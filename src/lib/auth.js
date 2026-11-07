import jwt from 'jsonwebtoken';

export const AUTH_COOKIE = 'skandaplus_session';

function getSecret() {
  const secret = process.env.JWT_SECRET;
  if (!secret || secret.length < 32) {
    // Fail loudly instead of signing tokens with an undefined/weak secret.
    throw new Error('JWT_SECRET must be set to a random string of at least 32 characters.');
  }
  return secret;
}

export function signToken(payload) {
  return jwt.sign(payload, getSecret(), { expiresIn: '7d' });
}

export function verifyToken(token) {
  try {
    return jwt.verify(token, getSecret());
  } catch {
    return null;
  }
}
