"use client";

import React, { useState, use } from "react";
import Link from "next/link";

interface GymDetailsProps {
  params: Promise<{ id: string }>;
}

interface MemberPlan {
  id: string;
  name: string;
  durationMonths: number;
  admissionFee: number;
  monthlyFee: number;
  additionalCharges: number;
  hasTrainerSupport: boolean;
  trainerSupportNote?: string;
  hasMealPlan: boolean;
  hasMobileApp: boolean;
  hasLockerAccess: boolean;
  isMultiBranch: boolean;
  badge: string;
  isDefault: boolean;
}

export default function GymDetailsWorkspacePage({ params }: GymDetailsProps) {
  const { id } = use(params);
  const [activeTab, setActiveTab] = useState<"overview" | "branches" | "plans" | "owner" | "subscription" | "features" | "activity">("overview");
  const [toast, setToast] = useState<{ title: string; message: string; type: "success" | "info" | "warning" } | null>(null);

  // Membership Plans State
  const [plans, setPlans] = useState<MemberPlan[]>([
    {
      id: "plan_basic",
      name: "Basic Plan",
      durationMonths: 1,
      admissionFee: 1000,
      monthlyFee: 3500,
      additionalCharges: 0,
      hasTrainerSupport: false,
      hasMealPlan: false,
      hasMobileApp: true,
      hasLockerAccess: true,
      isMultiBranch: false,
      badge: "Default",
      isDefault: true,
    },
    {
      id: "plan_silver",
      name: "Silver Plan",
      durationMonths: 1,
      admissionFee: 1500,
      monthlyFee: 6500,
      additionalCharges: 0,
      hasTrainerSupport: true,
      trainerSupportNote: "Beginner Workout Coaching (First 2 Weeks)",
      hasMealPlan: true,
      hasMobileApp: true,
      hasLockerAccess: true,
      isMultiBranch: false,
      badge: "Popular",
      isDefault: false,
    },
    {
      id: "plan_gold",
      name: "Gold VIP Plan",
      durationMonths: 1,
      admissionFee: 2000,
      monthlyFee: 12000,
      additionalCharges: 0,
      hasTrainerSupport: true,
      trainerSupportNote: "1-on-1 Dedicated Certified Personal Trainer",
      hasMealPlan: true,
      hasMobileApp: true,
      hasLockerAccess: true,
      isMultiBranch: true,
      badge: "VIP Tier",
      isDefault: false,
    },
    {
      id: "plan_quarterly",
      name: "Quarterly Pro Plan",
      durationMonths: 3,
      admissionFee: 1500,
      monthlyFee: 4500,
      additionalCharges: 0,
      hasTrainerSupport: true,
      trainerSupportNote: "Monthly Fitness Assessment & Guidance",
      hasMealPlan: true,
      hasMobileApp: true,
      hasLockerAccess: true,
      isMultiBranch: false,
      badge: "3-Months Saver",
      isDefault: false,
    },
  ]);

  // Plan creation modal state
  const [showPlanModal, setShowPlanModal] = useState(false);
  const [editingPlan, setEditingPlan] = useState<MemberPlan | null>(null);
  const [planForm, setPlanForm] = useState({
    name: "",
    durationMonths: 1,
    isCustomDuration: false,
    customMonths: 2,
    admissionFee: 1000,
    monthlyFee: 3500,
    additionalCharges: 0,
    hasTrainerSupport: false,
    trainerSupportNote: "Beginner Workout Coaching",
    hasMealPlan: false,
    hasMobileApp: true,
    hasLockerAccess: true,
    isMultiBranch: false,
    badge: "Special",
    isDefault: false,
  });

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

  const openNewPlanModal = () => {
    setEditingPlan(null);
    setPlanForm({
      name: "",
      durationMonths: 1,
      isCustomDuration: false,
      customMonths: 2,
      admissionFee: 1000,
      monthlyFee: 3500,
      additionalCharges: 0,
      hasTrainerSupport: false,
      trainerSupportNote: "Beginner Workout Coaching (First 2 Weeks)",
      hasMealPlan: false,
      hasMobileApp: true,
      hasLockerAccess: true,
      isMultiBranch: false,
      badge: "Custom",
      isDefault: false,
    });
    setShowPlanModal(true);
  };

  const openEditPlanModal = (plan: MemberPlan) => {
    setEditingPlan(plan);
    const isCustom = ![1, 3, 6, 12].includes(plan.durationMonths);
    setPlanForm({
      name: plan.name,
      durationMonths: plan.durationMonths,
      isCustomDuration: isCustom,
      customMonths: isCustom ? plan.durationMonths : 2,
      admissionFee: plan.admissionFee,
      monthlyFee: plan.monthlyFee,
      additionalCharges: plan.additionalCharges,
      hasTrainerSupport: plan.hasTrainerSupport,
      trainerSupportNote: plan.trainerSupportNote || "Beginner Workout Coaching",
      hasMealPlan: plan.hasMealPlan,
      hasMobileApp: plan.hasMobileApp,
      hasLockerAccess: plan.hasLockerAccess,
      isMultiBranch: plan.isMultiBranch,
      badge: plan.badge,
      isDefault: plan.isDefault,
    });
    setShowPlanModal(true);
  };

  const handleSavePlan = (e: React.FormEvent) => {
    e.preventDefault();
    if (!planForm.name.trim()) {
      showToast("Error", "Plan Name is required.", "warning");
      return;
    }

    const duration = planForm.isCustomDuration ? Number(planForm.customMonths) : Number(planForm.durationMonths);

    if (editingPlan) {
      setPlans(
        plans.map((p) =>
          p.id === editingPlan.id
            ? {
                ...p,
                name: planForm.name.trim(),
                durationMonths: duration,
                admissionFee: Number(planForm.admissionFee),
                monthlyFee: Number(planForm.monthlyFee),
                additionalCharges: Number(planForm.additionalCharges),
                hasTrainerSupport: planForm.hasTrainerSupport,
                trainerSupportNote: planForm.hasTrainerSupport ? planForm.trainerSupportNote : undefined,
                hasMealPlan: planForm.hasMealPlan,
                hasMobileApp: planForm.hasMobileApp,
                hasLockerAccess: planForm.hasLockerAccess,
                isMultiBranch: planForm.isMultiBranch,
                badge: planForm.badge.trim() || "Active",
                isDefault: planForm.isDefault,
              }
            : planForm.isDefault
            ? { ...p, isDefault: false }
            : p
        )
      );
      showToast("Plan Updated", `Membership package ${planForm.name} has been updated.`);
    } else {
      const newPlan: MemberPlan = {
        id: "plan_" + Date.now(),
        name: planForm.name.trim(),
        durationMonths: duration,
        admissionFee: Number(planForm.admissionFee),
        monthlyFee: Number(planForm.monthlyFee),
        additionalCharges: Number(planForm.additionalCharges),
        hasTrainerSupport: planForm.hasTrainerSupport,
        trainerSupportNote: planForm.hasTrainerSupport ? planForm.trainerSupportNote : undefined,
        hasMealPlan: planForm.hasMealPlan,
        hasMobileApp: planForm.hasMobileApp,
        hasLockerAccess: planForm.hasLockerAccess,
        isMultiBranch: planForm.isMultiBranch,
        badge: planForm.badge.trim() || "Custom",
        isDefault: planForm.isDefault,
      };

      if (planForm.isDefault) {
        setPlans(plans.map((p) => ({ ...p, isDefault: false })).concat(newPlan));
      } else {
        setPlans([...plans, newPlan]);
      }
      showToast("Plan Created", `New package ${planForm.name} added to your gym.`);
    }

    setShowPlanModal(false);
  };

  const handleDeletePlan = (id: string, name: string) => {
    if (plans.length <= 1) {
      showToast("Cannot Delete", "You must keep at least one membership package.", "warning");
      return;
    }
    setPlans(plans.filter((p) => p.id !== id));
    showToast("Plan Deleted", `Removed ${name} from active packages.`);
  };

  const handleSetDefault = (id: string, name: string) => {
    setPlans(plans.map((p) => ({ ...p, isDefault: p.id === id })));
    showToast("Default Set", `${name} is now the default package.`);
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
            <div className="w-14 h-14 rounded-2xl bg-orange-600 text-white font-black text-2xl flex items-center justify-center shadow-md shadow-orange-600/20 shrink-0">
              {gymInfo.name.charAt(0)}
            </div>
            <div>
              <div className="flex items-center gap-2">
                <h1 className="text-xl font-black text-stone-900 tracking-tight">{gymInfo.name}</h1>
                <span className="px-2.5 py-0.5 rounded-full text-[11px] font-bold bg-amber-100 text-amber-900 border border-amber-200">
                  {gymInfo.status}
                </span>
              </div>
              <p className="text-xs text-stone-500 font-medium mt-0.5">
                {gymInfo.code} • {gymInfo.city}, {gymInfo.country} • Owner: {gymInfo.ownerName}
              </p>
            </div>
          </div>

          <div className="flex flex-wrap items-center gap-2.5">
            <button
              onClick={copyCredentials}
              className="px-3.5 py-2 rounded-xl bg-stone-100 hover:bg-stone-200 text-stone-700 font-bold text-xs flex items-center gap-1.5 transition"
            >
              <span>📋</span>
              <span>Copy Login Pack</span>
            </button>
            <button
              onClick={sendWhatsApp}
              className="px-3.5 py-2 rounded-xl bg-emerald-600 hover:bg-emerald-700 text-white font-bold text-xs flex items-center gap-1.5 transition shadow-xs"
            >
              <span>💬</span>
              <span>WhatsApp Credentials</span>
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
            { id: "plans", label: `Member Packages (${plans.length})` },
            { id: "branches", label: `Branches (${gymInfo.branches.length})` },
            { id: "owner", label: "Owner & Admin Access" },
            { id: "subscription", label: "Platform SaaS Subscription" },
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

      {/* Tab: Member Packages */}
      {activeTab === "plans" && (
        <div className="space-y-6">
          <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
            <div>
              <h2 className="text-base font-black text-stone-900">Gym Membership Plans & Pricing Tiers</h2>
              <p className="text-xs text-stone-500 mt-0.5">
                Configure tiered monthly rates, admission fees, trainer perks, meal plans, and custom durations.
              </p>
            </div>
            <button
              onClick={openNewPlanModal}
              className="px-4 py-2 rounded-xl bg-orange-600 hover:bg-orange-700 text-white font-bold text-xs flex items-center gap-1.5 shadow-xs shrink-0 self-start sm:self-auto"
            >
              <span>+</span>
              <span>Create New Plan</span>
            </button>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
            {plans.map((p) => {
              const upfront = p.admissionFee + p.monthlyFee * p.durationMonths + p.additionalCharges;
              return (
                <div
                  key={p.id}
                  className={`p-5 rounded-2xl bg-white border flex flex-col justify-between transition shadow-xs ${
                    p.isDefault ? "border-orange-500 ring-2 ring-orange-500/20" : "border-stone-200"
                  }`}
                >
                  <div>
                    <div className="flex items-center justify-between">
                      <h3 className="font-black text-stone-900 text-base">{p.name}</h3>
                      {p.isDefault ? (
                        <span className="px-2 py-0.5 rounded-md bg-orange-600 text-white text-[10px] font-bold">
                          DEFAULT
                        </span>
                      ) : (
                        <span className="px-2 py-0.5 rounded-md bg-stone-100 text-stone-600 text-[10px] font-bold">
                          {p.badge}
                        </span>
                      )}
                    </div>

                    <p className="text-xs text-stone-500 font-medium mt-1">
                      📅 {p.durationMonths === 1 ? "1 Month (Monthly)" : `${p.durationMonths} Months (${p.durationMonths * 30} Days)`}
                    </p>

                    <div className="my-4 p-3 bg-stone-50 rounded-xl border border-stone-200 space-y-1.5 text-xs">
                      <div className="flex justify-between">
                        <span className="text-stone-500">Monthly Rate:</span>
                        <span className="font-bold text-stone-900">Rs {p.monthlyFee.toLocaleString()}/mo</span>
                      </div>
                      <div className="flex justify-between">
                        <span className="text-stone-500">Admission Fee:</span>
                        <span className="font-bold text-stone-900">Rs {p.admissionFee.toLocaleString()}</span>
                      </div>
                      <div className="pt-1.5 border-t border-stone-200 flex justify-between font-black">
                        <span className="text-stone-700">Total Upfront:</span>
                        <span className="text-orange-600">Rs {upfront.toLocaleString()}</span>
                      </div>
                    </div>

                    <div className="space-y-1.5 text-xs">
                      <div className="flex items-center gap-1.5">
                        <span className={p.hasTrainerSupport ? "text-emerald-600 font-bold" : "text-stone-400"}>
                          {p.hasTrainerSupport ? "✓" : "✗"}
                        </span>
                        <span className={p.hasTrainerSupport ? "text-stone-800 font-medium" : "text-stone-400"}>
                          {p.hasTrainerSupport ? (p.trainerSupportNote || "Trainer Support") : "No Personal Trainer"}
                        </span>
                      </div>
                      <div className="flex items-center gap-1.5">
                        <span className={p.hasMealPlan ? "text-emerald-600 font-bold" : "text-stone-400"}>
                          {p.hasMealPlan ? "✓" : "✗"}
                        </span>
                        <span className={p.hasMealPlan ? "text-stone-800 font-medium" : "text-stone-400"}>
                          {p.hasMealPlan ? "Meal & Diet Blueprint" : "Diet Plan Not Included"}
                        </span>
                      </div>
                      <div className="flex items-center gap-1.5">
                        <span className={p.hasMobileApp ? "text-emerald-600 font-bold" : "text-stone-400"}>
                          {p.hasMobileApp ? "✓" : "✗"}
                        </span>
                        <span className="text-stone-800 font-medium">Digital QR Pass</span>
                      </div>
                      <div className="flex items-center gap-1.5">
                        <span className={p.isMultiBranch ? "text-orange-600 font-bold" : "text-stone-400"}>
                          {p.isMultiBranch ? "✓" : "✗"}
                        </span>
                        <span className="text-stone-800 font-medium">
                          {p.isMultiBranch ? "All-Branch Arena Access" : "Single Branch"}
                        </span>
                      </div>
                    </div>
                  </div>

                  <div className="mt-5 pt-3 border-t border-stone-100 flex items-center justify-between gap-2">
                    {!p.isDefault && (
                      <button
                        onClick={() => handleSetDefault(p.id, p.name)}
                        className="px-2.5 py-1.5 rounded-lg text-[11px] font-bold bg-stone-100 hover:bg-stone-200 text-stone-700 transition"
                      >
                        Set Default
                      </button>
                    )}
                    <div className="flex items-center gap-1 ml-auto">
                      <button
                        onClick={() => openEditPlanModal(p)}
                        className="p-1.5 rounded-lg text-stone-500 hover:text-stone-900 hover:bg-stone-100 text-xs font-bold"
                        title="Edit Plan"
                      >
                        ✏️
                      </button>
                      {!p.isDefault && (
                        <button
                          onClick={() => handleDeletePlan(p.id, p.name)}
                          className="p-1.5 rounded-lg text-rose-500 hover:text-rose-700 hover:bg-rose-50 text-xs font-bold"
                          title="Delete Plan"
                        >
                          🗑️
                        </button>
                      )}
                    </div>
                  </div>
                </div>
              );
            })}
          </div>
        </div>
      )}

      {/* Plan Modal (Create & Edit) */}
      {showPlanModal && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/50 backdrop-blur-xs p-4 overflow-y-auto">
          <div className="bg-white rounded-2xl max-w-lg w-full p-6 space-y-4 border border-stone-200 shadow-2xl animate-in fade-in">
            <div className="flex items-center justify-between pb-3 border-b border-stone-200">
              <h3 className="font-black text-stone-900 text-base">
                {editingPlan ? "Edit Membership Package" : "Create New Membership Package"}
              </h3>
              <button
                onClick={() => setShowPlanModal(false)}
                className="text-stone-400 hover:text-stone-700 text-sm font-bold"
              >
                ✕
              </button>
            </div>

            <form onSubmit={handleSavePlan} className="space-y-4">
              <div className="grid grid-cols-2 gap-3">
                <div className="col-span-2 sm:col-span-1">
                  <label className="block text-xs font-bold text-stone-700 mb-1">Plan Name *</label>
                  <input
                    type="text"
                    required
                    placeholder="e.g. Basic, Silver, CrossFit Elite"
                    value={planForm.name}
                    onChange={(e) => setPlanForm({ ...planForm, name: e.target.value })}
                    className="w-full px-3 py-2 rounded-xl border border-stone-300 text-xs font-medium focus:ring-2 focus:ring-orange-500/20 focus:border-orange-600 outline-hidden"
                  />
                </div>
                <div className="col-span-2 sm:col-span-1">
                  <label className="block text-xs font-bold text-stone-700 mb-1">Badge / Tag</label>
                  <input
                    type="text"
                    placeholder="e.g. Popular, VIP"
                    value={planForm.badge}
                    onChange={(e) => setPlanForm({ ...planForm, badge: e.target.value })}
                    className="w-full px-3 py-2 rounded-xl border border-stone-300 text-xs font-medium focus:ring-2 focus:ring-orange-500/20 focus:border-orange-600 outline-hidden"
                  />
                </div>
              </div>

              {/* Spacious Duration Selector */}
              <div>
                <label className="block text-xs font-bold text-stone-700 mb-1.5">Plan Duration & Cycle</label>
                <div className="flex flex-wrap gap-2">
                  {[
                    { months: 1, label: "1 Month" },
                    { months: 3, label: "3 Months" },
                    { months: 6, label: "6 Months" },
                    { months: 12, label: "12 Months" },
                  ].map((d) => (
                    <button
                      key={d.months}
                      type="button"
                      onClick={() => setPlanForm({ ...planForm, isCustomDuration: false, durationMonths: d.months })}
                      className={`px-3 py-2 rounded-xl text-xs font-bold border transition ${
                        !planForm.isCustomDuration && planForm.durationMonths === d.months
                          ? "bg-orange-600 text-white border-orange-600 shadow-xs"
                          : "bg-white text-stone-700 border-stone-300 hover:bg-stone-50"
                      }`}
                    >
                      {d.label}
                    </button>
                  ))}
                  <button
                    type="button"
                    onClick={() => setPlanForm({ ...planForm, isCustomDuration: true })}
                    className={`px-3 py-2 rounded-xl text-xs font-bold border transition ${
                      planForm.isCustomDuration
                        ? "bg-orange-600 text-white border-orange-600 shadow-xs"
                        : "bg-white text-stone-700 border-stone-300 hover:bg-stone-50"
                    }`}
                  >
                    ⚙️ Custom Duration
                  </button>
                </div>

                {planForm.isCustomDuration && (
                  <div className="mt-2.5 p-3 bg-orange-50/60 rounded-xl border border-orange-200">
                    <label className="block text-[11px] font-bold text-orange-950 mb-1">Enter Duration (Months):</label>
                    <input
                      type="number"
                      min={1}
                      max={60}
                      value={planForm.customMonths}
                      onChange={(e) => setPlanForm({ ...planForm, customMonths: Number(e.target.value) })}
                      className="w-full px-3 py-1.5 rounded-lg border border-orange-300 text-xs font-bold text-stone-900 bg-white"
                    />
                  </div>
                )}
              </div>

              {/* Pricing breakdown */}
              <div className="grid grid-cols-2 sm:grid-cols-3 gap-3">
                <div>
                  <label className="block text-xs font-bold text-stone-700 mb-1">Admission Fee (Rs)</label>
                  <input
                    type="number"
                    value={planForm.admissionFee}
                    onChange={(e) => setPlanForm({ ...planForm, admissionFee: Number(e.target.value) })}
                    className="w-full px-3 py-2 rounded-xl border border-stone-300 text-xs font-bold"
                  />
                </div>
                <div>
                  <label className="block text-xs font-bold text-stone-700 mb-1">Monthly Fee (Rs)</label>
                  <input
                    type="number"
                    value={planForm.monthlyFee}
                    onChange={(e) => setPlanForm({ ...planForm, monthlyFee: Number(e.target.value) })}
                    className="w-full px-3 py-2 rounded-xl border border-stone-300 text-xs font-bold"
                  />
                </div>
                <div className="col-span-2 sm:col-span-1">
                  <label className="block text-xs font-bold text-stone-700 mb-1">Extra Charges (Rs)</label>
                  <input
                    type="number"
                    value={planForm.additionalCharges}
                    onChange={(e) => setPlanForm({ ...planForm, additionalCharges: Number(e.target.value) })}
                    className="w-full px-3 py-2 rounded-xl border border-stone-300 text-xs font-bold"
                  />
                </div>
              </div>

              {/* Feature checkboxes */}
              <div className="space-y-2 pt-2 border-t border-stone-200 text-xs">
                <label className="flex items-center gap-2 cursor-pointer">
                  <input
                    type="checkbox"
                    checked={planForm.hasTrainerSupport}
                    onChange={(e) => setPlanForm({ ...planForm, hasTrainerSupport: e.target.checked })}
                    className="rounded text-orange-600"
                  />
                  <span className="font-bold text-stone-800">Trainer Assistance / Coaching Included</span>
                </label>
                {planForm.hasTrainerSupport && (
                  <input
                    type="text"
                    placeholder="Trainer guidance note (e.g. First 2 weeks coaching)"
                    value={planForm.trainerSupportNote}
                    onChange={(e) => setPlanForm({ ...planForm, trainerSupportNote: e.target.value })}
                    className="w-full ml-5 px-3 py-1.5 rounded-lg border border-stone-300 text-xs"
                  />
                )}

                <label className="flex items-center gap-2 cursor-pointer">
                  <input
                    type="checkbox"
                    checked={planForm.hasMealPlan}
                    onChange={(e) => setPlanForm({ ...planForm, hasMealPlan: e.target.checked })}
                    className="rounded text-orange-600"
                  />
                  <span className="font-bold text-stone-800">Personalized Meal / Diet Blueprint Included</span>
                </label>

                <label className="flex items-center gap-2 cursor-pointer">
                  <input
                    type="checkbox"
                    checked={planForm.isMultiBranch}
                    onChange={(e) => setPlanForm({ ...planForm, isMultiBranch: e.target.checked })}
                    className="rounded text-orange-600"
                  />
                  <span className="font-bold text-stone-800">Multi-Branch Arena Access Pass</span>
                </label>
              </div>

              <div className="flex items-center justify-end gap-2 pt-3 border-t border-stone-200">
                <button
                  type="button"
                  onClick={() => setShowPlanModal(false)}
                  className="px-4 py-2 rounded-xl bg-stone-100 hover:bg-stone-200 text-stone-700 font-bold text-xs"
                >
                  Cancel
                </button>
                <button
                  type="submit"
                  className="px-4 py-2 rounded-xl bg-orange-600 hover:bg-orange-700 text-white font-bold text-xs shadow-xs"
                >
                  {editingPlan ? "Save Changes" : "Create Plan"}
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      {/* Tab: Overview */}
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
              <span className="text-xs font-bold text-stone-500 uppercase tracking-wider">Active Packages</span>
              <p className="text-2xl font-black text-orange-600 mt-1">{plans.length}</p>
              <span className="text-[11px] text-stone-500 font-medium mt-2 block">Basic, Silver, Gold</span>
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

      {/* Tab: Branches */}
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

      {/* Tab: Owner */}
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

      {/* Tab: Subscription */}
      {activeTab === "subscription" && (
        <div className="fb-panel p-6 bg-white border border-stone-200 rounded-2xl shadow-xs space-y-4">
          <h3 className="text-sm font-bold text-stone-900">Platform SaaS Subscription</h3>
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

      {/* Tab: Features */}
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
