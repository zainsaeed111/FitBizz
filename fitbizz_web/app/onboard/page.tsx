"use client";

import React, { useState } from "react";
import Link from "next/link";
import { useRouter } from "next/navigation";

// Preset sample logo images
const PRESET_LOGOS = [
  { id: "logo1", name: "Titan Power", url: "https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=150&auto=format&fit=crop&q=80" },
  { id: "logo2", name: "Iron Shield", url: "https://images.unsplash.com/photo-1571902943202-507ec2618e8f?w=150&auto=format&fit=crop&q=80" },
  { id: "logo3", name: "Pulse Flame", url: "https://images.unsplash.com/photo-1517838277536-f5f99be501cd?w=150&auto=format&fit=crop&q=80" },
  { id: "logo4", name: "Elite Club", url: "https://images.unsplash.com/photo-1581009146145-b5ef050c2e1e?w=150&auto=format&fit=crop&q=80" },
];

// Preset sample owner photos
const PRESET_OWNER_PHOTOS = [
  { id: "owner1", name: "Kamran Ahmed", url: "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150&auto=format&fit=crop&q=80" },
  { id: "owner2", name: "Ayesha Malik", url: "https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=150&auto=format&fit=crop&q=80" },
  { id: "owner3", name: "Bilal Tariq", url: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&auto=format&fit=crop&q=80" },
  { id: "owner4", name: "Hamza Ali", url: "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150&auto=format&fit=crop&q=80" },
];

const AVAILABLE_FACILITIES = [
  "AC & Climate Control",
  "Locker & Showers",
  "CrossFit Rig",
  "Biometric Turnstiles",
  "Sauna & Steam Room",
  "Cardio Theater",
  "Free Weights Zone",
  "Cafe & Juice Bar",
];

interface BranchItem {
  name: string;
  address: string;
}

export default function GymOnboardingWizardPage() {
  const router = useRouter();
  const [currentStep, setCurrentStep] = useState(1);
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [showCredentialsModal, setShowCredentialsModal] = useState(false);
  const [isDetectingGps, setIsDetectingGps] = useState(false);
  const [toast, setToast] = useState<{ title: string; message: string; type: "success" | "info" | "warning" } | null>(null);

  const showToast = (title: string, message: string, type: "success" | "info" | "warning" = "success") => {
    setToast({ title, message, type });
    setTimeout(() => setToast(null), 3800);
  };

  // Step 1: Business Profile & Location
  const [gymName, setGymName] = useState("Titan Fitness Arena");
  const [gymCode, setGymCode] = useState("titan-arena");
  const [ownerName, setOwnerName] = useState("Kamran Ahmed");
  const [ownerPhone, setOwnerPhone] = useState("+92 300 1234567");
  const [ownerEmail, setOwnerEmail] = useState("owner@titanfitness.com");
  const [city, setCity] = useState("Lahore");
  const [gymAddress, setGymAddress] = useState("Main Boulevard, Block 4, Gulberg III");
  const [gpsLocation, setGpsLocation] = useState("31.5204° N, 74.3587° E");

  // Step 2: Multi-Branch Architecture
  const [numberOfBranches, setNumberOfBranches] = useState(2);
  const [branches, setBranches] = useState<BranchItem[]>([
    { name: "Gulberg Main Arena (HQ)", address: "Gulberg III, Main Boulevard" },
    { name: "DHA Phase 5 Branch", address: "Sector CCA, DHA Phase 5" },
  ]);

  // Step 3: Identity & Assets
  const [cnic, setCnic] = useState("35202-1234567-1");
  const [areaSqFt, setAreaSqFt] = useState("8,500 sq ft");
  const [selectedLogo, setSelectedLogo] = useState(PRESET_LOGOS[0].url);
  const [selectedOwnerPhoto, setSelectedOwnerPhoto] = useState(PRESET_OWNER_PHOTOS[0].url);
  const [selectedFacilities, setSelectedFacilities] = useState<string[]>([
    "AC & Climate Control",
    "Locker & Showers",
    "CrossFit Rig",
    "Biometric Turnstiles",
  ]);

  // Step 4: Plan Configuration
  const [enableTrial, setEnableTrial] = useState(true);
  const [trialDays, setTrialDays] = useState(15);
  const [isCustomPlan, setIsCustomPlan] = useState(false);
  const [selectedPresetPlan, setSelectedPresetPlan] = useState("Pro Multi-Branch Plan");
  const [customMonthlyPrice, setCustomMonthlyPrice] = useState(35000);
  const [customMaxBranches, setCustomMaxBranches] = useState(3);
  const [featureSms, setFeatureSms] = useState(true);
  const [featureBiometrics, setFeatureBiometrics] = useState(true);
  const [featurePos, setFeaturePos] = useState(true);
  const [featureMobileApp, setFeatureMobileApp] = useState(true);
  const [featureSupport, setFeatureSupport] = useState(true);

  // Real GPS & Location Auto-Detector
  const handleDetectGps = async () => {
    setIsDetectingGps(true);

    if (typeof navigator !== "undefined" && navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(
        async (position) => {
          const lat = position.coords.latitude;
          const lon = position.coords.longitude;
          try {
            const nomRes = await fetch(`https://nominatim.openstreetmap.org/reverse?format=json&lat=${lat}&lon=${lon}`);
            if (nomRes.ok) {
              const nomData = await nomRes.json();
              const displayName = nomData.display_name || "";
              const parts = displayName.split(",");
              const cleanAddress = parts.length > 3 ? `${parts[0].trim()}, ${parts[1].trim()}, ${parts[2].trim()}` : displayName;
              const detectedCity = nomData.address?.city || nomData.address?.town || nomData.address?.state_district || city || "Lahore";

              setIsDetectingGps(false);
              setGpsLocation(`${lat.toFixed(4)}° N, ${lon.toFixed(4)}° E`);
              setCity(detectedCity);
              setGymAddress(cleanAddress || gymAddress);
              showToast("Location Detected", `📍 ${lat.toFixed(4)}° N, ${lon.toFixed(4)}° E (${detectedCity})`);
              return;
            }
          } catch (_) { }
          setIsDetectingGps(false);
          setGpsLocation(`${lat.toFixed(4)}° N, ${lon.toFixed(4)}° E`);
          showToast("GPS Location Acquired", `📍 ${lat.toFixed(4)}° N, ${lon.toFixed(4)}° E`);
        },
        async () => {
          try {
            const ipRes = await fetch("http://ip-api.com/json/");
            if (ipRes.ok) {
              const data = await ipRes.json();
              if (data.status === "success") {
                const lat = data.lat;
                const lon = data.lon;
                const ipCity = data.city || "Lahore";
                const region = data.regionName || "";

                setIsDetectingGps(false);
                setGpsLocation(`${lat.toFixed(4)}° N, ${lon.toFixed(4)}° E`);
                setCity(ipCity);
                setGymAddress(`${ipCity}, ${region}, Pakistan`);
                showToast("Location Detected", `📍 ${lat.toFixed(4)}° N, ${lon.toFixed(4)}° E (${ipCity})`);
                return;
              }
            }
          } catch (_) { }
          setIsDetectingGps(false);
          setGpsLocation("31.5204° N, 74.3587° E");
          showToast("Location Set", "📍 31.5204° N, 74.3587° E (Lahore)", "info");
        },
        { timeout: 5000 }
      );
      return;
    }

    setIsDetectingGps(false);
    setGpsLocation("31.5204° N, 74.3587° E");
    showToast("Location Set", "📍 31.5204° N, 74.3587° E (Lahore)", "info");
  };

  // Branch Count Handler
  const handleBranchCountChange = (count: number) => {
    if (count < 1 || count > 10) return;
    setNumberOfBranches(count);
    const updated = [...branches];
    while (updated.length < count) {
      const idx = updated.length + 1;
      updated.push({
        name: idx === 1 ? `${gymName} Main Arena (HQ)` : `Branch #${idx} (${city})`,
        address: `Branch #${idx} Address, Commercial Zone`,
      });
    }
    while (updated.length > count) {
      updated.pop();
    }
    setBranches(updated);
  };

  const handleBranchFieldChange = (index: number, field: keyof BranchItem, value: string) => {
    const updated = [...branches];
    updated[index][field] = value;
    setBranches(updated);
  };

  const toggleFacility = (facility: string) => {
    if (selectedFacilities.includes(facility)) {
      setSelectedFacilities(selectedFacilities.filter((f) => f !== facility));
    } else {
      setSelectedFacilities([...selectedFacilities, facility]);
    }
  };

  const handleFinishOnboarding = () => {
    setIsSubmitting(true);
    setTimeout(() => {
      setIsSubmitting(false);
      setShowCredentialsModal(true);
      showToast("Onboarding Completed!", `🎉 ${gymName} registered with ${numberOfBranches} branches.`);
    }, 700);
  };

  const credentialsText = `🏋️ *FitBizz Gym Tenant Credentials & Welcome Pack*
━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🏢 *Gym Name:* ${gymName}
🆔 *Tenant / Gym ID:* ${gymCode}
👤 *Owner Name:* ${ownerName}
📧 *Login Email:* ${ownerEmail}
📱 *Registered Phone:* ${ownerPhone}
🔑 *Default Password:* password123
🌐 *Web Portal:* http://localhost:3000/login
💻 *Desktop Client:* FitBizz OS Windows v2.0
🏢 *Branches Enabled:* ${numberOfBranches}
📦 *Subscription Tier:* ${isCustomPlan ? `Custom Plan (Rs ${customMonthlyPrice.toLocaleString()}/mo)` : selectedPresetPlan}
⏳ *Status:* ${enableTrial ? `${trialDays}-Day Free Trial` : "Active Paid Subscription"}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━
_Keep these credentials confidential. You can change your password anytime inside the Owner Settings._`;

  const copyToClipboard = (text: string, label: string) => {
    navigator.clipboard.writeText(text);
    showToast("Copied to Clipboard", `${label} copied successfully.`);
  };

  const sendViaWhatsApp = () => {
    copyToClipboard(credentialsText, "Credentials Pack");
    const cleanPhone = ownerPhone.replace(/[^0-9]/g, "");
    const waPhone = cleanPhone.startsWith("0") ? `92${cleanPhone.substring(1)}` : cleanPhone;
    const url = waPhone.length > 5
      ? `https://wa.me/${waPhone}?text=${encodeURIComponent(credentialsText)}`
      : `https://wa.me/?text=${encodeURIComponent(credentialsText)}`;
    window.open(url, "_blank");
    showToast("WhatsApp Dispatched", `Opening WhatsApp with credentials for ${ownerName}.`);
  };

  const sendViaEmail = () => {
    copyToClipboard(credentialsText, "Credentials Pack");
    const subject = encodeURIComponent(`🏋️ FitBizz Platform Access & Credentials - ${gymName}`);
    const body = encodeURIComponent(credentialsText);
    window.location.href = `mailto:${ownerEmail}?subject=${subject}&body=${body}`;
    showToast("Email Draft Prepared", `Opening mail client for ${ownerEmail}.`);
  };

  return (
    <div className="max-w-4xl mx-auto space-y-6 pb-12">
      {/* Top Breadcrumb & Header */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3 pb-4 border-b border-stone-200">
        <div>
          <div className="flex items-center gap-2">
            <span className="text-xl">🏋️</span>
            <h1 className="text-xl font-black text-stone-900 tracking-tight">Gym Tenant Onboarding Wizard</h1>
          </div>
          <p className="text-xs text-stone-500 mt-0.5">
            Register new fitness businesses, multi-branch structures, and automated credentials dispatch
          </p>
        </div>
        <Link href="/" className="fb-button-secondary text-xs self-start sm:self-auto">
          ← Back to Super Admin HQ
        </Link>
      </div>

      {/* 4-Step Progress Indicator */}
      <div className="fb-panel p-4 grid grid-cols-2 md:grid-cols-4 gap-3 bg-white">
        {[
          { num: 1, title: "1. Business Profile", desc: "Identity & GPS Location" },
          { num: 2, title: "2. Branch Setup", desc: "Multi-Location Network" },
          { num: 3, title: "3. Assets & Facilities", desc: "Logos, Media & Amenities" },
          { num: 4, title: "4. Subscription Plan", desc: "Trial & Custom Pricing" },
        ].map((step) => {
          const isActive = currentStep === step.num;
          const isDone = currentStep > step.num;

          return (
            <div
              key={step.num}
              onClick={() => setCurrentStep(step.num)}
              className={`p-3 rounded-xl border transition cursor-pointer flex items-start gap-3 ${isActive
                  ? "bg-orange-50 border-orange-500 shadow-sm"
                  : isDone
                    ? "bg-emerald-50/60 border-emerald-300"
                    : "bg-stone-50 border-stone-200 opacity-70 hover:opacity-100"
                }`}
            >
              <div
                className={`w-7 h-7 rounded-lg flex items-center justify-center font-black text-xs shrink-0 ${isActive
                    ? "bg-orange-600 text-white shadow-sm shadow-orange-500/40"
                    : isDone
                      ? "bg-emerald-600 text-white"
                      : "bg-stone-200 text-stone-700"
                  }`}
              >
                {isDone ? "✓" : step.num}
              </div>
              <div className="min-w-0">
                <p className={`text-xs font-bold leading-tight ${isActive ? "text-orange-950" : "text-stone-800"}`}>
                  {step.title}
                </p>
                <p className="text-[10px] text-stone-500 truncate mt-0.5">{step.desc}</p>
              </div>
            </div>
          );
        })}
      </div>

      {/* Step Form Body Container */}
      <div className="fb-panel p-6 sm:p-8 space-y-6">
        {/* STEP 1: BUSINESS PROFILE & GPS LOCATION */}
        {currentStep === 1 && (
          <div className="space-y-5 animate-in fade-in duration-200">
            <div className="border-b border-stone-200 pb-3 flex items-center justify-between">
              <div>
                <h2 className="text-sm font-bold text-stone-900 uppercase tracking-wider">Step 1: Business Profile & Location</h2>
                <p className="text-xs text-stone-500 mt-0.5">Enter core credentials, owner contact info, and pinpoint GPS location</p>
              </div>
              <span className="fb-badge fb-badge-info">Step 1 of 4</span>
            </div>

            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div>
                <label className="block text-xs font-bold text-stone-700 mb-1.5">Gym Business Name *</label>
                <input
                  type="text"
                  value={gymName}
                  onChange={(e) => setGymName(e.target.value)}
                  className="fb-input w-full"
                  placeholder="e.g. Titan Fitness Arena"
                />
              </div>

              <div>
                <label className="block text-xs font-bold text-stone-700 mb-1.5">Gym Code / Slug ID *</label>
                <input
                  type="text"
                  value={gymCode}
                  onChange={(e) => setGymCode(e.target.value)}
                  className="fb-input w-full font-mono"
                  placeholder="titan-arena"
                />
              </div>

              <div>
                <label className="block text-xs font-bold text-stone-700 mb-1.5">Owner Full Name *</label>
                <input
                  type="text"
                  value={ownerName}
                  onChange={(e) => setOwnerName(e.target.value)}
                  className="fb-input w-full"
                  placeholder="Kamran Ahmed"
                />
              </div>

              <div>
                <label className="block text-xs font-bold text-stone-700 mb-1.5">Owner Phone Number (WhatsApp Enabled) *</label>
                <input
                  type="text"
                  value={ownerPhone}
                  onChange={(e) => setOwnerPhone(e.target.value)}
                  className="fb-input w-full font-mono"
                  placeholder="+92 300 1234567"
                />
              </div>

              <div>
                <label className="block text-xs font-bold text-stone-700 mb-1.5">Owner Email Address *</label>
                <input
                  type="email"
                  value={ownerEmail}
                  onChange={(e) => setOwnerEmail(e.target.value)}
                  className="fb-input w-full"
                  placeholder="owner@titanfitness.com"
                />
              </div>

              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                  <label className="block text-xs font-bold text-stone-700 mb-1.5">City / Metropolitan Area *</label>
                  <input
                    type="text"
                    value={city}
                    onChange={(e) => setCity(e.target.value)}
                    className="fb-input w-full"
                    placeholder="Lahore"
                  />
                </div>

                <div>
                  <label className="block text-xs font-bold text-stone-700 mb-1.5">Gym Main Street Address *</label>
                  <input
                    type="text"
                    value={gymAddress}
                    onChange={(e) => setGymAddress(e.target.value)}
                    className="fb-input w-full"
                    placeholder="Main Boulevard, Block 4, Gulberg III"
                  />
                </div>
              </div>

              {/* Quick City Presets */}
              <div className="flex items-center gap-2 overflow-x-auto pb-1">
                <span className="text-[11px] font-bold text-stone-500 shrink-0">Popular Cities:</span>
                {[
                  { name: "Lahore", coords: "31.5204° N, 74.3587° E" },
                  { name: "Karachi", coords: "24.8607° N, 67.0011° E" },
                  { name: "Islamabad", coords: "33.6844° N, 73.0479° E" },
                  { name: "Rawalpindi", coords: "33.5651° N, 73.0169° E" },
                  { name: "Faisalabad", coords: "31.4504° N, 73.1350° E" },
                  { name: "Peshawar", coords: "34.0151° N, 71.5249° E" },
                  { name: "Multan", coords: "30.1575° N, 71.5249° E" },
                  { name: "Quetta", coords: "30.1798° N, 66.9750° E" },
                ].map((c) => (
                  <button
                    key={c.name}
                    type="button"
                    onClick={() => {
                      setCity(c.name);
                      setGpsLocation(c.coords);
                    }}
                    className={`px-2.5 py-1 rounded-md text-[11px] font-bold transition shrink-0 ${city.toLowerCase() === c.name.toLowerCase()
                        ? "bg-orange-600 text-white shadow-xs"
                        : "bg-stone-100 text-stone-700 hover:bg-stone-200 border border-stone-200"
                      }`}
                  >
                    {c.name}
                  </button>
                ))}
              </div>

              {/* GPS Coordinates (Directly Editable + 1-Click Detect Button) */}
              <div className="flex flex-col sm:flex-row items-end gap-3">
                <div className="flex-1 w-full">
                  <label className="block text-xs font-bold text-stone-700 mb-1.5">GPS Coordinates (Editable / Auto-Detected)</label>
                  <input
                    type="text"
                    value={gpsLocation}
                    onChange={(e) => setGpsLocation(e.target.value)}
                    className="fb-input w-full font-mono text-xs"
                    placeholder="31.5204° N, 74.3587° E"
                  />
                </div>
                <button
                  type="button"
                  onClick={handleDetectGps}
                  disabled={isDetectingGps}
                  className="fb-button-primary text-xs shrink-0 py-2.5 px-4"
                >
                  {isDetectingGps ? "Detecting..." : "📍 Auto Detect Location"}
                </button>
              </div>
            </div>
          </div>
        )}

            {/* STEP 2: MULTI-BRANCH ARCHITECTURE */}
            {currentStep === 2 && (
              <div className="space-y-5 animate-in fade-in duration-200">
                <div className="border-b border-stone-200 pb-3 flex items-center justify-between">
                  <div>
                    <h2 className="text-sm font-bold text-stone-900 uppercase tracking-wider">Step 2: Multi-Branch Architecture</h2>
                    <p className="text-xs text-stone-500 mt-0.5">Scale tenant operations across single or multiple physical gym locations</p>
                  </div>
                  <span className="fb-badge fb-badge-info">Step 2 of 4</span>
                </div>

                {/* Stepper Count Selector */}
                <div className="p-4 rounded-xl bg-stone-50 border border-stone-200 flex items-center justify-between">
                  <div>
                    <p className="text-xs font-bold text-stone-900">Total Branches Configured</p>
                    <p className="text-[11px] text-stone-500">Each branch gets its own reception terminal & biometric turnstile sync</p>
                  </div>
                  <div className="flex items-center gap-3">
                    <button
                      type="button"
                      onClick={() => handleBranchCountChange(numberOfBranches - 1)}
                      className="w-9 h-9 rounded-lg bg-white border border-stone-300 font-bold text-stone-800 hover:bg-stone-100 transition flex items-center justify-center text-base"
                    >
                      -
                    </button>
                    <span className="px-4 py-1.5 bg-orange-600 text-white font-black text-xs rounded-lg shadow-sm">
                      {numberOfBranches} Branches
                    </span>
                    <button
                      type="button"
                      onClick={() => handleBranchCountChange(numberOfBranches + 1)}
                      className="w-9 h-9 rounded-lg bg-white border border-stone-300 font-bold text-stone-800 hover:bg-stone-100 transition flex items-center justify-center text-base"
                    >
                      +
                    </button>
                  </div>
                </div>

                {/* Dynamic Branch Cards Grid */}
                <div className="space-y-3">
                  {branches.map((branch, idx) => (
                    <div key={idx} className="p-4 rounded-xl border border-stone-200 bg-white hover:border-orange-300 transition space-y-3">
                      <div className="flex items-center justify-between">
                        <span className="text-xs font-bold text-orange-600 uppercase tracking-wider">
                          Branch #{idx + 1} Configuration
                        </span>
                        {idx === 0 && <span className="fb-badge fb-badge-warning text-[10px]">Main Facility / HQ</span>}
                      </div>

                      <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                        <div>
                          <label className="block text-[11px] font-bold text-stone-600 mb-1">Branch Name</label>
                          <input
                            type="text"
                            value={branch.name}
                            onChange={(e) => handleBranchFieldChange(idx, "name", e.target.value)}
                            className="fb-input w-full text-xs"
                          />
                        </div>
                        <div>
                          <label className="block text-[11px] font-bold text-stone-600 mb-1">Street Address</label>
                          <input
                            type="text"
                            value={branch.address}
                            onChange={(e) => handleBranchFieldChange(idx, "address", e.target.value)}
                            className="fb-input w-full text-xs"
                          />
                        </div>
                      </div>
                    </div>
                  ))}
                </div>
              </div>
            )}

            {/* STEP 3: IDENTITY & ASSETS & FACILITIES */}
            {currentStep === 3 && (
              <div className="space-y-5 animate-in fade-in duration-200">
                <div className="border-b border-stone-200 pb-3 flex items-center justify-between">
                  <div>
                    <h2 className="text-sm font-bold text-stone-900 uppercase tracking-wider">Step 3: Identity, Branding & Facilities</h2>
                    <p className="text-xs text-stone-500 mt-0.5">Select gym logo, owner avatar, and enabled facility amenities</p>
                  </div>
                  <span className="fb-badge fb-badge-info">Step 3 of 4</span>
                </div>

                <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                  <div>
                    <label className="block text-xs font-bold text-stone-700 mb-1.5">Owner CNIC / National Tax ID</label>
                    <input
                      type="text"
                      value={cnic}
                      onChange={(e) => setCnic(e.target.value)}
                      className="fb-input w-full font-mono text-xs"
                      placeholder="35202-1234567-1"
                    />
                  </div>

                  <div>
                    <label className="block text-xs font-bold text-stone-700 mb-1.5">Total Covered Facility Area</label>
                    <input
                      type="text"
                      value={areaSqFt}
                      onChange={(e) => setAreaSqFt(e.target.value)}
                      className="fb-input w-full text-xs"
                      placeholder="8,500 sq ft"
                    />
                  </div>
                </div>

                {/* Gym Logo Selection */}
                <div>
                  <label className="block text-xs font-bold text-stone-700 mb-2">Gym Brand Logo</label>
                  <div className="grid grid-cols-2 sm:grid-cols-4 gap-3">
                    {PRESET_LOGOS.map((logo) => (
                      <div
                        key={logo.id}
                        onClick={() => setSelectedLogo(logo.url)}
                        className={`p-2.5 rounded-xl border cursor-pointer transition flex items-center gap-2.5 ${selectedLogo === logo.url
                            ? "border-orange-500 bg-orange-50 shadow-sm"
                            : "border-stone-200 hover:border-stone-400 bg-white"
                          }`}
                      >
                        <img src={logo.url} alt={logo.name} className="w-9 h-9 rounded-lg object-cover shrink-0" />
                        <span className="text-xs font-semibold text-stone-800 leading-tight">{logo.name}</span>
                      </div>
                    ))}
                  </div>
                </div>

                {/* Owner Photo Selection */}
                <div>
                  <label className="block text-xs font-bold text-stone-700 mb-2">Owner Profile Photo</label>
                  <div className="grid grid-cols-2 sm:grid-cols-4 gap-3">
                    {PRESET_OWNER_PHOTOS.map((owner) => (
                      <div
                        key={owner.id}
                        onClick={() => setSelectedOwnerPhoto(owner.url)}
                        className={`p-2.5 rounded-xl border cursor-pointer transition flex items-center gap-2.5 ${selectedOwnerPhoto === owner.url
                            ? "border-orange-500 bg-orange-50 shadow-sm"
                            : "border-stone-200 hover:border-stone-400 bg-white"
                          }`}
                      >
                        <img src={owner.url} alt={owner.name} className="w-9 h-9 rounded-full object-cover shrink-0" />
                        <span className="text-xs font-semibold text-stone-800 leading-tight">{owner.name}</span>
                      </div>
                    ))}
                  </div>
                </div>

                {/* Facilities Multi-Select Badges */}
                <div>
                  <label className="block text-xs font-bold text-stone-700 mb-2">Enabled Facility Amenities</label>
                  <div className="flex flex-wrap gap-2">
                    {AVAILABLE_FACILITIES.map((facility) => {
                      const isSelected = selectedFacilities.includes(facility);
                      return (
                        <button
                          key={facility}
                          type="button"
                          onClick={() => toggleFacility(facility)}
                          className={`text-xs font-bold px-3 py-1.5 rounded-lg border transition ${isSelected
                              ? "bg-orange-600 text-white border-orange-600 shadow-sm"
                              : "bg-white text-stone-600 border-stone-300 hover:border-orange-400"
                            }`}
                        >
                          {isSelected ? "✓ " : "+ "}
                          {facility}
                        </button>
                      );
                    })}
                  </div>
                </div>
              </div>
            )}

            {/* STEP 4: SUBSCRIPTION PLAN & TRIAL BUILDER */}
            {currentStep === 4 && (
              <div className="space-y-5 animate-in fade-in duration-200">
                <div className="border-b border-stone-200 pb-3 flex items-center justify-between">
                  <div>
                    <h2 className="text-sm font-bold text-stone-900 uppercase tracking-wider">Step 4: Subscription Plan & 15-Day Free Trial</h2>
                    <p className="text-xs text-stone-500 mt-0.5">Configure 15-day trial period, preset plans, or custom tenant pricing</p>
                  </div>
                  <span className="fb-badge fb-badge-info">Step 4 of 4</span>
                </div>

                {/* 15-Day Trial Card */}
                <div className="p-4 rounded-xl bg-emerald-50 border border-emerald-300 flex items-center justify-between">
                  <div>
                    <p className="text-xs font-bold text-emerald-950">Activate 15-Day Free Trial Period (Recommended)</p>
                    <p className="text-[11px] text-emerald-800 mt-0.5">Tenant gets complete access without payment barrier during setup</p>
                  </div>
                  <div className="flex items-center gap-3">
                    {[15, 30, 60].map((d) => (
                      <button
                        key={d}
                        type="button"
                        onClick={() => {
                          setEnableTrial(true);
                          setTrialDays(d);
                        }}
                        className={`text-xs font-bold px-3 py-1.5 rounded-lg border transition ${enableTrial && trialDays === d
                            ? "bg-emerald-700 text-white border-emerald-700 shadow-sm"
                            : "bg-white text-emerald-900 border-emerald-300 hover:bg-emerald-100"
                          }`}
                      >
                        {d} Days
                      </button>
                    ))}
                  </div>
                </div>

                {/* Preset vs Custom Plan Builder Switcher */}
                <div className="flex gap-2 p-1 bg-stone-100 rounded-xl border border-stone-200 max-w-sm">
                  <button
                    type="button"
                    onClick={() => setIsCustomPlan(false)}
                    className={`flex-1 py-1.5 text-xs font-bold rounded-lg transition ${!isCustomPlan ? "bg-white text-orange-600 shadow-sm" : "text-stone-600 hover:text-stone-900"
                      }`}
                  >
                    Preset Packages
                  </button>
                  <button
                    type="button"
                    onClick={() => setIsCustomPlan(true)}
                    className={`flex-1 py-1.5 text-xs font-bold rounded-lg transition ${isCustomPlan ? "bg-white text-orange-600 shadow-sm" : "text-stone-600 hover:text-stone-900"
                      }`}
                  >
                    🛠️ Custom Plan Builder
                  </button>
                </div>

                {!isCustomPlan ? (
                  <div className="grid grid-cols-1 sm:grid-cols-3 gap-3">
                    {[
                      { name: "Starter Business Plan", price: "Rs 15,000 / mo", branches: "1 Branch", desc: "For single location gyms" },
                      { name: "Pro Multi-Branch Plan", price: "Rs 35,000 / mo", branches: "Up to 3 Branches", desc: "Best for growing gyms" },
                      { name: "Enterprise Elite Suite", price: "Rs 75,000 / mo", branches: "Unlimited Branches", desc: "Full franchise operations" },
                    ].map((plan) => (
                      <div
                        key={plan.name}
                        onClick={() => setSelectedPresetPlan(plan.name)}
                        className={`p-4 rounded-xl border cursor-pointer transition space-y-2 ${selectedPresetPlan === plan.name
                            ? "border-orange-500 bg-orange-50/70 shadow-sm"
                            : "border-stone-200 bg-white hover:border-stone-400"
                          }`}
                      >
                        <div className="flex justify-between items-start">
                          <h3 className="font-bold text-stone-900 text-xs">{plan.name}</h3>
                          {selectedPresetPlan === plan.name && <span className="text-orange-600 font-bold text-xs">✓</span>}
                        </div>
                        <p className="text-sm font-black text-orange-600">{plan.price}</p>
                        <p className="text-[11px] text-stone-500">{plan.branches} • {plan.desc}</p>
                      </div>
                    ))}
                  </div>
                ) : (
                  <div className="p-4 rounded-xl border border-orange-200 bg-orange-50/40 space-y-4">
                    <div className="flex items-center justify-between">
                      <h3 className="text-xs font-bold text-orange-950 uppercase tracking-wider">Tailored Custom Tenant Plan</h3>
                      <span className="text-xs font-black text-orange-600">Rs {customMonthlyPrice.toLocaleString()} / month</span>
                    </div>

                    <div>
                      <div className="flex justify-between text-xs font-semibold text-stone-700 mb-1">
                        <span>Monthly License Price</span>
                        <span>Rs {customMonthlyPrice.toLocaleString()}</span>
                      </div>
                      <input
                        type="range"
                        min="15000"
                        max="120000"
                        step="5000"
                        value={customMonthlyPrice}
                        onChange={(e) => setCustomMonthlyPrice(Number(e.target.value))}
                        className="w-full accent-orange-600 cursor-pointer"
                      />
                    </div>

                    {/* Feature Toggles */}
                    <div>
                      <p className="text-xs font-bold text-stone-700 mb-2">Included Feature Entitlements:</p>
                      <div className="grid grid-cols-2 sm:grid-cols-3 gap-2.5 text-xs">
                        <label className="flex items-center gap-2 font-medium text-stone-800 cursor-pointer">
                          <input
                            type="checkbox"
                            checked={featureSms}
                            onChange={(e) => setFeatureSms(e.target.checked)}
                            className="rounded accent-orange-600"
                          />
                          SMS & WhatsApp Alerts
                        </label>
                        <label className="flex items-center gap-2 font-medium text-stone-800 cursor-pointer">
                          <input
                            type="checkbox"
                            checked={featureBiometrics}
                            onChange={(e) => setFeatureBiometrics(e.target.checked)}
                            className="rounded accent-orange-600"
                          />
                          Biometrics & Turnstiles
                        </label>
                        <label className="flex items-center gap-2 font-medium text-stone-800 cursor-pointer">
                          <input
                            type="checkbox"
                            checked={featurePos}
                            onChange={(e) => setFeaturePos(e.target.checked)}
                            className="rounded accent-orange-600"
                          />
                          POS Billing & Invoicing
                        </label>
                        <label className="flex items-center gap-2 font-medium text-stone-800 cursor-pointer">
                          <input
                            type="checkbox"
                            checked={featureMobileApp}
                            onChange={(e) => setFeatureMobileApp(e.target.checked)}
                            className="rounded accent-orange-600"
                          />
                          Mobile App Pass
                        </label>
                        <label className="flex items-center gap-2 font-medium text-stone-800 cursor-pointer">
                          <input
                            type="checkbox"
                            checked={featureSupport}
                            onChange={(e) => setFeatureSupport(e.target.checked)}
                            className="rounded accent-orange-600"
                          />
                          24/7 Priority Support
                        </label>
                      </div>
                    </div>
                  </div>
                )}
              </div>
            )}

            {/* Step Navigation Bar */}
            <div className="pt-4 border-t border-stone-200 flex items-center justify-between">
              {currentStep > 1 ? (
                <button
                  type="button"
                  onClick={() => setCurrentStep(currentStep - 1)}
                  className="fb-button-secondary text-xs"
                >
                  ← Previous Step
                </button>
              ) : (
                <div />
              )}

              {currentStep < 4 ? (
                <button
                  type="button"
                  onClick={() => setCurrentStep(currentStep + 1)}
                  className="fb-button-primary text-xs"
                >
                  Continue to Step {currentStep + 1} →
                </button>
              ) : (
                <button
                  type="button"
                  onClick={handleFinishOnboarding}
                  disabled={isSubmitting}
                  className="fb-button-primary text-xs bg-emerald-600 hover:bg-emerald-700 shadow-emerald-500/20"
                >
                  {isSubmitting ? "Onboarding Gym..." : "✓ Complete Gym Onboarding"}
                </button>
              )}
            </div>
          </div>

      {/* POST-ONBOARDING CREDENTIALS MODAL */}
        {showCredentialsModal && (
          <div className="fixed inset-0 z-50 bg-black/60 backdrop-blur-sm flex items-center justify-center p-4">
            <div className="bg-white rounded-2xl shadow-2xl max-w-lg w-full p-6 sm:p-8 space-y-5 animate-in fade-in zoom-in-95 duration-200">
              <div className="flex items-start justify-between">
                <div>
                  <span className="fb-badge fb-badge-success mb-1">🎉 Onboarded Successfully</span>
                  <h2 className="text-lg font-black text-stone-900">Gym Access Credentials Pack</h2>
                  <p className="text-xs text-stone-500 mt-0.5">
                    Share these login credentials with gym owner <strong>{ownerName}</strong>
                  </p>
                </div>
                <button
                  onClick={() => setShowCredentialsModal(false)}
                  className="text-stone-400 hover:text-stone-700 text-lg leading-none"
                >
                  ✕
                </button>
              </div>

              {/* Credential Details Box */}
              <div className="p-4 rounded-xl bg-stone-50 border border-stone-200 space-y-2 text-xs">
                <div className="flex justify-between py-1 border-b border-stone-200">
                  <span className="text-stone-500 font-semibold">Gym Name:</span>
                  <span className="font-bold text-stone-900">{gymName}</span>
                </div>
                <div className="flex justify-between py-1 border-b border-stone-200">
                  <span className="text-stone-500 font-semibold">Tenant Code:</span>
                  <span className="font-mono font-bold text-orange-600">{gymCode}</span>
                </div>
                <div className="flex justify-between py-1 border-b border-stone-200">
                  <span className="text-stone-500 font-semibold">Login Email:</span>
                  <span className="font-semibold text-stone-900">{ownerEmail}</span>
                </div>
                <div className="flex justify-between py-1 border-b border-stone-200">
                  <span className="text-stone-500 font-semibold">Default Password:</span>
                  <span className="font-mono font-bold text-stone-900">password123</span>
                </div>
                <div className="flex justify-between py-1">
                  <span className="text-stone-500 font-semibold">Plan Status:</span>
                  <span className="font-bold text-emerald-700">15-Day Free Trial ({numberOfBranches} Branches)</span>
                </div>
              </div>

              {/* Action Buttons: WhatsApp, Email, Copy */}
              <div className="space-y-2.5">
                <div className="grid grid-cols-1 sm:grid-cols-2 gap-2">
                  <button
                    type="button"
                    onClick={sendViaWhatsApp}
                    className="p-2.5 rounded-xl bg-emerald-600 hover:bg-emerald-700 text-white font-bold text-xs flex items-center justify-center gap-2 shadow-sm transition"
                  >
                    <span>💬</span> Send via WhatsApp
                  </button>
                  <button
                    type="button"
                    onClick={sendViaEmail}
                    className="p-2.5 rounded-xl bg-orange-600 hover:bg-orange-700 text-white font-bold text-xs flex items-center justify-center gap-2 shadow-sm transition"
                  >
                    <span>✉️</span> Send via Email
                  </button>
                </div>

                <button
                  type="button"
                  onClick={() => copyToClipboard(credentialsText, "Full Credentials")}
                  className="w-full fb-button-secondary text-xs"
                >
                  📋 Copy Full Credentials Pack
                </button>
              </div>

              <div className="pt-2 border-t border-stone-200 flex justify-between items-center">
                <Link
                  href={`/gyms/${gymCode}`}
                  className="text-xs font-bold text-orange-600 hover:underline"
                >
                  Open Gym Tenant Workspace →
                </Link>
                <button
                  onClick={() => {
                    setShowCredentialsModal(false);
                    router.push("/");
                  }}
                  className="text-xs text-stone-500 hover:text-stone-800"
                >
                  Done & Return to HQ
                </button>
              </div>
            </div>
          </div>
        )}

        {/* Floating Top-Right Toast Notification */}
        {toast && (
          <div className="fixed top-6 right-6 z-50 max-w-md w-[calc(100vw-2rem)] sm:w-auto animate-in fade-in slide-in-from-top-4 duration-300">
            <div
              className={`p-4 rounded-xl shadow-2xl border flex items-start gap-3 backdrop-blur-md transition-all ${toast.type === "success"
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
