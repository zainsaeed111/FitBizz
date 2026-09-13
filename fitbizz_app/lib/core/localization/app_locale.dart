import 'package:flutter/material.dart';

/// Supported Regions and Languages in FitBizz
enum AppRegion {
  pakistan('PK', 'Pakistan', 'Urdu (اردو)', '₨', 'PKR', Locale('ur', 'PK')),
  usa('US', 'United States', 'English (US)', '\$', 'USD', Locale('en', 'US')),
  uk('GB', 'United Kingdom', 'English (UK)', '£', 'GBP', Locale('en', 'GB')),
  uae('AE', 'United Arab Emirates', 'Arabic (العربية)', 'AED ', 'AED', Locale('ar', 'AE'));

  final String countryCode;
  final String countryName;
  final String languageLabel;
  final String currencySymbol;
  final String currencyCode;
  final Locale locale;

  const AppRegion(
    this.countryCode,
    this.countryName,
    this.languageLabel,
    this.currencySymbol,
    this.currencyCode,
    this.locale,
  );
}

/// Centralized Internationalization Dictionary
class AppLocaleController extends ChangeNotifier {
  static final AppLocaleController instance = AppLocaleController._internal();

  AppLocaleController._internal();

  AppRegion _currentRegion = AppRegion.pakistan;

  AppRegion get currentRegion => _currentRegion;
  String get currency => _currentRegion.currencySymbol;
  String get currencyCode => _currentRegion.currencyCode;
  bool get isRTL => _currentRegion == AppRegion.uae || _currentRegion == AppRegion.pakistan;

  void setRegion(AppRegion region) {
    if (_currentRegion != region) {
      _currentRegion = region;
      notifyListeners();
    }
  }

  /// Translation strings dictionary
  static final Map<String, Map<String, String>> _translations = {
    'PK': {
      'nav_overview': 'اوور ویو',
      'nav_onboard': 'نیا جم آن بورڈ کریں',
      'nav_tenants': 'جم کرایہ دار',
      'nav_owners': 'مالکان کی ڈائرکٹری',
      'nav_subscriptions': 'سبسکرپشنز اور پلینز',
      'onboard_title': 'جم آن بورڈنگ وزرڈ',
      'onboard_subtitle': 'نیا فٹنس کاروبار رجسٹر کریں اور برانچز سیٹ اپ کریں',
      'step_business': 'کاروباری معلومات',
      'step_branches': 'برانچز کا انتظام',
      'step_assets': 'لوگو اور سہولیات',
      'step_plan': 'سبسکرپشن اور فیس',
      'detect_location': 'موجودہ GPS لوکیشن حاصل کریں',
      'location_detected': 'لوکیشن کامیابی سے حاصل ہو گئی',
      'custom_plan': 'کسٹم معاہدہ بنائیں',
      'preset_plans': 'مقررہ پیکجز',
      'next_step': 'اگلا مرحلہ',
      'prev_step': 'پچھلا مرحلہ',
      'finish_onboard': 'آن بورڈنگ مکمل کریں',
      'upload_logo': 'جم کا لوگو لگائیں',
      'upload_photo': 'مالک کی تصویر',
      'use_gps': 'لائیو GPS تلاش کریں',
      'val_gym_name': 'جم کا نام کم از کم 3 حروف کا ہونا چاہیے',
      'val_owner_name': 'مالک کا نام ضروری ہے',
      'val_email': 'درست ای میل ایڈریس درج کریں',
      'val_phone': 'درست فون نمبر درج کریں (کم از کم 10 ہندسے)',
      'val_address': 'ایڈریس درج کرنا لازمی ہے',
      'val_city': 'شہر منتخب کرنا لازمی ہے',
      'val_price': 'ماہانہ فیس صفر سے زیادہ ہونی چاہیے',
      'registered_tenants': 'رجسٹرڈ جم کرایہ دار',
      'active_trials': 'فعال 15 روزہ ٹرائلز',
      'total_branches': 'کل فعال برانچز',
      'platform_mrr': 'ماہانہ آمدنی (MRR)',
      'edit_gym': 'جم تبدیل کریں',
      'delete_gym': 'جم حذف کریں',
      'share_credentials': 'لاگ ان کی تفصیلات شیئر کریں',
      'whatsapp_dispatch': 'واٹس ایپ پر بھیجیں',
      'email_dispatch': 'ای میل پر بھیجیں',
      'copy_pack': 'کاپی کریں',
      'save_changes': 'تبدیلیاں محفوظ کریں',
      'cancel': 'منسوخ کریں',
      'build_custom_plan': 'نیا کسٹم پلان بنائیں',
      'edit_plan': 'پلان تبدیل کریں',
      'back': 'واپس',
      'continue_next': 'جاری رکھیں',
    },
    'US': {
      'nav_overview': 'Overview',
      'nav_onboard': 'Onboard New Gym',
      'nav_tenants': 'Gym Tenants',
      'nav_owners': 'Owners Directory',
      'nav_subscriptions': 'Subscriptions & Plans',
      'onboard_title': 'Gym Onboarding Wizard',
      'onboard_subtitle': 'Register new fitness business & multi-branch setups',
      'step_business': 'Business Profile',
      'step_branches': 'Branch Architecture',
      'step_assets': 'Identity & Facilities',
      'step_plan': 'SaaS Subscription Plan',
      'detect_location': 'Use Current GPS Location',
      'location_detected': 'GPS Coordinates Acquired',
      'custom_plan': 'Build Custom Agreement',
      'preset_plans': 'Preset Packages',
      'next_step': 'Next Step',
      'prev_step': 'Previous Step',
      'finish_onboard': 'Complete Onboarding',
      'upload_logo': 'Upload Gym Logo',
      'upload_photo': 'Select Owner Photo',
      'use_gps': 'Detect Live GPS Location',
      'val_gym_name': 'Gym name must be at least 3 characters',
      'val_owner_name': 'Owner full name is required',
      'val_email': 'Please enter a valid email address',
      'val_phone': 'Please enter a valid phone number (min 10 digits)',
      'val_address': 'Physical address is required',
      'val_city': 'City selection is required',
      'val_price': 'Monthly fee must be greater than 0',
      'registered_tenants': 'Registered Gym Tenants',
      'active_trials': 'Active 15-Day Trials',
      'total_branches': 'Total Branches Managed',
      'platform_mrr': 'Platform SaaS MRR',
      'edit_gym': 'Edit Gym Tenant',
      'delete_gym': 'Delete / Suspend Gym',
      'share_credentials': 'Share Access Credentials',
      'whatsapp_dispatch': 'Send via WhatsApp',
      'email_dispatch': 'Send via Email',
      'copy_pack': 'Copy Credentials',
      'save_changes': 'Save Changes',
      'cancel': 'Cancel',
      'build_custom_plan': 'Build Custom Plan',
      'edit_plan': 'Edit SaaS Plan',
      'back': 'Back',
      'continue_next': 'Continue',
    },
    'GB': {
      'nav_overview': 'Overview',
      'nav_onboard': 'Onboard New Gym',
      'nav_tenants': 'Gym Tenants',
      'nav_owners': 'Owners Directory',
      'nav_subscriptions': 'Subscriptions & Plans',
      'onboard_title': 'Gym Onboarding Centre',
      'onboard_subtitle': 'Enrol new fitness enterprise & branch networks',
      'step_business': 'Business Details',
      'step_branches': 'Branch Facilities',
      'step_assets': 'Branding & Facilities',
      'step_plan': 'Subscription Plan',
      'detect_location': 'Detect Current Location',
      'location_detected': 'Coordinates Located',
      'custom_plan': 'Design Custom Plan',
      'preset_plans': 'Standard Packages',
      'next_step': 'Continue',
      'prev_step': 'Back',
      'finish_onboard': 'Finalise Enrolment',
      'upload_logo': 'Upload Gym Logo',
      'upload_photo': 'Upload Owner Photo',
      'use_gps': 'Fetch Live GPS',
      'val_gym_name': 'Gym name must be at least 3 characters',
      'val_owner_name': 'Owner full name is required',
      'val_email': 'Please enter a valid email address',
      'val_phone': 'Please enter a valid phone number',
      'val_address': 'Address is required',
      'val_city': 'City is required',
      'val_price': 'Price must be positive',
      'registered_tenants': 'Registered Gym Tenants',
      'active_trials': 'Active 15-Day Trials',
      'total_branches': 'Total Branches Managed',
      'platform_mrr': 'Platform SaaS MRR',
      'edit_gym': 'Edit Gym Tenant',
      'delete_gym': 'Delete / Suspend Gym',
      'share_credentials': 'Share Access Credentials',
      'whatsapp_dispatch': 'Send via WhatsApp',
      'email_dispatch': 'Send via Email',
      'copy_pack': 'Copy Credentials',
      'save_changes': 'Save Changes',
      'cancel': 'Cancel',
      'build_custom_plan': 'Design Custom Plan',
      'edit_plan': 'Edit Plan',
      'back': 'Back',
      'continue_next': 'Continue',
    },
    'AE': {
      'nav_overview': 'نظرة عامة',
      'nav_onboard': 'تسجيل صالة جديدة',
      'nav_tenants': 'الصالات المسجلة',
      'nav_owners': 'دليل الملاك',
      'nav_subscriptions': 'الاشتراكات والباقات',
      'onboard_title': 'معالج تسجيل الصالات الرياضية',
      'onboard_subtitle': 'تسجيل منشأة لياقة بدنية وإعداد الفروع المتعددة',
      'step_business': 'بيانات المنشأة',
      'step_branches': 'إدارة الفروع',
      'step_assets': 'الهوية والمرافق',
      'step_plan': 'خطة الاشتراك',
      'detect_location': 'تحديد الموقع الحالي',
      'location_detected': 'تم تحديد الإحداثيات بنجاح',
      'custom_plan': 'باقة مخصصة',
      'preset_plans': 'الباقات الجاهزة',
      'next_step': 'التالي',
      'prev_step': 'السابق',
      'finish_onboard': 'إتمام التسجيل',
      'upload_logo': 'تحميل شعار الصالة',
      'upload_photo': 'صورة المالك',
      'use_gps': 'استخدام إحداثيات GPS',
      'val_gym_name': 'اسم الصالة يجب أن يكون 3 أحرف على الأقل',
      'val_owner_name': 'اسم المالك مطلوب',
      'val_email': 'يرجى إدخال بريد إلكتروني صحيح',
      'val_phone': 'يرجى إدخال رقم هاتف صحيح',
      'val_address': 'العنوان مطلوب',
      'val_city': 'المدينة مطلوبة',
      'val_price': 'المبلغ يجب أن يكون أكبر من الصفر',
      'registered_tenants': 'الصالات المسجلة',
      'active_trials': 'التجارب النشطة (15 يوم)',
      'total_branches': 'إجمالي الفروع المدارة',
      'platform_mrr': 'الإيرادات الشهرية المتكررة',
      'edit_gym': 'تعديل الصالة',
      'delete_gym': 'حذف الصالة',
      'share_credentials': 'مشاركة بيانات الدخول',
      'whatsapp_dispatch': 'إرسال عبر واتساب',
      'email_dispatch': 'إرسال عبر البريد الإلكتروني',
      'copy_pack': 'نسخ البيانات',
      'save_changes': 'حفظ التعديلات',
      'cancel': 'إلغاء',
      'build_custom_plan': 'إنشاء باقة مخصصة',
      'edit_plan': 'تعديل الباقة',
      'back': 'رجوع',
      'continue_next': 'متابعة',
    },
  };

  String translate(String key) {
    return _translations[_currentRegion.countryCode]?[key] ??
        _translations['US']?[key] ??
        key;
  }
}

/// Helper function to translate keys quickly
String tr(String key) {
  return AppLocaleController.instance.translate(key);
}

/// Helper function to format numbers as localized currency
String formatMoney(num amount) {
  final controller = AppLocaleController.instance;
  final formattedNum = amount.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]},',
      );
  return '${controller.currency}$formattedNum';
}

/// Language Selector Component with Modern UI
class LanguageRegionSelector extends StatelessWidget {
  const LanguageRegionSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppLocaleController.instance,
      builder: (context, _) {
        final current = AppLocaleController.instance.currentRegion;

        return PopupMenuButton<AppRegion>(
          initialValue: current,
          tooltip: 'Select Region / Language',
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: const Color(0xFFE7E5E4)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _getFlagEmoji(current.countryCode),
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(width: 6),
                Text(
                  '${current.countryCode} (${current.currencySymbol})',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1C1917)),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.keyboard_arrow_down, size: 14, color: Color(0xFF78716C)),
              ],
            ),
          ),
          onSelected: (region) {
            AppLocaleController.instance.setRegion(region);
          },
          itemBuilder: (context) {
            return AppRegion.values.map((region) {
              return PopupMenuItem<AppRegion>(
                value: region,
                child: Row(
                  children: [
                    Text(_getFlagEmoji(region.countryCode), style: const TextStyle(fontSize: 16)),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(region.countryName, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        Text(
                          '${region.languageLabel} • ${region.currencyCode} (${region.currencySymbol})',
                          style: const TextStyle(fontSize: 10, color: Color(0xFF78716C)),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }).toList();
          },
        );
      },
    );
  }

  String _getFlagEmoji(String countryCode) {
    switch (countryCode) {
      case 'PK':
        return '🇵🇰';
      case 'US':
        return '🇺🇸';
      case 'GB':
        return '🇬🇧';
      case 'AE':
        return '🇦🇪';
      default:
        return '🌐';
    }
  }
}
