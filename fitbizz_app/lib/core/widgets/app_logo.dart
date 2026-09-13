import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// Reusable FitBizz Brand Logo Widget
/// Can be rendered as icon-only or with brand text/subtitle,
/// tailored for Light, Dark, Desktop Sidebar, Splash, and Header layouts.
class AppLogo extends StatelessWidget {
  final double size;
  final bool showText;
  final String title;
  final String? subtitle;
  final bool isDark;
  final bool hasGlow;
  final VoidCallback? onTap;

  const AppLogo({
    super.key,
    this.size = 36,
    this.showText = false,
    this.title = 'FitBizz',
    this.subtitle,
    this.isDark = false,
    this.hasGlow = false,
    this.onTap,
  });

  /// Factory for Large Splash Screen Logo
  const AppLogo.splash({
    super.key,
    this.size = 110,
    this.showText = true,
    this.title = 'FitBizz',
    this.subtitle = 'Multi-Tenant Fitness SaaS Platform',
    this.isDark = true,
    this.hasGlow = true,
    this.onTap,
  });

  /// Factory for Header / Navigation Bar Logo
  const AppLogo.nav({
    super.key,
    this.size = 36,
    this.showText = true,
    this.title = 'FitBizz',
    this.subtitle,
    this.isDark = false,
    this.hasGlow = false,
    this.onTap,
  });

  /// Factory for Desktop Sidebar Logo
  const AppLogo.sidebar({
    super.key,
    this.size = 38,
    this.showText = true,
    this.title = 'FitBizz SaaS',
    this.subtitle = 'Tenant: tenant-001',
    this.isDark = true,
    this.hasGlow = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final logoImage = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.24), // Squircle matching brand logo
        boxShadow: hasGlow
            ? [
                BoxShadow(
                  color: AppColors.japaniPhalDark.withValues(alpha: 0.45),
                  blurRadius: size * 0.4,
                  spreadRadius: size * 0.08,
                  offset: const Offset(0, 4),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size * 0.24),
        child: Image.asset(
          'assets/images/fitbizz_logo.png',
          width: size,
          height: size,
          fit: BoxFit.cover,
          filterQuality: FilterQuality.high,
          errorBuilder: (context, error, stackTrace) {
            // Fallback gracefully to brand colored container
            return Container(
              width: size,
              height: size,
              color: AppColors.japaniPhalDark,
              alignment: Alignment.center,
              child: Text(
                'FB',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: size * 0.42,
                  letterSpacing: -0.5,
                ),
              ),
            );
          },
        ),
      ),
    );

    if (!showText) {
      if (onTap != null) {
        return InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(size * 0.24),
          child: logoImage,
        );
      }
      return logoImage;
    }

    final content = Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        logoImage,
        const SizedBox(width: AppSpacing.sm),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: (size >= 60 ? AppTypography.h1 : AppTypography.h3).copyWith(
                color: isDark ? Colors.white : AppColors.stone900,
                letterSpacing: 0.3,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (subtitle != null && subtitle!.isNotEmpty) ...[
              const SizedBox(height: 2),
              Text(
                subtitle!,
                style: AppTypography.caption.copyWith(
                  color: isDark ? AppColors.stone500 : AppColors.stone500,
                  fontSize: size >= 60 ? 13 : 11,
                ),
              ),
            ],
          ],
        ),
      ],
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        child: content,
      );
    }

    return content;
  }
}
