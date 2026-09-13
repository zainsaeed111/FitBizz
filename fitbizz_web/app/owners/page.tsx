"use client";

import React, { useState } from "react";
import Link from "next/link";

interface OwnerItem {
  id: string;
  name: string;
  email: string;
  phone: string;
  gymId: string;
  gymName: string;
  branches: number;
  planName: string;
  status: "15-Day Trial" | "Paid Subscription" | "Suspended";
  city: string;
  lastLogin: string;
  createdDate: string;
}

export default function OwnersDirectoryPage() {
  const [toast, setToast] = useState<{ title: string; message: string; type: "success" | "info" | "warning" } | null>(null);

  const showToast = (title: string, message: string, type: "success" | "info" | "warning" = "success") => {
    setToast({ title, message, type });
    setTimeout(() => setToast(null), 3800);
  };

  const [owners] = useState<OwnerItem[]>([
    {
      id: "own-1",
      name: "Kamran Ahmed",
      email: "owner@metrofitness.com",
      phone: "+92 300 1234567",
      gymId: "tenant-001",
      gymName: "Metro Fitness Club",
      branches: 2,
      planName: "Pro Multi-Branch Plan",
      status: "15-Day Trial",
      city: "Lahore",
      lastLogin: "2026-09-13 14:22",
      createdDate: "Sep 12, 2026",
    },
  ]);

  const [search, setSearch] = useState("");

  const sendWhatsApp = (owner: OwnerItem) => {
    const cleanPhone = owner.phone.replace(/[^0-9]/g, "");
    const msg = encodeURIComponent(
      `Hello ${owner.name},\nThis is FitBizz Super Admin HQ. Your Gym Workspace for ${owner.gymName} is fully active.`
    );
    window.open(`https://wa.me/${cleanPhone}?text=${msg}`, "_blank");
    showToast("Opening WhatsApp", `Launched chat with ${owner.name}`);
  };

  const sendEmail = (owner: OwnerItem) => {
    const subject = encodeURIComponent(`FitBizz Master HQ Notification - ${owner.gymName}`);
    const body = encodeURIComponent(
      `Dear ${owner.name},\n\nYour tenant workspace for ${owner.gymName} is configured and running on FitBizz Platform.`
    );
    window.open(`mailto:${owner.email}?subject=${subject}&body=${body}`, "_blank");
    showToast("Opening Email Client", `Prepared message to ${owner.email}`);
  };

  const filteredOwners = owners.filter(
    (o) =>
      o.name.toLowerCase().includes(search.toLowerCase()) ||
      o.email.toLowerCase().includes(search.toLowerCase()) ||
      o.gymName.toLowerCase().includes(search.toLowerCase()) ||
      o.city.toLowerCase().includes(search.toLowerCase())
  );

  return (
    <div className="space-y-6">
      {/* Toast Notification */}
      {toast && (
        <div
          className={`fixed top-5 right-5 z-50 p-4 rounded-xl border shadow-xl flex items-center gap-3 transition-all duration-300 animate-in fade-in slide-in-from-top-4 ${
            toast.type === "success"
              ? "bg-white border-orange-200 text-stone-900 ring-2 ring-orange-500/20"
              : toast.type === "warning"
              ? "bg-amber-50 border-amber-300 text-amber-950 ring-2 ring-amber-500/20"
              : "bg-stone-900 border-stone-800 text-white"
          }`}
        >
          <div
            className={`w-8 h-8 rounded-lg flex items-center justify-center font-bold text-sm shrink-0 ${
              toast.type === "success" ? "bg-orange-600 text-white" : "bg-amber-500 text-white"
            }`}
          >
            ✓
          </div>
          <div>
            <p className="font-bold text-xs">{toast.title}</p>
            <p className="text-[11px] text-stone-600 font-medium">{toast.message}</p>
          </div>
          <button onClick={() => setToast(null)} className="text-stone-400 hover:text-stone-700 font-bold ml-2 text-sm">
            ✕
          </button>
        </div>
      )}

      {/* Header */}
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4 pb-4 border-b border-stone-200">
        <div>
          <h1 className="text-xl font-bold text-stone-900 tracking-tight">Platform Gym Owners Directory</h1>
          <p className="text-xs text-stone-500 mt-0.5">
            Centralized directory of business owners with tenant administration privileges
          </p>
        </div>
        <div className="flex items-center gap-2">
          <Link
            href="/gyms/tenant-001"
            className="fb-button-secondary text-xs flex items-center gap-1.5 border-orange-500 text-orange-600"
          >
            <span>🏢</span>
            <span>Open Owner Portal</span>
          </Link>
        </div>
      </div>

      {/* Search Toolbar */}
      <div className="fb-panel p-4 flex flex-col md:flex-row items-stretch md:items-center gap-3 justify-between bg-white border border-stone-200 rounded-xl shadow-xs">
        <div className="relative w-full sm:w-80">
          <svg
            className="w-4 h-4 absolute left-3 top-1/2 -translate-y-1/2 text-stone-400"
            fill="none"
            viewBox="0 0 24 24"
            stroke="currentColor"
          >
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
          </svg>
          <input
            type="text"
            placeholder="Search owners by name, email, or gym..."
            value={search}
            onChange={(e) => setSearch(e.target.value)}
            className="fb-input w-full pl-9 text-xs"
          />
        </div>
        <div className="text-xs text-stone-500 font-semibold">
          Total Platform Owners: <span className="text-orange-600 font-bold">{filteredOwners.length}</span>
        </div>
      </div>

      {/* Owners Table */}
      <div className="fb-panel overflow-hidden border border-stone-200 bg-white rounded-xl shadow-xs">
        <div className="overflow-x-auto">
          <table className="w-full text-left border-collapse text-xs">
            <thead>
              <tr className="bg-stone-50 border-b border-stone-200 text-stone-600 font-bold uppercase tracking-wider text-[10px]">
                <th className="p-3.5">Owner Details</th>
                <th className="p-3.5">Associated Gym Tenant</th>
                <th className="p-3.5">Contact Channels</th>
                <th className="p-3.5">Branches</th>
                <th className="p-3.5">Status</th>
                <th className="p-3.5">Last Active</th>
                <th className="p-3.5 text-right">Actions</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-stone-100">
              {filteredOwners.map((owner) => (
                <tr key={owner.id} className="hover:bg-orange-50/40 transition">
                  <td className="p-3.5">
                    <div className="flex items-center gap-3">
                      <div className="w-8 h-8 rounded-full bg-orange-600 flex items-center justify-center font-bold text-white text-xs shrink-0">
                        {owner.name.substring(0, 2).toUpperCase()}
                      </div>
                      <div>
                        <span className="font-bold text-stone-900 block text-sm">{owner.name}</span>
                        <span className="text-[11px] text-stone-400 font-mono">ID: {owner.id}</span>
                      </div>
                    </div>
                  </td>
                  <td className="p-3.5">
                    <Link href={`/gyms/${owner.gymId}`} className="text-orange-600 hover:underline font-bold text-xs">
                      {owner.gymName}
                    </Link>
                    <span className="text-[10px] text-stone-400 block">{owner.city}, Pakistan</span>
                  </td>
                  <td className="p-3.5">
                    <div>
                      <p className="text-stone-800 font-medium">{owner.email}</p>
                      <p className="text-[11px] text-stone-400 font-mono">{owner.phone}</p>
                    </div>
                  </td>
                  <td className="p-3.5">
                    <span className="inline-flex items-center px-2 py-0.5 rounded-md bg-stone-100 font-bold text-stone-700">
                      {owner.branches} Branches
                    </span>
                  </td>
                  <td className="p-3.5">
                    <span className="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full text-[11px] font-bold bg-amber-50 text-amber-700 border border-amber-200">
                      <span className="w-1.5 h-1.5 rounded-full bg-amber-500"></span>
                      {owner.status}
                    </span>
                  </td>
                  <td className="p-3.5">
                    <span className="text-stone-500 font-mono text-[11px]">{owner.lastLogin}</span>
                  </td>
                  <td className="p-3.5 text-right">
                    <div className="flex items-center justify-end gap-1.5">
                      <button
                        onClick={() => sendWhatsApp(owner)}
                        className="px-2.5 py-1 rounded-lg bg-emerald-50 text-emerald-700 border border-emerald-200 hover:bg-emerald-100 font-bold text-[11px] transition flex items-center gap-1"
                        title="Direct WhatsApp"
                      >
                        <span>💬</span> WhatsApp
                      </button>
                      <button
                        onClick={() => sendEmail(owner)}
                        className="px-2.5 py-1 rounded-lg bg-orange-50 text-orange-700 border border-orange-200 hover:bg-orange-100 font-bold text-[11px] transition flex items-center gap-1"
                        title="Send Email"
                      >
                        <span>✉️</span> Email
                      </button>
                      <Link
                        href={`/gyms/${owner.gymId}`}
                        className="px-3 py-1 rounded-lg bg-orange-600 hover:bg-orange-700 text-white font-bold transition text-[11px] shadow-xs"
                      >
                        Manage 🏢
                      </Link>
                    </div>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
}
