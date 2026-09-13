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

export default function GymsWorkspacePage() {
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

  const [search, setSearch] = useState("");
  const [statusFilter, setStatusFilter] = useState("ALL");

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
🆔 *Tenant ID:* ${gym.id}
👤 *Owner Name:* ${gym.ownerName}
📧 *Login Email:* ${gym.ownerEmail}
📱 *Login Phone:* ${gym.ownerPhone}
🔑 *Default Password:* ${gym.password || "password123"}

🌐 *Web Portal:* http://localhost:3000/login
💻 *Desktop Client:* FitBizz OS Windows v2.0
🏢 *Branches Enabled:* ${gym.branchesCount}
📦 *Subscription Tier:* ${gym.planName}
⏳ *Status:* ${gym.status} (${gym.trialDays > 0 ? `${gym.trialDays} Days Free Trial` : "Active Paid"})
━━━━━━━━━━━━━━━━━━━━━━━━━━━━
_Keep these credentials confidential. You can change your password anytime inside the Owner Settings._`;

  const copyCredentials = (gym: GymTenant) => {
    navigator.clipboard.writeText(formatCredentialsText(gym));
    showToast("Credentials Copied", `Copied credentials for "${gym.name}" to clipboard.`);
  };

  const sendWhatsApp = (gym: GymTenant) => {
    const cleanPhone = gym.ownerPhone.replace(/[^0-9]/g, "");
    const encoded = encodeURIComponent(formatCredentialsText(gym));
    window.open(`https://wa.me/${cleanPhone}?text=${encoded}`, "_blank");
    showToast("Opening WhatsApp", `Launched WhatsApp dispatch for ${gym.ownerName}`);
  };

  const sendEmail = (gym: GymTenant) => {
    const subject = encodeURIComponent(`FitBizz Credentials & Setup - ${gym.name}`);
    const body = encodeURIComponent(formatCredentialsText(gym));
    window.open(`mailto:${gym.ownerEmail}?subject=${subject}&body=${body}`, "_blank");
    showToast("Opening Email Client", `Prepared credentials email to ${gym.ownerEmail}`);
  };

  const filteredGyms = gyms.filter((gym) => {
    const matchesSearch =
      gym.name.toLowerCase().includes(search.toLowerCase()) ||
      gym.ownerName.toLowerCase().includes(search.toLowerCase()) ||
      gym.city.toLowerCase().includes(search.toLowerCase()) ||
      gym.id.toLowerCase().includes(search.toLowerCase());
    const matchesStatus =
      statusFilter === "ALL" ||
      (statusFilter === "TRIAL" && gym.status.includes("Trial")) ||
      (statusFilter === "PAID" && gym.status.includes("Paid")) ||
      (statusFilter === "SUSPENDED" && gym.status.includes("Suspended"));
    return matchesSearch && matchesStatus;
  });

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
          <h1 className="text-xl font-bold text-stone-900 tracking-tight">Registered Tenants Directory</h1>
          <p className="text-xs text-stone-500 mt-0.5">
            Active fitness clubs, branch allocations, credential dispatches, and live workspace controls
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
          <Link href="/onboard" className="fb-button-primary text-xs flex items-center gap-1.5">
            <span>+</span>
            <span>Onboard New Gym</span>
          </Link>
        </div>
      </div>

      {/* Search & Filter Toolbar */}
      <div className="fb-panel p-4 flex flex-col md:flex-row items-stretch md:items-center gap-3 justify-between bg-white border border-stone-200 rounded-xl shadow-xs">
        <div className="flex-1 flex flex-col sm:flex-row items-center gap-3">
          <div className="relative w-full sm:w-72">
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
              placeholder="Search by gym name, owner, city, ID..."
              value={search}
              onChange={(e) => setSearch(e.target.value)}
              className="fb-input w-full pl-9 text-xs"
            />
          </div>

          <select
            value={statusFilter}
            onChange={(e) => setStatusFilter(e.target.value)}
            className="fb-input text-xs w-full sm:w-40 font-semibold"
          >
            <option value="ALL">All Statuses</option>
            <option value="TRIAL">15-Day Trial</option>
            <option value="PAID">Paid Active</option>
            <option value="SUSPENDED">Suspended</option>
          </select>
        </div>

        <div className="text-xs text-stone-500 font-semibold">
          Active Tenants: <span className="text-orange-600 font-bold">{filteredGyms.length}</span>
        </div>
      </div>

      {/* Main Tenants Table */}
      <div className="fb-panel overflow-hidden border border-stone-200 bg-white rounded-xl shadow-xs">
        <div className="overflow-x-auto">
          <table className="w-full text-left border-collapse text-xs">
            <thead>
              <tr className="bg-stone-50 border-b border-stone-200 text-stone-600 font-bold uppercase tracking-wider text-[10px]">
                <th className="p-3.5">Gym Business</th>
                <th className="p-3.5">Owner & Contact</th>
                <th className="p-3.5">Location</th>
                <th className="p-3.5">Branches</th>
                <th className="p-3.5">Subscription Plan</th>
                <th className="p-3.5">Status</th>
                <th className="p-3.5 text-right">Actions</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-stone-100">
              {filteredGyms.length === 0 ? (
                <tr>
                  <td colSpan={7} className="text-center py-12 text-stone-500">
                    <p className="font-bold text-stone-800 text-sm">No Tenants Match Your Search</p>
                    <p className="text-xs text-stone-400 mt-1">Clear filters to view registered gyms.</p>
                  </td>
                </tr>
              ) : (
                filteredGyms.map((gym) => (
                  <tr key={gym.id} className="hover:bg-orange-50/40 transition">
                    <td className="p-3.5">
                      <div>
                        <span className="font-bold text-stone-900 block text-sm">{gym.name}</span>
                        <span className="text-[11px] text-stone-400 font-mono">ID: {gym.id}</span>
                      </div>
                    </td>
                    <td className="p-3.5">
                      <div>
                        <p className="font-semibold text-stone-800">{gym.ownerName}</p>
                        <p className="text-[11px] text-stone-500">{gym.ownerEmail}</p>
                        <p className="text-[11px] text-stone-400 font-mono">{gym.ownerPhone}</p>
                      </div>
                    </td>
                    <td className="p-3.5">
                      <span className="font-medium text-stone-700">{gym.city}, PK</span>
                    </td>
                    <td className="p-3.5">
                      <span className="inline-flex items-center px-2 py-0.5 rounded-md bg-stone-100 font-bold text-stone-700">
                        {gym.branchesCount} Branches
                      </span>
                    </td>
                    <td className="p-3.5">
                      <span className="font-bold text-orange-950 block">{gym.planName}</span>
                      <span className="text-[10px] text-stone-500">Rs. {gym.monthlyPrice.toLocaleString()}/mo</span>
                    </td>
                    <td className="p-3.5">
                      <span className="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full text-[11px] font-bold bg-amber-50 text-amber-700 border border-amber-200">
                        <span className="w-1.5 h-1.5 rounded-full bg-amber-500"></span>
                        {gym.status} ({gym.trialDays}d left)
                      </span>
                    </td>
                    <td className="p-3.5 text-right">
                      <div className="flex items-center justify-end gap-1.5">
                        <button
                          onClick={() => setSelectedGymForCredentials(gym)}
                          className="px-2.5 py-1 rounded-lg border border-stone-200 hover:border-orange-500 hover:text-orange-600 font-bold transition text-[11px]"
                          title="Share Credentials"
                        >
                          🔑 Share
                        </button>
                        <button
                          onClick={() => openEditModal(gym)}
                          className="px-2.5 py-1 rounded-lg border border-stone-200 hover:border-blue-500 hover:text-blue-600 font-bold transition text-[11px]"
                          title="Edit Gym"
                        >
                          ✏️ Edit
                        </button>
                        <button
                          onClick={() => setSelectedGymForDelete(gym)}
                          className="px-2.5 py-1 rounded-lg border border-stone-200 hover:border-rose-500 hover:text-rose-600 font-bold transition text-[11px]"
                          title="Delete Gym"
                        >
                          🗑️
                        </button>
                        <Link
                          href={`/gyms/${gym.id}`}
                          className="px-3 py-1 rounded-lg bg-orange-600 hover:bg-orange-700 text-white font-bold transition text-[11px] shadow-xs"
                        >
                          Manage 🏢
                        </Link>
                      </div>
                    </td>
                  </tr>
                ))
              )}
            </tbody>
          </table>
        </div>
      </div>

      {/* Credentials Modal */}
      {selectedGymForCredentials && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-stone-900/60 backdrop-blur-xs">
          <div className="bg-white rounded-2xl max-w-lg w-full p-6 shadow-2xl border border-stone-200 space-y-4 animate-in zoom-in-95">
            <div className="flex items-center justify-between border-b border-stone-200 pb-3">
              <div className="flex items-center gap-2.5">
                <div className="w-8 h-8 rounded-lg bg-orange-600 text-white flex items-center justify-center font-bold text-sm">
                  🔑
                </div>
                <div>
                  <h3 className="font-bold text-sm text-stone-900">Tenant Access Credentials</h3>
                  <p className="text-[11px] text-stone-500">Dispatch directly to the Gym Owner via WhatsApp or Email</p>
                </div>
              </div>
              <button
                onClick={() => setSelectedGymForCredentials(null)}
                className="text-stone-400 hover:text-stone-700 font-bold text-sm"
              >
                ✕
              </button>
            </div>

            <div className="bg-stone-50 rounded-xl p-4 border border-stone-200 space-y-2 font-mono text-xs text-stone-800">
              <div className="flex justify-between py-1 border-b border-stone-200/60">
                <span className="text-stone-500">Gym Name:</span>
                <span className="font-bold text-stone-900">{selectedGymForCredentials.name}</span>
              </div>
              <div className="flex justify-between py-1 border-b border-stone-200/60">
                <span className="text-stone-500">Owner Name:</span>
                <span className="font-bold">{selectedGymForCredentials.ownerName}</span>
              </div>
              <div className="flex justify-between py-1 border-b border-stone-200/60">
                <span className="text-stone-500">Login Email:</span>
                <span className="font-bold text-orange-600">{selectedGymForCredentials.ownerEmail}</span>
              </div>
              <div className="flex justify-between py-1 border-b border-stone-200/60">
                <span className="text-stone-500">Default Password:</span>
                <span className="font-bold text-stone-900 bg-stone-200 px-1.5 py-0.5 rounded">
                  {selectedGymForCredentials.password || "password123"}
                </span>
              </div>
              <div className="flex justify-between py-1 border-b border-stone-200/60">
                <span className="text-stone-500">Branches Enabled:</span>
                <span className="font-bold">{selectedGymForCredentials.branchesCount} Branches</span>
              </div>
              <div className="flex justify-between py-1">
                <span className="text-stone-500">SaaS Plan:</span>
                <span className="font-bold text-emerald-700">{selectedGymForCredentials.planName}</span>
              </div>
            </div>

            <div className="grid grid-cols-3 gap-2 pt-2">
              <button
                onClick={() => copyCredentials(selectedGymForCredentials)}
                className="py-2 px-3 rounded-xl border border-stone-300 hover:bg-stone-100 font-bold text-xs flex items-center justify-center gap-1.5 transition"
              >
                <span>📋</span>
                <span>Copy</span>
              </button>
              <button
                onClick={() => sendWhatsApp(selectedGymForCredentials)}
                className="py-2 px-3 rounded-xl bg-emerald-600 hover:bg-emerald-700 text-white font-bold text-xs flex items-center justify-center gap-1.5 transition shadow-xs"
              >
                <span>💬</span>
                <span>WhatsApp</span>
              </button>
              <button
                onClick={() => sendEmail(selectedGymForCredentials)}
                className="py-2 px-3 rounded-xl bg-orange-600 hover:bg-orange-700 text-white font-bold text-xs flex items-center justify-center gap-1.5 transition shadow-xs"
              >
                <span>✉️</span>
                <span>Email</span>
              </button>
            </div>
          </div>
        </div>
      )}

      {/* Edit Modal */}
      {selectedGymForEdit && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-stone-900/60 backdrop-blur-xs">
          <div className="bg-white rounded-2xl max-w-lg w-full p-6 shadow-2xl border border-stone-200 space-y-4 animate-in zoom-in-95">
            <div className="flex items-center justify-between border-b border-stone-200 pb-3">
              <h3 className="font-bold text-sm text-stone-900">Edit Gym Profile ({selectedGymForEdit.id})</h3>
              <button onClick={() => setSelectedGymForEdit(null)} className="text-stone-400 hover:text-stone-700 font-bold text-sm">
                ✕
              </button>
            </div>

            <div className="space-y-3 text-xs">
              <div>
                <label className="font-bold text-stone-700 block mb-1">Gym Business Name</label>
                <input
                  type="text"
                  value={editName}
                  onChange={(e) => setEditName(e.target.value)}
                  className="fb-input w-full"
                />
              </div>

              <div>
                <label className="font-bold text-stone-700 block mb-1">Owner Full Name</label>
                <input
                  type="text"
                  value={editOwner}
                  onChange={(e) => setEditOwner(e.target.value)}
                  className="fb-input w-full"
                />
              </div>

              <div className="grid grid-cols-2 gap-3">
                <div>
                  <label className="font-bold text-stone-700 block mb-1">Login Email</label>
                  <input
                    type="email"
                    value={editEmail}
                    onChange={(e) => setEditEmail(e.target.value)}
                    className="fb-input w-full"
                  />
                </div>
                <div>
                  <label className="font-bold text-stone-700 block mb-1">Owner Phone</label>
                  <input
                    type="text"
                    value={editPhone}
                    onChange={(e) => setEditPhone(e.target.value)}
                    className="fb-input w-full"
                  />
                </div>
              </div>

              <div className="grid grid-cols-2 gap-3">
                <div>
                  <label className="font-bold text-stone-700 block mb-1">Branch Licenses</label>
                  <select
                    value={editBranches}
                    onChange={(e) => setEditBranches(Number(e.target.value))}
                    className="fb-input w-full font-semibold"
                  >
                    {[1, 2, 3, 4, 5, 10].map((b) => (
                      <option key={b} value={b}>
                        {b} Branches
                      </option>
                    ))}
                  </select>
                </div>
                <div>
                  <label className="font-bold text-stone-700 block mb-1">Subscription Status</label>
                  <select
                    value={editStatus}
                    onChange={(e) => setEditStatus(e.target.value as any)}
                    className="fb-input w-full font-semibold"
                  >
                    <option value="15-Day Trial">15-Day Trial</option>
                    <option value="Paid Subscription">Paid Subscription</option>
                    <option value="Suspended">Suspended</option>
                  </select>
                </div>
              </div>
            </div>

            <div className="flex items-center justify-end gap-2 pt-3 border-t border-stone-200">
              <button
                onClick={() => setSelectedGymForEdit(null)}
                className="px-4 py-2 rounded-xl border border-stone-300 font-bold text-xs hover:bg-stone-100"
              >
                Cancel
              </button>
              <button
                onClick={handleSaveEdit}
                className="fb-button-primary text-xs"
              >
                Save Changes
              </button>
            </div>
          </div>
        </div>
      )}

      {/* Delete Confirmation Modal */}
      {selectedGymForDelete && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-stone-900/60 backdrop-blur-xs">
          <div className="bg-white rounded-2xl max-w-md w-full p-6 shadow-2xl border border-stone-200 space-y-4 animate-in zoom-in-95">
            <div className="flex items-center gap-3 text-rose-600">
              <div className="w-10 h-10 rounded-full bg-rose-50 flex items-center justify-center font-bold text-lg">
                ⚠️
              </div>
              <h3 className="font-bold text-sm text-stone-900">Remove Gym Tenant?</h3>
            </div>
            <p className="text-xs text-stone-600 leading-relaxed">
              Are you sure you want to remove <strong className="text-stone-900">{selectedGymForDelete.name}</strong> ({selectedGymForDelete.id})? All tenant data and branch licenses will be archived.
            </p>
            <div className="flex items-center justify-end gap-2 pt-3 border-t border-stone-200">
              <button
                onClick={() => setSelectedGymForDelete(null)}
                className="px-4 py-2 rounded-xl border border-stone-300 font-bold text-xs hover:bg-stone-100"
              >
                Cancel
              </button>
              <button
                onClick={handleDeleteGym}
                className="px-4 py-2 rounded-xl bg-rose-600 hover:bg-rose-700 text-white font-bold text-xs shadow-xs"
              >
                Delete Gym
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
