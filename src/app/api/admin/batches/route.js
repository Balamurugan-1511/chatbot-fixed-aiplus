import { NextResponse } from 'next/server';
import { prisma } from '@/lib/prisma';
import { requireAdmin } from '@/lib/adminAuth';

const deny = () => NextResponse.json({ success: false, message: 'Admin login required.' }, { status: 401 });

export async function GET() {
  if (!(await requireAdmin())) return deny();
  const batches = await prisma.batch.findMany({
    orderBy: { start_date: 'asc' },
    include: { course: { select: { id: true, title: true } } },
  });
  return NextResponse.json({ success: true, batches });
}

export async function POST(request) {
  if (!(await requireAdmin())) return deny();
  try {
    const { course_id, start_date, mode, timing, seats_left, status, note } = await request.json();
    if (!course_id || !start_date || Number.isNaN(new Date(start_date).getTime())) {
      return NextResponse.json(
        { success: false, message: 'Course and a valid start date are required.' },
        { status: 400 }
      );
    }
    const batch = await prisma.batch.create({
      data: {
        course_id: Number(course_id),
        start_date: new Date(start_date),
        mode: mode || 'online',
        timing: timing || null,
        seats_left: seats_left === '' || seats_left == null ? null : Number(seats_left),
        status: status || 'upcoming',
        note: note || null,
      },
    });
    return NextResponse.json({ success: true, batch });
  } catch (error) {
    console.error(error);
    return NextResponse.json({ success: false, message: 'Something went wrong.' }, { status: 500 });
  }
}
