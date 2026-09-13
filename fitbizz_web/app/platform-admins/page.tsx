"use me";
"use client";

import React, { useState } from "react";

interface AdminUser {
  id: string;
  name: string;
  email: string;
  role: "SUPER_ADMIN" | "PLATFORM_SUPPORT";
  status: "ACTIVE" | "INACTIVE";
  lastActive: string;
  createdAt: string;
}

export default function PlatformAdminsPage() {
  const [admins, setAdmins] = useState<AdminUser[]>([
    {
      id: "admin-01",
      name: "Zain Malik (Primary)",
      email: "iamzainofficial4211@gmail.com",
      role: "SUPER_ADMIN",
      status: "ACTIVE",
      lastActive: "Just Now",
      createdAt: "2026-09-01",
    },
    {
      id: "admin-02",
      name: "Platform Support",
      email: "support@fitbizz.com",
      role: "PLATFORM_SUPPORT",
      status: "ACTIVE",
      lastActive: "2 hours ago",
      createdAt: "2026-09-05",
    },
  ]);

  const [showInviteModal, setShowInviteModal] = useState(false);
  const [newAdmin, setNewAdmin] = useState({
    name: "",
    email: "",
    role: "SUPER_ADMIN" as const,
  });

  const handleCreateAdmin = (e: React.FormEvent) => {
    e.preventDefault();
    if (!newAdmin.email || !newAdmin.name) return;

    const created: AdminUser = {
      id: `admin-0${admins.length + 1}`,
      name: newAdmin.name,
      email: newAdmin.email,
      role: newAdmin.role,
      status: "ACTIVE",
      lastActive: "Invited (Pending)",
      createdAt: new Date().toISOString().substring(0, 10),
    };

    setAdmins([...admins, created]);
    setShowInviteModal(false);
    setNewAdmin({ name: "", email: "", role: "SUPER_ADMIN" });
  };

  const toggleStatus = (id: string) => {
    setAdmins(
      admins.map((a) =>
        a.id === id
          ? { ...a, status: a.status === "ACTIVE" ? "INACTIVE" : "ACTIVE" }
          : a
      )
    );
  };

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4 pb-4 border-b border-[#e2e8f0]">
        <div>
          <h1 className="text-xl font-bold text-slate-900 tracking-tight">Platform Super Administrators</h1>
          <p className="text-xs text-slate-500 mt-0.5">
            Manage FittBizz platform control center administrative users and security credentials
          </p>
        </div>
        <button
          onClick={() => setShowInviteModal(true)}
          className="fb-button-primary text-xs"
        >
          + Invite Platform Admin
        </button>
      </div>

      {/* Security Alert Banner */}
      <div className="p-4 rounded-xl bg-blue-50 border border-blue-200 text-xs text-blue-900 flex items-center justify-between shadow-xs">
        <div>
          <strong className="text-blue-950 block font-bold">Strict Governance & Security Scope</strong>
          <span>Platform Admins hold global control center access over all registered gyms and billing entitlements.</span>
        </div>
        <span className="fb-badge fb-badge-info shrink-0 font-bold">Audit Logs Active</span>
      </div>

      {/* Directory Table */}
      <div className="fb-table-container">
        <table className="fb-table">
          <thead>
            <tr>
              <th>Admin Name</th>
              <th>Email</th>
              <th>Role Scope</th>
              <th>Status</th>
              <th>Last Active</th>
              <th>Created</th>
              <th className="text-right">Actions</th>
            </tr>
          </thead>
          <tbody>
            {admins.map((admin) => (
              <tr key={admin.id}>
                <td>
                  <div>
                    <span className="font-bold text-slate-900 block text-sm">{admin.name}</span>
                    <span className="text-[11px] text-slate-500 font-mono">{admin.id}</span>
                  </div>
                </td>
                <td>
                  <span className="text-xs text-slate-800 font-mono font-medium">{admin.email}</span>
                </td>
                <td>
                  <span className="fb-badge fb-badge-info text-[10px]">{admin.role}</span>
                </td>
                <td>
                  <span
                    className={`fb-badge ${
                      admin.status === "ACTIVE" ? "fb-badge-success" : "fb-badge-danger"
                    }`}
                  >
                    {admin.status}
                  </span>
                </td>
                <td>
                  <span className="text-xs text-slate-500 font-mono">{admin.lastActive}</span>
                </td>
                <td>
                  <span className="text-xs text-slate-500 font-mono">{admin.createdAt}</span>
                </td>
                <td className="text-right">
                  <button
                    onClick={() => toggleStatus(admin.id)}
                    className="fb-button-secondary text-xs py-1 px-2.5"
                  >
                    {admin.status === "ACTIVE" ? "Deactivate" : "Reactivate"}
                  </button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>

      {/* Invite Admin Modal */}
      {showInviteModal && (
        <div className="fixed inset-0 z-50 bg-slate-900/50 backdrop-blur-xs flex items-center justify-center p-4">
          <div className="fb-panel w-full max-w-md p-6 space-y-4 shadow-xl bg-white border border-[#e2e8f0]">
            <h2 className="text-base font-bold text-slate-900 border-b border-[#e2e8f0] pb-2">
              Invite New Platform Administrator
            </h2>

            <form onSubmit={handleCreateAdmin} className="space-y-4">
              <div>
                <label className="block text-xs font-semibold text-slate-700 mb-1">Full Name</label>
                <input
                  type="text"
                  required
                  placeholder="e.g. Sarah Khan"
                  value={newAdmin.name}
                  onChange={(e) => setNewAdmin({ ...newAdmin, name: e.target.value })}
                  className="fb-input w-full"
                />
              </div>

              <div>
                <label className="block text-xs font-semibold text-slate-700 mb-1">Email Address</label>
                <input
                  type="email"
                  required
                  placeholder="sarah@fitbizz.com"
                  value={newAdmin.email}
                  onChange={(e) => setNewAdmin({ ...newAdmin, email: e.target.value })}
                  className="fb-input w-full"
                />
              </div>

              <div>
                <label className="block text-xs font-semibold text-slate-700 mb-1">Role Scope</label>
                <select
                  value={newAdmin.role}
                  onChange={(e) => setNewAdmin({ ...newAdmin, role: e.target.value as any })}
                  className="fb-input w-full"
                >
                  <option value="SUPER_ADMIN">Full Platform Super Admin</option>
                  <option value="PLATFORM_SUPPORT">Platform Support Specialist</option>
                </select>
              </div>

              <div className="pt-2 flex items-center justify-end gap-3">
                <button
                  type="button"
                  onClick={() => setShowInviteModal(false)}
                  className="fb-button-secondary text-xs"
                >
                  Cancel
                </button>
                <button type="submit" className="fb-button-primary text-xs">
                  Send Invitation
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
}
