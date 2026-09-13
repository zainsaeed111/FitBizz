"use client";

import React, { useState, use } from "react";
import Link from "next/link";

interface GymDetailsProps {
  params: Promise<{ id: string }>;
}

export default function GymDetailsWorkspacePage({ params }: GymDetailsProps) {
  const { id } = use(params);
  const [activeTab, setActiveTab] = useState<"overview" | "branches" | "owner" | "subscription" | "features" | "activity">("overview");
  const [toast, setToast] = useState<{ title: string; message: string; type: "success" | "info" | "warning" } | null>(null);

  const showToast = (title: string, message: string, type: "success" | "info" | "warning" = "success") => {
    setToast({ title, message, type });
    setTimeout(() => setToast(null), 3800);
  };

  const gymInfo = {
    id: id || "tenant-001",
    name: "Metro Fitness Club",
    code: "METRO-LHE-01",
    status: "15-Day Trial",
    trialDays: 14,
    plan: "Pro Multi-Branch Plan",
    monthlyPrice: 35000,
    ownerName: "Kamran Ahmed",
    ownerEmail: "owner@metrofitness.com",
    ownerPhone: "+92 300 1234567",
    country: "Pakistan",
    city: "Lahore",
    createdDate: "Sep 12, 2026",
    branches: [
      { id: "b1", name: "Gulberg Main Arena (HQ)", address: "Main Boulevard, Block 4, Gulberg III", members: 280, status: "ACTIVE" },
      { id: "b2", name: "DHA Phase 5 Arena", address: "Sector CCA, DHA Phase 5", members: 170, status: "ACTIVE" },
    ],
    entitlements: [
      { key: "Members Directory & Attendance (QR)", enabled: true },
      { key: "Multi-Branch Centralized Sync", enabled: true },
      { key: "Trainer Login & Client Rosters", enabled: true },
      { key: "Customer Mobile Pass App", enabled: true },
      { key: "WhatsApp Automated Invoicing", enabled: true },
      { key: "Biometric Turnstiles Integration", enabled: true },
      { key: "AI Attendance & Churn Predictor", enabled: false },
      { key: "Dedicated PostgreSQL Server Cluster", enabled: false },
    ],
  };

  const formatCredentialsText = () => `🏋️ *FitBizz Gym Tenant Credentials & Welcome Pack*
━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🏢 *Gym Name:* ${gymInfo.name}
🆔 *Tenant ID:* ${gymInfo.id}
👤 *Owner Name:* ${gymInfo.ownerName}
📧 *Login Email:* ${gymInfo.ownerEmail}
📱 *Login Phone:* ${gymInfo.ownerPhone}
🔑 *Default Password:* password123

🌐 *Web Portal:* http://localhost:3000/login
💻 *Desktop Client:* FitBizz OS Windows v2.0
🏢 *Branches Enabled:* ${gymInfo.branches.length}
📦 *Subscription Tier:* ${gymInfo.plan}
⏳ *Status:* ${gymInfo.status} (${gymInfo.trialDays} Days Free Trial)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━`;

  const copyCredentials = () => {
    navigator.clipboard.writeText(formatCredentialsText());
    showToast("Credentials Copied", "Welcome pack copied to clipboard.");
  };

  const sendWhatsApp = () => {
    const cleanPhone = gymInfo.ownerPhone.replace(/[^0-9]/g, "");
    const msg = encodeURIComponent(formatCredentialsText());
    window.open(`https://wa.me/${cleanPhone}?text=${msg}`, "_blank");
    showToast("Opening WhatsApp", `Launched WhatsApp dispatch for ${gymInfo.ownerName}`);
  };

  return (
    <div className="space-y-6">
      {/* Toast */}
      {toast && (
        <div
          className={`fixed top-5 right-5 z-50 p-4 rounded-xl border shadow-xl flex items-center gap-3 transition-all duration-300 animate-in fade-in slide-in-from-top-4 ${
            toast.type === "success"
              ? "bg-white border-orange-200 text-stone-900 ring-2 ring-orange-500/20"
              : "bg-amber-50 border-amber-300 text-amber-950"
          }`}
        >
          <div className="w-8 h-8 rounded-lg bg-orange-600 text-white flex items-center justify-center font-bold text-sm shrink-0">
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

      {/* Header Banner */}
      <div className="fb-panel p-6 bg-white border border-stone-200 rounded-2xl shadow-xs">
        <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
          <div className="flex items-center gap-4">
            <div className="w-14 h-14 rounded-2xl border border-orange-200 bg-orange-50 p-1 flex items-center justify-center overflow-hidden shrink-0 shadow-sm text-orange-600 font-black text-xl">
              🏢
            </div>
            <div>
              <div className="flex items-center gap-3">
                <h1 className="text-xl font-black text-stone-900 tracking-tight">{gymInfo.name}</h1>
                <span className="px-2.5 py-0.5 rounded-full text-[11px] font-bold bg-amber-50 text-amber-700 border border-amber-200">
                  {gymInfo.status} ({gymInfo.trialDays}d remaining)
                </span>
                <span className="px-2.5 py-0.5 rounded-full text-[11px] font-bold bg-orange-100 text-orange-800">
                  {gymInfo.plan}
                </span>
              </div>
              <p className="text-xs text-stone-500 mt-1">
                ID: <span className="font-mono font-bold text-stone-700">{gymInfo.id}</span> • Location: {gymInfo.city}, {gymInfo.country} • Owner: <strong className="text-stone-800">{gymInfo.ownerName}</strong>
              </p>
            </div>
          </div>

          <div className="flex items-center gap-2">
            <button
              onClick={copyCredentials}
              className="fb-button-secondary text-xs flex items-center gap-1.5"
            >
              <span>📋</span>
              <span>Copy Credentials</span>
            </button>
            <button
              onClick={sendWhatsApp}
              className="px-3 py-2 rounded-xl bg-emerald-600 hover:bg-emerald-700 text-white font-bold text-xs flex items-center gap-1.5 shadow-xs transition"
            >
              <span>💬</span>
              <span>WhatsApp Pack</span>
            </button>
            <Link
              href="/"
              className="fb-button-primary text-xs flex items-center gap-1.5"
            >
              <span>←</span>
              <span>Back to Super Admin HQ</span>
            </Link>
          </div>
        </div>

        {/* Tab Bar Navigation */}
        <div className="flex items-center gap-2 border-t border-stone-200 mt-6 pt-4 text-xs font-semibold overflow-x-auto">
          {[
            { id: "overview", label: "Overview & Metrics" },
            { id: "branches", label: `Branches (${gymInfo.branches.length})` },
            { id: "owner", label: "Owner & Admin Access" },
            { id: "subscription", label: "Subscription & Invoices" },
            { id: "features", label: "Enabled Modules" },
          ].map((tab) => (
            <button
              key={tab.id}
              onClick={() => setActiveTab(tab.id as any)}
              className={`px-4 py-2 rounded-xl transition whitespace-nowrap ${
                activeTab === tab.id
                  ? "bg-orange-600 text-white font-bold shadow-xs"
                  : "text-stone-600 hover:text-stone-900 hover:bg-stone-100"
              }`}
            >
              {tab.label}
            </button>
          ))}
        </div>
      </div>

      {/* Tab Contents */}
      {activeTab === "overview" && (
        <div className="space-y-6">
          {/* Key Metrics */}
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
            <div className="fb-panel p-5 bg-white border border-stone-200 rounded-xl shadow-xs">
              <span className="text-xs font-bold text-stone-500 uppercase tracking-wider">Total Members</span>
              <p className="text-2xl font-black text-stone-900 mt-1">450</p>
              <span className="text-[11px] text-emerald-600 font-bold mt-2 block">+18 new this week</span>
            </div>
            <div className="fb-panel p-5 bg-white border border-stone-200 rounded-xl shadow-xs">
              <span className="text-xs font-bold text-stone-500 uppercase tracking-wider">Today Check-ins</span>
              <p className="text-2xl font-black text-stone-900 mt-1">128</p>
              <span className="text-[11px] text-orange-600 font-bold mt-2 block">QR & Biometrics Live</span>
            </div>
            <div className="fb-panel p-5 bg-white border border-stone-200 rounded-xl shadow-xs">
              <span className="text-xs font-bold text-stone-500 uppercase tracking-wider">Monthly SaaS Fee</span>
              <p className="text-2xl font-black text-orange-600 mt-1">Rs. 35,000</p>
              <span className="text-[11px] text-stone-500 font-medium mt-2 block">Renews in 14 days</span>
            </div>
            <div className="fb-panel p-5 bg-white border border-stone-200 rounded-xl shadow-xs">
              <span className="text-xs font-bold text-stone-500 uppercase tracking-wider">Sync Engine</span>
              <p className="text-2xl font-black text-emerald-600 mt-1">100% OK</p>
              <span className="text-[11px] text-stone-500 font-medium mt-2 block">SQLite ↔ PostgreSQL</span>
            </div>
          </div>

          {/* Branches Section */}
          <div className="fb-panel p-6 bg-white border border-stone-200 rounded-2xl shadow-xs space-y-4">
            <h3 className="text-sm font-bold text-stone-900">Configured Branch Facilities</h3>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              {gymInfo.branches.map((b) => (
                <div key={b.id} className="p-4 rounded-xl border border-stone-200 bg-stone-50/60 space-y-2">
                  <div className="flex items-center justify-between">
                    <span className="font-bold text-stone-900 text-sm">{b.name}</span>
                    <span className="px-2 py-0.5 rounded-md bg-emerald-100 text-emerald-800 text-[10px] font-bold">
                      {b.status}
                    </span>
                  </div>
                  <p className="text-xs text-stone-500">{b.address}</p>
                  <p className="text-xs font-semibold text-stone-700">Active Members: {b.members}</p>
                </div>
              ))}
            </div>
          </div>
        </div>
      )}

      {activeTab === "branches" && (
        <div className="fb-panel p-6 bg-white border border-stone-200 rounded-2xl shadow-xs space-y-4">
          <div className="flex items-center justify-between">
            <h3 className="text-sm font-bold text-stone-900">Multi-Branch Management ({gymInfo.branches.length} Branches)</h3>
          </div>
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            {gymInfo.branches.map((b) => (
              <div key={b.id} className="p-5 rounded-xl border border-stone-200 bg-white space-y-3 shadow-xs">
                <div className="flex items-center justify-between">
                  <span className="font-black text-stone-900 text-sm">{b.name}</span>
                  <span className="px-2 py-0.5 rounded bg-emerald-50 text-emerald-700 border border-emerald-200 text-[10px] font-bold">
                    {b.status}
                  </span>
                </div>
                <p className="text-xs text-stone-600">{b.address}</p>
                <div className="flex items-center justify-between text-xs pt-2 border-t border-stone-100">
                  <span className="text-stone-500 font-medium">Registered Members:</span>
                  <span className="font-bold text-stone-900">{b.members}</span>
                </div>
              </div>
            ))}
          </div>
        </div>
      )}

      {activeTab === "owner" && (
        <div className="fb-panel p-6 bg-white border border-stone-200 rounded-2xl shadow-xs space-y-4">
          <h3 className="text-sm font-bold text-stone-900">Owner Profile & Login Access</h3>
          <div className="bg-stone-50 rounded-xl p-5 border border-stone-200 space-y-3 font-mono text-xs max-w-xl">
            <div className="flex justify-between py-1 border-b border-stone-200">
              <span className="text-stone-500 font-sans">Owner Name:</span>
              <span className="font-bold text-stone-900 font-sans">{gymInfo.ownerName}</span>
            </div>
            <div className="flex justify-between py-1 border-b border-stone-200">
              <span className="text-stone-500 font-sans">Login Email:</span>
              <span className="font-bold text-orange-600">{gymInfo.ownerEmail}</span>
            </div>
            <div className="flex justify-between py-1 border-b border-stone-200">
              <span className="text-stone-500 font-sans">Phone / WhatsApp:</span>
              <span className="font-bold text-stone-900">{gymInfo.ownerPhone}</span>
            </div>
            <div className="flex justify-between py-1">
              <span className="text-stone-500 font-sans">Default Password:</span>
              <span className="font-bold text-stone-900 bg-stone-200 px-2 py-0.5 rounded">password123</span>
            </div>
          </div>
          <div className="flex gap-2 pt-2">
            <button
              onClick={sendWhatsApp}
              className="px-4 py-2 rounded-xl bg-emerald-600 hover:bg-emerald-700 text-white font-bold text-xs flex items-center gap-1.5 shadow-xs"
            >
              <span>💬</span> Send WhatsApp Update
            </button>
          </div>
        </div>
      )}

      {activeTab === "subscription" && (
        <div className="fb-panel p-6 bg-white border border-stone-200 rounded-2xl shadow-xs space-y-4">
          <h3 className="text-sm font-bold text-stone-900">SaaS Subscription & Billing Ledger</h3>
          <div className="p-5 rounded-xl border border-orange-200 bg-orange-50/60 max-w-xl space-y-2">
            <div className="flex items-center justify-between">
              <span className="font-black text-orange-950 text-base">{gymInfo.plan}</span>
              <span className="px-2.5 py-1 rounded-full text-xs font-bold bg-amber-100 text-amber-900">
                {gymInfo.status}
              </span>
            </div>
            <p className="text-sm font-bold text-stone-900">Rs. {gymInfo.monthlyPrice.toLocaleString()} / month</p>
            <p className="text-xs text-stone-600">Includes 3 branch licenses, biometric sync, and WhatsApp receipts.</p>
          </div>
        </div>
      )}

      {activeTab === "features" && (
        <div className="fb-panel p-6 bg-white border border-stone-200 rounded-2xl shadow-xs space-y-4">
          <h3 className="text-sm font-bold text-stone-900">Module Entitlements</h3>
          <div className="grid grid-cols-1 md:grid-cols-2 gap-3 max-w-2xl">
            {gymInfo.entitlements.map((feat, idx) => (
              <div
                key={idx}
                className={`p-3.5 rounded-xl border flex items-center justify-between ${
                  feat.enabled ? "bg-emerald-50/60 border-emerald-200 text-emerald-950" : "bg-stone-50 border-stone-200 text-stone-400"
                }`}
              >
                <span className="text-xs font-bold">{feat.key}</span>
                <span className="text-xs font-bold">{feat.enabled ? "✅ Active" : "❌ Disabled"}</span>
              </div>
            ))}
          </div>
        </div>
      )}
    </div>
  );
}
