import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/app_toast.dart';

class ReceptionScreen extends StatefulWidget {
  const ReceptionScreen({super.key});

  @override
  State<ReceptionScreen> createState() => _ReceptionScreenState();
}

class _ReceptionScreenState extends State<ReceptionScreen> {
  final _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  String? _lastMemberName;
  String? _lastMemberNumber;
  String? _checkInStatus; // 'SUCCESS', 'EXPIRED', 'DENIED'
  String? _statusMessage;
  final List<Map<String, String>> _recentCheckIns = [
    {'name': 'Alex Morgan', 'number': 'MEM-1004', 'time': 'Just now', 'status': 'SUCCESS'},
    {'name': 'Rachel Green', 'number': 'MEM-1015', 'time': '3 mins ago', 'status': 'SUCCESS'},
  ];

  void _processCheckIn(String query) {
    if (query.trim().isEmpty) return;

    final q = query.trim().toUpperCase();

    setState(() {
      _lastMemberNumber = q;
      if (q.contains('EXP') || q == 'MEM-9999') {
        _lastMemberName = 'Robert Taylor';
        _checkInStatus = 'EXPIRED';
        _statusMessage = 'Membership Expired on Sep 10, 2026. Renewal Required.';
        AppToast.showError(
          context,
          'Access Denied: Membership Expired',
          '$_lastMemberName ($q) requires renewal.',
        );
      } else {
        _lastMemberName = q == 'MEM-1001' ? 'John Doe' : 'Jane Smith ($q)';
        _checkInStatus = 'SUCCESS';
        _statusMessage = 'Access Granted. Active Premium Pass.';
        _recentCheckIns.insert(0, {
          'name': _lastMemberName!,
          'number': _lastMemberNumber!,
          'time': 'Just now',
          'status': 'SUCCESS',
        });
        AppToast.showSuccess(
          context,
          'Check-In Approved: $_lastMemberName',
          'Active Pass verified for $q',
        );
      }
    });

    _searchController.clear();
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 800;

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
                  Text('Reception Check-in Terminal', style: AppTypography.h1),
                  Text('Fast barcode scanning & member access point', style: AppTypography.bodySecondary),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.green600.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.wifi, size: 16, color: AppColors.green600),
                    const SizedBox(width: AppSpacing.xs),
                    Text('Offline Queue Ready', style: AppTypography.caption.copyWith(color: AppColors.green600, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // Main Terminal Interface
          Flex(
            direction: isDesktop ? Axis.horizontal : Axis.vertical,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left: Scanner Input & Active Banner
              Expanded(
                flex: isDesktop ? 3 : 0,
                child: Column(
                  children: [
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Scan Member QR Card / Roll Number', style: AppTypography.h3),
                          const SizedBox(height: AppSpacing.xs),
                          Text('Ready for optical QR camera scanners or Roll No search.', style: AppTypography.caption),
                          const SizedBox(height: AppSpacing.md),

                          Row(
                            children: [
                              Expanded(
                                child: AppTextField(
                                  label: '',
                                  hint: 'Scan QR payload or enter Roll No (e.g. PULSE-2026-1001)',
                                  controller: _searchController,
                                  prefixIcon: const Icon(Icons.qr_code_scanner, color: AppColors.japaniPhal),
                                  onSubmitted: _processCheckIn,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.md),
                              AppButton(
                                label: 'Verify & Check In',
                                icon: Icons.check_circle_outline,
                                onPressed: () => _processCheckIn(_searchController.text),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppSpacing.md),

                    // Visual Feedback Banner
                    if (_checkInStatus != null) ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        decoration: BoxDecoration(
                          color: _checkInStatus == 'SUCCESS'
                              ? AppColors.green600.withValues(alpha: 0.15)
                              : AppColors.red600.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                          border: Border.all(
                            color: _checkInStatus == 'SUCCESS' ? AppColors.green600 : AppColors.red600,
                            width: 2,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              _checkInStatus == 'SUCCESS' ? Icons.check_circle : Icons.warning_amber,
                              size: 48,
                              color: _checkInStatus == 'SUCCESS' ? AppColors.green600 : AppColors.red600,
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _lastMemberName ?? 'Unknown Member',
                                    style: AppTypography.h2,
                                  ),
                                  Text(
                                    'ID: $_lastMemberNumber',
                                    style: AppTypography.body.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(height: AppSpacing.xs),
                                  Text(
                                    _statusMessage ?? '',
                                    style: AppTypography.bodySecondary.copyWith(
                                      color: _checkInStatus == 'SUCCESS' ? AppColors.green600 : AppColors.red600,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              if (isDesktop) const SizedBox(width: AppSpacing.lg) else const SizedBox(height: AppSpacing.lg),

              // Right: Terminal Recent Check-in List
              Expanded(
                flex: isDesktop ? 2 : 0,
                child: AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Terminal Session Log', style: AppTypography.h3),
                      const SizedBox(height: AppSpacing.md),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _recentCheckIns.length,
                        separatorBuilder: (context, index) => const Divider(),
                        itemBuilder: (context, index) {
                          final item = _recentCheckIns[index];
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const CircleAvatar(
                              backgroundColor: AppColors.blue600,
                              child: Icon(Icons.person, color: Colors.white, size: 20),
                            ),
                            title: Text(item['name']!, style: AppTypography.body.copyWith(fontWeight: FontWeight.w600)),
                            subtitle: Text('${item['number']} • ${item['time']}', style: AppTypography.caption),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
                              decoration: BoxDecoration(
                                color: AppColors.green600.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                              ),
                              child: Text('VERIFIED', style: AppTypography.caption.copyWith(color: AppColors.green600, fontWeight: FontWeight.w600)),
                            ),
                          );
                        },
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
}
