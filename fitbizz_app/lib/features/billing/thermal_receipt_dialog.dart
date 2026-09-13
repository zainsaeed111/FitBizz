import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/localization/app_locale.dart';
import '../../core/theme/app_colors.dart';
import '../settings/gym_settings_controller.dart';
import 'billing_screen.dart';

class PosThermalReceiptDialog extends StatelessWidget {
  final InvoiceRecord invoice;

  const PosThermalReceiptDialog({
    super.key,
    required this.invoice,
  });

  static Future<void> show(BuildContext context, InvoiceRecord invoice) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => PosThermalReceiptDialog(invoice: invoice),
    );
  }

  Widget _buildDashedLine() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 4.0;
        const dashHeight = 1.0;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: List.generate(dashCount, (_) {
            return const SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: AppColors.stone400),
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildMonoRow(String label, String value, {bool isBold = false, Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 10,
              color: AppColors.stone600,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 10,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                color: valueColor ?? AppColors.stone900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = GymSettingsController.instance.settings;
    final is58mm = settings.receiptWidth == '58mm';
    final dialogWidth = is58mm ? 300.0 : 360.0;

    return AlertDialog(
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      contentPadding: EdgeInsets.zero,
      insetPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
      content: SizedBox(
        width: dialogWidth,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Thermal Paper Container with serrated styling
              Container(
                padding: EdgeInsets.symmetric(horizontal: is58mm ? 14 : 20, vertical: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFFFCFCFB),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.stone300, width: 1.2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.18),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Gym Header
                    Center(
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppColors.japaniPhalDark.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.fitness_center, size: 22, color: AppColors.japaniPhalDark),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            settings.receiptHeader.toUpperCase(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontWeight: FontWeight.w900,
                              fontSize: 15,
                              letterSpacing: 0.5,
                              color: AppColors.stone900,
                            ),
                          ),
                          if (settings.receiptTagline.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Text(
                              settings.receiptTagline,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 9.5,
                                color: AppColors.stone600,
                              ),
                            ),
                          ],
                          const SizedBox(height: 2),
                          Text(
                            '${settings.branchName} • ${settings.address}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 9,
                              color: AppColors.stone600,
                            ),
                          ),
                          Text(
                            '${settings.taxNumber} • Ph: ${settings.phone}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 8.5,
                              color: AppColors.stone500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildDashedLine(),
                    const SizedBox(height: 8),

                    // POS Metadata
                    _buildMonoRow('RCPT NO  :', invoice.id, isBold: true),
                    _buildMonoRow('DATE/TIME:', '${invoice.date} ${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}'),
                    _buildMonoRow('TERMINAL :', 'Front Desk POS #01'),
                    _buildMonoRow('CASHIER  :', settings.ownerName),
                    const SizedBox(height: 8),
                    _buildDashedLine(),
                    const SizedBox(height: 8),

                    // Member Details
                    const Text(
                      '--- MEMBER & PLAN DETAILS ---',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: AppColors.stone600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    _buildMonoRow('NAME     :', invoice.memberName, isBold: true),
                    _buildMonoRow('ROLL NO  :', invoice.memberRoll, isBold: true),
                    _buildMonoRow('PHONE    :', invoice.memberPhone),
                    _buildMonoRow('PLAN/ITEM:', invoice.items.isNotEmpty ? invoice.items.first.name : 'Gym Membership'),
                    const SizedBox(height: 8),
                    _buildDashedLine(),
                    const SizedBox(height: 8),

                    // Itemized Header
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('ITEM DESCRIPTION', style: TextStyle(fontFamily: 'monospace', fontSize: 9, fontWeight: FontWeight.w900, color: AppColors.stone800)),
                        Text('QTY  AMOUNT', style: TextStyle(fontFamily: 'monospace', fontSize: 9, fontWeight: FontWeight.w900, color: AppColors.stone800)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    _buildDashedLine(),
                    const SizedBox(height: 6),

                    // Items List
                    ...invoice.items.map((item) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                item.name,
                                style: const TextStyle(fontFamily: 'monospace', fontSize: 9.5, fontWeight: FontWeight.w600, color: AppColors.stone900),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '${item.quantity}  ${formatMoney(item.total)}',
                              style: const TextStyle(fontFamily: 'monospace', fontSize: 9.5, fontWeight: FontWeight.bold, color: AppColors.stone900),
                            ),
                          ],
                        ),
                      );
                    }),

                    const SizedBox(height: 6),
                    _buildDashedLine(),
                    const SizedBox(height: 6),

                    // Financials
                    _buildMonoRow('SUBTOTAL   :', formatMoney(invoice.subtotal)),
                    if (invoice.discount > 0)
                      _buildMonoRow('DISCOUNT   :', '- ${formatMoney(invoice.discount)}', valueColor: AppColors.red600),
                    const SizedBox(height: 4),
                    const Divider(thickness: 1.5, color: AppColors.stone900),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('NET PAID:', style: TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.w900, fontSize: 13, color: AppColors.stone900)),
                        Text(formatMoney(invoice.grandTotal), style: const TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.w900, fontSize: 14.5, color: AppColors.japaniPhalDark)),
                      ],
                    ),
                    const Divider(thickness: 1.5, color: AppColors.stone900),
                    const SizedBox(height: 4),

                    // Tender Details
                    _buildMonoRow('PAY MODE   :', invoice.paymentMode, isBold: true),
                    if (invoice.paymentRef != null)
                      _buildMonoRow('TRX REF    :', invoice.paymentRef!),
                    if (invoice.cashTendered != null) ...[
                      _buildMonoRow('CASH TENDER:', formatMoney(invoice.cashTendered!)),
                      _buildMonoRow('CHANGE DUE :', formatMoney(invoice.changeReturned ?? 0), isBold: true, valueColor: AppColors.green600),
                    ],

                    const SizedBox(height: 10),

                    // QR Code & Footer
                    Center(
                      child: Column(
                        children: [
                          if (settings.showQrCode) ...[
                            QrImageView(
                              data: 'RECEIPT:${invoice.id}:${invoice.grandTotal}:${invoice.memberRoll}',
                              version: QrVersions.auto,
                              size: is58mm ? 60 : 70,
                            ),
                            const SizedBox(height: 6),
                          ],
                          const Text(
                            '*** THANK YOU FOR TRAINING WITH US ***',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontFamily: 'monospace', fontSize: 8.5, fontWeight: FontWeight.bold, color: AppColors.stone700),
                          ),
                          if (settings.customFooterNote.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Text(
                              settings.customFooterNote,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontFamily: 'monospace', fontSize: 7.5, color: AppColors.stone500),
                            ),
                          ],
                          if (settings.showPoweredBy) ...[
                            const SizedBox(height: 6),
                            _buildDashedLine(),
                            const SizedBox(height: 6),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.bolt, size: 11, color: AppColors.japaniPhalDark),
                                SizedBox(width: 3),
                                Text(
                                  'Powered by FitBizz Cloud Gym POS',
                                  style: TextStyle(fontFamily: 'monospace', fontSize: 8, fontWeight: FontWeight.bold, color: AppColors.japaniPhalDark),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // Action Buttons Bar
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.green600,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 11),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      icon: const Icon(Icons.share, size: 15),
                      label: const Text('WhatsApp', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold)),
                      onPressed: () {
                        final text = '''🧾 *${settings.receiptHeader.toUpperCase()} - POS THERMAL RECEIPT*
━━━━━━━━━━━━━━━━━━━━
🏢 *Gym:* ${settings.gymName} (${settings.branchName})
📄 *Receipt #:* ${invoice.id}
📅 *Date:* ${invoice.date}
👤 *Member:* ${invoice.memberName} (${invoice.memberRoll})
📱 *Phone:* ${invoice.memberPhone}
━━━━━━━━━━━━━━━━━━━━
*ITEMIZED CHARGES:*
${invoice.items.map((it) => '• ${it.name} (x${it.quantity}): ${formatMoney(it.total)}').join('\n')}
━━━━━━━━━━━━━━━━━━━━
Subtotal: ${formatMoney(invoice.subtotal)}
Discount: -${formatMoney(invoice.discount)}
*TOTAL PAID:* ${formatMoney(invoice.grandTotal)}
Payment Mode: ${invoice.paymentMode} ${invoice.paymentRef != null ? '(${invoice.paymentRef})' : ''}
━━━━━━━━━━━━━━━━━━━━
⚡ _Powered by FitBizz Cloud Gym POS_''';
                        final cleanPhone = invoice.memberPhone.replaceAll(RegExp(r'[^0-9]'), '');
                        launchUrl(Uri.parse('https://wa.me/$cleanPhone?text=${Uri.encodeComponent(text)}'), mode: LaunchMode.externalApplication);
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.stone900,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 11),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      icon: const Icon(Icons.print, size: 15),
                      label: Text('Print ${settings.receiptWidth}', style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold)),
                      onPressed: () async {
                        final doc = pw.Document();
                        final isRoll58 = settings.receiptWidth == '58mm';

                        doc.addPage(
                          pw.Page(
                            pageFormat: isRoll58 ? PdfPageFormat.roll57 : PdfPageFormat.roll80,
                            margin: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                            build: (pw.Context context) {
                              return pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                                children: [
                                  pw.Center(
                                    child: pw.Column(
                                      children: [
                                        pw.Text(settings.receiptHeader.toUpperCase(), style: pw.TextStyle(font: pw.Font.courierBold(), fontSize: 13)),
                                        if (settings.receiptTagline.isNotEmpty)
                                          pw.Text(settings.receiptTagline, style: pw.TextStyle(font: pw.Font.courier(), fontSize: 8)),
                                        pw.Text('${settings.branchName} • ${settings.address}', style: pw.TextStyle(font: pw.Font.courier(), fontSize: 7.5)),
                                        pw.Text('${settings.taxNumber} • Ph: ${settings.phone}', style: pw.TextStyle(font: pw.Font.courier(), fontSize: 7.5)),
                                      ],
                                    ),
                                  ),
                                  pw.SizedBox(height: 6),
                                  pw.Divider(thickness: 0.8),
                                  pw.Row(
                                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                    children: [
                                      pw.Text('RCPT: ${invoice.id}', style: pw.TextStyle(font: pw.Font.courierBold(), fontSize: 8.5)),
                                      pw.Text('DATE: ${invoice.date}', style: pw.TextStyle(font: pw.Font.courier(), fontSize: 8.5)),
                                    ],
                                  ),
                                  pw.Text('MEMBER: ${invoice.memberName} (${invoice.memberRoll})', style: pw.TextStyle(font: pw.Font.courierBold(), fontSize: 8.5)),
                                  pw.Divider(thickness: 0.8),
                                  ...invoice.items.map((item) => pw.Row(
                                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                    children: [
                                      pw.Expanded(child: pw.Text('${item.quantity}x ${item.name}', style: pw.TextStyle(font: pw.Font.courier(), fontSize: 8))),
                                      pw.Text(formatMoney(item.total), style: pw.TextStyle(font: pw.Font.courierBold(), fontSize: 8)),
                                    ],
                                  )),
                                  pw.Divider(thickness: 0.8),
                                  pw.Row(
                                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                    children: [
                                      pw.Text('NET PAID:', style: pw.TextStyle(font: pw.Font.courierBold(), fontSize: 10)),
                                      pw.Text(formatMoney(invoice.grandTotal), style: pw.TextStyle(font: pw.Font.courierBold(), fontSize: 10)),
                                    ],
                                  ),
                                  pw.Text('MODE: ${invoice.paymentMode}', style: pw.TextStyle(font: pw.Font.courier(), fontSize: 8)),
                                  pw.SizedBox(height: 6),
                                  pw.Center(
                                    child: pw.Text(
                                      '*** THANK YOU ***\n${settings.showPoweredBy ? "Powered by FitBizz POS" : ""}',
                                      textAlign: pw.TextAlign.center,
                                      style: pw.TextStyle(font: pw.Font.courier(), fontSize: 7),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        );
                        await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => doc.save());
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.stone200,
                      foregroundColor: AppColors.stone800,
                      padding: const EdgeInsets.all(10),
                    ),
                    icon: const Icon(Icons.close, size: 18),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
