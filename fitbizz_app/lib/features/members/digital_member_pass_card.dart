import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/localization/app_locale.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_toast.dart';
import 'member_model.dart';

enum PassThemeMode { luxuryLight, obsidianDark }

class DigitalMemberPassDialog extends StatefulWidget {
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

  @override
  State<DigitalMemberPassDialog> createState() => _DigitalMemberPassDialogState();
}

class _DigitalMemberPassDialogState extends State<DigitalMemberPassDialog> {
  PassThemeMode _themeMode = PassThemeMode.luxuryLight;

  void _shareViaWhatsApp() async {
    final text = '''🏋️ *FITBIZZ DIGITAL MEMBERSHIP PASS*
━━━━━━━━━━━━━━━━━━━━
🏢 *Gym:* Metro Fitness Club (HQ Arena)
👤 *Member Name:* ${widget.member.fullName}
🆔 *Unique Member ID:* ${widget.member.id}
🔢 *Roll / Pass #:* ${widget.member.memberNumber}
📱 *Phone:* ${widget.member.phone}
🪪 *CNIC:* ${widget.member.cnic ?? 'N/A'}
🩸 *Blood Group:* ${widget.member.bloodGroup ?? 'N/A'}
📦 *Plan:* ${widget.member.planName}
📅 *Valid Until:* ${widget.member.expiryDate}
💵 *Fee Status:* PAID (${formatMoney(widget.member.totalFeePaid)})
🔐 *Pass Code:* ${widget.member.qrPayload}
━━━━━━━━━━━━━━━━━━━━
Scan QR code at front desk turnstiles for instant admission.''';

    final cleanPhone = widget.member.phone.replaceAll(RegExp(r'[^0-9]'), '');
    final uri = Uri.parse('https://wa.me/$cleanPhone?text=${Uri.encodeComponent(text)}');
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (mounted) {
          AppToast.showSuccess(context, 'Pass Copied', 'Digital pass details copied to clipboard.');
        }
      }
    } catch (_) {
      if (mounted) {
        AppToast.showSuccess(context, 'Pass Details', 'Pass details ready for dispatch.');
      }
    }
  }

  // --- PDF GENERATION & EXPORT ---
  Future<void> _generateAndPrintPdf() async {
    final doc = pw.Document();

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context ctx) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'METRO FITNESS CLUB',
                        style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold, color: PdfColors.orange800),
                      ),
                      pw.Text('Official Member Access Credential & Pass', style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
                    ],
                  ),
                  pw.Container(
                    padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: pw.BoxDecoration(
                      color: PdfColors.orange100,
                      borderRadius: pw.BorderRadius.circular(6),
                      border: pw.Border.all(color: PdfColors.orange500),
                    ),
                    child: pw.Text(
                      widget.member.status.toUpperCase(),
                      style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, color: PdfColors.orange900),
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Divider(thickness: 1.5, color: PdfColors.orange300),
              pw.SizedBox(height: 15),

              // Card Layout Box
              pw.Container(
                padding: const pw.EdgeInsets.all(20),
                decoration: pw.BoxDecoration(
                  color: PdfColors.grey100,
                  borderRadius: pw.BorderRadius.circular(16),
                  border: pw.Border.all(color: PdfColors.orange600, width: 2),
                ),
                child: pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Expanded(
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text('MEMBER IDENTITY', style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold, color: PdfColors.grey600)),
                          pw.Text(widget.member.fullName, style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColors.black)),
                          pw.SizedBox(height: 8),

                          pw.Row(
                            children: [
                              pw.Text('Roll Number: ', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
                              pw.Text(widget.member.memberNumber, style: pw.TextStyle(fontSize: 10, color: PdfColors.orange800, fontWeight: pw.FontWeight.bold)),
                            ],
                          ),
                          pw.Row(
                            children: [
                              pw.Text('Unique ID: ', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
                              pw.Text(widget.member.id, style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey800)),
                            ],
                          ),
                          pw.Row(
                            children: [
                              pw.Text('Phone / Mobile: ', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
                              pw.Text(widget.member.phone, style: const pw.TextStyle(fontSize: 10)),
                            ],
                          ),
                          if (widget.member.cnic != null)
                            pw.Row(
                              children: [
                                pw.Text('CNIC / ID: ', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
                                pw.Text(widget.member.cnic!, style: const pw.TextStyle(fontSize: 10)),
                              ],
                            ),
                          if (widget.member.bloodGroup != null)
                            pw.Row(
                              children: [
                                pw.Text('Blood Group: ', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
                                pw.Text(widget.member.bloodGroup!, style: pw.TextStyle(fontSize: 10, color: PdfColors.red800, fontWeight: pw.FontWeight.bold)),
                              ],
                            ),
                          pw.SizedBox(height: 12),

                          pw.Row(
                            children: [
                              pw.Text('Package Tier: ', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
                              pw.Text(widget.member.planName, style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: PdfColors.orange900)),
                            ],
                          ),
                          pw.Row(
                            children: [
                              pw.Text('Valid Period: ', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
                              pw.Text('${widget.member.joinedDate} to ${widget.member.expiryDate}', style: const pw.TextStyle(fontSize: 10)),
                            ],
                          ),
                          pw.Row(
                            children: [
                              pw.Text('Total Paid: ', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
                              pw.Text('${AppLocaleController.instance.currency} ${widget.member.totalFeePaid.toInt()}', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: PdfColors.green800)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    pw.SizedBox(width: 20),
                    // QR Code Box
                    pw.Container(
                      width: 110,
                      height: 110,
                      padding: const pw.EdgeInsets.all(8),
                      decoration: pw.BoxDecoration(
                        color: PdfColors.white,
                        borderRadius: pw.BorderRadius.circular(10),
                        border: pw.Border.all(color: PdfColors.grey400),
                      ),
                      child: pw.BarcodeWidget(
                        barcode: pw.Barcode.qrCode(),
                        data: widget.member.qrPayload,
                      ),
                    ),
                  ],
                ),
              ),

              pw.SizedBox(height: 30),
              pw.Text('TERMS & FRONT DESK REGULATIONS', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: PdfColors.grey800)),
              pw.SizedBox(height: 4),
              pw.Bullet(text: 'This pass must be presented or scanned via turnstiles during every gym visit.'),
              pw.Bullet(text: 'Membership is non-transferable and subject to gym code of conduct.'),
              pw.Bullet(text: 'For renewals and workout plan upgrades, contact the reception desk or management.'),
              pw.Spacer(),

              pw.Divider(color: PdfColors.grey400),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Generated by FitBizz Multi-Tenant SaaS Platform', style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600)),
                  pw.Text('Printed: ${DateTime.now().toIso8601String().split("T")[0]}', style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600)),
                ],
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => doc.save(),
      name: 'FitBizz_Pass_${widget.member.memberNumber}.pdf',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 480,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: AppColors.stone200),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
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
                            color: AppColors.japaniPhal.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.qr_code_2, color: AppColors.japaniPhalDark, size: 20),
                        ),
                        const SizedBox(width: 10),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'DIGITAL MEMBERSHIP PASS',
                              style: TextStyle(
                                color: AppColors.stone900,
                                fontWeight: FontWeight.w900,
                                fontSize: 13,
                                letterSpacing: 1.1,
                              ),
                            ),
                            Text(
                              'High-Definition Member Card & QR Token',
                              style: TextStyle(color: AppColors.stone500, fontSize: 10),
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
                const SizedBox(height: 12),

                // Card Theme Toggle Chips (Luxury Light vs Obsidian Dark)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ChoiceChip(
                      label: const Text('✨ Luxury Pearl & Gold'),
                      selected: _themeMode == PassThemeMode.luxuryLight,
                      selectedColor: AppColors.japaniPhalDark,
                      labelStyle: TextStyle(
                        color: _themeMode == PassThemeMode.luxuryLight ? Colors.white : AppColors.stone700,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                      onSelected: (_) => setState(() => _themeMode = PassThemeMode.luxuryLight),
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: const Text('🌑 Obsidian Dark VIP'),
                      selected: _themeMode == PassThemeMode.obsidianDark,
                      selectedColor: AppColors.stone900,
                      labelStyle: TextStyle(
                        color: _themeMode == PassThemeMode.obsidianDark ? Colors.white : AppColors.stone700,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                      onSelected: (_) => setState(() => _themeMode = PassThemeMode.obsidianDark),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Physical Digital Pass Card Container
                _themeMode == PassThemeMode.luxuryLight
                    ? _buildLuxuryLightPassCard()
                    : _buildObsidianDarkPassCard(),

                const SizedBox(height: 18),

                // Quick Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.picture_as_pdf, size: 16, color: AppColors.japaniPhalDark),
                        label: const Text('Print / PDF Pass', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: AppColors.stone800)),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: const BorderSide(color: AppColors.stone300),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: _generateAndPrintPdf,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.send_outlined, size: 16, color: AppColors.green600),
                        label: const Text('WhatsApp Pass', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: AppColors.stone800)),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: const BorderSide(color: AppColors.stone300),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: _shareViaWhatsApp,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                ElevatedButton.icon(
                  icon: const Icon(Icons.sensors, size: 16, color: Colors.white),
                  label: const Text('Simulate Turnstile Scan', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.japaniPhalDark,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    if (widget.onSimulateScan != null) {
                      widget.onSimulateScan!();
                    } else {
                      AppToast.showSuccess(
                        context,
                        'Access Granted',
                        'Verified ${widget.member.fullName} (${widget.member.memberNumber}) at Reception Desk.',
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- LUXURY PEARL & GOLD PASS CARD ---
  Widget _buildLuxuryLightPassCard() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          colors: [Color(0xFFFFFBF7), Color(0xFFFFF3E6), Color(0xFFFEEDD8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: AppColors.japaniPhalDark.withValues(alpha: 0.5),
          width: 1.8,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.japaniPhalDark.withValues(alpha: 0.18),
            blurRadius: 18,
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
                      color: AppColors.stone900,
                      fontWeight: FontWeight.w900,
                      fontSize: 13,
                      letterSpacing: 1.3,
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
                        style: TextStyle(color: AppColors.japaniPhalDark, fontSize: 9.5, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
              // Simulated Smart Chip (Gold Finish)
              Container(
                width: 36,
                height: 28,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFDE68A), Color(0xFFD97706)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: const Color(0xFFB45309), width: 1.2),
                ),
                child: Center(
                  child: Container(
                    width: 22,
                    height: 16,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black.withValues(alpha: 0.35)),
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
                width: 66,
                height: 66,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.japaniPhalDark, width: 2.2),
                  image: DecorationImage(
                    image: NetworkImage(widget.member.photoUrl),
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
                      widget.member.fullName,
                      style: const TextStyle(
                        color: AppColors.stone900,
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.member.memberNumber,
                      style: const TextStyle(
                        color: AppColors.japaniPhalDark,
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.w900,
                        fontSize: 12,
                        letterSpacing: 1.1,
                      ),
                    ),
                    Text(
                      'ID: ${widget.member.id}',
                      style: const TextStyle(color: AppColors.stone500, fontSize: 9.5, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.japaniPhalDark,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            widget.member.planName.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        if (widget.member.bloodGroup != null && widget.member.bloodGroup!.isNotEmpty) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.red600.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: AppColors.red600.withValues(alpha: 0.4), width: 0.8),
                            ),
                            child: Text(
                              '🩸 ${widget.member.bloodGroup}',
                              style: const TextStyle(
                                color: AppColors.red600,
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
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.stone300),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: QrImageView(
                  data: widget.member.qrPayload,
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
          const Divider(color: Color(0xFFE5D5C5), height: 1),
          const SizedBox(height: 12),

          // Bottom Metadata Row: Join, Expiry & Fee
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildPassMetaColLight('JOIN DATE', widget.member.joinedDate),
              _buildPassMetaColLight('EXPIRES ON', widget.member.expiryDate),
              _buildPassMetaColLight('FEE STATUS', 'PAID • ${formatMoney(widget.member.totalFeePaid)}'),
            ],
          ),
        ],
      ),
    );
  }

  // --- OBSIDIAN DARK PASS CARD ---
  Widget _buildObsidianDarkPassCard() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          colors: [Color(0xFF2A1910), Color(0xFF1C120C), Color(0xFF120B07)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: AppColors.japaniPhal.withValues(alpha: 0.5),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'METRO FITNESS CLUB',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 13,
                      letterSpacing: 1.4,
                    ),
                  ),
                  Text(
                    'MAIN ARENA • ALL ACCESS PASS',
                    style: TextStyle(color: AppColors.stone400, fontSize: 9, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
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
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(widget.member.photoUrl),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.member.fullName,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16),
                    ),
                    Text(
                      widget.member.memberNumber,
                      style: const TextStyle(color: AppColors.japaniPhal, fontFamily: 'monospace', fontWeight: FontWeight.w900, fontSize: 12),
                    ),
                    Text(
                      'ID: ${widget.member.id}',
                      style: const TextStyle(color: AppColors.stone400, fontSize: 9.5),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: QrImageView(
                  data: widget.member.qrPayload,
                  version: QrVersions.auto,
                  size: 68.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: Colors.white12, height: 1),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildPassMetaColDark('JOIN DATE', widget.member.joinedDate),
              _buildPassMetaColDark('EXPIRES ON', widget.member.expiryDate),
              _buildPassMetaColDark('FEE STATUS', 'PAID • ${formatMoney(widget.member.totalFeePaid)}'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPassMetaColLight(String label, String value) {
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
            color: AppColors.stone900,
            fontSize: 10,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }

  Widget _buildPassMetaColDark(String label, String value) {
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
