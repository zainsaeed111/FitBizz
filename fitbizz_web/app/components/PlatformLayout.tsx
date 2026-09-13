"use client";

import React, { useState } from "react";
import Link from "next/link";
import { usePathname, useRouter } from "next/navigation";

interface PlatformLayoutProps {
  children: React.ReactNode;
}

interface NavItem {
  label: string;
  href: string;
  icon: React.ReactNode;
  badge?: string;
}

export default function PlatformLayout({ children }: PlatformLayoutProps) {
  const pathname = usePathname();
  const router = useRouter();
  const [collapsed, setCollapsed] = useState(false);
  const [isDarkMode, setIsDarkMode] = useState(false);
  const [selectedRegion, setSelectedRegion] = useState("PK");

  const isLoginPage = pathname === "/login";
  const isGymWorkspace = pathname.startsWith("/gyms/") && pathname !== "/gyms/create";

  if (isLoginPage) {
    return <div className="min-h-screen bg-[#fafaf9] text-stone-900">{children}</div>;
  }

  // Super Admin Navigation Items (Clean & Synced with Flutter)
  const superAdminNavItems: NavItem[] = [
    {
      label: "Super Admin HQ",
      href: "/",
      icon: (
        <svg className="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1.8} d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6" />
        </svg>
      ),
      badge: "Master",
    },
    {
      label: "Onboard New Gym",
      href: "/onboard",
      icon: (
        <svg className="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1.8} d="M12 4v16m8-8H4" />
        </svg>
      ),
      badge: "Wizard",
    },
    {
      label: "Registered Tenants",
      href: "/gyms",
      icon: (
        <svg className="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1.8} d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5m0 0v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4" />
        </svg>
      ),
    },
    {
      label: "Owners Directory",
      href: "/owners",
      icon: (
        <svg className="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1.8} d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z" />
        </svg>
      ),
    },
    {
      label: "Subscriptions & Plans",
      href: "/subscriptions",
      icon: (
        <svg className="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1.8} d="M3 10h18M7 15h1m4 0h1m-7 4h12a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v8a2 2 0 002 2z" />
        </svg>
      ),
    },
    {
      label: "Gym Settings & POS",
      href: "/settings",
      icon: (
        <svg className="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1.8} d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z" />
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1.8} d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
        </svg>
      ),
    },
  ];

  const gymWorkspaceNavItems: NavItem[] = [
    {
      label: "Gym Dashboard",
      href: pathname,
      icon: (
        <svg className="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1.8} d="M4 6a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2H6a2 2 0 01-2-2V6zM14 6a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2h-2a2 2 0 01-2-2V6zM4 16a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2H6a2 2 0 01-2-2v-2zM14 16a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2h-2a2 2 0 01-2-2v-2z" />
        </svg>
      ),
    },
    {
      label: "Reception Terminal",
      href: `${pathname}#reception`,
      icon: (
        <svg className="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1.8} d="M12 4v1m6 11h2m-6 0h-2v4m0-11v3m0 0h.01M12 12h4.01M16 20h4M4 12h4m12 0h.01M5 8h2a1 1 0 001-1V5a1 1 0 00-1-1H5a1 1 0 00-1 1v2a1 1 0 001 1zm12 0h2a1 1 0 001-1V5a1 1 0 00-1-1h-2a1 1 0 00-1 1v2a1 1 0 001 1zM5 20h2a1 1 0 001-1v-2a1 1 0 00-1-1H5a1 1 0 00-1 1v2a1 1 0 001 1z" />
        </svg>
      ),
    },
    {
      label: "Member Directory",
      href: "/members",
      icon: (
        <svg className="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1.8} d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z" />
        </svg>
      ),
    },
    {
      label: "Attendance & Biometrics",
      href: "/attendance",
      icon: (
        <svg className="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1.8} d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z" />
        </svg>
      ),
      badge: "Live",
    },
    {
      label: "Billing & Invoices",
      href: "/subscriptions",
      icon: (
        <svg className="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1.8} d="M9 14l6-6m-5.5.5h.01m4.99 5h.01M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16l3.5-2 3.5 2 3.5-2 3.5 2zM10 8.5a.5.5 0 11-1 0 .5.5 0 011 0zm5 5a.5.5 0 11-1 0 .5.5 0 011 0z" />
        </svg>
      ),
    },
    {
      label: "Gym Settings & POS",
      href: "/settings",
      icon: (
        <svg className="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1.8} d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z" />
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1.8} d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
        </svg>
      ),
    },
  ];

  const navItems = isGymWorkspace ? gymWorkspaceNavItems : superAdminNavItems;

  return (
    <div className="min-h-screen flex bg-[#fafaf9] text-stone-800">
      {/* Sidebar Navigation */}
      <aside
        className={`${
          collapsed ? "w-20" : "w-64"
        } ${
          isDarkMode ? "bg-stone-900 border-stone-800 text-white" : "bg-white border-stone-200 text-stone-800"
        } border-r flex flex-col transition-all duration-200 sticky top-0 h-screen z-30 shrink-0 shadow-sm`}
      >
        {/* Brand Header */}
        <div
          className={`h-16 px-4 flex items-center justify-between border-b ${
            isDarkMode ? "border-stone-800 bg-stone-950" : "border-stone-200 bg-stone-50/50"
          }`}
        >
          <Link href="/" className="flex items-center gap-3 overflow-hidden">
            <div className="w-9 h-9 rounded-xl overflow-hidden shrink-0 shadow-md border border-orange-500/30 bg-orange-600 p-0.5">
              <img src="/fitbizz_logo.png" alt="FitBizz Logo" className="w-full h-full object-cover rounded-lg" />
            </div>
            {!collapsed && (
              <div className="truncate">
                <span className={`font-black text-sm tracking-tight block ${isDarkMode ? "text-white" : "text-stone-900"}`}>
                  FitBizz
                </span>
                <span className="text-[10px] text-orange-600 font-bold tracking-wider uppercase block">
                  {isGymWorkspace ? "Tenant Portal" : "Super Admin HQ"}
                </span>
              </div>
            )}
          </Link>
          <button
            onClick={() => setCollapsed(!collapsed)}
            className={`p-1.5 rounded transition ${
              isDarkMode ? "text-stone-400 hover:text-white hover:bg-stone-800" : "text-stone-500 hover:text-stone-900 hover:bg-stone-100"
            }`}
            title="Toggle Sidebar"
          >
            <svg className="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d={collapsed ? "M13 5l7 7-7 7M5 5l7 7-7 7" : "M11 19l-7-7 7-7m8 14l-7-7 7-7"} />
            </svg>
          </button>
        </div>

        {/* Role Pill */}
        {!collapsed && (
          <div className="px-3 pt-3">
            <div
              className={`p-2 rounded-xl flex items-center gap-2 border ${
                isDarkMode ? "bg-orange-500/15 border-orange-500/30 text-orange-300" : "bg-orange-50 border-orange-200 text-orange-950"
              }`}
            >
              <span className="text-orange-600 text-xs">🛡️</span>
              <div className="truncate">
                <p className="text-[11px] font-bold truncate">
                  {isGymWorkspace ? "Active Gym Workspace" : "Super Admin (Product Owner)"}
                </p>
                <p className={`text-[9px] truncate ${isDarkMode ? "text-stone-400" : "text-stone-500"}`}>
                  {isGymWorkspace ? "Multi-Branch Active Context" : "Platform Governance & Onboarding"}
                </p>
              </div>
            </div>
          </div>
        )}

        {/* Return to Super Admin HQ Button (when in gym workspace) */}
        {isGymWorkspace && !collapsed && (
          <div className="px-3 pt-2">
            <Link
              href="/"
              className="w-full py-2 px-3 rounded-xl bg-orange-600 hover:bg-orange-700 text-white font-bold text-xs flex items-center justify-center gap-2 shadow-sm transition"
            >
              <span>←</span> Back to Super Admin HQ
            </Link>
          </div>
        )}

        {/* Switch to Gym Owner Workspace (when in Super Admin HQ) */}
        {!isGymWorkspace && !collapsed && (
          <div className="px-3 pt-2">
            <Link
              href="/gyms/tenant-001"
              className={`w-full py-2 px-3 rounded-xl border font-bold text-xs flex items-center justify-between shadow-xs transition ${
                isDarkMode
                  ? "bg-stone-800/80 border-orange-500/30 text-orange-400 hover:bg-stone-800"
                  : "bg-orange-50 border-orange-200 text-orange-950 hover:bg-orange-100"
              }`}
            >
              <span className="flex items-center gap-1.5 truncate">
                <span>🏢</span>
                <span className="truncate">Open Owner Portal</span>
              </span>
              <span className="text-[10px] text-orange-600 font-extrabold">→</span>
            </Link>
          </div>
        )}

        {/* Navigation Links */}
        <div className="flex-1 overflow-y-auto py-4 px-3 space-y-1">
          {navItems.map((item, idx) => {
            const isActive = pathname === item.href || (item.href !== "/" && pathname.startsWith(item.href));
            return (
              <Link
                key={idx}
                href={item.href}
                className={`flex items-center gap-3 px-3 py-2.5 rounded-xl text-xs font-semibold transition ${
                  isActive
                    ? "bg-orange-600 text-white shadow-sm font-bold"
                    : isDarkMode
                    ? "text-stone-300 hover:bg-stone-800 hover:text-white"
                    : "text-stone-700 hover:bg-stone-100 hover:text-stone-900"
                }`}
                title={collapsed ? item.label : undefined}
              >
                <span className="shrink-0">{item.icon}</span>
                {!collapsed && (
                  <div className="flex items-center justify-between flex-1 truncate">
                    <span className="truncate">{item.label}</span>
                    {item.badge && (
                      <span
                        className={`text-[9px] font-bold px-1.5 py-0.5 rounded uppercase ${
                          isActive
                            ? "bg-white/25 text-white"
                            : isDarkMode
                            ? "bg-stone-800 text-orange-400"
                            : "bg-orange-100 text-orange-700"
                        }`}
                      >
                        {item.badge}
                      </span>
                    )}
                  </div>
                )}
              </Link>
            );
          })}
        </div>

        {/* Theme Toggle & User Session Footer */}
        <div
          className={`p-3 border-t space-y-2 ${
            isDarkMode ? "border-stone-800 bg-stone-950" : "border-stone-200 bg-stone-50"
          }`}
        >
          {/* Theme switcher pill */}
          {!collapsed && (
            <div className="flex items-center justify-between px-1 py-1">
              <span className={`text-[10px] font-bold ${isDarkMode ? "text-stone-400" : "text-stone-500"}`}>
                Sidebar Appearance:
              </span>
              <button
                onClick={() => setIsDarkMode(!isDarkMode)}
                className={`flex items-center gap-1.5 px-2 py-1 rounded-md text-[11px] font-bold border transition ${
                  isDarkMode
                    ? "bg-stone-800 border-stone-700 text-amber-300"
                    : "bg-white border-stone-300 text-stone-700 shadow-xs"
                }`}
              >
                {isDarkMode ? "🌙 Dark" : "☀️ Light"}
              </button>
            </div>
          )}

          <div className="flex items-center justify-between">
            <div className="flex items-center gap-2.5 overflow-hidden">
              <div className="w-8 h-8 rounded-full bg-orange-600 flex items-center justify-center text-xs font-black text-white shrink-0">
                SA
              </div>
              {!collapsed && (
                <div className="truncate">
                  <p className={`text-xs font-bold truncate ${isDarkMode ? "text-white" : "text-stone-900"}`}>
                    Super Admin (HQ)
                  </p>
                  <p className={`text-[10px] truncate ${isDarkMode ? "text-stone-400" : "text-stone-500"}`}>
                    admin@fitbizz.com
                  </p>
                </div>
              )}
            </div>
            <Link
              href="/login"
              className={`p-1.5 rounded transition shrink-0 ${
                isDarkMode ? "text-stone-400 hover:text-red-400 hover:bg-stone-800" : "text-stone-500 hover:text-red-600 hover:bg-stone-200"
              }`}
              title="Sign Out"
            >
              <svg className="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1" />
              </svg>
            </Link>
          </div>
        </div>
      </aside>

      {/* Main Workspace Area */}
      <div className="flex-1 flex flex-col min-w-0">
        {/* Top Header */}
        <header className="h-16 bg-white border-b border-stone-200 px-6 flex items-center justify-between sticky top-0 z-20 shadow-xs">
          <div className="flex items-center gap-3">
            <h2 className="text-sm font-bold text-stone-900 tracking-tight">
              {isGymWorkspace ? "🏋️ Gym Tenant Workspace" : "🏢 FitBizz Platform Master HQ"}
            </h2>
          </div>

          <div className="flex items-center gap-3">
            {/* Region / Currency Switcher */}
            <select
              value={selectedRegion}
              onChange={(e) => setSelectedRegion(e.target.value)}
              className="fb-input text-xs py-1 px-2.5 font-bold cursor-pointer"
            >
              <option value="PK">🇵🇰 Pakistan (PKR - Rs)</option>
              <option value="AE">🇦🇪 United Arab Emirates (AED - د.إ)</option>
              <option value="US">🇺🇸 United States (USD - $)</option>
              <option value="GB">🇬🇧 United Kingdom (GBP - £)</option>
              <option value="SA">🇸🇦 Saudi Arabia (SAR - ﷼)</option>
            </select>



            {!isGymWorkspace && (
              <Link
                href="/gyms/tenant-001"
                className="fb-button-secondary text-xs flex items-center gap-1.5 py-1 px-3 border-orange-500 text-orange-600 hover:bg-orange-50"
              >
                <span>🏢</span>
                <span>Open Owner Portal</span>
              </Link>
            )}

            <Link
              href="/onboard"
              className="fb-button-primary text-xs flex items-center gap-1.5 py-1 px-3"
            >
              <span>+</span>
              <span>Onboard Gym</span>
            </Link>
          </div>
        </header>

        {/* Dynamic Page Body */}
        <main className="flex-1 p-6 md:p-8 max-w-7xl w-full mx-auto">{children}</main>
      </div>
    </div>
  );
}
