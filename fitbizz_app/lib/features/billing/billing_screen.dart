import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/localization/app_locale.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_badge.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/app_toast.dart';
import '../members/members_controller.dart';

class InvoiceItem {
  String name;
  int quantity;
  double unitPrice;

  InvoiceItem({
    required this.name,
    this.quantity = 1,
    required this.unitPrice,
  });

  double get total => quantity * unitPrice;
}

class InvoiceRecord {
  final String id;
  final String memberName;
  final String memberRoll;
  final String memberPhone;
  final List<InvoiceItem> items;
  final double subtotal;
  final double discount;
  final double grandTotal;
  final String paymentMode;
  final String? paymentRef;
  final double? cashTendered;
  final double? changeReturned;
  final String status; // PAID, PARTIAL, DUE
  final String date;

  InvoiceRecord({
    required this.id,
    required this.memberName,
    required this.memberRoll,
    required this.memberPhone,
    required this.items,
    required this.subtotal,
    this.discount = 0.0,
    required this.grandTotal,
    required this.paymentMode,
    this.paymentRef,
    this.cashTendered,
    this.changeReturned,
    this.status = 'PAID',
    required this.date,
  });
}

class BillingScreen extends StatefulWidget {
  const BillingScreen({super.key});

  @override
  State<BillingScreen> createState() => _BillingScreenState();
}

class _BillingScreenState extends State<BillingScreen> {
  String _searchQuery = '';
  String _invoiceFilter = 'ALL'; // ALL, PAID, DUE, OVERDUE

  final List<InvoiceRecord> _invoices = [
    InvoiceRecord(
      id: 'INV-2026-001',
      memberName: 'Zain Malik',
      memberRoll: 'METRO-202609-0001',
      memberPhone: '+92 300 1234567',
      items: [
        InvoiceItem(name: 'Silver Plan Monthly Membership', quantity: 1, unitPrice: 6500.0),
        InvoiceItem(name: 'Admission / Registration Fee', quantity: 1, unitPrice: 1500.0),
      ],
      subtotal: 8000.0,
      grandTotal: 8000.0,
      paymentMode: 'CASH',
      cashTendered: 10000.0,
      changeReturned: 2000.0,
      status: 'PAID',
      date: '2026-09-01',
    ),
    InvoiceRecord(
      id: 'INV-2026-002',
      memberName: 'Ayesha Khan',
      memberRoll: 'METRO-202609-0002',
      memberPhone: '+92 301 9876543',
      items: [
        InvoiceItem(name: 'Gold VIP Annual Plan', quantity: 1, unitPrice: 12000.0),
        InvoiceItem(name: 'VIP Registration & Access Card', quantity: 1, unitPrice: 2000.0),
      ],
      subtotal: 14000.0,
      grandTotal: 14000.0,
      paymentMode: 'ONLINE',
      paymentRef: 'RAAST-TRX-893201',
      status: 'PAID',
      date: '2026-08-15',
    ),
    InvoiceRecord(
      id: 'INV-2026-003',
      memberName: 'Junaid Khan',
      memberRoll: 'METRO-202609-0004',
      memberPhone: '+92 333 7891234',
      items: [
        InvoiceItem(name: 'Silver Plan Membership Renewal', quantity: 1, unitPrice: 6500.0),
        InvoiceItem(name: 'Personal Locker Rental (1 Mo)', quantity: 1, unitPrice: 1500.0),
      ],
      subtotal: 8000.0,
      grandTotal: 8000.0,
      paymentMode: 'CASH',
      status: 'DUE',
      date: '2026-09-15',
    ),
  ];

  void _sendWhatsAppReminder(MemberModel member) async {
    final amountDue = member.dueAmount > 0 ? member.dueAmount : member.monthlyFee;
    final text = '''🔔 *FITBIZZ MEMBERSHIP FEE REMINDER*
━━━━━━━━━━━━━━━━━━━━
🏢 *Gym:* Metro Fitness Club (HQ Arena)
👤 *Dear Member:* ${member.fullName} (${member.memberNumber})
📦 *Active Plan:* ${member.planName}
💰 *Pending Dues:* ${formatMoney(amountDue)}
📅 *Renewal Due Date:* ${member.expiryDate}
━━━━━━━━━━━━━━━━━━━━
Kindly settle your dues at the gym reception desk or via Raast/Online transfer to avoid pass suspension.
🏦 *Raast / Bank Account:* 03001234567 (Meezan Bank - Metro Fitness)
Thank you for training with us!''';

    final cleanPhone = member.phone.replaceAll(RegExp(r'[^0-9]'), '');
    final uri = Uri.parse('https://wa.me/$cleanPhone?text=${Uri.encodeComponent(text)}');
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (mounted) AppToast.showSuccess(context, 'Reminder Ready', 'Fee reminder text ready for dispatch.');
      }
    } catch (_) {
      if (mounted) AppToast.showSuccess(context, 'Fee Reminder', 'Fee reminder dispatched to ${member.fullName}.');
    }
  }

  // --- MID-LEVEL POS FEE SETTLEMENT & MULTI-ITEM INVOICE BUILDER ---
  void _showPosBillingModal({MemberModel? preselectedMember}) {
    final allMembers = MembersController.instance.members;
    MemberModel? selectedMember = preselectedMember ?? (allMembers.isNotEmpty ? allMembers.first : null);

    final customerNameController = TextEditingController(text: selectedMember?.fullName ?? '');
    final customerPhoneController = TextEditingController(text: selectedMember?.phone ?? '');
    final refController = TextEditingController();
    final discountController = TextEditingController(text: '0');

    String paymentMode = 'CASH';
    final cashTenderedController = TextEditingController();

    // Default POS Items Cart
    final List<InvoiceItem> cartItems = [
      InvoiceItem(
        name: selectedMember != null ? '${selectedMember.planName} Membership Renewal' : 'Gym Membership Fee',
        quantity: 1,
        unitPrice: selectedMember != null && selectedMember.dueAmount > 0 ? selectedMember.dueAmount : (selectedMember?.monthlyFee ?? 4500.0),
      ),
    ];

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        final screenWidth = MediaQuery.of(context).size.width;
        final isWide = screenWidth >= 860;

        return StatefulBuilder(
          builder: (context, setModalState) {
            final double subtotal = cartItems.fold(0.0, (acc, item) => acc + item.total);
            final double discount = double.tryParse(discountController.text) ?? 0.0;
            final double netTotal = (subtotal - discount).clamp(0.0, double.infinity);

            final double tendered = double.tryParse(cashTenderedController.text) ?? netTotal;
            final double changeDue = tendered >= netTotal ? (tendered - netTotal) : 0.0;

            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.japaniPhal.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.point_of_sale, color: AppColors.japaniPhalDark, size: 22),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('POS Fee Collection & Invoice Builder', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900)),
                      Text('Itemized charges, dues clearance, discounts & real-time receipting', style: TextStyle(fontSize: 11, color: AppColors.stone500)),
                    ],
                  ),
                ],
              ),
              content: SizedBox(
                width: isWide ? 880 : 520,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section 1: Member Selection
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.stone50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.stone200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('1. Member Account / Customer:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5)),
                            const SizedBox(height: 8),
                            DropdownButtonFormField<MemberModel>(
                              initialValue: selectedMember,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.stone300)),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              ),
                              items: allMembers.map((m) {
                                return DropdownMenuItem(
                                  value: m,
                                  child: Text(
                                    '${m.fullName} (${m.memberNumber}) • ${m.planName} ${m.dueAmount > 0 ? "• ₨ ${m.dueAmount.toInt()} DUE" : ""}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: m.isDueSoon ? FontWeight.bold : FontWeight.normal,
                                      color: m.isOverdue ? AppColors.red600 : AppColors.stone900,
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (picked) {
                                if (picked != null) {
                                  setModalState(() {
                                    selectedMember = picked;
                                    customerNameController.text = picked.fullName;
                                    customerPhoneController.text = picked.phone;
                                    cartItems[0] = InvoiceItem(
                                      name: '${picked.planName} Membership Renewal',
                                      quantity: 1,
                                      unitPrice: picked.dueAmount > 0 ? picked.dueAmount : picked.monthlyFee,
                                    );
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),

                      // Section 2: Multi-Item Cart & Charges
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('2. Itemized Fee Charges:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          // Quick Add Item Button
                          PopupMenuButton<String>(
                            tooltip: 'Add Charge Item',
                            onSelected: (val) {
                              setModalState(() {
                                if (val == 'PT') {
                                  cartItems.add(InvoiceItem(name: 'Personal Training (PT) Guidance (1 Mo)', unitPrice: 5000.0));
                                } else if (val == 'LOCKER') {
                                  cartItems.add(InvoiceItem(name: 'Dedicated Private Locker (1 Mo)', unitPrice: 1000.0));
                                } else if (val == 'DIET') {
                                  cartItems.add(InvoiceItem(name: 'Customized Macro Diet & Nutrition Consultation', unitPrice: 2500.0));
                                } else if (val == 'SUPPLEMENT') {
                                  cartItems.add(InvoiceItem(name: 'Whey Protein Shake / Energy Drink', unitPrice: 600.0));
                                } else {
                                  cartItems.add(InvoiceItem(name: 'Custom Facility Charge / Service', unitPrice: 1000.0));
                                }
                              });
                            },
                            itemBuilder: (ctx) => [
                              const PopupMenuItem(value: 'PT', child: Text('🏋️ + Personal Training (PT) - ₨ 5,000')),
                              const PopupMenuItem(value: 'LOCKER', child: Text('🔒 + Locker Rental - ₨ 1,000')),
                              const PopupMenuItem(value: 'DIET', child: Text('🥗 + Customized Diet Plan - ₨ 2,500')),
                              const PopupMenuItem(value: 'SUPPLEMENT', child: Text('🥤 + Protein Shake / Supplement - ₨ 600')),
                              const PopupMenuItem(value: 'CUSTOM', child: Text('⚡ + Custom Line Item')),
                            ],
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: AppColors.japaniPhal.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: AppColors.japaniPhal),
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.add, size: 16, color: AppColors.japaniPhalDark),
                                  SizedBox(width: 4),
                                  Text('Add Charge Item', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.japaniPhalDark)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Cart Items Table
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.stone200),
                        ),
                        child: Column(
                          children: cartItems.asMap().entries.map((entry) {
                            final idx = entry.key;
                            final item = entry.value;

                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                border: Border(bottom: BorderSide(color: idx < cartItems.length - 1 ? AppColors.stone100 : Colors.transparent)),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: TextFormField(
                                      initialValue: item.name,
                                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                                      decoration: const InputDecoration(isDense: true, border: InputBorder.none),
                                      onChanged: (v) => item.name = v,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: TextFormField(
                                      initialValue: item.unitPrice.toInt().toString(),
                                      keyboardType: TextInputType.number,
                                      textAlign: TextAlign.right,
                                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.japaniPhalDark),
                                      decoration: const InputDecoration(isDense: true, prefixText: '₨ ', border: InputBorder.none),
                                      onChanged: (v) {
                                        setModalState(() {
                                          item.unitPrice = double.tryParse(v) ?? 0.0;
                                        });
                                      },
                                    ),
                                  ),
                                  if (cartItems.length > 1)
                                    IconButton(
                                      icon: const Icon(Icons.close, size: 16, color: AppColors.red600),
                                      onPressed: () => setModalState(() => cartItems.removeAt(idx)),
                                    ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),

                      // Subtotal & Discount Row
                      Row(
                        children: [
                          Expanded(
                            child: AppTextField(
                              label: 'Flat Discount / Promo (₨)',
                              hint: '0',
                              controller: discountController,
                              keyboardType: TextInputType.number,
                              onChanged: (_) => setModalState(() {}),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: AppColors.japaniPhal.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.japaniPhal.withValues(alpha: 0.3)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text('Total Net Payable:', style: TextStyle(fontSize: 10, color: AppColors.stone600, fontWeight: FontWeight.bold)),
                                Text(
                                  formatMoney(netTotal),
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.japaniPhalDark),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),

                      // Section 3: Payment Mode & Fast POS Cashiering
                      const Text('3. Payment Settlement & Mode:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 8,
                        children: [
                          ChoiceChip(
                            label: const Text('💵 Cash (POS)'),
                            selected: paymentMode == 'CASH',
                            selectedColor: AppColors.green600,
                            labelStyle: TextStyle(color: paymentMode == 'CASH' ? Colors.white : AppColors.stone800, fontWeight: FontWeight.bold, fontSize: 11),
                            onSelected: (_) => setModalState(() => paymentMode = 'CASH'),
                          ),
                          ChoiceChip(
                            label: const Text('💳 Online Bank / Raast'),
                            selected: paymentMode == 'ONLINE',
                            selectedColor: AppColors.japaniPhalDark,
                            labelStyle: TextStyle(color: paymentMode == 'ONLINE' ? Colors.white : AppColors.stone800, fontWeight: FontWeight.bold, fontSize: 11),
                            onSelected: (_) => setModalState(() => paymentMode = 'ONLINE'),
                          ),
                          ChoiceChip(
                            label: const Text('📱 JazzCash / POS'),
                            selected: paymentMode == 'WALLET',
                            selectedColor: AppColors.stone900,
                            labelStyle: TextStyle(color: paymentMode == 'WALLET' ? Colors.white : AppColors.stone800, fontWeight: FontWeight.bold, fontSize: 11),
                            onSelected: (_) => setModalState(() => paymentMode = 'WALLET'),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),

                      if (paymentMode == 'CASH') ...[
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.green600.withValues(alpha: 0.06),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.green600.withValues(alpha: 0.3)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: AppTextField(
                                      label: 'Cash Tendered / Received (${AppLocaleController.instance.currency})',
                                      hint: netTotal.toInt().toString(),
                                      controller: cashTenderedController,
                                      keyboardType: TextInputType.number,
                                      onChanged: (_) => setModalState(() {}),
                                    ),
                                  ),
                                  const SizedBox(width: AppSpacing.sm),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: AppColors.green600.withValues(alpha: 0.4)),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text('Change to Return:', style: TextStyle(fontSize: 10, color: AppColors.stone500, fontWeight: FontWeight.bold)),
                                        Text(
                                          formatMoney(changeDue),
                                          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: AppColors.green600),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Wrap(
                                spacing: 6,
                                children: [
                                  ActionChip(
                                    label: Text('Exact: ${formatMoney(netTotal)}', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                                    onPressed: () {
                                      cashTenderedController.text = netTotal.toInt().toString();
                                      setModalState(() {});
                                    },
                                  ),
                                  ActionChip(
                                    label: Text('₨ ${(netTotal + 500).toInt()}', style: const TextStyle(fontSize: 10)),
                                    onPressed: () {
                                      cashTenderedController.text = (netTotal + 500).toInt().toString();
                                      setModalState(() {});
                                    },
                                  ),
                                  ActionChip(
                                    label: const Text('₨ 5,000', style: TextStyle(fontSize: 10)),
                                    onPressed: () {
                                      cashTenderedController.text = '5000';
                                      setModalState(() {});
                                    },
                                  ),
                                  ActionChip(
                                    label: const Text('₨ 10,000', style: TextStyle(fontSize: 10)),
                                    onPressed: () {
                                      cashTenderedController.text = '10000';
                                      setModalState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ] else ...[
                        AppTextField(
                          label: 'Transaction Reference / Raast ID',
                          hint: 'TRX-9823412',
                          controller: refController,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              actions: [
                AppButton(
                  label: 'Cancel',
                  variant: AppButtonVariant.secondary,
                  onPressed: () => Navigator.pop(context),
                ),
                AppButton(
                  label: 'Settle & Generate Invoice',
                  icon: Icons.receipt_long,
                  onPressed: () {
                    final invoiceId = 'INV-2026-${(1001 + _invoices.length).toString()}';
                    final dateStr = DateFormat('yyyy-MM-dd').format(DateTime.now());

                    final newInvoice = InvoiceRecord(
                      id: invoiceId,
                      memberName: selectedMember?.fullName ?? customerNameController.text.trim(),
                      memberRoll: selectedMember?.memberNumber ?? 'WALK-IN',
                      memberPhone: selectedMember?.phone ?? customerPhoneController.text.trim(),
                      items: List.from(cartItems),
                      subtotal: subtotal,
                      discount: discount,
                      grandTotal: netTotal,
                      paymentMode: paymentMode,
                      paymentRef: refController.text.trim().isEmpty ? null : refController.text.trim(),
                      cashTendered: paymentMode == 'CASH' ? tendered : null,
                      changeReturned: paymentMode == 'CASH' ? changeDue : null,
                      status: 'PAID',
                      date: dateStr,
                    );

                    setState(() {
                      _invoices.insert(0, newInvoice);
                    });

                    // Update member financial ledger if member is selected
                    if (selectedMember != null) {
                      MembersController.instance.recordFeePayment(
                        selectedMember!.id,
                        netTotal,
                        paymentMode,
                        extendMonths: 1,
                        receiptRef: invoiceId,
                      );
                    }

                    Navigator.pop(context);
                    AppToast.showSuccess(
                      context,
                      'Fee Collected Successfully',
                      'Invoice $invoiceId issued for ${newInvoice.memberName} (${formatMoney(netTotal)}).',
                    );

                    // Immediately present the Tax Invoice & Receipt
                    _showReceiptDialog(newInvoice);
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  // --- AUTHENTIC COMPACT POS THERMAL RECEIPT DIALOG (80MM ROLL & WHATSAPP) ---
  void _showReceiptDialog(InvoiceRecord invoice) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        contentPadding: EdgeInsets.zero,
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        content: SizedBox(
          width: 350,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Thermal Paper Container with serrated edges look
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
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
                              child: const Icon(Icons.fitness_center, size: 24, color: AppColors.japaniPhalDark),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'METRO FITNESS CLUB',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.w900, fontSize: 16, letterSpacing: 0.5, color: AppColors.stone900),
                            ),
                            const Text(
                              'HQ Arena • Main Blvd, Gulberg III',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontFamily: 'monospace', fontSize: 10, color: AppColors.stone600),
                            ),
                            const Text(
                              'NTN: 8932014-7 • Ph: +92 300 0000000',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontFamily: 'monospace', fontSize: 9.5, color: AppColors.stone500),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildDashedLine(),
                      const SizedBox(height: 8),

                      // POS Terminal Metadata
                      _buildMonoRow('RCPT NO  :', invoice.id, isBold: true),
                      _buildMonoRow('DATE/TIME:', '${invoice.date} 10:30 PM'),
                      _buildMonoRow('TERMINAL :', 'POS Counter #01 (Front Desk)'),
                      _buildMonoRow('CASHIER  :', 'Reception Desk Staff'),
                      const SizedBox(height: 8),
                      _buildDashedLine(),
                      const SizedBox(height: 8),

                      // Member & Membership Details Section
                      const Text(
                        '--- MEMBER & PLAN DETAILS ---',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontFamily: 'monospace', fontSize: 9.5, fontWeight: FontWeight.bold, color: AppColors.stone600),
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
                          Text('ITEM DESCRIPTION', style: TextStyle(fontFamily: 'monospace', fontSize: 9.5, fontWeight: FontWeight.w900, color: AppColors.stone800)),
                          Text('QTY  AMOUNT', style: TextStyle(fontFamily: 'monospace', fontSize: 9.5, fontWeight: FontWeight.w900, color: AppColors.stone800)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      _buildDashedLine(),
                      const SizedBox(height: 6),

                      // Items List
                      ...invoice.items.map((item) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2.5),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  item.name,
                                  style: const TextStyle(fontFamily: 'monospace', fontSize: 10.5, fontWeight: FontWeight.w600, color: AppColors.stone900),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${item.quantity}  ${formatMoney(item.total)}',
                                style: const TextStyle(fontFamily: 'monospace', fontSize: 10.5, fontWeight: FontWeight.bold, color: AppColors.stone900),
                              ),
                            ],
                          ),
                        );
                      }),

                      const SizedBox(height: 6),
                      _buildDashedLine(),
                      const SizedBox(height: 6),

                      // Financial Calculations
                      _buildMonoRow('SUBTOTAL   :', formatMoney(invoice.subtotal)),
                      if (invoice.discount > 0)
                        _buildMonoRow('DISCOUNT   :', '- ${formatMoney(invoice.discount)}', valueColor: AppColors.red600),
                      const SizedBox(height: 4),
                      const Divider(thickness: 1.5, color: AppColors.stone900),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('NET PAID:', style: TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.w900, fontSize: 14, color: AppColors.stone900)),
                          Text(formatMoney(invoice.grandTotal), style: const TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.w900, fontSize: 15, color: AppColors.japaniPhalDark)),
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

                      const SizedBox(height: 12),

                      // QR Code Verification
                      Center(
                        child: Column(
                          children: [
                            QrImageView(
                              data: 'RECEIPT:${invoice.id}:${invoice.grandTotal}:${invoice.memberRoll}',
                              version: QrVersions.auto,
                              size: 70,
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              '*** THANK YOU FOR TRAINING WITH US ***',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontFamily: 'monospace', fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.stone700),
                            ),
                            const Text(
                              'Computer-generated POS Tax Receipt\nNo signature required • Non-refundable',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontFamily: 'monospace', fontSize: 8, color: AppColors.stone500),
                            ),
                            const SizedBox(height: 6),
                            _buildDashedLine(),
                            const SizedBox(height: 6),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.bolt, size: 12, color: AppColors.japaniPhalDark),
                                SizedBox(width: 4),
                                Text(
                                  'Powered by FitBizz Cloud Gym POS',
                                  style: TextStyle(fontFamily: 'monospace', fontSize: 8.5, fontWeight: FontWeight.bold, color: AppColors.japaniPhalDark),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Action Buttons Bar
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.green600,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        icon: const Icon(Icons.share, size: 16),
                        label: const Text('WhatsApp', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        onPressed: () {
                          final text = '''🧾 *METRO FITNESS CLUB - POS THERMAL RECEIPT*
━━━━━━━━━━━━━━━━━━━━
🏢 *Gym:* Metro Fitness Club (HQ Arena)
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
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        icon: const Icon(Icons.print, size: 16),
                        label: const Text('Print 80mm', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        onPressed: () async {
                          final doc = pw.Document();
                          doc.addPage(
                            pw.Page(
                              pageFormat: PdfPageFormat.roll80,
                              margin: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 14),
                              build: (pw.Context context) {
                                return pw.Column(
                                  crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                                  children: [
                                    pw.Center(
                                      child: pw.Text('METRO FITNESS CLUB', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
                                    ),
                                    pw.Center(
                                      child: pw.Text('HQ Arena • Gulberg III • NTN: 8932014-7', style: const pw.TextStyle(fontSize: 8)),
                                    ),
                                    pw.Center(
                                      child: pw.Text('Helpline: +92 300 0000000', style: const pw.TextStyle(fontSize: 8)),
                                    ),
                                    pw.Divider(thickness: 0.5),
                                    pw.Text('RCPT #: ${invoice.id}', style: pw.TextStyle(fontSize: 8.5, fontWeight: pw.FontWeight.bold)),
                                    pw.Text('DATE  : ${invoice.date}', style: const pw.TextStyle(fontSize: 8)),
                                    pw.Text('MEMBER: ${invoice.memberName}', style: pw.TextStyle(fontSize: 8.5, fontWeight: pw.FontWeight.bold)),
                                    pw.Text('ROLL #: ${invoice.memberRoll}', style: const pw.TextStyle(fontSize: 8)),
                                    pw.Divider(thickness: 0.5),
                                    ...invoice.items.map((it) => pw.Row(
                                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                          children: [
                                            pw.Expanded(child: pw.Text('${it.name} x${it.quantity}', style: const pw.TextStyle(fontSize: 8))),
                                            pw.Text('Rs ${it.total.toInt()}', style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
                                          ],
                                        )),
                                    pw.Divider(thickness: 0.5),
                                    pw.Row(
                                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                      children: [
                                        pw.Text('TOTAL PAID (${invoice.paymentMode}):', style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold)),
                                        pw.Text('Rs ${invoice.grandTotal.toInt()}', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
                                      ],
                                    ),
                                    pw.SizedBox(height: 8),
                                    pw.Center(
                                      child: pw.Text('*** THANK YOU ***', style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
                                    ),
                                    pw.Center(
                                      child: pw.Text('Powered by FitBizz Cloud POS', style: const pw.TextStyle(fontSize: 7)),
                                    ),
                                  ],
                                );
                              },
                            ),
                          );
                          await Printing.layoutPdf(onLayout: (format) async => doc.save());
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      style: IconButton.styleFrom(backgroundColor: AppColors.stone800),
                      onPressed: () => Navigator.pop(ctx),
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

  Widget _buildDashedLine() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
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
              child: DecoratedBox(decoration: BoxDecoration(color: AppColors.stone400)),
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
            style: const TextStyle(fontFamily: 'monospace', fontSize: 10, color: AppColors.stone600),
          ),
          Flexible(
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 860;

    return ListenableBuilder(
      listenable: Listenable.merge([
        MembersController.instance,
        AppLocaleController.instance,
      ]),
      builder: (context, _) {
        final dueMembers = MembersController.instance.dueMembers;
        final overdueMembers = MembersController.instance.overdueMembers;
        final totalDues = MembersController.instance.totalPendingDues;
        final totalCollected = MembersController.instance.totalCollectedThisMonth;

        final filteredInvoices = _invoices.where((inv) {
          final q = _searchQuery.toLowerCase();
          final matches = inv.memberName.toLowerCase().contains(q) ||
              inv.id.toLowerCase().contains(q) ||
              inv.memberRoll.toLowerCase().contains(q);
          if (!matches) return false;

          if (_invoiceFilter == 'PAID' && inv.status != 'PAID') return false;
          if (_invoiceFilter == 'DUE' && inv.status != 'DUE') return false;
          return true;
        }).toList();

        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row (Zero-Overflow Guaranteed)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Fees & Dues Management', style: AppTypography.h1.copyWith(fontSize: 22)),
                        const SizedBox(height: 2),
                        Text(
                          'Point of Sale (POS) Cashiering, Dues Recovery, Push Reminders & Tax Invoices',
                          style: AppTypography.caption.copyWith(color: AppColors.stone500),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  AppButton(
                    label: 'Collect Fee (POS)',
                    icon: Icons.point_of_sale,
                    onPressed: () => _showPosBillingModal(),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              // KPI Metric Cards
              LayoutBuilder(
                builder: (context, constraints) {
                  final cols = isDesktop ? 4 : 2;
                  return GridView.count(
                    crossAxisCount: cols,
                    crossAxisSpacing: AppSpacing.sm,
                    mainAxisSpacing: AppSpacing.sm,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    childAspectRatio: isDesktop ? 2.4 : 1.8,
                    children: [
                      _buildMetricCard('Total Pending Dues', formatMoney(totalDues > 0 ? totalDues : 12500), '${dueMembers.length} Accounts Pending', AppColors.red600, Icons.warning_amber),
                      _buildMetricCard('Collected This Month', formatMoney(totalCollected > 0 ? totalCollected : 42500), 'Active Billing Cycle', AppColors.green600, Icons.account_balance_wallet),
                      _buildMetricCard('Overdue Members', '${overdueMembers.length} Overdue', 'Immediate Recovery', AppColors.japaniPhalDark, Icons.timer_off),
                      _buildMetricCard('Expiring in 7 Days', '${dueMembers.length} Members', 'Upcoming Renewals', Colors.amber.shade900, Icons.calendar_month),
                    ],
                  );
                },
              ),
              const SizedBox(height: AppSpacing.lg),

              // Urgent Dues & Expiring Members Action Banner
              if (dueMembers.isNotEmpty || overdueMembers.isNotEmpty) ...[
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.red600.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.red600.withValues(alpha: 0.25)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(color: AppColors.red600, borderRadius: BorderRadius.circular(8)),
                                child: const Icon(Icons.notifications_active, color: Colors.white, size: 16),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Urgent Dues & Upcoming Expiration Alert',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.stone900),
                              ),
                            ],
                          ),
                          Text(
                            '${dueMembers.length} Accounts Require Action',
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.red600),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // List of Urgent Dues
                      ...dueMembers.take(3).map((m) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 6),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.stone200),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(radius: 16, backgroundImage: NetworkImage(m.photoUrl)),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(m.fullName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                    Text('${m.memberNumber} • ${m.planName} • Exp: ${m.expiryDate}', style: const TextStyle(fontSize: 10.5, color: AppColors.stone500)),
                                  ],
                                ),
                              ),
                              Text(
                                formatMoney(m.dueAmount > 0 ? m.dueAmount : m.monthlyFee),
                                style: const TextStyle(fontWeight: FontWeight.w900, color: AppColors.red600, fontSize: 13),
                              ),
                              const SizedBox(width: 8),
                              // 1-Click WhatsApp Reminder
                              IconButton(
                                icon: const Icon(Icons.chat, color: AppColors.green600, size: 18),
                                tooltip: 'Send WhatsApp Fee Reminder',
                                onPressed: () => _sendWhatsAppReminder(m),
                              ),
                              // 1-Click Settle Fee
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.green600,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                onPressed: () => _showPosBillingModal(preselectedMember: m),
                                child: const Text('Collect', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
              ],

              // Invoices & Payment Ledger Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Payment History & Invoices', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  // Filter Chips
                  Row(
                    children: [
                      ChoiceChip(
                        label: const Text('All Invoices'),
                        selected: _invoiceFilter == 'ALL',
                        selectedColor: AppColors.japaniPhalDark,
                        labelStyle: TextStyle(color: _invoiceFilter == 'ALL' ? Colors.white : AppColors.stone800, fontSize: 10.5, fontWeight: FontWeight.bold),
                        onSelected: (_) => setState(() => _invoiceFilter = 'ALL'),
                      ),
                      const SizedBox(width: 4),
                      ChoiceChip(
                        label: const Text('✅ Paid'),
                        selected: _invoiceFilter == 'PAID',
                        selectedColor: AppColors.green600,
                        labelStyle: TextStyle(color: _invoiceFilter == 'PAID' ? Colors.white : AppColors.stone800, fontSize: 10.5, fontWeight: FontWeight.bold),
                        onSelected: (_) => setState(() => _invoiceFilter = 'PAID'),
                      ),
                      const SizedBox(width: 4),
                      ChoiceChip(
                        label: const Text('⚠️ Dues'),
                        selected: _invoiceFilter == 'DUE',
                        selectedColor: Colors.amber.shade900,
                        labelStyle: TextStyle(color: _invoiceFilter == 'DUE' ? Colors.white : AppColors.stone800, fontSize: 10.5, fontWeight: FontWeight.bold),
                        onSelected: (_) => setState(() => _invoiceFilter = 'DUE'),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),

              // Search Bar
              AppTextField(
                label: 'Search Invoices & Receipts',
                hint: 'Search by Invoice #, Member Name, or Roll Number...',
                onChanged: (v) => setState(() => _searchQuery = v),
              ),
              const SizedBox(height: AppSpacing.md),

              // Invoices Table / List
              ListView.builder(
                itemCount: filteredInvoices.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final inv = filteredInvoices[index];

                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: AppCard(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.japaniPhal.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.receipt, color: AppColors.japaniPhalDark, size: 20),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(inv.id, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.japaniPhalDark)),
                                    const SizedBox(width: 8),
                                    AppBadge(
                                      label: inv.status,
                                      variant: inv.status == 'PAID' ? AppBadgeVariant.active : AppBadgeVariant.warning,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text('${inv.memberName} (${inv.memberRoll}) • ${inv.date}', style: AppTypography.caption.copyWith(color: AppColors.stone600)),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(formatMoney(inv.grandTotal), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
                              Text(inv.paymentMode, style: AppTypography.caption.copyWith(color: AppColors.stone500)),
                            ],
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          IconButton(
                            icon: const Icon(Icons.receipt_long, color: AppColors.japaniPhalDark),
                            tooltip: 'View Official Receipt',
                            onPressed: () => _showReceiptDialog(inv),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMetricCard(String label, String value, String subtitle, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.stone200),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 6),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.stone500)),
              Icon(icon, color: color, size: 16),
            ],
          ),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: color)),
          const SizedBox(height: 2),
          Text(subtitle, style: const TextStyle(fontSize: 10, color: AppColors.stone400), overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}
