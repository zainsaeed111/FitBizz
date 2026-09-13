import 'package:flutter/material.dart';

/// Supported Languages in FitBizz
enum AppLanguage {
  english('en', 'English', 'English', '🇺🇸'),
  urdu('ur', 'Urdu', 'اردو', '🇵🇰'),
  arabic('ar', 'Arabic', 'العربية', '🇦🇪'),
  spanish('es', 'Spanish', 'Español', '🇪🇸');

  final String code;
  final String name;
  final String nativeName;
  final String flag;

  const AppLanguage(this.code, this.name, this.nativeName, this.flag);

  static AppLanguage fromCode(String code) {
    for (final lang in AppLanguage.values) {
      if (lang.code.toLowerCase() == code.toLowerCase()) return lang;
    }
    return AppLanguage.english;
  }
}

/// Supported Regions (Kept for currency formatting)
enum AppRegion {
  pakistan('PK', 'Pakistan', '₨', 'PKR'),
  usa('US', 'United States', '\$', 'USD'),
  uk('GB', 'United Kingdom', '£', 'GBP'),
  uae('AE', 'United Arab Emirates', 'AED ', 'AED');

  final String countryCode;
  final String countryName;
  final String currencySymbol;
  final String currencyCode;

  const AppRegion(
    this.countryCode,
    this.countryName,
    this.currencySymbol,
    this.currencyCode,
  );
}

/// Centralized Internationalization Dictionary Controller
class AppLocaleController extends ChangeNotifier {
  static final AppLocaleController instance = AppLocaleController._internal();

  AppLocaleController._internal();

  AppLanguage _currentLanguage = AppLanguage.english;
  AppRegion _currentRegion = AppRegion.pakistan;

  AppLanguage get currentLanguage => _currentLanguage;
  AppRegion get currentRegion => _currentRegion;
  String get currency => _currentRegion.currencySymbol;
  String get currencyCode => _currentRegion.currencyCode;
  bool get isRTL => _currentLanguage == AppLanguage.urdu || _currentLanguage == AppLanguage.arabic;

  void setLanguage(AppLanguage language) {
    if (_currentLanguage != language) {
      _currentLanguage = language;
      notifyListeners();
    }
  }

  void setRegion(AppRegion region) {
    if (_currentRegion != region) {
      _currentRegion = region;
      notifyListeners();
    }
  }

  /// Comprehensive 4-Language Translation Dictionary
  Map<String, Map<String, String>> get _translations => {
    // 1. ENGLISH (Default)
    'en': {
      // General & Common
      'app_title': 'FitBizz Multi-Tenant SaaS',
      'welcome': 'Welcome',
      'save_changes': 'Save Changes',
      'cancel': 'Cancel',
      'confirm': 'Confirm',
      'delete': 'Delete',
      'edit': 'Edit',
      'back': 'Back',
      'search': 'Search...',
      'status': 'Status',
      'active': 'Active',
      'expired': 'Expired',
      'suspended': 'Suspended',
      'live': 'Live',
      'hq': 'HQ',
      'sync': 'Sync',
      'sign_out': 'Sign Out',
      'force_sync': 'Force Sync',
      'local_engine_active': 'Local Engine • 100% OK',
      'sidebar_appearance': 'Sidebar Appearance',
      'theme_light': 'Light',
      'theme_dark': 'Dark',
      'pro_trial_remaining': 'Pro Plan • 14 Days Trial',
      'back_to_super_admin': 'Back to Super Admin HQ',

      // Navigation & Menus
      'nav_dashboard': 'Executive Dashboard',
      'nav_reception': 'Reception Terminal',
      'nav_members': 'Member Directory',
      'nav_attendance': 'Attendance & Biometrics',
      'nav_billing': 'Billing & Invoices',
      'nav_branches': 'Multi-Branch Network',
      'nav_trainers': 'Trainers & Staff',
      'nav_settings': 'Gym Settings',
      'nav_overview': 'Overview',
      'nav_onboard': 'Onboard New Gym',
      'nav_tenants': 'Registered Gym Tenants',
      'nav_owners': 'Owners Directory',
      'nav_subscriptions': 'Subscriptions & Plans',

      // Login Screen
      'login_welcome': 'Welcome Back',
      'login_subtitle': 'Sign in to manage your gym or platform operations.',
      'login_role_owner': 'Gym Owner',
      'login_role_super_admin': 'Super Admin',
      'login_role_receptionist': 'Reception Desk',
      'login_identifier_label': 'Email, Phone, or User/Gym ID',
      'login_identifier_hint': 'e.g. owner@metrofitness.com, 03001234567, or SUPER-001',
      'login_password_label': 'Password',
      'login_remember_me': 'Remember session',
      'login_forgot_password': 'Forgot password?',
      'login_sign_in': 'Sign In',
      'login_demo_helper': 'Testing Accounts & ID Reference',

      // Executive Dashboard (Gym Owner)
      'dash_title': 'Executive Dashboard',
      'dash_subtitle': 'Live tenant analytics & operational status',
      'dash_enroll_member': 'Enroll New Member',
      'dash_reception_terminal': 'Open Reception Terminal',
      'dash_fee_ledger': 'Fee Ledger & Invoices',
      'stat_total_members': 'Total Active Members',
      'stat_total_members_sub': '+18 enrolled this week (92% capacity)',
      'stat_today_checkins': 'Today Check-ins',
      'stat_today_checkins_sub': 'Peak hour: 6:00 PM (23 in gym now)',
      'stat_monthly_revenue': 'Monthly Fee Collections',
      'stat_monthly_revenue_sub': '94% collected • 6 pending',
      'stat_sync_status': 'Local Sync & Hardware',
      'stat_sync_status_sub': 'Biometric Turnstiles & SQLite Sync',
      'branch_network_health': 'Multi-Branch Network Health',
      'branches_deployed': '2 of 3 Branches Deployed',
      'realtime_attendance_feed': 'Real-Time Attendance Feed',
      'live_pulse': 'Live Pulse',
      'fee_renewals_dues': 'Fee Renewals & Dues',
      'all_dues_collected': 'All member dues collected!',
      'collect': 'Collect',
      'collect_payment': 'Collect Membership Fee',
      'whatsapp_reminder': 'WhatsApp',

      // Super Admin Dashboard
      'super_admin_title': 'Super Admin (Product Owner)',
      'super_admin_subtitle': 'Platform Governance & Tenant Onboarding',
      'registered_tenants': 'Registered Gym Tenants',
      'active_trials': 'Active 15-Day Trials',
      'total_branches': 'Total Branches Managed',
      'platform_mrr': 'Platform SaaS MRR',
      'build_custom_plan': 'Build Custom Plan',
      'edit_plan': 'Edit Plan',
      'edit_gym': 'Edit Gym Tenant',
      'delete_gym': 'Delete Gym',
      'share_credentials': 'Share Access Credentials',
      'whatsapp_dispatch': 'Send via WhatsApp',
      'email_dispatch': 'Send via Email',
      'copy_pack': 'Copy Credentials Pack',

      // Reception Terminal
      'rec_title': 'Reception Check-in Terminal',
      'rec_subtitle': 'Fast QR pass scanner & biometric verification',
      'rec_scan_qr': 'Scan Member QR Pass',
      'rec_manual_checkin': 'Manual Check-in',
      'rec_recent_entries': 'Recent Check-in Logs',

      // Member Directory
      'mem_title': 'Member Directory & Registry',
      'mem_subtitle': 'Manage member profiles, packages & attendance',
      'mem_add_member': 'Add New Member',
      'mem_search': 'Search member by name, phone or ID...',

      // Billing & Invoices
      'bill_title': 'Billing & Fee Invoices',
      'bill_subtitle': 'Track monthly membership fees & dues ledger',
      'bill_collect_fee': 'Record Fee Payment',
      'bill_total_collected': 'Total Collected This Month',
      'bill_pending_dues': 'Outstanding Pending Dues',
    },

    // 2. URDU (اردو)
    'ur': {
      // General & Common
      'app_title': 'فٹ بز ملٹی ٹیننٹ پلیٹ فارم',
      'welcome': 'خوش آمدید',
      'save_changes': 'تبدیلیاں محفوظ کریں',
      'cancel': 'منسوخ کریں',
      'confirm': 'تصدیق کریں',
      'delete': 'حذف کریں',
      'edit': 'تبدیل کریں',
      'back': 'واپس',
      'search': 'تلاش کریں...',
      'status': 'حیثیت',
      'active': 'فعال',
      'expired': 'ختم شدہ',
      'suspended': 'معطل',
      'live': 'لائیو',
      'hq': 'مرکزی',
      'sync': 'مطابقت پذیری',
      'sign_out': 'لاگ آؤٹ',
      'force_sync': 'فوری سنک کریں',
      'local_engine_active': 'لوکل انجن فعال • 100% سنک',
      'sidebar_appearance': 'سائیڈبار کی شکل',
      'theme_light': 'دن کا موڈ',
      'theme_dark': 'رات کا موڈ',
      'pro_trial_remaining': 'پرو پلان • 14 دن باقی',
      'back_to_super_admin': 'سپر ایڈمن ہیڈ کوارٹر پر واپس جائیں',

      // Navigation & Menus
      'nav_dashboard': 'ایگزیکٹو ڈیش بورڈ',
      'nav_reception': 'ریسیپشن ٹرمینل',
      'nav_members': 'ممبرز ڈائرکٹری',
      'nav_attendance': 'حاضری اور بائیو میٹرک',
      'nav_billing': 'بلنگ اور فیسیں',
      'nav_branches': 'ملٹی برانچ نیٹ ورک',
      'nav_trainers': 'ٹرینرز اور عملہ',
      'nav_settings': 'جم سیٹنگز',
      'nav_overview': 'اوور ویو',
      'nav_onboard': 'نیا جم آن بورڈ کریں',
      'nav_tenants': 'رجسٹرڈ جم کرایہ دار',
      'nav_owners': 'مالکان کی ڈائرکٹری',
      'nav_subscriptions': 'سبسکرپشنز اور پلینز',

      // Login Screen
      'login_welcome': 'دوبارہ خوش آمدید',
      'login_subtitle': 'اپنے جم یا پلیٹ فارم کو منظم کرنے کے لیے لاگ ان کریں۔',
      'login_role_owner': 'جم کا مالک',
      'login_role_super_admin': 'سپر ایڈمن',
      'login_role_receptionist': 'فرنٹ ڈیسک / ریسیپشن',
      'login_identifier_label': 'ای میل، فون نمبر یا صارف آئی ڈی',
      'login_identifier_hint': 'مثال: owner@metrofitness.com یا 03001234567',
      'login_password_label': 'پاس ورڈ',
      'login_remember_me': 'مجھے یاد رکھیں',
      'login_forgot_password': 'پاس ورڈ بھول گئے؟',
      'login_sign_in': 'لاگ ان کریں',
      'login_demo_helper': 'ٹیسٹنگ اکاؤنٹس اور ریفرنس آئی ڈیز',

      // Executive Dashboard (Gym Owner)
      'dash_title': 'ایگزیکٹو آپریشنز ڈیش بورڈ',
      'dash_subtitle': 'لائیو آپریشنل تجزیات اور برانچ کی صورتحال',
      'dash_enroll_member': 'نیا ممبر رجسٹر کریں',
      'dash_reception_terminal': 'ریسیپشن ٹرمینل کھولیں',
      'dash_fee_ledger': 'فیس لیجر اور رسیدیں',
      'stat_total_members': 'کل فعال ممبران',
      'stat_total_members_sub': 'اس ہفتے +18 نئے ممبران (92% گنجائش)',
      'stat_today_checkins': 'آج کی حاضری / چیک اِن',
      'stat_today_checkins_sub': 'رش کا وقت: شام 6:00 بجے (23 حاضر)',
      'stat_monthly_revenue': 'ماہانہ فیس کی وصولی',
      'stat_monthly_revenue_sub': '94% وصول شدہ • 6 بقایا جات',
      'stat_sync_status': 'لوکل سنک اور ہارڈویئر',
      'stat_sync_status_sub': 'بائیو میٹرک ٹرنسٹائلز اور SQLite سنک',
      'branch_network_health': 'ملٹی برانچ نیٹ ورک صورتحال',
      'branches_deployed': '3 میں سے 2 برانچز فعال',
      'realtime_attendance_feed': 'لائیو حاضری فیڈ',
      'live_pulse': 'لائیو نبض',
      'fee_renewals_dues': 'فیس کی تجدید اور بقایا جات',
      'all_dues_collected': 'تمام ممبران کے واجبات وصول ہو چکے ہیں!',
      'collect': 'وصول کریں',
      'collect_payment': 'ممبرشپ فیس وصول کریں',
      'whatsapp_reminder': 'واٹس ایپ یاد دہانی',

      // Super Admin Dashboard
      'super_admin_title': 'سپر ایڈمن (پروڈکٹ اونر)',
      'super_admin_subtitle': 'پلیٹ فارم گورننس اور جم آن بورڈنگ',
      'registered_tenants': 'رجسٹرڈ جم کرایہ دار',
      'active_trials': 'فعال 15 روزہ ٹرائلز',
      'total_branches': 'کل فعال برانچز',
      'platform_mrr': 'پلیٹ فارم کی ماہانہ آمدنی (MRR)',
      'build_custom_plan': 'نیا کسٹم معاہدہ بنائیں',
      'edit_plan': 'پلان تبدیل کریں',
      'edit_gym': 'جم تبدیل کریں',
      'delete_gym': 'جم حذف کریں',
      'share_credentials': 'لاگ ان تفصیلات شیئر کریں',
      'whatsapp_dispatch': 'واٹس ایپ پر بھیجیں',
      'email_dispatch': 'ای میل پر بھیجیں',
      'copy_pack': 'کریڈینشلز کاپی کریں',

      // Reception Terminal
      'rec_title': 'ریسیپشن چیک اِن ٹرمینل',
      'rec_subtitle': 'فوری کیو آر کوڈ سکینر اور بائیو میٹرک تصدیق',
      'rec_scan_qr': 'ممبر کا کیو آر پاس سکین کریں',
      'rec_manual_checkin': 'دستی چیک اِن',
      'rec_recent_entries': 'حالیہ چیک اِن لاگز',

      // Member Directory
      'mem_title': 'ممبر ڈائرکٹری اور پروفائلز',
      'mem_subtitle': 'ممبر تفصیلات، پیکیجز اور حاضری کا انتظام',
      'mem_add_member': 'نیا ممبر شامل کریں',
      'mem_search': 'نام، فون یا آئی ڈی سے ممبر تلاش کریں...',

      // Billing & Invoices
      'bill_title': 'بلنگ اور فیس رسیدیں',
      'bill_subtitle': 'ماہانہ ممبرشپ فیس اور بقایا جات کا ریکارڈ',
      'bill_collect_fee': 'فیس کی ادائیگی درج کریں',
      'bill_total_collected': 'اس ماہ کی کل وصولی',
      'bill_pending_dues': 'کل واجب الادا رقم',
    },

    // 3. ARABIC (العربية)
    'ar': {
      // General & Common
      'app_title': 'نظام فت بز لإدارة الصالات الرياضية',
      'welcome': 'مرحباً بك',
      'save_changes': 'حفظ التعديلات',
      'cancel': 'إلغاء',
      'confirm': 'تأكيد',
      'delete': 'حذف',
      'edit': 'تعديل',
      'back': 'رجوع',
      'search': 'بحث...',
      'status': 'الحالة',
      'active': 'نشط',
      'expired': 'منتهي',
      'suspended': 'معلق',
      'live': 'مباشر',
      'hq': 'المقر الرئيسي',
      'sync': 'مزامنة',
      'sign_out': 'تسجيل الخروج',
      'force_sync': 'مزامنة فورية',
      'local_engine_active': 'المحرك المحلي نشط • 100% متزامن',
      'sidebar_appearance': 'مظهر القائمة',
      'theme_light': 'الوضع النهاري',
      'theme_dark': 'الوضع الليلي',
      'pro_trial_remaining': 'الباقة الاحترافية • 14 يوماً متبقية',
      'back_to_super_admin': 'العودة إلى لوحة المدير العام',

      // Navigation & Menus
      'nav_dashboard': 'لوحة التحكم التنفيذية',
      'nav_reception': 'محطة الاستقبال',
      'nav_members': 'دليل الأعضاء',
      'nav_attendance': 'الحضور والبصمة البيومترية',
      'nav_billing': 'الفواتير والمدفوعات',
      'nav_branches': 'شبكة الفروع',
      'nav_trainers': 'المدربين والموظفين',
      'nav_settings': 'إعدادات الصالة',
      'nav_overview': 'نظرة عامة',
      'nav_onboard': 'تسجيل صالة جديدة',
      'nav_tenants': 'الصالات المسجلة',
      'nav_owners': 'دليل الملاك',
      'nav_subscriptions': 'الاشتراكات والباقات',

      // Login Screen
      'login_welcome': 'مرحباً بعودتك',
      'login_subtitle': 'سجل الدخول لإدارة صالتك الرياضية أو النظام.',
      'login_role_owner': 'مالك الصالة',
      'login_role_super_admin': 'المدير العام',
      'login_role_receptionist': 'مكتب الاستقبال',
      'login_identifier_label': 'البريد، الهاتف أو المعرف',
      'login_identifier_hint': 'مثال: owner@metrofitness.com أو 0501234567',
      'login_password_label': 'كلمة المرور',
      'login_remember_me': 'تذكر الجلسة',
      'login_forgot_password': 'نسيت كلمة المرور؟',
      'login_sign_in': 'تسجيل الدخول',
      'login_demo_helper': 'حسابات التجربة والمعرفات',

      // Executive Dashboard (Gym Owner)
      'dash_title': 'لوحة العمليات التنفيذية',
      'dash_subtitle': 'تحليلات مباشرة وحالة العمليات في الفروع',
      'dash_enroll_member': 'تسجيل عضو جديد',
      'dash_reception_terminal': 'فتح محطة الاستقبال',
      'dash_fee_ledger': 'سجل الرسوم والفواتير',
      'stat_total_members': 'إجمالي الأعضاء النشطين',
      'stat_total_members_sub': '+18 عضو هذا الأسبوع (92% من السعة)',
      'stat_today_checkins': 'حضور اليوم',
      'stat_today_checkins_sub': 'ساعة الذروة: 6:00 مساءً (23 في الصالة)',
      'stat_monthly_revenue': 'تحصيلات الرسوم الشهرية',
      'stat_monthly_revenue_sub': 'تم تحصيل 94% • 6 متأخرات',
      'stat_sync_status': 'المزامنة والأجهزة',
      'stat_sync_status_sub': 'البوابات البيومترية ومزامنة SQLite',
      'branch_network_health': 'حالة شبكة الفروع',
      'branches_deployed': 'فرعان نشطان من أصل 3',
      'realtime_attendance_feed': 'سجل الحضور المباشر',
      'live_pulse': 'نبض مباشر',
      'fee_renewals_dues': 'تجديدات الرسوم والمستحقات',
      'all_dues_collected': 'تم تحصيل جميع المستحقات بنجاح!',
      'collect': 'تحصيل',
      'collect_payment': 'تحصيل رسوم الاشتراك',
      'whatsapp_reminder': 'تذكير واتساب',

      // Super Admin Dashboard
      'super_admin_title': 'المدير العام (مالك المنصة)',
      'super_admin_subtitle': 'حوكمة المنصة وتسجيل الصالات الجديدة',
      'registered_tenants': 'الصالات الرياضية المسجلة',
      'active_trials': 'التجارب النشطة (15 يوم)',
      'total_branches': 'إجمالي الفروع المدارة',
      'platform_mrr': 'الإيرادات الشهرية المتكررة',
      'build_custom_plan': 'إنشاء باقة مخصصة',
      'edit_plan': 'تعديل الباقة',
      'edit_gym': 'تعديل الصالة',
      'delete_gym': 'حذف الصالة',
      'share_credentials': 'مشاركة بيانات الدخول',
      'whatsapp_dispatch': 'إرسال عبر واتساب',
      'email_dispatch': 'إرسال عبر البريد الإلكتروني',
      'copy_pack': 'نسخ بيانات الدخول',

      // Reception Terminal
      'rec_title': 'محطة تسجيل الدخول بالاستقبال',
      'rec_subtitle': 'مسح سريع لرمز QR والتحقق البيومتري',
      'rec_scan_qr': 'مسح بطاقة العضو الإلكترونية',
      'rec_manual_checkin': 'تسجيل يدوي',
      'rec_recent_entries': 'سجلات الدخول الحديثة',

      // Member Directory
      'mem_title': 'دليل وملفات الأعضاء',
      'mem_subtitle': 'إدارة بيانات واشتراكات وحضور الأعضاء',
      'mem_add_member': 'إضافة عضو جديد',
      'mem_search': 'البحث عن عضو بالاسم أو الهاتف...',

      // Billing & Invoices
      'bill_title': 'الفواتير وسجل الاشتراكات',
      'bill_subtitle': 'متابعة رسوم العضوية وسجلات السداد',
      'bill_collect_fee': 'تسجيل سداد رسوم',
      'bill_total_collected': 'إجمالي المحصل هذا الشهر',
      'bill_pending_dues': 'المستحقات المعلقة',
    },

    // 4. SPANISH (Español)
    'es': {
      // General & Common
      'app_title': 'FitBizz Plataforma Multi-Tenant',
      'welcome': 'Bienvenido',
      'save_changes': 'Guardar Cambios',
      'cancel': 'Cancelar',
      'confirm': 'Confirmar',
      'delete': 'Eliminar',
      'edit': 'Editar',
      'back': 'Atrás',
      'search': 'Buscar...',
      'status': 'Estado',
      'active': 'Activo',
      'expired': 'Vencido',
      'suspended': 'Suspendido',
      'live': 'En Vivo',
      'hq': 'Sede Principal',
      'sync': 'Sincronizar',
      'sign_out': 'Cerrar Sesión',
      'force_sync': 'Sincronizar Ahora',
      'local_engine_active': 'Motor Local • 100% OK',
      'sidebar_appearance': 'Aspecto de Barra Lateral',
      'theme_light': 'Modo Claro',
      'theme_dark': 'Modo Oscuro',
      'pro_trial_remaining': 'Plan Pro • 14 Días Restantes',
      'back_to_super_admin': 'Volver a Sede Super Admin',

      // Navigation & Menus
      'nav_dashboard': 'Panel Ejecutivo',
      'nav_reception': 'Terminal de Recepción',
      'nav_members': 'Directorio de Miembros',
      'nav_attendance': 'Asistencia y Biometría',
      'nav_billing': 'Facturación y Pagos',
      'nav_branches': 'Red de Sucursales',
      'nav_trainers': 'Entrenadores y Personal',
      'nav_settings': 'Ajustes del Gimnasio',
      'nav_overview': 'Resumen General',
      'nav_onboard': 'Registrar Nuevo Gimnasio',
      'nav_tenants': 'Gimnasios Registrados',
      'nav_owners': 'Directorio de Propietarios',
      'nav_subscriptions': 'Planes y Suscripciones',

      // Login Screen
      'login_welcome': 'Bienvenido de Nuevo',
      'login_subtitle': 'Inicia sesión para gestionar tu gimnasio u operaciones.',
      'login_role_owner': 'Propietario del Gimnasio',
      'login_role_super_admin': 'Super Administrador',
      'login_role_receptionist': 'Recepción y Control',
      'login_identifier_label': 'Correo, Teléfono o ID',
      'login_identifier_hint': 'ej. owner@metrofitness.com o +34 600123456',
      'login_password_label': 'Contraseña',
      'login_remember_me': 'Recordar sesión',
      'login_forgot_password': '¿Olvidaste tu contraseña?',
      'login_sign_in': 'Iniciar Sesión',
      'login_demo_helper': 'Cuentas de Prueba y Referencias',

      // Executive Dashboard (Gym Owner)
      'dash_title': 'Panel de Operaciones Ejecutivas',
      'dash_subtitle': 'Análisis en tiempo real y estado de sucursales',
      'dash_enroll_member': 'Inscribir Nuevo Socio',
      'dash_reception_terminal': 'Abrir Terminal de Recepción',
      'dash_fee_ledger': 'Libro de Cuotas y Recibos',
      'stat_total_members': 'Total de Socios Activos',
      'stat_total_members_sub': '+18 inscritos esta semana (92% de capacidad)',
      'stat_today_checkins': 'Accesos de Hoy',
      'stat_today_checkins_sub': 'Hora pico: 18:00 (23 en gimnasio ahora)',
      'stat_monthly_revenue': 'Recaudación Mensual de Cuotas',
      'stat_monthly_revenue_sub': '94% recaudado • 6 pendientes',
      'stat_sync_status': 'Sincronización y Hardware',
      'stat_sync_status_sub': 'Tornos Biométricos y Sincronización SQLite',
      'branch_network_health': 'Salud de Red de Sucursales',
      'branches_deployed': '2 de 3 Sucursales Activas',
      'realtime_attendance_feed': 'Flujo de Asistencia en Tiempo Real',
      'live_pulse': 'Pulso en Vivo',
      'fee_renewals_dues': 'Renovaciones de Cuotas y Pendientes',
      'all_dues_collected': '¡Todas las cuotas han sido cobradas!',
      'collect': 'Cobrar',
      'collect_payment': 'Cobrar Cuota de Membresía',
      'whatsapp_reminder': 'Recordatorio WhatsApp',

      // Super Admin Dashboard
      'super_admin_title': 'Super Admin (Dueño de Plataforma)',
      'super_admin_subtitle': 'Gobernanza de Plataforma y Registro de Gimnasios',
      'registered_tenants': 'Gimnasios Registrados',
      'active_trials': 'Pruebas Activas (15 Días)',
      'total_branches': 'Total de Sucursales Gestionadas',
      'platform_mrr': 'MRR de Plataforma SaaS',
      'build_custom_plan': 'Crear Plan Personalizado',
      'edit_plan': 'Editar Plan SaaS',
      'edit_gym': 'Editar Gimnasio',
      'delete_gym': 'Eliminar Gimnasio',
      'share_credentials': 'Compartir Credenciales de Acceso',
      'whatsapp_dispatch': 'Enviar por WhatsApp',
      'email_dispatch': 'Enviar por Correo',
      'copy_pack': 'Copiar Paquete de Credenciales',

      // Reception Terminal
      'rec_title': 'Terminal de Recepción y Control',
      'rec_subtitle': 'Escaneo rápido de pases QR y verificación biométrica',
      'rec_scan_qr': 'Escanear Pase QR',
      'rec_manual_checkin': 'Registro Manual',
      'rec_recent_entries': 'Registros Recientes de Acceso',

      // Member Directory
      'mem_title': 'Directorio y Perfiles de Socios',
      'mem_subtitle': 'Gestionar datos de socios, planes y asistencias',
      'mem_add_member': 'Añadir Nuevo Socio',
      'mem_search': 'Buscar socio por nombre, teléfono o ID...',

      // Billing & Invoices
      'bill_title': 'Facturación y Recibos',
      'bill_subtitle': 'Control de cuotas de socios y pagos pendientes',
      'bill_collect_fee': 'Registrar Pago de Cuota',
      'bill_total_collected': 'Total Recaudado Este Mes',
      'bill_pending_dues': 'Cuotas Pendientes de Cobro',
    },
  };

  String translate(String key) {
    return _translations[_currentLanguage.code]?[key] ??
        _translations['en']?[key] ??
        key;
  }
}

/// Helper function to translate keys quickly
String tr(String key) {
  return AppLocaleController.instance.translate(key);
}

/// Helper function to format numbers as currency
String formatMoney(num amount) {
  final controller = AppLocaleController.instance;
  final formattedNum = amount.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]},',
      );
  return '${controller.currency}$formattedNum';
}

/// Universal Language Selector Dropdown Widget
class AppLanguageSelector extends StatelessWidget {
  final bool compact;

  const AppLanguageSelector({super.key, this.compact = false});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppLocaleController.instance,
      builder: (context, _) {
        final current = AppLocaleController.instance.currentLanguage;

        return PopupMenuButton<AppLanguage>(
          tooltip: 'Select Language / زبان منتخب کریں',
          initialValue: current,
          onSelected: (lang) {
            AppLocaleController.instance.setLanguage(lang);
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: AppLanguage.english,
              child: Row(
                children: [
                  Text('🇺🇸', style: TextStyle(fontSize: 15)),
                  SizedBox(width: 8),
                  Text('English (US)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const PopupMenuItem(
              value: AppLanguage.urdu,
              child: Row(
                children: [
                  Text('🇵🇰', style: TextStyle(fontSize: 15)),
                  SizedBox(width: 8),
                  Text('اردو (Urdu)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const PopupMenuItem(
              value: AppLanguage.arabic,
              child: Row(
                children: [
                  Text('🇦🇪', style: TextStyle(fontSize: 15)),
                  SizedBox(width: 8),
                  Text('العربية (Arabic)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const PopupMenuItem(
              value: AppLanguage.spanish,
              child: Row(
                children: [
                  Text('🇪🇸', style: TextStyle(fontSize: 15)),
                  SizedBox(width: 8),
                  Text('Español (Spanish)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: compact ? 7 : 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE7E5E4)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(current.flag, style: const TextStyle(fontSize: 14)),
                if (!compact) ...[
                  const SizedBox(width: 6),
                  Text(
                    current.nativeName,
                    style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF1C1917)),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_drop_down, size: 16, color: Color(0xFF78716C)),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
