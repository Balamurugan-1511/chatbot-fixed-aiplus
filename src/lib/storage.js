import fs from 'fs/promises';
import path from 'path';

// Local-disk file storage (replaces Supabase Storage so everything runs on
// plain cPanel hosting).
//
// UPLOAD_DIR   absolute folder for uploaded files. Put it OUTSIDE the app
//              folder (e.g. /home/cpuser/skandaplus-uploads) so a redeploy
//              never wipes it. Defaults to ./uploads for local dev.
// Files are served back through the /uploads/[...path] route.

export function getUploadRoot() {
  return path.resolve(process.env.UPLOAD_DIR || path.join(process.cwd(), 'uploads'));
}

const SAFE_SEGMENT = /^[A-Za-z0-9._-]+$/;

// Resolves bucket + file path to an absolute path, refusing anything that
// could escape the upload root (.., absolute paths, odd characters).
export function resolveUploadPath(bucket, filePath) {
  const parts = [bucket, ...String(filePath).split('/')].filter(Boolean);
  if (!parts.length || parts.some((p) => p === '.' || p === '..' || !SAFE_SEGMENT.test(p))) {
    throw new Error('Invalid upload path.');
  }
  const root = getUploadRoot();
  const full = path.resolve(root, ...parts);
  if (!full.startsWith(root + path.sep)) throw new Error('Invalid upload path.');
  return full;
}

// Same signature the old Supabase helper had: saves a Buffer into a bucket
// folder and returns the public URL.
function cleanSegment(seg) {
  return String(seg).replace(/[^A-Za-z0-9._-]/g, '_').replace(/^\.+/, '_').slice(0, 150);
}

export async function uploadToBucket(bucket, filePath, buffer) {
  const clean = String(filePath).split('/').filter(Boolean).map(cleanSegment);
  const full = resolveUploadPath(bucket, clean.join('/'));
  await fs.mkdir(path.dirname(full), { recursive: true });
  await fs.writeFile(full, buffer);
  return `/uploads/${[bucket, ...clean].join('/')}`;
}
