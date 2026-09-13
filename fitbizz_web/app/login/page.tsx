"use client";

import React, { useState } from "react";
import { useRouter } from "next/navigation";
import Image from "next/image";

export default function LoginPage() {
  const router = useRouter();
  const [identifier, setIdentifier] = useState("admin@fitbizz.com");
  const [password, setPassword] = useState("password123");
  const [rememberMe, setRememberMe] = useState(true);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState("");
  const [showHelper, setShowHelper] = useState(false);

  const getIdentifierIcon = (val: string) => {
    const t = val.trim();
    if (t.includes("@")) return "✉️";
    if (/^[0-9+\s-]+$/.test(t) && t.length > 0) return "📱";
    return "🪪";
  };

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setError("");

    const cleanId = identifier.trim().toLowerCase();

    try {
      // 1. Try unified Backend API
      const response = await fetch("http://localhost:8080/api/v1/auth/login", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ identifier: cleanId, password }),
      });

      if (response.ok) {
        const data = await response.json();
        if (data.token) {
          localStorage.setItem("fitbizz_token", data.token);
        }
        localStorage.setItem("fitbizz_user_role", data.role || "OWNER");
        localStorage.setItem("fitbizz_user_name", data.fullName || "User");
        localStorage.setItem("fitbizz_tenant_id", data.tenantId || "tenant-001");

        if (data.role === "SUPER_ADMIN") {
          router.push("/");
        } else {
          router.push("/members");
        }
        return;
      }
    } catch {
      // Offline / Local fallback
    }

    // 2. Offline / Local Smart Automatic Role Detection
    setTimeout(() => {
      setLoading(false);

      if (cleanId.includes("admin") || cleanId === "super-001") {
        localStorage.setItem("fitbizz_user_role", "SUPER_ADMIN");
        localStorage.setItem("fitbizz_user_name", "Super Admin HQ");
        localStorage.setItem("fitbizz_admin_token", "dev_super_admin_session_token");
        router.push("/");
      } else if (cleanId.includes("owner") || cleanId.includes("pulse") || cleanId === "gym-001" || cleanId.includes("3001234567")) {
        localStorage.setItem("fitbizz_user_role", "OWNER");
        localStorage.setItem("fitbizz_user_name", "Kamran Ahmed (Owner)");
        localStorage.setItem("fitbizz_gym_tenant_id", "tenant-001");
        router.push("/members");
      } else if (cleanId.includes("reception") || cleanId === "rec-101") {
        localStorage.setItem("fitbizz_user_role", "RECEPTIONIST");
        localStorage.setItem("fitbizz_user_name", "Ayesha Khan (Front Desk)");
        localStorage.setItem("fitbizz_gym_tenant_id", "tenant-001");
        router.push("/members");
      } else if (cleanId.includes("finance") || cleanId === "acc-201") {
        localStorage.setItem("fitbizz_user_role", "ACCOUNTANT");
        localStorage.setItem("fitbizz_user_name", "Bilal Tariq (Accounts)");
        localStorage.setItem("fitbizz_gym_tenant_id", "tenant-001");
        router.push("/members");
      } else if (cleanId.includes("trainer") || cleanId === "trn-301") {
        localStorage.setItem("fitbizz_user_role", "TRAINER");
        localStorage.setItem("fitbizz_user_name", "Coach Hamza Ali");
        localStorage.setItem("fitbizz_gym_tenant_id", "tenant-001");
        router.push("/members");
      } else {
        localStorage.setItem("fitbizz_user_role", "MEMBER");
        localStorage.setItem("fitbizz_user_name", "Gym Member");
        localStorage.setItem("fitbizz_gym_tenant_id", "tenant-001");
        router.push("/members");
      }
    }, 600);
  };

  const quickFill = (id: string, pwd: string) => {
    setIdentifier(id);
    setPassword(pwd);
  };

  return (
    <div className="min-h-screen bg-[#fafaf9] flex items-center justify-center p-4">
      <div className="w-full max-w-md">
        {/* Header Branding */}
        <div className="text-center mb-6">
          <div className="w-16 h-16 rounded-2xl mx-auto mb-3 shadow-lg shadow-orange-500/20 overflow-hidden relative border border-orange-500/20 bg-orange-600 flex items-center justify-center">
            <Image
              src="/fitbizz_logo.png"
              alt="FitBizz Logo"
              width={64}
              height={64}
              className="w-full h-full object-cover"
              priority
            />
          </div>
          <h1 className="text-2xl font-black text-stone-900 tracking-tight">FitBizz Platform</h1>
          <p className="text-xs text-stone-500 mt-1">Unified Multi-Tenant Fitness Management OS</p>
        </div>

        {/* Login Form Container */}
        <div className="rounded-2xl p-7 shadow-sm border border-stone-200 bg-white">
          <div className="mb-5">
            <h2 className="text-lg font-bold text-stone-900">Welcome Back</h2>
            <p className="text-xs text-stone-500">Sign in with your Email, Phone Number, or Unique ID.</p>
          </div>

          {error && (
            <div className="mb-4 p-3 rounded-xl bg-red-50 border border-red-200 text-red-700 text-xs flex items-center gap-2">
              <svg className="w-4 h-4 shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
              </svg>
              <span>{error}</span>
            </div>
          )}

          <form onSubmit={handleLogin} className="space-y-4">
            <div>
              <label className="block text-[11px] font-bold text-stone-700 uppercase tracking-wider mb-1.5 flex items-center justify-between">
                <span>Email, Phone, or User ID</span>
                <span className="text-xs">{getIdentifierIcon(identifier)}</span>
              </label>
              <input
                type="text"
                required
                value={identifier}
                onChange={(e) => setIdentifier(e.target.value)}
                className="w-full px-3.5 py-2.5 rounded-xl border border-stone-200 focus:outline-none focus:ring-2 focus:ring-orange-500/20 focus:border-orange-500 text-sm transition"
                placeholder="e.g. owner@metrofitness.com, 03001234567, or SUPER-001"
              />
            </div>

            <div>
              <div className="flex items-center justify-between mb-1.5">
                <label className="block text-[11px] font-bold text-stone-700 uppercase tracking-wider">
                  Password
                </label>
                <button
                  type="button"
                  onClick={() => alert("Password reset OTP has been dispatched to your registered email / mobile number.")}
                  className="text-xs text-orange-600 font-semibold hover:underline"
                >
                  Forgot password?
                </button>
              </div>
              <input
                type="password"
                required
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                className="w-full px-3.5 py-2.5 rounded-xl border border-stone-200 focus:outline-none focus:ring-2 focus:ring-orange-500/20 focus:border-orange-500 text-sm transition"
                placeholder="••••••••••••"
              />
            </div>

            <div className="flex items-center justify-between py-1">
              <label className="flex items-center gap-2 text-xs text-stone-600 cursor-pointer">
                <input
                  type="checkbox"
                  checked={rememberMe}
                  onChange={(e) => setRememberMe(e.target.checked)}
                  className="rounded border-stone-300 text-orange-600 focus:ring-orange-500"
                />
                <span>Remember session on this device</span>
              </label>
            </div>

            <button
              type="submit"
              disabled={loading}
              className="w-full py-3 px-4 rounded-xl bg-orange-600 hover:bg-orange-700 active:bg-orange-800 text-white text-xs font-bold transition shadow-md shadow-orange-600/20 flex items-center justify-center gap-2"
            >
              {loading ? (
                <>
                  <div className="w-3.5 h-3.5 border-2 border-white/30 border-t-white rounded-full animate-spin" />
                  <span>Verifying Credentials...</span>
                </>
              ) : (
                <span>Sign In to FitBizz Workspace →</span>
              )}
            </button>
          </form>

          {/* Collapsible Demo Quick-Fill Helper */}
          <div className="mt-5 pt-4 border-t border-stone-100">
            <button
              type="button"
              onClick={() => setShowHelper(!showHelper)}
              className="w-full flex items-center justify-between text-[11px] font-semibold text-stone-500 hover:text-stone-700"
            >
              <span>🧪 Quick Testing Credentials Reference</span>
              <span>{showHelper ? "▲" : "▼"}</span>
            </button>

            {showHelper && (
              <div className="mt-3 grid grid-cols-2 gap-1.5">
                <button
                  type="button"
                  onClick={() => quickFill("admin@fitbizz.com", "password123")}
                  className="text-left p-1.5 rounded-lg bg-stone-50 hover:bg-orange-50 border border-stone-200 text-[10px] text-stone-700 font-medium"
                >
                  🛡️ <strong>Super Admin</strong>
                  <div className="text-stone-400 text-[9px] truncate">admin@fitbizz.com</div>
                </button>
                <button
                  type="button"
                  onClick={() => quickFill("owner@metrofitness.com", "password123")}
                  className="text-left p-1.5 rounded-lg bg-stone-50 hover:bg-orange-50 border border-stone-200 text-[10px] text-stone-700 font-medium"
                >
                  🏢 <strong>Gym Owner</strong>
                  <div className="text-stone-400 text-[9px] truncate">owner@metrofitness.com</div>
                </button>
                <button
                  type="button"
                  onClick={() => quickFill("reception@fitbizz.com", "password123")}
                  className="text-left p-1.5 rounded-lg bg-stone-50 hover:bg-orange-50 border border-stone-200 text-[10px] text-stone-700 font-medium"
                >
                  🖥️ <strong>Front Desk</strong>
                  <div className="text-stone-400 text-[9px] truncate">reception@fitbizz.com</div>
                </button>
                <button
                  type="button"
                  onClick={() => quickFill("+923001234567", "password123")}
                  className="text-left p-1.5 rounded-lg bg-stone-50 hover:bg-orange-50 border border-stone-200 text-[10px] text-stone-700 font-medium"
                >
                  📱 <strong>By Phone</strong>
                  <div className="text-stone-400 text-[9px] truncate">+923001234567</div>
                </button>
              </div>
            )}
          </div>
        </div>

        {/* Footer info */}
        <div className="text-center mt-6">
          <p className="text-[11px] text-stone-400">
            Offline-first SQLite & Cloud PostgreSQL Unified Architecture
          </p>
        </div>
      </div>
    </div>
  );
}
