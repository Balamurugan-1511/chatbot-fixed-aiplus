'use client';

import React, { useEffect, useState } from 'react';

const REASONS = { discount: 'Asked for discount', join: 'Wants to join / talk to counselor' };

export default function AdminHandoffsPage() {
  const [handoffs, setHandoffs] = useState([]);
  const [counselors, setCounselors] = useState([]);
  const [open, setOpen] = useState(null);

  const load = async () => {
    const [h, c] = await Promise.all([
      fetch('/api/admin/handoffs').then((r) => r.json()),
      fetch('/api/admin/counselors').then((r) => r.json()),
    ]);
    if (h?.success) setHandoffs(h.handoffs);
    if (c?.success) setCounselors(c.counselors);
  };

  useEffect(() => {
    load();
  }, []);

  const update = async (id, patch) => {
    await fetch(`/api/admin/handoffs/${id}`, {
      method: 'PATCH',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(patch),
    });
    load();
  };

  return (
    <div>
      <h1 className="font-heading font-bold text-navy text-xl mb-1">Chat Handoffs</h1>
      <p className="text-sm text-bodyText mb-6">
        Chats the bot passed to a counselor: discount requests and people who want to join.
      </p>

      <div className="space-y-3">
        {handoffs.map((h) => (
          <div key={h.id} className="bg-white rounded-xl p-4 shadow-card">
            <div className="flex flex-wrap items-center gap-3 text-sm">
              <span className="font-semibold text-navy">{REASONS[h.reason] || h.reason}</span>
              <span className="text-bodyText">{new Date(h.created_at).toLocaleString('en-IN')}</span>
              <span className="text-bodyText">via {h.session?.channel}</span>
              <span className="text-bodyText">
                {h.name ? `${h.name} ` : ''}
                {h.phone ? `· ${h.phone}` : '· no phone yet'}
              </span>
              <select
                className="ml-auto border border-gray-200 rounded px-2 py-1"
                value={h.counselor_id || ''}
                onChange={(e) => update(h.id, { counselor_id: e.target.value })}
              >
                <option value="">Unassigned</option>
                {counselors.map((c) => (
                  <option key={c.id} value={c.id}>
                    {c.name}
                  </option>
                ))}
              </select>
              <select
                className="border border-gray-200 rounded px-2 py-1"
                value={h.status}
                onChange={(e) => update(h.id, { status: e.target.value })}
              >
                <option value="new">new</option>
                <option value="contacted">contacted</option>
                <option value="closed">closed</option>
              </select>
              <button
                className="text-accentBlue hover:underline"
                onClick={() => setOpen(open === h.id ? null : h.id)}
              >
                {open === h.id ? 'Hide chat' : 'View chat'}
              </button>
            </div>
            {open === h.id && (
              <div className="mt-3 border-t border-gray-100 pt-3 space-y-2 text-sm">
                {h.session.messages.map((m, i) => (
                  <p key={i} className={m.role === 'user' ? 'text-darkText' : 'text-bodyText'}>
                    <span className="font-semibold">{m.role === 'user' ? 'Visitor' : 'Bot'}:</span> {m.content}
                  </p>
                ))}
              </div>
            )}
          </div>
        ))}
        {!handoffs.length && <p className="text-sm text-bodyText">No handoffs yet.</p>}
      </div>
    </div>
  );
}
