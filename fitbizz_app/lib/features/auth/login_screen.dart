import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_logo.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/app_toast.dart';
import 'auth_state.dart';

class LoginScreen extends StatefulWidget {
  final AuthState authState;
  final VoidCallback onLoginSuccess;

  const LoginScreen({
    super.key,
    required this.authState,
    required this.onLoginSuccess,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _identifierController = TextEditingController(text: 'admin@fitbizz.com');
  final TextEditingController _passwordController = TextEditingController(text: 'password123');
  bool _obscurePassword = true;
  bool _rememberMe = true;
  bool _showDemoHelper = false;

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  IconData _getIdentifierIcon(String text) {
    final t = text.trim();
    if (t.contains('@')) return Icons.alternate_email;
    if (RegExp(r'^[0-9+\s-]+$').hasMatch(t) && t.isNotEmpty) return Icons.phone_android_outlined;
    return Icons.badge_outlined;
  }

  Future<void> _handleLogin() async {
    final success = await widget.authState.loginWithIdentifier(
      _identifierController.text.trim(),
      _passwordController.text.trim(),
    );
    if (success && mounted) {
      widget.onLoginSuccess();
    }
  }

  void _fillPreset(String id, String pwd) {
    setState(() {
      _identifierController.text = id;
      _passwordController.text = pwd;
    });
  }

  void _showForgotPasswordModal() {
    final resetController = TextEditingController(text: _identifierController.text);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusLg)),
          ),
          padding: EdgeInsets.only(
            left: AppSpacing.xl,
            right: AppSpacing.xl,
            top: AppSpacing.xl,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + AppSpacing.xl,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Password Recovery', style: AppTypography.h3),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Enter your registered Email, Phone Number, or Gym ID. We will send a secure verification code.',
                style: AppTypography.bodySecondary,
              ),
              const SizedBox(height: AppSpacing.lg),
              AppTextField(
                label: 'Registered Identifier',
                hint: 'e.g. owner@metrofitness.com or +92 300 1234567',
                controller: resetController,
                prefixIcon: const Icon(Icons.contact_mail_outlined, size: 18),
              ),
              const SizedBox(height: AppSpacing.lg),
              AppButton(
                label: 'Send Reset Instructions',
                fullWidth: true,
                onPressed: () {
                  Navigator.pop(ctx);
                  AppToast.showInfo(
                    context,
                    'Recovery Instructions Dispatched',
                    'OTP sent to ${resetController.text.trim()}. Contact Super Admin for direct access.',
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 950;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: isDesktop ? _buildDesktopLayout() : _buildMobileLayout(),
    );
  }

  /// Split Desktop & Web Showcase Layout
  Widget _buildDesktopLayout() {
    return Row(
      children: [
        // Left Column: Brand & Architecture Showcase
        Expanded(
          flex: 5,
          child: Container(
            color: AppColors.stone900,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl, vertical: AppSpacing.xl),
            child: Stack(
              children: [
                Positioned(
                  top: -80,
                  left: -80,
                  child: Container(
                    width: 320,
                    height: 320,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppColors.japaniPhal.withValues(alpha: 0.15),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AppLogo.sidebar(
                      size: 48,
                      title: 'FitBizz SaaS',
                      subtitle: 'Universal Multi-Tenant Fitness OS',
                    ),
                    const Spacer(),

                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.japaniPhal.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: AppColors.japaniPhal.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.japaniPhal),
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Text(
                            'UNIFIED SMART AUTHENTICATION',
                            style: AppTypography.caption.copyWith(
                              color: AppColors.japaniPhal,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'One Unified Portal.\nAutomatic Role Routing.',
                      style: AppTypography.h1.copyWith(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Super Admins, Gym Owners, Staff & Members log in seamlessly using their Email, Phone Number, or Unique ID.',
                      style: AppTypography.bodySecondary.copyWith(
                        color: AppColors.stone500,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: AppSpacing.xl),

                    _buildFeatureItem(Icons.auto_awesome_outlined, 'Automatic Role Detection', 'No manual role selection required. The engine identifies your permissions instantly.'),
                    _buildFeatureItem(Icons.offline_bolt_outlined, 'Offline-First SQLite Engine', 'Front desk & reception check-ins remain 100% operational offline.'),
                    _buildFeatureItem(Icons.shield_outlined, 'Tenant-Level Cryptographic Isolation', 'Multi-branch data security with isolated SQLite & cloud sync.'),

                    const Spacer(),

                    Row(
                      children: [
                        const Icon(Icons.check_circle, size: 14, color: AppColors.green600),
                        const SizedBox(width: 6),
                        Text(
                          'Cloud Services & PostgreSQL Engine Online',
                          style: AppTypography.caption.copyWith(color: AppColors.stone500, fontSize: 11),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // Right Column: Clean Unified Form Card
        Expanded(
          flex: 6,
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl, vertical: AppSpacing.xl),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 460),
                child: _buildAuthCard(isDesktop: true),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.darkSurfaceElevated,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              border: Border.all(color: AppColors.stone700.withValues(alpha: 0.3)),
            ),
            child: Icon(icon, color: AppColors.japaniPhal, size: 18),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.body.copyWith(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13),
                ),
                Text(
                  subtitle,
                  style: AppTypography.caption.copyWith(color: AppColors.stone500, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Responsive Mobile Layout
  Widget _buildMobileLayout() {
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Column(
              children: [
                const Center(
                  child: AppLogo(
                    size: 64,
                    hasGlow: true,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'FitBizz Portal',
                  style: AppTypography.h2.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Multi-Tenant Fitness Management Platform',
                  style: AppTypography.caption.copyWith(color: AppColors.stone500),
                ),
                const SizedBox(height: AppSpacing.xl),

                _buildAuthCard(isDesktop: false),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// The Single Unified Auth Card
  Widget _buildAuthCard({required bool isDesktop}) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: ListenableBuilder(
        listenable: widget.authState,
        builder: (context, _) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome Back',
                style: AppTypography.h2.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 2),
              Text(
                'Enter your registered Email, Phone, or ID to sign in.',
                style: AppTypography.bodySecondary.copyWith(fontSize: 13),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Error feedback
              if (widget.authState.error != null) ...[
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: AppColors.dangerBg,
                    border: Border.all(color: AppColors.dangerBorder),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, size: 16, color: AppColors.dangerText),
                      const SizedBox(width: AppSpacing.xs),
                      Expanded(
                        child: Text(
                          widget.authState.error!,
                          style: AppTypography.caption.copyWith(color: AppColors.dangerText),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
              ],

              // Universal Smart Identifier Field (Email / Phone / User ID / Gym ID)
              ListenableBuilder(
                listenable: _identifierController,
                builder: (context, _) {
                  return AppTextField(
                    label: 'Email, Phone, or User/Gym ID',
                    hint: 'e.g. owner@metrofitness.com, 03001234567, or SUPER-001',
                    controller: _identifierController,
                    prefixIcon: Icon(_getIdentifierIcon(_identifierController.text), size: 18),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.md),

              // Password
              AppTextField(
                label: 'Password',
                hint: '••••••••',
                controller: _passwordController,
                obscureText: _obscurePassword,
                prefixIcon: const Icon(Icons.lock_outline, size: 18),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                    size: 18,
                    color: AppColors.stone500,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
                onSubmitted: (_) => _handleLogin(),
              ),
              const SizedBox(height: AppSpacing.sm),

              // Remember Me & Forgot Password
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: Checkbox(
                          value: _rememberMe,
                          activeColor: AppColors.japaniPhalDark,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                          onChanged: (val) => setState(() => _rememberMe = val ?? true),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text('Remember session', style: AppTypography.caption),
                    ],
                  ),
                  TextButton(
                    onPressed: _showForgotPasswordModal,
                    child: Text(
                      'Forgot password?',
                      style: AppTypography.caption.copyWith(color: AppColors.japaniPhalDark, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              // Primary Sign In Button
              AppButton(
                label: 'Sign In',
                fullWidth: true,
                isLoading: widget.authState.isLoading,
                onPressed: _handleLogin,
              ),

              const SizedBox(height: AppSpacing.lg),

              // Testing helper expander
              InkWell(
                onTap: () => setState(() => _showDemoHelper = !_showDemoHelper),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.stone50,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    border: Border.all(color: AppColors.stone200),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.help_outline, size: 14, color: AppColors.stone700),
                          const SizedBox(width: 6),
                          Text(
                            'Testing Accounts & ID Reference',
                            style: AppTypography.caption.copyWith(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.stone700),
                          ),
                        ],
                      ),
                      Icon(
                        _showDemoHelper ? Icons.expand_less : Icons.expand_more,
                        size: 16,
                        color: AppColors.stone500,
                      ),
                    ],
                  ),
                ),
              ),

              if (_showDemoHelper) ...[
                const SizedBox(height: AppSpacing.sm),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    border: Border.all(color: AppColors.stone200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tap any account to auto-fill (Auto-detects role on Sign In):',
                        style: AppTypography.caption.copyWith(fontSize: 10, color: AppColors.stone500),
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: [
                          _buildQuickFillChip('Super Admin', 'admin@fitbizz.com', 'password123'),
                          _buildQuickFillChip('Gym Owner', 'owner@metrofitness.com', 'password123'),
                          _buildQuickFillChip('Reception', 'reception@fitbizz.com', 'password123'),
                          _buildQuickFillChip('Accountant', 'finance@metrofitness.com', 'password123'),
                          _buildQuickFillChip('Trainer', 'trainer@metrofitness.com', 'password123'),
                          _buildQuickFillChip('Member', 'member@customer.com', 'password123'),
                          _buildQuickFillChip('By Phone', '+923001234567', 'password123'),
                          _buildQuickFillChip('By ID (REC-101)', 'REC-101', 'password123'),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _buildQuickFillChip(String label, String id, String pwd) {
    return InkWell(
      onTap: () => _fillPreset(id, pwd),
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
        decoration: BoxDecoration(
          color: AppColors.stone50,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: AppColors.stone200),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.japaniPhalDark),
        ),
      ),
    );
  }
}
