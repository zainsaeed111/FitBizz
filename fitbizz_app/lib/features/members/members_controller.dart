import 'package:flutter/material.dart';
import 'member_model.dart';
export 'member_model.dart';

class MembersController extends ChangeNotifier {
  static final MembersController instance = MembersController._internal();

  MembersController._internal() {
    _initSampleMembers();
  }

  final List<MemberModel> _members = [];

  List<MemberModel> get members => List.unmodifiable(_members);

  void _initSampleMembers() {
    _members.clear();
    _members.addAll([
      MemberModel(
        id: 'MEM-A819C1',
        memberNumber: 'METRO-202609-0001',
        fullName: 'Zain Malik',
        phone: '+92 300 1234567',
        cnic: '35202-1234567-1',
        dob: '1996-04-18',
        photoUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200&auto=format&fit=crop&q=80',
        planId: 'plan_silver',
        planName: 'Silver Plan',
        durationMonths: 1,
        admissionFee: 1500.0,
        monthlyFee: 6500.0,
        totalFeePaid: 8000.0,
        paymentMode: 'CASH',
        cashTendered: 10000.0,
        changeReturned: 2000.0,
        status: 'ACTIVE',
        joinedDate: '2026-09-01',
        expiryDate: '2026-10-01',
        checkInCount: 14,
        gender: 'Male',
        bloodGroup: 'O+',
        currentWeightKg: 78.5,
        targetWeightKg: 74.0,
        height: '5\'11"',
        fitnessGoal: 'Muscle Building & Lean Bulk',
        dietaryPreference: 'High Protein (160g+)',
        emergencyContactName: 'Kamran Malik (Brother)',
        emergencyContactPhone: '+92 321 7654321',
      ),
      MemberModel(
        id: 'MEM-B920D2',
        memberNumber: 'METRO-202609-0002',
        fullName: 'Ayesha Khan',
        phone: '+92 301 9876543',
        cnic: '35201-9876543-2',
        dob: '1999-08-22',
        photoUrl: 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=200&auto=format&fit=crop&q=80',
        planId: 'plan_gold_vip',
        planName: 'Gold VIP Plan',
        durationMonths: 1,
        admissionFee: 2000.0,
        monthlyFee: 12000.0,
        totalFeePaid: 14000.0,
        paymentMode: 'ONLINE',
        paymentRef: 'RAAST-TRX-893201',
        status: 'ACTIVE',
        joinedDate: '2026-08-15',
        expiryDate: '2026-10-15',
        checkInCount: 28,
        gender: 'Female',
        bloodGroup: 'A+',
        currentWeightKg: 59.0,
        targetWeightKg: 55.0,
        height: '5\'6"',
        fitnessGoal: 'Fat Loss & Core Conditioning',
        dietaryPreference: 'Low Carb / High Fiber',
        emergencyContactName: 'Farhan Khan (Father)',
        emergencyContactPhone: '+92 300 5551234',
      ),
      MemberModel(
        id: 'MEM-C103E3',
        memberNumber: 'METRO-202609-0003',
        fullName: 'Hamza Farooq',
        phone: '+92 302 4455667',
        cnic: '35202-4455667-3',
        dob: '1994-11-05',
        photoUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200&auto=format&fit=crop&q=80',
        planId: 'plan_basic',
        planName: 'Basic Plan',
        durationMonths: 1,
        admissionFee: 1000.0,
        monthlyFee: 3500.0,
        totalFeePaid: 4500.0,
        paymentMode: 'CASH',
        cashTendered: 5000.0,
        changeReturned: 500.0,
        status: 'ACTIVE',
        joinedDate: '2026-09-05',
        expiryDate: '2026-10-05',
        checkInCount: 6,
        gender: 'Male',
        bloodGroup: 'B+',
        currentWeightKg: 84.0,
        targetWeightKg: 78.0,
        height: '6\'0"',
        fitnessGoal: 'General Strength & Cardio',
        dietaryPreference: 'Standard Balanced',
      ),
      MemberModel(
        id: 'MEM-D204F4',
        memberNumber: 'METRO-202609-0004',
        fullName: 'Junaid Khan',
        phone: '+92 333 7891234',
        cnic: '35201-7891234-5',
        dob: '1998-05-14',
        photoUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200&auto=format&fit=crop&q=80',
        planId: 'plan_silver',
        planName: 'Silver Plan',
        durationMonths: 1,
        admissionFee: 1500.0,
        monthlyFee: 6500.0,
        totalFeePaid: 3500.0,
        paymentMode: 'CASH',
        status: 'ACTIVE',
        feeStatus: 'DUE',
        dueAmount: 4500.0,
        joinedDate: '2026-08-14',
        expiryDate: '2026-09-15',
        checkInCount: 19,
        gender: 'Male',
        bloodGroup: 'O+',
        currentWeightKg: 75.0,
        targetWeightKg: 70.0,
        fitnessGoal: 'Muscle Building',
        dietaryPreference: 'High Protein (Balanced)',
      ),
      MemberModel(
        id: 'MEM-E305G5',
        memberNumber: 'METRO-202609-0005',
        fullName: 'Sara Tariq',
        phone: '+92 345 6789012',
        cnic: '35202-6789012-6',
        dob: '2001-02-10',
        photoUrl: 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=200&auto=format&fit=crop&q=80',
        planId: 'plan_gold_vip',
        planName: 'Gold VIP Plan',
        durationMonths: 1,
        admissionFee: 2000.0,
        monthlyFee: 12000.0,
        totalFeePaid: 6000.0,
        paymentMode: 'ONLINE',
        paymentRef: 'RAAST-8819',
        status: 'ACTIVE',
        feeStatus: 'OVERDUE',
        dueAmount: 8000.0,
        joinedDate: '2026-08-05',
        expiryDate: '2026-09-05',
        checkInCount: 12,
        gender: 'Female',
        bloodGroup: 'AB+',
        currentWeightKg: 62.0,
        targetWeightKg: 58.0,
        fitnessGoal: 'Fat Loss & Core',
        dietaryPreference: 'Keto / Low Carb',
      ),
    ]);
  }

  List<MemberModel> get dueMembers => _members.where((m) => m.isDueSoon).toList();
  List<MemberModel> get overdueMembers => _members.where((m) => m.isOverdue).toList();
  double get totalPendingDues => _members.fold(0.0, (acc, m) => acc + m.dueAmount);
  double get totalCollectedThisMonth => _members.fold(0.0, (acc, m) => acc + m.totalFeePaid);

  String generateNextRollNumber() {
    final now = DateTime.now();
    final yearMonth = '${now.year}${now.month.toString().padLeft(2, '0')}';
    final seq = (_members.length + 1).toString().padLeft(4, '0');
    return 'METRO-$yearMonth-$seq';
  }

  String generateNextMemberId() {
    final now = DateTime.now();
    final hex = now.millisecondsSinceEpoch.toRadixString(16).toUpperCase();
    return 'MEM-$hex';
  }

  void addMember(MemberModel member) {
    _members.insert(0, member);
    notifyListeners();
  }

  void recordFeePayment(String memberId, double amountPaid, String paymentMode, {int extendMonths = 1, String? receiptRef}) {
    final idx = _members.indexWhere((m) => m.id == memberId);
    if (idx != -1) {
      final cur = _members[idx];
      final newDue = (cur.dueAmount - amountPaid).clamp(0.0, double.infinity);
      final newPaid = cur.totalFeePaid + amountPaid;
      
      // Calculate extended expiry
      DateTime currentExp;
      try {
        currentExp = DateTime.parse(cur.expiryDate);
      } catch (_) {
        currentExp = DateTime.now();
      }
      final baseDate = currentExp.isBefore(DateTime.now()) ? DateTime.now() : currentExp;
      final newExp = DateTime(baseDate.year, baseDate.month + extendMonths, baseDate.day);
      final newExpStr = "${newExp.year}-${newExp.month.toString().padLeft(2, '0')}-${newExp.day.toString().padLeft(2, '0')}";

      _members[idx] = cur.copyWith(
        totalFeePaid: newPaid,
        dueAmount: newDue,
        feeStatus: newDue > 0 ? 'PARTIAL' : 'PAID',
        status: 'ACTIVE',
        expiryDate: newExpStr,
        paymentMode: paymentMode,
        paymentRef: receiptRef ?? cur.paymentRef,
      );
      notifyListeners();
    }
  }

  void updateMember(MemberModel updated) {
    final idx = _members.indexWhere((m) => m.id == updated.id);
    if (idx != -1) {
      _members[idx] = updated;
      notifyListeners();
    }
  }

  void updateMemberStatus(String id, String newStatus) {
    final idx = _members.indexWhere((m) => m.id == id);
    if (idx != -1) {
      _members[idx].status = newStatus;
      notifyListeners();
    }
  }

  void changeMemberPlan(String id, {
    required String newPlanId,
    required String newPlanName,
    required int durationMonths,
    required double monthlyFee,
    required double totalPaid,
    required String newExpiryDate,
  }) {
    final idx = _members.indexWhere((m) => m.id == id);
    if (idx != -1) {
      final cur = _members[idx];
      _members[idx] = cur.copyWith(
        planId: newPlanId,
        planName: newPlanName,
        durationMonths: durationMonths,
        monthlyFee: monthlyFee,
        totalFeePaid: totalPaid,
        expiryDate: newExpiryDate,
        status: 'ACTIVE',
      );
      notifyListeners();
    }
  }

  void deleteMember(String id) {
    _members.removeWhere((m) => m.id == id);
    notifyListeners();
  }

  MemberModel? findByScanCode(String code) {
    final clean = code.trim().toLowerCase();
    for (final m in _members) {
      if (m.memberNumber.toLowerCase() == clean ||
          m.phone.replaceAll(RegExp(r'[^0-9]'), '').endsWith(clean.replaceAll(RegExp(r'[^0-9]'), '')) ||
          m.id == clean ||
          m.qrPayload.toLowerCase() == clean) {
        return m;
      }
    }
    return null;
  }
}
