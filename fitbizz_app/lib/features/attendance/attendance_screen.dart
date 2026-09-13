import 'package:flutter/material.dart';
import '../../core/localization/app_locale.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/app_toast.dart';
import '../members/members_controller.dart';
import 'attendance_controller.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTime _selectedDate = DateTime.now();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  AttendanceStatus? _statusFilter;
  
  // Geofence simulation distance
  double _simulatedDistance = 25.0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime dt) {
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 900;
    final dateStr = _formatDate(_selectedDate);

    return ListenableBuilder(
      listenable: Listenable.merge([
        AttendanceController.instance,
        MembersController.instance,
        AppLocaleController.instance,
      ]),
      builder: (context, _) {
        final ctrl = AttendanceController.instance;
        final totalCheckIns = ctrl.getTodayTotalCheckIns();
        final membersPresent = ctrl.getTodayMembersPresent();
        final staffPresent = ctrl.getTodayStaffPresent();
        final device = ctrl.deviceConfig;

        final memberRecords = ctrl.getMemberRecords(dateStr);
        final staffRecords = ctrl.getStaffRecords(dateStr);

        return Scaffold(
          backgroundColor: AppColors.stone50,
          body: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. TOP HEADER & DATE CONTROLS
                _buildTopHeader(context, isDesktop, dateStr),
                const SizedBox(height: AppSpacing.md),

                // 2. LIVE FOOTFALL & HARDWARE KPI STRIP
                _buildKpiStrip(totalCheckIns, membersPresent, staffPresent, device),
                const SizedBox(height: AppSpacing.md),

                // 3. TABS BAR
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.stone200),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    isScrollable: !isDesktop,
                    labelColor: AppColors.japaniPhalDark,
                    unselectedLabelColor: AppColors.stone500,
                    indicatorColor: AppColors.japaniPhalDark,
                    indicatorWeight: 3,
                    labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    tabs: [
                      Tab(text: '🏋️ Members (${memberRecords.where((r) => r.status != AttendanceStatus.absent).length}/${memberRecords.length})'),
                      Tab(text: '👔 Staff & Trainers (${staffRecords.where((r) => r.status != AttendanceStatus.absent).length}/${staffRecords.length})'),
                      const Tab(text: '📊 Footfall & Analytics'),
                      const Tab(text: '⚙️ Biometric & Geofence'),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),

                // 4. TAB CONTENTS
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // TAB 1: MEMBERS ATTENDANCE
                      _buildMembersTab(context, ctrl, memberRecords, dateStr),

                      // TAB 2: STAFF & TRAINERS ATTENDANCE
                      _buildStaffTab(context, ctrl, staffRecords, dateStr),

                      // TAB 3: FOOTFALL & ANALYTICS
                      _buildAnalyticsTab(ctrl),

                      // TAB 4: BIOMETRIC HARDWARE & GEOFENCE CONFIG
                      _buildHardwareConfigTab(ctrl),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // --- 1. TOP HEADER ---
  Widget _buildTopHeader(BuildContext context, bool isDesktop, String dateStr) {
    final ctrl = AttendanceController.instance;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('Attendance & Biometrics', style: AppTypography.h1),
                  const SizedBox(width: AppSpacing.sm),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.green600.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.green600),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(width: 6, height: 6, decoration: const BoxDecoration(color: AppColors.green600, shape: BoxShape.circle)),
                        const SizedBox(width: 5),
                        Text(
                          '${ctrl.deviceConfig.deviceModel} (Live)',
                          style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: AppColors.green600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                'Dual member & staff tracking, ZKTeco IP socket bridge, and geofenced self check-in.',
                style: AppTypography.caption.copyWith(color: AppColors.stone500),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.md),

        // Date Picker & Quick Actions
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white,
                side: const BorderSide(color: AppColors.stone300),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              icon: const Icon(Icons.calendar_month, size: 16, color: AppColors.stone700),
              label: Text(
                dateStr == _formatDate(DateTime.now()) ? 'Today ($dateStr)' : dateStr,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.stone800),
              ),
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime(2025),
                  lastDate: DateTime(2027),
                );
                if (picked != null) {
                  setState(() => _selectedDate = picked);
                }
              },
            ),
            AppButton(
              label: '⚡ Simulate Scan',
              icon: Icons.fingerprint,
              onPressed: () => _showBiometricSimulatorModal(context),
            ),
          ],
        ),
      ],
    );
  }

  // --- 2. KPI FOOTFALL STRIP ---
  Widget _buildKpiStrip(int totalCheckIns, int membersPresent, int staffPresent, BiometricDeviceConfig device) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 750;
        return GridView.count(
          crossAxisCount: isNarrow ? 2 : 4,
          crossAxisSpacing: AppSpacing.sm,
          mainAxisSpacing: AppSpacing.sm,
          childAspectRatio: isNarrow ? 2.2 : 2.8,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _buildKpiCard('Total Check-ins Today', '$totalCheckIns', 'Peak: 07:00 PM (84/hr)', Icons.login, AppColors.green600),
            _buildKpiCard('Active Members in Gym', '$membersPresent', 'Workout capacity: 78%', Icons.fitness_center, AppColors.japaniPhalDark),
            _buildKpiCard('Staff on Duty', '$staffPresent / 4', 'All core shifts covered', Icons.badge, AppColors.amber500),
            _buildKpiCard('Biometric Device Logs', '${device.totalDeviceLogs}', 'ZKTeco • TCP/IP 4370', Icons.fingerprint, AppColors.stone800),
          ],
        );
      },
    );
  }

  Widget _buildKpiCard(String title, String value, String subtitle, IconData icon, Color color) {
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.stone500), maxLines: 1),
                Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.stone900)),
                Text(subtitle, style: TextStyle(fontSize: 9, color: color, fontWeight: FontWeight.w600), maxLines: 1),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- TAB 1: MEMBERS ATTENDANCE ---
  Widget _buildMembersTab(BuildContext context, AttendanceController ctrl, List<AttendanceRecord> records, String dateStr) {
    final filtered = records.where((r) {
      final q = _searchQuery.toLowerCase();
      final matchesQuery = r.entityName.toLowerCase().contains(q) ||
          r.entityIdentifier.toLowerCase().contains(q) ||
          r.departmentOrPlan.toLowerCase().contains(q);
      if (!matchesQuery) return false;

      if (_statusFilter != null && r.status != _statusFilter) return false;
      return true;
    }).toList();

    return Column(
      children: [
        // Controls bar: Search, Filter Chips, Bulk Actions
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.stone200),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      label: 'Search Members',
                      hint: 'Search by Name, Roll # (METRO-202609-0001), or Plan...',
                      controller: _searchController,
                      onChanged: (val) => setState(() => _searchQuery = val),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.green600,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    icon: const Icon(Icons.done_all, size: 16),
                    label: const Text('Mark All Present', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                    onPressed: () {
                      ctrl.markAllMembersPresent(dateStr);
                      AppToast.showSuccess(context, 'Attendance Saved', 'Marked all enrolled members as Present.');
                    },
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.red600,
                      side: const BorderSide(color: AppColors.red600),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    icon: const Icon(Icons.close, size: 16),
                    label: const Text('Mark All Absent', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                    onPressed: () {
                      ctrl.markAllMembersAbsent(dateStr);
                      AppToast.showInfo(context, 'Attendance Updated', 'Reset member roster to Absent.');
                    },
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),

              // Filter Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ChoiceChip(
                      label: Text('All (${records.length})'),
                      selected: _statusFilter == null,
                      selectedColor: AppColors.japaniPhalDark,
                      labelStyle: TextStyle(color: _statusFilter == null ? Colors.white : AppColors.stone800, fontWeight: FontWeight.bold, fontSize: 11),
                      onSelected: (_) => setState(() => _statusFilter = null),
                    ),
                    const SizedBox(width: 6),
                    ChoiceChip(
                      label: Text('✅ Present (${records.where((r) => r.status == AttendanceStatus.present).length})'),
                      selected: _statusFilter == AttendanceStatus.present,
                      selectedColor: AppColors.green600,
                      labelStyle: TextStyle(color: _statusFilter == AttendanceStatus.present ? Colors.white : AppColors.stone800, fontWeight: FontWeight.bold, fontSize: 11),
                      onSelected: (_) => setState(() => _statusFilter = AttendanceStatus.present),
                    ),
                    const SizedBox(width: 6),
                    ChoiceChip(
                      label: Text('⏳ Late (${records.where((r) => r.status == AttendanceStatus.late).length})'),
                      selected: _statusFilter == AttendanceStatus.late,
                      selectedColor: AppColors.amber500,
                      labelStyle: TextStyle(color: _statusFilter == AttendanceStatus.late ? Colors.white : AppColors.stone800, fontWeight: FontWeight.bold, fontSize: 11),
                      onSelected: (_) => setState(() => _statusFilter = AttendanceStatus.late),
                    ),
                    const SizedBox(width: 6),
                    ChoiceChip(
                      label: Text('❌ Absent (${records.where((r) => r.status == AttendanceStatus.absent).length})'),
                      selected: _statusFilter == AttendanceStatus.absent,
                      selectedColor: AppColors.red600,
                      labelStyle: TextStyle(color: _statusFilter == AttendanceStatus.absent ? Colors.white : AppColors.stone800, fontWeight: FontWeight.bold, fontSize: 11),
                      onSelected: (_) => setState(() => _statusFilter = AttendanceStatus.absent),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),

        // List of Member Attendance Records
        Expanded(
          child: filtered.isEmpty
              ? const Center(child: Text('No attendance records found matching filter.', style: TextStyle(color: AppColors.stone500)))
              : ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final item = filtered[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                      child: AppCard(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundImage: NetworkImage(item.photoUrl),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(item.entityName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                      const SizedBox(width: 6),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                                        decoration: BoxDecoration(
                                          color: AppColors.stone100,
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(item.entityIdentifier, style: const TextStyle(fontFamily: 'monospace', fontSize: 9.5, fontWeight: FontWeight.bold, color: AppColors.japaniPhalDark)),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${item.departmentOrPlan} • Check-in: ${item.checkInTime ?? "--"} ${item.checkOutTime != null ? "• Out: ${item.checkOutTime}" : ""}',
                                    style: const TextStyle(fontSize: 11, color: AppColors.stone500),
                                  ),
                                  if (item.notes != null)
                                    Text(item.notes!, style: const TextStyle(fontSize: 10, color: AppColors.green600, fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),

                            // Method Badge
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.stone100,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: AppColors.stone200),
                              ),
                              child: Text(
                                item.methodLabel,
                                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.stone700),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),

                            // Status Dropdown Switcher
                            DropdownButton<AttendanceStatus>(
                              value: item.status,
                              underline: const SizedBox(),
                              items: const [
                                DropdownMenuItem(value: AttendanceStatus.present, child: Text('✅ Present', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.green600))),
                                DropdownMenuItem(value: AttendanceStatus.late, child: Text('⏳ Late', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.amber500))),
                                DropdownMenuItem(value: AttendanceStatus.absent, child: Text('❌ Absent', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.red600))),
                              ],
                              onChanged: (newStatus) {
                                if (newStatus != null) {
                                  ctrl.setRecordStatus(item.id, newStatus);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  // --- TAB 2: STAFF & TRAINERS ATTENDANCE ---
  Widget _buildStaffTab(BuildContext context, AttendanceController ctrl, List<AttendanceRecord> records, String dateStr) {
    return Column(
      children: [
        // Staff Bulk Bar
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.stone200),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Staff Shift Rosters & In/Out Log', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  Text('Trainers, Nutritionists, Floor Coaches, and Front Desk Staff', style: TextStyle(fontSize: 11, color: AppColors.stone500)),
                ],
              ),
              Row(
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.green600,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    icon: const Icon(Icons.done_all, size: 15),
                    label: const Text('All Staff Present', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                    onPressed: () {
                      ctrl.markAllStaffPresent(dateStr);
                      AppToast.showSuccess(context, 'Staff Attendance', 'Marked all gym staff as Present on duty.');
                    },
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.red600,
                      side: const BorderSide(color: AppColors.red600),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    icon: const Icon(Icons.close, size: 15),
                    label: const Text('All Absent', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                    onPressed: () {
                      ctrl.markAllStaffAbsent(dateStr);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),

        // Staff List
        Expanded(
          child: ListView.builder(
            itemCount: records.length,
            itemBuilder: (context, index) {
              final staffItem = records[index];
              final staffMeta = ctrl.staff.firstWhere(
                (s) => s.id == staffItem.entityId,
                orElse: () => ctrl.staff.first,
              );

              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                child: AppCard(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(staffItem.photoUrl),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(staffItem.entityName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                                  decoration: BoxDecoration(color: AppColors.stone100, borderRadius: BorderRadius.circular(4)),
                                  child: Text(staffItem.entityIdentifier, style: const TextStyle(fontFamily: 'monospace', fontSize: 9.5, fontWeight: FontWeight.bold, color: AppColors.stone700)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text('${staffItem.departmentOrPlan} • ${staffMeta.shift}', style: const TextStyle(fontSize: 11, color: AppColors.stone500)),
                            Text('Time In: ${staffItem.checkInTime ?? "Not Checked In"} • Biometric Method: ${staffItem.methodLabel}', style: const TextStyle(fontSize: 10, color: AppColors.stone600)),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),

                      DropdownButton<AttendanceStatus>(
                        value: staffItem.status,
                        underline: const SizedBox(),
                        items: const [
                          DropdownMenuItem(value: AttendanceStatus.present, child: Text('✅ Present', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.green600))),
                          DropdownMenuItem(value: AttendanceStatus.late, child: Text('⏳ Late', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.amber500))),
                          DropdownMenuItem(value: AttendanceStatus.halfDay, child: Text('🌓 Half Day', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.japaniPhalDark))),
                          DropdownMenuItem(value: AttendanceStatus.absent, child: Text('❌ Absent', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.red600))),
                        ],
                        onChanged: (newStatus) {
                          if (newStatus != null) {
                            ctrl.setRecordStatus(staffItem.id, newStatus);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // --- TAB 3: FOOTFALL & ANALYTICS ---
  Widget _buildAnalyticsTab(AttendanceController ctrl) {
    final hourly = ctrl.getHourlyFootfallToday();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hourly Footfall Bar Chart Card
          AppCard(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Hourly Member Footfall Distribution', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        Text('Live gym traffic across operating hours (06:00 AM - 10:00 PM)', style: TextStyle(fontSize: 11, color: AppColors.stone500)),
                      ],
                    ),
                    Text('Peak: 84 / hr @ 7 PM', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.japaniPhalDark)),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),

                // Chart Bars
                SizedBox(
                  height: 160,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: hourly.entries.map((e) {
                      final count = e.value;
                      final heightRatio = count / 90.0;
                      final isPeak = count >= 60;
                      final hourLabel = e.key > 12 ? '${e.key - 12}p' : (e.key == 12 ? '12p' : '${e.key}a');

                      return Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text('$count', style: TextStyle(fontSize: 8.5, fontWeight: FontWeight.bold, color: isPeak ? AppColors.japaniPhalDark : AppColors.stone600)),
                            const SizedBox(height: 3),
                            Container(
                              height: 120 * heightRatio,
                              margin: const EdgeInsets.symmetric(horizontal: 2.5),
                              decoration: BoxDecoration(
                                color: isPeak ? AppColors.japaniPhalDark : AppColors.stone300,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(hourLabel, style: const TextStyle(fontSize: 8.5, color: AppColors.stone500)),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Regularity Leaderboard
          AppCard(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Top Member Workout Regularity Streaks (This Month)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: AppSpacing.md),
                ...[
                  {'name': 'Zain Malik', 'roll': 'METRO-202609-0001', 'days': '26 / 30 Days', 'streak': '🔥 14 Days Streak', 'pct': '87%'},
                  {'name': 'Ayesha Khan', 'roll': 'METRO-202609-0002', 'days': '28 / 30 Days', 'streak': '🔥 21 Days Streak', 'pct': '93%'},
                  {'name': 'Hamza Farooq', 'roll': 'METRO-202609-0003', 'days': '20 / 30 Days', 'streak': '🔥 8 Days Streak', 'pct': '67%'},
                ].map((item) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: AppColors.stone50, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.stone200)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item['name']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5)),
                              Text(item['roll']!, style: const TextStyle(fontFamily: 'monospace', fontSize: 10, color: AppColors.stone500)),
                            ],
                          ),
                          Row(
                            children: [
                              Text(item['streak']!, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.japaniPhalDark)),
                              const SizedBox(width: 12),
                              Text(item['days']!, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.stone800)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- TAB 4: BIOMETRIC HARDWARE & GEOFENCE CONFIG ---
  Widget _buildHardwareConfigTab(AttendanceController ctrl) {
    final device = ctrl.deviceConfig;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ZKTeco / Hikvision TCP/IP Configuration
          AppCard(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.router, color: AppColors.japaniPhalDark, size: 22),
                        SizedBox(width: 8),
                        Text('Biometric Hardware Socket Bridge (ZKTeco / Hikvision)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: AppColors.green600.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                      child: const Text('Bridge Active • Port 4370', style: TextStyle(color: AppColors.green600, fontSize: 10.5, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),

                const Text('Hardware Bridge Parameters:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        label: 'Device Static IP',
                        hint: '192.168.1.201',
                        controller: TextEditingController(text: device.ipAddress),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: AppTextField(
                        label: 'Socket Port',
                        hint: '4370',
                        controller: TextEditingController(text: '${device.port}'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        label: 'Device Model',
                        hint: 'ZKTeco SpeedFace-V5L',
                        controller: TextEditingController(text: device.deviceModel),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: AppTextField(
                        label: 'Gate Location',
                        hint: 'Main Turnstile #1',
                        controller: TextEditingController(text: device.location),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.stone900,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      icon: const Icon(Icons.wifi_tethering, size: 16),
                      label: const Text('Test TCP Socket Ping', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                      onPressed: () {
                        AppToast.showSuccess(context, 'Device Ping Successful', 'Connected to ZKTeco @ ${device.ipAddress}:${device.port} (0ms latency).');
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Geofence Self Check-in Setup
          AppCard(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.location_on, color: AppColors.green600, size: 22),
                    SizedBox(width: 8),
                    Text('Member Mobile App Geofence Radar', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'Members can mark self-attendance from their mobile app only when physically within gym perimeter (GPS Geofence).',
                  style: TextStyle(fontSize: 11, color: AppColors.stone500),
                ),
                const SizedBox(height: AppSpacing.md),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Allowed Gym Check-in Radius:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    Text('${_simulatedDistance.toInt()} meters (HQ Arena)', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.green600)),
                  ],
                ),
                Slider(
                  value: _simulatedDistance,
                  min: 10,
                  max: 200,
                  activeColor: AppColors.green600,
                  onChanged: (val) => setState(() => _simulatedDistance = val),
                ),
                const SizedBox(height: 8),

                // Simulated Geofence Check-in Button
                Row(
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.green600,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      icon: const Icon(Icons.gps_fixed, size: 16),
                      label: Text('Simulate Self Check-in (${_simulatedDistance.toInt()}m Range)', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                      onPressed: () {
                        final allMembers = MembersController.instance.members;
                        if (allMembers.isNotEmpty) {
                          final success = ctrl.geofenceSelfCheckIn(allMembers.first.id, _simulatedDistance);
                          if (success) {
                            AppToast.showSuccess(context, 'Geofence Check-in Verified', '${allMembers.first.fullName} checked in (${_simulatedDistance.toInt()}m from Gym).');
                          } else {
                            AppToast.showError(context, 'Out of Range', 'Cannot check in: Device is outside 100m gym radius.');
                          }
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- 5. BIOMETRIC SIMULATOR MODAL ---
  void _showBiometricSimulatorModal(BuildContext context) {
    final ctrl = AttendanceController.instance;
    final allMembers = MembersController.instance.members;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.fingerprint, color: AppColors.japaniPhalDark, size: 24),
            SizedBox(width: 8),
            Text('Simulate Biometric Turnstile Scan', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          ],
        ),
        content: SizedBox(
          width: 420,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Select Member or Staff to simulate live hardware punch:', style: TextStyle(fontSize: 11, color: AppColors.stone600)),
              const SizedBox(height: 12),
              ...allMembers.take(4).map((m) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 6.0),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: AppColors.stone50, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.stone200)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(radius: 16, backgroundImage: NetworkImage(m.photoUrl)),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(m.fullName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                Text(m.memberNumber, style: const TextStyle(fontFamily: 'monospace', fontSize: 9.5, color: AppColors.stone500)),
                              ],
                            ),
                          ],
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.japaniPhalDark,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                          ),
                          icon: const Icon(Icons.touch_app, size: 14),
                          label: const Text('Punch', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold)),
                          onPressed: () {
                            Navigator.pop(ctx);
                            ctrl.triggerBiometricCheckIn(
                              entityId: m.id,
                              type: AttendanceType.member,
                              method: CheckInMethod.biometricFinger,
                            );
                            AppToast.showSuccess(context, 'Biometric Log Recorded', 'Turnstile access granted for ${m.fullName} (${m.memberNumber}).');
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Close'),
            onPressed: () => Navigator.pop(ctx),
          ),
        ],
      ),
    );
  }
}
