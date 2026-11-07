import { prisma } from '@/lib/prisma';

// Failed-login tracking per account email, stored in MySQL (it used to be an
// in-memory Map that reset on every restart and wasn't shared between
// processes).
//   1. Progressive backoff: each consecutive failure delays the next try.
//   2. Hard lockout: MAX_ATTEMPTS consecutive failures lock the account.
// Callers must return the same generic error for every blocked case.

const MAX_ATTEMPTS = 5;
const LOCKOUT_DURATION_MS = 15 * 60 * 1000;
const BACKOFF_BASE_MS = 1000;
const BACKOFF_CAP_MS = 16000;

export async function checkBeforeAttempt(email) {
  try {
    const state = await prisma.loginAttempt.findUnique({ where: { email } });
    if (!state) return { blocked: false };
    const now = Date.now();
    if (state.locked_until && now < state.locked_until.getTime()) {
      return { blocked: true, reason: 'locked', retryAfterMs: state.locked_until.getTime() - now };
    }
    if (state.next_attempt_at && now < state.next_attempt_at.getTime()) {
      return { blocked: true, reason: 'backoff', retryAfterMs: state.next_attempt_at.getTime() - now };
    }
  } catch (err) {
    console.error('[loginAttempts] check failed open:', err?.message);
  }
  return { blocked: false };
}

// Call after ANY failed attempt, including for emails with no account, so
// lockout behaviour can't be used to tell valid emails from invalid ones.
// Returns { justLocked } true only on the attempt that crosses the threshold.
export async function recordFailure(email) {
  try {
    const now = Date.now();
    const state = await prisma.loginAttempt.findUnique({ where: { email } });
    const failCount = (state?.fail_count || 0) + 1;
    const wasLocked = state?.locked_until && now < state.locked_until.getTime();

    let lockedUntil = state?.locked_until || null;
    let nextAttemptAt;
    let justLocked = false;

    if (failCount >= MAX_ATTEMPTS) {
      justLocked = !wasLocked;
      lockedUntil = new Date(now + LOCKOUT_DURATION_MS);
      nextAttemptAt = lockedUntil;
    } else {
      nextAttemptAt = new Date(
        now + Math.min(BACKOFF_BASE_MS * 2 ** (failCount - 1), BACKOFF_CAP_MS)
      );
    }

    await prisma.loginAttempt.upsert({
      where: { email },
      create: { email, fail_count: failCount, locked_until: lockedUntil, next_attempt_at: nextAttemptAt },
      update: { fail_count: failCount, locked_until: lockedUntil, next_attempt_at: nextAttemptAt },
    });
    return { justLocked };
  } catch (err) {
    console.error('[loginAttempts] record failed:', err?.message);
    return { justLocked: false };
  }
}

export async function recordSuccess(email) {
  try {
    await prisma.loginAttempt.deleteMany({ where: { email } });
  } catch (err) {
    console.error('[loginAttempts] clear failed:', err?.message);
  }
}
