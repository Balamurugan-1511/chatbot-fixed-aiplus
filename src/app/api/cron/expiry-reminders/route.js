import { NextResponse } from 'next/server';
import { prisma } from '@/lib/prisma';
import { sendMail } from '@/lib/mailer';
import { escapeHtml } from '@/lib/escapeHtml';
import { purgeExpiredRateLimits } from '@/lib/rateLimit';

const SITE_URL = process.env.NEXT_PUBLIC_SITE_URL || 'http://localhost:3000';
const SUPPORT_EMAIL = process.env.SUPPORT_EMAIL || 'skandaplus2025@gmail.com';
const PLATFORM_NAME = process.env.PLATFORM_NAME || 'AI Plus';

// GET /api/cron/expiry-reminders — meant to be hit on a daily schedule
// (a cPanel Cron Job, see DEPLOY.md), not by a person or the admin UI. It does one thing:
// email students whose course access expires in ~7 days, so they get a
// heads-up before they lose access.
//
// This is intentionally its own route, separate from the enrollments PATCH
// handler — nothing here touches payment_status, amount_paid, or any
// existing enrollment field except the new `reminder_sent_at` guard, so it
// can't interfere with the admin payment-verification flow.
//
// Required env var: CRON_SECRET (a long random string). The cPanel cron job
// calls this route with `Authorization: Bearer <CRON_SECRET>`.

const REMINDER_WINDOW_DAYS = 7;

export async function GET(request) {
  // Fails closed: without CRON_SECRET configured, nobody can run this.
  const configuredSecret = process.env.CRON_SECRET;
  const authHeader = request.headers.get('authorization');
  if (!configuredSecret || authHeader !== `Bearer ${configuredSecret}`) {
    return NextResponse.json({ success: false, message: 'Unauthorized.' }, { status: 401 });
  }

  try {
    const now = new Date();
    const windowStart = new Date(now);
    windowStart.setDate(windowStart.getDate() + REMINDER_WINDOW_DAYS);
    windowStart.setHours(0, 0, 0, 0);

    const windowEnd = new Date(windowStart);
    windowEnd.setHours(23, 59, 59, 999);

    // Only "ongoing" enrollments, only ones expiring inside tomorrow's
    // 7-day-out window, and only ones that haven't already had a reminder
    // sent — this last check is what stops the same student getting the
    // same email every day until it actually expires.
    const dueForReminder = await prisma.enrollment.findMany({
      where: {
        status: 'ongoing',
        expires_at: { gte: windowStart, lte: windowEnd },
        reminder_sent_at: null,
      },
      include: {
        user: { select: { name: true, email: true } },
        course: { select: { title: true, slug: true } },
      },
    });

    let sent = 0;
    let failed = 0;

    for (const enrollment of dueForReminder) {
      const email = enrollment.user?.email;
      if (!email) continue;

      const studentName = escapeHtml(enrollment.user?.name || 'there');
      const rawCourseTitle = enrollment.course?.title || 'your course';
      const courseTitle = escapeHtml(rawCourseTitle);
      const expiresLabel = new Date(enrollment.expires_at).toLocaleDateString('en-IN', {
        day: 'numeric',
        month: 'short',
        year: 'numeric',
      });
      const courseLink = enrollment.course?.slug ? `${SITE_URL}/courses/${enrollment.course.slug}` : SITE_URL;

      const result = await sendMail({
        to: email,
        subject: `Your access to ${rawCourseTitle} expires in 7 days`,
        html: `
          <div style="font-family:Arial,Helvetica,sans-serif;max-width:560px;margin:0 auto;color:#1a1a1a;">
            <h2 style="margin:0 0 12px;font-size:20px;color:#111;">Your course access is ending soon</h2>
            <p style="font-size:14px;line-height:1.6;">Dear ${studentName},</p>
            <p style="font-size:14px;line-height:1.6;">
              This is a reminder from ${PLATFORM_NAME} that your access to <strong>${courseTitle}</strong> is set to expire on <strong>${expiresLabel}</strong>.
            </p>
            <p style="font-size:14px;line-height:1.6;">
              To make the most of your remaining time, we encourage you to complete any pending lessons before access ends. If you'd like to extend your access, please get in touch with our support team.
            </p>
            <p style="text-align:center;margin:24px 0;">
              <a href="${courseLink}" style="background:#0f172a;color:#fff;padding:10px 22px;border-radius:6px;text-decoration:none;font-size:14px;font-weight:600;display:inline-block;">
                Continue Learning
              </a>
            </p>
            <p style="font-size:14px;line-height:1.6;">
              Thank you for learning with ${PLATFORM_NAME}.
            </p>
            <p style="font-size:14px;line-height:1.6;margin-top:20px;">
              Best regards,<br/>
              ${PLATFORM_NAME} Team
            </p>
            <p style="margin-top:24px;font-size:12px;color:#666;line-height:1.6;">
              Need help? Contact us at <a href="mailto:${SUPPORT_EMAIL}" style="color:#666;">${SUPPORT_EMAIL}</a><br/>
              <a href="${SITE_URL}" style="color:#666;">${SITE_URL}</a>
            </p>
          </div>
        `,
      });

      if (result.sent) {
        sent += 1;
      } else {
        failed += 1;
      }

      // Mark as reminded regardless of send success/failure so a persistent
      // mail-provider outage can't cause this loop to retry the same
      // enrollment forever on every future run. Failures are still visible
      // in the response/logs below.
      await prisma.enrollment.update({
        where: { id: enrollment.id },
        data: { reminder_sent_at: now },
      });
    }

    const purged = await purgeExpiredRateLimits().catch(() => 0);

    return NextResponse.json({
      success: true,
      purged,
      checked: dueForReminder.length,
      sent,
      failed,
    });
  } catch (error) {
    console.error('[cron/expiry-reminders] failed:', error);
    return NextResponse.json({ success: false, message: 'Something went wrong.' }, { status: 500 });
  }
}
