import { prisma } from '@/lib/prisma';

// MySQL-backed fixed-window rate limiter. Replaces the in-memory Map that
// used to live in middleware.js (Edge middleware can't talk to MySQL, and
// in-memory counts reset whenever Passenger restarts the app).
//
// Fails OPEN on database errors, so a DB hiccup never takes the site down.
export async function rateLimit(key, max, windowMs) {
  const now = new Date();
  try {
    const row = await prisma.rateLimit.findUnique({ where: { key } });
    if (!row || row.reset_at <= now) {
      await prisma.rateLimit.upsert({
        where: { key },
        create: { key, count: 1, reset_at: new Date(now.getTime() + windowMs) },
        update: { count: 1, reset_at: new Date(now.getTime() + windowMs) },
      });
      return { limited: false };
    }
    const updated = await prisma.rateLimit.update({
      where: { key },
      data: { count: { increment: 1 } },
    });
    if (updated.count > max) {
      return {
        limited: true,
        retryAfterSeconds: Math.max(1, Math.ceil((row.reset_at.getTime() - now.getTime()) / 1000)),
      };
    }
    return { limited: false };
  } catch (err) {
    console.error('[rateLimit] failed open:', err?.message);
    return { limited: false };
  }
}

export function getClientIp(request) {
  const forwardedFor = request.headers.get('x-forwarded-for');
  if (forwardedFor) return forwardedFor.split(',')[0].trim();
  return request.headers.get('x-real-ip') || 'unknown';
}

// Convenience for route handlers: returns a 429 Response, or null if allowed.
export async function enforceRateLimit(request, name, max, windowMs) {
  const { limited, retryAfterSeconds } = await rateLimit(
    `${name}:${getClientIp(request)}`,
    max,
    windowMs
  );
  if (!limited) return null;
  return Response.json(
    { success: false, message: 'Too many attempts. Please wait a bit before trying again.' },
    { status: 429, headers: { 'Retry-After': String(retryAfterSeconds) } }
  );
}

// Housekeeping, called from the daily cron.
export async function purgeExpiredRateLimits() {
  const { count } = await prisma.rateLimit.deleteMany({ where: { reset_at: { lt: new Date() } } });
  return count;
}
