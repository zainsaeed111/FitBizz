import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/localization/app_locale.dart';
import 'gym_settings_model.dart';

class GymSettingsController extends ChangeNotifier {
  static final GymSettingsController instance = GymSettingsController._internal();
  GymSettingsController._internal();

  GymSettingsModel _settings = const GymSettingsModel();
  GymSettingsModel get settings => _settings;

  bool _isSyncing = false;
  bool get isSyncing => _isSyncing;

  Future<void> init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString('gym_settings_json');
      if (saved != null && saved.isNotEmpty) {
        _settings = GymSettingsModel.fromJson(saved);
        notifyListeners();
      }
    } catch (_) {
      // Use defaults if parse fails
    }
  }

  Future<void> saveSettings(GymSettingsModel newSettings) async {
    _settings = newSettings;
    notifyListeners();

    // Sync currency with AppLocaleController if currency changed
    if (newSettings.currency.contains('USD') || newSettings.currency.contains('\$')) {
      AppLocaleController.instance.setRegion(AppRegion.usa);
    } else if (newSettings.currency.contains('AED')) {
      AppLocaleController.instance.setRegion(AppRegion.uae);
    } else if (newSettings.currency.contains('GBP') || newSettings.currency.contains('£')) {
      AppLocaleController.instance.setRegion(AppRegion.uk);
    } else {
      AppLocaleController.instance.setRegion(AppRegion.pakistan);
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('gym_settings_json', _settings.toJson());
    } catch (_) {}
  }

  Future<void> triggerFullSync({Function(int syncedCount)? onComplete}) async {
    _isSyncing = true;
    notifyListeners();

    // Simulate mutation drain and cloud handshake
    await Future.delayed(const Duration(milliseconds: 900));

    final now = DateTime.now();
    final timeStr = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    _settings = _settings.copyWith(
      isOnline: true,
      lastSyncedTime: 'Today at $timeStr',
      pendingMutationsCount: 0,
    );

    _isSyncing = false;
    notifyListeners();

    onComplete?.call(12);
  }

  void refresh() {
    notifyListeners();
  }
}
