import crypto from 'crypto';
import { NextResponse } from 'next/server';
import { prisma } from '@/lib/prisma';
import { enforceRateLimit, getClientIp } from '@/lib/rateLimit';
import {
  buildCatalogText,
  buildSystemPrompt,
  createHandoff,
  CRISIS_REPLY,
  detectCrisis,
  detectIntent,
  extractPhone,
  generateReply,
  HANDOFF_REPLY,
} from '@/lib/counselor';

const MAX_MESSAGE_LENGTH = 600;
const HISTORY_LIMIT = 10;
const FALLBACK_REPLY =
  "Sorry, I'm having trouble replying right now. Please try again in a moment, or use the Contact page to reach our team.";

// POST /api/chatbot  { message, sessionToken? }  ->  { reply, sessionToken, handoff }
//
// Conversation history is read from MySQL by sessionToken, never from the
// request body, so a caller can't inject fake "assistant" turns. Both the web
// chat widget and the mobile app use this same endpoint.
export async function POST(request) {
  const limited = await enforceRateLimit(request, 'chatbot', 20, 60 * 1000);
  if (limited) return limited;

  try {
    const body = await request.json();
    const message = typeof body?.message === 'string' ? body.message.trim() : '';
    if (!message) {
      return NextResponse.json({ success: false, message: 'Message is required.' }, { status: 400 });
    }
    if (message.length > MAX_MESSAGE_LENGTH) {
      return NextResponse.json(
        { success: false, message: `Please keep messages under ${MAX_MESSAGE_LENGTH} characters.` },
        { status: 400 }
      );
    }

    const channel = body?.channel === 'app' ? 'app' : 'web';
    const suppliedToken = typeof body?.sessionToken === 'string' ? body.sessionToken : null;

    let session = suppliedToken
      ? await prisma.chatSession.findUnique({ where: { token: suppliedToken } })
      : null;
    if (!session) {
      session = await prisma.chatSession.create({
        data: { token: crypto.randomBytes(24).toString('hex'), channel, ip: getClientIp(request) },
      });
    }

    await prisma.chatMessage.create({
      data: { session_id: session.id, role: 'user', content: message },
    });

    const save = (content) =>
      prisma.chatMessage.create({ data: { session_id: session.id, role: 'assistant', content } });

    // --- Safety first: self-harm wording gets a fixed reply, never the model.
    if (detectCrisis(message)) {
      await save(CRISIS_REPLY);
      return NextResponse.json({ success: true, reply: CRISIS_REPLY, sessionToken: session.token, handoff: false });
    }

    // --- Human handoff: discount and "I want to join" never reach the model.
    const intent = detectIntent(message);
    if (intent) {
      await createHandoff(session.id, intent, message);
      const reply = HANDOFF_REPLY[intent];
      await save(reply);
      return NextResponse.json({ success: true, reply, sessionToken: session.token, handoff: true });
    }

    // --- Contact details sent after a handoff: attach to the open handoff.
    const phone = extractPhone(message);
    if (phone) {
      const open = await prisma.handoff.findFirst({
        where: { session_id: session.id, status: 'new' },
        orderBy: { id: 'desc' },
      });
      if (open) {
        const name = message.replace(/[\d+\-\s]{8,}/g, ' ').replace(/[^\p{L}\s.'-]/gu, ' ').trim().slice(0, 100);
        await prisma.handoff.update({
          where: { id: open.id },
          data: { phone, name: name || open.name },
        });
        const reply = HANDOFF_REPLY.phone_saved;
        await save(reply);
        return NextResponse.json({ success: true, reply, sessionToken: session.token, handoff: true });
      }
    }

    // --- Normal question: answer from the live catalog.
    const rows = await prisma.chatMessage.findMany({
      where: { session_id: session.id },
      orderBy: { id: 'desc' },
      take: HISTORY_LIMIT,
    });
    const history = rows.reverse().map((r) => ({ role: r.role, content: r.content }));

    let reply;
    try {
      const system = buildSystemPrompt(await buildCatalogText());
      reply = await generateReply(system, history);
    } catch (err) {
      console.error('[chatbot] model call failed:', err?.message);
      reply = '';
    }
    if (!reply) {
      await save(FALLBACK_REPLY);
      return NextResponse.json(
        { success: false, reply: FALLBACK_REPLY, sessionToken: session.token },
        { status: 502 }
      );
    }

    await save(reply);
    return NextResponse.json({ success: true, reply, sessionToken: session.token, handoff: false });
  } catch (err) {
    console.error('[chatbot] error:', err);
    return NextResponse.json({ success: false, message: 'Something went wrong.' }, { status: 500 });
  }
}
