import 'package:flutter/material.dart';

import '../../core/localization/app_locale.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_badge.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_stat_card.dart';
import '../../core/widgets/app_toast.dart';

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
  String _selectedBranch = 'Gulberg Main Arena (HQ)';

  final List<Map<String, dynamic>> _recentCheckIns = [
    {
      'id': 'MEM-1089',
      'name': 'Sarah Jenkins',
      'time': '2 mins ago',
      'branch': 'Gulberg Main Arena',
      'plan': 'Pro VIP',
      'status': 'ACTIVE',
      'method': 'QR Scan',
    },
    {
      'id': 'MEM-1042',
      'name': 'Michael Chang',
      'time': '8 mins ago',
      'branch': 'Gulberg Main Arena',
      'plan': 'Standard Monthly',
      'status': 'ACTIVE',
      'method': 'Biometric',
    },
    {
      'id': 'MEM-1033',
      'name': 'Hamza Ali',
      'time': '12 mins ago',
      'branch': 'DHA Phase 5 Arena',
      'plan': 'VIP Multi-Branch',
      'status': 'ACTIVE',
      'method': 'Biometric',
    },
    {
      'id': 'MEM-1011',
      'name': 'David Ross',
      'time': '24 mins ago',
      'branch': 'Gulberg Main Arena',
      'plan': 'Standard Monthly',
      'status': 'EXPIRED',
      'method': 'Manual Desk',
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

  void _sendWhatsAppReminder(Map<String, dynamic> item) {
    AppToast.showSuccess(
      context,
      tr('whatsapp_reminder'),
      '${item['name']} (${item['phone']})',
    );
  }

  void _showCollectFeeDialog(Map<String, dynamic> item) {
    final amountController = TextEditingController(text: (item['dueAmount'] as double).toInt().toString());
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.payment, color: AppColors.japaniPhalDark),
              const SizedBox(width: AppSpacing.sm),
              Text(tr('collect_payment'), style: AppTypography.h3),
            ],
          ),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Member: ${item['name']} (${item['id']})', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                Text('Plan: ${item['plan']}', style: const TextStyle(fontSize: 12, color: AppColors.stone500)),
                const SizedBox(height: AppSpacing.md),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: tr('collect'),
                    border: const OutlineInputBorder(),
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
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.japaniPhalDark, foregroundColor: Colors.white),
              onPressed: () {
                Navigator.pop(ctx);
                setState(() {
                  _pendingRenewals.removeWhere((r) => r['id'] == item['id']);
                });
                AppToast.showSuccess(
                  context,
                  tr('confirm'),
                  '${item['name']} - ${amountController.text}',
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

              // 2. Key Operational Metrics Grid (100% Translated)
              _buildMetricsGrid(isDesktop),

              const SizedBox(height: AppSpacing.lg),

              // 3. Multi-Branch Operations Bar
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
                  color: AppColors.japaniPhal.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.japaniPhal.withValues(alpha: 0.3)),
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
                      '${tr('welcome')}, Kamran Ahmed (Owner) • Gulberg & DHA Branches',
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
                        DropdownMenuItem(value: 'Gulberg Main Arena (HQ)', child: Text('🏢 Gulberg Main Arena (HQ)')),
                        DropdownMenuItem(value: 'DHA Phase 5 Arena', child: Text('🏢 DHA Phase 5 Arena')),
                        DropdownMenuItem(value: 'All Branches (Network View)', child: Text('🌐 All Branches (Network View)')),
                      ],
                      onChanged: (v) => setState(() => _selectedBranch = v ?? 'Gulberg Main Arena (HQ)'),
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
                  AppToast.showInfo(context, tr('dash_fee_ledger'), tr('bill_subtitle'));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 4 Key KPI Metrics Cards (Translated)
  Widget _buildMetricsGrid(bool isDesktop) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = isDesktop ? 4 : 2;
        return GridView.count(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: AppSpacing.md,
          mainAxisSpacing: AppSpacing.md,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: isDesktop ? 1.7 : 1.3,
          children: [
            AppStatCard(
              title: tr('stat_total_members'),
              value: '450',
              subtitle: tr('stat_total_members_sub'),
              icon: Icons.people_alt_outlined,
              iconColor: AppColors.japaniPhalDark,
            ),
            AppStatCard(
              title: tr('stat_today_checkins'),
              value: '128',
              subtitle: tr('stat_today_checkins_sub'),
              icon: Icons.qr_code_scanner,
              iconColor: AppColors.green600,
            ),
            AppStatCard(
              title: tr('stat_monthly_revenue'),
              value: formatMoney(385000),
              subtitle: tr('stat_monthly_revenue_sub'),
              icon: Icons.account_balance_wallet_outlined,
              iconColor: AppColors.japaniPhalDark,
            ),
            AppStatCard(
              title: tr('stat_sync_status'),
              value: '100% OK',
              subtitle: tr('stat_sync_status_sub'),
              icon: Icons.cloud_done_outlined,
              iconColor: AppColors.green600,
            ),
          ],
        );
      },
    );
  }

  /// Multi-Branch Health & Status Card
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
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.stone50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.stone200),
                  ),
                  child: Row(
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
                            Text('280 Members • Turnstile 1 & 2 Online', style: TextStyle(fontSize: 11, color: AppColors.stone500)),
                          ],
                        ),
                      ),
                      AppBadge(label: tr('live'), variant: AppBadgeVariant.active),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.stone50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.stone200),
                  ),
                  child: Row(
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
                            Text('170 Members • Reception Terminal Active', style: TextStyle(fontSize: 11, color: AppColors.stone500)),
                          ],
                        ),
                      ),
                      AppBadge(label: tr('live'), variant: AppBadgeVariant.active),
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
                            '${item['id']} • ${item['branch']} • ${item['plan']}',
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
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: AppColors.green600.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: AppColors.green600.withValues(alpha: 0.3)),
                                  ),
                                  child: Text('💬 ${tr("whatsapp_reminder")}', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.green600)),
                                ),
                              ),
                              const SizedBox(width: 4),
                              InkWell(
                                onTap: () => _showCollectFeeDialog(item),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
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
      ),
    );
  }
}
