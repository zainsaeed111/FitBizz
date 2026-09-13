import 'package:flutter/material.dart';

import '../../core/localization/app_locale.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_badge.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_stat_card.dart';
import '../../core/widgets/app_text_field.dart';

class BillingScreen extends StatefulWidget {
  const BillingScreen({super.key});

  @override
  State<BillingScreen> createState() => _BillingScreenState();
}

class _BillingScreenState extends State<BillingScreen> {
  final List<Map<String, dynamic>> _invoices = [
    {
      'id': 'INV-2026-001',
      'member': 'John Doe (MEM-1001)',
      'plan': 'All-Access Monthly Membership',
      'amount': '\$99.00',
      'tax': '\$9.90',
      'status': 'PAID',
      'date': 'Sep 01, 2026',
      'method': 'Credit Card',
    },
    {
      'id': 'INV-2026-002',
      'member': 'Jane Smith (MEM-1002)',
      'plan': 'VIP Annual Pass',
      'amount': '\$899.00',
      'tax': '\$89.90',
      'status': 'PAID',
      'date': 'Sep 05, 2026',
      'method': 'Bank Transfer',
    },
    {
      'id': 'INV-2026-003',
      'member': 'Robert Taylor (MEM-1003)',
      'plan': 'Basic Monthly Pass',
      'amount': '\$49.00',
      'tax': '\$4.90',
      'status': 'OVERDUE',
      'date': 'Aug 15, 2026',
      'method': 'Unpaid',
    },
  ];

  void _showCreateInvoiceModal() {
    final memberController = TextEditingController();
    final amountController = TextEditingController(text: '99.00');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusMd)),
          title: Text('Generate Invoice / Record Payment', style: AppTypography.h2),
          content: SizedBox(
            width: 480,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppTextField(label: 'Member ID or Name', hint: 'e.g. John Doe (MEM-1001)', controller: memberController),
                const SizedBox(height: AppSpacing.md),
                AppTextField(label: 'Amount (\$)', hint: '99.00', controller: amountController, keyboardType: TextInputType.number),
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
              label: 'Issue Invoice',
              onPressed: () {
                if (memberController.text.isNotEmpty) {
                  setState(() {
                    _invoices.insert(0, {
                      'id': 'INV-2026-00${_invoices.length + 1}',
                      'member': memberController.text.trim(),
                      'plan': 'Monthly Membership',
                      'amount': '\$${amountController.text.trim()}',
                      'tax': '\$9.90',
                      'status': 'PAID',
                      'date': 'Today',
                      'method': 'Cash',
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
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 800;

    return ListenableBuilder(
      listenable: AppLocaleController.instance,
      builder: (context, _) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(tr('bill_title'), style: AppTypography.h1),
                      Text(tr('bill_subtitle'), style: AppTypography.bodySecondary),
                    ],
                  ),
                  AppButton(
                    label: tr('bill_collect_fee'),
                    icon: Icons.receipt_long_outlined,
                    onPressed: _showCreateInvoiceModal,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),

              // KPI Metric Cards
              LayoutBuilder(
                builder: (context, constraints) {
                  final crossAxisCount = isDesktop ? 3 : 1;
                  return GridView.count(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: AppSpacing.md,
                    mainAxisSpacing: AppSpacing.md,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    childAspectRatio: isDesktop ? 2.2 : 2.5,
                    children: [
                      AppStatCard(
                        title: tr('bill_total_collected'),
                        value: formatMoney(48920),
                        subtitle: '342 invoices',
                        icon: Icons.account_balance_wallet_outlined,
                        iconColor: AppColors.blue600,
                      ),
                      AppStatCard(
                        title: tr('stat_monthly_revenue'),
                        value: formatMoney(44120),
                        subtitle: '90.2% collection rate',
                        icon: Icons.check_circle_outline,
                        iconColor: AppColors.green600,
                      ),
                      AppStatCard(
                        title: tr('bill_pending_dues'),
                        value: formatMoney(4800),
                        subtitle: '12 accounts pending',
                        icon: Icons.warning_amber_outlined,
                        iconColor: AppColors.red600,
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: AppSpacing.xl),

              // Invoice Ledger Table
              AppCard(
                padding: EdgeInsets.zero,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Text('Invoice Transactions Ledger', style: AppTypography.h3),
                    ),
                    const Divider(height: 1),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _invoices.length,
                      separatorBuilder: (context, index) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final item = _invoices[index];
                        final isPaid = item['status'] == 'PAID';

                        return ListTile(
                          contentPadding: const EdgeInsets.all(AppSpacing.md),
                          leading: CircleAvatar(
                            backgroundColor: isPaid ? AppColors.green600.withValues(alpha: 0.1) : AppColors.red600.withValues(alpha: 0.1),
                            child: Icon(
                              isPaid ? Icons.receipt_outlined : Icons.priority_high,
                              color: isPaid ? AppColors.green600 : AppColors.red600,
                              size: 20,
                            ),
                          ),
                          title: Row(
                            children: [
                              Text(item['id']!, style: AppTypography.body.copyWith(fontWeight: FontWeight.w600)),
                              const SizedBox(width: AppSpacing.sm),
                              AppBadge(
                                label: item['status']!,
                                variant: isPaid ? AppBadgeVariant.active : AppBadgeVariant.danger,
                              ),
                            ],
                          ),
                          subtitle: Text(
                            'Member: ${item['member']} • Plan: ${item['plan']} • Method: ${item['method']}',
                            style: AppTypography.caption,
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(item['amount']!, style: AppTypography.body.copyWith(fontWeight: FontWeight.w700)),
                              Text('Date: ${item['date']}', style: AppTypography.caption),
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
      },
    );
  }
}
