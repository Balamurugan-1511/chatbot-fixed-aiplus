import { NextResponse } from 'next/server';
import { prisma } from '@/lib/prisma';
import { requireAdmin } from '@/lib/adminAuth';

export async function GET() {
  if (!(await requireAdmin())) {
    return NextResponse.json({ success: false, message: 'Admin login required.' }, { status: 401 });
  }
  const handoffs = await prisma.handoff.findMany({
    orderBy: { created_at: 'desc' },
    take: 200,
    include: {
      counselor: { select: { id: true, name: true } },
      session: {
        select: {
          token: true,
          channel: true,
          messages: { orderBy: { id: 'asc' }, take: 30, select: { role: true, content: true } },
        },
      },
    },
  });
  // Never expose the session token to the browser, it is the chat's credential.
  const safe = handoffs.map((h) => ({ ...h, session: { channel: h.session.channel, messages: h.session.messages } }));
  return NextResponse.json({ success: true, handoffs: safe });
}
