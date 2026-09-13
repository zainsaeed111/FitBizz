import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

enum AppButtonVariant { primary, secondary, text, danger }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final IconData? icon;
  final bool isLoading;
  final bool fullWidth;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.icon,
    this.isLoading = false,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    BorderSide border = BorderSide.none;

    switch (variant) {
      case AppButtonVariant.primary:
        bg = AppColors.primaryAction;
        fg = Colors.white;
        break;
      case AppButtonVariant.secondary:
        bg = AppColors.slate50;
        fg = AppColors.primaryText;
        border = const BorderSide(color: AppColors.border, width: 1);
        break;
      case AppButtonVariant.text:
        bg = Colors.transparent;
        fg = AppColors.primaryAction;
        break;
      case AppButtonVariant.danger:
        bg = AppColors.red600;
        fg = Colors.white;
        break;
    }

    Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading) ...[
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(fg),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
        ] else if (icon != null) ...[
          Icon(icon, size: 18, color: fg),
          const SizedBox(width: AppSpacing.sm),
        ],
        Text(
          label,
          style: AppTypography.button.copyWith(color: fg),
        ),
      ],
    );

    Widget btn = ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: bg,
        foregroundColor: fg,
        elevation: 0,
        minimumSize: const Size(88, 48), // Ensure min 48px touch target
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          side: border,
        ),
      ),
      onPressed: isLoading ? null : onPressed,
      child: content,
    );

    if (fullWidth) {
      return SizedBox(width: double.infinity, child: btn);
    }
    return btn;
  }
}
