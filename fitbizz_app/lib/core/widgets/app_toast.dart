import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

enum ToastType { success, error, warning, info, sync }

/// Ultra-Modern Adaptive Toast & Notification System
/// Desktop/Web: Floats elegantly at Top-Right with subtle entrance and Japani Phal accent
/// Mobile: Floats smoothly at Top or Bottom with responsive margins, swipe dismiss & high contrast
class AppToast {
  static void show(
    BuildContext context, {
    required String title,
    String? message,
    ToastType type = ToastType.info,
    Duration duration = const Duration(milliseconds: 3500),
    VoidCallback? onAction,
    String? actionLabel,
    bool isTopOnMobile = true,
  }) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    final isDesktop = screenWidth > 750;

    final Color bgColor;
    final Color borderColor;
    final Color iconColor;
    final Color titleColor;
    final IconData icon;

    switch (type) {
      case ToastType.success:
        bgColor = const Color(0xFF0D2818);
        borderColor = const Color(0xFF22C55E);
        iconColor = const Color(0xFF4ADE80);
        titleColor = Colors.white;
        icon = Icons.check_circle_rounded;
        break;
      case ToastType.error:
        bgColor = const Color(0xFF2E0F14);
        borderColor = const Color(0xFFEF4444);
        iconColor = const Color(0xFFF87171);
        titleColor = Colors.white;
        icon = Icons.error_rounded;
        break;
      case ToastType.warning:
        bgColor = const Color(0xFF2E1C0A);
        borderColor = const Color(0xFFF59E0B);
        iconColor = const Color(0xFFFBBF24);
        titleColor = Colors.white;
        icon = Icons.warning_amber_rounded;
        break;
      case ToastType.sync:
        bgColor = const Color(0xFF241407);
        borderColor = AppColors.japaniPhalDark;
        iconColor = AppColors.japaniPhal;
        titleColor = Colors.white;
        icon = Icons.sync_rounded;
        break;
      case ToastType.info:
        bgColor = const Color(0xFF1C1917);
        borderColor = AppColors.stone700;
        iconColor = AppColors.japaniPhal;
        titleColor = Colors.white;
        icon = Icons.info_rounded;
        break;
    }

    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;

    messenger.hideCurrentSnackBar();

    // Desktop: Top Right placement
    // Mobile: Top floating or Bottom floating placement
    final double bottomMargin;
    final double leftMargin;
    final double rightMargin;

    if (isDesktop) {
      bottomMargin = screenHeight - (mediaQuery.padding.top + 100);
      leftMargin = screenWidth - 420;
      rightMargin = 24;
    } else {
      bottomMargin = isTopOnMobile ? (screenHeight - (mediaQuery.padding.top + 110)) : 16;
      leftMargin = 16;
      rightMargin = 16;
    }

    messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        backgroundColor: Colors.transparent,
        duration: duration,
        margin: EdgeInsets.only(
          bottom: bottomMargin > 0 ? bottomMargin : 16,
          left: leftMargin > 0 ? leftMargin : 16,
          right: rightMargin,
        ),
        padding: EdgeInsets.zero,
        content: Material(
          color: Colors.transparent,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 420),
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 12),
            decoration: BoxDecoration(
              color: bgColor.withValues(alpha: 0.96),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              border: Border.all(color: borderColor.withValues(alpha: 0.7), width: 1.3),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.45),
                  blurRadius: 20,
                  spreadRadius: 2,
                  offset: const Offset(0, 8),
                ),
                BoxShadow(
                  color: borderColor.withValues(alpha: 0.15),
                  blurRadius: 10,
                  spreadRadius: 0,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: iconColor.withValues(alpha: 0.18),
                  ),
                  child: Icon(icon, color: iconColor, size: 20),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTypography.body.copyWith(
                          color: titleColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                      if (message != null && message.isNotEmpty) ...[
                        const SizedBox(height: 3),
                        Text(
                          message,
                          style: AppTypography.caption.copyWith(
                            color: AppColors.stone300,
                            fontSize: 11,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (actionLabel != null && onAction != null) ...[
                  const SizedBox(width: 8),
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: () {
                      messenger.hideCurrentSnackBar();
                      onAction();
                    },
                    child: Text(
                      actionLabel,
                      style: TextStyle(color: iconColor, fontWeight: FontWeight.bold, fontSize: 11),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  static void showSuccess(BuildContext context, String title, [String? message]) {
    show(context, title: title, message: message, type: ToastType.success);
  }

  static void showError(BuildContext context, String title, [String? message]) {
    show(context, title: title, message: message, type: ToastType.error);
  }

  static void showWarning(BuildContext context, String title, [String? message]) {
    show(context, title: title, message: message, type: ToastType.warning);
  }

  static void showSync(BuildContext context, String title, [String? message]) {
    show(context, title: title, message: message, type: ToastType.sync);
  }

  static void showInfo(BuildContext context, String title, [String? message]) {
    show(context, title: title, message: message, type: ToastType.info);
  }
}
