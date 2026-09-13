import 'package:flutter/material.dart';

import '../../core/localization/app_locale.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/app_toast.dart';
import 'membership_plans_controller.dart';

class MembershipPlansScreen extends StatefulWidget {
  const MembershipPlansScreen({super.key});

  @override
  State<MembershipPlansScreen> createState() => _MembershipPlansScreenState();
}

class _MembershipPlansScreenState extends State<MembershipPlansScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch latest plans from backend API if online
    MembershipPlansController.instance.fetchPlansFromApi();
  }

  void _showPlanDialog({MembershipPlan? planToEdit}) {
    final isEditing = planToEdit != null;
    final nameController = TextEditingController(text: planToEdit?.name ?? '');
    final admissionFeeController = TextEditingController(
        text: (planToEdit?.admissionFee ?? 1000.0).toInt().toString());
    final monthlyFeeController = TextEditingController(
        text: (planToEdit?.monthlyFee ?? 3500.0).toInt().toString());
    final additionalFeeController = TextEditingController(
        text: (planToEdit?.additionalCharges ?? 0.0).toInt().toString());
    final trainerNoteController = TextEditingController(
        text: planToEdit?.trainerSupportNote ?? 'Beginner Workout Coaching (First 2 Weeks)');
    final badgeController = TextEditingController(
        text: planToEdit?.badge ?? (isEditing ? '' : 'Special Tier'));

    int durationMonths = planToEdit?.durationMonths ?? 1;
    bool isCustomDuration = ![1, 3, 6, 12].contains(durationMonths);
    final customMonthsController = TextEditingController(
        text: isCustomDuration ? durationMonths.toString() : '2');

    bool hasTrainerSupport = planToEdit?.hasTrainerSupport ?? false;
    bool hasMealPlan = planToEdit?.hasMealPlan ?? false;
    bool hasMobileApp = planToEdit?.hasMobileApp ?? true;
    bool hasLockerAccess = planToEdit?.hasLockerAccess ?? true;
    bool isMultiBranch = planToEdit?.isMultiBranch ?? false;
    bool isDefault = planToEdit?.isDefault ?? false;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final activeMonths = isCustomDuration
                ? (int.tryParse(customMonthsController.text) ?? 1).clamp(1, 60)
                : durationMonths;

            final adm = double.tryParse(admissionFeeController.text) ?? 0;
            final mth = double.tryParse(monthlyFeeController.text) ?? 0;
            final add = double.tryParse(additionalFeeController.text) ?? 0;
            final total = adm + (mth * activeMonths) + add;
            final renewal = (mth * activeMonths) + add;

            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.japaniPhal.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.card_membership, color: AppColors.japaniPhalDark, size: 22),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      isEditing ? 'Edit Membership Plan' : 'Configure New Membership Plan',
                      style: AppTypography.h2.copyWith(fontSize: 18),
                    ),
                  ),
                ],
              ),
              content: SizedBox(
                width: 580,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Plan Name & Badge
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: AppTextField(
                              label: 'Plan Name *',
                              hint: 'e.g. Basic Plan, Silver Plan, VIP Elite',
                              controller: nameController,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            flex: 2,
                            child: AppTextField(
                              label: 'Badge / Tag',
                              hint: 'e.g. Popular, Best Value',
                              controller: badgeController,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),

                      // Spacious, Uncongested Duration Selector
                      Text(
                        'Plan Duration & Billing Cycle:',
                        style: AppTypography.body.copyWith(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      const SizedBox(height: 8),

                      // Non-congested grid of duration options
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          _buildDurationOptionCard(
                            label: '1 Month',
                            subtitle: 'Monthly',
                            isSelected: !isCustomDuration && durationMonths == 1,
                            onTap: () {
                              setDialogState(() {
                                isCustomDuration = false;
                                durationMonths = 1;
                              });
                            },
                          ),
                          _buildDurationOptionCard(
                            label: '3 Months',
                            subtitle: 'Quarterly',
                            isSelected: !isCustomDuration && durationMonths == 3,
                            onTap: () {
                              setDialogState(() {
                                isCustomDuration = false;
                                durationMonths = 3;
                              });
                            },
                          ),
                          _buildDurationOptionCard(
                            label: '6 Months',
                            subtitle: 'Semi-Annual',
                            isSelected: !isCustomDuration && durationMonths == 6,
                            onTap: () {
                              setDialogState(() {
                                isCustomDuration = false;
                                durationMonths = 6;
                              });
                            },
                          ),
                          _buildDurationOptionCard(
                            label: '12 Months',
                            subtitle: 'Annual VIP',
                            isSelected: !isCustomDuration && durationMonths == 12,
                            onTap: () {
                              setDialogState(() {
                                isCustomDuration = false;
                                durationMonths = 12;
                              });
                            },
                          ),
                          _buildDurationOptionCard(
                            label: '⚙️ Custom',
                            subtitle: 'Custom Duration',
                            isSelected: isCustomDuration,
                            onTap: () {
                              setDialogState(() {
                                isCustomDuration = true;
                              });
                            },
                          ),
                        ],
                      ),

                      // Custom Duration Input Field
                      if (isCustomDuration) ...[
                        const SizedBox(height: AppSpacing.sm),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.japaniPhal.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.japaniPhal.withValues(alpha: 0.3)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.schedule, color: AppColors.japaniPhalDark, size: 20),
                              const SizedBox(width: AppSpacing.sm),
                              Expanded(
                                child: AppTextField(
                                  label: 'Custom Duration (Number of Months)',
                                  hint: 'Enter months (e.g. 2, 4, 9, 24)',
                                  controller: customMonthsController,
                                  keyboardType: TextInputType.number,
                                  onChanged: (_) => setDialogState(() {}),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: AppSpacing.md),

                      // Fee Configuration Fields
                      Row(
                        children: [
                          Expanded(
                            child: AppTextField(
                              label: 'Admission Fee (${AppLocaleController.instance.currency})',
                              hint: '1000',
                              controller: admissionFeeController,
                              keyboardType: TextInputType.number,
                              onChanged: (_) => setDialogState(() {}),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: AppTextField(
                              label: 'Monthly Fee (${AppLocaleController.instance.currency})',
                              hint: '3500',
                              controller: monthlyFeeController,
                              keyboardType: TextInputType.number,
                              onChanged: (_) => setDialogState(() {}),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: AppTextField(
                              label: 'Extra Charges',
                              hint: '0',
                              controller: additionalFeeController,
                              keyboardType: TextInputType.number,
                              onChanged: (_) => setDialogState(() {}),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),

                      // Upfront Calculated Summary Card
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: AppColors.stone100,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.stone300),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Upfront Total: Admission + ($activeMonths Mo × Fee) + Extra',
                                  style: const TextStyle(fontSize: 11, color: AppColors.stone600),
                                ),
                                Text(
                                  'Recurring Renewal: ${formatMoney(renewal)} / $activeMonths Mo',
                                  style: const TextStyle(fontSize: 11, color: AppColors.stone600, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            Text(
                              formatMoney(total),
                              style: const TextStyle(fontWeight: FontWeight.w900, color: AppColors.japaniPhalDark, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),

                      // Included Features & Perks Checkbox/Switch List
                      Text('Plan Inclusions & Benefits:', style: AppTypography.body.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),

                      // Trainer Guidance Toggle
                      _buildFeatureTile(
                        icon: Icons.sports_gymnastics,
                        title: 'Trainer Assistance / Personal Coaching',
                        subtitle: 'Coaching, stance instruction & routine guidance included',
                        value: hasTrainerSupport,
                        onChanged: (v) => setDialogState(() => hasTrainerSupport = v),
                      ),
                      if (hasTrainerSupport)
                        Padding(
                          padding: const EdgeInsets.only(left: 36, bottom: 8),
                          child: AppTextField(
                            label: 'Trainer Coaching Details / Scope',
                            hint: 'e.g. Beginner Workout Coaching (First 2 Weeks)',
                            controller: trainerNoteController,
                          ),
                        ),

                      // Diet / Meal Plan
                      _buildFeatureTile(
                        icon: Icons.restaurant_menu,
                        title: 'Personalized Meal / Diet Blueprint',
                        subtitle: 'Nutrition breakdown & dietary macros schedule',
                        value: hasMealPlan,
                        onChanged: (v) => setDialogState(() => hasMealPlan = v),
                      ),

                      // Mobile App Pass
                      _buildFeatureTile(
                        icon: Icons.qr_code_2,
                        title: 'Mobile App Pass (QR Attendance & Logs)',
                        subtitle: 'Customer access via smartphone application',
                        value: hasMobileApp,
                        onChanged: (v) => setDialogState(() => hasMobileApp = v),
                      ),

                      // Locker & Sauna
                      _buildFeatureTile(
                        icon: Icons.lock_outline,
                        title: 'Dedicated Locker & Changing Area Access',
                        subtitle: 'Secure member locker box & amenities',
                        value: hasLockerAccess,
                        onChanged: (v) => setDialogState(() => hasLockerAccess = v),
                      ),

                      // Multi-Branch Access
                      _buildFeatureTile(
                        icon: Icons.hub_outlined,
                        title: 'Multi-Branch Arena Network Pass',
                        subtitle: 'Allow check-in across all gym branch locations',
                        value: isMultiBranch,
                        onChanged: (v) => setDialogState(() => isMultiBranch = v),
                      ),

                      const Divider(height: 24),

                      // Default Plan Checkbox
                      CheckboxListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Set as Default Membership Tier for New Members', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        subtitle: const Text('Pre-selected automatically during member admissions', style: TextStyle(fontSize: 11)),
                        value: isDefault,
                        activeColor: AppColors.japaniPhalDark,
                        onChanged: (v) => setDialogState(() => isDefault = v ?? false),
                      ),
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
                  label: isEditing ? 'Save Changes' : 'Create Plan',
                  onPressed: () {
                    if (nameController.text.trim().isEmpty) {
                      AppToast.showError(context, 'Validation Error', 'Plan Name is required.');
                      return;
                    }

                    final admFee = double.tryParse(admissionFeeController.text) ?? 0.0;
                    final mthFee = double.tryParse(monthlyFeeController.text) ?? 0.0;
                    final addFee = double.tryParse(additionalFeeController.text) ?? 0.0;

                    final plan = MembershipPlan(
                      id: planToEdit?.id ?? 'plan_${DateTime.now().millisecondsSinceEpoch}',
                      name: nameController.text.trim(),
                      durationMonths: activeMonths,
                      admissionFee: admFee,
                      monthlyFee: mthFee,
                      additionalCharges: addFee,
                      hasTrainerSupport: hasTrainerSupport,
                      trainerSupportNote: hasTrainerSupport ? trainerNoteController.text.trim() : null,
                      hasMealPlan: hasMealPlan,
                      hasMobileApp: hasMobileApp,
                      hasLockerAccess: hasLockerAccess,
                      isMultiBranch: isMultiBranch,
                      badge: badgeController.text.trim().isEmpty ? 'Active' : badgeController.text.trim(),
                      isDefault: isDefault,
                    );

                    if (isEditing) {
                      MembershipPlansController.instance.updatePlan(plan);
                      AppToast.showSuccess(context, 'Plan Updated', 'Membership package ${plan.name} has been updated.');
                    } else {
                      MembershipPlansController.instance.addPlan(plan);
                      AppToast.showSuccess(context, 'Plan Created', 'New membership package ${plan.name} added.');
                    }

                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildDurationOptionCard({
    required String label,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.japaniPhalDark : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.japaniPhalDark : AppColors.stone300,
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.japaniPhalDark.withValues(alpha: 0.25),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : AppColors.stone900,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                color: isSelected ? Colors.white.withValues(alpha: 0.85) : AppColors.stone500,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      secondary: Icon(icon, color: value ? AppColors.japaniPhalDark : AppColors.stone400, size: 20),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 11, color: AppColors.stone500)),
      value: value,
      activeThumbColor: AppColors.japaniPhalDark,
      onChanged: onChanged,
    );
  }

  void _confirmDeletePlan(MembershipPlan plan) {
    if (MembershipPlansController.instance.plans.length <= 1) {
      AppToast.showError(context, 'Cannot Delete', 'You must have at least one active membership plan.');
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.delete_outline, color: AppColors.red600),
            const SizedBox(width: AppSpacing.sm),
            const Text('Delete Membership Plan'),
          ],
        ),
        content: Text(
          'Are you sure you want to delete "${plan.name}"? Members currently registered under this plan will remain unaffected, but new members cannot select it.',
          style: AppTypography.body,
        ),
        actions: [
          AppButton(
            label: 'Cancel',
            variant: AppButtonVariant.secondary,
            onPressed: () => Navigator.pop(ctx),
          ),
          AppButton(
            label: 'Delete Plan',
            variant: AppButtonVariant.danger,
            onPressed: () {
              MembershipPlansController.instance.deletePlan(plan.id);
              Navigator.pop(ctx);
              AppToast.showSuccess(context, 'Plan Deleted', '${plan.name} has been removed.');
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([
        MembershipPlansController.instance,
        AppLocaleController.instance,
      ]),
      builder: (context, _) {
        final plans = MembershipPlansController.instance.plans;

        return Scaffold(
          body: Padding(
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
                        Text(
                          'Membership Plans & Packages',
                          style: AppTypography.h1,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Configure tiered pricing, billing cycles, trainer perks, and meal benefits for your gym members.',
                          style: AppTypography.body.copyWith(color: AppColors.stone500),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        AppButton(
                          label: 'Create New Plan',
                          icon: Icons.add,
                          onPressed: () => _showPlanDialog(),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),

                // Plans Grid View
                Expanded(
                  child: plans.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : GridView.builder(
                          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 380,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            mainAxisExtent: 420,
                          ),
                          itemCount: plans.length,
                          itemBuilder: (context, idx) {
                            final plan = plans[idx];
                            return _buildPlanCard(plan);
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPlanCard(MembershipPlan plan) {
    final isDefault = plan.isDefault;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDefault ? AppColors.japaniPhalDark : AppColors.stone200,
          width: isDefault ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Name & Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Text(
                      plan.name,
                      style: AppTypography.h2.copyWith(fontSize: 16),
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (isDefault) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.japaniPhalDark,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text('DEFAULT', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ],
                ),
              ),
              if (plan.badge.isNotEmpty && !isDefault)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.japaniPhal.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    plan.badge,
                    style: const TextStyle(
                      color: AppColors.japaniPhalDark,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),

          // Duration Subtitle
          Row(
            children: [
              const Icon(Icons.schedule, size: 14, color: AppColors.stone400),
              const SizedBox(width: 4),
              Text(
                plan.durationLabel,
                style: const TextStyle(fontSize: 12, color: AppColors.stone600, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Pricing Breakdown Box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.stone100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Monthly Fee:', style: TextStyle(fontSize: 11, color: AppColors.stone600)),
                    Text('${formatMoney(plan.monthlyFee)} / mo', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Admission / Reg:', style: TextStyle(fontSize: 11, color: AppColors.stone600)),
                    Text(formatMoney(plan.admissionFee), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  ],
                ),
                if (plan.additionalCharges > 0) ...[
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Additional / Tax:', style: TextStyle(fontSize: 11, color: AppColors.stone600)),
                      Text(formatMoney(plan.additionalCharges), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    ],
                  ),
                ],
                const Divider(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Upfront Enrollment:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: AppColors.stone700)),
                    Text(
                      formatMoney(plan.totalEnrollmentFee),
                      style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14, color: AppColors.japaniPhalDark),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Inclusions Checklist
          const Text('Included Benefits:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.stone700)),
          const SizedBox(height: 6),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildBenefitRow(
                    icon: Icons.sports_gymnastics,
                    text: plan.hasTrainerSupport
                        ? (plan.trainerSupportNote ?? 'Trainer Guidance Included')
                        : 'Self-Workout (No Personal Trainer)',
                    isPositive: plan.hasTrainerSupport,
                  ),
                  _buildBenefitRow(
                    icon: Icons.restaurant_menu,
                    text: plan.hasMealPlan ? 'Personalized Meal / Diet Blueprint' : 'Standard Diet Plan Not Included',
                    isPositive: plan.hasMealPlan,
                  ),
                  _buildBenefitRow(
                    icon: Icons.qr_code_2,
                    text: plan.hasMobileApp ? 'Mobile App QR Pass & Attendance' : 'Card / Manual Pass',
                    isPositive: plan.hasMobileApp,
                  ),
                  _buildBenefitRow(
                    icon: Icons.lock_outline,
                    text: plan.hasLockerAccess ? 'Locker & Changing Facilities' : 'No Dedicated Locker',
                    isPositive: plan.hasLockerAccess,
                  ),
                  _buildBenefitRow(
                    icon: Icons.hub_outlined,
                    text: plan.isMultiBranch ? 'All-Branch Arena Access' : 'Single Home Branch Only',
                    isPositive: plan.isMultiBranch,
                  ),
                ],
              ),
            ),
          ),

          const Divider(height: 16),

          // Action Buttons
          Row(
            children: [
              if (!isDefault)
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      MembershipPlansController.instance.setDefaultPlan(plan.id);
                      AppToast.showSuccess(context, 'Default Plan Set', '${plan.name} is now the default package.');
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      side: const BorderSide(color: AppColors.stone300),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Set Default', style: TextStyle(fontSize: 11, color: AppColors.stone700, fontWeight: FontWeight.bold)),
                  ),
                ),
              if (!isDefault) const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.edit_outlined, size: 18, color: AppColors.stone600),
                tooltip: 'Edit Plan',
                onPressed: () => _showPlanDialog(planToEdit: plan),
              ),
              if (!isDefault)
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.red600),
                  tooltip: 'Delete Plan',
                  onPressed: () => _confirmDeletePlan(plan),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitRow({
    required IconData icon,
    required String text,
    required bool isPositive,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Icon(
            isPositive ? Icons.check_circle : Icons.remove_circle_outline,
            size: 14,
            color: isPositive ? AppColors.green600 : AppColors.stone400,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 11,
                color: isPositive ? AppColors.stone800 : AppColors.stone400,
                fontWeight: isPositive ? FontWeight.w600 : FontWeight.normal,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
