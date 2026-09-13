import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/localization/app_locale.dart';
import '../../core/network/api_client.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_logo.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/utils/communication_launcher.dart';
import '../../core/widgets/app_toast.dart';
import 'super_admin_onboarding_screen.dart';

class GymTenantItem {
  String id;
  String gymName;
  String ownerName;
  String ownerEmail;
  String ownerPhone;
  String password;
  int branches;
  String status; // '15-Day Trial' | 'Paid Subscription' | 'Suspended'
  int trialDays;
  String date;
  String city;
  String planName;
  double monthlyPrice;

  GymTenantItem({
    required this.id,
    required this.gymName,
    required this.ownerName,
    required this.ownerEmail,
    required this.ownerPhone,
    this.password = 'password123',
    required this.branches,
    required this.status,
    required this.trialDays,
    required this.date,
    this.city = 'Lahore',
    this.planName = 'Pro Multi-Branch Plan',
    this.monthlyPrice = 35000,
  });
}

class SuperAdminDashboardScreen extends StatefulWidget {
  final ApiClient apiClient;
  final VoidCallback onSwitchToTenantPortal;
  final Function(GymTenantItem gym)? onManageGym;
  final VoidCallback? onLogout;

  const SuperAdminDashboardScreen({
    super.key,
    required this.apiClient,
    required this.onSwitchToTenantPortal,
    this.onManageGym,
    this.onLogout,
  });

  @override
  State<SuperAdminDashboardScreen> createState() => _SuperAdminDashboardScreenState();
}

class _SuperAdminDashboardScreenState extends State<SuperAdminDashboardScreen> {
  int _selectedNavIndex = 0;
  bool _isDarkSidebar = false; // Default to Crisp White & Stone Light Mode
  String _tenantSearchQuery = '';
  String _tenantStatusFilter = 'ALL';
  String _ownerSearchQuery = '';

  // Only 1 Clean Real Seed Entry
  final List<GymTenantItem> _gyms = [
    GymTenantItem(
      id: 'tenant-001',
      gymName: 'Metro Fitness Club',
      ownerName: 'Kamran Ahmed',
      ownerEmail: 'owner@metrofitness.com',
      ownerPhone: '+92 300 1234567',
      password: 'password123',
      branches: 2,
      status: '15-Day Trial',
      trialDays: 14,
      date: 'Sep 12, 2026',
      city: 'Lahore',
      planName: 'Pro Multi-Branch Plan',
      monthlyPrice: 35000,
    ),
  ];

  // Configured & Editable Subscription Tiers with Granular Modules
  final List<Map<String, dynamic>> _customPlans = [
    {
      'id': 'starter',
      'title': 'Starter Business Tier',
      'price': 15000.0,
      'period': '/ month',
      'subtitle': 'For single-location fitness studios & boutique clubs.',
      'badge': '1 Branch',
      'branches': 1,
      'members': 'Up to 300 members',
      'featAttendance': true,
      'featMembers': true,
      'featExpenses': true,
      'featMultiBranch': false,
      'featBiometrics': false,
      'featTrainer': false,
      'featCustomerApp': false,
      'featAi': false,
      'featWhatsApp': false,
      'featSla': false,
      'features': [
        'Membership & Member Registry',
        'QR Attendance & Check-in',
        'Fee Collection & Receipts',
        'Expense Tracking Ledger',
        'Drift Offline Local Engine',
      ],
      'activeGyms': 1,
      'isPopular': false,
    },
    {
      'id': 'pro',
      'title': 'Pro Multi-Branch Tier',
      'price': 35000.0,
      'period': '/ month',
      'subtitle': 'For growing multi-branch fitness centers and chain facilities.',
      'badge': 'MOST POPULAR',
      'branches': 3,
      'members': 'Up to 1,500 members',
      'featAttendance': true,
      'featMembers': true,
      'featExpenses': true,
      'featMultiBranch': true,
      'featBiometrics': true,
      'featTrainer': true,
      'featCustomerApp': true,
      'featAi': false,
      'featWhatsApp': true,
      'featSla': false,
      'features': [
        'Everything in Starter',
        'Multi-Branch Centralized Sync',
        'Biometric Turnstiles Integration',
        'Trainer Login & Client Rosters',
        'Customer Mobile Pass App',
        'WhatsApp Automated Invoices',
      ],
      'activeGyms': 1,
      'isPopular': true,
    },
    {
      'id': 'enterprise',
      'title': 'Enterprise Elite Suite',
      'price': 75000.0,
      'period': '/ month',
      'subtitle': 'Uncapped power for major fitness brands & franchised facilities.',
      'badge': 'Unlimited',
      'branches': 10,
      'members': 'Unlimited members',
      'featAttendance': true,
      'featMembers': true,
      'featExpenses': true,
      'featMultiBranch': true,
      'featBiometrics': true,
      'featTrainer': true,
      'featCustomerApp': true,
      'featAi': true,
      'featWhatsApp': true,
      'featSla': true,
      'features': [
        'Everything in Pro Suite',
        'AI Member Churn & Attendance Forecast',
        'Multi-City Franchise Ledger',
        'Dedicated PostgreSQL Cluster',
        'Custom Hardware Webhooks',
        '24/7 Priority SLA & Dedicated Server',
      ],
      'activeGyms': 0,
      'isPopular': false,
    },
  ];

  void _showCredentialsModal(GymTenantItem gym, {bool isNewlyCreated = false}) {
    final credentialsText = '''
🏋️ *FitBizz Gym Tenant Credentials & Welcome Pack*
━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🏢 *Gym Name:* ${gym.gymName}
🆔 *Tenant / Gym ID:* ${gym.id}
👤 *Owner Name:* ${gym.ownerName}
📧 *Login Email:* ${gym.ownerEmail}
📱 *Login Phone:* ${gym.ownerPhone}
🔑 *Default Password:* ${gym.password}

🌐 *Web Portal:* http://localhost:3000/login
💻 *Desktop Client:* FitBizz OS Windows v2.0
🏢 *Branches Enabled:* ${gym.branches}
📦 *Subscription Tier:* ${gym.planName}
⏳ *Status:* ${gym.status} (${gym.trialDays > 0 ? '${gym.trialDays} Days Free Trial' : 'Active Paid'})
━━━━━━━━━━━━━━━━━━━━━━━━━━━━
_Keep these credentials confidential. You can change your password anytime inside the Owner Settings._
''';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusLg)),
          ),
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const AppLogo(size: 32),
                      const SizedBox(width: AppSpacing.sm),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isNewlyCreated ? '🎉 Gym Onboarded Successfully!' : tr('share_credentials'),
                            style: AppTypography.h3.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text('Dispatch credentials to the Gym Owner via WhatsApp, Email, or Clipboard.', style: AppTypography.caption),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),

              // Credential Highlights Card
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.stone50,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  border: Border.all(color: AppColors.stone200),
                ),
                child: Column(
                  children: [
                    _buildModalRow('Gym / Business Name', gym.gymName, isBold: true),
                    _buildModalRow('Tenant ID / Code', gym.id, copyable: true),
                    _buildModalRow('Owner Login Email', gym.ownerEmail, copyable: true),
                    _buildModalRow('Owner Phone Number', gym.ownerPhone, copyable: true),
                    _buildModalRow('Default Password', gym.password, copyable: true),
                    _buildModalRow('Configured Branches', '${gym.branches} Active Locations'),
                    _buildModalRow('Assigned Tier', '${gym.planName} (${formatMoney(gym.monthlyPrice)}/mo)'),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Action Buttons Row (WhatsApp, Email, Copy)
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF25D366),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    icon: const Icon(Icons.chat, size: 18),
                    label: Text(tr('whatsapp_dispatch'), style: const TextStyle(fontWeight: FontWeight.bold)),
                    onPressed: () async {
                      Navigator.pop(ctx);
                      AppToast.showInfo(
                        context,
                        'Opening WhatsApp...',
                        'Sending access pack to ${gym.ownerPhone}',
                      );
                      final success = await CommunicationLauncher.sendWhatsApp(
                        phone: gym.ownerPhone,
                        message: credentialsText,
                      );
                      if (mounted) {
                        if (success) {
                          AppToast.showSuccess(
                            context,
                            'WhatsApp Dispatched',
                            'Opened WhatsApp & copied credentials to clipboard.',
                          );
                        } else {
                          AppToast.showSuccess(
                            context,
                            'Credentials Copied',
                            'Ready to paste in WhatsApp (${gym.ownerPhone}).',
                          );
                        }
                      }
                    },
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.japaniPhalDark,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    icon: const Icon(Icons.email_outlined, size: 18),
                    label: Text(tr('email_dispatch'), style: const TextStyle(fontWeight: FontWeight.bold)),
                    onPressed: () async {
                      Navigator.pop(ctx);
                      AppToast.showInfo(
                        context,
                        'Opening Email Client...',
                        'Drafting email to ${gym.ownerEmail}',
                      );
                      final success = await CommunicationLauncher.sendEmail(
                        email: gym.ownerEmail,
                        subject: '🏋️ FitBizz Platform Access Pack - ${gym.gymName}',
                        body: credentialsText,
                      );
                      if (mounted) {
                        if (success) {
                          AppToast.showSuccess(
                            context,
                            'Email Draft Created',
                            'Draft prepared & credentials copied to clipboard.',
                          );
                        } else {
                          AppToast.showSuccess(
                            context,
                            'Credentials Copied',
                            'Ready to paste into your mail app (${gym.ownerEmail}).',
                          );
                        }
                      }
                    },
                  ),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.copy, size: 18),
                    label: Text(tr('copy_pack')),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: credentialsText));
                      Navigator.pop(ctx);
                      AppToast.showSuccess(
                        context,
                        'Access Pack Copied',
                        'Tenant credentials copied to clipboard.',
                      );
                    },
                  ),
                  if (widget.onManageGym != null)
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.stone800,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      icon: const Icon(Icons.login, size: 18),
                      label: const Text('Open Gym Workspace'),
                      onPressed: () {
                        Navigator.pop(ctx);
                        _manageGym(gym);
                      },
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildModalRow(String label, String value, {bool isBold = false, bool copyable = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              label,
              style: AppTypography.caption.copyWith(color: AppColors.stone600),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: isBold
                    ? AppTypography.body.copyWith(fontWeight: FontWeight.bold)
                    : AppTypography.caption.copyWith(fontWeight: FontWeight.w600, color: AppColors.stone900),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (copyable) ...[
                const SizedBox(width: 4),
                InkWell(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: value));
                    AppToast.showSuccess(context, 'Copied', '$label copied to clipboard');
                  },
                  child: const Icon(Icons.copy, size: 13, color: AppColors.stone400),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  void _showEditGymDialog(GymTenantItem gym) {
    final nameController = TextEditingController(text: gym.gymName);
    final ownerController = TextEditingController(text: gym.ownerName);
    final emailController = TextEditingController(text: gym.ownerEmail);
    final phoneController = TextEditingController(text: gym.ownerPhone);
    int branchCount = gym.branches;
    String status = gym.status;
    int trialDays = gym.trialDays;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Row(
                children: [
                  const Icon(Icons.edit_note, color: AppColors.japaniPhalDark),
                  const SizedBox(width: AppSpacing.sm),
                  Flexible(
                    child: Text(
                      '${tr('edit_gym')} (${gym.id})',
                      style: AppTypography.h3,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              content: SizedBox(
                width: 480,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppTextField(label: 'Gym Brand Name', controller: nameController),
                      const SizedBox(height: AppSpacing.sm),
                      AppTextField(label: 'Owner Full Name', controller: ownerController),
                      const SizedBox(height: AppSpacing.sm),
                      AppTextField(label: 'Owner Email', controller: emailController),
                      const SizedBox(height: AppSpacing.sm),
                      AppTextField(label: 'Owner Phone', controller: phoneController),
                      const SizedBox(height: AppSpacing.md),

                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Branch Licenses:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                DropdownButton<int>(
                                  value: branchCount,
                                  isExpanded: true,
                                  items: [1, 2, 3, 4, 5, 10].map((b) => DropdownMenuItem(value: b, child: Text('$b Branches'))).toList(),
                                  onChanged: (val) => setDialogState(() => branchCount = val ?? 1),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Subscription Status:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                DropdownButton<String>(
                                  value: status,
                                  isExpanded: true,
                                  items: ['15-Day Trial', 'Paid Subscription', 'Suspended']
                                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                                      .toList(),
                                  onChanged: (val) => setDialogState(() => status = val ?? '15-Day Trial'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      if (status == '15-Day Trial') ...[
                        const SizedBox(height: AppSpacing.sm),
                        Row(
                          children: [
                            const Text('Remaining Trial Days:', style: TextStyle(fontSize: 11)),
                            const SizedBox(width: AppSpacing.sm),
                            DropdownButton<int>(
                              value: trialDays > 60 ? 60 : (trialDays <= 0 ? 15 : trialDays),
                              items: [7, 14, 15, 30, 60].map((d) => DropdownMenuItem(value: d, child: Text('$d Days'))).toList(),
                              onChanged: (val) => setDialogState(() => trialDays = val ?? 15),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text(tr('cancel')),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.japaniPhalDark, foregroundColor: Colors.white),
                  onPressed: () {
                    // Strict Validations
                    if (nameController.text.trim().length < 3) {
                      AppToast.showError(context, 'Validation Error', tr('val_gym_name'));
                      return;
                    }
                    if (ownerController.text.trim().length < 3) {
                      AppToast.showError(context, 'Validation Error', tr('val_owner_name'));
                      return;
                    }
                    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                    if (!emailRegex.hasMatch(emailController.text.trim())) {
                      AppToast.showError(context, 'Validation Error', tr('val_email'));
                      return;
                    }
                    final phoneDigits = phoneController.text.replaceAll(RegExp(r'[^0-9]'), '');
                    if (phoneDigits.length < 10) {
                      AppToast.showError(context, 'Validation Error', tr('val_phone'));
                      return;
                    }

                    setState(() {
                      gym.gymName = nameController.text.trim();
                      gym.ownerName = ownerController.text.trim();
                      gym.ownerEmail = emailController.text.trim();
                      gym.ownerPhone = phoneController.text.trim();
                      gym.branches = branchCount;
                      gym.status = status;
                      gym.trialDays = status == '15-Day Trial' ? trialDays : 0;
                    });
                    Navigator.pop(ctx);
                    AppToast.showSuccess(
                      context,
                      'Gym Updated',
                      'Updated "${gym.gymName}" successfully!',
                    );
                  },
                  child: Text(tr('save_changes')),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showCustomPlanBuilderDialog({Map<String, dynamic>? existingPlan}) {
    final isEditing = existingPlan != null;
    final nameController = TextEditingController(text: isEditing ? existingPlan['title'] as String : 'Franchise Custom Tier');
    double price = isEditing ? (existingPlan['price'] as double) : 45000;
    int branches = isEditing ? (existingPlan['branches'] as int) : 5;
    String members = isEditing ? (existingPlan['members'] as String? ?? 'Up to 1,500 Members') : 'Up to 2,000 Members';
    bool featAttendance = isEditing ? (existingPlan['featAttendance'] ?? true) : true;
    bool featMembers = isEditing ? (existingPlan['featMembers'] ?? true) : true;
    bool featExpenses = isEditing ? (existingPlan['featExpenses'] ?? true) : true;
    bool featMultiBranch = isEditing ? (existingPlan['featMultiBranch'] ?? true) : true;
    bool featBiometrics = isEditing ? (existingPlan['featBiometrics'] ?? true) : true;
    bool featTrainer = isEditing ? (existingPlan['featTrainer'] ?? true) : true;
    bool featCustomerApp = isEditing ? (existingPlan['featCustomerApp'] ?? true) : true;
    bool featAi = isEditing ? (existingPlan['featAi'] ?? false) : false;
    bool featWhatsApp = isEditing ? (existingPlan['featWhatsApp'] ?? true) : true;
    bool featSla = isEditing ? (existingPlan['featSla'] ?? false) : false;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Row(
                children: [
                  const Icon(Icons.stars, color: AppColors.japaniPhalDark),
                  const SizedBox(width: AppSpacing.sm),
                  Text(isEditing ? tr('edit_plan') : tr('build_custom_plan'), style: AppTypography.h3),
                ],
              ),
              content: SizedBox(
                width: 500,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppTextField(label: 'Plan / Agreement Name', controller: nameController),
                      const SizedBox(height: AppSpacing.md),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Monthly SaaS Fee:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                          Text(formatMoney(price), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.japaniPhalDark)),
                        ],
                      ),
                      Slider(
                        value: price,
                        min: 5000,
                        max: 150000,
                        divisions: 29,
                        activeColor: AppColors.japaniPhalDark,
                        onChanged: (val) => setDialogState(() => price = val),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Branch Licenses:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                          Text('$branches Branches Included', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Slider(
                        value: branches.toDouble(),
                        min: 1,
                        max: 20,
                        divisions: 19,
                        activeColor: AppColors.japaniPhalDark,
                        onChanged: (val) => setDialogState(() => branches = val.toInt()),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      const Text('Member Capacity Allocation:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      DropdownButtonFormField<String>(
                        initialValue: members,
                        decoration: const InputDecoration(
                          isDense: true,
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'Up to 300 Members', child: Text('Up to 300 Members', style: TextStyle(fontSize: 12))),
                          DropdownMenuItem(value: 'Up to 1,500 Members', child: Text('Up to 1,500 Members', style: TextStyle(fontSize: 12))),
                          DropdownMenuItem(value: 'Up to 2,000 Members', child: Text('Up to 2,000 Members', style: TextStyle(fontSize: 12))),
                          DropdownMenuItem(value: '5,000 Active Members', child: Text('5,000 Active Members', style: TextStyle(fontSize: 12))),
                          DropdownMenuItem(value: 'Unlimited Members', child: Text('Unlimited Members', style: TextStyle(fontSize: 12))),
                        ],
                        onChanged: (val) => setDialogState(() => members = val ?? 'Up to 1,500 Members'),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      const Text('Granular Feature Entitlements:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),

                      // Feature Checkboxes (10 Entitlements - Synced with Web 1:1)
                      CheckboxListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Membership & Member Management (Core)', style: TextStyle(fontSize: 12)),
                        value: featMembers,
                        activeColor: AppColors.japaniPhalDark,
                        onChanged: (v) => setDialogState(() => featMembers = v ?? true),
                      ),
                      CheckboxListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        title: const Text('QR Attendance & Check-in Terminal (Core)', style: TextStyle(fontSize: 12)),
                        value: featAttendance,
                        activeColor: AppColors.japaniPhalDark,
                        onChanged: (v) => setDialogState(() => featAttendance = v ?? true),
                      ),
                      CheckboxListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Expense Tracking & Fee Ledger (Core)', style: TextStyle(fontSize: 12)),
                        value: featExpenses,
                        activeColor: AppColors.japaniPhalDark,
                        onChanged: (v) => setDialogState(() => featExpenses = v ?? true),
                      ),
                      CheckboxListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Multi-Branch Centralized Sync', style: TextStyle(fontSize: 12)),
                        value: featMultiBranch,
                        activeColor: AppColors.japaniPhalDark,
                        onChanged: (v) => setDialogState(() => featMultiBranch = v ?? true),
                      ),
                      CheckboxListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Biometric Turnstiles Integration', style: TextStyle(fontSize: 12)),
                        value: featBiometrics,
                        activeColor: AppColors.japaniPhalDark,
                        onChanged: (v) => setDialogState(() => featBiometrics = v ?? true),
                      ),
                      CheckboxListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Trainer Login & Client Rosters', style: TextStyle(fontSize: 12)),
                        value: featTrainer,
                        activeColor: AppColors.japaniPhalDark,
                        onChanged: (v) => setDialogState(() => featTrainer = v ?? true),
                      ),
                      CheckboxListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Customer Mobile Self-Service Pass App', style: TextStyle(fontSize: 12)),
                        value: featCustomerApp,
                        activeColor: AppColors.japaniPhalDark,
                        onChanged: (v) => setDialogState(() => featCustomerApp = v ?? true),
                      ),
                      CheckboxListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        title: const Text('AI Member Churn & Attendance Forecasting', style: TextStyle(fontSize: 12)),
                        value: featAi,
                        activeColor: AppColors.japaniPhalDark,
                        onChanged: (v) => setDialogState(() => featAi = v ?? false),
                      ),
                      CheckboxListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        title: const Text('WhatsApp Automated Receipts & Invoices', style: TextStyle(fontSize: 12)),
                        value: featWhatsApp,
                        activeColor: AppColors.japaniPhalDark,
                        onChanged: (v) => setDialogState(() => featWhatsApp = v ?? true),
                      ),
                      CheckboxListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        title: const Text('24/7 Priority VIP SLA & Dedicated Cluster', style: TextStyle(fontSize: 12)),
                        value: featSla,
                        activeColor: AppColors.japaniPhalDark,
                        onChanged: (v) => setDialogState(() => featSla = v ?? false),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text(tr('cancel')),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.japaniPhalDark, foregroundColor: Colors.white),
                  onPressed: () {
                    if (nameController.text.trim().isEmpty) {
                      AppToast.showError(context, 'Validation Error', 'Please enter a valid plan name.');
                      return;
                    }

                    final featuresList = <String>[
                      if (featMembers) 'Membership & Member Registry',
                      if (featAttendance) 'QR Attendance & Check-in',
                      if (featExpenses) 'Expense Tracking Ledger',
                      if (featMultiBranch) 'Multi-Branch Centralized Sync',
                      if (featBiometrics) 'Biometric Turnstiles Integration',
                      if (featTrainer) 'Trainer Login & Client Rosters',
                      if (featCustomerApp) 'Customer Mobile Pass App',
                      if (featAi) 'AI Member Churn & Attendance Forecast',
                      if (featWhatsApp) 'WhatsApp Automated Invoices',
                      if (featSla) '24/7 Priority SLA & Dedicated Server',
                    ];

                    setState(() {
                      if (isEditing) {
                        existingPlan['title'] = nameController.text.trim();
                        existingPlan['price'] = price;
                        existingPlan['branches'] = branches;
                        existingPlan['members'] = members;
                        existingPlan['badge'] = '$branches Branches';
                        existingPlan['featAttendance'] = featAttendance;
                        existingPlan['featMembers'] = featMembers;
                        existingPlan['featExpenses'] = featExpenses;
                        existingPlan['featMultiBranch'] = featMultiBranch;
                        existingPlan['featBiometrics'] = featBiometrics;
                        existingPlan['featTrainer'] = featTrainer;
                        existingPlan['featCustomerApp'] = featCustomerApp;
                        existingPlan['featAi'] = featAi;
                        existingPlan['featWhatsApp'] = featWhatsApp;
                        existingPlan['featSla'] = featSla;
                        existingPlan['features'] = featuresList;
                      } else {
                        _customPlans.add({
                          'id': 'tier-${DateTime.now().millisecondsSinceEpoch}',
                          'title': nameController.text.trim(),
                          'price': price,
                          'period': '/ month',
                          'subtitle': 'Custom negotiated agreement with tailored modules.',
                          'badge': '$branches Branches',
                          'branches': branches,
                          'members': members,
                          'featAttendance': featAttendance,
                          'featMembers': featMembers,
                          'featExpenses': featExpenses,
                          'featMultiBranch': featMultiBranch,
                          'featBiometrics': featBiometrics,
                          'featTrainer': featTrainer,
                          'featCustomerApp': featCustomerApp,
                          'featAi': featAi,
                          'featWhatsApp': featWhatsApp,
                          'featSla': featSla,
                          'features': featuresList,
                          'activeGyms': 1,
                          'isPopular': false,
                        });
                      }
                    });
                    Navigator.pop(ctx);
                    AppToast.showSuccess(
                      context,
                      isEditing ? 'Tier Updated' : 'Custom Tier Saved',
                      'Saved "${nameController.text.trim()}" with ${featuresList.length} enabled modules.',
                    );
                  },
                  child: Text(isEditing ? tr('save_changes') : tr('build_custom_plan')),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _manageGym(GymTenantItem gym) {
    AppToast.showSuccess(
      context,
      'Active Workspace: ${gym.gymName}',
      'Switched tenant context to ${gym.ownerName} (${gym.branches} branches).',
    );
    if (widget.onManageGym != null) {
      widget.onManageGym!(gym);
    } else {
      widget.onSwitchToTenantPortal();
    }
  }

  void _showDeleteConfirmation(GymTenantItem gym) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(tr('delete_gym')),
          content: Text('Are you sure you want to remove "${gym.gymName}" (${gym.id})? All associated branch data and offline mutations will be archived.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(tr('cancel')),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.red600, foregroundColor: Colors.white),
              onPressed: () {
                setState(() {
                  _gyms.removeWhere((g) => g.id == gym.id);
                });
                Navigator.pop(ctx);
                AppToast.showWarning(context, 'Tenant Removed', 'Gym "${gym.gymName}" has been removed.');
              },
              child: Text(tr('delete_gym')),
            ),
          ],
        );
      },
    );
  }

  // Nav item definitions (Matching Next.js Web Navigation 1:1)
  List<Map<String, dynamic>> _getNavItems() => [
        {
          'label': 'Super Admin HQ',
          'icon': Icons.home_outlined,
          'activeIcon': Icons.home,
          'badge': 'MASTER',
        },
        {
          'label': 'Onboard New Gym',
          'icon': Icons.add_business_outlined,
          'activeIcon': Icons.add_business,
          'badge': 'WIZARD',
        },
        {
          'label': 'Registered Tenants',
          'icon': Icons.business_outlined,
          'activeIcon': Icons.business,
          'badge': null,
        },
        {
          'label': 'Owners Directory',
          'icon': Icons.people_outline,
          'activeIcon': Icons.people,
          'badge': null,
        },
        {
          'label': 'Subscriptions & Plans',
          'icon': Icons.credit_card_outlined,
          'activeIcon': Icons.credit_card,
          'badge': null,
        },
      ];

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppLocaleController.instance,
      builder: (context, _) {
        final screenWidth = MediaQuery.of(context).size.width;
        final isDesktop = screenWidth > 850;
        final navItems = _getNavItems();

        return Scaffold(
          backgroundColor: const Color(0xFFFAFAF9),
          drawer: isDesktop ? null : _buildMobileDrawer(navItems),
          body: isDesktop
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDesktopSidebar(navItems),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildTopHeader(isDesktop, navItems),
                          Expanded(
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 250),
                              switchInCurve: Curves.easeOutCubic,
                              switchOutCurve: Curves.easeInCubic,
                              layoutBuilder: (Widget? currentChild, List<Widget> previousChildren) {
                                return Stack(
                                  alignment: Alignment.topLeft,
                                  children: <Widget>[
                                    ...previousChildren,
                                    ?currentChild,
                                  ],
                                );
                              },
                              transitionBuilder: (child, animation) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: child,
                                );
                              },
                              child: Container(
                                key: ValueKey<int>(_selectedNavIndex),
                                width: double.infinity,
                                height: double.infinity,
                                alignment: Alignment.topLeft,
                                color: const Color(0xFFFAFAF9),
                                child: _buildCurrentView(isDesktop),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildTopHeader(isDesktop, navItems),
                      Expanded(
                        child: Container(
                          key: ValueKey<int>(_selectedNavIndex),
                          width: double.infinity,
                          height: double.infinity,
                          alignment: Alignment.topLeft,
                          color: const Color(0xFFFAFAF9),
                          child: _buildCurrentView(isDesktop),
                        ),
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }

  Widget _buildTopHeader(bool isDesktop, List<Map<String, dynamic>> navItems) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.stone200)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (!isDesktop) ...[
                Builder(
                  builder: (ctx) => IconButton(
                    icon: const Icon(Icons.menu, color: AppColors.stone800),
                    onPressed: () => Scaffold.of(ctx).openDrawer(),
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
              ],
              Row(
                children: [
                  const Text('🏢', style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 8),
                  Text(
                    'FitBizz Platform Master HQ',
                    style: AppTypography.h3.copyWith(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.stone900),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              // Universal Language Selector
              const AppLanguageSelector(),
              const SizedBox(width: AppSpacing.sm),
              // Open Owner Portal Button (Outlined)
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.japaniPhalDark,
                  side: const BorderSide(color: AppColors.japaniPhalDark, width: 1.2),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                icon: const Icon(Icons.storefront_outlined, size: 16),
                label: const Text('Open Owner Portal', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                onPressed: () => _manageGym(_gyms.first),
              ),
              const SizedBox(width: AppSpacing.sm),
              // Onboard Gym Button (Solid Orange)
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.japaniPhalDark,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                ),
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Onboard Gym', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                onPressed: () => setState(() => _selectedNavIndex = 1),
              ),
              if (widget.onLogout != null) ...[
                const SizedBox(width: AppSpacing.sm),
                IconButton(
                  icon: const Icon(Icons.logout, color: AppColors.stone700),
                  tooltip: 'Sign Out',
                  onPressed: widget.onLogout,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopSidebar(List<Map<String, dynamic>> navItems) {
    final bgColor = _isDarkSidebar ? AppColors.darkBackground : AppColors.pureWhite;
    final borderColor = _isDarkSidebar ? AppColors.stone800 : AppColors.stone200;
    final titleColor = _isDarkSidebar ? Colors.white : AppColors.stone900;
    final unselectedTextColor = _isDarkSidebar ? AppColors.stone300 : AppColors.stone700;
    final unselectedIconColor = _isDarkSidebar ? AppColors.stone400 : AppColors.stone500;

    return Container(
      width: 250,
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(
          right: BorderSide(color: borderColor),
        ),
      ),
      child: Column(
        children: [
          // Brand Header (Top-Left of screen - Matching Web)
          Container(
            height: 64,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            decoration: BoxDecoration(
              color: _isDarkSidebar ? AppColors.darkSurface : AppColors.stone50,
              border: Border(bottom: BorderSide(color: borderColor)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const AppLogo(size: 32),
                    const SizedBox(width: AppSpacing.sm),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'FitBizz',
                          style: AppTypography.h3.copyWith(color: titleColor, fontSize: 15, fontWeight: FontWeight.w900),
                        ),
                        Text(
                          'SUPER ADMIN HQ',
                          style: TextStyle(
                            color: AppColors.japaniPhalDark,
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Icon(Icons.keyboard_double_arrow_left, size: 16, color: unselectedIconColor),
              ],
            ),
          ),

          // Top Sub-Headers (Role Badge Card & Quick Switcher - Matching Web)
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.sm, AppSpacing.sm, AppSpacing.sm, 0),
            child: Column(
              children: [
                // Role Badge Card
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.persimmonCream.withValues(alpha: _isDarkSidebar ? 0.15 : 0.6),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.borderOrange),
                  ),
                  child: Row(
                    children: [
                      const Text('🛡️', style: TextStyle(fontSize: 14)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Super Admin (Product Owner)',
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: titleColor),
                            ),
                            Text(
                              'Platform Governance & Onboarding',
                              style: TextStyle(fontSize: 9, color: _isDarkSidebar ? AppColors.stone400 : AppColors.stone500),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),

                // Quick Switch to Owner Portal Card
                InkWell(
                  onTap: () => _manageGym(_gyms.first),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: _isDarkSidebar ? AppColors.darkSurfaceElevated : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: borderColor),
                    ),
                    child: Row(
                      children: [
                        const Text('🏢', style: TextStyle(fontSize: 14)),
                        const SizedBox(width: 8),
                        Text(
                          'Open Owner Portal',
                          style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: titleColor),
                        ),
                        const Spacer(),
                        Text(
                          '→',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.japaniPhalDark),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 5 Synchronized Nav Items (Matching Web 1:1)
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.sm),
              itemCount: navItems.length,
              itemBuilder: (context, idx) {
                final item = navItems[idx];
                final isSelected = _selectedNavIndex == idx;

                return Container(
                  margin: const EdgeInsets.only(bottom: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    gradient: isSelected
                        ? const LinearGradient(
                            colors: [AppColors.japaniPhal, AppColors.japaniPhalDark],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.japaniPhalDark.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: ListTile(
                    dense: true,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    tileColor: Colors.transparent,
                    leading: Icon(
                      isSelected ? item['activeIcon'] as IconData : item['icon'] as IconData,
                      color: isSelected ? Colors.white : unselectedIconColor,
                      size: 19,
                    ),
                    title: Text(
                      item['label'] as String,
                      style: TextStyle(
                        color: isSelected ? Colors.white : unselectedTextColor,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                        fontSize: 12.5,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: item['badge'] != null
                        ? Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.white.withValues(alpha: 0.25)
                                  : (_isDarkSidebar ? AppColors.stone800 : AppColors.stone100),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              item['badge'] as String,
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : (_isDarkSidebar ? AppColors.stone400 : AppColors.japaniPhalDark),
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        : null,
                    onTap: () => setState(() => _selectedNavIndex = idx),
                  ),
                );
              },
            ),
          ),

          // Bottom Section (Theme Switcher & Profile)
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: borderColor)),
            ),
            child: Column(
              children: [
                // Theme Toggle Switcher Pill
                Container(
                  margin: const EdgeInsets.only(bottom: AppSpacing.xs),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  decoration: BoxDecoration(
                    color: _isDarkSidebar ? AppColors.darkSurfaceElevated : AppColors.stone50,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: borderColor),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Sidebar Appearance:',
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: unselectedTextColor),
                      ),
                      InkWell(
                        onTap: () => setState(() => _isDarkSidebar = !_isDarkSidebar),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: _isDarkSidebar ? AppColors.stone800 : Colors.white,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: borderColor),
                          ),
                          child: Text(
                            _isDarkSidebar ? '🌙 Dark' : '☀️ Light',
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: titleColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _isDarkSidebar ? AppColors.darkSurfaceElevated : AppColors.stone50,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: borderColor),
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 13,
                        backgroundColor: AppColors.stone900,
                        child: Text('N', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Super Admin (HQ)', style: TextStyle(color: titleColor, fontSize: 11, fontWeight: FontWeight.bold)),
                            Text('admin@fitbizz.com', style: TextStyle(color: _isDarkSidebar ? AppColors.stone400 : AppColors.stone500, fontSize: 9)),
                          ],
                        ),
                      ),
                      if (widget.onLogout != null)
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: Icon(Icons.logout, color: unselectedIconColor, size: 15),
                          tooltip: 'Sign Out',
                          onPressed: widget.onLogout,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileDrawer(List<Map<String, dynamic>> navItems) {
    final bgColor = _isDarkSidebar ? AppColors.darkBackground : AppColors.pureWhite;
    final titleColor = _isDarkSidebar ? Colors.white : AppColors.stone900;
    return Drawer(
      backgroundColor: bgColor,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                children: [
                  const AppLogo(size: 32),
                  const SizedBox(width: AppSpacing.sm),
                  Text('FitBizz Super HQ', style: AppTypography.h3.copyWith(color: titleColor)),
                ],
              ),
            ),
            // Mobile Quick Switcher
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 4),
              child: ListTile(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                tileColor: AppColors.persimmonCream,
                leading: const Icon(Icons.storefront, color: AppColors.japaniPhalDark),
                title: const Text('🏢 Open Owner Portal', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.japaniPhalDark)),
                subtitle: Text('${_gyms.first.gymName} (${_gyms.first.city})', style: const TextStyle(fontSize: 10, color: AppColors.stone600)),
                trailing: const Icon(Icons.chevron_right, color: AppColors.japaniPhalDark, size: 18),
                onTap: () {
                  Navigator.pop(context);
                  _manageGym(_gyms.first);
                },
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView.builder(
                itemCount: navItems.length,
                itemBuilder: (context, idx) {
                  final item = navItems[idx];
                  final isSelected = _selectedNavIndex == idx;
                  return ListTile(
                    leading: Icon(
                      isSelected ? item['activeIcon'] as IconData : item['icon'] as IconData,
                      color: isSelected ? AppColors.japaniPhalDark : AppColors.stone500,
                    ),
                    title: Text(
                      item['label'] as String,
                      style: TextStyle(
                        color: isSelected ? AppColors.japaniPhalDark : titleColor,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      setState(() => _selectedNavIndex = idx);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentView(bool isDesktop) {
    switch (_selectedNavIndex) {
      case 0:
        return _buildOverviewView(isDesktop);
      case 1:
        return SuperAdminOnboardingScreen(
          apiClient: widget.apiClient,
          isEmbedded: true,
          onOnboardingSuccess: () {
            final newGym = GymTenantItem(
              id: 'tenant-00${_gyms.length + 1}',
              gymName: 'Titan Fitness Arena',
              ownerName: 'Kamran Ahmed',
              ownerEmail: 'owner@titanfitness.com',
              ownerPhone: '+92 300 1234567',
              password: 'password123',
              branches: 2,
              status: '15-Day Trial',
              trialDays: 15,
              date: 'Just now',
              city: 'Lahore',
              planName: 'Pro Multi-Branch Plan',
              monthlyPrice: 35000,
            );

            setState(() {
              _gyms.insert(0, newGym);
              _selectedNavIndex = 0; // Return to Overview
            });

            // Open Credentials & Dispatch Pack immediately
            _showCredentialsModal(newGym, isNewlyCreated: true);
          },
        );
      case 2:
        return _buildTenantsDirectoryView(isDesktop);
      case 3:
        return _buildOwnersDirectoryView(isDesktop);
      case 4:
        return _buildSubscriptionsView(isDesktop);
      default:
        return _buildOverviewView(isDesktop);
    }
  }

  // ================= VIEW 1: OVERVIEW (PIXEL-PERFECT MATCH WITH WEB) =================
  Widget _buildOverviewView(bool isDesktop) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header Row (Platform Overview)
          Container(
            padding: const EdgeInsets.only(bottom: 16),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.stone200)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Platform Overview',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.stone900,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Real-time status of multi-tenant businesses, subscriptions, and platform operational health',
                      style: TextStyle(fontSize: 12, color: AppColors.stone500),
                    ),
                  ],
                ),
                Row(
                  children: [
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.stone800,
                        side: const BorderSide(color: AppColors.stone300),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () => setState(() => _selectedNavIndex = 2),
                      child: const Text('Manage All Gyms', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.japaniPhalDark,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        elevation: 0,
                      ),
                      onPressed: () => setState(() => _selectedNavIndex = 1),
                      child: const Text('Onboard New Gym', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Platform KPI Summary Card (Single Sleek White Card with Underlined Numbers - Exact Match)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.stone200),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                // Top Metric Row (4 columns)
                Row(
                  children: [
                    _buildKpiItem('TOTAL GYMS', '14', AppColors.stone900),
                    const SizedBox(width: 24),
                    _buildKpiItem('ACTIVE GYMS', '12', const Color(0xFF16A34A)),
                    const SizedBox(width: 24),
                    _buildKpiItem('PENDING SETUP', '2', const Color(0xFFEA580C)),
                    const SizedBox(width: 24),
                    _buildKpiItem('ACTIVE SUBS', '12', const Color(0xFF2563EB)),
                  ],
                ),
                const SizedBox(height: 20),
                // Bottom Metric Row (3 columns)
                Row(
                  children: [
                    _buildKpiItem('EXPIRING (14D)', '3', const Color(0xFFE11D48)),
                    const SizedBox(width: 24),
                    _buildKpiItem('TOTAL BRANCHES', '28', AppColors.stone900),
                    const SizedBox(width: 24),
                    _buildKpiItem('PLATFORM MEMBERS', '4,850', AppColors.stone900),
                    const SizedBox(width: 24),
                    const Expanded(child: SizedBox()), // Balances the 4th slot
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Action Required Banner (Amber Alert Box - Exact Match)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFEFCE8),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFFEF08A)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF08A),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text('⚠️', style: TextStyle(fontSize: 16)),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Action Required: 2 Gyms Pending Onboarding Review',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF713F12),
                        ),
                      ),
                      const SizedBox(height: 3),
                      const Text(
                        'Titan Performance Lab and Pulse Branch 4 require initial owner invitation confirmation and entitlement verification.',
                        style: TextStyle(fontSize: 11.5, color: Color(0xFFA16207)),
                      ),
                      const SizedBox(height: 6),
                      InkWell(
                        onTap: () => setState(() => _selectedNavIndex = 2),
                        child: const Text(
                          'Review Pending Gyms →',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF713F12),
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Recently Onboarded Businesses Section (Exact Match)
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.stone200),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Recently Onboarded Businesses',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.stone900),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Latest tenant registrations across FitBizz platform',
                            style: TextStyle(fontSize: 11, color: AppColors.stone500),
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () => setState(() => _selectedNavIndex = 2),
                        child: const Text(
                          'View All Gyms →',
                          style: TextStyle(
                            color: AppColors.japaniPhalDark,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1, color: AppColors.stone200),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _gyms.length,
                  separatorBuilder: (context, index) => const Divider(height: 1, color: AppColors.stone100),
                  itemBuilder: (context, index) {
                    final item = _gyms[index];

                    return Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          // Leading Avatar
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: AppColors.persimmonCream,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: Text('🏋️', style: TextStyle(fontSize: 20)),
                            ),
                          ),
                          const SizedBox(width: 14),
                          // Details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      item.gymName,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.stone900),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFEF3C7),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: const Color(0xFFFDE68A)),
                                      ),
                                      child: Text(
                                        item.status,
                                        style: const TextStyle(color: Color(0xFFB45309), fontSize: 10, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  'Owner: ${item.ownerName} (${item.ownerEmail}) • ${item.branches} Branches • ${item.city} • Onboarded: ${item.date}',
                                  style: const TextStyle(color: AppColors.stone500, fontSize: 11.5),
                                ),
                              ],
                            ),
                          ),
                          // Trailing Actions
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.share_outlined, size: 18, color: AppColors.stone600),
                                tooltip: 'Share Access Pack (WhatsApp / Email / Copy)',
                                onPressed: () => _showCredentialsModal(item),
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit_outlined, size: 18, color: AppColors.stone600),
                                tooltip: 'Edit Gym Details',
                                onPressed: () => _showEditGymDialog(item),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.red600),
                                tooltip: 'Delete / Suspend Gym',
                                onPressed: () => _showDeleteConfirmation(item),
                              ),
                              const SizedBox(width: 6),
                              OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.japaniPhalDark,
                                  side: const BorderSide(color: AppColors.japaniPhalDark, width: 1.2),
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                icon: const Icon(Icons.login, size: 15),
                                label: const Text('Manage Gym', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11.5)),
                                onPressed: () => _manageGym(item),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKpiItem(String title, String value, Color valueColor) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: AppColors.stone500,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: valueColor,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            height: 1.5,
            color: AppColors.stone300,
          ),
        ],
      ),
    );
  }

  // ================= VIEW 2: GYM TENANTS (MATCHING WEB 1:1) =================
  Widget _buildTenantsDirectoryView(bool isDesktop) {
    final filteredGyms = _gyms.where((g) {
      final matchesSearch = g.gymName.toLowerCase().contains(_tenantSearchQuery.toLowerCase()) ||
          g.ownerName.toLowerCase().contains(_tenantSearchQuery.toLowerCase()) ||
          g.city.toLowerCase().contains(_tenantSearchQuery.toLowerCase()) ||
          g.id.toLowerCase().contains(_tenantSearchQuery.toLowerCase());
      final matchesStatus = _tenantStatusFilter == 'ALL' ||
          (_tenantStatusFilter == 'TRIAL' && g.status.contains('Trial')) ||
          (_tenantStatusFilter == 'PAID' && g.status.contains('Paid')) ||
          (_tenantStatusFilter == 'SUSPENDED' && g.status.contains('Suspended'));
      return matchesSearch && matchesStatus;
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Container(
            padding: const EdgeInsets.only(bottom: 16),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.stone200)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Registered Tenants Directory',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.stone900,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Active fitness clubs, branch allocations, credential dispatches, and live workspace controls',
                      style: TextStyle(fontSize: 12, color: AppColors.stone500),
                    ),
                  ],
                ),
                Row(
                  children: [
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.japaniPhalDark,
                        side: const BorderSide(color: AppColors.japaniPhalDark, width: 1.2),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      icon: const Icon(Icons.storefront_outlined, size: 16),
                      label: const Text('Open Owner Portal', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      onPressed: () => _manageGym(_gyms.first),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.japaniPhalDark,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        elevation: 0,
                      ),
                      icon: const Icon(Icons.add, size: 16),
                      label: const Text('Onboard New Gym', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      onPressed: () => setState(() => _selectedNavIndex = 1),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Search & Filter Toolbar Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.stone200),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search, size: 18, color: AppColors.stone400),
                      hintText: 'Search by gym name, owner, city, ID...',
                      hintStyle: TextStyle(fontSize: 12, color: AppColors.stone400),
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8)), borderSide: BorderSide(color: AppColors.stone200)),
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                    onChanged: (val) => setState(() => _tenantSearchQuery = val),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.stone300),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _tenantStatusFilter,
                      items: const [
                        DropdownMenuItem(value: 'ALL', child: Text('All Statuses', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
                        DropdownMenuItem(value: 'TRIAL', child: Text('15-Day Trial', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
                        DropdownMenuItem(value: 'PAID', child: Text('Paid Subscriptions', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
                        DropdownMenuItem(value: 'SUSPENDED', child: Text('Suspended', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
                      ],
                      onChanged: (val) => setState(() => _tenantStatusFilter = val ?? 'ALL'),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.lg),
                Text(
                  'Active Tenants: ${filteredGyms.length}',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.stone600),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Main Tenants Table Container
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.stone200),
            ),
            clipBehavior: Clip.antiAlias,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final tableWidth = constraints.maxWidth > 1180.0 ? constraints.maxWidth : 1180.0;
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: tableWidth,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Table Header Row
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          decoration: const BoxDecoration(
                            color: Color(0xFFFAFAFA),
                            border: Border(bottom: BorderSide(color: AppColors.stone200)),
                          ),
                          child: const Row(
                            children: [
                              SizedBox(
                                width: 200,
                                child: Text('GYM BUSINESS', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: AppColors.stone600, letterSpacing: 0.5)),
                              ),
                              SizedBox(
                                width: 200,
                                child: Text('OWNER & CONTACT', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: AppColors.stone600, letterSpacing: 0.5)),
                              ),
                              SizedBox(
                                width: 110,
                                child: Text('LOCATION', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: AppColors.stone600, letterSpacing: 0.5)),
                              ),
                              SizedBox(
                                width: 100,
                                child: Text('BRANCHES', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: AppColors.stone600, letterSpacing: 0.5)),
                              ),
                              SizedBox(
                                width: 180,
                                child: Text('SUBSCRIPTION PLAN', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: AppColors.stone600, letterSpacing: 0.5)),
                              ),
                              SizedBox(
                                width: 150,
                                child: Text('STATUS', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: AppColors.stone600, letterSpacing: 0.5)),
                              ),
                              Expanded(
                                child: Text('ACTIONS', textAlign: TextAlign.right, style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: AppColors.stone600, letterSpacing: 0.5)),
                              ),
                            ],
                          ),
                        ),

                        // Table Body Rows
                        if (filteredGyms.isEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 48),
                            child: const Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('No Tenants Match Your Search', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.stone800)),
                                  SizedBox(height: 4),
                                  Text('Clear filters to view registered gyms.', style: TextStyle(fontSize: 12, color: AppColors.stone400)),
                                ],
                              ),
                            ),
                          )
                        else
                          ...filteredGyms.asMap().entries.map((entry) {
                            final index = entry.key;
                            final gym = entry.value;
                            final isTrial = gym.status.contains('Trial');
                            final isPaid = gym.status.contains('Paid');

                            return Container(
                              decoration: BoxDecoration(
                                border: index < filteredGyms.length - 1 ? const Border(bottom: BorderSide(color: Color(0xFFF3F4F6))) : null,
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              child: Row(
                                children: [
                                  // 1. Gym Business
                                  SizedBox(
                                    width: 200,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          gym.gymName,
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.stone900),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          'ID: ${gym.id}',
                                          style: const TextStyle(fontFamily: 'monospace', fontSize: 11, color: AppColors.stone400),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // 2. Owner Details
                                  SizedBox(
                                    width: 200,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          gym.ownerName,
                                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: AppColors.stone800),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          gym.ownerEmail,
                                          style: const TextStyle(fontSize: 11, color: AppColors.stone500),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          gym.ownerPhone,
                                          style: const TextStyle(fontFamily: 'monospace', fontSize: 11, color: AppColors.stone400),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),

                                  // 3. Location
                                  SizedBox(
                                    width: 110,
                                    child: Text(
                                      '${gym.city}, PK',
                                      style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12, color: AppColors.stone700),
                                    ),
                                  ),

                                  // 4. Branches
                                  SizedBox(
                                    width: 100,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF3F4F6),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          '${gym.branches} Branches',
                                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.stone700),
                                        ),
                                      ),
                                    ),
                                  ),

                                  // 5. Subscription Plan
                                  SizedBox(
                                    width: 180,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          gym.planName,
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF431407)),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          'Rs. ${gym.monthlyPrice.toStringAsFixed(0)}/mo',
                                          style: const TextStyle(fontSize: 10.5, color: AppColors.stone500),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // 6. Status
                                  SizedBox(
                                    width: 150,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: isTrial
                                              ? const Color(0xFFFFFBEB)
                                              : isPaid
                                                  ? const Color(0xFFF0FDF4)
                                                  : const Color(0xFFFEF2F2),
                                          borderRadius: BorderRadius.circular(20),
                                          border: Border.all(
                                            color: isTrial
                                                ? const Color(0xFFFDE68A)
                                                : isPaid
                                                    ? const Color(0xFFBBF7D0)
                                                    : const Color(0xFFFECACA),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              width: 6,
                                              height: 6,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: isTrial
                                                    ? const Color(0xFFF59E0B)
                                                    : isPaid
                                                        ? const Color(0xFF22C55E)
                                                        : const Color(0xFFEF4444),
                                              ),
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              isTrial
                                                  ? '${gym.status} (${gym.trialDays}d left)'
                                                  : gym.status,
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                                color: isTrial
                                                    ? const Color(0xFFB45309)
                                                    : isPaid
                                                        ? const Color(0xFF15803D)
                                                        : const Color(0xFFB91C1C),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                                  // 7. Actions
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        OutlinedButton.icon(
                                          style: OutlinedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                            minimumSize: Size.zero,
                                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                            side: const BorderSide(color: AppColors.stone300),
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                            foregroundColor: AppColors.stone700,
                                          ),
                                          icon: const Icon(Icons.vpn_key_outlined, size: 13),
                                          label: const Text('Share', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                          onPressed: () => _showCredentialsModal(gym),
                                        ),
                                        const SizedBox(width: 6),
                                        OutlinedButton.icon(
                                          style: OutlinedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                            minimumSize: Size.zero,
                                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                            side: const BorderSide(color: AppColors.stone300),
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                            foregroundColor: AppColors.stone700,
                                          ),
                                          icon: const Icon(Icons.edit_outlined, size: 13),
                                          label: const Text('Edit', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                          onPressed: () => _showEditGymDialog(gym),
                                        ),
                                        const SizedBox(width: 6),
                                        OutlinedButton(
                                          style: OutlinedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                            minimumSize: Size.zero,
                                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                            side: const BorderSide(color: AppColors.stone300),
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                            foregroundColor: AppColors.red600,
                                          ),
                                          onPressed: () => _showDeleteConfirmation(gym),
                                          child: const Icon(Icons.delete_outline, size: 15),
                                        ),
                                        const SizedBox(width: 6),
                                        ElevatedButton.icon(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColors.japaniPhalDark,
                                            foregroundColor: Colors.white,
                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                                            minimumSize: Size.zero,
                                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                            elevation: 0,
                                          ),
                                          icon: const Icon(Icons.login, size: 13),
                                          label: const Text('Manage', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                                          onPressed: () => _manageGym(gym),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ================= VIEW 3: OWNERS DIRECTORY (MATCHING WEB 1:1) =================
  Widget _buildOwnersDirectoryView(bool isDesktop) {
    final filteredGyms = _gyms.where((g) {
      return g.ownerName.toLowerCase().contains(_ownerSearchQuery.toLowerCase()) ||
          g.ownerEmail.toLowerCase().contains(_ownerSearchQuery.toLowerCase()) ||
          g.ownerPhone.contains(_ownerSearchQuery) ||
          g.gymName.toLowerCase().contains(_ownerSearchQuery.toLowerCase()) ||
          g.city.toLowerCase().contains(_ownerSearchQuery.toLowerCase());
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Container(
            padding: const EdgeInsets.only(bottom: 16),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.stone200)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Platform Gym Owners Directory',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.stone900,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Centralized directory of business owners with tenant administration privileges',
                      style: TextStyle(fontSize: 12, color: AppColors.stone500),
                    ),
                  ],
                ),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.japaniPhalDark,
                    side: const BorderSide(color: AppColors.japaniPhalDark, width: 1.2),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  icon: const Icon(Icons.storefront_outlined, size: 16),
                  label: const Text('Open Owner Portal', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  onPressed: () => _manageGym(_gyms.first),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Search Toolbar Card (Matching Web 1:1)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.stone200),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 320,
                  child: TextField(
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search, size: 18, color: AppColors.stone400),
                      hintText: 'Search owners by name, email, or gym...',
                      hintStyle: TextStyle(fontSize: 12, color: AppColors.stone400),
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8)), borderSide: BorderSide(color: AppColors.stone200)),
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                    ),
                    onChanged: (val) => setState(() => _ownerSearchQuery = val),
                  ),
                ),
                Text(
                  'Total Platform Owners: ${filteredGyms.length}',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.stone600),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Owners Table Container
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.stone200),
            ),
            clipBehavior: Clip.antiAlias,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final tableWidth = constraints.maxWidth > 1150.0 ? constraints.maxWidth : 1150.0;
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: tableWidth,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Table Header Row
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          decoration: const BoxDecoration(
                            color: Color(0xFFFAFAFA),
                            border: Border(bottom: BorderSide(color: AppColors.stone200)),
                          ),
                          child: const Row(
                        children: [
                          SizedBox(
                            width: 220,
                            child: Text('OWNER DETAILS', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: AppColors.stone600, letterSpacing: 0.5)),
                          ),
                          SizedBox(
                            width: 200,
                            child: Text('ASSOCIATED GYM TENANT', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: AppColors.stone600, letterSpacing: 0.5)),
                          ),
                          SizedBox(
                            width: 200,
                            child: Text('CONTACT CHANNELS', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: AppColors.stone600, letterSpacing: 0.5)),
                          ),
                          SizedBox(
                            width: 110,
                            child: Text('BRANCHES', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: AppColors.stone600, letterSpacing: 0.5)),
                          ),
                          SizedBox(
                            width: 140,
                            child: Text('STATUS', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: AppColors.stone600, letterSpacing: 0.5)),
                          ),
                          Expanded(
                            child: Text('ACTIONS', textAlign: TextAlign.right, style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: AppColors.stone600, letterSpacing: 0.5)),
                          ),
                        ],
                      ),
                    ),

                    // Table Body Rows
                    if (filteredGyms.isEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 48),
                        child: const Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('No Owners Match Your Search', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.stone800)),
                              SizedBox(height: 4),
                              Text('Try searching with a different name or email.', style: TextStyle(fontSize: 12, color: AppColors.stone400)),
                            ],
                          ),
                        ),
                      )
                    else
                      ...filteredGyms.asMap().entries.map((entry) {
                        final index = entry.key;
                        final gym = entry.value;
                        final isTrial = gym.status.contains('Trial');
                        final isPaid = gym.status.contains('Paid');

                        return Container(
                          decoration: BoxDecoration(
                            border: index < filteredGyms.length - 1 ? const Border(bottom: BorderSide(color: Color(0xFFF3F4F6))) : null,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          child: Row(
                            children: [
                              // 1. Owner Details
                              SizedBox(
                                width: 220,
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 16,
                                      backgroundColor: AppColors.japaniPhalDark,
                                      child: Text(
                                        gym.ownerName.isNotEmpty ? gym.ownerName.substring(0, gym.ownerName.length >= 2 ? 2 : 1).toUpperCase() : 'OW',
                                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            gym.ownerName,
                                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.stone900),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            'ID: own-${gym.id.replaceAll(RegExp(r'[^0-9]'), '')}',
                                            style: const TextStyle(fontFamily: 'monospace', fontSize: 11, color: AppColors.stone400),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // 2. Associated Gym Tenant
                              SizedBox(
                                width: 200,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    InkWell(
                                      onTap: () => _manageGym(gym),
                                      child: Text(
                                        gym.gymName,
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.japaniPhalDark),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${gym.city}, Pakistan',
                                      style: const TextStyle(fontSize: 10.5, color: AppColors.stone400),
                                    ),
                                  ],
                                ),
                              ),

                              // 3. Contact Channels
                              SizedBox(
                                width: 200,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      gym.ownerEmail,
                                      style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 11.5, color: AppColors.stone800),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      gym.ownerPhone,
                                      style: const TextStyle(fontFamily: 'monospace', fontSize: 11, color: AppColors.stone400),
                                    ),
                                  ],
                                ),
                              ),

                              // 4. Branches
                              SizedBox(
                                width: 110,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF3F4F6),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      '${gym.branches} Branches',
                                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.stone700),
                                    ),
                                  ),
                                ),
                              ),

                              // 5. Status
                              SizedBox(
                                width: 140,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: isTrial
                                          ? const Color(0xFFFFFBEB)
                                          : isPaid
                                              ? const Color(0xFFF0FDF4)
                                              : const Color(0xFFFEF2F2),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: isTrial
                                            ? const Color(0xFFFDE68A)
                                            : isPaid
                                                ? const Color(0xFFBBF7D0)
                                                : const Color(0xFFFECACA),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          width: 6,
                                          height: 6,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: isTrial
                                                ? const Color(0xFFF59E0B)
                                                : isPaid
                                                    ? const Color(0xFF22C55E)
                                                    : const Color(0xFFEF4444),
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          gym.status,
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: isTrial
                                                ? const Color(0xFFB45309)
                                                : isPaid
                                                    ? const Color(0xFF15803D)
                                                    : const Color(0xFFB91C1C),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              // 6. Actions
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF25D366),
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                        minimumSize: Size.zero,
                                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                        elevation: 0,
                                      ),
                                      icon: const Icon(Icons.chat, size: 13),
                                      label: const Text('WhatsApp', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                      onPressed: () async {
                                        AppToast.showInfo(context, 'WhatsApp', 'Connecting to ${gym.ownerPhone}...');
                                        await CommunicationLauncher.sendWhatsApp(
                                          phone: gym.ownerPhone,
                                          message: 'Hello ${gym.ownerName}, reaching out from FitBizz regarding ${gym.gymName}.',
                                        );
                                      },
                                    ),
                                    const SizedBox(width: 6),
                                    ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.japaniPhalDark,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                        minimumSize: Size.zero,
                                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                        elevation: 0,
                                      ),
                                      icon: const Icon(Icons.email_outlined, size: 13),
                                      label: const Text('Email', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                      onPressed: () async {
                                        await CommunicationLauncher.sendEmail(
                                          email: gym.ownerEmail,
                                          subject: 'FitBizz Platform Update - ${gym.gymName}',
                                          body: 'Hello ${gym.ownerName},\n\n',
                                        );
                                      },
                                    ),
                                    const SizedBox(width: 6),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.stone900,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                                        minimumSize: Size.zero,
                                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                        elevation: 0,
                                      ),
                                      onPressed: () => _manageGym(gym),
                                      child: const Text('Manage', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    ],
  ),
);
}

  // ================= VIEW 4: SUBSCRIPTIONS & PLANS (MATCHING WEB 1:1) =================
  Widget _buildSubscriptionsView(bool isDesktop) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Container(
            padding: const EdgeInsets.only(bottom: 16),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.stone200)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Platform Subscriptions & SaaS Tiers',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.stone900,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Configure platform pricing plans, feature entitlements, and active tenant subscriptions',
                      style: TextStyle(fontSize: 12, color: AppColors.stone500),
                    ),
                  ],
                ),
                Row(
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.japaniPhalDark,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        elevation: 0,
                      ),
                      icon: const Icon(Icons.add, size: 16),
                      label: const Text('Build Custom Plan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      onPressed: () => _showCustomPlanBuilderDialog(),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Plan Tier Cards Grid
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 900;
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isWide ? 3 : 1,
                  crossAxisSpacing: AppSpacing.lg,
                  mainAxisSpacing: AppSpacing.lg,
                  childAspectRatio: isWide ? 0.70 : 1.3,
                ),
                itemCount: _customPlans.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final plan = _customPlans[index];
                  return _buildPlanCard(
                    plan: plan,
                    title: plan['title'] as String,
                    price: formatMoney(plan['price'] as double),
                    period: plan['period'] as String,
                    subtitle: plan['subtitle'] as String,
                    badge: plan['badge'] as String,
                    features: List<String>.from(plan['features'] as List),
                    activeGyms: plan['activeGyms'] as int,
                    isPopular: plan['isPopular'] as bool,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard({
    required Map<String, dynamic> plan,
    required String title,
    required String price,
    required String period,
    required String subtitle,
    required String badge,
    required List<String> features,
    required int activeGyms,
    required bool isPopular,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isPopular ? AppColors.japaniPhalDark : AppColors.stone200,
          width: isPopular ? 2.0 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: isPopular ? AppColors.japaniPhalDark.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.02),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.stone900),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isPopular ? AppColors.japaniPhalDark : AppColors.stone100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  badge,
                  style: TextStyle(
                    color: isPopular ? Colors.white : AppColors.stone700,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(subtitle, style: const TextStyle(fontSize: 11, color: AppColors.stone500), maxLines: 2, overflow: TextOverflow.ellipsis),
          const SizedBox(height: AppSpacing.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(price, style: const TextStyle(color: AppColors.japaniPhalDark, fontSize: 24, fontWeight: FontWeight.w900)),
              const SizedBox(width: 4),
              Text(period, style: const TextStyle(fontSize: 11, color: AppColors.stone500)),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          const Divider(color: AppColors.stone200),
          const SizedBox(height: AppSpacing.sm),
          Expanded(
            child: ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: features
                  .map(
                    (f) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle, color: Color(0xFF16A34A), size: 15),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              f,
                              style: const TextStyle(fontSize: 11.5, color: AppColors.stone700),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.japaniPhalDark,
                    side: const BorderSide(color: AppColors.japaniPhalDark),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  icon: const Icon(Icons.edit_outlined, size: 14),
                  label: const Text('Edit Plan', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold)),
                  onPressed: () => _showCustomPlanBuilderDialog(existingPlan: plan),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.stone50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.stone200),
                ),
                child: Text('$activeGyms Active', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.stone700)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
