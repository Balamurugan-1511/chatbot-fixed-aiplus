import { NextResponse } from 'next/server';
import { prisma } from '@/lib/prisma';
import { requireAdmin } from '@/lib/adminAuth';

const STATUSES = ['new', 'contacted', 'closed'];

export async function PATCH(request, { params }) {
  if (!(await requireAdmin())) {
    return NextResponse.json({ success: false, message: 'Admin login required.' }, { status: 401 });
  }
  const { id } = await params;
  try {
    const { status, counselor_id } = await request.json();
    const data = {};
    if (status !== undefined) {
      if (!STATUSES.includes(status)) {
        return NextResponse.json({ success: false, message: 'Invalid status.' }, { status: 400 });
      }
      data.status = status;
    }
    if (counselor_id !== undefined) data.counselor_id = counselor_id ? Number(counselor_id) : null;
    const handoff = await prisma.handoff.update({ where: { id: Number(id) }, data });
    return NextResponse.json({ success: true, handoff });
  } catch (error) {
    console.error(error);
    return NextResponse.json({ success: false, message: 'Something went wrong.' }, { status: 500 });
  }
}
