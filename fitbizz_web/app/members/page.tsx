"use client";

import React, { useState, useEffect } from "react";
import Link from "next/link";
import PlatformLayout from "../components/PlatformLayout";

// Preset Member Avatars for quick selection
const PRESET_MEMBER_PHOTOS = [
  { id: "p1", name: "Male Athlete 1", url: "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200&auto=format&fit=crop&q=80" },
  { id: "p2", name: "Male Athlete 2", url: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200&auto=format&fit=crop&q=80" },
  { id: "p3", name: "Female Athlete 1", url: "https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=200&auto=format&fit=crop&q=80" },
  { id: "p4", name: "Male Athlete 3", url: "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200&auto=format&fit=crop&q=80" },
  { id: "p5", name: "Female Athlete 2", url: "https://images.unsplash.com/photo-1517841905240-472988babdf9?w=200&auto=format&fit=crop&q=80" },
  { id: "p6", name: "Athlete 4", url: "https://images.unsplash.com/photo-1492562080023-ab3db95bfbce?w=200&auto=format&fit=crop&q=80" },
];

export interface MemberRecord {
  id: string;
  fullName: string;
  phone: string;
  cnic: string;
  dob: string;
  photoUrl: string;
  rollNumber: string;
  planId: string;
  planName: string;
  durationMonths: number;
  admissionFee: number;
  monthlyFee: number;
  feeAmount: number; // Total Paid
  paymentMode: "CASH" | "ONLINE" | "WALLET";
  paymentReference?: string;
  cashTendered?: number;
  changeReturned?: number;
  status: "ACTIVE" | "EXPIRED" | "SUSPENDED" | "FROZEN";
  joinedAt: string;
  expiresAt: string;
  qrCodeData: string;
  // Health & Diet Profile
  gender: string;
  bloodGroup: string;
  currentWeightKg?: number;
  targetWeightKg?: number;
  height?: string;
  fitnessGoal: string;
  dietaryPreference: string;
  emergencyContactName?: string;
  emergencyContactPhone?: string;
}

export default function MembersAdmissionPage() {
  const [members, setMembers] = useState<MemberRecord[]>([
    {
      id: "MEM-A819C1",
      rollNumber: "METRO-202609-0001",
      fullName: "Zain Malik",
      phone: "+92 300 1234567",
      cnic: "35202-1234567-1",
      dob: "1996-04-18",
      photoUrl: PRESET_MEMBER_PHOTOS[0].url,
      planId: "plan_silver",
      planName: "Silver Plan",
      durationMonths: 1,
      admissionFee: 1500,
      monthlyFee: 6500,
      feeAmount: 8000,
      paymentMode: "CASH",
      cashTendered: 10000,
      changeReturned: 2000,
      status: "ACTIVE",
      joinedAt: "2026-09-01",
      expiresAt: "2026-10-01",
      qrCodeData: "FITBIZZ_PASS:tenant-001:METRO-202609-0001:+923001234567",
      gender: "Male",
      bloodGroup: "O+",
      currentWeightKg: 78.5,
      targetWeightKg: 74.0,
      height: "5'11\"",
      fitnessGoal: "Muscle Building & Lean Bulk",
      dietaryPreference: "High Protein (160g+)",
      emergencyContactName: "Kamran Malik (Brother)",
      emergencyContactPhone: "+92 321 7654321",
    },
    {
      id: "MEM-B920D2",
      rollNumber: "METRO-202609-0002",
      fullName: "Ayesha Khan",
      phone: "+92 301 9876543",
      cnic: "35201-9876543-2",
      dob: "1999-08-22",
      photoUrl: PRESET_MEMBER_PHOTOS[2].url,
      planId: "plan_gold",
      planName: "Gold VIP Plan",
      durationMonths: 1,
      admissionFee: 2000,
      monthlyFee: 12000,
      feeAmount: 14000,
      paymentMode: "ONLINE",
      paymentReference: "RAAST-TRX-893201",
      status: "ACTIVE",
      joinedAt: "2026-08-15",
      expiresAt: "2026-10-15",
      qrCodeData: "FITBIZZ_PASS:tenant-001:METRO-202609-0002:+923019876543",
      gender: "Female",
      bloodGroup: "A+",
      currentWeightKg: 59.0,
      targetWeightKg: 55.0,
      height: "5'6\"",
      fitnessGoal: "Fat Loss & Core Conditioning",
      dietaryPreference: "Low Carb / High Fiber",
      emergencyContactName: "Farhan Khan (Father)",
      emergencyContactPhone: "+92 300 5551234",
    },
    {
      id: "MEM-C103E3",
      rollNumber: "METRO-202609-0003",
      fullName: "Hamza Farooq",
      phone: "+92 302 4455667",
      cnic: "35202-4455667-3",
      dob: "1994-11-05",
      photoUrl: PRESET_MEMBER_PHOTOS[1].url,
      planId: "plan_basic",
      planName: "Basic Plan",
      durationMonths: 1,
      admissionFee: 1000,
      monthlyFee: 3500,
      feeAmount: 4500,
      paymentMode: "CASH",
      cashTendered: 5000,
      changeReturned: 500,
      status: "ACTIVE",
      joinedAt: "2026-09-05",
      expiresAt: "2026-10-05",
      qrCodeData: "FITBIZZ_PASS:tenant-001:METRO-202609-0003:+923024455667",
      gender: "Male",
      bloodGroup: "B+",
      currentWeightKg: 84.0,
      targetWeightKg: 78.0,
      height: "6'0\"",
      fitnessGoal: "General Strength & Cardio",
      dietaryPreference: "Standard Balanced",
    },
  ]);

  const [searchQuery, setSearchQuery] = useState("");
  const [showAdmissionModal, setShowAdmissionModal] = useState(false);
  const [showPassModal, setShowPassModal] = useState<MemberRecord | null>(null);
  const [selectedMemberDetail, setSelectedMemberDetail] = useState<MemberRecord | null>(null);
  const [showUpgradeModal, setShowUpgradeModal] = useState<MemberRecord | null>(null);
  const [showScannerModal, setShowScannerModal] = useState(false);
  const [scanQuery, setScanQuery] = useState("");
  const [scanResult, setScanResult] = useState<MemberRecord | null>(null);
  const [attendanceLogged, setAttendanceLogged] = useState(false);
  const [toast, setToast] = useState<{ title: string; message: string } | null>(null);

  const showNotification = (title: string, message: string) => {
    setToast({ title, message });
    setTimeout(() => setToast(null), 3800);
  };

  // Form State
  const [formData, setFormData] = useState({
    fullName: "",
    phone: "",
    cnic: "",
    dob: "1998-05-14",
    photoUrl: PRESET_MEMBER_PHOTOS[0].url,
    planId: "plan_basic",
    paymentMode: "CASH" as "CASH" | "ONLINE" | "WALLET",
    cashTendered: 4500,
    bankName: "Meezan Bank / Raast",
    paymentReference: "",
    // Health Details
    gender: "Male",
    bloodGroup: "O+",
    currentWeightKg: 75,
    targetWeightKg: 70,
    height: "5'10\"",
    fitnessGoal: "Muscle Building",
    dietaryPreference: "High Protein (Balanced)",
    emergencyContactName: "",
    emergencyContactPhone: "",
    showHealthAccordion: false,
  });

  // Package Configs
  const availablePlans = [
    { id: "plan_basic", name: "Basic Plan", durationMonths: 1, admission: 1000, monthly: 3500, total: 4500, badge: "Default", trainer: false, meal: false },
    { id: "plan_silver", name: "Silver Plan", durationMonths: 1, admission: 1500, monthly: 6500, total: 8000, badge: "Popular", trainer: true, meal: true },
    { id: "plan_gold", name: "Gold VIP Plan", durationMonths: 1, admission: 2000, monthly: 12000, total: 14000, badge: "VIP Tier", trainer: true, meal: true },
    { id: "plan_quarterly", name: "Quarterly Pro Plan", durationMonths: 3, admission: 1500, monthly: 4500, total: 15000, badge: "3-Months Saver", trainer: true, meal: true },
  ];

  const selectedPlanObj = availablePlans.find((p) => p.id === formData.planId) || availablePlans[0];
  const cashChangeDue = (formData.cashTendered || selectedPlanObj.total) >= selectedPlanObj.total
    ? (formData.cashTendered || selectedPlanObj.total) - selectedPlanObj.total
    : 0;

  const [passThemeMode, setPassThemeMode] = useState<"luxuryLight" | "obsidianDark">("luxuryLight");

  const handleAdmitMember = (e: React.FormEvent) => {
    e.preventDefault();

    if (!formData.fullName.trim()) {
      alert("Member Name is required.");
      return;
    }

    const now = new Date();
    const ym = `${now.getFullYear()}${String(now.getMonth() + 1).padStart(2, "0")}`;
    const seq = String(members.length + 1).padStart(4, "0");
    const rollNumber = `METRO-${ym}-${seq}`;
    const memberId = "MEM-" + Math.random().toString(16).substring(2, 8).toUpperCase();

    const expiryDate = new Date();
    expiryDate.setMonth(now.getMonth() + selectedPlanObj.durationMonths);

    const qrData = `FITBIZZ_PASS:tenant-001:${rollNumber}:${formData.phone}`;

    const newMember: MemberRecord = {
      id: memberId,
      fullName: formData.fullName.trim(),
      phone: formData.phone.trim(),
      cnic: formData.cnic.trim(),
      dob: formData.dob,
      photoUrl: formData.photoUrl,
      rollNumber: rollNumber,
      planId: selectedPlanObj.id,
      planName: selectedPlanObj.name,
      durationMonths: selectedPlanObj.durationMonths,
      admissionFee: selectedPlanObj.admission,
      monthlyFee: selectedPlanObj.monthly,
      feeAmount: selectedPlanObj.total,
      paymentMode: formData.paymentMode,
      paymentReference: formData.paymentMode === "CASH" ? undefined : formData.paymentReference,
      cashTendered: formData.paymentMode === "CASH" ? formData.cashTendered : undefined,
      changeReturned: formData.paymentMode === "CASH" ? cashChangeDue : undefined,
      status: "ACTIVE",
      joinedAt: now.toISOString().split("T")[0],
      expiresAt: expiryDate.toISOString().split("T")[0],
      qrCodeData: qrData,
      gender: formData.gender,
      bloodGroup: formData.bloodGroup,
      currentWeightKg: Number(formData.currentWeightKg),
      targetWeightKg: Number(formData.targetWeightKg),
      height: formData.height,
      fitnessGoal: formData.fitnessGoal,
      dietaryPreference: formData.dietaryPreference,
      emergencyContactName: formData.emergencyContactName,
      emergencyContactPhone: formData.emergencyContactPhone,
    };

    setMembers([newMember, ...members]);
    setShowAdmissionModal(false);
    showNotification("Member Admitted Successfully", `Enrolled ${newMember.fullName} (${newMember.rollNumber}) under ${newMember.planName}.`);
    
    // Automatically pop open the Digital QR Pass Card
    setShowPassModal(newMember);

    // Reset Form
    setFormData({
      fullName: "",
      phone: "",
      cnic: "",
      dob: "1998-05-14",
      photoUrl: PRESET_MEMBER_PHOTOS[0].url,
      planId: "plan_basic",
      paymentMode: "CASH",
      cashTendered: 4500,
      bankName: "Meezan Bank / Raast",
      paymentReference: "",
      gender: "Male",
      bloodGroup: "O+",
      currentWeightKg: 75,
      targetWeightKg: 70,
      height: "5'10\"",
      fitnessGoal: "Muscle Building",
      dietaryPreference: "High Protein (Balanced)",
      emergencyContactName: "",
      emergencyContactPhone: "",
      showHealthAccordion: false,
    });
  };

  const handleScanVerify = (e: React.FormEvent) => {
    e.preventDefault();
    setAttendanceLogged(false);
    const clean = scanQuery.trim().toLowerCase();
    const found = members.find(
      (m) =>
        m.rollNumber.toLowerCase() === clean ||
        m.phone.includes(clean) ||
        m.qrCodeData.toLowerCase() === clean ||
        m.fullName.toLowerCase().includes(clean)
    );

    if (found) {
      setScanResult(found);
    } else if (members.length > 0) {
      setScanResult(members[0]);
    }
  };

  const filteredMembers = members.filter((m) => {
    const q = searchQuery.toLowerCase();
    return (
      m.fullName.toLowerCase().includes(q) ||
      m.rollNumber.toLowerCase().includes(q) ||
      m.phone.includes(q) ||
      m.cnic.toLowerCase().includes(q) ||
      m.bloodGroup.toLowerCase().includes(q) ||
      m.planName.toLowerCase().includes(q)
    );
  });

  const sendWhatsAppPass = (member: MemberRecord) => {
    const msg = `🏋️ *FITBIZZ DIGITAL MEMBERSHIP PASS*
━━━━━━━━━━━━━━━━━━━━
🏢 *Gym:* Metro Fitness Club (HQ Arena)
👤 *Member Name:* ${member.fullName}
🆔 *Unique Member ID:* ${member.id}
🔢 *Roll / Pass #:* ${member.rollNumber}
📱 *Phone:* ${member.phone}
🪪 *CNIC:* ${member.cnic || "N/A"}
🩸 *Blood Group:* ${member.bloodGroup || "N/A"}
📦 *Plan:* ${member.planName}
📅 *Valid Until:* ${member.expiresAt}
💵 *Fee Status:* PAID (Rs ${member.feeAmount.toLocaleString()})
🔐 *Pass Code:* ${member.qrCodeData}
━━━━━━━━━━━━━━━━━━━━
Scan QR code at front desk turnstiles for instant admission.`;

    const cleanPhone = member.phone.replace(/[^0-9]/g, "");
    window.open(`https://wa.me/${cleanPhone}?text=${encodeURIComponent(msg)}`, "_blank");
    showNotification("WhatsApp Pass Sent", `Dispatched digital credential pack to ${member.fullName}`);
  };

  return (
    <PlatformLayout>
      {/* Toast Notification */}
      {toast && (
        <div className="fixed top-5 right-5 z-50 p-4 rounded-xl border bg-white border-orange-200 text-stone-900 shadow-xl flex items-center gap-3 animate-in fade-in">
          <div className="w-8 h-8 rounded-lg bg-orange-600 text-white flex items-center justify-center font-bold text-sm">
            ✓
          </div>
          <div>
            <p className="font-bold text-xs">{toast.title}</p>
            <p className="text-[11px] text-stone-600 font-medium">{toast.message}</p>
          </div>
        </div>
      )}

      <div className="space-y-6">
        {/* TOP HEADER WITH SEARCH & ADMISSION BUTTON */}
        <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 bg-white p-6 rounded-2xl border border-stone-200 shadow-xs">
          <div>
            <div className="flex items-center gap-2">
              <span className="p-2 bg-orange-100 text-orange-600 rounded-xl text-lg font-bold">🏋️</span>
              <h1 className="text-2xl font-black text-stone-900 tracking-tight">Member Admissions & Pass Hub</h1>
            </div>
            <p className="text-xs text-stone-500 mt-1">
              Real-time POS fee collection, themed calendar DOB, month-based sequential roll numbers, and digital card generation.
            </p>
          </div>

          <div className="flex items-center gap-2">
            <button
              onClick={() => setShowScannerModal(true)}
              className="px-4 py-2.5 rounded-xl border border-stone-300 hover:bg-stone-50 text-stone-700 font-bold text-xs flex items-center gap-2 transition"
            >
              <span>📷</span>
              <span>Verify QR Pass</span>
            </button>
            <button
              onClick={() => setShowAdmissionModal(true)}
              className="px-5 py-2.5 rounded-xl bg-orange-600 hover:bg-orange-700 text-white font-bold text-xs flex items-center gap-2 shadow-md shadow-orange-600/20 transition"
            >
              <span>➕</span>
              <span>Admit New Member</span>
            </button>
          </div>
        </div>

        {/* SEARCH & FILTER BAR */}
        <div className="flex items-center gap-3 bg-white p-3 rounded-xl border border-stone-200">
          <span className="text-stone-400 pl-2">🔍</span>
          <input
            type="text"
            placeholder="Search members by name, roll number (METRO-202609-0001), phone, or plan..."
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            className="w-full text-xs font-medium focus:outline-hidden text-stone-800 placeholder:text-stone-400"
          />
          {searchQuery && (
            <button onClick={() => setSearchQuery("")} className="text-stone-400 hover:text-stone-600 text-xs px-2">
              Clear
            </button>
          )}
        </div>

        {/* MEMBERS DATA TABLE */}
        <div className="bg-white rounded-2xl border border-stone-200 shadow-xs overflow-hidden">
          <div className="overflow-x-auto">
            <table className="w-full text-left text-xs">
              <thead className="bg-stone-50 text-stone-500 font-bold border-b border-stone-200">
                <tr>
                  <th className="py-3.5 px-4">MEMBER</th>
                  <th className="py-3.5 px-4">ROLL NUMBER & ID</th>
                  <th className="py-3.5 px-4">CONTACT & CNIC</th>
                  <th className="py-3.5 px-4">PLAN & POS PAYMENT</th>
                  <th className="py-3.5 px-4">VALIDITY</th>
                  <th className="py-3.5 px-4">STATUS</th>
                  <th className="py-3.5 px-4 text-right">ACTIONS</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-stone-100 text-stone-700">
                {filteredMembers.map((member) => (
                  <tr key={member.id} className="hover:bg-orange-50/30 transition">
                    <td className="py-3.5 px-4">
                      <div className="flex items-center gap-3">
                        <img
                          src={member.photoUrl}
                          alt={member.fullName}
                          className="w-9 h-9 rounded-full object-cover border border-stone-200"
                        />
                        <div>
                          <div className="font-bold text-stone-900">{member.fullName}</div>
                          <div className="text-[10px] text-stone-400">DOB: {member.dob}</div>
                        </div>
                      </div>
                    </td>
                    <td className="py-3.5 px-4">
                      <div className="font-mono font-bold text-orange-600">{member.rollNumber}</div>
                      <div className="text-[10px] text-stone-400 font-mono">{member.id}</div>
                    </td>
                    <td className="py-3.5 px-4">
                      <div className="font-medium text-stone-800">{member.phone}</div>
                      <div className="text-[10px] text-stone-400 font-mono">{member.cnic || "N/A"}</div>
                    </td>
                    <td className="py-3.5 px-4">
                      <div className="font-bold text-stone-900">{member.planName}</div>
                      <div className="text-[10px] text-emerald-600 font-bold">
                        Rs {member.feeAmount.toLocaleString()} • {member.paymentMode}
                      </div>
                    </td>
                    <td className="py-3.5 px-4">
                      <div className="text-stone-800 font-medium">Exp: {member.expiresAt}</div>
                      <div className="text-[10px] text-stone-400">Joined: {member.joinedAt}</div>
                    </td>
                    <td className="py-3.5 px-4">
                      <span
                        className={`px-2 py-0.5 rounded-full text-[10px] font-bold ${
                          member.status === "ACTIVE"
                            ? "bg-emerald-100 text-emerald-700"
                            : "bg-stone-100 text-stone-600"
                        }`}
                      >
                        {member.status}
                      </span>
                    </td>
                    <td className="py-3.5 px-4 text-right">
                      <div className="flex items-center justify-end gap-1.5">
                        <button
                          onClick={() => setShowPassModal(member)}
                          className="px-2.5 py-1 rounded-lg bg-orange-100 hover:bg-orange-200 text-orange-700 font-bold text-[11px] transition"
                          title="View Digital QR Pass Card"
                        >
                          🎴 Pass
                        </button>
                        <button
                          onClick={() => setSelectedMemberDetail(member)}
                          className="px-2.5 py-1 rounded-lg bg-stone-100 hover:bg-stone-200 text-stone-700 font-bold text-[11px] transition"
                        >
                          Profile
                        </button>
                      </div>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>

        {/* MODAL 1: SUPER SPACIOUS 2-COLUMN ADMISSION MODAL */}
        {showAdmissionModal && (
          <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/60 backdrop-blur-xs p-4 overflow-y-auto animate-in fade-in">
            <div className="bg-white rounded-3xl max-w-4xl w-full p-6 space-y-4 border border-stone-200 shadow-2xl my-6">
              {/* Header */}
              <div className="flex items-center justify-between pb-3 border-b border-stone-200">
                <div className="flex items-center gap-2.5">
                  <div className="w-10 h-10 rounded-xl bg-orange-100 text-orange-600 flex items-center justify-center font-black text-lg">
                    👤+
                  </div>
                  <div>
                    <h3 className="font-black text-stone-900 text-base">Admit New Member & Issue Pass</h3>
                    <p className="text-[11px] text-stone-500">2-Column Executive Form: Configure identity, package, live POS fee, and health metrics</p>
                  </div>
                </div>
                <button
                  onClick={() => setShowAdmissionModal(false)}
                  className="text-stone-400 hover:text-stone-700 text-sm font-bold"
                >
                  ✕
                </button>
              </div>

              <form onSubmit={handleAdmitMember} className="space-y-4 text-xs">
                <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                  {/* LEFT COLUMN: Identity & Health Details */}
                  <div className="space-y-4">
                    {/* 1. Identity & Contact */}
                    <div className="p-4 bg-stone-50 rounded-2xl border border-stone-200 space-y-3">
                      <div className="flex items-center gap-2">
                        <span className="text-orange-600 font-bold">🪪</span>
                        <label className="font-black text-stone-900">1. Personal & Contact Info</label>
                      </div>
                      
                      <div className="space-y-2.5">
                        <div>
                          <label className="block text-stone-600 font-bold mb-1">Full Name *</label>
                          <input
                            type="text"
                            required
                            placeholder="e.g. Usman Ali, Tauseef Ahmed"
                            value={formData.fullName}
                            onChange={(e) => setFormData({ ...formData, fullName: e.target.value })}
                            className="w-full px-3 py-2 rounded-xl border border-stone-300 font-medium bg-white focus:ring-2 focus:ring-orange-500/20 focus:border-orange-600 outline-hidden"
                          />
                        </div>

                        <div className="grid grid-cols-2 gap-2">
                          <div>
                            <label className="block text-stone-600 font-bold mb-1">Phone / WhatsApp *</label>
                            <input
                              type="text"
                              required
                              placeholder="+92 300 1234567"
                              value={formData.phone}
                              onChange={(e) => setFormData({ ...formData, phone: e.target.value })}
                              className="w-full px-3 py-2 rounded-xl border border-stone-300 font-medium bg-white focus:ring-2 focus:ring-orange-500/20 focus:border-orange-600 outline-hidden"
                            />
                          </div>
                          <div>
                            <label className="block text-stone-600 font-bold mb-1">CNIC / National ID</label>
                            <input
                              type="text"
                              placeholder="35202-1234567-1"
                              value={formData.cnic}
                              onChange={(e) => setFormData({ ...formData, cnic: e.target.value })}
                              className="w-full px-3 py-2 rounded-xl border border-stone-300 font-medium bg-white focus:ring-2 focus:ring-orange-500/20 focus:border-orange-600 outline-hidden font-mono"
                            />
                          </div>
                        </div>

                        <div>
                          <label className="block text-stone-600 font-bold mb-1">Date of Birth (Themed Calendar)</label>
                          <input
                            type="date"
                            value={formData.dob}
                            onChange={(e) => setFormData({ ...formData, dob: e.target.value })}
                            className="w-full px-3 py-2 rounded-xl border border-stone-300 font-medium bg-white focus:ring-2 focus:ring-orange-500/20 focus:border-orange-600 outline-hidden font-mono"
                          />
                        </div>
                      </div>
                    </div>

                    {/* 2. Health & Fitness Profile */}
                    <div className="p-4 bg-stone-50 rounded-2xl border border-stone-200 space-y-3">
                      <div className="flex items-center gap-2">
                        <span className="text-orange-600 font-bold">🏋️</span>
                        <label className="font-black text-stone-900">2. Health & Fitness Metrics (Optional)</label>
                      </div>

                      {/* Avatar Selector */}
                      <div>
                        <label className="block text-stone-600 font-bold mb-1">Choose Member Avatar:</label>
                        <div className="flex gap-2">
                          {PRESET_MEMBER_PHOTOS.map((p) => (
                            <img
                              key={p.id}
                              src={p.url}
                              alt={p.name}
                              onClick={() => setFormData({ ...formData, photoUrl: p.url })}
                              className={`w-9 h-9 rounded-full object-cover cursor-pointer border-2 transition ${
                                formData.photoUrl === p.url ? "border-orange-600 scale-110 shadow-xs" : "border-transparent opacity-70"
                              }`}
                            />
                          ))}
                        </div>
                      </div>

                      <div className="grid grid-cols-3 gap-2">
                        <div>
                          <label className="block text-stone-600 font-bold mb-1">Gender</label>
                          <select
                            value={formData.gender}
                            onChange={(e) => setFormData({ ...formData, gender: e.target.value })}
                            className="w-full px-2.5 py-1.5 rounded-xl border border-stone-300 font-medium bg-white"
                          >
                            <option>Male</option>
                            <option>Female</option>
                            <option>Other</option>
                          </select>
                        </div>
                        <div>
                          <label className="block text-stone-600 font-bold mb-1">Blood Group</label>
                          <select
                            value={formData.bloodGroup}
                            onChange={(e) => setFormData({ ...formData, bloodGroup: e.target.value })}
                            className="w-full px-2.5 py-1.5 rounded-xl border border-stone-300 font-medium bg-white"
                          >
                            <option>O+</option>
                            <option>A+</option>
                            <option>B+</option>
                            <option>AB+</option>
                            <option>O-</option>
                            <option>A-</option>
                            <option>B-</option>
                            <option>AB-</option>
                          </select>
                        </div>
                        <div>
                          <label className="block text-stone-600 font-bold mb-1">Height</label>
                          <input
                            type="text"
                            placeholder="5'10 in"
                            value={formData.height}
                            onChange={(e) => setFormData({ ...formData, height: e.target.value })}
                            className="w-full px-2.5 py-1.5 rounded-xl border border-stone-300 font-medium bg-white"
                          />
                        </div>
                      </div>

                      <div className="grid grid-cols-2 gap-2">
                        <div>
                          <label className="block text-stone-600 font-bold mb-1">Current Weight (kg)</label>
                          <input
                            type="number"
                            value={formData.currentWeightKg}
                            onChange={(e) => setFormData({ ...formData, currentWeightKg: Number(e.target.value) })}
                            className="w-full px-2.5 py-1.5 rounded-xl border border-stone-300 font-medium bg-white"
                          />
                        </div>
                        <div>
                          <label className="block text-stone-600 font-bold mb-1">Target Weight (kg)</label>
                          <input
                            type="number"
                            value={formData.targetWeightKg}
                            onChange={(e) => setFormData({ ...formData, targetWeightKg: Number(e.target.value) })}
                            className="w-full px-2.5 py-1.5 rounded-xl border border-stone-300 font-medium bg-white"
                          />
                        </div>
                      </div>

                      <div className="grid grid-cols-2 gap-2">
                        <div>
                          <label className="block text-stone-600 font-bold mb-1">Fitness Goal</label>
                          <select
                            value={formData.fitnessGoal}
                            onChange={(e) => setFormData({ ...formData, fitnessGoal: e.target.value })}
                            className="w-full px-2.5 py-1.5 rounded-xl border border-stone-300 font-medium bg-white"
                          >
                            <option>Muscle Building</option>
                            <option>Fat Loss & Cardio</option>
                            <option>Endurance & Agility</option>
                            <option>General Fitness</option>
                          </select>
                        </div>
                        <div>
                          <label className="block text-stone-600 font-bold mb-1">Diet Preference</label>
                          <select
                            value={formData.dietaryPreference}
                            onChange={(e) => setFormData({ ...formData, dietaryPreference: e.target.value })}
                            className="w-full px-2.5 py-1.5 rounded-xl border border-stone-300 font-medium bg-white"
                          >
                            <option>High Protein (Balanced)</option>
                            <option>Keto / Low Carb</option>
                            <option>Standard Gym Diet</option>
                            <option>Vegetarian / Vegan</option>
                          </select>
                        </div>
                      </div>

                      <div className="grid grid-cols-2 gap-2">
                        <input
                          type="text"
                          placeholder="Emergency Contact Name"
                          value={formData.emergencyContactName}
                          onChange={(e) => setFormData({ ...formData, emergencyContactName: e.target.value })}
                          className="px-2.5 py-1.5 rounded-xl border border-stone-300 font-medium bg-white"
                        />
                        <input
                          type="text"
                          placeholder="Emergency Phone #"
                          value={formData.emergencyContactPhone}
                          onChange={(e) => setFormData({ ...formData, emergencyContactPhone: e.target.value })}
                          className="px-2.5 py-1.5 rounded-xl border border-stone-300 font-medium bg-white"
                        />
                      </div>
                    </div>
                  </div>

                  {/* RIGHT COLUMN: Plan Package & POS Settlement */}
                  <div className="space-y-4">
                    {/* 3. Choose Package */}
                    <div className="p-4 bg-stone-50 rounded-2xl border border-stone-200 space-y-3">
                      <div className="flex items-center justify-between">
                        <div className="flex items-center gap-2">
                          <span className="text-orange-600 font-bold">📦</span>
                          <label className="font-black text-stone-900">3. Select Membership Package</label>
                        </div>
                        <span className="text-[10px] bg-orange-100 text-orange-700 font-bold px-2 py-0.5 rounded-md">
                          {selectedPlanObj.badge}
                        </span>
                      </div>

                      <div className="grid grid-cols-2 gap-2">
                        {availablePlans.map((p) => {
                          const isSel = formData.planId === p.id;
                          return (
                            <div
                              key={p.id}
                              onClick={() => {
                                setFormData({
                                  ...formData,
                                  planId: p.id,
                                  cashTendered: p.total,
                                });
                              }}
                              className={`p-3 rounded-xl border cursor-pointer transition flex flex-col justify-between ${
                                isSel ? "border-orange-600 bg-orange-50 ring-2 ring-orange-500/20 shadow-xs" : "border-stone-200 bg-white hover:border-stone-300"
                              }`}
                            >
                              <div>
                                <div className="flex items-center justify-between">
                                  <span className="font-bold text-stone-900">{p.name}</span>
                                  <span className="text-[8px] bg-stone-100 text-stone-600 px-1 py-0.5 rounded font-bold">
                                    {p.durationMonths}m
                                  </span>
                                </div>
                                <span className="text-orange-600 font-black text-sm block mt-1">Rs {p.total.toLocaleString()}</span>
                                <span className="text-[9px] text-stone-500">
                                  Adm: Rs {p.admission} + Rate: Rs {p.monthly}
                                </span>
                              </div>
                              {p.trainer && (
                                <span className="text-[9px] text-emerald-600 font-bold mt-1 block">✓ Trainer Included</span>
                              )}
                            </div>
                          );
                        })}
                      </div>
                    </div>

                    {/* 4. Embedded POS Settlement */}
                    <div className="p-4 bg-stone-50 rounded-2xl border border-stone-200 space-y-3">
                      <div className="flex items-center justify-between">
                        <div className="flex items-center gap-2">
                          <span className="text-orange-600 font-bold">💳</span>
                          <label className="font-black text-stone-900">4. Point of Sale (POS) Settlement</label>
                        </div>
                        <span className="font-black text-orange-600 text-sm">Due: Rs {selectedPlanObj.total.toLocaleString()}</span>
                      </div>

                      <div className="flex gap-2">
                        {[
                          { id: "CASH", label: "💵 Cash (POS)" },
                          { id: "ONLINE", label: "💳 Bank / Raast" },
                          { id: "WALLET", label: "📱 JazzCash/POS" },
                        ].map((mode) => (
                          <button
                            key={mode.id}
                            type="button"
                            onClick={() => setFormData({ ...formData, paymentMode: mode.id as any })}
                            className={`px-3 py-1.5 rounded-xl font-bold border transition text-xs ${
                              formData.paymentMode === mode.id
                                ? "bg-stone-900 text-white border-stone-900 shadow-xs"
                                : "bg-white text-stone-700 border-stone-300 hover:bg-stone-100"
                            }`}
                          >
                            {mode.label}
                          </button>
                        ))}
                      </div>

                      {formData.paymentMode === "CASH" ? (
                        <div className="space-y-2 pt-1">
                          <div className="grid grid-cols-2 gap-2">
                            <div>
                              <label className="block text-stone-600 font-bold mb-1">Cash Received (Rs)</label>
                              <input
                                type="number"
                                value={formData.cashTendered}
                                onChange={(e) => setFormData({ ...formData, cashTendered: Number(e.target.value) })}
                                className="w-full px-3 py-2 rounded-xl border border-stone-300 font-bold text-stone-900 bg-white"
                              />
                            </div>
                            <div className="p-2 bg-emerald-50 border border-emerald-200 rounded-xl flex flex-col justify-center">
                              <span className="text-[10px] font-bold text-emerald-800">Change to Return:</span>
                              <span className="text-base font-black text-emerald-600">Rs {cashChangeDue.toLocaleString()}</span>
                            </div>
                          </div>

                          {/* Quick Cash Suggestions */}
                          <div className="flex flex-wrap gap-1.5 pt-1">
                            <button
                              type="button"
                              onClick={() => setFormData({ ...formData, cashTendered: selectedPlanObj.total })}
                              className="px-2 py-0.5 rounded-lg bg-stone-200 hover:bg-stone-300 text-stone-800 text-[10px] font-bold"
                            >
                              Exact: Rs {selectedPlanObj.total}
                            </button>
                            <button
                              type="button"
                              onClick={() => setFormData({ ...formData, cashTendered: selectedPlanObj.total + 500 })}
                              className="px-2 py-0.5 rounded-lg bg-stone-200 hover:bg-stone-300 text-stone-800 text-[10px] font-bold"
                            >
                              Rs {selectedPlanObj.total + 500}
                            </button>
                            <button
                              type="button"
                              onClick={() => setFormData({ ...formData, cashTendered: 5000 })}
                              className="px-2 py-0.5 rounded-lg bg-stone-200 hover:bg-stone-300 text-stone-800 text-[10px] font-bold"
                            >
                              Rs 5,000
                            </button>
                            <button
                              type="button"
                              onClick={() => setFormData({ ...formData, cashTendered: 10000 })}
                              className="px-2 py-0.5 rounded-lg bg-stone-200 hover:bg-stone-300 text-stone-800 text-[10px] font-bold"
                            >
                              Rs 10,000
                            </button>
                          </div>
                        </div>
                      ) : formData.paymentMode === "ONLINE" ? (
                        <div className="grid grid-cols-2 gap-2 pt-1">
                          <input
                            type="text"
                            placeholder="Bank / Channel Name"
                            value={formData.bankName}
                            onChange={(e) => setFormData({ ...formData, bankName: e.target.value })}
                            className="px-3 py-2 rounded-xl border border-stone-300 font-medium bg-white"
                          />
                          <input
                            type="text"
                            placeholder="Transaction / Receipt Ref #"
                            value={formData.paymentReference}
                            onChange={(e) => setFormData({ ...formData, paymentReference: e.target.value })}
                            className="px-3 py-2 rounded-xl border border-stone-300 font-medium bg-white"
                          />
                        </div>
                      ) : (
                        <div className="pt-1">
                          <input
                            type="text"
                            placeholder="Wallet Mobile # or POS Terminal Auth Code"
                            value={formData.paymentReference}
                            onChange={(e) => setFormData({ ...formData, paymentReference: e.target.value })}
                            className="w-full px-3 py-2 rounded-xl border border-stone-300 font-medium bg-white"
                          />
                        </div>
                      )}
                    </div>
                  </div>
                </div>

                <div className="flex items-center justify-end gap-2 pt-4 border-t border-stone-200">
                  <button
                    type="button"
                    onClick={() => setShowAdmissionModal(false)}
                    className="px-4 py-2 rounded-xl bg-stone-100 hover:bg-stone-200 text-stone-700 font-bold text-xs"
                  >
                    Cancel
                  </button>
                  <button
                    type="submit"
                    className="px-5 py-2.5 rounded-xl bg-orange-600 hover:bg-orange-700 text-white font-black text-xs shadow-md shadow-orange-600/20 flex items-center gap-1.5"
                  >
                    <span>🎴</span>
                    <span>Confirm & Generate Digital Pass</span>
                  </button>
                </div>
              </form>
            </div>
          </div>
        )}

        {/* MODAL 2: STUNNING DIGITAL QR MEMBERSHIP PASS CARD (LUXURY LIGHT / OBSIDIAN VIP WITH PDF/PRINT) */}
        {showPassModal && (
          <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/60 backdrop-blur-sm p-4 animate-in fade-in">
            <div className={`rounded-3xl max-w-lg w-full p-6 border shadow-2xl space-y-5 transition-colors ${
              passThemeMode === "luxuryLight"
                ? "bg-stone-50 border-orange-300 text-stone-900"
                : "bg-[#141312] border-orange-500/40 text-white"
            }`}>
              {/* Modal Top Bar with Theme Switcher */}
              <div className={`flex items-center justify-between pb-3 border-b ${
                passThemeMode === "luxuryLight" ? "border-stone-200" : "border-stone-800"
              }`}>
                <div className="flex items-center gap-2">
                  <span className="text-orange-500 font-black text-lg">🎴</span>
                  <div>
                    <h3 className="font-black text-xs tracking-wider uppercase">FitBizz Universal Digital Pass</h3>
                    <p className={`text-[10px] ${passThemeMode === "luxuryLight" ? "text-stone-500" : "text-stone-400"}`}>
                      Official Member Access Credential
                    </p>
                  </div>
                </div>
                <div className="flex items-center gap-2">
                  {/* Theme Mode Switcher */}
                  <div className="flex bg-stone-200/80 p-0.5 rounded-lg text-[10px] font-bold">
                    <button
                      onClick={() => setPassThemeMode("luxuryLight")}
                      className={`px-2 py-0.5 rounded-md transition ${
                        passThemeMode === "luxuryLight" ? "bg-white text-orange-600 shadow-xs" : "text-stone-600"
                      }`}
                    >
                      👑 Pearl Light
                    </button>
                    <button
                      onClick={() => setPassThemeMode("obsidianDark")}
                      className={`px-2 py-0.5 rounded-md transition ${
                        passThemeMode === "obsidianDark" ? "bg-stone-900 text-white shadow-xs" : "text-stone-600"
                      }`}
                    >
                      🌑 Obsidian Dark
                    </button>
                  </div>

                  <button
                    onClick={() => setShowPassModal(null)}
                    className="text-stone-400 hover:text-stone-700 text-sm font-bold pl-2"
                  >
                    ✕
                  </button>
                </div>
              </div>

              {/* Physical Metallic Pass Card Presentation */}
              <div id="printable-pass-card" className={`p-5 rounded-2xl border shadow-xl space-y-4 relative overflow-hidden transition-all ${
                passThemeMode === "luxuryLight"
                  ? "bg-gradient-to-br from-white via-[#FFF8F0] to-[#F5EBE0] border-amber-300/80 shadow-amber-900/10 text-stone-900"
                  : "bg-gradient-to-br from-[#2A1910] via-[#1C120C] to-[#120B07] border-orange-500/60 shadow-black/40 text-white"
              }`}>
                {/* Microchip Graphic & Brand Header */}
                <div className="flex items-center justify-between">
                  <div>
                    <span className={`font-black text-xs tracking-widest block ${
                      passThemeMode === "luxuryLight" ? "text-amber-950" : "text-white"
                    }`}>
                      METRO FITNESS CLUB
                    </span>
                    <span className="text-[9px] text-emerald-600 font-bold tracking-wider">● MAIN ARENA • ALL ACCESS VIP</span>
                  </div>
                  <div className="w-9 h-7 rounded bg-gradient-to-br from-amber-300 to-amber-600 border border-amber-400 flex items-center justify-center shadow-xs">
                    <div className="w-5 h-4 border border-black/30 rounded-xs" />
                  </div>
                </div>

                {/* Member Details & QR Box */}
                <div className="flex items-center justify-between gap-4">
                  <div className="flex items-center gap-3">
                    <img
                      src={showPassModal.photoUrl}
                      alt={showPassModal.fullName}
                      className="w-14 h-14 rounded-full object-cover border-2 border-orange-500 shadow-md"
                    />
                    <div>
                      <h4 className={`font-black text-base ${
                        passThemeMode === "luxuryLight" ? "text-stone-950" : "text-white"
                      }`}>
                        {showPassModal.fullName}
                      </h4>
                      <p className="font-mono text-orange-600 font-black text-xs">{showPassModal.rollNumber}</p>
                      <p className="font-mono text-stone-400 font-medium text-[9px]">{showPassModal.id}</p>
                      <div className="flex items-center gap-1.5 mt-1">
                        <span className={`px-1.5 py-0.5 rounded text-[9px] font-bold ${
                          passThemeMode === "luxuryLight" ? "bg-amber-100 text-amber-900" : "bg-white/10 text-white"
                        }`}>
                          {showPassModal.planName.toUpperCase()}
                        </span>
                        <span className="px-1.5 py-0.5 rounded bg-red-100 text-red-700 text-[9px] font-bold">
                          🩸 {showPassModal.bloodGroup}
                        </span>
                      </div>
                    </div>
                  </div>

                  {/* QR Box */}
                  <div className="p-2 bg-white rounded-xl shadow-md shrink-0 flex flex-col items-center border border-stone-200">
                    <div className="w-16 h-16 bg-stone-900 rounded flex items-center justify-center text-white font-mono text-[9px] font-bold text-center leading-tight">
                      [QR CODE]<br/>{showPassModal.rollNumber.split("-")[2]}
                    </div>
                  </div>
                </div>

                {/* Footer Metrics */}
                <div className={`pt-3 border-t grid grid-cols-3 gap-2 text-[10px] ${
                  passThemeMode === "luxuryLight" ? "border-amber-200/60" : "border-white/10"
                }`}>
                  <div>
                    <span className="text-stone-400 font-bold block">JOIN DATE</span>
                    <span className={`font-mono font-bold ${
                      passThemeMode === "luxuryLight" ? "text-stone-900" : "text-white"
                    }`}>
                      {showPassModal.joinedAt}
                    </span>
                  </div>
                  <div>
                    <span className="text-stone-400 font-bold block">EXPIRES ON</span>
                    <span className={`font-mono font-bold ${
                      passThemeMode === "luxuryLight" ? "text-stone-900" : "text-white"
                    }`}>
                      {showPassModal.expiresAt}
                    </span>
                  </div>
                  <div>
                    <span className="text-stone-400 font-bold block">FEE STATUS</span>
                    <span className="font-bold text-emerald-600">PAID (Rs {showPassModal.feeAmount.toLocaleString()})</span>
                  </div>
                </div>
              </div>

              {/* Action Buttons: WhatsApp, Print/PDF, and Simulate */}
              <div className="flex flex-wrap gap-2">
                <button
                  onClick={() => sendWhatsAppPass(showPassModal)}
                  className="flex-1 py-2.5 rounded-xl bg-emerald-600 hover:bg-emerald-700 text-white font-bold text-xs flex items-center justify-center gap-1.5 shadow-xs transition"
                >
                  <span>💬</span>
                  <span>WhatsApp Pass</span>
                </button>
                <button
                  onClick={() => window.print()}
                  className="flex-1 py-2.5 rounded-xl bg-stone-800 hover:bg-stone-900 text-white font-bold text-xs flex items-center justify-center gap-1.5 shadow-xs transition"
                >
                  <span>🖨️</span>
                  <span>Print / PDF Pass</span>
                </button>
                <button
                  onClick={() => {
                    setShowPassModal(null);
                    showNotification("Simulated Check-in", `Access granted for ${showPassModal.fullName} at Front Desk Turnstile.`);
                  }}
                  className="flex-1 py-2.5 rounded-xl bg-orange-600 hover:bg-orange-700 text-white font-bold text-xs flex items-center justify-center gap-1.5 shadow-xs transition"
                >
                  <span>⚡</span>
                  <span>Simulate Scan</span>
                </button>
              </div>
            </div>
          </div>
        )}

        {/* MODAL 3: MEMBER 360 PROFILE DRAWER */}
        {selectedMemberDetail && (
          <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/50 backdrop-blur-xs p-4 overflow-y-auto">
            <div className="bg-white rounded-2xl max-w-lg w-full p-6 space-y-4 border border-stone-200 shadow-2xl animate-in fade-in">
              <div className="flex items-center justify-between pb-3 border-b border-stone-200">
                <div className="flex items-center gap-3">
                  <img src={selectedMemberDetail.photoUrl} alt={selectedMemberDetail.fullName} className="w-12 h-12 rounded-full object-cover border-2 border-orange-500" />
                  <div>
                    <h3 className="font-black text-stone-900 text-base">{selectedMemberDetail.fullName}</h3>
                    <p className="text-xs text-stone-500 font-mono">{selectedMemberDetail.rollNumber} • {selectedMemberDetail.gender}</p>
                  </div>
                </div>
                <button onClick={() => setSelectedMemberDetail(null)} className="text-stone-400 hover:text-stone-700 text-sm font-bold">
                  ✕
                </button>
              </div>

              <div className="space-y-3 text-xs">
                <div className="p-3 bg-stone-50 rounded-xl border border-stone-200 space-y-1.5">
                  <span className="font-bold text-stone-900 block">Membership & Financial Status</span>
                  <div className="flex justify-between"><span className="text-stone-500">Plan Tier:</span><span className="font-bold">{selectedMemberDetail.planName}</span></div>
                  <div className="flex justify-between"><span className="text-stone-500">Total Fee Paid:</span><span className="font-bold text-orange-600">Rs {selectedMemberDetail.feeAmount.toLocaleString()}</span></div>
                  <div className="flex justify-between"><span className="text-stone-500">Valid Until:</span><span className="font-mono font-bold">{selectedMemberDetail.expiresAt}</span></div>
                  <div className="flex justify-between"><span className="text-stone-500">Payment Mode:</span><span className="font-bold">{selectedMemberDetail.paymentMode}</span></div>
                </div>

                <div className="p-3 bg-stone-50 rounded-xl border border-stone-200 space-y-1.5">
                  <span className="font-bold text-stone-900 block">Health & Fitness Ledger</span>
                  <div className="flex justify-between"><span className="text-stone-500">Blood Group:</span><span className="font-bold text-rose-600">🩸 {selectedMemberDetail.bloodGroup}</span></div>
                  <div className="flex justify-between"><span className="text-stone-500">Weight (Current / Target):</span><span className="font-bold">{selectedMemberDetail.currentWeightKg || 75} kg / {selectedMemberDetail.targetWeightKg || 70} kg</span></div>
                  <div className="flex justify-between"><span className="text-stone-500">Goal:</span><span className="font-bold">{selectedMemberDetail.fitnessGoal}</span></div>
                  <div className="flex justify-between"><span className="text-stone-500">Dietary Macros:</span><span className="font-bold">{selectedMemberDetail.dietaryPreference}</span></div>
                </div>
              </div>

              <div className="flex gap-2 pt-2 border-t border-stone-200">
                <button
                  onClick={() => {
                    setShowPassModal(selectedMemberDetail);
                    setSelectedMemberDetail(null);
                  }}
                  className="flex-1 py-2 rounded-xl bg-orange-600 text-white font-bold text-xs"
                >
                  🎴 View Pass Card
                </button>
                <button
                  onClick={() => {
                    setMembers(members.filter((m) => m.id !== selectedMemberDetail.id));
                    setSelectedMemberDetail(null);
                    showNotification("Member Deleted", "Removed member profile.");
                  }}
                  className="px-3 py-2 rounded-xl bg-rose-50 text-rose-700 hover:bg-rose-100 font-bold text-xs border border-rose-200"
                >
                  Delete
                </button>
              </div>
            </div>
          </div>
        )}

        {/* MODAL 4: FRONT DESK QR SCANNER SIMULATOR */}
        {showScannerModal && (
          <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/60 backdrop-blur-xs p-4 animate-in fade-in">
            <div className="bg-white rounded-2xl max-w-md w-full p-6 space-y-4 border border-stone-200 shadow-2xl">
              <div className="flex items-center justify-between pb-3 border-b border-stone-200">
                <h3 className="font-black text-stone-900 text-base">📷 Desk QR Attendance Scanner</h3>
                <button onClick={() => setShowScannerModal(false)} className="text-stone-400 hover:text-stone-700 text-sm font-bold">
                  ✕
                </button>
              </div>

              <form onSubmit={handleScanVerify} className="space-y-3">
                <input
                  type="text"
                  required
                  placeholder="Scan QR payload, Roll #, or Phone..."
                  value={scanQuery}
                  onChange={(e) => setScanQuery(e.target.value)}
                  className="w-full px-4 py-2.5 rounded-xl border border-stone-300 font-mono text-xs"
                />
                <button
                  type="submit"
                  className="w-full py-2.5 rounded-xl bg-orange-600 hover:bg-orange-700 text-white font-black text-xs shadow-xs"
                >
                  ⚡ Scan & Check In
                </button>
              </form>

              {scanResult && (
                <div className="p-4 rounded-xl bg-emerald-50 border border-emerald-200 text-xs space-y-2 animate-in fade-in">
                  <div className="flex items-center gap-2.5">
                    <img src={scanResult.photoUrl} alt={scanResult.fullName} className="w-10 h-10 rounded-full object-cover border border-emerald-400" />
                    <div>
                      <span className="font-black text-stone-900 block">{scanResult.fullName}</span>
                      <span className="font-mono text-emerald-700 font-bold">{scanResult.rollNumber} • {scanResult.planName}</span>
                    </div>
                  </div>
                  <div className="pt-2 border-t border-emerald-200 flex justify-between font-bold text-emerald-950">
                    <span>Turnstile Access:</span>
                    <span className="text-emerald-600 font-black">GRANTED ✅</span>
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
