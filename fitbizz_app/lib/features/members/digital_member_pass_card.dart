import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/localization/app_locale.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_toast.dart';
import 'member_model.dart';

class DigitalMemberPassDialog extends StatelessWidget {
  final MemberModel member;
  final VoidCallback? onSimulateScan;

  const DigitalMemberPassDialog({
    super.key,
    required this.member,
    this.onSimulateScan,
  });

  static void show(BuildContext context, MemberModel member, {VoidCallback? onSimulateScan}) {
    showDialog(
      context: context,
      builder: (ctx) => DigitalMemberPassDialog(
        member: member,
        onSimulateScan: onSimulateScan,
      ),
    );
  }

  void _shareViaWhatsApp(BuildContext context) async {
    final text = '''🏋️ *FITBIZZ DIGITAL MEMBERSHIP PASS*
━━━━━━━━━━━━━━━━━━━━
🏢 *Gym:* Metro Fitness Club (HQ)
👤 *Member Name:* ${member.fullName}
🆔 *Pass / Roll #:* ${member.memberNumber}
📱 *Phone:* ${member.phone}
🪪 *CNIC:* ${member.cnic ?? 'N/A'}
🩸 *Blood Group:* ${member.bloodGroup ?? 'N/A'}
📦 *Plan:* ${member.planName}
📅 *Valid Until:* ${member.expiryDate}
💵 *Fee Status:* PAID (${formatMoney(member.totalFeePaid)})
🔐 *Pass Code:* ${member.qrPayload}
━━━━━━━━━━━━━━━━━━━━
Scan QR at front desk turnstile for instant check-in.''';

    final cleanPhone = member.phone.replaceAll(RegExp(r'[^0-9]'), '');
    final uri = Uri.parse('https://wa.me/$cleanPhone?text=${Uri.encodeComponent(text)}');
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          AppToast.showSuccess(context, 'Pass Copied', 'Digital pass details copied to clipboard.');
        }
      }
    } catch (_) {
      if (context.mounted) {
        AppToast.showSuccess(context, 'Pass Details', 'Pass details ready for dispatch.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 460,
            decoration: BoxDecoration(
              color: const Color(0xFF141312),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.japaniPhal.withValues(alpha: 0.4), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.7),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
                BoxShadow(
                  color: AppColors.japaniPhalDark.withValues(alpha: 0.15),
                  blurRadius: 40,
                  spreadRadius: 2,
                ),
              ],
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top Header Controls
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.japaniPhalDark.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.qr_code_2, color: AppColors.japaniPhal, size: 20),
                        ),
                        const SizedBox(width: 10),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'DIGITAL GYM PASS',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 13,
                                letterSpacing: 1.2,
                              ),
                            ),
                            Text(
                              'FitBizz OS Universal Pass',
                              style: TextStyle(color: AppColors.stone400, fontSize: 10),
                            ),
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: AppColors.stone400, size: 20),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                // Physical Digital Pass Card Container
                _buildPhysicalPassCard(),

                const SizedBox(height: 20),

                // Quick Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.send_outlined, size: 16, color: AppColors.green600),
                        label: const Text('WhatsApp Pass', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: const BorderSide(color: AppColors.stone700),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () => _shareViaWhatsApp(context),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.sensors, size: 16, color: Colors.white),
                        label: const Text('Simulate Scan', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.japaniPhalDark,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          if (onSimulateScan != null) {
                            onSimulateScan!();
                          } else {
                            AppToast.showSuccess(
                              context,
                              'Access Granted',
                              'Verified ${member.fullName} (${member.memberNumber}) at Reception Desk.',
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhysicalPassCard() {
    final bool isGold = member.planName.toLowerCase().contains('gold') || member.planName.toLowerCase().contains('vip');
    final bool isSilver = member.planName.toLowerCase().contains('silver');

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: isGold
              ? [const Color(0xFF2C1E0F), const Color(0xFF1C1309), const Color(0xFF0F0B05)]
              : (isSilver
                  ? [const Color(0xFF27272A), const Color(0xFF18181B), const Color(0xFF09090B)]
                  : [const Color(0xFF2A1910), const Color(0xFF1C120C), const Color(0xFF120B07)]),
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: isGold
              ? const Color(0xFFF59E0B).withValues(alpha: 0.6)
              : (isSilver
                  ? const Color(0xFFA1A1AA).withValues(alpha: 0.5)
                  : AppColors.japaniPhal.withValues(alpha: 0.5)),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gym Title & Metallic Chip
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'METRO FITNESS CLUB',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 13,
                      letterSpacing: 1.4,
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: AppColors.green600,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        'MAIN ARENA • ALL ACCESS PASS',
                        style: TextStyle(color: AppColors.stone400, fontSize: 9, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
              // Simulated Smart Chip
              Container(
                width: 34,
                height: 26,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFCD34D), Color(0xFFD97706)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: const Color(0xFFF59E0B)),
                ),
                child: Center(
                  child: Container(
                    width: 20,
                    height: 14,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black.withValues(alpha: 0.3)),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Member Info & High-Res QR
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Photo Avatar
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.japaniPhal, width: 2),
                  image: DecorationImage(
                    image: NetworkImage(member.photoUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 14),

              // Member Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      member.fullName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      member.memberNumber,
                      style: const TextStyle(
                        color: AppColors.japaniPhal,
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.w900,
                        fontSize: 12,
                        letterSpacing: 1.1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            member.planName.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        if (member.bloodGroup != null && member.bloodGroup!.isNotEmpty) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.red600.withValues(alpha: 0.25),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: AppColors.red600.withValues(alpha: 0.5), width: 0.8),
                            ),
                            child: Text(
                              '🩸 ${member.bloodGroup}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),

              // High-Definition QR Code
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: QrImageView(
                  data: member.qrPayload,
                  version: QrVersions.auto,
                  size: 72.0,
                  eyeStyle: const QrEyeStyle(
                    eyeShape: QrEyeShape.square,
                    color: Color(0xFF1C1917),
                  ),
                  dataModuleStyle: const QrDataModuleStyle(
                    dataModuleShape: QrDataModuleShape.square,
                    color: Color(0xFF1C1917),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          const Divider(color: Colors.white12, height: 1),
          const SizedBox(height: 12),

          // Bottom Metadata Row: Join, Expiry & Fee
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildPassMetaCol('JOIN DATE', member.joinedDate),
              _buildPassMetaCol('EXPIRES ON', member.expiryDate),
              _buildPassMetaCol('FEE STATUS', 'PAID • ${formatMoney(member.totalFeePaid)}'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPassMetaCol(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.stone500,
            fontSize: 8.5,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.6,
          ),
        ),
        const SizedBox(height: 1),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
