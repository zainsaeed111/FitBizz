import 'dart:convert';
import 'package:flutter/material.dart';
import '../../core/network/api_client.dart';
import 'membership_plan_model.dart';
export 'membership_plan_model.dart';

class MembershipPlansController extends ChangeNotifier {
  static final MembershipPlansController instance = MembershipPlansController._internal();

  MembershipPlansController._internal() {
    _initDefaultPlans();
  }

  final ApiClient _apiClient = ApiClient();
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final List<MembershipPlan> _plans = [];

  List<MembershipPlan> get plans => List.unmodifiable(_plans);

  MembershipPlan? get defaultPlan =>
      _plans.firstWhere((p) => p.isDefault, orElse: () => _plans.isNotEmpty ? _plans.first : _createDefaultBasicPlan());

  MembershipPlan _createDefaultBasicPlan() {
    return MembershipPlan(
      id: 'plan_basic',
      name: 'Basic Plan',
      durationMonths: 1,
      admissionFee: 1000.0,
      monthlyFee: 3500.0,
      additionalCharges: 0.0,
      hasTrainerSupport: false,
      hasMealPlan: false,
      hasMobileApp: true,
      hasLockerAccess: true,
      isMultiBranch: false,
      badge: 'Default',
      isDefault: true,
    );
  }

  void _initDefaultPlans() {
    _plans.clear();
    _plans.addAll([
      // 1. Basic Plan (Default)
      _createDefaultBasicPlan(),

      // 2. Silver Plan (Enhanced with Beginner Guidance)
      MembershipPlan(
        id: 'plan_silver',
        name: 'Silver Plan',
        durationMonths: 1,
        admissionFee: 1500.0,
        monthlyFee: 6500.0,
        additionalCharges: 0.0,
        hasTrainerSupport: true,
        trainerSupportNote: 'Beginner Workout Guidance (First 2 Weeks)',
        hasMealPlan: true,
        hasMobileApp: true,
        hasLockerAccess: true,
        isMultiBranch: false,
        badge: 'Popular',
        isDefault: false,
      ),

      // 3. Gold VIP Plan
      MembershipPlan(
        id: 'plan_gold_vip',
        name: 'Gold VIP Plan',
        durationMonths: 1,
        admissionFee: 2000.0,
        monthlyFee: 12000.0,
        additionalCharges: 0.0,
        hasTrainerSupport: true,
        trainerSupportNote: '1-on-1 Dedicated Certified Personal Trainer',
        hasMealPlan: true,
        hasMobileApp: true,
        hasLockerAccess: true,
        isMultiBranch: true,
        badge: 'VIP Tier',
        isDefault: false,
      ),

      // 4. Quarterly Pro
      MembershipPlan(
        id: 'plan_quarterly',
        name: 'Quarterly Pro Plan',
        durationMonths: 3,
        admissionFee: 1500.0,
        monthlyFee: 4500.0,
        additionalCharges: 0.0,
        hasTrainerSupport: true,
        trainerSupportNote: 'Monthly Fitness Assessment & Guidance',
        hasMealPlan: true,
        hasMobileApp: true,
        hasLockerAccess: true,
        isMultiBranch: false,
        badge: '3-Months Saver',
        isDefault: false,
      ),
    ]);
  }

  Future<void> fetchPlansFromApi() async {
    try {
      _isLoading = true;
      notifyListeners();
      final res = await _apiClient.get('/plans');
      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body);
        if (data.isNotEmpty) {
          _plans.clear();
          for (final item in data) {
            _plans.add(MembershipPlan.fromJson(Map<String, dynamic>.from(item)));
          }
        }
      }
    } catch (_) {
      // Offline fallback: keep local plans
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  MembershipPlan? getPlanById(String id) {
    try {
      return _plans.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  void addPlan(MembershipPlan plan) {
    if (plan.isDefault) {
      for (final p in _plans) {
        p.isDefault = false;
      }
    }
    _plans.add(plan);
    notifyListeners();

    // Async sync with API in background
    _syncAddPlan(plan);
  }

  void _syncAddPlan(MembershipPlan plan) async {
    try {
      await _apiClient.post('/plans', plan.toJson());
    } catch (_) {}
  }

  void updatePlan(MembershipPlan plan) {
    final idx = _plans.indexWhere((p) => p.id == plan.id);
    if (idx != -1) {
      if (plan.isDefault) {
        for (final p in _plans) {
          p.isDefault = false;
        }
      }
      _plans[idx] = plan;
      notifyListeners();

      _syncUpdatePlan(plan);
    }
  }

  void _syncUpdatePlan(MembershipPlan plan) async {
    try {
      await _apiClient.put('/plans/${plan.id}', plan.toJson());
    } catch (_) {}
  }

  void deletePlan(String id) {
    if (_plans.length <= 1) return; // Keep at least one plan
    _plans.removeWhere((p) => p.id == id);
    if (!_plans.any((p) => p.isDefault)) {
      _plans.first.isDefault = true;
    }
    notifyListeners();

    _syncDeletePlan(id);
  }

  void _syncDeletePlan(String id) async {
    try {
      await _apiClient.delete('/plans/$id');
    } catch (_) {}
  }

  void setDefaultPlan(String id) {
    for (final p in _plans) {
      p.isDefault = (p.id == id);
    }
    notifyListeners();

    _syncSetDefaultPlan(id);
  }

  void _syncSetDefaultPlan(String id) async {
    try {
      await _apiClient.put('/plans/$id/set-default', {});
    } catch (_) {}
  }
}
