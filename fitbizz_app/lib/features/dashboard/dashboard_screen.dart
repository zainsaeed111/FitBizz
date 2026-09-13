import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_stat_card.dart';

class DashboardScreen extends StatelessWidget {
  final VoidCallback onNavigateToReception;
  final VoidCallback onNavigateToMembers;

  const DashboardScreen({
    super.key,
    required this.onNavigateToReception,
    required this.onNavigateToMembers,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 900;

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
                  Text('Executive Dashboard', style: AppTypography.h1),
                  Text('Live tenant analytics & operational status', style: AppTypography.bodySecondary),
                ],
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 18, color: AppColors.slate700),
                        const SizedBox(width: AppSpacing.xs),
                        Text('Main Branch', style: AppTypography.body.copyWith(fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // KPI Metric Cards Grid (Clean Icons without colored container boxes)
          LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = isDesktop ? 4 : (screenWidth > 600 ? 2 : 1);
              return GridView.count(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: AppSpacing.md,
                mainAxisSpacing: AppSpacing.md,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: isDesktop ? 1.6 : 2.2,
                children: const [
                  AppStatCard(
                    title: 'Active Members',
                    value: '1,248',
                    subtitle: '+12% this month',
                    icon: Icons.people_outline,
                    iconColor: AppColors.slate700,
                  ),
                  AppStatCard(
                    title: 'Today Check-ins',
                    value: '142',
                    subtitle: 'Peak time: 5:00 PM',
                    icon: Icons.qr_code_scanner,
                    iconColor: AppColors.slate700,
                  ),
                  AppStatCard(
                    title: 'Expiring Memberships',
                    value: '18',
                    subtitle: 'Requires renewal follow-up',
                    icon: Icons.warning_amber_outlined,
                    iconColor: AppColors.warningText,
                  ),
                  AppStatCard(
                    title: 'Monthly Revenue',
                    value: '\$42,850',
                    subtitle: 'Target: \$45,000',
                    icon: Icons.payments_outlined,
                    iconColor: AppColors.slate700,
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: AppSpacing.xl),

          // Quick Action Cards & Operational Feed
          Flex(
            direction: isDesktop ? Axis.horizontal : Axis.vertical,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Column: Quick Actions (No forced colored icon circles)
              Expanded(
                flex: isDesktop ? 1 : 0,
                child: AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Reception Quick Actions', style: AppTypography.h3),
                      const SizedBox(height: AppSpacing.md),
                      ListTile(
                        leading: const Icon(Icons.qr_code_scanner, color: AppColors.slate700, size: 22),
                        title: Text('Open Reception Check-in Terminal', style: AppTypography.body.copyWith(fontWeight: FontWeight.w600)),
                        subtitle: Text('Fast barcode scanner & search terminal', style: AppTypography.caption),
                        trailing: const Icon(Icons.chevron_right, color: AppColors.slate500),
                        onTap: onNavigateToReception,
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.person_add_outlined, color: AppColors.slate700, size: 22),
                        title: Text('Register New Gym Member', style: AppTypography.body.copyWith(fontWeight: FontWeight.w600)),
                        subtitle: Text('Offline-capable member enrollment', style: AppTypography.caption),
                        trailing: const Icon(Icons.chevron_right, color: AppColors.slate500),
                        onTap: onNavigateToMembers,
                      ),
                    ],
                  ),
                ),
              ),

              if (isDesktop) const SizedBox(width: AppSpacing.lg) else const SizedBox(height: AppSpacing.lg),

              // Right Column: Live Check-in Stream
              Expanded(
                flex: isDesktop ? 1 : 0,
                child: AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Recent Check-ins', style: AppTypography.h3),
                          Text('Live Feed', style: AppTypography.caption.copyWith(color: AppColors.successText, fontWeight: FontWeight.w600)),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _buildCheckInTile('MEM-1089', 'Sarah Jenkins', '2 mins ago', 'ACTIVE', AppColors.successText, AppColors.successBg),
                      const Divider(),
                      _buildCheckInTile('MEM-1042', 'Michael Chang', '8 mins ago', 'ACTIVE', AppColors.successText, AppColors.successBg),
                      const Divider(),
                      _buildCheckInTile('MEM-1011', 'David Ross', '15 mins ago', 'EXPIRED (Warning)', AppColors.warningText, AppColors.warningBg),
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

  Widget _buildCheckInTile(String id, String name, String time, String status, Color textColor, Color bgColor) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: AppColors.slate900,
        child: Text(name[0], style: AppTypography.body.copyWith(fontWeight: FontWeight.bold, color: Colors.white)),
      ),
      title: Text(name, style: AppTypography.body.copyWith(fontWeight: FontWeight.w600)),
      subtitle: Text('ID: $id • Check-in: $time', style: AppTypography.caption),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        ),
        child: Text(
          status,
          style: AppTypography.caption.copyWith(color: textColor, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
