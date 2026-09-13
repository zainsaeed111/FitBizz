import 'package:flutter/material.dart';
import '../../core/localization/app_locale.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/app_toast.dart';
import '../billing/billing_screen.dart';
import '../billing/thermal_receipt_dialog.dart';
import 'gym_settings_controller.dart';
import 'gym_settings_model.dart';

class GymSettingsScreen extends StatefulWidget {
  const GymSettingsScreen({super.key});

  @override
  State<GymSettingsScreen> createState() => _GymSettingsScreenState();
}

class _GymSettingsScreenState extends State<GymSettingsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Controllers for Profile
  late TextEditingController _gymNameController;
  late TextEditingController _branchNameController;
  late TextEditingController _ownerNameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _addressController;
  late TextEditingController _cityController;
  late TextEditingController _taxNumberController;
  late String _selectedCurrency;

  // Controllers for Thermal Receipt
  late TextEditingController _receiptHeaderController;
  late TextEditingController _receiptTaglineController;
  late String _receiptWidth;
  late bool _showQrCode;
  late bool _showPoweredBy;
  late TextEditingController _customFooterController;
  late bool _autoPrintOnPayment;
  late bool _autoWhatsAppOnPayment;

  // Access & Attendance
  late String _defaultAttendanceMode;
  late double _geofenceRadiusMeters;
  late int _autoCheckoutHours;
  late bool _allowSelfCheckIn;

  // Cloud & Sync
  late TextEditingController _apiUrlController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _populateFromSettings();
  }

  void _populateFromSettings() {
    final s = GymSettingsController.instance.settings;
    _gymNameController = TextEditingController(text: s.gymName);
    _branchNameController = TextEditingController(text: s.branchName);
    _ownerNameController = TextEditingController(text: s.ownerName);
    _phoneController = TextEditingController(text: s.phone);
    _emailController = TextEditingController(text: s.email);
    _addressController = TextEditingController(text: s.address);
    _cityController = TextEditingController(text: s.city);
    _taxNumberController = TextEditingController(text: s.taxNumber);
    _selectedCurrency = s.currency;

    _receiptHeaderController = TextEditingController(text: s.receiptHeader);
    _receiptTaglineController = TextEditingController(text: s.receiptTagline);
    _receiptWidth = s.receiptWidth;
    _showQrCode = s.showQrCode;
    _showPoweredBy = s.showPoweredBy;
    _customFooterController = TextEditingController(text: s.customFooterNote);
    _autoPrintOnPayment = s.autoPrintOnPayment;
    _autoWhatsAppOnPayment = s.autoWhatsAppOnPayment;

    _defaultAttendanceMode = s.defaultAttendanceMode;
    _geofenceRadiusMeters = s.geofenceRadiusMeters;
    _autoCheckoutHours = s.autoCheckoutHours;
    _allowSelfCheckIn = s.allowSelfCheckIn;

    _apiUrlController = TextEditingController(text: s.apiUrl);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _gymNameController.dispose();
    _branchNameController.dispose();
    _ownerNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _taxNumberController.dispose();
    _receiptHeaderController.dispose();
    _receiptTaglineController.dispose();
    _customFooterController.dispose();
    _apiUrlController.dispose();
    super.dispose();
  }

  void _saveAllSettings() async {
    final updated = GymSettingsModel(
      gymName: _gymNameController.text.trim(),
      branchName: _branchNameController.text.trim(),
      ownerName: _ownerNameController.text.trim(),
      phone: _phoneController.text.trim(),
      email: _emailController.text.trim(),
      address: _addressController.text.trim(),
      city: _cityController.text.trim(),
      taxNumber: _taxNumberController.text.trim(),
      currency: _selectedCurrency,
      receiptHeader: _receiptHeaderController.text.trim(),
      receiptTagline: _receiptTaglineController.text.trim(),
      receiptWidth: _receiptWidth,
      showQrCode: _showQrCode,
      showPoweredBy: _showPoweredBy,
      customFooterNote: _customFooterController.text.trim(),
      autoPrintOnPayment: _autoPrintOnPayment,
      autoWhatsAppOnPayment: _autoWhatsAppOnPayment,
      defaultAttendanceMode: _defaultAttendanceMode,
      geofenceRadiusMeters: _geofenceRadiusMeters,
      autoCheckoutHours: _autoCheckoutHours,
      allowSelfCheckIn: _allowSelfCheckIn,
      apiUrl: _apiUrlController.text.trim(),
      isOnline: GymSettingsController.instance.settings.isOnline,
      lastSyncedTime: GymSettingsController.instance.settings.lastSyncedTime,
      pendingMutationsCount: GymSettingsController.instance.settings.pendingMutationsCount,
    );

    await GymSettingsController.instance.saveSettings(updated);

    if (mounted) {
      AppToast.showSuccess(
        context,
        'Settings Saved',
        'Gym profile, POS thermal receipt layout, and cloud sync policies updated.',
      );
      setState(() {});
    }
  }

  void _previewReceipt() {
    final sampleInvoice = InvoiceRecord(
      id: 'INV-PREVIEW-001',
      memberName: 'Hamza Ali Khan',
      memberRoll: 'METRO-2026-0089',
      memberPhone: '+92 300 1234567',
      items: [
        InvoiceItem(name: 'Gold Monthly Membership Fee', quantity: 1, unitPrice: 8500.0),
        InvoiceItem(name: 'Biometric Access Tag Card', quantity: 1, unitPrice: 1000.0),
      ],
      subtotal: 9500.0,
      discount: 500.0,
      grandTotal: 9000.0,
      paymentMode: 'CASH',
      cashTendered: 10000.0,
      changeReturned: 1000.0,
      status: 'PAID',
      date: '2026-09-13',
    );

    PosThermalReceiptDialog.show(context, sampleInvoice);
  }

  @override
  Widget build(BuildContext context) {
    final settings = GymSettingsController.instance.settings;
    final isSyncing = GymSettingsController.instance.isSyncing;

    return Scaffold(
      backgroundColor: AppColors.stone50,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(bottom: BorderSide(color: AppColors.stone200)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.japaniPhal.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.settings_suggest, color: AppColors.japaniPhalDark, size: 24),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              tr('nav_settings'),
                              style: AppTypography.h2.copyWith(fontWeight: FontWeight.w900),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: settings.isOnline ? AppColors.green600.withValues(alpha: 0.12) : AppColors.red600.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: settings.isOnline ? AppColors.green600 : AppColors.red600,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    settings.isOnline ? 'Cloud Synced' : 'Offline Mode',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: settings.isOnline ? AppColors.green600 : AppColors.red600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'Branding, POS Thermal Receipt templates, biometric hardware policies & sync engine hub',
                          style: AppTypography.caption.copyWith(color: AppColors.stone500),
                        ),
                      ],
                    ),
                  ),
                  AppButton(
                    label: isSyncing ? 'Syncing...' : 'Force Sync',
                    icon: isSyncing ? Icons.hourglass_top : Icons.sync,
                    variant: AppButtonVariant.secondary,
                    isLoading: isSyncing,
                    onPressed: () {
                      GymSettingsController.instance.triggerFullSync(
                        onComplete: (count) {
                          AppToast.showSuccess(
                            context,
                            'Cloud & Local Engine Synced',
                            'All members, billing receipts, attendance punches and settings synced.',
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                  AppButton(
                    label: tr('save_changes'),
                    icon: Icons.save,
                    onPressed: _saveAllSettings,
                  ),
                ],
              ),
            ),

            // Tab Navigation
            Container(
              color: Colors.white,
              child: TabBar(
                controller: _tabController,
                indicatorColor: AppColors.japaniPhalDark,
                indicatorWeight: 3,
                labelColor: AppColors.japaniPhalDark,
                unselectedLabelColor: AppColors.stone600,
                labelStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                tabs: const [
                  Tab(icon: Icon(Icons.business_outlined, size: 18), text: '1. Gym Profile & Brand'),
                  Tab(icon: Icon(Icons.receipt_long_outlined, size: 18), text: '2. POS Thermal Receipt'),
                  Tab(icon: Icon(Icons.fingerprint, size: 18), text: '3. Access & Policies'),
                  Tab(icon: Icon(Icons.cloud_sync_outlined, size: 18), text: '4. Cloud & Sync Hub'),
                ],
              ),
            ),

            // Tab Views
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildProfileTab(),
                  _buildReceiptTab(),
                  _buildAccessPoliciesTab(),
                  _buildSyncHubTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- TAB 1: GYM PROFILE & BRANDING ---
  Widget _buildProfileTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 860),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.japaniPhal.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.fitness_center, color: AppColors.japaniPhalDark),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Gym Identification & Contact Info', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
                            Text('Displayed on member cards, invoices, receipts, and public apps', style: TextStyle(color: AppColors.stone500, fontSize: 11)),
                          ],
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: AppTextField(
                            label: 'Gym / Business Name',
                            hint: 'e.g. Metro Fitness Club',
                            controller: _gymNameController,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: AppTextField(
                            label: 'Branch / Arena Name',
                            hint: 'e.g. HQ Arena - Main Campus',
                            controller: _branchNameController,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      children: [
                        Expanded(
                          child: AppTextField(
                            label: 'Owner / Contact Person',
                            hint: 'e.g. Zain Malik',
                            controller: _ownerNameController,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: AppTextField(
                            label: 'Official Phone / WhatsApp',
                            hint: 'e.g. +92 300 1234567',
                            controller: _phoneController,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      children: [
                        Expanded(
                          child: AppTextField(
                            label: 'Business Email',
                            hint: 'e.g. owner@metrofitness.com',
                            controller: _emailController,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: AppTextField(
                            label: 'Tax NTN / Registration No',
                            hint: 'e.g. NTN: 8932014-7',
                            controller: _taxNumberController,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: AppTextField(
                            label: 'Street Address',
                            hint: 'e.g. Main Boulevard, Block D, Gulberg III',
                            controller: _addressController,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: AppTextField(
                            label: 'City & Country',
                            hint: 'e.g. Lahore, Pakistan',
                            controller: _cityController,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    const Text('Operating Currency:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5)),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      children: [
                        ChoiceChip(
                          label: const Text('PKR ₨ (Pakistan Rupee)'),
                          selected: _selectedCurrency == 'PKR ₨',
                          onSelected: (val) {
                            if (val) setState(() => _selectedCurrency = 'PKR ₨');
                          },
                        ),
                        ChoiceChip(
                          label: const Text('USD \$ (US Dollar)'),
                          selected: _selectedCurrency == 'USD \$',
                          onSelected: (val) {
                            if (val) setState(() => _selectedCurrency = 'USD \$');
                          },
                        ),
                        ChoiceChip(
                          label: const Text('AED (UAE Dirham)'),
                          selected: _selectedCurrency == 'AED',
                          onSelected: (val) {
                            if (val) setState(() => _selectedCurrency = 'AED');
                          },
                        ),
                        ChoiceChip(
                          label: const Text('GBP £ (British Pound)'),
                          selected: _selectedCurrency == 'GBP £',
                          onSelected: (val) {
                            if (val) setState(() => _selectedCurrency = 'GBP £');
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- TAB 2: POS THERMAL RECEIPT CUSTOMIZER ---
  Widget _buildReceiptTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 960),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Column: Configuration Controls
              Expanded(
                flex: 3,
                child: AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Thermal Slip Customizer', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
                              Text('Format 58mm/80mm rolls, headers, QR codes & policies', style: TextStyle(color: AppColors.stone500, fontSize: 11)),
                            ],
                          ),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.japaniPhalDark,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            icon: const Icon(Icons.remove_red_eye, size: 16),
                            label: const Text('Test Slip Dialog', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold)),
                            onPressed: _previewReceipt,
                          ),
                        ],
                      ),
                      const Divider(height: 20),
                      AppTextField(
                        label: 'Receipt Header Title',
                        hint: 'METRO FITNESS CLUB',
                        controller: _receiptHeaderController,
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      AppTextField(
                        label: 'Tagline / Slogan (Optional)',
                        hint: 'Transform Your Mind, Elevate Your Body',
                        controller: _receiptTaglineController,
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      const Text('Thermal Paper Roll Width:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5)),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () => setState(() => _receiptWidth = '80mm'),
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: _receiptWidth == '80mm' ? AppColors.japaniPhal.withValues(alpha: 0.1) : AppColors.stone100,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: _receiptWidth == '80mm' ? AppColors.japaniPhalDark : AppColors.stone300,
                                    width: _receiptWidth == '80mm' ? 2 : 1,
                                  ),
                                ),
                                child: const Column(
                                  children: [
                                    Text('80mm Standard POS', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13)),
                                    Text('Full-width desktop POS printers', style: TextStyle(fontSize: 10, color: AppColors.stone500)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: InkWell(
                              onTap: () => setState(() => _receiptWidth = '58mm'),
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: _receiptWidth == '58mm' ? AppColors.japaniPhal.withValues(alpha: 0.1) : AppColors.stone100,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: _receiptWidth == '58mm' ? AppColors.japaniPhalDark : AppColors.stone300,
                                    width: _receiptWidth == '58mm' ? 2 : 1,
                                  ),
                                ),
                                child: const Column(
                                  children: [
                                    Text('58mm Compact Mini', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13)),
                                    Text('Mobile Bluetooth & handheld units', style: TextStyle(fontSize: 10, color: AppColors.stone500)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      AppTextField(
                        label: 'Custom Policy / Footer Note',
                        hint: 'Computer-generated POS Tax Receipt\nNo signature required • Non-refundable',
                        controller: _customFooterController,
                        maxLines: 2,
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      SwitchListTile(
                        title: const Text('Show QR Code for Verification', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        subtitle: const Text('Allows digital verification via scanner or mobile camera', style: TextStyle(fontSize: 11, color: AppColors.stone500)),
                        value: _showQrCode,
                        activeThumbColor: AppColors.japaniPhalDark,
                        contentPadding: EdgeInsets.zero,
                        onChanged: (val) => setState(() => _showQrCode = val),
                      ),
                      SwitchListTile(
                        title: const Text('Show "Powered by FitBizz" Footer', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        subtitle: const Text('Displays official cloud verification badge on receipt', style: TextStyle(fontSize: 11, color: AppColors.stone500)),
                        value: _showPoweredBy,
                        activeThumbColor: AppColors.japaniPhalDark,
                        contentPadding: EdgeInsets.zero,
                        onChanged: (val) => setState(() => _showPoweredBy = val),
                      ),
                      SwitchListTile(
                        title: const Text('Auto-Launch Thermal Print on Payment', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        subtitle: const Text('Instantly opens native print dialog when fee is recorded', style: TextStyle(fontSize: 11, color: AppColors.stone500)),
                        value: _autoPrintOnPayment,
                        activeThumbColor: AppColors.japaniPhalDark,
                        contentPadding: EdgeInsets.zero,
                        onChanged: (val) => setState(() => _autoPrintOnPayment = val),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.lg),

              // Right Column: Live Interactive Thermal Slip Preview
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.stone800,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.receipt, color: AppColors.japaniPhal, size: 16),
                              SizedBox(width: 6),
                              Text('LIVE PREVIEW', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(_receiptWidth, style: const TextStyle(color: AppColors.japaniPhal, fontSize: 10, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Paper Preview
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFCFCFB),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.stone300),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Center(
                            child: Column(
                              children: [
                                Text(
                                  _receiptHeaderController.text.toUpperCase(),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.w900, fontSize: 13, color: AppColors.stone900),
                                ),
                                if (_receiptTaglineController.text.isNotEmpty)
                                  Text(
                                    _receiptTaglineController.text,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontFamily: 'monospace', fontSize: 8.5, color: AppColors.stone600),
                                  ),
                                Text(
                                  '${_branchNameController.text} • ${_taxNumberController.text}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontFamily: 'monospace', fontSize: 7.5, color: AppColors.stone500),
                                ),
                              ],
                            ),
                          ),
                          const Divider(height: 12, thickness: 0.8),
                          _buildPreviewRow('RCPT NO  :', 'INV-2026-0042'),
                          _buildPreviewRow('MEMBER   :', 'Hamza Ali Khan'),
                          _buildPreviewRow('ROLL NO  :', 'METRO-2026-0089'),
                          _buildPreviewRow('ITEM     :', 'Gold Monthly Plan'),
                          const Divider(height: 12, thickness: 0.8),
                          _buildPreviewRow('SUBTOTAL :', '$_selectedCurrency 8,500'),
                          _buildPreviewRow('NET PAID :', '$_selectedCurrency 8,500', isBold: true),
                          _buildPreviewRow('MODE     :', 'CASH (Exact)'),
                          const SizedBox(height: 8),
                          if (_showQrCode)
                            const Center(
                              child: Icon(Icons.qr_code_2, size: 48, color: AppColors.stone800),
                            ),
                          const SizedBox(height: 4),
                          Center(
                            child: Text(
                              _customFooterController.text,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontFamily: 'monospace', fontSize: 7, color: AppColors.stone500),
                            ),
                          ),
                          if (_showPoweredBy) ...[
                            const SizedBox(height: 6),
                            const Center(
                              child: Text(
                                '⚡ Powered by FitBizz POS',
                                style: TextStyle(fontFamily: 'monospace', fontSize: 7.5, fontWeight: FontWeight.bold, color: AppColors.japaniPhalDark),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPreviewRow(String label, String val, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontFamily: 'monospace', fontSize: 8.5, color: AppColors.stone600)),
          Text(val, style: TextStyle(fontFamily: 'monospace', fontSize: 8.5, fontWeight: isBold ? FontWeight.bold : FontWeight.normal, color: AppColors.stone900)),
        ],
      ),
    );
  }

  // --- TAB 3: ACCESS & ATTENDANCE POLICIES ---
  Widget _buildAccessPoliciesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 860),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Default Attendance & Hardware Operating Policy', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
                    const Text('Controls turnstiles, biometric scanners, face cameras, and mobile self check-in', style: TextStyle(color: AppColors.stone500, fontSize: 11)),
                    const Divider(height: 24),
                    const Text('Active Operating Mode:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    const SizedBox(height: 8),
                    _buildPolicyCard(
                      mode: 'hybridAll',
                      title: '🌐 Mode A: All Channels Enabled (Recommended)',
                      subtitle: 'Accepts Fingerprint, Face ID, Mobile 1-Tap Check-In, and Reception QR scan.',
                    ),
                    const SizedBox(height: 8),
                    _buildPolicyCard(
                      mode: 'biometricOnly',
                      title: '🔒 Mode B: Strict Biometric Only (High Security)',
                      subtitle: 'Requires physical fingerprint hardware or Face ID punch only.',
                    ),
                    const SizedBox(height: 8),
                    _buildPolicyCard(
                      mode: 'manualOnly',
                      title: '📋 Mode C: Reception Desk & Manual Only',
                      subtitle: 'All check-ins verified manually by front desk staff.',
                    ),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Mobile Geofencing Radius (Meters):', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        Text('${_geofenceRadiusMeters.toInt()}m', style: const TextStyle(fontWeight: FontWeight.w900, color: AppColors.japaniPhalDark)),
                      ],
                    ),
                    Slider(
                      value: _geofenceRadiusMeters,
                      min: 50,
                      max: 500,
                      divisions: 9,
                      activeColor: AppColors.japaniPhalDark,
                      label: '${_geofenceRadiusMeters.toInt()}m',
                      onChanged: (val) => setState(() => _geofenceRadiusMeters = val),
                    ),
                    const Text('Members must be within this distance from the gym coordinates to punch check-in from their phones.', style: TextStyle(fontSize: 11, color: AppColors.stone500)),
                    const Divider(height: 24),
                    SwitchListTile(
                      title: const Text('Allow Member App Self Check-In', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      subtitle: const Text('Members can check into the facility using their FitBizz Member mobile app', style: TextStyle(fontSize: 11, color: AppColors.stone500)),
                      value: _allowSelfCheckIn,
                      activeThumbColor: AppColors.japaniPhalDark,
                      contentPadding: EdgeInsets.zero,
                      onChanged: (val) => setState(() => _allowSelfCheckIn = val),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPolicyCard({required String mode, required String title, required String subtitle}) {
    final isSelected = _defaultAttendanceMode == mode;
    return InkWell(
      onTap: () => setState(() => _defaultAttendanceMode = mode),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.japaniPhal.withValues(alpha: 0.1) : AppColors.stone50,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppColors.japaniPhalDark : AppColors.stone300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
              color: isSelected ? AppColors.japaniPhalDark : AppColors.stone400,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: isSelected ? AppColors.japaniPhalDark : AppColors.stone900)),
                  Text(subtitle, style: const TextStyle(fontSize: 11, color: AppColors.stone500)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- TAB 4: CLOUD & OFFLINE SQLITE SYNC ENGINE HUB ---
  Widget _buildSyncHubTab() {
    final settings = GymSettingsController.instance.settings;
    final isSyncing = GymSettingsController.instance.isSyncing;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 860),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Cloud & Local Offline Sync Architecture', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
                            Text('Real-time synchronization between Local SQLite DB and FitBizz Cloud Multi-Tenant Cluster', style: TextStyle(color: AppColors.stone500, fontSize: 11)),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.green600.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.shield, size: 14, color: AppColors.green600),
                              SizedBox(width: 4),
                              Text('100% Data Integrity', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.green600)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.stone900,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.japaniPhal.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.sync, color: AppColors.japaniPhal, size: 24),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Local SQLite Engine Status: OPERATIONAL', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 13)),
                                Text('Last sync completed: ${settings.lastSyncedTime} • Offline Queue: ${settings.pendingMutationsCount} pending items', style: const TextStyle(color: AppColors.stone400, fontSize: 11)),
                              ],
                            ),
                          ),
                          AppButton(
                            label: isSyncing ? 'Syncing...' : 'Force Full Sync',
                            icon: Icons.sync,
                            isLoading: isSyncing,
                            onPressed: () {
                              GymSettingsController.instance.triggerFullSync(
                                onComplete: (count) {
                                  AppToast.showSuccess(
                                    context,
                                    'Sync Completed',
                                    'Successfully synchronized 100% of local records with cloud cluster.',
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    AppTextField(
                      label: 'Cloud Gateway API Endpoint',
                      hint: 'https://api.fitbizz.cloud/v1',
                      controller: _apiUrlController,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    const Text('Data Recovery & Local SQLite Management:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            icon: const Icon(Icons.download, size: 16),
                            label: const Text('Export Local DB Backup (.sqlite)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                            onPressed: () {
                              AppToast.showSuccess(context, 'Backup Exported', 'Local SQLite database exported to downloads directory.');
                            },
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            icon: const Icon(Icons.cleaning_services, size: 16),
                            label: const Text('Optimize SQLite Indices', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                            onPressed: () {
                              AppToast.showSuccess(context, 'Database Optimized', 'VACUUM & re-indexing complete with 0 latency.');
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
