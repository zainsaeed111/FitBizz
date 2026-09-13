"use client";

import React, { useState } from "react";
import Link from "next/link";

interface PlanTier {
  id: string;
  name: string;
  price: string;
  priceNum: number;
  branches: string;
  branchesNum: number;
  membersLimit: string;
  activeTenants: number;
  popular?: boolean;
  featMembers: boolean;
  featAttendance: boolean;
  featExpenses: boolean;
  featMultiBranch: boolean;
  featBiometrics: boolean;
  featTrainer: boolean;
  featCustomerApp: boolean;
  featAi: boolean;
  featWhatsApp: boolean;
  featSla: boolean;
  features: string[];
}

export default function SubscriptionsPage() {
  const [plans, setPlans] = useState<PlanTier[]>([
    {
      id: "starter",
      name: "Starter Business Plan",
      price: "Rs 15,000 / mo",
      priceNum: 15000,
      branches: "1 Physical Location",
      branchesNum: 1,
      membersLimit: "Up to 300 Members",
      activeTenants: 1,
      featMembers: true,
      featAttendance: true,
      featExpenses: true,
      featMultiBranch: false,
      featBiometrics: false,
      featTrainer: false,
      featCustomerApp: false,
      featAi: false,
      featWhatsApp: false,
      featSla: false,
      features: [
        "Membership & Member Registry",
        "QR Attendance & Check-in",
        "Fee Collection & Receipts",
        "Expense Tracking Ledger",
        "Drift SQLite Offline Engine",
      ],
    },
    {
      id: "pro",
      name: "Pro Multi-Branch Plan",
      price: "Rs 35,000 / mo",
      priceNum: 35000,
      branches: "Up to 3 Branches",
      branchesNum: 3,
      membersLimit: "Up to 1,500 Members",
      activeTenants: 1,
      popular: true,
      featMembers: true,
      featAttendance: true,
      featExpenses: true,
      featMultiBranch: true,
      featBiometrics: true,
      featTrainer: true,
      featCustomerApp: true,
      featAi: false,
      featWhatsApp: true,
      featSla: false,
      features: [
        "Everything in Starter",
        "Multi-Branch Centralized Sync",
        "Biometric Turnstile Integration",
        "Trainer Login & Client Rosters",
        "Customer Mobile Pass App",
        "WhatsApp Automated Invoices",
      ],
    },
    {
      id: "enterprise",
      name: "Enterprise Elite Suite",
      price: "Rs 75,000 / mo",
      priceNum: 75000,
      branches: "Unlimited Branches",
      branchesNum: 10,
      membersLimit: "Unlimited Members",
      activeTenants: 0,
      featMembers: true,
      featAttendance: true,
      featExpenses: true,
      featMultiBranch: true,
      featBiometrics: true,
      featTrainer: true,
      featCustomerApp: true,
      featAi: true,
      featWhatsApp: true,
      featSla: true,
      features: [
        "Everything in Pro Plan",
        "AI Member Churn & Attendance Forecast",
        "Multi-City Franchise Operations",
        "Dedicated Server Instance",
        "Custom API & Hardware Webhooks",
        "24/7 Priority VIP Support",
      ],
    },
  ]);

  // Modal / Editor State
  const [showModal, setShowModal] = useState(false);
  const [editingPlanId, setEditingPlanId] = useState<string | null>(null);
  const [planName, setPlanName] = useState("Custom Gym Agreement");
  const [price, setPrice] = useState(45000);
  const [branches, setBranches] = useState(5);
  const [members, setMembers] = useState("Up to 2,000 Members");

  // Feature Toggles
  const [featMembers, setFeatMembers] = useState(true);
  const [featAttendance, setFeatAttendance] = useState(true);
  const [featExpenses, setFeatExpenses] = useState(true);
  const [featMultiBranch, setFeatMultiBranch] = useState(true);
  const [featBiometrics, setFeatBiometrics] = useState(true);
  const [featTrainer, setFeatTrainer] = useState(true);
  const [featCustomerApp, setFeatCustomerApp] = useState(true);
  const [featAi, setFeatAi] = useState(false);
  const [featWhatsApp, setFeatWhatsApp] = useState(true);
  const [featSla, setFeatSla] = useState(false);

  const openCreateModal = () => {
    setEditingPlanId(null);
    setPlanName("Custom Agreement Tier");
    setPrice(45000);
    setBranches(5);
    setMembers("Up to 2,000 Members");
    setFeatMembers(true);
    setFeatAttendance(true);
    setFeatExpenses(true);
    setFeatMultiBranch(true);
    setFeatBiometrics(true);
    setFeatTrainer(true);
    setFeatCustomerApp(true);
    setFeatAi(false);
    setFeatWhatsApp(true);
    setFeatSla(false);
    setShowModal(true);
  };

  const openEditModal = (p: PlanTier) => {
    setEditingPlanId(p.id);
    setPlanName(p.name);
    setPrice(p.priceNum);
    setBranches(p.branchesNum);
    setMembers(p.membersLimit);
    setFeatMembers(p.featMembers);
    setFeatAttendance(p.featAttendance);
    setFeatExpenses(p.featExpenses);
    setFeatMultiBranch(p.featMultiBranch);
    setFeatBiometrics(p.featBiometrics);
    setFeatTrainer(p.featTrainer);
    setFeatCustomerApp(p.featCustomerApp);
    setFeatAi(p.featAi);
    setFeatWhatsApp(p.featWhatsApp);
    setFeatSla(p.featSla);
    setShowModal(true);
  };

  const handleSavePlan = () => {
    if (planName.trim().length < 3) {
      alert("Please enter a valid plan name (min 3 chars).");
      return;
    }
    if (price <= 0) {
      alert("Price must be greater than 0.");
      return;
    }

    const featureList = [
      ...(featMembers ? ["Membership & Member Registry"] : []),
      ...(featAttendance ? ["QR Attendance & Check-in"] : []),
      ...(featExpenses ? ["Expense Tracking Ledger"] : []),
      ...(featMultiBranch ? ["Multi-Branch Centralized Sync"] : []),
      ...(featBiometrics ? ["Biometric Turnstiles Integration"] : []),
      ...(featTrainer ? ["Trainer Login & Client Rosters"] : []),
      ...(featCustomerApp ? ["Customer Mobile Pass App"] : []),
      ...(featAi ? ["AI Member Churn & Attendance Forecast"] : []),
      ...(featWhatsApp ? ["WhatsApp Automated Receipts"] : []),
      ...(featSla ? ["24/7 Priority VIP SLA Support"] : []),
    ];

    if (editingPlanId) {
      setPlans(
        plans.map((p) =>
          p.id === editingPlanId
            ? {
                ...p,
                name: planName.trim(),
                price: `Rs ${price.toLocaleString()} / mo`,
                priceNum: price,
                branches: branches >= 10 ? "Unlimited Branches" : `${branches} Location(s)`,
                branchesNum: branches,
                membersLimit: members,
                featMembers,
                featAttendance,
                featExpenses,
                featMultiBranch,
                featBiometrics,
                featTrainer,
                featCustomerApp,
                featAi,
                featWhatsApp,
                featSla,
                features: featureList,
              }
            : p
        )
      );
    } else {
      const newTier: PlanTier = {
        id: `custom-${Date.now()}`,
        name: planName.trim(),
        price: `Rs ${price.toLocaleString()} / mo`,
        priceNum: price,
        branches: `${branches} Location(s)`,
        branchesNum: branches,
        membersLimit: members,
        activeTenants: 1,
        featMembers,
        featAttendance,
        featExpenses,
        featMultiBranch,
        featBiometrics,
        featTrainer,
        featCustomerApp,
        featAi,
        featWhatsApp,
        featSla,
        features: featureList,
      };
      setPlans([...plans, newTier]);
    }

    setShowModal(false);
  };

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 pb-4 border-b border-stone-200">
        <div>
          <h1 className="text-xl font-black text-stone-900 tracking-tight">Platform Subscriptions & SaaS Tiers</h1>
          <p className="text-xs text-stone-500 mt-0.5">
            Configure platform pricing plans, feature entitlements, and active tenant subscriptions
          </p>
        </div>
        <div className="flex items-center gap-3">
          <button
            onClick={openCreateModal}
            className="fb-button-primary text-xs flex items-center gap-1.5"
          >
            <span>+</span>
            <span>Build Custom Plan</span>
          </button>
          <Link href="/onboard" className="fb-button-secondary text-xs flex items-center gap-1.5">
            <span>➕</span>
            <span>Onboard Gym Tenant</span>
          </Link>
        </div>
      </div>

      {/* Pricing Cards Grid */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-5">
        {plans.map((plan) => (
          <div
            key={plan.id}
            className={`fb-panel p-6 flex flex-col justify-between space-y-4 relative bg-white transition hover:shadow-md ${
              plan.popular ? "border-orange-500 ring-2 ring-orange-500/20 shadow-sm" : "border-stone-200"
            }`}
          >
            {plan.popular && (
              <span className="absolute -top-3 right-4 bg-orange-600 text-white font-bold text-[10px] px-2.5 py-0.5 rounded-full uppercase tracking-wider shadow-sm">
                Most Popular
              </span>
            )}
            <div>
              <div className="flex items-center justify-between">
                <h3 className="font-bold text-stone-900 text-base">{plan.name}</h3>
                <span className="text-xs px-2 py-0.5 rounded-md bg-stone-100 text-stone-600 font-bold">
                  {plan.branches}
                </span>
              </div>
              <div className="mt-3">
                <span className="text-2xl font-black text-orange-600">{plan.price}</span>
              </div>
              <p className="text-xs text-stone-500 mt-1">{plan.membersLimit}</p>

              <div className="mt-4 pt-4 border-t border-stone-100 space-y-2">
                <p className="text-[11px] font-bold text-stone-700 uppercase tracking-wider">Features Included:</p>
                {plan.features.map((feat, i) => (
                  <div key={i} className="flex items-start gap-2 text-xs text-stone-600">
                    <span className="text-green-600 font-bold shrink-0">✓</span>
                    <span className="break-words">{feat}</span>
                  </div>
                ))}
              </div>
            </div>

            <div className="pt-4 border-t border-stone-100 flex items-center justify-between gap-2">
              <button
                onClick={() => openEditModal(plan)}
                className="fb-button-secondary text-xs py-1 px-3"
              >
                ✏️ Edit Tier
              </button>
              <div className="text-xs text-stone-500">
                Active Gyms: <span className="font-bold text-stone-800">{plan.activeTenants}</span>
              </div>
            </div>
          </div>
        ))}
      </div>

      {/* Plan Editor & Custom Tier Modal */}
      {showModal && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/50 backdrop-blur-xs">
          <div className="bg-white rounded-2xl border border-stone-200 shadow-2xl max-w-lg w-full p-6 space-y-5">
            <div className="flex items-center justify-between border-b border-stone-100 pb-3">
              <div className="flex items-center gap-2">
                <span className="text-xl">✨</span>
                <h3 className="font-bold text-stone-900 text-base">
                  {editingPlanId ? "Edit Subscription Tier" : "Custom Agreement Builder"}
                </h3>
              </div>
              <button
                onClick={() => setShowModal(false)}
                className="text-stone-400 hover:text-stone-600 p-1 text-sm font-bold"
              >
                ✕
              </button>
            </div>

            <div className="space-y-4 text-xs">
              <div>
                <label className="font-bold text-stone-700 block mb-1">Plan / Agreement Name</label>
                <input
                  type="text"
                  value={planName}
                  onChange={(e) => setPlanName(e.target.value)}
                  className="fb-input w-full"
                  placeholder="e.g. VIP Franchise Tier"
                />
              </div>

              <div>
                <div className="flex justify-between items-center mb-1">
                  <label className="font-bold text-stone-700">Monthly Pricing (PKR / Localized)</label>
                  <span className="font-black text-orange-600 text-sm">Rs {price.toLocaleString()} / mo</span>
                </div>
                <input
                  type="range"
                  min={5000}
                  max={150000}
                  step={5000}
                  value={price}
                  onChange={(e) => setPrice(Number(e.target.value))}
                  className="w-full accent-orange-600"
                />
              </div>

              <div>
                <div className="flex justify-between items-center mb-1">
                  <label className="font-bold text-stone-700">Branch License Limit</label>
                  <span className="font-bold text-stone-900">{branches} Location(s)</span>
                </div>
                <input
                  type="range"
                  min={1}
                  max={20}
                  step={1}
                  value={branches}
                  onChange={(e) => setBranches(Number(e.target.value))}
                  className="w-full accent-orange-600"
                />
              </div>

              <div>
                <label className="font-bold text-stone-700 block mb-1">Member Capacity Allocation</label>
                <select
                  value={members}
                  onChange={(e) => setMembers(e.target.value)}
                  className="fb-input w-full"
                >
                  <option value="Up to 300 Members">Up to 300 Members</option>
                  <option value="Up to 1,500 Members">Up to 1,500 Members</option>
                  <option value="5,000 Active Members">5,000 Active Members</option>
                  <option value="Unlimited Members">Unlimited Members</option>
                </select>
              </div>

              <div>
                <label className="font-bold text-stone-700 block mb-2">Granular Module Entitlements</label>
                <div className="grid grid-cols-2 gap-2">
                  <label className="flex items-center gap-2 cursor-pointer bg-stone-50 p-2 rounded-lg border border-stone-200">
                    <input
                      type="checkbox"
                      checked={featMembers}
                      onChange={(e) => setFeatMembers(e.target.checked)}
                      className="accent-orange-600"
                    />
                    <span>Membership Mgmt</span>
                  </label>
                  <label className="flex items-center gap-2 cursor-pointer bg-stone-50 p-2 rounded-lg border border-stone-200">
                    <input
                      type="checkbox"
                      checked={featAttendance}
                      onChange={(e) => setFeatAttendance(e.target.checked)}
                      className="accent-orange-600"
                    />
                    <span>QR Attendance Scan</span>
                  </label>
                  <label className="flex items-center gap-2 cursor-pointer bg-stone-50 p-2 rounded-lg border border-stone-200">
                    <input
                      type="checkbox"
                      checked={featExpenses}
                      onChange={(e) => setFeatExpenses(e.target.checked)}
                      className="accent-orange-600"
                    />
                    <span>Expense Ledger</span>
                  </label>
                  <label className="flex items-center gap-2 cursor-pointer bg-stone-50 p-2 rounded-lg border border-stone-200">
                    <input
                      type="checkbox"
                      checked={featMultiBranch}
                      onChange={(e) => setFeatMultiBranch(e.target.checked)}
                      className="accent-orange-600"
                    />
                    <span>Multi-Branch Sync</span>
                  </label>
                  <label className="flex items-center gap-2 cursor-pointer bg-stone-50 p-2 rounded-lg border border-stone-200">
                    <input
                      type="checkbox"
                      checked={featBiometrics}
                      onChange={(e) => setFeatBiometrics(e.target.checked)}
                      className="accent-orange-600"
                    />
                    <span>Biometric Turnstiles</span>
                  </label>
                  <label className="flex items-center gap-2 cursor-pointer bg-stone-50 p-2 rounded-lg border border-stone-200">
                    <input
                      type="checkbox"
                      checked={featTrainer}
                      onChange={(e) => setFeatTrainer(e.target.checked)}
                      className="accent-orange-600"
                    />
                    <span>Trainer Login & Rosters</span>
                  </label>
                  <label className="flex items-center gap-2 cursor-pointer bg-stone-50 p-2 rounded-lg border border-stone-200">
                    <input
                      type="checkbox"
                      checked={featCustomerApp}
                      onChange={(e) => setFeatCustomerApp(e.target.checked)}
                      className="accent-orange-600"
                    />
                    <span>Customer Mobile Pass</span>
                  </label>
                  <label className="flex items-center gap-2 cursor-pointer bg-stone-50 p-2 rounded-lg border border-stone-200">
                    <input
                      type="checkbox"
                      checked={featAi}
                      onChange={(e) => setFeatAi(e.target.checked)}
                      className="accent-orange-600"
                    />
                    <span>AI Churn Forecast</span>
                  </label>
                  <label className="flex items-center gap-2 cursor-pointer bg-stone-50 p-2 rounded-lg border border-stone-200">
                    <input
                      type="checkbox"
                      checked={featWhatsApp}
                      onChange={(e) => setFeatWhatsApp(e.target.checked)}
                      className="accent-orange-600"
                    />
                    <span>WhatsApp Receipts</span>
                  </label>
                  <label className="flex items-center gap-2 cursor-pointer bg-stone-50 p-2 rounded-lg border border-stone-200">
                    <input
                      type="checkbox"
                      checked={featSla}
                      onChange={(e) => setFeatSla(e.target.checked)}
                      className="accent-orange-600"
                    />
                    <span>24/7 Priority SLA</span>
                  </label>
                </div>
              </div>
            </div>

            <div className="flex justify-end gap-3 pt-3 border-t border-stone-100">
              <button
                type="button"
                onClick={() => setShowModal(false)}
                className="fb-button-secondary text-xs"
              >
                Cancel
              </button>
              <button
                type="button"
                onClick={handleSavePlan}
                className="fb-button-primary text-xs"
              >
                Save Subscription Tier
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
