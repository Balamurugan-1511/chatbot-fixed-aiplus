import { NextResponse } from 'next/server';
import { prisma } from '@/lib/prisma';
import { requireAdmin } from '@/lib/adminAuth';

export async function GET() {
  if (!(await requireAdmin())) {
    return NextResponse.json({ success: false, message: 'Admin login required.' }, { status: 401 });
  }
  const counselors = await prisma.counselor.findMany({ orderBy: { name: 'asc' } });
  return NextResponse.json({ success: true, counselors });
}
