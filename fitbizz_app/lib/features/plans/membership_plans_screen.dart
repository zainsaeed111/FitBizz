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
        text: planToEdit?.trainerSupportNote ?? 'Beginner Workout Guidance');
    final badgeController = TextEditingController(
        text: planToEdit?.badge ?? (isEditing ? '' : 'Custom'));

    int durationMonths = planToEdit?.durationMonths ?? 1;
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
            final adm = double.tryParse(admissionFeeController.text) ?? 0;
            final mth = double.tryParse(monthlyFeeController.text) ?? 0;
            final add = double.tryParse(additionalFeeController.text) ?? 0;
            final total = adm + (mth * durationMonths) + add;

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
                    child: const Icon(Icons.card_membership, color: AppColors.japaniPhalDark, size: 20),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    isEditing ? 'Edit Membership Plan' : 'Configure New Membership Plan',
                    style: AppTypography.h2,
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

                      // Duration Selector
                      Text('Plan Duration (Billing Cycle):', style: AppTypography.body.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 8,
                        children: [
                          ChoiceChip(
                            label: const Text('1 Month (Monthly)'),
                            selected: durationMonths == 1,
                            selectedColor: AppColors.japaniPhalDark,
                            labelStyle: TextStyle(color: durationMonths == 1 ? Colors.white : AppColors.stone800, fontWeight: FontWeight.bold, fontSize: 11),
                            onSelected: (_) => setDialogState(() => durationMonths = 1),
                          ),
                          ChoiceChip(
                            label: const Text('3 Months (Quarterly)'),
                            selected: durationMonths == 3,
                            selectedColor: AppColors.japaniPhalDark,
                            labelStyle: TextStyle(color: durationMonths == 3 ? Colors.white : AppColors.stone800, fontWeight: FontWeight.bold, fontSize: 11),
                            onSelected: (_) => setDialogState(() => durationMonths = 3),
                          ),
                          ChoiceChip(
                            label: const Text('6 Months (Semi-Annual)'),
                            selected: durationMonths == 6,
                            selectedColor: AppColors.japaniPhalDark,
                            labelStyle: TextStyle(color: durationMonths == 6 ? Colors.white : AppColors.stone800, fontWeight: FontWeight.bold, fontSize: 11),
                            onSelected: (_) => setDialogState(() => durationMonths = 6),
                          ),
                          ChoiceChip(
                            label: const Text('12 Months (Annual)'),
                            selected: durationMonths == 12,
                            selectedColor: AppColors.japaniPhalDark,
                            labelStyle: TextStyle(color: durationMonths == 12 ? Colors.white : AppColors.stone800, fontWeight: FontWeight.bold, fontSize: 11),
                            onSelected: (_) => setDialogState(() => durationMonths = 12),
                          ),
                        ],
                      ),
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

                      // Upfront Calculated Summary Pill
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.stone100,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.stone300),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Total Upfront Enrollment Fee:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.stone700)),
                            Text(formatMoney(total), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: AppColors.japaniPhalDark)),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),

                      // Included Features Checklist
                      Text('Included Features & Add-ons:', style: AppTypography.body.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),

                      CheckboxListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Trainer Assistance / Guidance Included', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        subtitle: Text(hasTrainerSupport ? 'First-time form guidance or PT sessions' : 'Independent self-training only', style: const TextStyle(fontSize: 11, color: AppColors.stone500)),
                        value: hasTrainerSupport,
                        activeColor: AppColors.japaniPhalDark,
                        onChanged: (val) => setDialogState(() => hasTrainerSupport = val ?? false),
                      ),

                      if (hasTrainerSupport)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: AppTextField(
                            label: 'Trainer Support Details',
                            hint: 'e.g. Beginner Workout Guidance (First 2 Weeks)',
                            controller: trainerNoteController,
                          ),
                        ),

                      CheckboxListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Customized Diet & Meal Plan Blueprint', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        value: hasMealPlan,
                        activeColor: AppColors.japaniPhalDark,
                        onChanged: (val) => setDialogState(() => hasMealPlan = val ?? false),
                      ),

                      CheckboxListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Member Mobile App Access & QR Pass', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        value: hasMobileApp,
                        activeColor: AppColors.japaniPhalDark,
                        onChanged: (val) => setDialogState(() => hasMobileApp = val ?? true),
                      ),

                      CheckboxListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Locker, Sauna & Changing Room Access', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        value: hasLockerAccess,
                        activeColor: AppColors.japaniPhalDark,
                        onChanged: (val) => setDialogState(() => hasLockerAccess = val ?? true),
                      ),

                      CheckboxListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Multi-Branch Access (All Gym Locations)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        value: isMultiBranch,
                        activeColor: AppColors.japaniPhalDark,
                        onChanged: (val) => setDialogState(() => isMultiBranch = val ?? false),
                      ),

                      CheckboxListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Set as Default Membership Plan for New Enrollees', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.japaniPhalDark)),
                        value: isDefault,
                        activeColor: AppColors.japaniPhalDark,
                        onChanged: (val) => setDialogState(() => isDefault = val ?? false),
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.japaniPhalDark,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () {
                    if (nameController.text.trim().isEmpty) {
                      AppToast.showError(context, 'Validation Error', 'Plan Name is required');
                      return;
                    }

                    final newPlan = MembershipPlan(
                      id: planToEdit?.id ?? 'plan_${DateTime.now().millisecondsSinceEpoch}',
                      name: nameController.text.trim(),
                      durationMonths: durationMonths,
                      admissionFee: double.tryParse(admissionFeeController.text) ?? 1000.0,
                      monthlyFee: double.tryParse(monthlyFeeController.text) ?? 3500.0,
                      additionalCharges: double.tryParse(additionalFeeController.text) ?? 0.0,
                      hasTrainerSupport: hasTrainerSupport,
                      trainerSupportNote: hasTrainerSupport ? trainerNoteController.text.trim() : null,
                      hasMealPlan: hasMealPlan,
                      hasMobileApp: hasMobileApp,
                      hasLockerAccess: hasLockerAccess,
                      isMultiBranch: isMultiBranch,
                      badge: badgeController.text.trim().isEmpty ? 'Custom' : badgeController.text.trim(),
                      isDefault: isDefault,
                    );

                    if (isEditing) {
                      MembershipPlansController.instance.updatePlan(newPlan);
                      AppToast.showSuccess(context, 'Plan Updated', 'Updated "${newPlan.name}" successfully.');
                    } else {
                      MembershipPlansController.instance.addPlan(newPlan);
                      AppToast.showSuccess(context, 'Plan Created', 'Added "${newPlan.name}" to active membership offerings.');
                    }
                    Navigator.pop(ctx);
                  },
                  child: Text(isEditing ? tr('save_changes') : 'Save & Publish Plan'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _confirmDeletePlan(MembershipPlan plan) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Delete "${plan.name}"?'),
        content: const Text(
          'Are you sure you want to remove this membership plan? Existing members subscribed to this plan will remain active.',
          style: TextStyle(fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(tr('cancel')),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.red600, foregroundColor: Colors.white),
            onPressed: () {
              MembershipPlansController.instance.deletePlan(plan.id);
              Navigator.pop(ctx);
              AppToast.showSuccess(context, 'Plan Deleted', 'Plan "${plan.name}" removed.');
            },
            child: Text(tr('delete')),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 950;

    return ListenableBuilder(
      listenable: Listenable.merge([
        AppLocaleController.instance,
        MembershipPlansController.instance,
      ]),
      builder: (context, _) {
        final plans = MembershipPlansController.instance.plans;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Membership Plans & Packages', style: AppTypography.h1),
                      const SizedBox(height: 2),
                      Text(
                        'Configure pricing, admission fees, trainer support & member perks',
                        style: AppTypography.bodySecondary,
                      ),
                    ],
                  ),
                  AppButton(
                    label: 'Create New Plan',
                    icon: Icons.add,
                    onPressed: () => _showPlanDialog(),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),

              // Plans Showcase Grid
              LayoutBuilder(
                builder: (context, constraints) {
                  final crossAxisCount = isDesktop ? 3 : (screenWidth > 600 ? 2 : 1);
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: AppSpacing.md,
                      mainAxisSpacing: AppSpacing.md,
                      mainAxisExtent: 380,
                    ),
                    itemCount: plans.length,
                    itemBuilder: (context, index) {
                      final plan = plans[index];
                      return _buildPlanCard(plan);
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPlanCard(MembershipPlan plan) {
    final isDefault = plan.isDefault;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDefault ? AppColors.japaniPhalDark : AppColors.stone200,
          width: isDefault ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDefault ? 0.05 : 0.02),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row (Badge + Default Status + Menu)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isDefault
                      ? AppColors.japaniPhal.withValues(alpha: 0.15)
                      : AppColors.stone100,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  plan.badge,
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.bold,
                    color: isDefault ? AppColors.japaniPhalDark : AppColors.stone700,
                  ),
                ),
              ),
              Row(
                children: [
                  if (isDefault)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.green600.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text('DEFAULT', style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: AppColors.green600)),
                    ),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, size: 18, color: AppColors.stone500),
                    onSelected: (action) {
                      if (action == 'edit') {
                        _showPlanDialog(planToEdit: plan);
                      } else if (action == 'delete') {
                        _confirmDeletePlan(plan);
                      } else if (action == 'default') {
                        MembershipPlansController.instance.setDefaultPlan(plan.id);
                        AppToast.showSuccess(context, 'Default Plan Updated', '"${plan.name}" is now the default plan.');
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(value: 'edit', child: Row(children: [Icon(Icons.edit, size: 16), SizedBox(width: 8), Text('Edit Plan')])),
                      if (!isDefault)
                        const PopupMenuItem(value: 'default', child: Row(children: [Icon(Icons.star_border, size: 16), SizedBox(width: 8), Text('Set as Default')])),
                      const PopupMenuItem(value: 'delete', child: Row(children: [Icon(Icons.delete_outline, size: 16, color: Colors.red), SizedBox(width: 8), Text('Delete Plan', style: TextStyle(color: Colors.red))])),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Plan Name
          Text(plan.name, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: AppColors.stone900)),
          Text(plan.durationLabel, style: const TextStyle(fontSize: 11.5, color: AppColors.stone500, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),

          // Price Tag
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                formatMoney(plan.monthlyFee),
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.japaniPhalDark),
              ),
              const SizedBox(width: 4),
              const Text('/ mo', style: TextStyle(fontSize: 11, color: AppColors.stone500, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Admission Fee: ${formatMoney(plan.admissionFee)} • Total Initial: ${formatMoney(plan.totalEnrollmentFee)}',
            style: const TextStyle(fontSize: 10.5, color: AppColors.stone600, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          const Divider(color: AppColors.stone200, height: 1),
          const SizedBox(height: 10),

          // Feature Badges
          Expanded(
            child: ListView(
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildFeatureRow(Icons.fitness_center, 'Full Gym Floor Access', isIncluded: true),
                _buildFeatureRow(
                  Icons.sports,
                  plan.hasTrainerSupport
                      ? (plan.trainerSupportNote ?? 'Trainer Guidance Included')
                      : 'Self Training Only (No Trainer)',
                  isIncluded: plan.hasTrainerSupport,
                ),
                _buildFeatureRow(Icons.restaurant_menu, 'Diet & Meal Plan Blueprint', isIncluded: plan.hasMealPlan),
                _buildFeatureRow(Icons.qr_code_2, 'Mobile QR Pass & Attendance', isIncluded: plan.hasMobileApp),
                _buildFeatureRow(Icons.lock_clock, 'Locker & Shower Access', isIncluded: plan.hasLockerAccess),
                _buildFeatureRow(Icons.hub, 'Multi-Branch Arena Pass', isIncluded: plan.isMultiBranch),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Action Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: isDefault ? AppColors.japaniPhalDark : AppColors.stone700,
                side: BorderSide(color: isDefault ? AppColors.japaniPhalDark : AppColors.stone300),
                padding: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              icon: const Icon(Icons.tune, size: 14),
              label: const Text('Edit Package', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold)),
              onPressed: () => _showPlanDialog(planToEdit: plan),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureRow(IconData icon, String text, {required bool isIncluded}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        children: [
          Icon(
            isIncluded ? Icons.check_circle : Icons.remove_circle_outline,
            size: 14,
            color: isIncluded ? AppColors.green600 : AppColors.stone400,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 11,
                color: isIncluded ? AppColors.stone800 : AppColors.stone400,
                fontWeight: isIncluded ? FontWeight.w600 : FontWeight.normal,
                decoration: isIncluded ? null : TextDecoration.lineThrough,
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
