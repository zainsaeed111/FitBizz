"use client";

import React, { useState } from "react";
import PlatformLayout from "../components/PlatformLayout";

export interface AttendanceItem {
  id: string;
  entityId: string;
  entityName: string;
  entityIdentifier: string; // Roll # or Staff ID
  photoUrl: string;
  type: "MEMBER" | "STAFF";
  departmentOrPlan: string;
  date: string;
  checkInTime: string | null;
  checkOutTime: string | null;
  status: "PRESENT" | "LATE" | "ABSENT" | "HALF_DAY";
  method: "BIOMETRIC_FINGER" | "BIOMETRIC_FACE" | "QR_SCAN" | "GEOFENCE_APP" | "MANUAL_DESK";
  geofenceMeters?: number;
  notes?: string;
}

export interface StaffItem {
  id: string;
  employeeCode: string;
  fullName: string;
  role: string;
  phone: string;
  photoUrl: string;
  shift: string;
}

export default function AttendancePage() {
  const [selectedDate, setSelectedDate] = useState("2026-09-13");
  const [activeTab, setActiveTab] = useState<"MEMBERS" | "STAFF" | "ANALYTICS" | "HARDWARE">("MEMBERS");
  const [searchQuery, setSearchQuery] = useState("");
  const [statusFilter, setStatusFilter] = useState<string>("ALL");
  const [showSimulatorModal, setShowSimulatorModal] = useState(false);
  const [toast, setToast] = useState<{ title: string; message: string } | null>(null);

  // Hardware Configuration State
  const [deviceConfig, setDeviceConfig] = useState({
    ipAddress: "192.168.1.201",
    port: 4370,
    deviceModel: "ZKTeco SpeedFace-V5L (Turnstile #1)",
    location: "Main Entrance Turnstile & Biometric Gate",
    isConnected: true,
    totalLogs: 1482,
  });

  // Geofence Radius
  const [geofenceRadius, setGeofenceRadius] = useState(25);

  const showNotification = (title: string, message: string) => {
    setToast({ title, message });
    setTimeout(() => setToast(null), 3800);
  };

  // Staff Roster
  const [staffList, setStaffList] = useState<StaffItem[]>([
    {
      id: "STAFF-001",
      employeeCode: "METRO-STF-01",
      fullName: "Captain Asad Rauf",
      role: "Head Strength Coach & PT",
      phone: "+92 300 8899112",
      photoUrl: "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200&auto=format&fit=crop&q=80",
      shift: "Morning (06:00 AM - 02:00 PM)",
    },
    {
      id: "STAFF-002",
      employeeCode: "METRO-STF-02",
      fullName: "Zoya Alvi",
      role: "Clinical Sports Nutritionist",
      phone: "+92 321 4455667",
      photoUrl: "https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=200&auto=format&fit=crop&q=80",
      shift: "Evening (02:00 PM - 10:00 PM)",
    },
    {
      id: "STAFF-003",
      employeeCode: "METRO-STF-03",
      fullName: "Usman Tariq",
      role: "Front Desk & Turnstile Supervisor",
      phone: "+92 333 1122334",
      photoUrl: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200&auto=format&fit=crop&q=80",
      shift: "Morning (06:00 AM - 02:00 PM)",
    },
    {
      id: "STAFF-004",
      employeeCode: "METRO-STF-04",
      fullName: "Bilal Butt",
      role: "CrossFit & Cardio Floor Coach",
      phone: "+92 304 9988776",
      photoUrl: "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200&auto=format&fit=crop&q=80",
      shift: "Evening (02:00 PM - 10:00 PM)",
    },
  ]);

  // Attendance Records
  const [attendanceLogs, setAttendanceLogs] = useState<AttendanceItem[]>([
    {
      id: "ATT-M-001",
      entityId: "MEM-A819C1",
      entityName: "Zain Malik",
      entityIdentifier: "METRO-202609-0001",
      photoUrl: "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200&auto=format&fit=crop&q=80",
      type: "MEMBER",
      departmentOrPlan: "Silver Plan",
      date: "2026-09-13",
      checkInTime: "06:45 AM",
      checkOutTime: "08:00 AM",
      status: "PRESENT",
      method: "BIOMETRIC_FINGER",
    },
    {
      id: "ATT-M-002",
      entityId: "MEM-B920D2",
      entityName: "Ayesha Khan",
      entityIdentifier: "METRO-202609-0002",
      photoUrl: "https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=200&auto=format&fit=crop&q=80",
      type: "MEMBER",
      departmentOrPlan: "Gold VIP Plan",
      date: "2026-09-13",
      checkInTime: "07:15 AM",
      checkOutTime: "08:30 AM",
      status: "PRESENT",
      method: "BIOMETRIC_FACE",
    },
    {
      id: "ATT-M-003",
      entityId: "MEM-C103E3",
      entityName: "Hamza Farooq",
      entityIdentifier: "METRO-202609-0003",
      photoUrl: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200&auto=format&fit=crop&q=80",
      type: "MEMBER",
      departmentOrPlan: "Basic Plan",
      date: "2026-09-13",
      checkInTime: "08:10 AM",
      checkOutTime: null,
      status: "PRESENT",
      method: "QR_SCAN",
    },
    {
      id: "ATT-M-004",
      entityId: "MEM-D204F4",
      entityName: "Junaid Khan",
      entityIdentifier: "METRO-202609-0004",
      photoUrl: "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200&auto=format&fit=crop&q=80",
      type: "MEMBER",
      departmentOrPlan: "Silver Plan",
      date: "2026-09-13",
      checkInTime: null,
      checkOutTime: null,
      status: "ABSENT",
      method: "MANUAL_DESK",
    },
    {
      id: "ATT-M-005",
      entityId: "MEM-E305G5",
      entityName: "Sara Tariq",
      entityIdentifier: "METRO-202609-0005",
      photoUrl: "https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=200&auto=format&fit=crop&q=80",
      type: "MEMBER",
      departmentOrPlan: "Gold VIP Plan",
      date: "2026-09-13",
      checkInTime: "09:20 AM",
      checkOutTime: null,
      status: "LATE",
      method: "GEOFENCE_APP",
      geofenceMeters: 18.4,
      notes: "Geofenced Check-in (18m from Gym)",
    },
    // Staff initial logs
    {
      id: "ATT-S-001",
      entityId: "STAFF-001",
      entityName: "Captain Asad Rauf",
      entityIdentifier: "METRO-STF-01",
      photoUrl: "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200&auto=format&fit=crop&q=80",
      type: "STAFF",
      departmentOrPlan: "Head Strength Coach & PT",
      date: "2026-09-13",
      checkInTime: "05:55 AM",
      checkOutTime: null,
      status: "PRESENT",
      method: "BIOMETRIC_FINGER",
    },
    {
      id: "ATT-S-002",
      entityId: "STAFF-002",
      entityName: "Zoya Alvi",
      entityIdentifier: "METRO-STF-02",
      photoUrl: "https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=200&auto=format&fit=crop&q=80",
      type: "STAFF",
      departmentOrPlan: "Clinical Sports Nutritionist",
      date: "2026-09-13",
      checkInTime: "01:50 PM",
      checkOutTime: null,
      status: "PRESENT",
      method: "BIOMETRIC_FACE",
    },
    {
      id: "ATT-S-003",
      entityId: "STAFF-003",
      entityName: "Usman Tariq",
      entityIdentifier: "METRO-STF-03",
      photoUrl: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200&auto=format&fit=crop&q=80",
      type: "STAFF",
      departmentOrPlan: "Front Desk & Turnstile Supervisor",
      date: "2026-09-13",
      checkInTime: "06:05 AM",
      checkOutTime: null,
      status: "PRESENT",
      method: "BIOMETRIC_FINGER",
    },
    {
      id: "ATT-S-004",
      entityId: "STAFF-004",
      entityName: "Bilal Butt",
      entityIdentifier: "METRO-STF-04",
      photoUrl: "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200&auto=format&fit=crop&q=80",
      type: "STAFF",
      departmentOrPlan: "CrossFit & Cardio Floor Coach",
      date: "2026-09-13",
      checkInTime: null,
      checkOutTime: null,
      status: "ABSENT",
      method: "MANUAL_DESK",
    },
  ]);

  // Hourly Footfall Data for Bar Chart
  const hourlyFootfall = [
    { hour: "6a", count: 18 },
    { hour: "7a", count: 34 },
    { hour: "8a", count: 26 },
    { hour: "9a", count: 15 },
    { hour: "10a", count: 9 },
    { hour: "11a", count: 7 },
    { hour: "12p", count: 5 },
    { hour: "1p", count: 4 },
    { hour: "2p", count: 6 },
    { hour: "3p", count: 12 },
    { hour: "4p", count: 28 },
    { hour: "5p", count: 52 },
    { hour: "6p", count: 78, peak: true },
    { hour: "7p", count: 84, peak: true },
    { hour: "8p", count: 62, peak: true },
    { hour: "9p", count: 39 },
    { hour: "10p", count: 14 },
  ];

  // Helper getters
  const memberRecords = attendanceLogs.filter((l) => l.type === "MEMBER" && l.date === selectedDate);
  const staffRecords = attendanceLogs.filter((l) => l.type === "STAFF" && l.date === selectedDate);
  const totalCheckInsToday = attendanceLogs.filter((l) => l.date === selectedDate && l.status !== "ABSENT" && l.checkInTime).length;
  const membersPresentToday = memberRecords.filter((l) => l.status === "PRESENT" || l.status === "LATE").length;
  const staffPresentToday = staffRecords.filter((l) => l.status === "PRESENT" || l.status === "LATE").length;

  const handleUpdateStatus = (id: string, newStatus: AttendanceItem["status"]) => {
    const updated = attendanceLogs.map((l) => {
      if (l.id === id) {
        const nowTime = new Date().toLocaleTimeString([], { hour: "2-digit", minute: "2-digit" });
        return {
          ...l,
          status: newStatus,
          checkInTime: newStatus === "ABSENT" ? null : (l.checkInTime || nowTime),
        };
      }
      return l;
    });
    setAttendanceLogs(updated);
  };

  const handleMarkAllMembersPresent = () => {
    const nowTime = new Date().toLocaleTimeString([], { hour: "2-digit", minute: "2-digit" });
    const updated = attendanceLogs.map((l) => {
      if (l.type === "MEMBER" && l.date === selectedDate) {
        return {
          ...l,
          status: "PRESENT" as const,
          checkInTime: l.checkInTime || nowTime,
        };
      }
      return l;
    });
    setAttendanceLogs(updated);
    showNotification("Members Attendance", "Marked all enrolled members as Present.");
  };

  const handleMarkAllMembersAbsent = () => {
    const updated = attendanceLogs.map((l) => {
      if (l.type === "MEMBER" && l.date === selectedDate) {
        return {
          ...l,
          status: "ABSENT" as const,
          checkInTime: null,
        };
      }
      return l;
    });
    setAttendanceLogs(updated);
    showNotification("Members Attendance", "Reset member roster to Absent.");
  };

  const handleMarkAllStaffPresent = () => {
    const updated = attendanceLogs.map((l) => {
      if (l.type === "STAFF" && l.date === selectedDate) {
        return {
          ...l,
          status: "PRESENT" as const,
          checkInTime: l.checkInTime || "06:00 AM",
        };
      }
      return l;
    });
    setAttendanceLogs(updated);
    showNotification("Staff Attendance", "Marked all staff as Present on shift.");
  };

  const handleSimulateBiometricPunch = (entityName: string, entityIdentifier: string, type: "MEMBER" | "STAFF") => {
    const nowTime = new Date().toLocaleTimeString([], { hour: "2-digit", minute: "2-digit" });
    const matchIdx = attendanceLogs.findIndex((l) => l.entityIdentifier === entityIdentifier && l.date === selectedDate);

    if (matchIdx >= 0) {
      const updated = [...attendanceLogs];
      updated[matchIdx] = {
        ...updated[matchIdx],
        status: "PRESENT",
        checkInTime: updated[matchIdx].checkInTime || nowTime,
        method: "BIOMETRIC_FINGER",
      };
      setAttendanceLogs(updated);
    }

    setDeviceConfig({ ...deviceConfig, totalLogs: deviceConfig.totalLogs + 1 });
    setShowSimulatorModal(false);
    showNotification("Biometric Turnstile Scan", `Access Granted for ${entityName} (${entityIdentifier}).`);
  };

  const filteredMembers = memberRecords.filter((m) => {
    const q = searchQuery.toLowerCase();
    const match = m.entityName.toLowerCase().includes(q) || m.entityIdentifier.toLowerCase().includes(q) || m.departmentOrPlan.toLowerCase().includes(q);
    if (!match) return false;
    if (statusFilter !== "ALL" && m.status !== statusFilter) return false;
    return true;
  });

  return (
    <PlatformLayout>
      {/* Toast */}
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
        {/* HEADER BAR */}
        <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 bg-white p-6 rounded-2xl border border-stone-200 shadow-xs">
          <div>
            <div className="flex items-center gap-2">
              <span className="p-2 bg-orange-100 text-orange-600 rounded-xl text-lg font-bold">📋</span>
              <h1 className="text-2xl font-black text-stone-900 tracking-tight">Attendance & Biometrics Hub</h1>
              <span className="px-2.5 py-0.5 rounded-full text-[10px] font-bold bg-emerald-100 text-emerald-800 border border-emerald-200 flex items-center gap-1">
                <span className="w-2 h-2 rounded-full bg-emerald-600 animate-pulse" />
                {deviceConfig.deviceModel} (TCP/IP Live)
              </span>
            </div>
            <p className="text-xs text-stone-500 mt-1">
              Live ZKTeco hardware socket stream, footfall graphs, geofenced member check-in, and staff shift rosters.
            </p>
          </div>

          <div className="flex items-center gap-2">
            <input
              type="date"
              value={selectedDate}
              onChange={(e) => setSelectedDate(e.target.value)}
              className="px-3 py-2 rounded-xl border border-stone-300 font-bold text-xs text-stone-700 bg-white"
            />
            <button
              onClick={() => setShowSimulatorModal(true)}
              className="px-4 py-2 rounded-xl bg-stone-900 hover:bg-stone-800 text-white font-bold text-xs flex items-center gap-1.5 shadow-xs transition"
            >
              <span>⚡</span>
              <span>Simulate Scan</span>
            </button>
          </div>
        </div>

        {/* KPI FOOTFALL STRIP */}
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
          <div className="p-4 bg-white rounded-2xl border border-stone-200 shadow-xs flex items-center justify-between">
            <div>
              <span className="text-[11px] font-bold text-stone-500 uppercase tracking-wider">Total Check-ins Today</span>
              <div className="text-2xl font-black text-stone-900 mt-0.5">{totalCheckInsToday}</div>
              <span className="text-[10px] text-orange-600 font-bold">Peak Traffic: 07:00 PM (84/hr)</span>
            </div>
            <div className="w-11 h-11 rounded-xl bg-orange-50 text-orange-600 flex items-center justify-center font-bold text-lg">
              📊
            </div>
          </div>

          <div className="p-4 bg-white rounded-2xl border border-stone-200 shadow-xs flex items-center justify-between">
            <div>
              <span className="text-[11px] font-bold text-stone-500 uppercase tracking-wider">Active Members In Gym</span>
              <div className="text-2xl font-black text-stone-900 mt-0.5">{membersPresentToday} / {memberRecords.length}</div>
              <span className="text-[10px] text-emerald-600 font-bold">Floor Capacity: 78%</span>
            </div>
            <div className="w-11 h-11 rounded-xl bg-emerald-50 text-emerald-600 flex items-center justify-center font-bold text-lg">
              🏋️
            </div>
          </div>

          <div className="p-4 bg-white rounded-2xl border border-stone-200 shadow-xs flex items-center justify-between">
            <div>
              <span className="text-[11px] font-bold text-stone-500 uppercase tracking-wider">Staff On Duty</span>
              <div className="text-2xl font-black text-stone-900 mt-0.5">{staffPresentToday} / {staffRecords.length}</div>
              <span className="text-[10px] text-stone-500 font-medium">Morning & Evening Shifts</span>
            </div>
            <div className="w-11 h-11 rounded-xl bg-blue-50 text-blue-600 flex items-center justify-center font-bold text-lg">
              👔
            </div>
          </div>

          <div className="p-4 bg-white rounded-2xl border border-stone-200 shadow-xs flex items-center justify-between">
            <div>
              <span className="text-[11px] font-bold text-stone-500 uppercase tracking-wider">Biometric Device Logs</span>
              <div className="text-2xl font-black text-stone-900 mt-0.5">{deviceConfig.totalLogs}</div>
              <span className="text-[10px] text-emerald-600 font-bold">Port 4370 • 100% Synced</span>
            </div>
            <div className="w-11 h-11 rounded-xl bg-stone-100 text-stone-700 flex items-center justify-center font-bold text-lg">
              🔒
            </div>
          </div>
        </div>

        {/* TABS SELECTOR */}
        <div className="flex bg-white p-1.5 rounded-2xl border border-stone-200 shadow-xs max-w-fit">
          <button
            onClick={() => setActiveTab("MEMBERS")}
            className={`px-4 py-2 rounded-xl text-xs font-bold transition ${
              activeTab === "MEMBERS" ? "bg-orange-600 text-white shadow-xs" : "text-stone-600 hover:text-stone-900"
            }`}
          >
            🏋️ Members Attendance ({membersPresentToday}/{memberRecords.length})
          </button>
          <button
            onClick={() => setActiveTab("STAFF")}
            className={`px-4 py-2 rounded-xl text-xs font-bold transition ${
              activeTab === "STAFF" ? "bg-orange-600 text-white shadow-xs" : "text-stone-600 hover:text-stone-900"
            }`}
          >
            👔 Staff & Trainers ({staffPresentToday}/{staffRecords.length})
          </button>
          <button
            onClick={() => setActiveTab("ANALYTICS")}
            className={`px-4 py-2 rounded-xl text-xs font-bold transition ${
              activeTab === "ANALYTICS" ? "bg-orange-600 text-white shadow-xs" : "text-stone-600 hover:text-stone-900"
            }`}
          >
            📊 Footfall Analytics
          </button>
          <button
            onClick={() => setActiveTab("HARDWARE")}
            className={`px-4 py-2 rounded-xl text-xs font-bold transition ${
              activeTab === "HARDWARE" ? "bg-orange-600 text-white shadow-xs" : "text-stone-600 hover:text-stone-900"
            }`}
          >
            ⚙️ Biometric Hardware & Geofence
          </button>
        </div>

        {/* TAB 1: MEMBERS ATTENDANCE */}
        {activeTab === "MEMBERS" && (
          <div className="space-y-4">
            {/* Search & Bulk Bar */}
            <div className="bg-white p-4 rounded-2xl border border-stone-200 space-y-3">
              <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-2">
                <div className="flex-1 flex items-center gap-2 bg-stone-50 px-3 py-2 rounded-xl border border-stone-200">
                  <span className="text-stone-400">🔍</span>
                  <input
                    type="text"
                    placeholder="Search by Name, Roll # (METRO-202609-0001), or Plan..."
                    value={searchQuery}
                    onChange={(e) => setSearchQuery(e.target.value)}
                    className="w-full text-xs font-medium focus:outline-hidden bg-transparent"
                  />
                  {searchQuery && (
                    <button onClick={() => setSearchQuery("")} className="text-stone-400 hover:text-stone-600 text-xs">
                      Clear
                    </button>
                  )}
                </div>

                <div className="flex items-center gap-2">
                  <button
                    onClick={handleMarkAllMembersPresent}
                    className="px-3 py-2 rounded-xl bg-emerald-600 hover:bg-emerald-700 text-white font-bold text-xs transition"
                  >
                    ✓ Mark All Present
                  </button>
                  <button
                    onClick={handleMarkAllMembersAbsent}
                    className="px-3 py-2 rounded-xl bg-rose-50 hover:bg-rose-100 text-rose-700 font-bold text-xs border border-rose-200 transition"
                  >
                    ✕ Mark All Absent
                  </button>
                </div>
              </div>

              {/* Status Filter Chips */}
              <div className="flex items-center gap-1.5 pt-1 border-t border-stone-100">
                {["ALL", "PRESENT", "LATE", "ABSENT"].map((st) => (
                  <button
                    key={st}
                    onClick={() => setStatusFilter(st)}
                    className={`px-3 py-1 rounded-xl text-xs font-bold transition ${
                      statusFilter === st
                        ? "bg-stone-900 text-white shadow-xs"
                        : "bg-stone-100 text-stone-600 hover:bg-stone-200"
                    }`}
                  >
                    {st === "ALL" ? `All (${memberRecords.length})` : st}
                  </button>
                ))}
              </div>
            </div>

            {/* Member Attendance Table */}
            <div className="bg-white rounded-2xl border border-stone-200 shadow-xs overflow-hidden">
              <div className="overflow-x-auto">
                <table className="w-full text-left text-xs">
                  <thead className="bg-stone-50 text-stone-500 font-bold border-b border-stone-200">
                    <tr>
                      <th className="py-3.5 px-4">MEMBER</th>
                      <th className="py-3.5 px-4">ROLL NUMBER</th>
                      <th className="py-3.5 px-4">PLAN TIER</th>
                      <th className="py-3.5 px-4">CHECK-IN / OUT</th>
                      <th className="py-3.5 px-4">METHOD</th>
                      <th className="py-3.5 px-4">STATUS</th>
                      <th className="py-3.5 px-4 text-right">ACTION</th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-stone-100 text-stone-700">
                    {filteredMembers.map((record) => (
                      <tr key={record.id} className="hover:bg-orange-50/20 transition">
                        <td className="py-3 px-4">
                          <div className="flex items-center gap-2.5">
                            <img src={record.photoUrl} alt={record.entityName} className="w-8 h-8 rounded-full object-cover border border-stone-200" />
                            <span className="font-bold text-stone-900">{record.entityName}</span>
                          </div>
                        </td>
                        <td className="py-3 px-4 font-mono font-bold text-orange-600">{record.entityIdentifier}</td>
                        <td className="py-3 px-4 font-medium text-stone-600">{record.departmentOrPlan}</td>
                        <td className="py-3 px-4">
                          <span className="font-mono font-bold text-stone-900">{record.checkInTime || "--"}</span>
                          {record.checkOutTime && <span className="text-stone-400 font-mono text-[10px]"> → {record.checkOutTime}</span>}
                        </td>
                        <td className="py-3 px-4">
                          <span className="px-2 py-0.5 rounded-md bg-stone-100 text-stone-700 font-medium text-[10.5px]">
                            {record.method.replace("_", " ")}
                          </span>
                        </td>
                        <td className="py-3 px-4">
                          <span
                            className={`px-2 py-0.5 rounded-full text-[10px] font-bold ${
                              record.status === "PRESENT"
                                ? "bg-emerald-100 text-emerald-800"
                                : record.status === "LATE"
                                ? "bg-amber-100 text-amber-800"
                                : "bg-rose-100 text-rose-800"
                            }`}
                          >
                            {record.status}
                          </span>
                        </td>
                        <td className="py-3 px-4 text-right">
                          <select
                            value={record.status}
                            onChange={(e) => handleUpdateStatus(record.id, e.target.value as any)}
                            className="px-2 py-1 rounded-lg border border-stone-300 font-bold text-[11px] bg-white cursor-pointer"
                          >
                            <option value="PRESENT">✅ Present</option>
                            <option value="LATE">⏳ Late</option>
                            <option value="ABSENT">❌ Absent</option>
                          </select>
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            </div>
          </div>
        )}

        {/* TAB 2: STAFF ATTENDANCE */}
        {activeTab === "STAFF" && (
          <div className="space-y-4">
            <div className="flex items-center justify-between bg-white p-4 rounded-2xl border border-stone-200 shadow-xs">
              <div>
                <h3 className="font-black text-stone-900 text-sm">Gym Staff Shift Rosters</h3>
                <p className="text-[11px] text-stone-500">Trainers, Nutritionists, Floor Coaches, and Turnstile Receptionists</p>
              </div>
              <div className="flex gap-2">
                <button
                  onClick={handleMarkAllStaffPresent}
                  className="px-3 py-1.5 rounded-xl bg-emerald-600 hover:bg-emerald-700 text-white font-bold text-xs"
                >
                  ✓ All Staff Present
                </button>
              </div>
            </div>

            <div className="bg-white rounded-2xl border border-stone-200 shadow-xs overflow-hidden">
              <div className="overflow-x-auto">
                <table className="w-full text-left text-xs">
                  <thead className="bg-stone-50 text-stone-500 font-bold border-b border-stone-200">
                    <tr>
                      <th className="py-3.5 px-4">EMPLOYEE</th>
                      <th className="py-3.5 px-4">STAFF CODE</th>
                      <th className="py-3.5 px-4">ROLE & DEPARTMENT</th>
                      <th className="py-3.5 px-4">TIME IN / OUT</th>
                      <th className="py-3.5 px-4">BIOMETRIC METHOD</th>
                      <th className="py-3.5 px-4">STATUS</th>
                      <th className="py-3.5 px-4 text-right">ACTION</th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-stone-100 text-stone-700">
                    {staffRecords.map((staff) => (
                      <tr key={staff.id} className="hover:bg-orange-50/20 transition">
                        <td className="py-3 px-4">
                          <div className="flex items-center gap-2.5">
                            <img src={staff.photoUrl} alt={staff.entityName} className="w-8 h-8 rounded-full object-cover border border-stone-200" />
                            <span className="font-bold text-stone-900">{staff.entityName}</span>
                          </div>
                        </td>
                        <td className="py-3 px-4 font-mono font-bold text-stone-700">{staff.entityIdentifier}</td>
                        <td className="py-3 px-4 font-medium text-stone-600">{staff.departmentOrPlan}</td>
                        <td className="py-3 px-4 font-mono font-bold">{staff.checkInTime || "Not Checked In"}</td>
                        <td className="py-3 px-4 text-stone-500">{staff.method.replace("_", " ")}</td>
                        <td className="py-3 px-4">
                          <span
                            className={`px-2 py-0.5 rounded-full text-[10px] font-bold ${
                              staff.status === "PRESENT" ? "bg-emerald-100 text-emerald-800" : "bg-rose-100 text-rose-800"
                            }`}
                          >
                            {staff.status}
                          </span>
                        </td>
                        <td className="py-3 px-4 text-right">
                          <select
                            value={staff.status}
                            onChange={(e) => handleUpdateStatus(staff.id, e.target.value as any)}
                            className="px-2 py-1 rounded-lg border border-stone-300 font-bold text-[11px] bg-white cursor-pointer"
                          >
                            <option value="PRESENT">✅ Present</option>
                            <option value="LATE">⏳ Late</option>
                            <option value="HALF_DAY">🌓 Half Day</option>
                            <option value="ABSENT">❌ Absent</option>
                          </select>
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            </div>
          </div>
        )}

        {/* TAB 3: FOOTFALL ANALYTICS */}
        {activeTab === "ANALYTICS" && (
          <div className="space-y-6">
            {/* Hourly Footfall Graph */}
            <div className="bg-white p-6 rounded-2xl border border-stone-200 shadow-xs space-y-4">
              <div className="flex items-center justify-between">
                <div>
                  <h3 className="font-black text-stone-900 text-base">Hourly Member Traffic Distribution</h3>
                  <p className="text-xs text-stone-500">Live footfall curve from 06:00 AM to 10:00 PM</p>
                </div>
                <span className="text-xs font-bold text-orange-600 bg-orange-50 px-2.5 py-1 rounded-lg border border-orange-200">
                  Peak Rush Hour: 07:00 PM (84 Members)
                </span>
              </div>

              {/* Bar Chart Visual */}
              <div className="pt-6 pb-2">
                <div className="h-44 flex items-end gap-2">
                  {hourlyFootfall.map((h, i) => {
                    const heightPct = (h.count / 90) * 100;
                    return (
                      <div key={i} className="flex-1 flex flex-col items-center gap-1 group">
                        <span className="text-[10px] font-bold text-stone-600 group-hover:text-orange-600">
                          {h.count}
                        </span>
                        <div
                          style={{ height: `${heightPct}%` }}
                          className={`w-full rounded-t-md transition-all ${
                            h.peak
                              ? "bg-orange-600 shadow-md shadow-orange-600/30"
                              : "bg-stone-200 hover:bg-stone-300"
                          }`}
                        />
                        <span className="text-[10px] font-medium text-stone-500 mt-1">{h.hour}</span>
                      </div>
                    );
                  })}
                </div>
              </div>
            </div>

            {/* Regularity Streaks */}
            <div className="bg-white p-6 rounded-2xl border border-stone-200 shadow-xs space-y-4">
              <h3 className="font-black text-stone-900 text-base">Top Member Workout Regularity Streaks</h3>
              <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                {[
                  { name: "Ayesha Khan", roll: "METRO-202609-0002", streak: "🔥 21 Days Streak", days: "28/30 Days" },
                  { name: "Zain Malik", roll: "METRO-202609-0001", streak: "🔥 14 Days Streak", days: "26/30 Days" },
                  { name: "Hamza Farooq", roll: "METRO-202609-0003", streak: "🔥 8 Days Streak", days: "20/30 Days" },
                ].map((item, idx) => (
                  <div key={idx} className="p-4 rounded-xl bg-stone-50 border border-stone-200 flex justify-between items-center">
                    <div>
                      <h4 className="font-bold text-stone-900 text-xs">{item.name}</h4>
                      <p className="font-mono text-stone-400 text-[10px]">{item.roll}</p>
                    </div>
                    <div className="text-right">
                      <span className="font-bold text-orange-600 text-xs block">{item.streak}</span>
                      <span className="text-[10px] text-stone-500">{item.days}</span>
                    </div>
                  </div>
                ))}
              </div>
            </div>
          </div>
        )}

        {/* TAB 4: BIOMETRIC HARDWARE & GEOFENCE */}
        {activeTab === "HARDWARE" && (
          <div className="space-y-6">
            {/* TCP/IP Bridge */}
            <div className="bg-white p-6 rounded-2xl border border-stone-200 shadow-xs space-y-4">
              <div className="flex items-center justify-between">
                <div className="flex items-center gap-2">
                  <span className="text-xl">🔌</span>
                  <h3 className="font-black text-stone-900 text-base">ZKTeco / Hikvision Socket Bridge</h3>
                </div>
                <span className="px-2.5 py-0.5 rounded-full text-xs font-bold bg-emerald-100 text-emerald-800">
                  Socket Active • Port 4370
                </span>
              </div>

              <div className="grid grid-cols-1 sm:grid-cols-2 gap-4 text-xs">
                <div>
                  <label className="block text-stone-600 font-bold mb-1">Static Device IP Address</label>
                  <input
                    type="text"
                    value={deviceConfig.ipAddress}
                    onChange={(e) => setDeviceConfig({ ...deviceConfig, ipAddress: e.target.value })}
                    className="w-full px-3 py-2 rounded-xl border border-stone-300 font-mono font-bold"
                  />
                </div>
                <div>
                  <label className="block text-stone-600 font-bold mb-1">TCP Socket Port</label>
                  <input
                    type="number"
                    value={deviceConfig.port}
                    onChange={(e) => setDeviceConfig({ ...deviceConfig, port: Number(e.target.value) })}
                    className="w-full px-3 py-2 rounded-xl border border-stone-300 font-mono font-bold"
                  />
                </div>
              </div>

              <button
                onClick={() => showNotification("Device Ping OK", `Connected to ZKTeco @ ${deviceConfig.ipAddress}:${deviceConfig.port} (0ms latency).`)}
                className="px-4 py-2 rounded-xl bg-stone-900 hover:bg-stone-800 text-white font-bold text-xs"
              >
                📡 Test TCP Socket Ping
              </button>
            </div>

            {/* Geofence Radar Slider */}
            <div className="bg-white p-6 rounded-2xl border border-stone-200 shadow-xs space-y-4">
              <div className="flex items-center gap-2">
                <span className="text-xl">📍</span>
                <div>
                  <h3 className="font-black text-stone-900 text-base">Member Mobile App Geofence Radar</h3>
                  <p className="text-xs text-stone-500">Self check-in is allowed only when member phone is physically within gym radius</p>
                </div>
              </div>

              <div className="space-y-2">
                <div className="flex justify-between text-xs font-bold">
                  <span>Allowed Gym Radius:</span>
                  <span className="text-orange-600">{geofenceRadius} meters (HQ Arena)</span>
                </div>
                <input
                  type="range"
                  min="10"
                  max="200"
                  value={geofenceRadius}
                  onChange={(e) => setGeofenceRadius(Number(e.target.value))}
                  className="w-full accent-orange-600"
                />
              </div>

              <button
                onClick={() => {
                  if (geofenceRadius <= 100) {
                    showNotification("Geofence Verified", `Zain Malik checked in (${geofenceRadius}m from Gym).`);
                  } else {
                    alert("Outside Allowed Range (>100m). Check-in rejected.");
                  }
                }}
                className="px-4 py-2 rounded-xl bg-emerald-600 hover:bg-emerald-700 text-white font-bold text-xs"
              >
                🛰️ Simulate Mobile Self Check-in ({geofenceRadius}m)
              </button>
            </div>
          </div>
        )}

        {/* MODAL: BIOMETRIC SCAN SIMULATOR */}
        {showSimulatorModal && (
          <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/60 backdrop-blur-xs p-4 animate-in fade-in">
            <div className="bg-white rounded-3xl max-w-md w-full p-6 space-y-4 border border-stone-200 shadow-2xl">
              <div className="flex items-center justify-between pb-3 border-b border-stone-200">
                <div className="flex items-center gap-2">
                  <span className="text-xl">⚡</span>
                  <h3 className="font-black text-stone-900 text-base">Biometric Turnstile Punch</h3>
                </div>
                <button onClick={() => setShowSimulatorModal(false)} className="text-stone-400 hover:text-stone-700 text-sm font-bold">
                  ✕
                </button>
              </div>

              <p className="text-xs text-stone-500">
                Simulate a real-time fingerprint/face scan event from the turnstile hardware:
              </p>

              <div className="space-y-2 max-h-64 overflow-y-auto">
                {attendanceLogs.map((item) => (
                  <div key={item.id} className="p-3 bg-stone-50 rounded-xl border border-stone-200 flex items-center justify-between">
                    <div className="flex items-center gap-2.5">
                      <img src={item.photoUrl} alt={item.entityName} className="w-8 h-8 rounded-full object-cover" />
                      <div>
                        <span className="font-bold text-stone-900 text-xs block">{item.entityName}</span>
                        <span className="font-mono text-stone-400 text-[10px]">{item.entityIdentifier}</span>
                      </div>
                    </div>
                    <button
                      onClick={() => handleSimulateBiometricPunch(item.entityName, item.entityIdentifier, item.type)}
                      className="px-3 py-1.5 rounded-lg bg-orange-600 hover:bg-orange-700 text-white font-bold text-xs shadow-xs"
                    >
                      Punch Scan
                    </button>
                  </div>
                ))}
              </div>
            </div>
          </div>
        )}
      </div>
    </PlatformLayout>
  );
}
