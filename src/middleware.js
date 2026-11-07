import { NextResponse } from 'next/server';
import { jwtVerify } from 'jose';

const AUTH_COOKIE = 'skandaplus_session';

// Edge middleware can't use the jsonwebtoken package or MySQL, so it only
// does the cheap job: verify the session token with `jose` and guard admin
// pages and content-write APIs. Rate limiting lives in the route handlers
// now (see src/lib/rateLimit.js), backed by MySQL.
async function getRole(request) {
  let token = request.cookies.get(AUTH_COOKIE)?.value;
  // The mobile app sends a Bearer token instead of a cookie.
  if (!token) {
    const auth = request.headers.get('authorization') || '';
    if (auth.startsWith('Bearer ')) token = auth.slice(7).trim();
  }
  if (!token || !process.env.JWT_SECRET) return null;
  try {
    const secret = new TextEncoder().encode(process.env.JWT_SECRET);
    const { payload } = await jwtVerify(token, secret);
    return payload.role || null;
  } catch {
    return null;
  }
}

export async function middleware(request) {
  const { pathname } = request.nextUrl;
  const role = await getRole(request);

  if (pathname.startsWith('/admin')) {
    if (role !== 'admin') {
      const loginUrl = new URL('/login', request.url);
      loginUrl.searchParams.set('redirect', pathname);
      return NextResponse.redirect(loginUrl);
    }
    return NextResponse.next();
  }

  const isWriteMethod = ['POST', 'PUT', 'PATCH', 'DELETE'].includes(request.method);
  const isGuardedApi = pathname.startsWith('/api/courses') || pathname.startsWith('/api/jobs');
  if (isGuardedApi && isWriteMethod && role !== 'admin') {
    return NextResponse.json({ success: false, message: 'Admin login required.' }, { status: 401 });
  }

  return NextResponse.next();
}

export const config = {
  matcher: ['/admin/:path*', '/api/courses/:path*', '/api/jobs/:path*'],
};
