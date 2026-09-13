import 'dart:math';
import 'package:flutter/material.dart';
import '../members/members_controller.dart';
import 'attendance_model.dart';
export 'attendance_model.dart';

class AttendanceController extends ChangeNotifier {
  static final AttendanceController instance = AttendanceController._internal();

  AttendanceController._internal() {
    _initStaffMembers();
    _initSampleAttendanceLogs();
  }

  final List<StaffMemberModel> _staff = [];
  final List<AttendanceRecord> _records = [];
  final BiometricDeviceConfig _deviceConfig = BiometricDeviceConfig();
  bool _isAutoSimulationRunning = false;

  List<StaffMemberModel> get staff => List.unmodifiable(_staff);
  List<AttendanceRecord> get allRecords => List.unmodifiable(_records);
  BiometricDeviceConfig get deviceConfig => _deviceConfig;
  bool get isAutoSimulationRunning => _isAutoSimulationRunning;

  void toggleAutoSimulation() {
    _isAutoSimulationRunning = !_isAutoSimulationRunning;
    notifyListeners();
  }

  // --- 1. INITIALIZE STAFF MEMBERS ---
  void _initStaffMembers() {
    _staff.clear();
    _staff.addAll([
      StaffMemberModel(
        id: 'STAFF-001',
        employeeCode: 'METRO-STF-01',
        fullName: 'Captain Asad Rauf',
        role: 'Head Strength Coach & PT',
        phone: '+92 300 8899112',
        photoUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200&auto=format&fit=crop&q=80',
        shift: 'Morning (06:00 AM - 02:00 PM)',
        joinedDate: '2024-01-10',
        monthlySalary: 85000.0,
      ),
      StaffMemberModel(
        id: 'STAFF-002',
        employeeCode: 'METRO-STF-02',
        fullName: 'Zoya Alvi',
        role: 'Clinical Sports Nutritionist',
        phone: '+92 321 4455667',
        photoUrl: 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=200&auto=format&fit=crop&q=80',
        shift: 'Evening (02:00 PM - 10:00 PM)',
        joinedDate: '2024-06-01',
        monthlySalary: 65000.0,
      ),
      StaffMemberModel(
        id: 'STAFF-003',
        employeeCode: 'METRO-STF-03',
        fullName: 'Usman Tariq',
        role: 'Front Desk & Turnstile Supervisor',
        phone: '+92 333 1122334',
        photoUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200&auto=format&fit=crop&q=80',
        shift: 'Morning (06:00 AM - 02:00 PM)',
        joinedDate: '2025-02-15',
        monthlySalary: 45000.0,
      ),
      StaffMemberModel(
        id: 'STAFF-004',
        employeeCode: 'METRO-STF-04',
        fullName: 'Bilal Butt',
        role: 'CrossFit & Cardio Floor Coach',
        phone: '+92 304 9988776',
        photoUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200&auto=format&fit=crop&q=80',
        shift: 'Evening (02:00 PM - 10:00 PM)',
        joinedDate: '2024-09-01',
        monthlySalary: 55000.0,
      ),
    ]);
  }

  // --- 2. INITIALIZE SAMPLE ATTENDANCE LOGS ---
  void _initSampleAttendanceLogs() {
    _records.clear();
    final today = _formatDate(DateTime.now());

    // Member Logs for Today
    _records.addAll([
      AttendanceRecord(
        id: 'ATT-M-001',
        entityId: 'MEM-A819C1',
        entityName: 'Zain Malik',
        entityIdentifier: 'METRO-202609-0001',
        photoUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200&auto=format&fit=crop&q=80',
        type: AttendanceType.member,
        departmentOrPlan: 'Silver Plan',
        date: today,
        checkInTime: '06:45 AM',
        checkOutTime: '08:00 AM',
        status: AttendanceStatus.present,
        method: CheckInMethod.biometricFinger,
        workoutDurationMinutes: 75,
        isSynced: true,
      ),
      AttendanceRecord(
        id: 'ATT-M-002',
        entityId: 'MEM-B920D2',
        entityName: 'Ayesha Khan',
        entityIdentifier: 'METRO-202609-0002',
        photoUrl: 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=200&auto=format&fit=crop&q=80',
        type: AttendanceType.member,
        departmentOrPlan: 'Gold VIP Plan',
        date: today,
        checkInTime: '07:15 AM',
        checkOutTime: '08:30 AM',
        status: AttendanceStatus.present,
        method: CheckInMethod.biometricFace,
        workoutDurationMinutes: 75,
        isSynced: true,
      ),
      AttendanceRecord(
        id: 'ATT-M-003',
        entityId: 'MEM-C103E3',
        entityName: 'Hamza Farooq',
        entityIdentifier: 'METRO-202609-0003',
        photoUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200&auto=format&fit=crop&q=80',
        type: AttendanceType.member,
        departmentOrPlan: 'Basic Plan',
        date: today,
        checkInTime: '08:10 AM',
        status: AttendanceStatus.present,
        method: CheckInMethod.qrScan,
        workoutDurationMinutes: 50,
        isSynced: true,
      ),
      AttendanceRecord(
        id: 'ATT-M-004',
        entityId: 'MEM-D204F4',
        entityName: 'Junaid Khan',
        entityIdentifier: 'METRO-202609-0004',
        photoUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200&auto=format&fit=crop&q=80',
        type: AttendanceType.member,
        departmentOrPlan: 'Silver Plan (DUE)',
        date: today,
        checkInTime: null,
        status: AttendanceStatus.absent,
        method: CheckInMethod.manualDesk,
        isSynced: true,
      ),
      AttendanceRecord(
        id: 'ATT-M-005',
        entityId: 'MEM-E305G5',
        entityName: 'Sara Tariq',
        entityIdentifier: 'METRO-202609-0005',
        photoUrl: 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=200&auto=format&fit=crop&q=80',
        type: AttendanceType.member,
        departmentOrPlan: 'Gold VIP Plan (OVERDUE)',
        date: today,
        checkInTime: '09:20 AM',
        status: AttendanceStatus.late,
        method: CheckInMethod.geofenceApp,
        geofenceDistanceMeters: 18.4,
        isSynced: true,
      ),
    ]);

    // Staff Logs for Today
    _records.addAll([
      AttendanceRecord(
        id: 'ATT-S-001',
        entityId: 'STAFF-001',
        entityName: 'Captain Asad Rauf',
        entityIdentifier: 'METRO-STF-01',
        photoUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200&auto=format&fit=crop&q=80',
        type: AttendanceType.staff,
        departmentOrPlan: 'Head Strength Coach & PT',
        date: today,
        checkInTime: '05:55 AM',
        status: AttendanceStatus.present,
        method: CheckInMethod.biometricFinger,
        isSynced: true,
      ),
      AttendanceRecord(
        id: 'ATT-S-002',
        entityId: 'STAFF-002',
        entityName: 'Zoya Alvi',
        entityIdentifier: 'METRO-STF-02',
        photoUrl: 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=200&auto=format&fit=crop&q=80',
        type: AttendanceType.staff,
        departmentOrPlan: 'Clinical Sports Nutritionist',
        date: today,
        checkInTime: '01:50 PM',
        status: AttendanceStatus.present,
        method: CheckInMethod.biometricFace,
        isSynced: true,
      ),
      AttendanceRecord(
        id: 'ATT-S-003',
        entityId: 'STAFF-003',
        entityName: 'Usman Tariq',
        entityIdentifier: 'METRO-STF-03',
        photoUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200&auto=format&fit=crop&q=80',
        type: AttendanceType.staff,
        departmentOrPlan: 'Front Desk & Turnstile Supervisor',
        date: today,
        checkInTime: '06:05 AM',
        status: AttendanceStatus.present,
        method: CheckInMethod.biometricFinger,
        isSynced: true,
      ),
      AttendanceRecord(
        id: 'ATT-S-004',
        entityId: 'STAFF-004',
        entityName: 'Bilal Butt',
        entityIdentifier: 'METRO-STF-04',
        photoUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200&auto=format&fit=crop&q=80',
        type: AttendanceType.staff,
        departmentOrPlan: 'CrossFit & Cardio Floor Coach',
        date: today,
        checkInTime: null,
        status: AttendanceStatus.absent,
        method: CheckInMethod.manualDesk,
        isSynced: true,
      ),
    ]);
  }

  String _formatDate(DateTime dt) {
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
  }

  String _formatCurrentTime() {
    final now = DateTime.now();
    final hour = now.hour % 12 == 0 ? 12 : now.hour % 12;
    final ampm = now.hour >= 12 ? 'PM' : 'AM';
    return '${hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')} $ampm';
  }

  // --- 3. FILTERED GETTERS ---
  List<AttendanceRecord> getRecordsByDate(String date, {AttendanceType? type}) {
    return _records.where((r) {
      if (r.date != date) return false;
      if (type != null && r.type != type) return false;
      return true;
    }).toList();
  }

  List<AttendanceRecord> getMemberRecords(String date) {
    return getRecordsByDate(date, type: AttendanceType.member);
  }

  List<AttendanceRecord> getStaffRecords(String date) {
    return getRecordsByDate(date, type: AttendanceType.staff);
  }

  int getTodayTotalCheckIns() {
    final today = _formatDate(DateTime.now());
    return _records.where((r) => r.date == today && r.status != AttendanceStatus.absent && r.checkInTime != null).length;
  }

  int getTodayMembersPresent() {
    final today = _formatDate(DateTime.now());
    return _records.where((r) => r.date == today && r.type == AttendanceType.member && r.status != AttendanceStatus.absent).length;
  }

  int getTodayStaffPresent() {
    final today = _formatDate(DateTime.now());
    return _records.where((r) => r.date == today && r.type == AttendanceType.staff && r.status != AttendanceStatus.absent).length;
  }

  // Hourly footfall breakdown for today (6 AM to 10 PM)
  Map<int, int> getHourlyFootfallToday() {
    return {
      6: 18,
      7: 34,
      8: 26,
      9: 15,
      10: 9,
      11: 7,
      12: 5,
      13: 4,
      14: 6,
      15: 12,
      16: 28,
      17: 52,
      18: 78,
      19: 84,
      20: 62,
      21: 39,
      22: 14,
    };
  }

  // --- 4. RECORD ACTIONS & BULK MARKING ---
  void setRecordStatus(String recordId, AttendanceStatus newStatus) {
    final idx = _records.indexWhere((r) => r.id == recordId);
    if (idx >= 0) {
      final old = _records[idx];
      _records[idx] = old.copyWith(
        status: newStatus,
        checkInTime: (newStatus != AttendanceStatus.absent && old.checkInTime == null)
            ? _formatCurrentTime()
            : (newStatus == AttendanceStatus.absent ? null : old.checkInTime),
        isSynced: true,
      );
      notifyListeners();
    }
  }

  void markAllMembersPresent(String date) {
    final allMembers = MembersController.instance.members;
    for (final m in allMembers) {
      final existingIdx = _records.indexWhere((r) => r.entityId == m.id && r.date == date);
      if (existingIdx >= 0) {
        final r = _records[existingIdx];
        _records[existingIdx] = r.copyWith(
          status: AttendanceStatus.present,
          checkInTime: r.checkInTime ?? _formatCurrentTime(),
        );
      } else {
        _records.add(AttendanceRecord(
          id: 'ATT-M-${_generateUniqueId()}',
          entityId: m.id,
          entityName: m.fullName,
          entityIdentifier: m.memberNumber,
          photoUrl: m.photoUrl,
          type: AttendanceType.member,
          departmentOrPlan: m.planName,
          date: date,
          checkInTime: _formatCurrentTime(),
          status: AttendanceStatus.present,
          method: CheckInMethod.manualDesk,
        ));
      }
    }
    notifyListeners();
  }

  void markAllMembersAbsent(String date) {
    final allMembers = MembersController.instance.members;
    for (final m in allMembers) {
      final existingIdx = _records.indexWhere((r) => r.entityId == m.id && r.date == date);
      if (existingIdx >= 0) {
        final r = _records[existingIdx];
        _records[existingIdx] = r.copyWith(
          status: AttendanceStatus.absent,
          checkInTime: null,
          checkOutTime: null,
        );
      } else {
        _records.add(AttendanceRecord(
          id: 'ATT-M-${_generateUniqueId()}',
          entityId: m.id,
          entityName: m.fullName,
          entityIdentifier: m.memberNumber,
          photoUrl: m.photoUrl,
          type: AttendanceType.member,
          departmentOrPlan: m.planName,
          date: date,
          checkInTime: null,
          status: AttendanceStatus.absent,
          method: CheckInMethod.manualDesk,
        ));
      }
    }
    notifyListeners();
  }

  void markAllStaffPresent(String date) {
    for (final s in _staff) {
      final existingIdx = _records.indexWhere((r) => r.entityId == s.id && r.date == date);
      if (existingIdx >= 0) {
        final r = _records[existingIdx];
        _records[existingIdx] = r.copyWith(
          status: AttendanceStatus.present,
          checkInTime: r.checkInTime ?? '06:00 AM',
        );
      } else {
        _records.add(AttendanceRecord(
          id: 'ATT-S-${_generateUniqueId()}',
          entityId: s.id,
          entityName: s.fullName,
          entityIdentifier: s.employeeCode,
          photoUrl: s.photoUrl,
          type: AttendanceType.staff,
          departmentOrPlan: s.role,
          date: date,
          checkInTime: '06:00 AM',
          status: AttendanceStatus.present,
          method: CheckInMethod.biometricFinger,
        ));
      }
    }
    notifyListeners();
  }

  void markAllStaffAbsent(String date) {
    for (final s in _staff) {
      final existingIdx = _records.indexWhere((r) => r.entityId == s.id && r.date == date);
      if (existingIdx >= 0) {
        final r = _records[existingIdx];
        _records[existingIdx] = r.copyWith(
          status: AttendanceStatus.absent,
          checkInTime: null,
        );
      } else {
        _records.add(AttendanceRecord(
          id: 'ATT-S-${_generateUniqueId()}',
          entityId: s.id,
          entityName: s.fullName,
          entityIdentifier: s.employeeCode,
          photoUrl: s.photoUrl,
          type: AttendanceType.staff,
          departmentOrPlan: s.role,
          date: date,
          checkInTime: null,
          status: AttendanceStatus.absent,
          method: CheckInMethod.manualDesk,
        ));
      }
    }
    notifyListeners();
  }

  // --- 5. BIOMETRIC DEVICE SIMULATOR & FAST CHECK-IN ---
  void triggerBiometricCheckIn({
    required String entityId,
    required AttendanceType type,
    required CheckInMethod method,
    String? date,
    String? customNotes,
  }) {
    final targetDate = date ?? _formatDate(DateTime.now());
    final existingIdx = _records.indexWhere((r) => r.entityId == entityId && r.date == targetDate);

    String name = '';
    String ident = '';
    String photo = '';
    String deptOrPlan = '';

    if (type == AttendanceType.member) {
      final m = MembersController.instance.members.firstWhere(
        (mem) => mem.id == entityId,
        orElse: () => MembersController.instance.members.first,
      );
      name = m.fullName;
      ident = m.memberNumber;
      photo = m.photoUrl;
      deptOrPlan = m.planName;
    } else {
      final s = _staff.firstWhere(
        (st) => st.id == entityId,
        orElse: () => _staff.first,
      );
      name = s.fullName;
      ident = s.employeeCode;
      photo = s.photoUrl;
      deptOrPlan = s.role;
    }

    if (existingIdx >= 0) {
      final existing = _records[existingIdx];
      // Toggle / update to present
      _records[existingIdx] = existing.copyWith(
        status: AttendanceStatus.present,
        checkInTime: existing.checkInTime ?? _formatCurrentTime(),
        method: method,
        notes: customNotes,
        isSynced: true,
      );
    } else {
      _records.insert(
        0,
        AttendanceRecord(
          id: 'ATT-${type == AttendanceType.member ? "M" : "S"}-${_generateUniqueId()}',
          entityId: entityId,
          entityName: name,
          entityIdentifier: ident,
          photoUrl: photo,
          type: type,
          departmentOrPlan: deptOrPlan,
          date: targetDate,
          checkInTime: _formatCurrentTime(),
          status: AttendanceStatus.present,
          method: method,
          notes: customNotes,
          isSynced: true,
        ),
      );
    }

    _deviceConfig.totalDeviceLogs += 1;
    _deviceConfig.lastSyncTime = DateTime.now();
    notifyListeners();
  }

  // Geofenced Self Check-in (< 100 meters)
  bool geofenceSelfCheckIn(String memberId, double simulatedDistanceMeters) {
    if (simulatedDistanceMeters > 100.0) {
      return false; // Out of range
    }
    triggerBiometricCheckIn(
      entityId: memberId,
      type: AttendanceType.member,
      method: CheckInMethod.geofenceApp,
      customNotes: 'Geofence Verified (${simulatedDistanceMeters.toStringAsFixed(1)}m from HQ)',
    );
    return true;
  }

  void updateDeviceConfig({
    required String ip,
    required int port,
    required String model,
    required String location,
  }) {
    _deviceConfig.ipAddress = ip;
    _deviceConfig.port = port;
    _deviceConfig.deviceModel = model;
    _deviceConfig.location = location;
    notifyListeners();
  }

  static String _generateUniqueId() {
    return '${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(9999).toString().padLeft(4, "0")}';
  }
}
