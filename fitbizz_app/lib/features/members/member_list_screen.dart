import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_badge.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_text_field.dart';

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

    String selectedTier = 'MONTHLY_STANDARD';
    String paymentMode = 'CASH';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final double fee = selectedTier == 'YEARLY_VIP'
                ? 48000.0
                : (selectedTier == 'QUARTERLY_PRO' ? 13500.0 : 5000.0);

            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusMd)),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Admit New Gym Member', style: AppTypography.h2),
                  Text('Configure membership plan, CNIC, and fee status', style: AppTypography.caption),
                ],
              ),
              content: SizedBox(
                width: 520,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppTextField(label: 'Member Full Name *', hint: 'e.g. Usman Ali', controller: nameController),
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

                      Text('Choose Membership Tier:', style: AppTypography.body.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: AppSpacing.xs),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          ChoiceChip(
                            label: const Text('Monthly (5k)'),
                            selected: selectedTier == 'MONTHLY_STANDARD',
                            selectedColor: AppColors.japaniPhal,
                            labelStyle: TextStyle(color: selectedTier == 'MONTHLY_STANDARD' ? Colors.white : AppColors.primaryText),
                            onSelected: (_) => setModalState(() => selectedTier = 'MONTHLY_STANDARD'),
                          ),
                          ChoiceChip(
                            label: const Text('Quarterly (13.5k)'),
                            selected: selectedTier == 'QUARTERLY_PRO',
                            selectedColor: AppColors.japaniPhal,
                            labelStyle: TextStyle(color: selectedTier == 'QUARTERLY_PRO' ? Colors.white : AppColors.primaryText),
                            onSelected: (_) => setModalState(() => selectedTier = 'QUARTERLY_PRO'),
                          ),
                          ChoiceChip(
                            label: const Text('Yearly VIP (48k)'),
                            selected: selectedTier == 'YEARLY_VIP',
                            selectedColor: AppColors.japaniPhal,
                            labelStyle: TextStyle(color: selectedTier == 'YEARLY_VIP' ? Colors.white : AppColors.primaryText),
                            onSelected: (_) => setModalState(() => selectedTier = 'YEARLY_VIP'),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),

                      Text('Fee Payment Mode (Total: PKR ${fee.toStringAsFixed(0)}):', style: AppTypography.body.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: AppSpacing.xs),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          ChoiceChip(
                            label: const Text('💵 Cash Payment'),
                            selected: paymentMode == 'CASH',
                            selectedColor: AppColors.green600,
                            labelStyle: TextStyle(color: paymentMode == 'CASH' ? Colors.white : AppColors.primaryText),
                            onSelected: (_) => setModalState(() => paymentMode = 'CASH'),
                          ),
                          ChoiceChip(
                            label: const Text('💳 Online Transfer'),
                            selected: paymentMode == 'ONLINE',
                            selectedColor: AppColors.japaniPhalDark,
                            labelStyle: TextStyle(color: paymentMode == 'ONLINE' ? Colors.white : AppColors.primaryText),
                            onSelected: (_) => setModalState(() => paymentMode = 'ONLINE'),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      if (paymentMode == 'ONLINE')
                        AppTextField(label: 'Online Transaction Ref ID', hint: 'TRX-9823471', controller: refController),
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
                    if (nameController.text.isNotEmpty) {
                      final rollNum = 'PULSE-2026-${1001 + _members.length}';
                      setState(() {
                        _members.insert(0, {
                          'id': 'mem_${DateTime.now().millisecondsSinceEpoch}',
                          'number': rollNum,
                          'name': nameController.text.trim(),
                          'email': 'member@gym.com',
                          'phone': phoneController.text.trim(),
                          'cnic': cnicController.text.trim(),
                          'dob': dobController.text.trim(),
                          'status': 'ACTIVE',
                          'plan': selectedTier.replaceAll('_', ' '),
                          'joined': 'Today',
                          'expires': selectedTier == 'YEARLY_VIP' ? '1 Year' : '1 Month',
                          'checkIns': '0 Visits',
                          'payment': paymentMode,
                        });
                      });
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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 900;

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
                  Text('Member Directory', style: AppTypography.h1),
                  Text('High-density operational member database & status tracking', style: AppTypography.bodySecondary),
                ],
              ),
              AppButton(
                label: 'Add Member',
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
                  hint: 'Search by member name, ID, or phone...',
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
                  'Showing ${filtered.length} of ${_members.length} Members',
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
