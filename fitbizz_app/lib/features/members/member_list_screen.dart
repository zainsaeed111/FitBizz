import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
import 'digital_member_pass_card.dart';
import 'members_controller.dart';

class MemberListScreen extends StatefulWidget {
  const MemberListScreen({super.key});

  @override
  State<MemberListScreen> createState() => _MemberListScreenState();
}

class _MemberListScreenState extends State<MemberListScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  String _statusFilter = 'ALL'; // ALL, ACTIVE, DUE, OVERDUE
  String _planFilter = 'ALL';
  MemberModel? _selectedMember;

  // Preset Avatars for Fast Admission
  static const List<String> _presetAvatars = [
    'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200&auto=format&fit=crop&q=80',
    'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200&auto=format&fit=crop&q=80',
    'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=200&auto=format&fit=crop&q=80',
    'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200&auto=format&fit=crop&q=80',
    'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=200&auto=format&fit=crop&q=80',
    'https://images.unsplash.com/photo-1492562080023-ab3db95bfbce?w=200&auto=format&fit=crop&q=80',
  ];

  void _selectMember(MemberModel member, bool isDesktop) {
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

  // --- THEMED CALENDAR DATE PICKER ---
  Future<DateTime?> _pickThemedDate(BuildContext context, DateTime initialDate) async {
    return await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1940),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.japaniPhalDark,
              onPrimary: Colors.white,
              onSurface: AppColors.stone900,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.japaniPhalDark,
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          child: child!,
        );
      },
    );
  }

  // --- FAST SETTLE DUE FEE MODAL ---
  void _showSettleFeeModal(MemberModel member) {
    final amountController = TextEditingController(text: (member.dueAmount > 0 ? member.dueAmount : member.monthlyFee).toInt().toString());
    final refController = TextEditingController();
    String paymentMode = 'CASH';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          final double due = double.tryParse(amountController.text) ?? (member.dueAmount > 0 ? member.dueAmount : member.monthlyFee);

          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.green600.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.point_of_sale, color: AppColors.green600, size: 20),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Settle Dues: ${member.fullName}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Text('${member.memberNumber} • ${member.planName}', style: const TextStyle(fontSize: 11, color: AppColors.stone500)),
                    ],
                  ),
                ),
              ],
            ),
            content: SizedBox(
              width: 440,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.stone100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Current Pending Dues:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                        Text(
                          formatMoney(member.dueAmount > 0 ? member.dueAmount : member.monthlyFee),
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: AppColors.red600),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  AppTextField(
                    label: 'Amount to Pay (${AppLocaleController.instance.currency})',
                    hint: '4500',
                    controller: amountController,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  const Text('Payment Mode:', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: AppColors.stone700)),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    children: [
                      ChoiceChip(
                        label: const Text('💵 Cash (POS)'),
                        selected: paymentMode == 'CASH',
                        selectedColor: AppColors.green600,
                        labelStyle: TextStyle(color: paymentMode == 'CASH' ? Colors.white : AppColors.stone800, fontWeight: FontWeight.bold, fontSize: 11),
                        onSelected: (_) => setModalState(() => paymentMode = 'CASH'),
                      ),
                      ChoiceChip(
                        label: const Text('💳 Online / Raast'),
                        selected: paymentMode == 'ONLINE',
                        selectedColor: AppColors.japaniPhalDark,
                        labelStyle: TextStyle(color: paymentMode == 'ONLINE' ? Colors.white : AppColors.stone800, fontWeight: FontWeight.bold, fontSize: 11),
                        onSelected: (_) => setModalState(() => paymentMode = 'ONLINE'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              AppButton(
                label: 'Cancel',
                variant: AppButtonVariant.secondary,
                onPressed: () => Navigator.pop(context),
              ),
              AppButton(
                label: 'Collect & Issue Receipt',
                icon: Icons.check_circle,
                onPressed: () {
                  final paid = double.tryParse(amountController.text) ?? due;
                  MembersController.instance.recordFeePayment(
                    member.id,
                    paid,
                    paymentMode,
                    extendMonths: 1,
                    receiptRef: refController.text.trim().isEmpty ? null : refController.text.trim(),
                  );
                  Navigator.pop(context);
                  AppToast.showSuccess(
                    context,
                    'Fee Collected Successfully',
                    'Received ${formatMoney(paid)} from ${member.fullName}. Plan extended for 1 month.',
                  );
                  setState(() {
                    _selectedMember = MembersController.instance.members.firstWhere((m) => m.id == member.id);
                  });
                },
              ),
            ],
          );
        },
      ),
    );
  }

  // --- SUPER PREMIUM ADMIT MEMBER MODAL WITH EMBEDDED POS & HEALTH LEDGER ---
  void _showAddMemberModal() {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final cnicController = TextEditingController();
    DateTime selectedDob = DateTime(1998, 5, 14);

    // Financial POS State
    String paymentMode = 'CASH'; // CASH, ONLINE, WALLET
    final cashTenderedController = TextEditingController();
    final bankNameController = TextEditingController(text: 'Meezan Bank / Raast');
    final refController = TextEditingController();

    // Health & Diet Profile State
    String selectedAvatar = _presetAvatars[0];
    String selectedGender = 'Male';
    String selectedBloodGroup = 'O+';
    final weightController = TextEditingController(text: '75.0');
    final targetWeightController = TextEditingController(text: '70.0');
    final heightController = TextEditingController(text: '5\'10"');
    String selectedGoal = 'Muscle Building';
    String selectedDiet = 'High Protein (Balanced)';
    final emergencyNameController = TextEditingController();
    final emergencyPhoneController = TextEditingController();

    final plans = MembershipPlansController.instance.plans;
    String selectedPlanId = MembershipPlansController.instance.defaultPlan?.id ??
        (plans.isNotEmpty ? plans.first.id : 'plan_basic');

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        final screenWidth = MediaQuery.of(context).size.width;
        final isWide = screenWidth >= 880;

        return StatefulBuilder(
          builder: (context, setModalState) {
            final selectedPlan = plans.firstWhere(
              (p) => p.id == selectedPlanId,
              orElse: () => plans.first,
            );

            final double totalFee = selectedPlan.totalEnrollmentFee;
            final double tendered = double.tryParse(cashTenderedController.text) ?? totalFee;
            final double changeDue = tendered >= totalFee ? (tendered - totalFee) : 0.0;

            // Widget for Left Column: Personal & Health Info
            Widget buildPersonalAndHealthSection() {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Personal Header
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.japaniPhal.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.badge_outlined, size: 16, color: AppColors.japaniPhalDark),
                        SizedBox(width: 6),
                        Text('1. Member Personal & Contact Details', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.stone900)),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  AppTextField(
                    label: 'Full Name *',
                    hint: 'e.g. Usman Ali, Tauseef Ahmed',
                    controller: nameController,
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  Row(
                    children: [
                      Expanded(
                        child: AppTextField(
                          label: 'Phone / WhatsApp *',
                          hint: '+92 300 1234567',
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: AppTextField(
                          label: 'CNIC / National ID',
                          hint: '35202-1234567-1',
                          controller: cnicController,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  // Themed DOB Calendar Picker
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Date of Birth (Themed Calendar):', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: AppColors.stone700)),
                      const SizedBox(height: 5),
                      InkWell(
                        onTap: () async {
                          final picked = await _pickThemedDate(context, selectedDob);
                          if (picked != null) {
                            setModalState(() => selectedDob = picked);
                          }
                        },
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.stone300),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.calendar_month, size: 17, color: AppColors.japaniPhalDark),
                                  const SizedBox(width: 8),
                                  Text(
                                    DateFormat('yyyy-MM-dd').format(selectedDob),
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5, color: AppColors.stone900),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.stone100,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'Age: ${DateTime.now().year - selectedDob.year} yrs',
                                  style: const TextStyle(fontSize: 11, color: AppColors.stone700, fontWeight: FontWeight.w700),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Health & Fitness Section Header
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.stone100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.fitness_center, size: 16, color: AppColors.stone700),
                        SizedBox(width: 6),
                        Text('2. Health, Diet & Metrics (Optional Profile)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.stone900)),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  // Avatar selector
                  const Text('Member Avatar Photo:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.stone700)),
                  const SizedBox(height: 5),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _presetAvatars.map((url) {
                        final isPicked = url == selectedAvatar;
                        return GestureDetector(
                          onTap: () => setModalState(() => selectedAvatar = url),
                          child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isPicked ? AppColors.japaniPhalDark : Colors.transparent,
                                width: 2.5,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 18,
                              backgroundImage: NetworkImage(url),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  // Gender, Blood Group & Height
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: selectedGender,
                          decoration: InputDecoration(
                            labelText: 'Gender',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.stone300)),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.stone300)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          ),
                          items: ['Male', 'Female', 'Other']
                              .map((g) => DropdownMenuItem(value: g, child: Text(g, style: const TextStyle(fontSize: 12))))
                              .toList(),
                          onChanged: (v) => setModalState(() => selectedGender = v ?? 'Male'),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: selectedBloodGroup,
                          decoration: InputDecoration(
                            labelText: 'Blood Group',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.stone300)),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.stone300)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          ),
                          items: ['O+', 'A+', 'B+', 'AB+', 'O-', 'A-', 'B-', 'AB-']
                              .map((bg) => DropdownMenuItem(value: bg, child: Text('🩸 $bg', style: const TextStyle(fontSize: 12))))
                              .toList(),
                          onChanged: (v) => setModalState(() => selectedBloodGroup = v ?? 'O+'),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: AppTextField(
                          label: 'Height',
                          hint: '5\'10"',
                          controller: heightController,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  // Weight Metrics
                  Row(
                    children: [
                      Expanded(
                        child: AppTextField(
                          label: 'Current Weight (kg)',
                          hint: '75.0',
                          controller: weightController,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: AppTextField(
                          label: 'Target Weight (kg)',
                          hint: '70.0',
                          controller: targetWeightController,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  // Goal & Diet
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: selectedGoal,
                          decoration: InputDecoration(
                            labelText: 'Fitness Goal',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.stone300)),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.stone300)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          ),
                          items: [
                            'Muscle Building',
                            'Fat Loss & Cardio',
                            'Endurance & Agility',
                            'General Fitness',
                          ]
                              .map((g) => DropdownMenuItem(value: g, child: Text(g, style: const TextStyle(fontSize: 11.5))))
                              .toList(),
                          onChanged: (v) => setModalState(() => selectedGoal = v ?? 'General Fitness'),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: selectedDiet,
                          decoration: InputDecoration(
                            labelText: 'Diet Preference',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.stone300)),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.stone300)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          ),
                          items: [
                            'High Protein (Balanced)',
                            'Keto / Low Carb',
                            'Standard Gym Diet',
                            'Vegetarian / Vegan',
                          ]
                              .map((d) => DropdownMenuItem(value: d, child: Text(d, style: const TextStyle(fontSize: 11.5))))
                              .toList(),
                          onChanged: (v) => setModalState(() => selectedDiet = v ?? 'High Protein (Balanced)'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  // Emergency Contact
                  Row(
                    children: [
                      Expanded(
                        child: AppTextField(
                          label: 'Emergency Contact Name',
                          hint: 'e.g. Brother / Father',
                          controller: emergencyNameController,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: AppTextField(
                          label: 'Emergency Phone',
                          hint: '+92 300 0000000',
                          controller: emergencyPhoneController,
                          keyboardType: TextInputType.phone,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }

            // Widget for Right Column: Package Selection & POS Payment Settlement
            Widget buildPlanAndPosSection() {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Plan Selection Header
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.japaniPhal.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.workspace_premium, size: 16, color: AppColors.japaniPhalDark),
                        SizedBox(width: 6),
                        Text('3. Select Membership Package', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.stone900)),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  // Plans Choice Grid/Chips
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: plans.map((plan) {
                      final isSelected = plan.id == selectedPlanId;
                      return InkWell(
                        onTap: () => setModalState(() => selectedPlanId = plan.id),
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.japaniPhalDark : Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isSelected ? AppColors.japaniPhalDark : AppColors.stone300,
                              width: isSelected ? 1.5 : 1.0,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: AppColors.japaniPhalDark.withValues(alpha: 0.2),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                                size: 14,
                                color: isSelected ? Colors.white : AppColors.stone500,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '${plan.name} (${formatMoney(plan.monthlyFee)}/mo)',
                                style: TextStyle(
                                  color: isSelected ? Colors.white : AppColors.stone800,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                  fontSize: 11.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  // Selected Plan Summary Box
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.stone50,
                      borderRadius: BorderRadius.circular(12),
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
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.japaniPhal.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                selectedPlan.badge,
                                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.japaniPhalDark),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text('• Duration: ${selectedPlan.durationLabel}', style: const TextStyle(fontSize: 11, color: AppColors.stone600)),
                        Text('• Admission Fee: ${formatMoney(selectedPlan.admissionFee)} + Monthly Fee: ${formatMoney(selectedPlan.monthlyFee * selectedPlan.durationMonths)}', style: const TextStyle(fontSize: 11, color: AppColors.stone600)),
                        if (selectedPlan.hasTrainerSupport)
                          Text('• 🏋️ Trainer: ${selectedPlan.trainerSupportNote ?? "Trainer Guidance Included"}', style: const TextStyle(fontSize: 11, color: AppColors.green600, fontWeight: FontWeight.bold))
                        else
                          const Text('• Self-Workout (No Personal Trainer)', style: TextStyle(fontSize: 11, color: AppColors.stone500)),
                        const Divider(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Total Upfront Fee Payable:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.stone700)),
                            Text(formatMoney(totalFee), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: AppColors.japaniPhalDark)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // POS Settlement Header
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.stone100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.point_of_sale, size: 16, color: AppColors.stone700),
                        SizedBox(width: 6),
                        Text('4. Point of Sale (POS) Fee Settlement', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.stone900)),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  // Payment mode selector
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ChoiceChip(
                        label: const Text('💵 Cash Payment (POS)'),
                        selected: paymentMode == 'CASH',
                        selectedColor: AppColors.green600,
                        labelStyle: TextStyle(color: paymentMode == 'CASH' ? Colors.white : AppColors.stone800, fontWeight: FontWeight.bold, fontSize: 11.5),
                        onSelected: (_) => setModalState(() => paymentMode = 'CASH'),
                      ),
                      ChoiceChip(
                        label: const Text('💳 Online Bank / Raast'),
                        selected: paymentMode == 'ONLINE',
                        selectedColor: AppColors.japaniPhalDark,
                        labelStyle: TextStyle(color: paymentMode == 'ONLINE' ? Colors.white : AppColors.stone800, fontWeight: FontWeight.bold, fontSize: 11.5),
                        onSelected: (_) => setModalState(() => paymentMode = 'ONLINE'),
                      ),
                      ChoiceChip(
                        label: const Text('📱 JazzCash / EasyPaisa / POS'),
                        selected: paymentMode == 'WALLET',
                        selectedColor: AppColors.stone900,
                        labelStyle: TextStyle(color: paymentMode == 'WALLET' ? Colors.white : AppColors.stone800, fontWeight: FontWeight.bold, fontSize: 11.5),
                        onSelected: (_) => setModalState(() => paymentMode = 'WALLET'),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  // POS Mode Specific Form
                  if (paymentMode == 'CASH') ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.green600.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.green600.withValues(alpha: 0.3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: AppTextField(
                                  label: 'Cash Tendered / Received (${AppLocaleController.instance.currency})',
                                  hint: totalFee.toInt().toString(),
                                  controller: cashTenderedController,
                                  keyboardType: TextInputType.number,
                                  onChanged: (_) => setModalState(() {}),
                                ),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: AppColors.green600.withValues(alpha: 0.4)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Change to Return:', style: TextStyle(fontSize: 10, color: AppColors.stone500, fontWeight: FontWeight.bold)),
                                    Text(
                                      formatMoney(changeDue),
                                      style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14, color: AppColors.green600),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Fast Cash Suggestions
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: [
                              ActionChip(
                                label: Text('Exact: ${formatMoney(totalFee)}', style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold)),
                                onPressed: () {
                                  cashTenderedController.text = totalFee.toInt().toString();
                                  setModalState(() {});
                                },
                              ),
                              ActionChip(
                                label: Text('₨ ${(totalFee + 500).toInt()}', style: const TextStyle(fontSize: 10.5)),
                                onPressed: () {
                                  cashTenderedController.text = (totalFee + 500).toInt().toString();
                                  setModalState(() {});
                                },
                              ),
                              ActionChip(
                                label: const Text('₨ 5,000', style: TextStyle(fontSize: 10.5)),
                                onPressed: () {
                                  cashTenderedController.text = '5000';
                                  setModalState(() {});
                                },
                              ),
                              ActionChip(
                                label: const Text('₨ 10,000', style: TextStyle(fontSize: 10.5)),
                                onPressed: () {
                                  cashTenderedController.text = '10000';
                                  setModalState(() {});
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ] else if (paymentMode == 'ONLINE') ...[
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: AppTextField(
                            label: 'Bank / Channel Name',
                            hint: 'e.g. Meezan Bank, HBL Raast',
                            controller: bankNameController,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          flex: 3,
                          child: AppTextField(
                            label: 'Transaction / Receipt Ref ID',
                            hint: 'TRX-9823471',
                            controller: refController,
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    AppTextField(
                      label: 'Wallet Mobile # or POS Terminal Auth Code',
                      hint: '03001234567 / AUTH-4912',
                      controller: refController,
                    ),
                  ],
                ],
              );
            }

            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.japaniPhal.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.person_add_alt_1, color: AppColors.japaniPhalDark, size: 22),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Admit New Member & Issue Pass', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900)),
                      Text('Configure plan, POS fee collection, and health metrics in real-time', style: TextStyle(fontSize: 11, color: AppColors.stone500)),
                    ],
                  ),
                ],
              ),
              content: SizedBox(
                width: isWide ? 900 : 540,
                child: SingleChildScrollView(
                  child: isWide
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: buildPersonalAndHealthSection()),
                            const SizedBox(width: 24),
                            Expanded(child: buildPlanAndPosSection()),
                          ],
                        )
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildPersonalAndHealthSection(),
                            const SizedBox(height: AppSpacing.md),
                            const Divider(),
                            const SizedBox(height: AppSpacing.md),
                            buildPlanAndPosSection(),
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
                  label: 'Confirm & Generate Pass',
                  icon: Icons.qr_code,
                  onPressed: () {
                    if (nameController.text.trim().isEmpty) {
                      AppToast.showError(context, 'Validation Error', 'Member Full Name is required.');
                      return;
                    }
                    if (phoneController.text.trim().isEmpty) {
                      AppToast.showError(context, 'Validation Error', 'Phone number is required.');
                      return;
                    }

                    // Month-based sequential roll number: METRO-YYYYMM-0001
                    final rollNum = MembersController.instance.generateNextRollNumber();
                    final memberId = MembersController.instance.generateNextMemberId();

                    final now = DateTime.now();
                    final expiryDate = DateTime(now.year, now.month + selectedPlan.durationMonths, now.day);
                    final joinDateStr = DateFormat('yyyy-MM-dd').format(now);
                    final expiryDateStr = DateFormat('yyyy-MM-dd').format(expiryDate);
                    final dobStr = DateFormat('yyyy-MM-dd').format(selectedDob);

                    final newMember = MemberModel(
                      id: memberId,
                      memberNumber: rollNum,
                      fullName: nameController.text.trim(),
                      phone: phoneController.text.trim(),
                      cnic: cnicController.text.trim().isEmpty ? null : cnicController.text.trim(),
                      dob: dobStr,
                      photoUrl: selectedAvatar,
                      planId: selectedPlan.id,
                      planName: selectedPlan.name,
                      durationMonths: selectedPlan.durationMonths,
                      admissionFee: selectedPlan.admissionFee,
                      monthlyFee: selectedPlan.monthlyFee,
                      totalFeePaid: totalFee,
                      paymentMode: paymentMode,
                      paymentRef: paymentMode == 'CASH' ? null : refController.text.trim(),
                      cashTendered: paymentMode == 'CASH' ? tendered : null,
                      changeReturned: paymentMode == 'CASH' ? changeDue : null,
                      status: 'ACTIVE',
                      joinedDate: joinDateStr,
                      expiryDate: expiryDateStr,
                      gender: selectedGender,
                      bloodGroup: selectedBloodGroup,
                      currentWeightKg: double.tryParse(weightController.text),
                      targetWeightKg: double.tryParse(targetWeightController.text),
                      height: heightController.text.trim().isEmpty ? null : heightController.text.trim(),
                      fitnessGoal: selectedGoal,
                      dietaryPreference: selectedDiet,
                      emergencyContactName: emergencyNameController.text.trim().isEmpty ? null : emergencyNameController.text.trim(),
                      emergencyContactPhone: emergencyPhoneController.text.trim().isEmpty ? null : emergencyPhoneController.text.trim(),
                    );

                    MembersController.instance.addMember(newMember);
                    Navigator.pop(context);

                    AppToast.showSuccess(
                      context,
                      'Member Admitted Successfully',
                      'Enrolled ${newMember.fullName} under ${newMember.planName} (${formatMoney(totalFee)}). Pass $rollNum issued.',
                    );

                    // Immediately present the Digital Member Pass Card!
                    DigitalMemberPassDialog.show(context, newMember);
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  // --- UPGRADE / CHANGE PLAN MODAL ---
  void _showUpgradePlanModal(MemberModel member) {
    final plans = MembershipPlansController.instance.plans;
    String selectedPlanId = member.planId;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setUpgradeState) {
          final selectedPlan = plans.firstWhere((p) => p.id == selectedPlanId, orElse: () => plans.first);
          final double totalRenewal = selectedPlan.renewalFee;

          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Row(
              children: [
                const Icon(Icons.upgrade, color: AppColors.japaniPhalDark),
                const SizedBox(width: AppSpacing.sm),
                Text('Change / Upgrade Plan (${member.fullName})'),
              ],
            ),
            content: SizedBox(
              width: 480,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Current Package: ${member.planName} (Expires: ${member.expiryDate})', style: const TextStyle(fontSize: 12, color: AppColors.stone600)),
                  const SizedBox(height: AppSpacing.md),
                  const Text('Select New Package Tier:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: plans.map((p) {
                      final isSelected = p.id == selectedPlanId;
                      return ChoiceChip(
                        label: Text('${p.name} (${formatMoney(p.monthlyFee)}/mo)'),
                        selected: isSelected,
                        selectedColor: AppColors.japaniPhalDark,
                        labelStyle: TextStyle(color: isSelected ? Colors.white : AppColors.stone800, fontWeight: FontWeight.bold, fontSize: 11),
                        onSelected: (_) => setUpgradeState(() => selectedPlanId = p.id),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.stone100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total Plan Fee Payable:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        Text(formatMoney(totalRenewal), style: const TextStyle(fontWeight: FontWeight.w900, color: AppColors.japaniPhalDark, fontSize: 15)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              AppButton(
                label: 'Cancel',
                variant: AppButtonVariant.secondary,
                onPressed: () => Navigator.pop(ctx),
              ),
              AppButton(
                label: 'Confirm Upgrade',
                onPressed: () {
                  final now = DateTime.now();
                  final newExpiry = DateTime(now.year, now.month + selectedPlan.durationMonths, now.day);
                  final expiryStr = DateFormat('yyyy-MM-dd').format(newExpiry);

                  MembersController.instance.changeMemberPlan(
                    member.id,
                    newPlanId: selectedPlan.id,
                    newPlanName: selectedPlan.name,
                    durationMonths: selectedPlan.durationMonths,
                    monthlyFee: selectedPlan.monthlyFee,
                    totalPaid: totalRenewal,
                    newExpiryDate: expiryStr,
                  );

                  Navigator.pop(ctx);
                  AppToast.showSuccess(ctx, 'Plan Upgraded', 'Member ${member.fullName} upgraded to ${selectedPlan.name}.');
                },
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 900;

    return ListenableBuilder(
      listenable: Listenable.merge([
        MembersController.instance,
        AppLocaleController.instance,
      ]),
      builder: (context, _) {
        final allMembers = MembersController.instance.members;

        final activeCount = allMembers.where((m) => m.status == 'ACTIVE' && m.feeStatus == 'PAID' && !m.isDueSoon).length;
        final dueCount = allMembers.where((m) => m.isDueSoon && !m.isOverdue).length;
        final overdueCount = allMembers.where((m) => m.isOverdue).length;

        final filtered = allMembers.where((m) {
          final query = _searchQuery.toLowerCase();
          final matchesSearch = m.fullName.toLowerCase().contains(query) ||
              m.memberNumber.toLowerCase().contains(query) ||
              m.phone.toLowerCase().contains(query) ||
              (m.cnic != null && m.cnic!.toLowerCase().contains(query)) ||
              (m.bloodGroup != null && m.bloodGroup!.toLowerCase().contains(query));

          if (!matchesSearch) return false;

          // Status / Fee filter
          if (_statusFilter == 'ACTIVE') {
            if (m.status != 'ACTIVE' || m.isDueSoon || m.isOverdue) return false;
          } else if (_statusFilter == 'DUE') {
            if (!m.isDueSoon || m.isOverdue) return false;
          } else if (_statusFilter == 'OVERDUE') {
            if (!m.isOverdue) return false;
          }

          // Plan filter
          if (_planFilter != 'ALL') {
            if (m.planId != _planFilter && m.planName != _planFilter) return false;
          }

          return true;
        }).toList();

        return Scaffold(
          body: Row(
            children: [
              // Left: Member List Directory
              Expanded(
                flex: isDesktop ? 6 : 12,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Row (Zero-Overflow Guaranteed)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(tr('nav_members'), style: AppTypography.h1.copyWith(fontSize: 22)),
                                const SizedBox(height: 2),
                                Text(
                                  '${allMembers.length} Members • Passes & Billing',
                                  style: AppTypography.caption.copyWith(color: AppColors.stone500),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          AppButton(
                            label: 'Admit Member',
                            icon: Icons.person_add,
                            onPressed: _showAddMemberModal,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),

                      // Search Input
                      AppTextField(
                        label: 'Search Member Directory',
                        hint: 'Search by Name, Roll #, Phone, CNIC, or Blood Group...',
                        controller: _searchController,
                        onChanged: (val) => setState(() => _searchQuery = val),
                      ),
                      const SizedBox(height: AppSpacing.sm),

                      // Filter Chips Bar (All, Active, Fee Due, Overdue)
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            ChoiceChip(
                              label: Text('All (${allMembers.length})'),
                              selected: _statusFilter == 'ALL',
                              selectedColor: AppColors.japaniPhalDark,
                              labelStyle: TextStyle(
                                color: _statusFilter == 'ALL' ? Colors.white : AppColors.stone800,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                              onSelected: (_) => setState(() => _statusFilter = 'ALL'),
                            ),
                            const SizedBox(width: 6),
                            ChoiceChip(
                              label: Text('✅ Active ($activeCount)'),
                              selected: _statusFilter == 'ACTIVE',
                              selectedColor: AppColors.green600,
                              labelStyle: TextStyle(
                                color: _statusFilter == 'ACTIVE' ? Colors.white : AppColors.stone800,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                              onSelected: (_) => setState(() => _statusFilter = 'ACTIVE'),
                            ),
                            const SizedBox(width: 6),
                            ChoiceChip(
                              label: Text('⚠️ Due Soon ($dueCount)'),
                              selected: _statusFilter == 'DUE',
                              selectedColor: Colors.amber.shade800,
                              labelStyle: TextStyle(
                                color: _statusFilter == 'DUE' ? Colors.white : AppColors.stone800,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                              onSelected: (_) => setState(() => _statusFilter = 'DUE'),
                            ),
                            const SizedBox(width: 6),
                            ChoiceChip(
                              label: Text('❌ Overdue ($overdueCount)'),
                              selected: _statusFilter == 'OVERDUE',
                              selectedColor: AppColors.red600,
                              labelStyle: TextStyle(
                                color: _statusFilter == 'OVERDUE' ? Colors.white : AppColors.stone800,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                              onSelected: (_) => setState(() => _statusFilter = 'OVERDUE'),
                            ),
                            const SizedBox(width: 12),
                            Container(width: 1, height: 20, color: AppColors.stone300),
                            const SizedBox(width: 12),
                            ChoiceChip(
                              label: const Text('All Plans'),
                              selected: _planFilter == 'ALL',
                              selectedColor: AppColors.stone800,
                              labelStyle: TextStyle(
                                color: _planFilter == 'ALL' ? Colors.white : AppColors.stone800,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                              onSelected: (_) => setState(() => _planFilter = 'ALL'),
                            ),
                            const SizedBox(width: 6),
                            ChoiceChip(
                              label: const Text('Basic'),
                              selected: _planFilter == 'plan_basic' || _planFilter == 'Basic Plan',
                              selectedColor: AppColors.stone800,
                              labelStyle: TextStyle(
                                color: (_planFilter == 'plan_basic' || _planFilter == 'Basic Plan') ? Colors.white : AppColors.stone800,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                              onSelected: (_) => setState(() => _planFilter = 'plan_basic'),
                            ),
                            const SizedBox(width: 6),
                            ChoiceChip(
                              label: const Text('Silver'),
                              selected: _planFilter == 'plan_silver' || _planFilter == 'Silver Plan',
                              selectedColor: AppColors.stone800,
                              labelStyle: TextStyle(
                                color: (_planFilter == 'plan_silver' || _planFilter == 'Silver Plan') ? Colors.white : AppColors.stone800,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                              onSelected: (_) => setState(() => _planFilter = 'plan_silver'),
                            ),
                            const SizedBox(width: 6),
                            ChoiceChip(
                              label: const Text('Gold VIP'),
                              selected: _planFilter == 'plan_gold' || _planFilter == 'Gold VIP Plan',
                              selectedColor: AppColors.stone800,
                              labelStyle: TextStyle(
                                color: (_planFilter == 'plan_gold' || _planFilter == 'Gold VIP Plan') ? Colors.white : AppColors.stone800,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                              onSelected: (_) => setState(() => _planFilter = 'plan_gold'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),

                      // Members Grid / List
                      Expanded(
                        child: filtered.isEmpty
                            ? const Center(child: Text('No members found matching criteria.', style: TextStyle(color: AppColors.stone500)))
                            : ListView.builder(
                                itemCount: filtered.length,
                                itemBuilder: (context, index) {
                                  final member = filtered[index];
                                  final isSelected = _selectedMember?.id == member.id;

                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                                    child: AppCard(
                                      padding: const EdgeInsets.all(AppSpacing.md),
                                      child: InkWell(
                                        onTap: () => _selectMember(member, isDesktop),
                                        child: Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 22,
                                              backgroundImage: NetworkImage(member.photoUrl),
                                            ),
                                            const SizedBox(width: AppSpacing.md),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Flexible(
                                                        child: Text(
                                                          member.fullName,
                                                          style: AppTypography.body.copyWith(
                                                            fontWeight: FontWeight.bold,
                                                            color: isSelected ? AppColors.japaniPhalDark : null,
                                                          ),
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      ),
                                                      const SizedBox(width: 6),
                                                      if (member.isOverdue)
                                                        Container(
                                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                          decoration: BoxDecoration(
                                                            color: AppColors.red600.withValues(alpha: 0.15),
                                                            borderRadius: BorderRadius.circular(4),
                                                          ),
                                                          child: Text(
                                                            'OVERDUE (${formatMoney(member.dueAmount > 0 ? member.dueAmount : member.monthlyFee)})',
                                                            style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: AppColors.red600),
                                                          ),
                                                        )
                                                      else if (member.isDueSoon)
                                                        Container(
                                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                          decoration: BoxDecoration(
                                                            color: Colors.amber.withValues(alpha: 0.2),
                                                            borderRadius: BorderRadius.circular(4),
                                                          ),
                                                          child: Text(
                                                            'DUE SOON (${formatMoney(member.dueAmount > 0 ? member.dueAmount : member.monthlyFee)})',
                                                            style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: Colors.amber.shade900),
                                                          ),
                                                        )
                                                      else
                                                        AppBadge(
                                                          label: member.status,
                                                          variant: member.status == 'ACTIVE'
                                                              ? AppBadgeVariant.active
                                                              : AppBadgeVariant.neutral,
                                                        ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 2),
                                                  Text(
                                                    '${member.memberNumber} • ${member.planName} • ${member.phone}',
                                                    style: AppTypography.caption.copyWith(color: AppColors.stone500),
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                            ),

                                            // Quick Digital Card Button
                                            IconButton(
                                              icon: const Icon(Icons.qr_code, color: AppColors.japaniPhalDark),
                                              tooltip: 'View Digital Pass Card',
                                              onPressed: () => DigitalMemberPassDialog.show(context, member),
                                            ),

                                            const SizedBox(width: AppSpacing.sm),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  'Expires: ${member.expiryDate}',
                                                  style: AppTypography.caption.copyWith(fontWeight: FontWeight.bold),
                                                ),
                                                Text(
                                                  'Paid: ${formatMoney(member.totalFeePaid)}',
                                                  style: AppTypography.caption.copyWith(color: AppColors.stone500),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ),

              // Right: Full Member 360 Workspace (Desktop Mode)
              if (isDesktop && _selectedMember != null) ...[
                const VerticalDivider(width: 1, color: AppColors.stone200),
                Expanded(
                  flex: 6,
                  child: Container(
                    color: AppColors.stone50,
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: _buildMember360Sheet(_selectedMember!),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  // --- MEMBER 360 PROFILE, HEALTH STATS & ACTIONS VIEW ---
  Widget _buildMember360Sheet(MemberModel member) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Card
          Row(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundImage: NetworkImage(member.photoUrl),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(member.fullName, style: AppTypography.h1.copyWith(fontSize: 20)),
                    Text(
                      '${member.memberNumber} • ${member.gender} (${member.dob})',
                      style: AppTypography.caption.copyWith(color: AppColors.stone500),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        AppBadge(
                          label: member.status,
                          variant: member.status == 'ACTIVE' ? AppBadgeVariant.active : AppBadgeVariant.neutral,
                        ),
                        const SizedBox(width: 6),
                        if (member.bloodGroup != null)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.red600.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text('🩸 ${member.bloodGroup}', style: const TextStyle(fontSize: 10, color: AppColors.red600, fontWeight: FontWeight.bold)),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              // View Digital Card Button
              IconButton.filled(
                style: IconButton.styleFrom(backgroundColor: AppColors.japaniPhalDark),
                icon: const Icon(Icons.qr_code_2, color: Colors.white),
                tooltip: 'Open Digital Pass',
                onPressed: () => DigitalMemberPassDialog.show(context, member),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // Primary Actions Row
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.qr_code, size: 16),
                  label: const Text('Digital Card', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.japaniPhalDark,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () => DigitalMemberPassDialog.show(context, member),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.point_of_sale, size: 16),
                  label: const Text('Settle Fee', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.green600,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () => _showSettleFeeModal(member),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.upgrade, size: 16),
                  label: const Text('Upgrade', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () => _showUpgradePlanModal(member),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Membership Financial & Plan Details Card
          AppCard(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Membership & Billing Ledger', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    if (member.isDueSoon || member.dueAmount > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.red600.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'DUE: ${formatMoney(member.dueAmount > 0 ? member.dueAmount : member.monthlyFee)}',
                          style: const TextStyle(color: AppColors.red600, fontWeight: FontWeight.bold, fontSize: 10.5),
                        ),
                      ),
                  ],
                ),
                const Divider(height: 16),
                _buildDetailRow('Active Plan', member.planName),
                _buildDetailRow('Plan Duration', '${member.durationMonths} Months'),
                _buildDetailRow('Total Paid Fee', formatMoney(member.totalFeePaid)),
                _buildDetailRow('Fee Status', member.isOverdue ? '❌ OVERDUE' : (member.isDueSoon ? '⚠️ DUE SOON' : '✅ PAID IN FULL')),
                if (member.dueAmount > 0)
                  _buildDetailRow('Remaining Balance Due', formatMoney(member.dueAmount)),
                _buildDetailRow('Payment Mode', '${member.paymentMode} ${member.paymentRef != null ? "(${member.paymentRef})" : ""}'),
                if (member.cashTendered != null)
                  _buildDetailRow('Cash POS Settle', 'Rec: ${formatMoney(member.cashTendered!)} • Change: ${formatMoney(member.changeReturned ?? 0)}'),
                _buildDetailRow('Admission / Join Date', member.joinedDate),
                _buildDetailRow('Pass Expiration Date', member.expiryDate),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Health, Diet & Workout Profile Card
          AppCard(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Health, Diet & Fitness Profile', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    Icon(Icons.monitor_heart, color: AppColors.japaniPhalDark, size: 18),
                  ],
                ),
                const Divider(height: 16),
                _buildDetailRow('Fitness Goal', member.fitnessGoal),
                _buildDetailRow('Diet Preference', member.dietaryPreference),
                _buildDetailRow('Current Weight', '${member.currentWeightKg ?? 75.0} kg'),
                _buildDetailRow('Target Weight', '${member.targetWeightKg ?? 70.0} kg'),
                _buildDetailRow('Height', member.height ?? '5\'10"'),
                if (member.emergencyContactName != null)
                  _buildDetailRow('Emergency Contact', '${member.emergencyContactName} (${member.emergencyContactPhone ?? ""})'),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Status & Danger Actions
          AppCard(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Account Status Controls', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          final newSt = member.status == 'ACTIVE' ? 'FROZEN' : 'ACTIVE';
                          MembersController.instance.updateMemberStatus(member.id, newSt);
                          AppToast.showSuccess(context, 'Status Updated', 'Member is now $newSt.');
                        },
                        child: Text(member.status == 'ACTIVE' ? 'Freeze Member' : 'Activate Member', style: const TextStyle(fontSize: 11)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(foregroundColor: AppColors.red600),
                        onPressed: () {
                          MembersController.instance.deleteMember(member.id);
                          if (Navigator.canPop(context)) Navigator.pop(context);
                          AppToast.showSuccess(context, 'Member Removed', 'Member profile has been deleted.');
                        },
                        child: const Text('Delete Profile', style: TextStyle(fontSize: 11)),
                      ),
                    ),
                  ],
                ),
              ],
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
          Text(label, style: AppTypography.caption.copyWith(color: AppColors.stone500)),
          Text(value, style: AppTypography.caption.copyWith(fontWeight: FontWeight.bold, color: AppColors.stone900)),
        ],
      ),
    );
  }
}
