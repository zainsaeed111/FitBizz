enum AttendanceType {
  member,
  staff,
}

enum AttendanceStatus {
  present,
  late,
  absent,
  halfDay,
}

enum CheckInMethod {
  biometricFinger,
  biometricFace,
  qrScan,
  geofenceApp,
  manualDesk,
}

class AttendanceRecord {
  final String id;
  final String entityId;
  final String entityName;
  final String entityIdentifier; // Roll Number or Staff ID
  final String photoUrl;
  final AttendanceType type;
  final String departmentOrPlan;
  final String date; // YYYY-MM-DD
  String? checkInTime; // e.g. "07:15 AM"
  String? checkOutTime; // e.g. "08:45 AM"
  AttendanceStatus status;
  CheckInMethod method;
  bool isSynced;
  String? syncTimestamp;
  double? geofenceDistanceMeters;
  int? workoutDurationMinutes;
  String? notes;

  AttendanceRecord({
    required this.id,
    required this.entityId,
    required this.entityName,
    required this.entityIdentifier,
    required this.photoUrl,
    required this.type,
    required this.departmentOrPlan,
    required this.date,
    this.checkInTime,
    this.checkOutTime,
    this.status = AttendanceStatus.present,
    this.method = CheckInMethod.biometricFinger,
    this.isSynced = true,
    this.syncTimestamp,
    this.geofenceDistanceMeters,
    this.workoutDurationMinutes,
    this.notes,
  });

  String get methodLabel {
    switch (method) {
      case CheckInMethod.biometricFinger:
        return 'Fingerprint (ZKTeco)';
      case CheckInMethod.biometricFace:
        return 'Face Recognition';
      case CheckInMethod.qrScan:
        return 'QR Pass Scan';
      case CheckInMethod.geofenceApp:
        return 'Geofenced Mobile App';
      case CheckInMethod.manualDesk:
        return 'Front Desk Manual';
    }
  }

  String get statusLabel {
    switch (status) {
      case AttendanceStatus.present:
        return 'Present';
      case AttendanceStatus.late:
        return 'Late';
      case AttendanceStatus.absent:
        return 'Absent';
      case AttendanceStatus.halfDay:
        return 'Half Day';
    }
  }

  AttendanceRecord copyWith({
    String? id,
    String? entityId,
    String? entityName,
    String? entityIdentifier,
    String? photoUrl,
    AttendanceType? type,
    String? departmentOrPlan,
    String? date,
    String? checkInTime,
    String? checkOutTime,
    AttendanceStatus? status,
    CheckInMethod? method,
    bool? isSynced,
    String? syncTimestamp,
    double? geofenceDistanceMeters,
    int? workoutDurationMinutes,
    String? notes,
  }) {
    return AttendanceRecord(
      id: id ?? this.id,
      entityId: entityId ?? this.entityId,
      entityName: entityName ?? this.entityName,
      entityIdentifier: entityIdentifier ?? this.entityIdentifier,
      photoUrl: photoUrl ?? this.photoUrl,
      type: type ?? this.type,
      departmentOrPlan: departmentOrPlan ?? this.departmentOrPlan,
      date: date ?? this.date,
      checkInTime: checkInTime ?? this.checkInTime,
      checkOutTime: checkOutTime ?? this.checkOutTime,
      status: status ?? this.status,
      method: method ?? this.method,
      isSynced: isSynced ?? this.isSynced,
      syncTimestamp: syncTimestamp ?? this.syncTimestamp,
      geofenceDistanceMeters: geofenceDistanceMeters ?? this.geofenceDistanceMeters,
      workoutDurationMinutes: workoutDurationMinutes ?? this.workoutDurationMinutes,
      notes: notes ?? this.notes,
    );
  }
}

class BiometricDeviceConfig {
  String ipAddress;
  int port;
  String deviceModel;
  String location;
  bool isConnected;
  DateTime lastSyncTime;
  int autoPollIntervalSec;
  int totalDeviceLogs;

  BiometricDeviceConfig({
    this.ipAddress = '192.168.1.201',
    this.port = 4370,
    this.deviceModel = 'ZKTeco SpeedFace-V5L (Turnstile #1)',
    this.location = 'Main Entrance Turnstile & Biometric Gate',
    this.isConnected = true,
    DateTime? lastSyncTime,
    this.autoPollIntervalSec = 5,
    this.totalDeviceLogs = 1482,
  }) : lastSyncTime = lastSyncTime ?? DateTime.now();
}

class StaffMemberModel {
  final String id;
  final String employeeCode;
  final String fullName;
  final String role; // Head Trainer, Floor Coach, Nutritionist, Front Desk, Cleaner
  final String phone;
  final String photoUrl;
  final String shift; // Morning (06:00 AM - 02:00 PM), Evening (02:00 PM - 10:00 PM)
  final String joinedDate;
  final double monthlySalary;

  StaffMemberModel({
    required this.id,
    required this.employeeCode,
    required this.fullName,
    required this.role,
    required this.phone,
    required this.photoUrl,
    required this.shift,
    required this.joinedDate,
    required this.monthlySalary,
  });
}

enum AttendanceMode {
  hybridAll('Hybrid (All Methods Enabled)'),
  biometricOnly('Biometric Fingerprint Machine Only'),
  faceOnly('AI Face Recognition Only'),
  manualOnly('Manual & 1-Tap App Button Only');

  final String label;
  const AttendanceMode(this.label);
}

/// Comprehensive Gym Owner Attendance Mode & Hardware Policy Settings
class AttendancePolicySettings {
  AttendanceMode primaryMode;
  bool allowManualAdminMarking; // Gym Owner / Front Desk can mark members directly
  bool allowMemberApp1Tap; // Member can mark from their mobile app button
  bool allowBiometricMachine; // ZKTeco / Turnstile hardware integration
  bool allowFaceRecognition; // AI Camera & Selfie Face Recognition
  bool allowGeofencing; // Geofenced distance validation
  double geofenceMaxRadiusMeters;
  bool allowMemberSelfFaceEnrollment; // Member can self-enroll face from their mobile camera
  bool allowMemberSelfFingerEnrollment; // Member can self-enroll fingerprint sensor
  String gymLatitude;
  String gymLongitude;

  AttendancePolicySettings({
    this.primaryMode = AttendanceMode.hybridAll,
    this.allowManualAdminMarking = true,
    this.allowMemberApp1Tap = true,
    this.allowBiometricMachine = true,
    this.allowFaceRecognition = true,
    this.allowGeofencing = true,
    this.geofenceMaxRadiusMeters = 100.0,
    this.allowMemberSelfFaceEnrollment = true,
    this.allowMemberSelfFingerEnrollment = true,
    this.gymLatitude = '31.5204',
    this.gymLongitude = '74.3587',
  });

  bool get isButtonAllowed => primaryMode == AttendanceMode.hybridAll || primaryMode == AttendanceMode.manualOnly;
  bool get isFingerprintAllowed => primaryMode == AttendanceMode.hybridAll || primaryMode == AttendanceMode.biometricOnly;
  bool get isFaceAllowed => primaryMode == AttendanceMode.hybridAll || primaryMode == AttendanceMode.faceOnly;
}

/// Member Biometric & Face Profile
class MemberBiometricProfile {
  final String memberId;
  bool isFingerprintEnrolled;
  String? fingerprintEnrolledDate;
  bool isFaceEnrolled;
  String? faceEnrolledDate;
  String? facePhotoUrl;

  MemberBiometricProfile({
    required this.memberId,
    this.isFingerprintEnrolled = false,
    this.fingerprintEnrolledDate,
    this.isFaceEnrolled = false,
    this.faceEnrolledDate,
    this.facePhotoUrl,
  });
}
