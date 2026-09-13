import 'dart:convert';

class GymSettingsModel {
  // Gym Profile
  final String gymName;
  final String branchName;
  final String ownerName;
  final String phone;
  final String email;
  final String address;
  final String city;
  final String taxNumber;
  final String currency;

  // POS Thermal Receipt Settings
  final String receiptHeader;
  final String receiptTagline;
  final String receiptWidth; // '58mm' or '80mm'
  final bool showQrCode;
  final bool showPoweredBy;
  final String customFooterNote;
  final bool autoPrintOnPayment;
  final bool autoWhatsAppOnPayment;

  // Access & Attendance
  final String defaultAttendanceMode; // 'hybridAll', 'biometricOnly', 'faceOnly', 'manualOnly'
  final double geofenceRadiusMeters;
  final int autoCheckoutHours;
  final bool allowSelfCheckIn;

  // Cloud & Sync Engine
  final String apiUrl;
  final bool isOnline;
  final String lastSyncedTime;
  final int pendingMutationsCount;
  final int autoSyncIntervalSeconds;

  const GymSettingsModel({
    this.gymName = 'Metro Fitness Club',
    this.branchName = 'HQ Arena - Main Campus',
    this.ownerName = 'Zain Malik',
    this.phone = '+92 300 1234567',
    this.email = 'owner@metrofitness.com',
    this.address = 'Main Boulevard, Block D, Gulberg III',
    this.city = 'Lahore, Pakistan',
    this.taxNumber = 'NTN: 8932014-7',
    this.currency = 'PKR ₨',
    this.receiptHeader = 'METRO FITNESS CLUB',
    this.receiptTagline = 'Transform Your Mind, Elevate Your Body',
    this.receiptWidth = '80mm',
    this.showQrCode = true,
    this.showPoweredBy = true,
    this.customFooterNote = 'Computer-generated POS Tax Receipt\nNo signature required • Non-refundable',
    this.autoPrintOnPayment = true,
    this.autoWhatsAppOnPayment = true,
    this.defaultAttendanceMode = 'hybridAll',
    this.geofenceRadiusMeters = 150.0,
    this.autoCheckoutHours = 3,
    this.allowSelfCheckIn = true,
    this.apiUrl = 'https://api.fitbizz.cloud/v1',
    this.isOnline = true,
    this.lastSyncedTime = 'Just now',
    this.pendingMutationsCount = 0,
    this.autoSyncIntervalSeconds = 30,
  });

  GymSettingsModel copyWith({
    String? gymName,
    String? branchName,
    String? ownerName,
    String? phone,
    String? email,
    String? address,
    String? city,
    String? taxNumber,
    String? currency,
    String? receiptHeader,
    String? receiptTagline,
    String? receiptWidth,
    bool? showQrCode,
    bool? showPoweredBy,
    String? customFooterNote,
    bool? autoPrintOnPayment,
    bool? autoWhatsAppOnPayment,
    String? defaultAttendanceMode,
    double? geofenceRadiusMeters,
    int? autoCheckoutHours,
    bool? allowSelfCheckIn,
    String? apiUrl,
    bool? isOnline,
    String? lastSyncedTime,
    int? pendingMutationsCount,
    int? autoSyncIntervalSeconds,
  }) {
    return GymSettingsModel(
      gymName: gymName ?? this.gymName,
      branchName: branchName ?? this.branchName,
      ownerName: ownerName ?? this.ownerName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      city: city ?? this.city,
      taxNumber: taxNumber ?? this.taxNumber,
      currency: currency ?? this.currency,
      receiptHeader: receiptHeader ?? this.receiptHeader,
      receiptTagline: receiptTagline ?? this.receiptTagline,
      receiptWidth: receiptWidth ?? this.receiptWidth,
      showQrCode: showQrCode ?? this.showQrCode,
      showPoweredBy: showPoweredBy ?? this.showPoweredBy,
      customFooterNote: customFooterNote ?? this.customFooterNote,
      autoPrintOnPayment: autoPrintOnPayment ?? this.autoPrintOnPayment,
      autoWhatsAppOnPayment: autoWhatsAppOnPayment ?? this.autoWhatsAppOnPayment,
      defaultAttendanceMode: defaultAttendanceMode ?? this.defaultAttendanceMode,
      geofenceRadiusMeters: geofenceRadiusMeters ?? this.geofenceRadiusMeters,
      autoCheckoutHours: autoCheckoutHours ?? this.autoCheckoutHours,
      allowSelfCheckIn: allowSelfCheckIn ?? this.allowSelfCheckIn,
      apiUrl: apiUrl ?? this.apiUrl,
      isOnline: isOnline ?? this.isOnline,
      lastSyncedTime: lastSyncedTime ?? this.lastSyncedTime,
      pendingMutationsCount: pendingMutationsCount ?? this.pendingMutationsCount,
      autoSyncIntervalSeconds: autoSyncIntervalSeconds ?? this.autoSyncIntervalSeconds,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'gymName': gymName,
      'branchName': branchName,
      'ownerName': ownerName,
      'phone': phone,
      'email': email,
      'address': address,
      'city': city,
      'taxNumber': taxNumber,
      'currency': currency,
      'receiptHeader': receiptHeader,
      'receiptTagline': receiptTagline,
      'receiptWidth': receiptWidth,
      'showQrCode': showQrCode,
      'showPoweredBy': showPoweredBy,
      'customFooterNote': customFooterNote,
      'autoPrintOnPayment': autoPrintOnPayment,
      'autoWhatsAppOnPayment': autoWhatsAppOnPayment,
      'defaultAttendanceMode': defaultAttendanceMode,
      'geofenceRadiusMeters': geofenceRadiusMeters,
      'autoCheckoutHours': autoCheckoutHours,
      'allowSelfCheckIn': allowSelfCheckIn,
      'apiUrl': apiUrl,
      'isOnline': isOnline,
      'lastSyncedTime': lastSyncedTime,
      'pendingMutationsCount': pendingMutationsCount,
      'autoSyncIntervalSeconds': autoSyncIntervalSeconds,
    };
  }

  factory GymSettingsModel.fromMap(Map<String, dynamic> map) {
    return GymSettingsModel(
      gymName: map['gymName'] ?? 'Metro Fitness Club',
      branchName: map['branchName'] ?? 'HQ Arena - Main Campus',
      ownerName: map['ownerName'] ?? 'Zain Malik',
      phone: map['phone'] ?? '+92 300 1234567',
      email: map['email'] ?? 'owner@metrofitness.com',
      address: map['address'] ?? 'Main Boulevard, Block D, Gulberg III',
      city: map['city'] ?? 'Lahore, Pakistan',
      taxNumber: map['taxNumber'] ?? 'NTN: 8932014-7',
      currency: map['currency'] ?? 'PKR ₨',
      receiptHeader: map['receiptHeader'] ?? 'METRO FITNESS CLUB',
      receiptTagline: map['receiptTagline'] ?? 'Transform Your Mind, Elevate Your Body',
      receiptWidth: map['receiptWidth'] ?? '80mm',
      showQrCode: map['showQrCode'] ?? true,
      showPoweredBy: map['showPoweredBy'] ?? true,
      customFooterNote: map['customFooterNote'] ?? 'Computer-generated POS Tax Receipt\nNo signature required • Non-refundable',
      autoPrintOnPayment: map['autoPrintOnPayment'] ?? true,
      autoWhatsAppOnPayment: map['autoWhatsAppOnPayment'] ?? true,
      defaultAttendanceMode: map['defaultAttendanceMode'] ?? 'hybridAll',
      geofenceRadiusMeters: (map['geofenceRadiusMeters'] as num?)?.toDouble() ?? 150.0,
      autoCheckoutHours: (map['autoCheckoutHours'] as num?)?.toInt() ?? 3,
      allowSelfCheckIn: map['allowSelfCheckIn'] ?? true,
      apiUrl: map['apiUrl'] ?? 'https://api.fitbizz.cloud/v1',
      isOnline: map['isOnline'] ?? true,
      lastSyncedTime: map['lastSyncedTime'] ?? 'Just now',
      pendingMutationsCount: (map['pendingMutationsCount'] as num?)?.toInt() ?? 0,
      autoSyncIntervalSeconds: (map['autoSyncIntervalSeconds'] as num?)?.toInt() ?? 30,
    );
  }

  String toJson() => jsonEncode(toMap());
  factory GymSettingsModel.fromJson(String source) => GymSettingsModel.fromMap(jsonDecode(source));
}
