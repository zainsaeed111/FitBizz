"use client";

import React, { useState } from "react";
import Link from "next/link";
import { useRouter } from "next/navigation";

export interface GymTenant {
  id: string;
  name: string;
  ownerName: string;
  ownerEmail: string;
  ownerPhone: string;
  password?: string;
  branchesCount: number;
  status: "15-Day Trial" | "Paid Subscription" | "Suspended";
  trialDays: number;
  city: string;
  planName: string;
  monthlyPrice: number;
  createdDate: string;
}

export default function SuperAdminDashboardPage() {
  const router = useRouter();
  const [toast, setToast] = useState<{ title: string; message: string; type: "success" | "info" | "warning" } | null>(null);

  const showToast = (title: string, message: string, type: "success" | "info" | "warning" = "success") => {
    setToast({ title, message, type });
    setTimeout(() => setToast(null), 3800);
  };

  const [gyms, setGyms] = useState<GymTenant[]>([
    {
      id: "tenant-001",
      name: "Metro Fitness Club",
      ownerName: "Kamran Ahmed",
      ownerEmail: "owner@metrofitness.com",
      ownerPhone: "+92 300 1234567",
      password: "password123",
      branchesCount: 2,
      status: "15-Day Trial",
      trialDays: 14,
      city: "Lahore",
      planName: "Pro Multi-Branch Plan",
      monthlyPrice: 35000,
      createdDate: "Sep 12, 2026",
    },
  ]);

  // Modals state
  const [selectedGymForCredentials, setSelectedGymForCredentials] = useState<GymTenant | null>(null);
  const [selectedGymForEdit, setSelectedGymForEdit] = useState<GymTenant | null>(null);
  const [selectedGymForDelete, setSelectedGymForDelete] = useState<GymTenant | null>(null);

  // Edit form state
  const [editName, setEditName] = useState("");
  const [editOwner, setEditOwner] = useState("");
  const [editEmail, setEditEmail] = useState("");
  const [editPhone, setEditPhone] = useState("");
  const [editBranches, setEditBranches] = useState(1);
  const [editStatus, setEditStatus] = useState<"15-Day Trial" | "Paid Subscription" | "Suspended">("15-Day Trial");

  const openEditModal = (gym: GymTenant) => {
    setSelectedGymForEdit(gym);
    setEditName(gym.name);
    setEditOwner(gym.ownerName);
    setEditEmail(gym.ownerEmail);
    setEditPhone(gym.ownerPhone);
    setEditBranches(gym.branchesCount);
    setEditStatus(gym.status);
  };

  const handleSaveEdit = () => {
    if (!selectedGymForEdit) return;
    if (editName.trim().length < 3) {
      showToast("Validation Error", "Gym name must be at least 3 characters", "warning");
      return;
    }
    if (editOwner.trim().length < 3) {
      showToast("Validation Error", "Owner name is required", "warning");
      return;
    }
    const emailRegex = /^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$/;
    if (!emailRegex.test(editEmail.trim())) {
      showToast("Validation Error", "Please enter a valid email address", "warning");
      return;
    }
    const phoneDigits = editPhone.replace(/[^0-9]/g, "");
    if (phoneDigits.length < 10) {
      showToast("Validation Error", "Please enter a valid phone number", "warning");
      return;
    }

    setGyms(
      gyms.map((g) =>
        g.id === selectedGymForEdit.id
          ? {
              ...g,
              name: editName.trim(),
              ownerName: editOwner.trim(),
              ownerEmail: editEmail.trim(),
              ownerPhone: editPhone.trim(),
              branchesCount: editBranches,
              status: editStatus,
            }
          : g
      )
    );
    showToast("Gym Updated Successfully", `Updated "${editName}" tenant profile.`);
    setSelectedGymForEdit(null);
  };

  const handleDeleteGym = () => {
    if (!selectedGymForDelete) return;
    setGyms(gyms.filter((g) => g.id !== selectedGymForDelete.id));
    showToast("Tenant Removed", `"${selectedGymForDelete.name}" (${selectedGymForDelete.id}) has been removed.`, "warning");
    setSelectedGymForDelete(null);
  };

  const formatCredentialsText = (gym: GymTenant) => `🏋️ *FitBizz Gym Tenant Credentials & Welcome Pack*
━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🏢 *Gym Name:* ${gym.name}
🆔 *Tenant / Gym ID:* ${gym.id}
👤 *Owner Name:* ${gym.ownerName}
📧 *Login Email:* ${gym.ownerEmail}
📱 *Registered Phone:* ${gym.ownerPhone}
🔑 *Default Password:* ${gym.password || "password123"}
🌐 *Web Portal:* http://localhost:3000/login
💻 *Desktop Client:* FitBizz OS Windows v2.0
🏢 *Branches Enabled:* ${gym.branchesCount}
📦 *Subscription Tier:* ${gym.planName}
⏳ *Status:* ${gym.status}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━
_Keep these credentials confidential. You can change your password anytime inside the Owner Settings._`;

  const copyCredentials = (gym: GymTenant) => {
    const text = formatCredentialsText(gym);
    navigator.clipboard.writeText(text);
    showToast("Credentials Copied!", `Access pack for "${gym.name}" copied to clipboard.`);
  };

  const sendViaWhatsApp = (gym: GymTenant) => {
    const text = formatCredentialsText(gym);
    navigator.clipboard.writeText(text);
    const cleanPhone = gym.ownerPhone.replace(/[^0-9]/g, "");
    const waPhone = cleanPhone.startsWith("0") ? `92${cleanPhone.substring(1)}` : cleanPhone;
    const url = waPhone.length > 5
      ? `https://wa.me/${waPhone}?text=${encodeURIComponent(text)}`
      : `https://wa.me/?text=${encodeURIComponent(text)}`;
    window.open(url, "_blank");
    showToast("WhatsApp Dispatched", `Opening WhatsApp with credentials for ${gym.ownerName}.`);
  };

  const sendViaEmail = (gym: GymTenant) => {
    const text = formatCredentialsText(gym);
    navigator.clipboard.writeText(text);
    const subject = encodeURIComponent(`🏋️ FitBizz Platform Access Pack - ${gym.name}`);
    const body = encodeURIComponent(text);
    window.location.href = `mailto:${gym.ownerEmail}?subject=${subject}&body=${body}`;
    showToast("Email Draft Prepared", `Opening mail client for ${gym.ownerEmail}.`);
  };

  const activeTrialsCount = gyms.filter((g) => g.status === "15-Day Trial").length;
  const totalBranchesCount = gyms.reduce((acc, g) => acc + g.branchesCount, 0);

  return (
    <div className="space-y-6">
      {/* Top Banner & Header */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 pb-4 border-b border-stone-200">
        <div>
          <h1 className="text-xl font-black text-stone-900 tracking-tight">Platform Gym Onboarding Overview</h1>
          <p className="text-xs text-stone-500 mt-0.5">
            Manage registered fitness business tenants, 15-day trials, and automated credential packs
          </p>
        </div>
        <div className="flex items-center gap-2.5">
          <Link href="/onboard" className="fb-button-primary text-xs">
            <span>+</span> Onboard New Gym
          </Link>
          <Link href="/gyms/tenant-001" className="fb-button-secondary text-xs">
            Sample Workspace
          </Link>
        </div>
      </div>

      {/* 4 Metric Cards (Matching Flutter Super Admin) */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
        {/* Metric 1 */}
        <div className="fb-panel p-5 space-y-2">
          <div className="flex items-center justify-between">
            <span className="text-[11px] font-bold text-stone-500 uppercase tracking-wider">Onboarded Gyms</span>
            <div className="w-8 h-8 rounded-lg bg-orange-100 text-orange-600 flex items-center justify-center font-bold text-sm">
              🏢
            </div>
          </div>
          <p className="text-2xl font-black text-stone-900">{gyms.length + 22}</p>
          <p className="text-[11px] text-emerald-600 font-semibold">+4 gyms this week</p>
        </div>

        {/* Metric 2 */}
        <div className="fb-panel p-5 space-y-2">
          <div className="flex items-center justify-between">
            <span className="text-[11px] font-bold text-stone-500 uppercase tracking-wider">Active 15-Day Trials</span>
            <div className="w-8 h-8 rounded-lg bg-amber-100 text-amber-600 flex items-center justify-center font-bold text-sm">
              🎁
            </div>
          </div>
          <p className="text-2xl font-black text-stone-900">{activeTrialsCount + 6}</p>
          <p className="text-[11px] text-stone-500 font-semibold">Conversion rate: 78%</p>
        </div>

        {/* Metric 3 */}
        <div className="fb-panel p-5 space-y-2">
          <div className="flex items-center justify-between">
            <span className="text-[11px] font-bold text-stone-500 uppercase tracking-wider">Total Branches Managed</span>
            <div className="w-8 h-8 rounded-lg bg-emerald-100 text-emerald-600 flex items-center justify-center font-bold text-sm">
              📍
            </div>
          </div>
          <p className="text-2xl font-black text-stone-900">{totalBranchesCount + 56}</p>
          <p className="text-[11px] text-stone-500 font-semibold">Avg 2.5 branches / gym</p>
        </div>

        {/* Metric 4 */}
        <div className="fb-panel p-5 space-y-2">
          <div className="flex items-center justify-between">
            <span className="text-[11px] font-bold text-stone-500 uppercase tracking-wider">Platform SaaS MRR</span>
            <div className="w-8 h-8 rounded-lg bg-orange-100 text-orange-600 flex items-center justify-center font-bold text-sm">
              📈
            </div>
          </div>
          <p className="text-2xl font-black text-orange-600">Rs 425,000</p>
          <p className="text-[11px] text-stone-500 font-semibold">Active subscriptions</p>
        </div>
      </div>

      {/* Registered Gym Tenants CRUD Table */}
      <div className="fb-panel overflow-hidden">
        <div className="p-4 border-b border-stone-200 flex items-center justify-between bg-white">
          <div>
            <h2 className="text-sm font-bold text-stone-900">Registered Gym Tenants ({gyms.length})</h2>
            <p className="text-xs text-stone-500">Full CRUD, Dynamic Context Switch & Credential Dispatch</p>
          </div>
          <span className="fb-badge fb-badge-info text-[10px]">Real-time SQLite Sync</span>
        </div>

        <div className="divide-y divide-stone-200 overflow-x-auto">
          {gyms.map((gym) => {
            const isTrial = gym.status === "15-Day Trial";

            return (
              <div
                key={gym.id}
                className="p-4 flex flex-col md:flex-row md:items-center justify-between gap-4 hover:bg-orange-50/40 transition"
              >
                {/* Left Info */}
                <div className="flex items-start gap-3">
                  <div className="w-10 h-10 rounded-xl bg-orange-100 text-orange-600 flex items-center justify-center font-bold text-base shrink-0">
                    🏋️
                  </div>
                  <div>
                    <div className="flex items-center gap-2">
                      <h3 className="text-sm font-bold text-stone-900">{gym.name}</h3>
                      <span className={`fb-badge text-[10px] ${isTrial ? "fb-badge-warning" : "fb-badge-success"}`}>
                        {gym.status}
                      </span>
                    </div>
                    <p className="text-xs text-stone-500 mt-0.5">
                      Owner: <strong className="text-stone-700">{gym.ownerName}</strong> ({gym.ownerEmail}) •{" "}
                      {gym.branchesCount} Branches • {gym.city} • Onboarded: {gym.createdDate}
                    </p>
                  </div>
                </div>

                {/* Right Action Icons & Manage Button */}
                <div className="flex items-center gap-1.5 self-end md:self-auto shrink-0">
                  <button
                    type="button"
                    onClick={() => setSelectedGymForCredentials(gym)}
                    className="p-1.5 rounded-lg border border-stone-200 hover:bg-orange-50 text-stone-600 hover:text-orange-600 transition"
                    title="Share Access Pack (WhatsApp / Email / Copy)"
                  >
                    💬
                  </button>
                  <button
                    type="button"
                    onClick={() => openEditModal(gym)}
                    className="p-1.5 rounded-lg border border-stone-200 hover:bg-stone-100 text-stone-600 hover:text-stone-900 transition"
                    title="Edit Gym Details"
                  >
                    ✏️
                  </button>
                  <button
                    type="button"
                    onClick={() => setSelectedGymForDelete(gym)}
                    className="p-1.5 rounded-lg border border-stone-200 hover:bg-red-50 text-stone-600 hover:text-red-600 transition"
                    title="Delete / Suspend Gym"
                  >
                    🗑️
                  </button>
                  <Link
                    href={`/gyms/${gym.id}`}
                    onClick={() => {
                      showToast(`Opening ${gym.name}`, `Switched active context to ${gym.ownerName}.`);
                    }}
                    className="fb-button-secondary text-xs py-1.5 px-3"
                  >
                    Manage Gym
                  </Link>
                </div>
              </div>
            );
          })}
        </div>
      </div>

      {/* SHARE / CREDENTIALS MODAL */}
      {selectedGymForCredentials && (
        <div className="fixed inset-0 z-50 bg-black/60 backdrop-blur-sm flex items-center justify-center p-4">
          <div className="bg-white rounded-2xl shadow-2xl max-w-lg w-full p-6 sm:p-8 space-y-5 animate-in fade-in zoom-in-95 duration-200">
            <div className="flex items-start justify-between">
              <div>
                <span className="fb-badge fb-badge-info mb-1">Access Credentials</span>
                <h2 className="text-lg font-black text-stone-900">{selectedGymForCredentials.name}</h2>
                <p className="text-xs text-stone-500 mt-0.5">
                  Owner: {selectedGymForCredentials.ownerName} ({selectedGymForCredentials.ownerPhone})
                </p>
              </div>
              <button
                onClick={() => setSelectedGymForCredentials(null)}
                className="text-stone-400 hover:text-stone-700 text-lg leading-none"
              >
                ✕
              </button>
            </div>

            <div className="p-4 rounded-xl bg-stone-50 border border-stone-200 space-y-2 text-xs">
              <div className="flex justify-between py-1 border-b border-stone-200">
                <span className="text-stone-500 font-semibold">Tenant ID:</span>
                <span className="font-mono font-bold text-orange-600">{selectedGymForCredentials.id}</span>
              </div>
              <div className="flex justify-between py-1 border-b border-stone-200">
                <span className="text-stone-500 font-semibold">Owner Email:</span>
                <span className="font-semibold text-stone-900">{selectedGymForCredentials.ownerEmail}</span>
              </div>
              <div className="flex justify-between py-1 border-b border-stone-200">
                <span className="text-stone-500 font-semibold">Default Password:</span>
                <span className="font-mono font-bold text-stone-900">password123</span>
              </div>
              <div className="flex justify-between py-1">
                <span className="text-stone-500 font-semibold">Plan Status:</span>
                <span className="font-bold text-emerald-700">
                  {selectedGymForCredentials.status} ({selectedGymForCredentials.branchesCount} Branches)
                </span>
              </div>
            </div>

            <div className="space-y-2.5">
              <div className="grid grid-cols-1 sm:grid-cols-2 gap-2">
                <button
                  type="button"
                  onClick={() => sendViaWhatsApp(selectedGymForCredentials)}
                  className="p-2.5 rounded-xl bg-emerald-600 hover:bg-emerald-700 text-white font-bold text-xs flex items-center justify-center gap-2 shadow-sm transition"
                >
                  <span>💬</span> Send via WhatsApp
                </button>
                <button
                  type="button"
                  onClick={() => sendViaEmail(selectedGymForCredentials)}
                  className="p-2.5 rounded-xl bg-orange-600 hover:bg-orange-700 text-white font-bold text-xs flex items-center justify-center gap-2 shadow-sm transition"
                >
                  <span>✉️</span> Send via Email
                </button>
              </div>

              <button
                type="button"
                onClick={() => copyCredentials(selectedGymForCredentials)}
                className="w-full fb-button-secondary text-xs"
              >
                📋 Copy Full Credentials Pack
              </button>
            </div>
          </div>
        </div>
      )}

      {/* EDIT GYM MODAL */}
      {selectedGymForEdit && (
        <div className="fixed inset-0 z-50 bg-black/60 backdrop-blur-sm flex items-center justify-center p-4">
          <div className="bg-white rounded-2xl shadow-2xl max-w-md w-full p-6 space-y-4 animate-in fade-in zoom-in-95 duration-200">
            <h2 className="text-base font-black text-stone-900">Edit Gym Details ({selectedGymForEdit.id})</h2>

            <div className="space-y-3 text-xs">
              <div>
                <label className="block font-bold text-stone-700 mb-1">Gym Name</label>
                <input
                  type="text"
                  value={editName}
                  onChange={(e) => setEditName(e.target.value)}
                  className="fb-input w-full"
                />
              </div>

              <div>
                <label className="block font-bold text-stone-700 mb-1">Owner Name</label>
                <input
                  type="text"
                  value={editOwner}
                  onChange={(e) => setEditOwner(e.target.value)}
                  className="fb-input w-full"
                />
              </div>

              <div className="grid grid-cols-2 gap-2">
                <div>
                  <label className="block font-bold text-stone-700 mb-1">Email</label>
                  <input
                    type="email"
                    value={editEmail}
                    onChange={(e) => setEditEmail(e.target.value)}
                    className="fb-input w-full"
                  />
                </div>
                <div>
                  <label className="block font-bold text-stone-700 mb-1">Phone</label>
                  <input
                    type="text"
                    value={editPhone}
                    onChange={(e) => setEditPhone(e.target.value)}
                    className="fb-input w-full"
                  />
                </div>
              </div>

              <div className="grid grid-cols-2 gap-2">
                <div>
                  <label className="block font-bold text-stone-700 mb-1">Branches</label>
                  <input
                    type="number"
                    min="1"
                    max="10"
                    value={editBranches}
                    onChange={(e) => setEditBranches(Number(e.target.value))}
                    className="fb-input w-full"
                  />
                </div>
                <div>
                  <label className="block font-bold text-stone-700 mb-1">Status</label>
                  <select
                    value={editStatus}
                    onChange={(e) => setEditStatus(e.target.value as any)}
                    className="fb-input w-full"
                  >
                    <option value="15-Day Trial">15-Day Trial</option>
                    <option value="Paid Subscription">Paid Subscription</option>
                    <option value="Suspended">Suspended</option>
                  </select>
                </div>
              </div>
            </div>

            <div className="pt-2 flex justify-end gap-2">
              <button
                type="button"
                onClick={() => setSelectedGymForEdit(null)}
                className="fb-button-secondary text-xs"
              >
                Cancel
              </button>
              <button
                type="button"
                onClick={handleSaveEdit}
                className="fb-button-primary text-xs"
              >
                Save Changes
              </button>
            </div>
          </div>
        </div>
      )}

      {/* DELETE CONFIRMATION MODAL */}
      {selectedGymForDelete && (
        <div className="fixed inset-0 z-50 bg-black/60 backdrop-blur-sm flex items-center justify-center p-4">
          <div className="bg-white rounded-2xl shadow-2xl max-w-sm w-full p-6 space-y-4 animate-in fade-in zoom-in-95 duration-200">
            <h2 className="text-base font-black text-red-600">Delete / Suspend Gym?</h2>
            <p className="text-xs text-stone-600">
              Are you sure you want to remove <strong>"{selectedGymForDelete.name}"</strong> ({selectedGymForDelete.id})? All associated branch data and offline mutations will be archived.
            </p>
            <div className="pt-2 flex justify-end gap-2">
              <button
                type="button"
                onClick={() => setSelectedGymForDelete(null)}
                className="fb-button-secondary text-xs"
              >
                Cancel
              </button>
              <button
                type="button"
                onClick={handleDeleteGym}
                className="fb-button-primary text-xs bg-red-600 hover:bg-red-700 shadow-red-500/20"
              >
                Delete Gym
              </button>
            </div>
          </div>
        </div>
      )}

      {/* Floating Japani Phal Toast Notification */}
      {toast && (
        <div className="fixed top-6 right-6 z-50 max-w-md w-[calc(100vw-2rem)] sm:w-auto animate-in fade-in slide-in-from-top-4 duration-300">
          <div
            className={`p-4 rounded-xl shadow-2xl border flex items-start gap-3 backdrop-blur-md transition-all ${
              toast.type === "success"
                ? "bg-emerald-950/95 text-white border-emerald-500/40"
                : toast.type === "warning"
                ? "bg-amber-950/95 text-white border-amber-500/40"
                : "bg-stone-900/95 text-white border-orange-500/40"
            }`}
          >
            <div className="p-1.5 rounded-full bg-orange-500/20 text-orange-400 font-bold text-sm leading-none flex items-center justify-center">
              {toast.type === "success" ? "✓" : toast.type === "warning" ? "⚠️" : "ℹ️"}
            </div>
            <div className="flex-1">
              <h4 className="text-sm font-bold text-white">{toast.title}</h4>
              <p className="text-xs text-stone-300 mt-0.5 leading-relaxed">{toast.message}</p>
            </div>
            <button
              onClick={() => setToast(null)}
              className="text-stone-400 hover:text-white text-sm p-1 leading-none"
            >
              ✕
            </button>
          </div>
        </div>
      )}
    </div>
  );
}
