'use client';

import React, { useEffect, useState } from 'react';

const EMPTY = { course_id: '', start_date: '', mode: 'online', timing: '', seats_left: '', status: 'upcoming', note: '' };
const input = 'w-full text-sm font-body px-3 py-2 rounded-lg border border-gray-200 focus:outline-none focus:border-accentBlue';

export default function AdminBatchesPage() {
  const [batches, setBatches] = useState([]);
  const [courses, setCourses] = useState([]);
  const [form, setForm] = useState(EMPTY);
  const [message, setMessage] = useState('');

  const load = async () => {
    const [b, c] = await Promise.all([
      fetch('/api/admin/batches').then((r) => r.json()),
      fetch('/api/courses').then((r) => r.json()),
    ]);
    if (b?.success) setBatches(b.batches);
    const list = c?.courses || c?.data || [];
    setCourses(Array.isArray(list) ? list : []);
  };

  useEffect(() => {
    load();
  }, []);

  const set = (k) => (e) => setForm((f) => ({ ...f, [k]: e.target.value }));

  const add = async (e) => {
    e.preventDefault();
    setMessage('');
    const res = await fetch('/api/admin/batches', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(form),
    });
    const data = await res.json();
    if (data?.success) {
      setForm(EMPTY);
      load();
    } else {
      setMessage(data?.message || 'Could not add batch.');
    }
  };

  const update = async (id, patch) => {
    await fetch(`/api/admin/batches/${id}`, {
      method: 'PATCH',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(patch),
    });
    load();
  };

  const remove = async (id) => {
    if (!confirm('Delete this batch?')) return;
    await fetch(`/api/admin/batches/${id}`, { method: 'DELETE' });
    load();
  };

  return (
    <div>
      <h1 className="font-heading font-bold text-navy text-xl mb-1">Batches</h1>
      <p className="text-sm text-bodyText mb-6">
        The chatbot reads these for &quot;next batch&quot; answers. Cancelled and past batches are ignored.
      </p>

      <form onSubmit={add} className="bg-white rounded-xl p-5 shadow-card mb-8 grid gap-3 sm:grid-cols-3">
        <select className={input} value={form.course_id} onChange={set('course_id')} required>
          <option value="">Course…</option>
          {courses.map((c) => (
            <option key={c.id} value={c.id}>
              {c.title}
            </option>
          ))}
        </select>
        <input className={input} type="date" value={form.start_date} onChange={set('start_date')} required />
        <select className={input} value={form.mode} onChange={set('mode')}>
          <option value="online">Online</option>
          <option value="offline">Offline</option>
          <option value="hybrid">Hybrid</option>
        </select>
        <input className={input} placeholder="Timing (e.g. 7-9 PM)" value={form.timing} onChange={set('timing')} />
        <input className={input} type="number" min="0" placeholder="Seats left" value={form.seats_left} onChange={set('seats_left')} />
        <input className={input} placeholder="Note (optional)" value={form.note} onChange={set('note')} />
        <div className="sm:col-span-3 flex items-center gap-3">
          <button type="submit" className="px-4 py-2 rounded-lg bg-accentBlue text-white text-sm font-medium hover:bg-navy">
            Add batch
          </button>
          {message && <span className="text-sm text-red-600">{message}</span>}
        </div>
      </form>

      <div className="bg-white rounded-xl shadow-card overflow-x-auto">
        <table className="w-full text-sm text-left">
          <thead className="bg-gray-50 text-bodyText">
            <tr>
              <th className="px-4 py-3">Course</th>
              <th className="px-4 py-3">Start</th>
              <th className="px-4 py-3">Mode</th>
              <th className="px-4 py-3">Timing</th>
              <th className="px-4 py-3">Seats</th>
              <th className="px-4 py-3">Status</th>
              <th className="px-4 py-3" />
            </tr>
          </thead>
          <tbody>
            {batches.map((b) => (
              <tr key={b.id} className="border-t border-gray-100">
                <td className="px-4 py-3">{b.course?.title}</td>
                <td className="px-4 py-3 whitespace-nowrap">{new Date(b.start_date).toLocaleDateString('en-IN')}</td>
                <td className="px-4 py-3">{b.mode}</td>
                <td className="px-4 py-3">{b.timing || '-'}</td>
                <td className="px-4 py-3">{b.seats_left ?? '-'}</td>
                <td className="px-4 py-3">
                  <select
                    className="text-sm border border-gray-200 rounded px-2 py-1"
                    value={b.status}
                    onChange={(e) => update(b.id, { status: e.target.value })}
                  >
                    <option value="upcoming">upcoming</option>
                    <option value="full">full</option>
                    <option value="cancelled">cancelled</option>
                  </select>
                </td>
                <td className="px-4 py-3">
                  <button onClick={() => remove(b.id)} className="text-red-600 hover:underline">
                    Delete
                  </button>
                </td>
              </tr>
            ))}
            {!batches.length && (
              <tr>
                <td colSpan={7} className="px-4 py-6 text-center text-bodyText">
                  No batches yet.
                </td>
              </tr>
            )}
          </tbody>
        </table>
      </div>
    </div>
  );
}
