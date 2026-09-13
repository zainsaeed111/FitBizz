"use client";

import React, { useState } from "react";
import Link from "next/link";
import PlatformLayout from "../components/PlatformLayout";

export default function GymSettingsPage() {
  const [activeTab, setActiveTab] = useState<"profile" | "receipt" | "access" | "sync">("profile");

  // Gym Profile State
  const [gymName, setGymName] = useState("Metro Fitness Club");
  const [branchName, setBranchName] = useState("HQ Arena - Main Campus");
  const [ownerName, setOwnerName] = useState("Zain Malik");
  const [phone, setPhone] = useState("+92 300 1234567");
  const [email, setEmail] = useState("owner@metrofitness.com");
  const [address, setAddress] = useState("Main Boulevard, Block D, Gulberg III");
  const [city, setCity] = useState("Lahore, Pakistan");
  const [taxNumber, setTaxNumber] = useState("NTN: 8932014-7");
  const [currency, setCurrency] = useState("PKR ₨");

  // Thermal Receipt Customizer State
  const [receiptHeader, setReceiptHeader] = useState("METRO FITNESS CLUB");
  const [receiptTagline, setReceiptTagline] = useState("Transform Your Mind, Elevate Your Body");
  const [receiptWidth, setReceiptWidth] = useState<"58mm" | "80mm">("80mm");
  const [showQrCode, setShowQrCode] = useState(true);
  const [showPoweredBy, setShowPoweredBy] = useState(true);
  const [customFooter, setCustomFooter] = useState("Computer-generated POS Tax Receipt\nNo signature required • Non-refundable");
  const [autoPrint, setAutoPrint] = useState(true);
  const [autoWhatsApp, setAutoWhatsApp] = useState(true);

  // Access & Biometric Policy
  const [attendanceMode, setAttendanceMode] = useState<"hybridAll" | "biometricOnly" | "manualOnly">("hybridAll");
  const [geofenceRadius, setGeofenceRadius] = useState(150);
  const [allowSelfCheckIn, setAllowSelfCheckIn] = useState(true);

  // Sync Engine State
  const [apiUrl, setApiUrl] = useState("https://api.fitbizz.cloud/v1");
  const [isSyncing, setIsSyncing] = useState(false);
  const [lastSyncTime, setLastSyncTime] = useState("Just now");
  const [savedSuccess, setSavedSuccess] = useState(false);

  const handleSave = () => {
    setSavedSuccess(true);
    setTimeout(() => setSavedSuccess(false), 3000);
  };

  const handleForceSync = () => {
    setIsSyncing(true);
    setTimeout(() => {
      setIsSyncing(false);
      const now = new Date();
      setLastSyncTime(`Today at ${now.getHours().toString().padStart(2, "0")}:${now.getMinutes().toString().padStart(2, "0")}`);
      setSavedSuccess(true);
      setTimeout(() => setSavedSuccess(false), 3000);
    }, 800);
  };

  return (
    <PlatformLayout>
      <div className="p-6 md:p-8 max-w-7xl mx-auto space-y-6">
        {/* Header Bar */}
        <div className="flex flex-col md:flex-row md:items-center justify-between gap-4 bg-white p-6 rounded-2xl border border-stone-200 shadow-xs">
          <div className="flex items-center gap-4">
            <div className="w-12 h-12 rounded-xl bg-orange-600/10 text-orange-600 flex items-center justify-center text-2xl font-black shrink-0 border border-orange-600/20">
              ⚙️
            </div>
            <div>
              <div className="flex items-center gap-2">
                <h1 className="text-xl md:text-2xl font-black text-stone-900 tracking-tight">
                  Gym Settings & Hardware Hub
                </h1>
                <span className="px-2.5 py-0.5 rounded-full text-[11px] font-bold bg-emerald-50 text-emerald-700 border border-emerald-200 flex items-center gap-1.5">
                  <span className="w-2 h-2 rounded-full bg-emerald-500 animate-pulse" />
                  Cloud Synced
                </span>
              </div>
              <p className="text-xs text-stone-500 font-medium mt-0.5">
                Manage Gym branding, 58mm/80mm POS thermal receipt templates, biometric turnstiles & local SQLite engine
              </p>
            </div>
          </div>

          <div className="flex items-center gap-3">
            <button
              onClick={handleForceSync}
              disabled={isSyncing}
              className="px-4 py-2.5 rounded-xl border border-stone-200 hover:bg-stone-50 text-stone-700 font-bold text-xs flex items-center gap-2 transition shadow-xs"
            >
              <span className={isSyncing ? "animate-spin" : ""}>🔄</span>
              {isSyncing ? "Syncing..." : "Force Sync Now"}
            </button>
            <button
              onClick={handleSave}
              className="px-5 py-2.5 rounded-xl bg-orange-600 hover:bg-orange-700 text-white font-bold text-xs flex items-center gap-2 shadow-sm transition"
            >
              <span>💾</span> Save All Settings
            </button>
          </div>
        </div>

        {/* Success Alert */}
        {savedSuccess && (
          <div className="p-4 rounded-xl bg-emerald-50 border border-emerald-200 text-emerald-800 text-xs font-bold flex items-center gap-2 animate-fade-in">
            <span>✅</span> Settings and POS thermal receipt templates updated across Mobile, Desktop & Web portals.
          </div>
        )}

        {/* Tab Navigation */}
        <div className="flex border-b border-stone-200 bg-white rounded-t-2xl px-6 pt-2 gap-2 overflow-x-auto">
          {[
            { id: "profile", label: "1. Gym Profile & Brand", icon: "🏢" },
            { id: "receipt", label: "2. POS Thermal Receipt Customizer", icon: "🖨️" },
            { id: "access", label: "3. Access & Biometric Policies", icon: "🔒" },
            { id: "sync", label: "4. Cloud & Offline SQLite Sync", icon: "🔄" },
          ].map((tab) => (
            <button
              key={tab.id}
              onClick={() => setActiveTab(tab.id as any)}
              className={`pb-3 pt-2 px-4 font-bold text-xs flex items-center gap-2 border-b-2 transition whitespace-nowrap ${
                activeTab === tab.id
                  ? "border-orange-600 text-orange-600 bg-orange-50/50 rounded-t-lg"
                  : "border-transparent text-stone-500 hover:text-stone-900"
              }`}
            >
              <span>{tab.icon}</span>
              {tab.label}
            </button>
          ))}
        </div>

        {/* Tab 1: Gym Profile */}
        {activeTab === "profile" && (
          <div className="bg-white p-6 md:p-8 rounded-b-2xl border border-stone-200 shadow-xs space-y-6">
            <div>
              <h2 className="text-base font-bold text-stone-900">Gym Identification & Contact Info</h2>
              <p className="text-xs text-stone-500">Displayed on digital passes, invoices, receipts, and mobile member app.</p>
            </div>

            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div>
                <label className="block text-xs font-bold text-stone-700 mb-1">Gym / Business Name</label>
                <input
                  type="text"
                  value={gymName}
                  onChange={(e) => setGymName(e.target.value)}
                  className="w-full p-2.5 text-xs bg-stone-50 border border-stone-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-orange-500"
                />
              </div>

              <div>
                <label className="block text-xs font-bold text-stone-700 mb-1">Branch / Arena Name</label>
                <input
                  type="text"
                  value={branchName}
                  onChange={(e) => setBranchName(e.target.value)}
                  className="w-full p-2.5 text-xs bg-stone-50 border border-stone-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-orange-500"
                />
              </div>

              <div>
                <label className="block text-xs font-bold text-stone-700 mb-1">Owner / Contact Person</label>
                <input
                  type="text"
                  value={ownerName}
                  onChange={(e) => setOwnerName(e.target.value)}
                  className="w-full p-2.5 text-xs bg-stone-50 border border-stone-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-orange-500"
                />
              </div>

              <div>
                <label className="block text-xs font-bold text-stone-700 mb-1">Official Helpline / WhatsApp</label>
                <input
                  type="text"
                  value={phone}
                  onChange={(e) => setPhone(e.target.value)}
                  className="w-full p-2.5 text-xs bg-stone-50 border border-stone-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-orange-500"
                />
              </div>

              <div>
                <label className="block text-xs font-bold text-stone-700 mb-1">Business Email</label>
                <input
                  type="email"
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  className="w-full p-2.5 text-xs bg-stone-50 border border-stone-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-orange-500"
                />
              </div>

              <div>
                <label className="block text-xs font-bold text-stone-700 mb-1">Tax NTN / Registration Number</label>
                <input
                  type="text"
                  value={taxNumber}
                  onChange={(e) => setTaxNumber(e.target.value)}
                  className="w-full p-2.5 text-xs bg-stone-50 border border-stone-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-orange-500"
                />
              </div>

              <div className="md:col-span-2">
                <label className="block text-xs font-bold text-stone-700 mb-1">Street Address</label>
                <input
                  type="text"
                  value={address}
                  onChange={(e) => setAddress(e.target.value)}
                  className="w-full p-2.5 text-xs bg-stone-50 border border-stone-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-orange-500"
                />
              </div>
            </div>

            <div>
              <label className="block text-xs font-bold text-stone-700 mb-2">Operating Currency Symbol:</label>
              <div className="flex flex-wrap gap-2">
                {["PKR ₨", "USD $", "AED", "GBP £"].map((c) => (
                  <button
                    key={c}
                    type="button"
                    onClick={() => setCurrency(c)}
                    className={`px-3 py-1.5 rounded-lg text-xs font-bold border transition ${
                      currency === c
                        ? "bg-orange-600 text-white border-orange-600 shadow-xs"
                        : "bg-stone-50 border-stone-200 text-stone-700 hover:bg-stone-100"
                    }`}
                  >
                    {c}
                  </button>
                ))}
              </div>
            </div>
          </div>
        )}

        {/* Tab 2: POS Thermal Receipt Customizer */}
        {activeTab === "receipt" && (
          <div className="grid grid-cols-1 lg:grid-cols-12 gap-6 items-start">
            {/* Left Column: Form Controls */}
            <div className="lg:col-span-7 bg-white p-6 md:p-8 rounded-2xl border border-stone-200 shadow-xs space-y-5">
              <div>
                <h2 className="text-base font-bold text-stone-900">Thermal POS Slip Layout Customizer</h2>
                <p className="text-xs text-stone-500">Configure headers, width, QR codes, and automated print/WhatsApp dispatch.</p>
              </div>

              <div>
                <label className="block text-xs font-bold text-stone-700 mb-1">Receipt Header Title</label>
                <input
                  type="text"
                  value={receiptHeader}
                  onChange={(e) => setReceiptHeader(e.target.value)}
                  className="w-full p-2.5 text-xs bg-stone-50 border border-stone-200 rounded-xl font-mono focus:outline-none focus:ring-2 focus:ring-orange-500"
                />
              </div>

              <div>
                <label className="block text-xs font-bold text-stone-700 mb-1">Tagline / Slogan (Optional)</label>
                <input
                  type="text"
                  value={receiptTagline}
                  onChange={(e) => setReceiptTagline(e.target.value)}
                  className="w-full p-2.5 text-xs bg-stone-50 border border-stone-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-orange-500"
                />
              </div>

              <div>
                <label className="block text-xs font-bold text-stone-700 mb-2">Paper Roll Width Mode:</label>
                <div className="grid grid-cols-2 gap-3">
                  <div
                    onClick={() => setReceiptWidth("80mm")}
                    className={`p-3 rounded-xl border cursor-pointer transition ${
                      receiptWidth === "80mm"
                        ? "bg-orange-50 border-orange-500 text-orange-950 font-bold shadow-xs"
                        : "bg-stone-50 border-stone-200 text-stone-700 hover:bg-stone-100"
                    }`}
                  >
                    <p className="text-xs font-bold">80mm Standard POS</p>
                    <p className="text-[10px] text-stone-500">Full-width desktop POS printers</p>
                  </div>

                  <div
                    onClick={() => setReceiptWidth("58mm")}
                    className={`p-3 rounded-xl border cursor-pointer transition ${
                      receiptWidth === "58mm"
                        ? "bg-orange-50 border-orange-500 text-orange-950 font-bold shadow-xs"
                        : "bg-stone-50 border-stone-200 text-stone-700 hover:bg-stone-100"
                    }`}
                  >
                    <p className="text-xs font-bold">58mm Compact Mini</p>
                    <p className="text-[10px] text-stone-500">Mobile Bluetooth / handheld terminals</p>
                  </div>
                </div>
              </div>

              <div>
                <label className="block text-xs font-bold text-stone-700 mb-1">Custom Policy / Footer Note</label>
                <textarea
                  rows={2}
                  value={customFooter}
                  onChange={(e) => setCustomFooter(e.target.value)}
                  className="w-full p-2.5 text-xs bg-stone-50 border border-stone-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-orange-500"
                />
              </div>

              <div className="space-y-3 pt-2">
                <label className="flex items-center justify-between p-3 rounded-xl bg-stone-50 border border-stone-200 cursor-pointer">
                  <div>
                    <span className="text-xs font-bold text-stone-800 block">Show QR Code for Verification</span>
                    <span className="text-[10px] text-stone-500 block">Enables instant QR scanner verification of the slip</span>
                  </div>
                  <input
                    type="checkbox"
                    checked={showQrCode}
                    onChange={(e) => setShowQrCode(e.target.checked)}
                    className="w-4 h-4 text-orange-600 rounded border-stone-300 focus:ring-orange-500"
                  />
                </label>

                <label className="flex items-center justify-between p-3 rounded-xl bg-stone-50 border border-stone-200 cursor-pointer">
                  <div>
                    <span className="text-xs font-bold text-stone-800 block">Show "Powered by FitBizz" Footer</span>
                    <span className="text-[10px] text-stone-500 block">Displays official FitBizz Cloud Gym verification badge</span>
                  </div>
                  <input
                    type="checkbox"
                    checked={showPoweredBy}
                    onChange={(e) => setShowPoweredBy(e.target.checked)}
                    className="w-4 h-4 text-orange-600 rounded border-stone-300 focus:ring-orange-500"
                  />
                </label>

                <label className="flex items-center justify-between p-3 rounded-xl bg-stone-50 border border-stone-200 cursor-pointer">
                  <div>
                    <span className="text-xs font-bold text-stone-800 block">Auto-Print Slip on Payment</span>
                    <span className="text-[10px] text-stone-500 block">Instantly prompts printer when fee payment is recorded</span>
                  </div>
                  <input
                    type="checkbox"
                    checked={autoPrint}
                    onChange={(e) => setAutoPrint(e.target.checked)}
                    className="w-4 h-4 text-orange-600 rounded border-stone-300 focus:ring-orange-500"
                  />
                </label>
              </div>
            </div>

            {/* Right Column: Live Interactive Thermal Receipt Preview */}
            <div className="lg:col-span-5 flex flex-col items-center">
              <div className="w-full max-w-[360px]">
                {/* Roll Header Bar */}
                <div className="bg-stone-900 text-white px-4 py-2 rounded-t-xl flex items-center justify-between text-xs font-bold">
                  <span className="flex items-center gap-1.5">
                    <span>🧾</span> LIVE SLIP PREVIEW
                  </span>
                  <span className="px-2 py-0.5 rounded bg-orange-600 text-white text-[10px] font-mono">
                    {receiptWidth}
                  </span>
                </div>

                {/* Thermal Slip Paper Look */}
                <div className="bg-[#fcfcfb] border border-stone-300 p-5 font-mono shadow-md text-stone-900 space-y-3 rounded-b-xl">
                  {/* Gym Header */}
                  <div className="text-center space-y-0.5">
                    <div className="w-8 h-8 rounded-full bg-orange-600/10 text-orange-600 mx-auto flex items-center justify-center text-sm font-bold">
                      🏋️
                    </div>
                    <p className="font-black text-sm tracking-wide uppercase">{receiptHeader}</p>
                    {receiptTagline && <p className="text-[10px] text-stone-600">{receiptTagline}</p>}
                    <p className="text-[9px] text-stone-500">{branchName} • {address}</p>
                    <p className="text-[9px] text-stone-500">{taxNumber} • Ph: {phone}</p>
                  </div>

                  {/* Dashed Separator */}
                  <div className="border-t border-dashed border-stone-400 my-2" />

                  {/* Metadata */}
                  <div className="text-[10px] space-y-0.5">
                    <div className="flex justify-between">
                      <span className="text-stone-500">RCPT NO :</span>
                      <span className="font-bold">INV-2026-0042</span>
                    </div>
                    <div className="flex justify-between">
                      <span className="text-stone-500">DATE/TIME:</span>
                      <span>2026-09-13 10:30 PM</span>
                    </div>
                    <div className="flex justify-between">
                      <span className="text-stone-500">CASHIER  :</span>
                      <span>{ownerName}</span>
                    </div>
                  </div>

                  {/* Dashed Separator */}
                  <div className="border-t border-dashed border-stone-400 my-2" />

                  {/* Member Details */}
                  <div className="text-[10px] space-y-0.5">
                    <p className="text-center font-bold text-[9px] text-stone-600">--- MEMBER DETAILS ---</p>
                    <div className="flex justify-between">
                      <span className="text-stone-500">NAME :</span>
                      <span className="font-bold">Hamza Ali Khan</span>
                    </div>
                    <div className="flex justify-between">
                      <span className="text-stone-500">ROLL :</span>
                      <span className="font-bold">METRO-2026-0089</span>
                    </div>
                    <div className="flex justify-between">
                      <span className="text-stone-500">PLAN :</span>
                      <span>Gold Monthly Pass</span>
                    </div>
                  </div>

                  {/* Dashed Separator */}
                  <div className="border-t border-dashed border-stone-400 my-2" />

                  {/* Itemized Table */}
                  <div className="text-[10px] space-y-1">
                    <div className="flex justify-between font-black text-stone-800">
                      <span>ITEM</span>
                      <span>AMOUNT</span>
                    </div>
                    <div className="flex justify-between">
                      <span>1x Gold Membership Fee</span>
                      <span>{currency} 8,500</span>
                    </div>
                    <div className="flex justify-between text-stone-600">
                      <span>1x Biometric Tag Issuance</span>
                      <span>{currency} 1,000</span>
                    </div>
                  </div>

                  {/* Dashed Separator */}
                  <div className="border-t border-dashed border-stone-400 my-2" />

                  {/* Financials */}
                  <div className="text-[10px] space-y-0.5">
                    <div className="flex justify-between">
                      <span className="text-stone-500">SUBTOTAL:</span>
                      <span>{currency} 9,500</span>
                    </div>
                    <div className="flex justify-between text-red-600">
                      <span>DISCOUNT:</span>
                      <span>- {currency} 500</span>
                    </div>
                    <div className="flex justify-between font-black text-xs border-y border-stone-900 py-1 my-1">
                      <span>NET PAID:</span>
                      <span className="text-orange-700">{currency} 9,000</span>
                    </div>
                    <div className="flex justify-between">
                      <span className="text-stone-500">PAY MODE:</span>
                      <span className="font-bold">CASH (Exact)</span>
                    </div>
                  </div>

                  {/* QR Code & Footer */}
                  <div className="text-center pt-2 space-y-1">
                    {showQrCode && (
                      <div className="w-16 h-16 bg-stone-100 border border-stone-300 mx-auto rounded flex items-center justify-center text-xs font-bold text-stone-600">
                        [QR CODE]
                      </div>
                    )}
                    <p className="text-[9px] font-bold text-stone-700">*** THANK YOU FOR TRAINING WITH US ***</p>
                    {customFooter && (
                      <p className="text-[7.5px] text-stone-500 whitespace-pre-line">{customFooter}</p>
                    )}
                    {showPoweredBy && (
                      <p className="text-[8px] font-bold text-orange-600 pt-1 border-t border-dashed border-stone-300">
                        ⚡ Powered by FitBizz Cloud Gym POS
                      </p>
                    )}
                  </div>
                </div>
              </div>
            </div>
          </div>
        )}

        {/* Tab 3: Access & Biometric Policies */}
        {activeTab === "access" && (
          <div className="bg-white p-6 md:p-8 rounded-b-2xl border border-stone-200 shadow-xs space-y-6">
            <div>
              <h2 className="text-base font-bold text-stone-900">Attendance & Hardware Access Policies</h2>
              <p className="text-xs text-stone-500">Configure biometric turnstiles, face recognition cameras, and geofencing rules.</p>
            </div>

            <div className="space-y-3">
              {[
                {
                  id: "hybridAll",
                  title: "🌐 Mode A: Hybrid / All Channels (Recommended)",
                  desc: "Allows Fingerprint, Face ID, Mobile App 1-Tap Check-In, and Reception QR scan.",
                },
                {
                  id: "biometricOnly",
                  title: "🔒 Mode B: Strict Biometric Only",
                  desc: "Restricts access strictly to physical fingerprint scanners or Face recognition hardware.",
                },
                {
                  id: "manualOnly",
                  title: "📋 Mode C: Reception Desk Verification Only",
                  desc: "All check-ins must be manually confirmed by front desk staff.",
                },
              ].map((m) => (
                <div
                  key={m.id}
                  onClick={() => setAttendanceMode(m.id as any)}
                  className={`p-4 rounded-xl border cursor-pointer transition flex items-center gap-3 ${
                    attendanceMode === m.id
                      ? "bg-orange-50 border-orange-500 text-orange-950 font-bold"
                      : "bg-stone-50 border-stone-200 text-stone-700 hover:bg-stone-100"
                  }`}
                >
                  <span className="text-lg">{attendanceMode === m.id ? "🔘" : "⚪"}</span>
                  <div>
                    <p className="text-xs font-bold">{m.title}</p>
                    <p className="text-[11px] text-stone-500 font-normal">{m.desc}</p>
                  </div>
                </div>
              ))}
            </div>

            <div className="pt-4 border-t border-stone-200 space-y-4">
              <div>
                <div className="flex justify-between text-xs font-bold text-stone-800 mb-1">
                  <span>Mobile Check-In Geofence Radius:</span>
                  <span className="text-orange-600">{geofenceRadius} meters</span>
                </div>
                <input
                  type="range"
                  min="50"
                  max="500"
                  step="25"
                  value={geofenceRadius}
                  onChange={(e) => setGeofenceRadius(Number(e.target.value))}
                  className="w-full accent-orange-600"
                />
                <p className="text-[10px] text-stone-500">Members must be physically within this radius to punch in from their smartphones.</p>
              </div>

              <label className="flex items-center justify-between p-3 rounded-xl bg-stone-50 border border-stone-200 cursor-pointer">
                <div>
                  <span className="text-xs font-bold text-stone-800 block">Allow Member App Self Check-In</span>
                  <span className="text-[10px] text-stone-500 block">Permits members to punch attendance from their own FitBizz mobile application</span>
                </div>
                <input
                  type="checkbox"
                  checked={allowSelfCheckIn}
                  onChange={(e) => setAllowSelfCheckIn(e.target.checked)}
                  className="w-4 h-4 text-orange-600 rounded border-stone-300 focus:ring-orange-500"
                />
              </label>
            </div>
          </div>
        )}

        {/* Tab 4: Cloud & Sync Hub */}
        {activeTab === "sync" && (
          <div className="bg-white p-6 md:p-8 rounded-b-2xl border border-stone-200 shadow-xs space-y-6">
            <div>
              <h2 className="text-base font-bold text-stone-900">Cloud & Offline SQLite Sync Engine</h2>
              <p className="text-xs text-stone-500">High-speed synchronization between local front-desk hardware and the FitBizz Cloud multi-tenant cluster.</p>
            </div>

            <div className="p-4 rounded-xl bg-stone-900 text-white flex flex-col md:flex-row md:items-center justify-between gap-4">
              <div className="flex items-center gap-3">
                <div className="w-10 h-10 rounded-lg bg-orange-600/20 text-orange-400 flex items-center justify-center text-xl font-bold">
                  🔄
                </div>
                <div>
                  <p className="text-xs font-bold text-white">Local SQLite Engine: OPERATIONAL</p>
                  <p className="text-[11px] text-stone-400">Last synced: {lastSyncTime} • Queue: 0 pending mutations</p>
                </div>
              </div>

              <button
                onClick={handleForceSync}
                disabled={isSyncing}
                className="px-4 py-2 rounded-xl bg-orange-600 hover:bg-orange-700 text-white font-bold text-xs flex items-center justify-center gap-2 transition"
              >
                {isSyncing ? "Syncing..." : "Force Sync Now"}
              </button>
            </div>

            <div>
              <label className="block text-xs font-bold text-stone-700 mb-1">Cloud API Gateway Endpoint</label>
              <input
                type="text"
                value={apiUrl}
                onChange={(e) => setApiUrl(e.target.value)}
                className="w-full p-2.5 text-xs bg-stone-50 border border-stone-200 rounded-xl font-mono focus:outline-none focus:ring-2 focus:ring-orange-500"
              />
            </div>

            <div className="grid grid-cols-1 md:grid-cols-2 gap-4 pt-2">
              <div className="p-4 rounded-xl border border-stone-200 bg-stone-50 space-y-2">
                <p className="text-xs font-bold text-stone-800">Database Backup & Export</p>
                <p className="text-[11px] text-stone-500">Download a full snapshot of your members, fee receipts, and attendance punches in .sqlite format.</p>
                <button
                  type="button"
                  onClick={() => alert("Local database backup generated successfully.")}
                  className="px-3 py-1.5 rounded-lg bg-white border border-stone-300 text-stone-800 font-bold text-xs hover:bg-stone-100"
                >
                  📥 Export Database Backup
                </button>
              </div>

              <div className="p-4 rounded-xl border border-stone-200 bg-stone-50 space-y-2">
                <p className="text-xs font-bold text-stone-800">Index Optimization & Cache</p>
                <p className="text-[11px] text-stone-500">Run SQLite VACUUM and re-index all search fields to ensure sub-millisecond lookup latency.</p>
                <button
                  type="button"
                  onClick={() => alert("SQLite indices optimized and cache refreshed.")}
                  className="px-3 py-1.5 rounded-lg bg-white border border-stone-300 text-stone-800 font-bold text-xs hover:bg-stone-100"
                >
                  ⚡ Optimize Indices & Cache
                </button>
              </div>
            </div>
          </div>
        )}
      </div>
    </PlatformLayout>
  );
}
