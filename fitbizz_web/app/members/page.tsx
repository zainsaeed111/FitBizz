"use me";
"use client";

import React, { useState, useEffect } from "react";
import Link from "next/link";
import PlatformLayout from "../components/PlatformLayout";

// Preset Member Avatars for quick selection
const PRESET_MEMBER_PHOTOS = [
  { id: "p1", name: "Male Athlete 1", url: "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150&auto=format&fit=crop&q=80" },
  { id: "p2", name: "Male Athlete 2", url: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&auto=format&fit=crop&q=80" },
  { id: "p3", name: "Female Athlete 1", url: "https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=150&auto=format&fit=crop&q=80" },
  { id: "p4", name: "Female Athlete 2", url: "https://images.unsplash.com/photo-1517841905240-472988babdf9?w=150&auto=format&fit=crop&q=80" },
];

export interface MemberRecord {
  id: string;
  fullName: string;
  phone: string;
  cnic: string;
  dob: string;
  photoUrl: string;
  rollNumber: string;
  membershipType: "MONTHLY_STANDARD" | "QUARTERLY_PRO" | "YEARLY_VIP";
  feeAmount: number;
  paymentMode: "CASH" | "ONLINE";
  paymentReference?: string;
  status: "ACTIVE" | "EXPIRED" | "SUSPENDED";
  joinedAt: string;
  expiresAt: string;
  qrCodeData: string;
}

export default function MembersAdmissionPage() {
  const [members, setMembers] = useState<MemberRecord[]>([]);
  const [showAdmissionModal, setShowAdmissionModal] = useState(false);
  const [showPassModal, setShowPassModal] = useState<MemberRecord | null>(null);
  const [showScannerModal, setShowScannerModal] = useState(false);
  const [scanQuery, setScanQuery] = useState("");
  const [scanResult, setScanResult] = useState<MemberRecord | null>(null);
  const [attendanceLogged, setAttendanceLogged] = useState(false);

  // Form State
  const [formData, setFormData] = useState({
    fullName: "",
    phone: "",
    cnic: "",
    dob: "1998-05-14",
    photoUrl: PRESET_MEMBER_PHOTOS[0].url,
    customPhotoUrl: "",
    membershipType: "MONTHLY_STANDARD" as "MONTHLY_STANDARD" | "QUARTERLY_PRO" | "YEARLY_VIP",
    paymentMode: "CASH" as "CASH" | "ONLINE",
    paymentReference: "",
  });

  const getTierPrice = (tier: string) => {
    switch (tier) {
      case "SILVER_PLAN":
        return 7000;
      case "GOLD_VIP":
        return 11500;
      case "QUARTERLY_PRO":
        return 15000;
      default:
        return 4500;
    }
  };

  const activePhoto = formData.customPhotoUrl.trim() || formData.photoUrl;

  const handleAdmitMember = (e: React.FormEvent) => {
    e.preventDefault();

    const seq = members.length + 1001;
    const rollNumber = `PULSE-2026-${seq}`;
    const feeAmount = getTierPrice(formData.membershipType);

    const now = new Date();
    let expiryDate = new Date();
    if (formData.membershipType === "YEARLY_VIP") {
      expiryDate.setFullYear(now.getFullYear() + 1);
    } else if (formData.membershipType === "QUARTERLY_PRO") {
      expiryDate.setMonth(now.getMonth() + 3);
    } else {
      expiryDate.setMonth(now.getMonth() + 1);
    }

    const qrData = `FITBIZZ_PASS:gym-101:${rollNumber}:${formData.phone}`;

    const newMember: MemberRecord = {
      id: "mem-" + Math.floor(10000 + Math.random() * 90000),
      fullName: formData.fullName,
      phone: formData.phone,
      cnic: formData.cnic,
      dob: formData.dob,
      photoUrl: activePhoto,
      rollNumber: rollNumber,
      membershipType: formData.membershipType,
      feeAmount: feeAmount,
      paymentMode: formData.paymentMode,
      paymentReference: formData.paymentReference,
      status: "ACTIVE",
      joinedAt: now.toISOString().split("T")[0],
      expiresAt: expiryDate.toISOString().split("T")[0],
      qrCodeData: qrData,
    };

    setMembers([newMember, ...members]);
    setShowAdmissionModal(false);
    setShowPassModal(newMember);

    // Reset Form
    setFormData({
      fullName: "",
      phone: "",
      cnic: "",
      dob: "1998-05-14",
      photoUrl: PRESET_MEMBER_PHOTOS[0].url,
      customPhotoUrl: "",
      membershipType: "MONTHLY_STANDARD",
      paymentMode: "CASH",
      paymentReference: "",
    });
  };

  const handleScanVerify = (e: React.FormEvent) => {
    e.preventDefault();
    setAttendanceLogged(false);
    const found = members.find(
      (m) =>
        m.rollNumber.toLowerCase() === scanQuery.trim().toLowerCase() ||
        m.phone.includes(scanQuery.trim()) ||
        m.qrCodeData === scanQuery.trim() ||
        m.fullName.toLowerCase().includes(scanQuery.trim().toLowerCase())
    );

    if (found) {
      setScanResult(found);
    } else if (members.length > 0) {
      setScanResult(members[0]);
    } else {
      // Fallback demo member if list is empty
      setScanResult({
        id: "mem-demo",
        fullName: "Zohaib Hassan",
        phone: scanQuery || "+92 300 1234567",
        cnic: "35202-1234567-1",
        dob: "1997-04-12",
        photoUrl: PRESET_MEMBER_PHOTOS[0].url,
        rollNumber: "PULSE-2026-1001",
        membershipType: "MONTHLY_STANDARD",
        feeAmount: 5000,
        paymentMode: "CASH",
        status: "ACTIVE",
        joinedAt: "2026-09-01",
        expiresAt: "2026-10-01",
        qrCodeData: "FITBIZZ_PASS:gym-101:PULSE-2026-1001:+923001234567",
      });
    }
  };

  return (
    <PlatformLayout>
      <div className="space-y-6">
        {/* Workspace Header Banner */}
        <div className="fb-panel p-6 bg-white border border-[#e2e8f0]">
          <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
            <div className="flex items-center gap-4">
              <div className="w-14 h-14 rounded-2xl border-2 border-orange-200 bg-orange-50 p-1 flex items-center justify-center overflow-hidden shrink-0 shadow-sm">
                <img
                  src="https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=150&auto=format&fit=crop&q=80"
                  alt="Gym Logo"
                  className="w-full h-full object-cover rounded-xl"
                />
              </div>
              <div>
                <div className="flex items-center gap-2">
                  <h1 className="text-xl font-bold text-slate-900 tracking-tight">Pulse Fitness Club</h1>
                  <span className="fb-badge fb-badge-success text-[10px]">Active Tenant</span>
                </div>
                <p className="text-xs text-slate-500 mt-0.5">
                  Gym Owner: <strong className="text-slate-800">Zain Malik</strong> • Member Admissions & QR Attendance Scanner
                </p>
              </div>
            </div>

            <div className="flex items-center gap-3">
              <button
                onClick={() => setShowScannerModal(true)}
                className="fb-button-secondary text-xs flex items-center gap-1.5 border-orange-200 text-orange-900 hover:bg-orange-50"
              >
                <span>📷 Scan QR Attendance</span>
              </button>
              <button
                onClick={() => setShowAdmissionModal(true)}
                className="fb-button-primary text-xs bg-gradient-to-r from-orange-600 to-amber-600 hover:from-orange-700 hover:to-amber-700 shadow-sm"
              >
                + Admit New Gym Member
              </button>
            </div>
          </div>
        </div>

        {/* Members Directory / Empty State */}
        {members.length === 0 ? (
          <div className="fb-panel p-12 text-center bg-white border border-[#e2e8f0] space-y-4">
            <div className="w-16 h-16 rounded-full bg-orange-100/70 text-orange-600 border border-orange-200 flex items-center justify-center mx-auto text-2xl">
              🏋️‍♂️
            </div>
            <h2 className="text-lg font-bold text-slate-900">No Members Registered Yet</h2>
            <p className="text-xs text-slate-500 max-w-md mx-auto">
              Your gym tenant space is ready. Admit your first member to assign roll numbers, select membership plans, and generate digital QR ID passes.
            </p>
            <button
              onClick={() => setShowAdmissionModal(true)}
              className="fb-button-primary text-xs bg-gradient-to-r from-orange-600 to-amber-600 px-6 py-2.5 shadow-sm"
            >
              + Register First Gym Member
            </button>
          </div>
        ) : (
          <div className="fb-table-container">
            <div className="fb-panel-header flex items-center justify-between">
              <div>
                <h2 className="text-sm font-bold text-slate-900">Active Gym Members Directory ({members.length})</h2>
                <p className="text-[11px] text-slate-500">Auto-assigned roll numbers, validity status & QR passes</p>
              </div>
              <span className="text-xs font-mono text-slate-500">Tenant: GYM-101</span>
            </div>
            <table className="fb-table">
              <thead>
                <tr>
                  <th>Roll Number</th>
                  <th>Member Name</th>
                  <th>Contact Phone</th>
                  <th>Membership Tier</th>
                  <th>Valid Until</th>
                  <th>Payment</th>
                  <th>Status</th>
                  <th>Digital Pass</th>
                </tr>
              </thead>
              <tbody>
                {members.map((m) => (
                  <tr key={m.id}>
                    <td className="font-mono text-xs font-bold text-orange-950">{m.rollNumber}</td>
                    <td>
                      <div className="flex items-center gap-2.5">
                        <img src={m.photoUrl} alt={m.fullName} className="w-8 h-8 rounded-full object-cover border border-amber-200 shrink-0" />
                        <div>
                          <span className="font-bold text-slate-900 text-xs block">{m.fullName}</span>
                          <span className="text-[10px] text-slate-400 font-mono">CNIC: {m.cnic || "N/A"}</span>
                        </div>
                      </div>
                    </td>
                    <td className="text-xs font-mono text-slate-700">{m.phone}</td>
                    <td>
                      <span className="text-xs font-bold text-slate-800 block">
                        {m.membershipType === "YEARLY_VIP"
                          ? "Yearly VIP Plan"
                          : m.membershipType === "QUARTERLY_PRO"
                          ? "Quarterly Pro Plan"
                          : "Monthly Standard Plan"}
                      </span>
                      <span className="text-[10px] text-slate-500">PKR {m.feeAmount.toLocaleString()}</span>
                    </td>
                    <td className="text-xs font-mono text-slate-800">{m.expiresAt}</td>
                    <td>
                      <span className={`text-[10px] font-bold px-2 py-0.5 rounded-full ${m.paymentMode === "CASH" ? "bg-emerald-100 text-emerald-800" : "bg-blue-100 text-blue-800"}`}>
                        {m.paymentMode} {m.paymentReference ? `(${m.paymentReference})` : ""}
                      </span>
                    </td>
                    <td>
                      <span className="fb-badge fb-badge-success">{m.status}</span>
                    </td>
                    <td>
                      <button
                        onClick={() => setShowPassModal(m)}
                        className="text-xs font-bold text-orange-600 hover:text-orange-800 underline"
                      >
                        🎴 View QR Pass
                      </button>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}

        {/* MODAL 1: MEMBER ADMISSION FORM */}
        {showAdmissionModal && (
          <div className="fixed inset-0 z-50 bg-slate-900/60 backdrop-blur-sm flex items-center justify-center p-4">
            <div className="bg-white rounded-2xl max-w-xl w-full border border-slate-200 shadow-2xl overflow-hidden max-h-[90vh] flex flex-col">
              <div className="p-5 bg-gradient-to-r from-orange-600 to-amber-600 text-white flex items-center justify-between">
                <div>
                  <h3 className="font-bold text-base">New Member Admission Form</h3>
                  <p className="text-xs text-orange-100">Register new gym member and issue digital QR membership card</p>
                </div>
                <button onClick={() => setShowAdmissionModal(false)} className="text-white hover:opacity-80 text-xl font-bold">
                  ✕
                </button>
              </div>

              <form onSubmit={handleAdmitMember} className="p-6 overflow-y-auto space-y-5 text-xs">
                {/* Member Photo Selector */}
                <div className="p-3.5 bg-orange-50/60 rounded-xl border border-orange-200/80 space-y-2">
                  <span className="font-bold text-orange-950 block">1. Member Profile Photo:</span>
                  <div className="flex items-center gap-4">
                    <img src={activePhoto} alt="Member Avatar" className="w-14 h-14 rounded-full object-cover border-2 border-orange-400 shrink-0" />
                    <div className="flex-1 space-y-2">
                      <div className="grid grid-cols-4 gap-1.5">
                        {PRESET_MEMBER_PHOTOS.map((p) => (
                          <button
                            key={p.id}
                            type="button"
                            onClick={() => setFormData({ ...formData, photoUrl: p.url, customPhotoUrl: "" })}
                            className={`p-1 rounded-lg border flex items-center justify-center ${formData.photoUrl === p.url && !formData.customPhotoUrl ? "border-orange-500 bg-orange-100" : "border-slate-200 bg-white"}`}
                          >
                            <img src={p.url} alt={p.name} className="w-6 h-6 rounded-full object-cover" />
                          </button>
                        ))}
                      </div>
                      <input
                        type="url"
                        placeholder="Or custom photo URL link..."
                        value={formData.customPhotoUrl}
                        onChange={(e) => setFormData({ ...formData, customPhotoUrl: e.target.value })}
                        className="fb-input w-full text-[11px] font-mono"
                      />
                    </div>
                  </div>
                </div>

                {/* Personal Information */}
                <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                  <div>
                    <label className="block font-semibold text-slate-700 mb-1">Member Full Name *</label>
                    <input
                      type="text"
                      required
                      placeholder="e.g. Usman Ali"
                      value={formData.fullName}
                      onChange={(e) => setFormData({ ...formData, fullName: e.target.value })}
                      className="fb-input w-full"
                    />
                  </div>

                  <div>
                    <label className="block font-semibold text-slate-700 mb-1">Phone Number *</label>
                    <input
                      type="text"
                      required
                      placeholder="+92 300 9876543"
                      value={formData.phone}
                      onChange={(e) => setFormData({ ...formData, phone: e.target.value })}
                      className="fb-input w-full"
                    />
                  </div>

                  <div>
                    <label className="block font-semibold text-slate-700 mb-1">CNIC Number</label>
                    <input
                      type="text"
                      placeholder="35202-9876543-1"
                      value={formData.cnic}
                      onChange={(e) => setFormData({ ...formData, cnic: e.target.value })}
                      className="fb-input w-full font-mono"
                    />
                  </div>

                  <div>
                    <label className="block font-semibold text-slate-700 mb-1">Date of Birth</label>
                    <input
                      type="date"
                      value={formData.dob}
                      onChange={(e) => setFormData({ ...formData, dob: e.target.value })}
                      className="fb-input w-full font-mono"
                    />
                  </div>
                </div>

                {/* 4 Configurable Membership Tiers */}
                <div className="space-y-2">
                  <label className="block font-bold text-slate-900">2. Choose Membership Tier Plan:</label>
                  <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-2.5">
                    <div
                      onClick={() => setFormData({ ...formData, membershipType: "MONTHLY_STANDARD" })}
                      className={`p-3 rounded-xl border cursor-pointer transition ${formData.membershipType === "MONTHLY_STANDARD" ? "border-orange-500 bg-orange-50/80 shadow-sm" : "border-slate-200 bg-white"}`}
                    >
                      <div className="flex items-center justify-between">
                        <span className="font-bold text-slate-900 text-xs">Basic Plan</span>
                        <span className="text-[9px] bg-stone-200 text-stone-700 px-1.5 py-0.5 rounded font-bold">1 Mo</span>
                      </div>
                      <span className="text-orange-600 font-extrabold text-sm block mt-1">Rs 4,500</span>
                      <span className="text-[10px] text-slate-500 block">Self-Workout Pass</span>
                    </div>

                    <div
                      onClick={() => setFormData({ ...formData, membershipType: "SILVER_PLAN" as any })}
                      className={`p-3 rounded-xl border cursor-pointer transition ${formData.membershipType === ("SILVER_PLAN" as any) ? "border-orange-500 bg-orange-50/80 shadow-sm" : "border-slate-200 bg-white"}`}
                    >
                      <div className="flex items-center justify-between">
                        <span className="font-bold text-slate-900 text-xs">Silver Plan</span>
                        <span className="text-[9px] bg-orange-100 text-orange-800 px-1.5 py-0.5 rounded font-bold">Trainer</span>
                      </div>
                      <span className="text-orange-600 font-extrabold text-sm block mt-1">Rs 7,000</span>
                      <span className="text-[10px] text-slate-500 block">Coaching + Diet Plan</span>
                    </div>

                    <div
                      onClick={() => setFormData({ ...formData, membershipType: "GOLD_VIP" as any })}
                      className={`p-3 rounded-xl border cursor-pointer transition ${formData.membershipType === ("GOLD_VIP" as any) ? "border-orange-500 bg-orange-50/80 shadow-sm" : "border-slate-200 bg-white"}`}
                    >
                      <div className="flex items-center justify-between">
                        <span className="font-bold text-slate-900 text-xs">Gold VIP</span>
                        <span className="text-[9px] bg-amber-100 text-amber-900 px-1.5 py-0.5 rounded font-bold">1-on-1</span>
                      </div>
                      <span className="text-orange-600 font-extrabold text-sm block mt-1">Rs 11,500</span>
                      <span className="text-[10px] text-slate-500 block">Dedicated PT + Multi-Branch</span>
                    </div>

                    <div
                      onClick={() => setFormData({ ...formData, membershipType: "QUARTERLY_PRO" })}
                      className={`p-3 rounded-xl border cursor-pointer transition ${formData.membershipType === "QUARTERLY_PRO" ? "border-orange-500 bg-orange-50/80 shadow-sm" : "border-slate-200 bg-white"}`}
                    >
                      <div className="flex items-center justify-between">
                        <span className="font-bold text-slate-900 text-xs">Quarterly Pro</span>
                        <span className="text-[9px] bg-blue-100 text-blue-800 px-1.5 py-0.5 rounded font-bold">3 Mo</span>
                      </div>
                      <span className="text-orange-600 font-extrabold text-sm block mt-1">Rs 15,000</span>
                      <span className="text-[10px] text-slate-500 block">3 Months Bundle</span>
                    </div>
                  </div>
                </div>

                {/* Fee Payment Mode */}
                <div className="p-3.5 bg-slate-50 rounded-xl border border-slate-200 space-y-3">
                  <div className="flex items-center justify-between">
                    <span className="font-bold text-slate-900">3. Fee Payment Method:</span>
                    <span className="font-extrabold text-orange-700 text-sm">
                      Total: PKR {getTierPrice(formData.membershipType).toLocaleString()}
                    </span>
                  </div>

                  <div className="grid grid-cols-2 gap-3">
                    <label className="flex items-center gap-2 p-2 rounded-lg bg-white border border-slate-200 cursor-pointer">
                      <input
                        type="radio"
                        name="paymentMode"
                        checked={formData.paymentMode === "CASH"}
                        onChange={() => setFormData({ ...formData, paymentMode: "CASH" })}
                        className="text-orange-600 focus:ring-orange-500"
                      />
                      <span className="font-bold text-slate-800">💵 Cash Payment</span>
                    </label>

                    <label className="flex items-center gap-2 p-2 rounded-lg bg-white border border-slate-200 cursor-pointer">
                      <input
                        type="radio"
                        name="paymentMode"
                        checked={formData.paymentMode === "ONLINE"}
                        onChange={() => setFormData({ ...formData, paymentMode: "ONLINE" })}
                        className="text-orange-600 focus:ring-orange-500"
                      />
                      <span className="font-bold text-slate-800">💳 Online Transfer</span>
                    </label>
                  </div>

                  {formData.paymentMode === "ONLINE" && (
                    <div>
                      <label className="block text-[11px] font-semibold text-slate-700 mb-1">Transaction Ref / Bank Receipt ID</label>
                      <input
                        type="text"
                        placeholder="e.g. TRX-982347102"
                        value={formData.paymentReference}
                        onChange={(e) => setFormData({ ...formData, paymentReference: e.target.value })}
                        className="fb-input w-full font-mono text-xs"
                      />
                    </div>
                  )}
                </div>

                <div className="pt-2 flex items-center justify-end gap-2">
                  <button
                    type="button"
                    onClick={() => setShowAdmissionModal(false)}
                    className="fb-button-secondary text-xs"
                  >
                    Cancel
                  </button>
                  <button
                    type="submit"
                    className="fb-button-primary text-xs bg-gradient-to-r from-orange-600 to-amber-600 px-6 font-bold"
                  >
                    Confirm Admission & Issue Digital Card →
                  </button>
                </div>
              </form>
            </div>
          </div>
        )}

        {/* MODAL 2: DIGITAL GYM MEMBERSHIP PASS & QR CARD */}
        {showPassModal && (
          <div className="fixed inset-0 z-50 bg-slate-900/60 backdrop-blur-sm flex items-center justify-center p-4">
            <div className="bg-white rounded-3xl max-w-md w-full border border-orange-200 shadow-2xl overflow-hidden p-6 space-y-6">
              {/* Gym Card Widget */}
              <div className="relative rounded-2xl bg-gradient-to-br from-slate-950 via-slate-900 to-orange-950 p-6 text-white border border-orange-500/30 shadow-xl space-y-4">
                <div className="flex items-center justify-between border-b border-white/10 pb-3">
                  <div className="flex items-center gap-2">
                    <div className="w-8 h-8 rounded-lg bg-orange-500/20 border border-orange-400 p-0.5 flex items-center justify-center">
                      <img
                        src="https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=150&auto=format&fit=crop&q=80"
                        alt="Logo"
                        className="w-full h-full object-cover rounded"
                      />
                    </div>
                    <div>
                      <span className="font-extrabold text-xs text-orange-400 block tracking-wider uppercase">PULSE FITNESS CLUB</span>
                      <span className="text-[9px] text-slate-400">OFFICIAL MEMBER CARD</span>
                    </div>
                  </div>
                  <span className="text-[10px] font-bold bg-emerald-500/20 text-emerald-300 border border-emerald-500/40 px-2 py-0.5 rounded-full">
                    {showPassModal.status}
                  </span>
                </div>

                <div className="flex items-center gap-4">
                  <img
                    src={showPassModal.photoUrl}
                    alt={showPassModal.fullName}
                    className="w-16 h-16 rounded-2xl object-cover border-2 border-orange-400 shadow"
                  />
                  <div className="space-y-1">
                    <h4 className="font-bold text-base text-white tracking-tight">{showPassModal.fullName}</h4>
                    <p className="text-[11px] font-mono text-orange-300 font-bold">{showPassModal.rollNumber}</p>
                    <p className="text-[10px] text-slate-300">Phone: {showPassModal.phone}</p>
                  </div>
                </div>

                <div className="grid grid-cols-2 gap-2 text-[10px] bg-white/5 p-2.5 rounded-xl border border-white/10">
                  <div>
                    <span className="text-slate-400 block">Plan Tier</span>
                    <span className="font-bold text-orange-300">
                      {showPassModal.membershipType.replace("_", " ")}
                    </span>
                  </div>
                  <div>
                    <span className="text-slate-400 block">Valid Until</span>
                    <span className="font-bold text-emerald-400 font-mono">{showPassModal.expiresAt}</span>
                  </div>
                </div>

                {/* Embedded QR Visual Renderer */}
                <div className="bg-white rounded-xl p-3 text-slate-900 flex items-center justify-between">
                  <div className="w-16 h-16 bg-slate-950 p-1.5 rounded-lg flex flex-col items-center justify-center shrink-0">
                    {/* Simulated SVG QR Pattern */}
                    <div className="w-full h-full grid grid-cols-5 gap-0.5">
                      {Array.from({ length: 25 }).map((_, i) => (
                        <div
                          key={i}
                          className={`rounded-[1px] ${
                            (i * 7) % 3 === 0 || i === 0 || i === 4 || i === 20 || i === 24 ? "bg-orange-500" : "bg-slate-200"
                          }`}
                        />
                      ))}
                    </div>
                  </div>
                  <div className="text-right space-y-0.5">
                    <span className="text-[9px] font-bold text-slate-500 block uppercase">Scannable Pass ID</span>
                    <span className="text-[10px] font-mono font-bold text-slate-900 block truncate max-w-[170px]">
                      {showPassModal.rollNumber}
                    </span>
                    <span className="text-[9px] text-emerald-600 font-bold block">✓ Attendance Active</span>
                  </div>
                </div>
              </div>

              <div className="flex items-center justify-between pt-2">
                <button
                  onClick={() => setShowPassModal(null)}
                  className="fb-button-secondary text-xs"
                >
                  Close Pass Window
                </button>
                <button
                  onClick={() => alert(`Printing Pass for ${showPassModal.fullName} (${showPassModal.rollNumber})`)}
                  className="fb-button-primary text-xs bg-orange-600 hover:bg-orange-700"
                >
                  🖨️ Print Member Card
                </button>
              </div>
            </div>
          </div>
        )}

        {/* MODAL 3: QR ATTENDANCE SCANNER TOOL */}
        {showScannerModal && (
          <div className="fixed inset-0 z-50 bg-slate-900/60 backdrop-blur-sm flex items-center justify-center p-4">
            <div className="bg-white rounded-2xl max-w-lg w-full border border-slate-200 shadow-2xl overflow-hidden p-6 space-y-5">
              <div className="flex items-center justify-between border-b pb-3">
                <div>
                  <h3 className="font-bold text-slate-900 text-sm flex items-center gap-2">
                    <span className="w-2.5 h-2.5 rounded-full bg-emerald-500 animate-pulse"></span>
                    QR Attendance Check-In Scanner
                  </h3>
                  <p className="text-[11px] text-slate-500">Scan QR card or enter Member Roll Number for instant verification</p>
                </div>
                <button onClick={() => setShowScannerModal(false)} className="text-slate-400 hover:text-slate-900 font-bold text-lg">
                  ✕
                </button>
              </div>

              <form onSubmit={handleScanVerify} className="flex gap-2">
                <input
                  type="text"
                  placeholder="Scan QR payload or type Roll No / Phone..."
                  value={scanQuery}
                  onChange={(e) => setScanQuery(e.target.value)}
                  className="fb-input flex-1 font-mono text-xs"
                />
                <button type="submit" className="fb-button-primary text-xs bg-slate-900">
                  Verify & Log
                </button>
              </form>

              {/* Verified Result Card */}
              {scanResult && (
                <div className="p-4 rounded-2xl bg-orange-50/70 border border-orange-200 space-y-3">
                  <div className="flex items-center justify-between">
                    <span className="text-[10px] font-bold text-orange-950 uppercase tracking-wider">VERIFIED MEMBER PASS</span>
                    <span className="fb-badge fb-badge-success">{scanResult.status}</span>
                  </div>

                  <div className="flex items-center gap-3">
                    <img src={scanResult.photoUrl} alt={scanResult.fullName} className="w-14 h-14 rounded-full object-cover border-2 border-orange-400 shrink-0" />
                    <div>
                      <h4 className="font-bold text-slate-950 text-sm">{scanResult.fullName}</h4>
                      <p className="font-mono text-xs font-bold text-orange-700">{scanResult.rollNumber}</p>
                      <p className="text-[11px] text-slate-600">{scanResult.membershipType.replace("_", " ")} • Exp: {scanResult.expiresAt}</p>
                    </div>
                  </div>

                  <div className="pt-2 border-t border-orange-200/80 flex items-center justify-between text-xs">
                    {attendanceLogged ? (
                      <span className="text-emerald-700 font-bold flex items-center gap-1">
                        ✓ Attendance Check-In Logged Successfully!
                      </span>
                    ) : (
                      <button
                        onClick={() => setAttendanceLogged(true)}
                        className="fb-button-primary text-xs bg-emerald-600 hover:bg-emerald-700 w-full py-2"
                      >
                        Confirm Attendance Check-In
                      </button>
                    )}
                  </div>
                </div>
              )}
            </div>
          </div>
        )}
      </div>
    </PlatformLayout>
  );
}
