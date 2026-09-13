import 'package:flutter/material.dart';

import '../../core/localization/app_locale.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_badge.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/app_toast.dart';
import '../plans/membership_plans_controller.dart';

class MemberListScreen extends StatefulWidget {
  const MemberListScreen({super.key});

  @override
  State<MemberListScreen> createState() => _MemberListScreenState();
}

class _MemberListScreenState extends State<MemberListScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  Map<String, String>? _selectedMember;

  final List<Map<String, String>> _members = [
    {
      'id': 'mem_001',
      'number': 'MEM-1001',
      'name': 'John Doe',
      'email': 'john@example.com',
      'phone': '+1 555-0192',
      'status': 'ACTIVE',
      'plan': 'Pro Monthly Access',
      'joined': 'Jan 12, 2026',
      'expires': 'Oct 12, 2026',
      'checkIns': '42 Visits',
    },
    {
      'id': 'mem_002',
      'number': 'MEM-1002',
      'name': 'Jane Smith',
      'email': 'jane@example.com',
      'phone': '+1 555-0144',
      'status': 'ACTIVE',
      'plan': 'VIP All-Branch Pass',
      'joined': 'Feb 01, 2026',
      'expires': 'Feb 01, 2027',
      'checkIns': '89 Visits',
    },
    {
      'id': 'mem_003',
      'number': 'MEM-1003',
      'name': 'Robert Taylor',
      'email': 'robert@example.com',
      'phone': '+1 555-0188',
      'status': 'EXPIRED',
      'plan': 'Starter Membership',
      'joined': 'Nov 15, 2025',
      'expires': 'Dec 15, 2025',
      'checkIns': '14 Visits',
    },
  ];

  void _selectMember(Map<String, String> member, bool isDesktop) {
    if (isDesktop) {
      setState(() {
        _selectedMember = member;
      });
    } else {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => _buildMember360Sheet(member),
      );
    }
  }

  void _showAddMemberModal() {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final cnicController = TextEditingController();
    final dobController = TextEditingController(text: '1998-05-14');
    final refController = TextEditingController();

    final plans = MembershipPlansController.instance.plans;
    String selectedPlanId = MembershipPlansController.instance.defaultPlan?.id ??
        (plans.isNotEmpty ? plans.first.id : 'plan_basic');
    String paymentMode = 'CASH';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final selectedPlan = plans.firstWhere(
              (p) => p.id == selectedPlanId,
              orElse: () => plans.first,
            );

            final double totalFee = selectedPlan.totalEnrollmentFee;

            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.japaniPhal.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.person_add, color: AppColors.japaniPhalDark, size: 20),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Admit New Gym Member', style: AppTypography.h2),
                      Text('Select membership package, CNIC, and fee collection', style: AppTypography.caption),
                    ],
                  ),
                ],
              ),
              content: SizedBox(
                width: 540,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppTextField(label: 'Member Full Name *', hint: 'e.g. Usman Ali, Tauseef', controller: nameController),
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        children: [
                          Expanded(child: AppTextField(label: 'Phone Number *', hint: '+92 300 9876543', controller: phoneController)),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(child: AppTextField(label: 'CNIC Number', hint: '35202-9876543-1', controller: cnicController)),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      AppTextField(label: 'Date of Birth', hint: '1998-05-14', controller: dobController),
                      const SizedBox(height: AppSpacing.md),

                      // Dynamic Membership Plans Selector
                      Text('Choose Configured Membership Plan:', style: AppTypography.body.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: plans.map((plan) {
                          final isSelected = plan.id == selectedPlanId;
                          return ChoiceChip(
                            label: Text('${plan.name} (${formatMoney(plan.monthlyFee)}/mo)'),
                            selected: isSelected,
                            selectedColor: AppColors.japaniPhalDark,
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.white : AppColors.stone800,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                              fontSize: 11.5,
                            ),
                            onSelected: (_) => setModalState(() => selectedPlanId = plan.id),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: AppSpacing.sm),

                      // Plan Highlights & Fee Breakdown Card
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.stone50,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.stone200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  selectedPlan.name,
                                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: AppColors.stone900),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.japaniPhal.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    selectedPlan.badge,
                                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.japaniPhalDark),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '• Duration: ${selectedPlan.durationLabel}',
                              style: const TextStyle(fontSize: 11, color: AppColors.stone600),
                            ),
                            Text(
                              '• Admission Fee: ${formatMoney(selectedPlan.admissionFee)} + Monthly Fee: ${formatMoney(selectedPlan.monthlyFee * selectedPlan.durationMonths)}',
                              style: const TextStyle(fontSize: 11, color: AppColors.stone600),
                            ),
                            if (selectedPlan.hasTrainerSupport)
                              Text(
                                '• 🏋️ Trainer: ${selectedPlan.trainerSupportNote ?? "Trainer Guidance Included"}',
                                style: const TextStyle(fontSize: 11, color: AppColors.green600, fontWeight: FontWeight.bold),
                              )
                            else
                              const Text(
                                '• Self-Workout (No Personal Trainer)',
                                style: TextStyle(fontSize: 11, color: AppColors.stone500),
                              ),
                            if (selectedPlan.hasMealPlan)
                              const Text('• 🥗 Customized Diet & Meal Plan Included', style: TextStyle(fontSize: 11, color: AppColors.green600, fontWeight: FontWeight.bold)),
                            if (selectedPlan.isMultiBranch)
                              const Text('• 🌐 All-Branch Access Included', style: TextStyle(fontSize: 11, color: AppColors.japaniPhalDark, fontWeight: FontWeight.bold)),
                            const Divider(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Total Initial Fee Payable:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.stone700)),
                                Text(formatMoney(totalFee), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14, color: AppColors.japaniPhalDark)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),

                      Text('Fee Payment Mode:', style: AppTypography.body.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          ChoiceChip(
                            label: const Text('💵 Cash Payment'),
                            selected: paymentMode == 'CASH',
                            selectedColor: AppColors.green600,
                            labelStyle: TextStyle(color: paymentMode == 'CASH' ? Colors.white : AppColors.primaryText, fontWeight: FontWeight.bold, fontSize: 11),
                            onSelected: (_) => setModalState(() => paymentMode = 'CASH'),
                          ),
                          ChoiceChip(
                            label: const Text('💳 Online Bank Transfer'),
                            selected: paymentMode == 'ONLINE',
                            selectedColor: AppColors.japaniPhalDark,
                            labelStyle: TextStyle(color: paymentMode == 'ONLINE' ? Colors.white : AppColors.primaryText, fontWeight: FontWeight.bold, fontSize: 11),
                            onSelected: (_) => setModalState(() => paymentMode = 'ONLINE'),
                          ),
                          ChoiceChip(
                            label: const Text('📱 EasyPaisa / JazzCash'),
                            selected: paymentMode == 'WALLET',
                            selectedColor: const Color(0xFF0070BA),
                            labelStyle: TextStyle(color: paymentMode == 'WALLET' ? Colors.white : AppColors.primaryText, fontWeight: FontWeight.bold, fontSize: 11),
                            onSelected: (_) => setModalState(() => paymentMode = 'WALLET'),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      if (paymentMode != 'CASH')
                        AppTextField(label: 'Transaction / Receipt Ref ID', hint: 'TRX-9823471', controller: refController),
                    ],
                  ),
                ),
              ),
              actions: [
                AppButton(
                  label: 'Cancel',
                  variant: AppButtonVariant.secondary,
                  onPressed: () => Navigator.pop(context),
                ),
                AppButton(
                  label: 'Confirm & Issue Pass',
                  onPressed: () {
                    if (nameController.text.trim().isEmpty) {
                      AppToast.showError(context, 'Validation Error', 'Member Name is required.');
                      return;
                    }

                    final rollNum = 'PULSE-2026-${1001 + _members.length}';
                    final expDuration = selectedPlan.durationMonths == 12
                        ? '1 Year'
                        : (selectedPlan.durationMonths == 6
                            ? '6 Months'
                            : (selectedPlan.durationMonths == 3 ? '3 Months' : '1 Month'));

                    setState(() {
                      _members.insert(0, {
                        'id': 'mem_${DateTime.now().millisecondsSinceEpoch}',
                        'number': rollNum,
                        'name': nameController.text.trim(),
                        'email': 'member@gym.com',
                        'phone': phoneController.text.trim().isEmpty ? '+92 300 1234567' : phoneController.text.trim(),
                        'cnic': cnicController.text.trim().isEmpty ? '35202-0000000-1' : cnicController.text.trim(),
                        'dob': dobController.text.trim(),
                        'status': 'ACTIVE',
                        'plan': selectedPlan.name,
                        'joined': 'Today',
                        'expires': expDuration,
                        'checkIns': '0 Visits',
                        'payment': paymentMode,
                      });
                    });

                    Navigator.pop(context);
                    AppToast.showSuccess(
                      context,
                      'Member Enrolled Successfully',
                      'Enrolled ${nameController.text.trim()} under ${selectedPlan.name} (${formatMoney(totalFee)}). Pass $rollNum issued.',
                    );
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 900;

    return ListenableBuilder(
      listenable: AppLocaleController.instance,
      builder: (context, _) {
        final filtered = _members.where((m) {
          final query = _searchQuery.toLowerCase();
          return m['name']!.toLowerCase().contains(query) ||
              m['number']!.toLowerCase().contains(query) ||
              m['phone']!.toLowerCase().contains(query);
        }).toList();

        return Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(tr('mem_title'), style: AppTypography.h1),
                      Text(tr('mem_subtitle'), style: AppTypography.bodySecondary),
                    ],
                  ),
                  AppButton(
                    label: tr('mem_add_member'),
                    icon: Icons.person_add,
                    onPressed: _showAddMemberModal,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),

              // Search & Filter Toolbar
              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      label: '',
                      hint: tr('mem_search'),
                      controller: _searchController,
                      prefixIcon: const Icon(Icons.search, size: 20),
                      onChanged: (val) {
                        setState(() {
                          _searchQuery = val;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    ),
                    child: Text(
                      '${filtered.length} / ${_members.length}',
                      style: AppTypography.caption.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),

          // Content Area (Split View on Desktop when a member is selected)
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Directory List / Data Table
                Expanded(
                  child: AppCard(
                    padding: EdgeInsets.zero,
                    child: ListView.separated(
                      itemCount: filtered.length,
                      separatorBuilder: (context, index) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final member = filtered[index];
                        final isActive = member['status'] == 'ACTIVE';
                        final isSelected = _selectedMember?['id'] == member['id'];

                        return ListTile(
                          selected: isSelected,
                          selectedTileColor: AppColors.blue50,
                          contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
                          leading: CircleAvatar(
                            backgroundColor: isActive ? AppColors.blue600 : AppColors.slate500,
                            child: Text(
                              member['name']![0],
                              style: AppTypography.body.copyWith(fontWeight: FontWeight.w600, color: Colors.white),
                            ),
                          ),
                          title: Row(
                            children: [
                              Text(member['name']!, style: AppTypography.body.copyWith(fontWeight: FontWeight.w600)),
                              const SizedBox(width: AppSpacing.sm),
                              AppBadge(
                                label: member['status']!,
                                variant: isActive ? AppBadgeVariant.active : AppBadgeVariant.danger,
                              ),
                            ],
                          ),
                          subtitle: Text(
                            '${member['number']} • ${member['phone']} • Plan: ${member['plan']}',
                            style: AppTypography.caption,
                          ),
                          trailing: const Icon(Icons.chevron_right, size: 20, color: AppColors.slate500),
                          onTap: () => _selectMember(member, isDesktop),
                        );
                      },
                    ),
                  ),
                ),

                // Side Detail Drawer for Desktop (Member 360 View)
                if (isDesktop && _selectedMember != null) ...[
                  const SizedBox(width: AppSpacing.lg),
                  SizedBox(
                    width: 340,
                    child: _buildMember360Panel(_selectedMember!),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
      },
    );
  }

  Widget _buildMember360Panel(Map<String, String> member) {
    final isActive = member['status'] == 'ACTIVE';

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Member 360 Workspace', style: AppTypography.h3),
              IconButton(
                icon: const Icon(Icons.close, size: 18),
                onPressed: () => setState(() => _selectedMember = null),
              ),
            ],
          ),
          const Divider(),
          const SizedBox(height: AppSpacing.sm),

          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.blue600,
                  child: Text(member['name']![0], style: AppTypography.h1.copyWith(color: Colors.white)),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(member['name']!, style: AppTypography.h2),
                Text(member['email']!, style: AppTypography.caption),
                const SizedBox(height: AppSpacing.xs),
                AppBadge(
                  label: member['status']!,
                  variant: isActive ? AppBadgeVariant.active : AppBadgeVariant.danger,
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.lg),
          Text('MEMBERSHIP DETAILS', style: AppTypography.caption.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: AppSpacing.xs),
          _buildDetailRow('Member Number', member['number']!),
          _buildDetailRow('Active Plan', member['plan']!),
          _buildDetailRow('Joined Date', member['joined']!),
          _buildDetailRow('Expiration Date', member['expires']!),
          _buildDetailRow('Total Check-Ins', member['checkIns']!),

          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: AppButton(
              label: 'Renew Subscription',
              icon: Icons.autorenew,
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMember360Sheet(Map<String, String> member) {
    final isActive = member['status'] == 'ACTIVE';

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusLg)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.slate200,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(member['name']!, style: AppTypography.h2),
          Text('${member['number']} • ${member['phone']}', style: AppTypography.caption),
          const SizedBox(height: AppSpacing.md),
          AppBadge(
            label: member['status']!,
            variant: isActive ? AppBadgeVariant.active : AppBadgeVariant.danger,
          ),
          const SizedBox(height: AppSpacing.lg),
          _buildDetailRow('Active Plan', member['plan']!),
          _buildDetailRow('Expiration Date', member['expires']!),
          _buildDetailRow('Total Visits', member['checkIns']!),
          const SizedBox(height: AppSpacing.xl),
          SizedBox(
            width: double.infinity,
            child: AppButton(
              label: 'Renew Membership',
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.caption.copyWith(color: AppColors.slate500)),
          Text(value, style: AppTypography.caption.copyWith(fontWeight: FontWeight.bold, color: AppColors.slate900)),
        ],
      ),
    );
  }
}
