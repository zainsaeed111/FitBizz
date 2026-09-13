import 'package:flutter/material.dart';

import '../../core/localization/app_locale.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_badge.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_stat_card.dart';
import '../../core/widgets/app_toast.dart';
import '../../core/utils/communication_launcher.dart';

class DashboardScreen extends StatefulWidget {
  final VoidCallback onNavigateToReception;
  final VoidCallback onNavigateToMembers;

  const DashboardScreen({
    super.key,
    required this.onNavigateToReception,
    required this.onNavigateToMembers,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _selectedBranch = 'All Branches (Network View)';

  final List<Map<String, dynamic>> _recentCheckIns = [
    {
      'id': 'MEM-1089',
      'name': 'Sarah Jenkins',
      'time': '2 mins ago',
      'branch': 'Gulberg Main Arena',
      'plan': 'Pro VIP Monthly',
      'status': 'ACTIVE',
      'method': 'QR Scan',
      'turnstile': 'Gate 01',
    },
    {
      'id': 'MEM-1042',
      'name': 'Michael Chang',
      'time': '8 mins ago',
      'branch': 'Gulberg Main Arena',
      'plan': 'Standard Monthly',
      'status': 'ACTIVE',
      'method': 'Biometric',
      'turnstile': 'Gate 02',
    },
    {
      'id': 'MEM-1033',
      'name': 'Hamza Ali',
      'time': '12 mins ago',
      'branch': 'DHA Phase 5 Arena',
      'plan': 'VIP All-Branch',
      'status': 'ACTIVE',
      'method': 'Biometric',
      'turnstile': 'Main Turnstile',
    },
    {
      'id': 'MEM-1011',
      'name': 'David Ross',
      'time': '24 mins ago',
      'branch': 'Gulberg Main Arena',
      'plan': 'Standard Monthly',
      'status': 'EXPIRED',
      'method': 'Desk Check-in',
      'turnstile': 'Front Reception',
    },
    {
      'id': 'MEM-1094',
      'name': 'Zainab Fatima',
      'time': '32 mins ago',
      'branch': 'DHA Phase 5 Arena',
      'plan': 'Executive Annual',
      'status': 'ACTIVE',
      'method': 'QR Scan',
      'turnstile': 'Gate 01',
    },
  ];

  final List<Map<String, dynamic>> _pendingRenewals = [
    {
      'id': 'MEM-1011',
      'name': 'David Ross',
      'phone': '+92 301 9876543',
      'dueAmount': 5000.0,
      'dueDate': 'Due Yesterday',
      'plan': 'Standard Monthly',
    },
    {
      'id': 'MEM-1055',
      'name': 'Areeba Khan',
      'phone': '+92 322 4567890',
      'dueAmount': 13500.0,
      'dueDate': 'Due in 2 days',
      'plan': 'Quarterly Pro',
    },
    {
      'id': 'MEM-1078',
      'name': 'Usman Tariq',
      'phone': '+92 333 1122334',
      'dueAmount': 5000.0,
      'dueDate': 'Due in 3 days',
      'plan': 'Standard Monthly',
    },
  ];

  void _sendWhatsAppReminder(Map<String, dynamic> item) async {
    final msg = 'Hello ${item['name']}, this is a friendly reminder from Metro Fitness Club regarding your ${item['plan']} renewal of ${formatMoney(item['dueAmount'] as double)} (${item['dueDate']}). Please contact reception to settle.';
    await CommunicationLauncher.sendWhatsApp(phone: item['phone'], message: msg);
    if (mounted) {
      AppToast.showSuccess(
        context,
        tr('whatsapp_reminder'),
        'Reminder dispatched to ${item['name']} (${item['phone']})',
      );
    }
  }

  void _showCollectFeeDialog(Map<String, dynamic> item) {
    final amountController = TextEditingController(text: (item['dueAmount'] as double).toInt().toString());
    showDialog(
      context: context,
      builder: (ctx) {
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
                child: const Icon(Icons.payment, color: AppColors.japaniPhalDark, size: 20),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(tr('collect_payment'), style: AppTypography.h3),
            ],
          ),
          content: SizedBox(
            width: 420,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.stone50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.stone200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          Text(item['id'], style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.japaniPhalDark)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text('Plan: ${item['plan']} • ${item['dueDate']}', style: const TextStyle(fontSize: 11.5, color: AppColors.stone600)),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: '${tr("collect")} Amount (${AppLocaleController.instance.currency})',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    prefixText: '${AppLocaleController.instance.currency} ',
                    isDense: true,
                  ),
                ),
              ],
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
                Navigator.pop(ctx);
                setState(() {
                  _pendingRenewals.removeWhere((r) => r['id'] == item['id']);
                });
                AppToast.showSuccess(
                  context,
                  'Fee Payment Recorded',
                  'Collected ${formatMoney(double.tryParse(amountController.text) ?? 0)} from ${item['name']}. Invoice generated.',
                );
              },
              child: Text(tr('confirm')),
            ),
          ],
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
        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Top Executive Banner & Tenant Header
              _buildExecutiveHeader(isDesktop),

              const SizedBox(height: AppSpacing.lg),

              // 2. Key Operational Metrics Grid (100% Overflow-Free)
              _buildMetricsGrid(isDesktop),

              const SizedBox(height: AppSpacing.lg),

              // 3. Multi-Branch Operations & Capacity Bar
              _buildBranchOperationsCard(isDesktop),

              const SizedBox(height: AppSpacing.lg),

              // 4. Two-Column Live Activity & Pending Renewals Grid
              if (isDesktop)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 6, child: _buildLiveCheckInStream()),
                    const SizedBox(width: AppSpacing.lg),
                    Expanded(flex: 5, child: _buildPendingRenewalsLedger()),
                  ],
                )
              else
                Column(
                  children: [
                    _buildLiveCheckInStream(),
                    const SizedBox(height: AppSpacing.lg),
                    _buildPendingRenewalsLedger(),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }

  /// Top Executive Header with Welcome & Quick Actions
  Widget _buildExecutiveHeader(bool isDesktop) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.stone200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.japaniPhal, AppColors.japaniPhalDark],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.japaniPhalDark.withValues(alpha: 0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text('🏋️', style: TextStyle(fontSize: 22)),
                ),
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
                            'Metro Fitness Club',
                            style: AppTypography.h2.copyWith(fontWeight: FontWeight.w900, color: AppColors.stone900),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.green600.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.green600.withValues(alpha: 0.3)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.circle, size: 6, color: AppColors.green600),
                              const SizedBox(width: 4),
                              Text(tr('active'), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.green600)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${tr('welcome')}, Kamran Ahmed (Owner) • 2 Branches Active • 450 Total Members',
                      style: AppTypography.caption.copyWith(color: AppColors.stone500, fontSize: 12),
                    ),
                  ],
                ),
              ),
              if (isDesktop) ...[
                // Branch Selector Dropdown Pill
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.stone50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.stone300),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedBranch,
                      isDense: true,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.stone800),
                      items: const [
                        DropdownMenuItem(value: 'All Branches (Network View)', child: Text('🌐 All Branches (Network View)')),
                        DropdownMenuItem(value: 'Gulberg Main Arena (HQ)', child: Text('🏢 Gulberg Main Arena (HQ)')),
                        DropdownMenuItem(value: 'DHA Phase 5 Arena', child: Text('🏢 DHA Phase 5 Arena')),
                      ],
                      onChanged: (v) => setState(() => _selectedBranch = v ?? 'All Branches (Network View)'),
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          const Divider(color: AppColors.stone200, height: 1),
          const SizedBox(height: AppSpacing.md),

          // Action Shortcuts Row (Translated)
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.japaniPhalDark,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                ),
                icon: const Icon(Icons.person_add, size: 16),
                label: Text(tr('dash_enroll_member'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                onPressed: widget.onNavigateToMembers,
              ),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.stone800,
                  side: const BorderSide(color: AppColors.stone300),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                icon: const Icon(Icons.qr_code_scanner, size: 16, color: AppColors.japaniPhalDark),
                label: Text(tr('dash_reception_terminal'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                onPressed: widget.onNavigateToReception,
              ),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.stone800,
                  side: const BorderSide(color: AppColors.stone300),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                icon: const Icon(Icons.receipt_long, size: 16, color: AppColors.green600),
                label: Text(tr('dash_fee_ledger'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                onPressed: () {
                  AppToast.showInfo(context, tr('dash_fee_ledger'), 'Opening ledger with ₨385,000 collected & 3 pending invoices.');
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 4 Key KPI Metrics Cards (Zero-Overflow Protected)
  Widget _buildMetricsGrid(bool isDesktop) {
    final c1 = AppStatCard(
      title: tr('stat_total_members'),
      value: '450',
      subtitle: 'Gulberg: 280 • DHA: 170',
      trend: '+18 this wk',
      isPositiveTrend: true,
      icon: Icons.people_alt_outlined,
      iconColor: AppColors.japaniPhalDark,
      onTap: widget.onNavigateToMembers,
    );

    final c2 = AppStatCard(
      title: tr('stat_today_checkins'),
      value: '128',
      subtitle: 'Peak: 6:00 PM • 23 in gym now',
      trend: '● Live Pulse',
      isPositiveTrend: true,
      icon: Icons.qr_code_scanner,
      iconColor: AppColors.green600,
      onTap: widget.onNavigateToReception,
    );

    final c3 = AppStatCard(
      title: tr('stat_monthly_revenue'),
      value: formatMoney(385000),
      subtitle: 'Total: ${formatMoney(410000)} • 6 Due',
      trend: '94% Collected',
      isPositiveTrend: true,
      icon: Icons.account_balance_wallet_outlined,
      iconColor: AppColors.japaniPhalDark,
    );

    final c4 = AppStatCard(
      title: tr('stat_sync_status'),
      value: '100% OK',
      subtitle: '2 Turnstiles Online • SQLite Sync',
      trend: '⚡ 0ms Latency',
      isPositiveTrend: true,
      icon: Icons.cloud_done_outlined,
      iconColor: AppColors.green600,
    );

    if (isDesktop) {
      return Row(
        children: [
          Expanded(child: c1),
          const SizedBox(width: AppSpacing.md),
          Expanded(child: c2),
          const SizedBox(width: AppSpacing.md),
          Expanded(child: c3),
          const SizedBox(width: AppSpacing.md),
          Expanded(child: c4),
        ],
      );
    }

    return Column(
      children: [
        Row(
          children: [
            Expanded(child: c1),
            const SizedBox(width: AppSpacing.md),
            Expanded(child: c2),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(child: c3),
            const SizedBox(width: AppSpacing.md),
            Expanded(child: c4),
          ],
        ),
      ],
    );
  }

  /// Multi-Branch Health & Status Card with Capacity Meters
  Widget _buildBranchOperationsCard(bool isDesktop) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.stone200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.hub_outlined, size: 18, color: AppColors.japaniPhalDark),
                  const SizedBox(width: 8),
                  Text(tr('branch_network_health'), style: AppTypography.h3),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.stone100,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(tr('branches_deployed'), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.stone700)),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Flex(
            direction: isDesktop ? Axis.horizontal : Axis.vertical,
            children: [
              // Branch 1: Gulberg HQ
              Expanded(
                flex: isDesktop ? 1 : 0,
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.stone50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.stone200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.japaniPhal.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.fitness_center, size: 18, color: AppColors.japaniPhalDark),
                          ),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Gulberg Main Arena (HQ)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                Text('Turnstiles 1 & 2 Online • Biometric Sync OK', style: TextStyle(fontSize: 11, color: AppColors.stone500)),
                              ],
                            ),
                          ),
                          AppBadge(label: tr('live'), variant: AppBadgeVariant.active),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Capacity: 280 / 300 Members', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: AppColors.stone700)),
                          Text('93.3%', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: AppColors.green600)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: const LinearProgressIndicator(
                          value: 0.933,
                          minHeight: 6,
                          backgroundColor: AppColors.stone200,
                          valueColor: AlwaysStoppedAnimation<Color>(AppColors.green600),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Monthly Revenue: ${formatMoney(245000)}', style: const TextStyle(fontSize: 11, color: AppColors.stone500, fontWeight: FontWeight.w600)),
                          const Text('86 Today Visits', style: TextStyle(fontSize: 11, color: AppColors.japaniPhalDark, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              if (isDesktop) const SizedBox(width: AppSpacing.md) else const SizedBox(height: AppSpacing.md),

              // Branch 2: DHA Phase 5
              Expanded(
                flex: isDesktop ? 1 : 0,
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.stone50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.stone200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.japaniPhal.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.store, size: 18, color: AppColors.japaniPhalDark),
                          ),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('DHA Phase 5 Arena', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                Text('Reception Terminal Active • Camera Optical OK', style: TextStyle(fontSize: 11, color: AppColors.stone500)),
                              ],
                            ),
                          ),
                          AppBadge(label: tr('live'), variant: AppBadgeVariant.active),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Capacity: 170 / 250 Members', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: AppColors.stone700)),
                          const Text('68.0%', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: AppColors.japaniPhalDark)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: const LinearProgressIndicator(
                          value: 0.68,
                          minHeight: 6,
                          backgroundColor: AppColors.stone200,
                          valueColor: AlwaysStoppedAnimation<Color>(AppColors.japaniPhalDark),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Monthly Revenue: ${formatMoney(140000)}', style: const TextStyle(fontSize: 11, color: AppColors.stone500, fontWeight: FontWeight.w600)),
                          const Text('42 Today Visits', style: TextStyle(fontSize: 11, color: AppColors.japaniPhalDark, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Live Member Attendance Feed
  Widget _buildLiveCheckInStream() {
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.sensors, size: 18, color: AppColors.green600),
                  const SizedBox(width: 8),
                  Text(tr('realtime_attendance_feed'), style: AppTypography.h3),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.green600.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(tr('live_pulse'), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.green600)),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          const Divider(color: AppColors.stone200),
          const SizedBox(height: AppSpacing.xs),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _recentCheckIns.length,
            separatorBuilder: (context, index) => const Divider(color: AppColors.stone100, height: 1),
            itemBuilder: (context, index) {
              final item = _recentCheckIns[index];
              final isExpired = item['status'] == 'EXPIRED';

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: isExpired ? AppColors.dangerBg : AppColors.stone100,
                      child: Text(
                        (item['name'] as String).substring(0, 1),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: isExpired ? AppColors.dangerText : AppColors.stone800,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                decoration: BoxDecoration(
                                  color: AppColors.stone100,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(item['method'], style: const TextStyle(fontSize: 9.5, color: AppColors.stone600, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                          Text(
                            '${item['id']} • ${item['branch']} • ${item['turnstile'] ?? "Main Gate"}',
                            style: const TextStyle(fontSize: 11, color: AppColors.stone500),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(item['time'], style: const TextStyle(fontSize: 11, color: AppColors.stone400, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 2),
                        AppBadge(
                          label: item['status'],
                          variant: isExpired ? AppBadgeVariant.danger : AppBadgeVariant.active,
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
    );
  }

  /// Pending Renewals & Fee Recovery Hub
  Widget _buildPendingRenewalsLedger() {
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.notification_important_outlined, size: 18, color: AppColors.warningText),
                  const SizedBox(width: 8),
                  Text(tr('fee_renewals_dues'), style: AppTypography.h3),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.warningBg,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text('${_pendingRenewals.length} Pending', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.warningText)),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          const Divider(color: AppColors.stone200),
          const SizedBox(height: AppSpacing.xs),
          if (_pendingRenewals.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Text(tr('all_dues_collected'), style: const TextStyle(color: AppColors.green600, fontWeight: FontWeight.bold, fontSize: 13)),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _pendingRenewals.length,
              separatorBuilder: (context, index) => const Divider(color: AppColors.stone100, height: 1),
              itemBuilder: (context, index) {
                final item = _pendingRenewals[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                            Text('${item['plan']} • ${item['dueDate']}', style: const TextStyle(fontSize: 11, color: AppColors.warningText, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(formatMoney(item['dueAmount'] as double), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: AppColors.stone900)),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              InkWell(
                                onTap: () => _sendWhatsAppReminder(item),
                                borderRadius: BorderRadius.circular(4),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF25D366).withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: const Color(0xFF25D366).withValues(alpha: 0.3)),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.chat, size: 11, color: Color(0xFF25D366)),
                                      const SizedBox(width: 3),
                                      Text(tr('whatsapp_reminder'), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF25D366))),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 4),
                              InkWell(
                                onTap: () => _showCollectFeeDialog(item),
                                borderRadius: BorderRadius.circular(4),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: AppColors.japaniPhalDark,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(tr('collect'), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
  }
}
