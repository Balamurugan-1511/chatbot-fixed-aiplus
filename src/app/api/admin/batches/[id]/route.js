import { NextResponse } from 'next/server';
import { prisma } from '@/lib/prisma';
import { requireAdmin } from '@/lib/adminAuth';

const deny = () => NextResponse.json({ success: false, message: 'Admin login required.' }, { status: 401 });

export async function PATCH(request, { params }) {
  if (!(await requireAdmin())) return deny();
  const { id } = await params;
  try {
    const b = await request.json();
    const data = {};
    if (b.start_date) {
      if (Number.isNaN(new Date(b.start_date).getTime())) {
        return NextResponse.json({ success: false, message: 'Invalid start date.' }, { status: 400 });
      }
      data.start_date = new Date(b.start_date);
    }
    for (const k of ['mode', 'timing', 'status', 'note']) if (k in b) data[k] = b[k] || null;
    if ('seats_left' in b) data.seats_left = b.seats_left === '' || b.seats_left == null ? null : Number(b.seats_left);
    const batch = await prisma.batch.update({ where: { id: Number(id) }, data });
    return NextResponse.json({ success: true, batch });
  } catch (error) {
    console.error(error);
    return NextResponse.json({ success: false, message: 'Something went wrong.' }, { status: 500 });
  }
}

export async function DELETE(_request, { params }) {
  if (!(await requireAdmin())) return deny();
  const { id } = await params;
  try {
    await prisma.batch.delete({ where: { id: Number(id) } });
    return NextResponse.json({ success: true });
  } catch (error) {
    console.error(error);
    return NextResponse.json({ success: false, message: 'Something went wrong.' }, { status: 500 });
  }
}
