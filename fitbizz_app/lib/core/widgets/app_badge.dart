import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

enum AppBadgeVariant { active, warning, danger, neutral }

class AppBadge extends StatelessWidget {
  final String label;
  final AppBadgeVariant variant;

  const AppBadge({
    super.key,
    required this.label,
    this.variant = AppBadgeVariant.active,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;

    switch (variant) {
      case AppBadgeVariant.active:
        bg = AppColors.green600.withValues(alpha: 0.1);
        fg = AppColors.green600;
        break;
      case AppBadgeVariant.warning:
        bg = AppColors.amber500.withValues(alpha: 0.1);
        fg = AppColors.amber500;
        break;
      case AppBadgeVariant.danger:
        bg = AppColors.red600.withValues(alpha: 0.1);
        fg = AppColors.red600;
        break;
      case AppBadgeVariant.neutral:
        bg = AppColors.slate500.withValues(alpha: 0.1);
        fg = AppColors.slate500;
        break;
    }

    return Container(
      constraints: const BoxConstraints(maxWidth: 180),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTypography.caption.copyWith(
          color: fg,
          fontWeight: FontWeight.w600,
          fontSize: 11,
        ),
      ),
    );
  }
}
