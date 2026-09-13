import 'package:flutter/material.dart';

import '../../core/localization/app_locale.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/app_logo.dart';
import '../../core/widgets/app_toast.dart';
import '../auth/auth_state.dart';
import '../dashboard/dashboard_screen.dart';
import '../members/member_list_screen.dart';
import '../reception/reception_screen.dart';
import '../billing/billing_screen.dart';
import '../plans/membership_plans_screen.dart';
import '../attendance/attendance_screen.dart';

class MainNavigationShell extends StatefulWidget {
  final AuthState authState;
  final VoidCallback? onReturnToSuperAdmin;

  const MainNavigationShell({
    super.key,
    required this.authState,
    this.onReturnToSuperAdmin,
  });

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _selectedIndex = 0;
  bool _isSyncing = false;
  bool _isDarkSidebar = false;
  bool _isSidebarCollapsed = false;

  void _triggerManualSync() async {
    setState(() {
      _isSyncing = true;
    });
    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) {
      setState(() {
        _isSyncing = false;
      });
      AppToast.showSync(
        context,
        tr('sync'),
        tr('local_engine_active'),
      );
    }
  }

  List<NavigationItemConfig> _getAvailableNavItems() {
    final role = widget.authState.userRole;
    final List<NavigationItemConfig> items = [];

    // 1. Executive Dashboard
    if (widget.authState.canAccessDashboard) {
      items.add(NavigationItemConfig(
        icon: Icons.dashboard_outlined,
        activeIcon: Icons.dashboard,
        labelKey: 'nav_dashboard',
        badge: 'HQ',
        screen: DashboardScreen(
          onNavigateToReception: () {
            final idx = items.indexWhere((i) => i.labelKey.contains('reception'));
            if (idx != -1) setState(() => _selectedIndex = idx);
          },
          onNavigateToMembers: () {
            final idx = items.indexWhere((i) => i.labelKey.contains('members'));
            if (idx != -1) setState(() => _selectedIndex = idx);
          },
        ),
      ));
    }

    // 2. Reception Terminal
    if (widget.authState.canAccessReception) {
      items.add(const NavigationItemConfig(
        icon: Icons.qr_code_scanner,
        activeIcon: Icons.qr_code_scanner,
        labelKey: 'nav_reception',
        badge: 'Live',
        screen: ReceptionScreen(),
      ));
    }

    // 3. Members Directory
    if (widget.authState.canAccessMembers) {
      items.add(NavigationItemConfig(
        icon: Icons.people_outline,
        activeIcon: Icons.people,
        labelKey: role == UserRole.trainer ? 'nav_trainers' : 'nav_members',
        badge: '450',
        screen: const MemberListScreen(),
      ));

      // 3b. Attendance & Biometrics
      items.add(const NavigationItemConfig(
        icon: Icons.how_to_reg_outlined,
        activeIcon: Icons.how_to_reg,
        labelKey: 'nav_attendance',
        label: 'Attendance & Biometrics',
        badge: 'Live',
        screen: AttendanceScreen(),
      ));
    }

    // 4. Membership Plans & Packages (Owner, Super Admin, Billing Staff)
    if (widget.authState.isOwner || widget.authState.isSuperAdmin || widget.authState.canAccessBilling) {
      items.add(const NavigationItemConfig(
        icon: Icons.card_membership_outlined,
        activeIcon: Icons.card_membership,
        labelKey: 'nav_subscriptions',
        screen: MembershipPlansScreen(),
      ));
    }

    // 5. Fee Ledger & Billing
    if (widget.authState.canAccessBilling) {
      items.add(const NavigationItemConfig(
        icon: Icons.receipt_long_outlined,
        activeIcon: Icons.receipt_long,
        labelKey: 'nav_billing',
        badge: '3 Due',
        screen: BillingScreen(),
      ));
    }

    // 5. Member Self-Service View
    if (widget.authState.isMember) {
      items.add(const NavigationItemConfig(
        icon: Icons.qr_code_2,
        activeIcon: Icons.qr_code_2,
        labelKey: 'nav_reception',
        screen: ReceptionScreen(),
      ));
      items.add(const NavigationItemConfig(
        icon: Icons.account_circle_outlined,
        activeIcon: Icons.account_circle,
        labelKey: 'nav_members',
        screen: MemberListScreen(),
      ));
    }

    if (items.isEmpty) {
      items.add(NavigationItemConfig(
        icon: Icons.dashboard_outlined,
        activeIcon: Icons.dashboard,
        labelKey: 'nav_dashboard',
        screen: DashboardScreen(
          onNavigateToReception: () {},
          onNavigateToMembers: () {},
        ),
      ));
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    final navItems = _getAvailableNavItems();
    if (_selectedIndex >= navItems.length) {
      _selectedIndex = 0;
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 950;

    return ListenableBuilder(
      listenable: AppLocaleController.instance,
      builder: (context, _) {
        if (isDesktop) {
          return Scaffold(
            body: Row(
              children: [
                // Clean Non-congested Sidebar with Language & Day/Night switcher
                _buildSidebar(navItems),

                // Main Workspace Area
                Expanded(
                  child: Column(
                    children: [
                      _buildTopHeader(navItems),
                      Expanded(
                        child: navItems[_selectedIndex].screen,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        // Mobile / Tablet Layout (< 950px)
        return Scaffold(
          appBar: _buildMobileAppBar(navItems),
          drawer: Drawer(
            child: _buildSidebar(navItems, isDrawer: true),
          ),
          body: navItems[_selectedIndex].screen,
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedIndex < 4 ? _selectedIndex : 0,
            onTap: (idx) {
              if (idx < navItems.length) {
                setState(() => _selectedIndex = idx);
              }
            },
            selectedItemColor: AppColors.japaniPhalDark,
            unselectedItemColor: AppColors.stone500,
            type: BottomNavigationBarType.fixed,
            items: navItems.take(4).map((item) {
              return BottomNavigationBarItem(
                icon: Icon(item.icon),
                activeIcon: Icon(item.activeIcon),
                label: item.displayLabel.split(' / ').first,
              );
            }).toList(),
          ),
        );
      },
    );
  }

  /// Refined Non-congested Sidebar (Zero Overflow, Day/Night at Top, Sleek Sync)
  Widget _buildSidebar(List<NavigationItemConfig> navItems, {bool isDrawer = false}) {
    final bgColor = _isDarkSidebar ? AppColors.stone900 : Colors.white;
    final borderColor = _isDarkSidebar ? AppColors.stone800 : AppColors.stone200;
    final titleColor = _isDarkSidebar ? Colors.white : AppColors.stone900;
    final unselectedTextColor = _isDarkSidebar ? AppColors.stone400 : AppColors.stone600;
    final unselectedIconColor = _isDarkSidebar ? AppColors.stone400 : AppColors.stone500;

    final width = isDrawer ? double.infinity : (_isSidebarCollapsed ? 68.0 : 260.0);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      width: width,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(right: BorderSide(color: borderColor)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Top Header (Logo + Tenant Title + Day/Night Mode + Collapse Button)
          Container(
            height: 60,
            padding: EdgeInsets.symmetric(horizontal: _isSidebarCollapsed && !isDrawer ? 6 : 12),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: borderColor)),
            ),
            child: Row(
              mainAxisAlignment: _isSidebarCollapsed && !isDrawer ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween,
              children: [
                if (_isSidebarCollapsed && !isDrawer) ...[
                  Tooltip(
                    message: 'Expand Sidebar',
                    child: InkWell(
                      onTap: () => setState(() => _isSidebarCollapsed = false),
                      borderRadius: BorderRadius.circular(8),
                      child: const Padding(
                        padding: EdgeInsets.all(4),
                        child: AppLogo(size: 32),
                      ),
                    ),
                  ),
                ] else ...[
                  Row(
                    children: [
                      const AppLogo(size: 32),
                      const SizedBox(width: 10),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.authState.tenantName,
                            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: titleColor),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'Tenant: ${widget.authState.tenantId ?? "tenant-001"}',
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.japaniPhalDark),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Day / Night Mode Toggle (At Top)
                      InkWell(
                        onTap: () => setState(() => _isDarkSidebar = !_isDarkSidebar),
                        borderRadius: BorderRadius.circular(6),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                          decoration: BoxDecoration(
                            color: _isDarkSidebar ? AppColors.stone800 : AppColors.stone100,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: borderColor),
                          ),
                          child: Text(
                            _isDarkSidebar ? '🌙' : '☀️',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                      if (!isDrawer) ...[
                        const SizedBox(width: 4),
                        IconButton(
                          constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                          padding: EdgeInsets.zero,
                          icon: Icon(
                            Icons.keyboard_double_arrow_left,
                            size: 16,
                            color: unselectedIconColor,
                          ),
                          tooltip: 'Collapse Sidebar',
                          onPressed: () => setState(() => _isSidebarCollapsed = true),
                        ),
                      ],
                    ],
                  ),
                ],
              ],
            ),
          ),

          // Collapsed Top Quick Controls
          if (_isSidebarCollapsed && !isDrawer)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () => setState(() => _isDarkSidebar = !_isDarkSidebar),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: _isDarkSidebar ? AppColors.stone800 : AppColors.stone100,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(_isDarkSidebar ? '🌙' : '☀️', style: const TextStyle(fontSize: 11)),
                    ),
                  ),
                  const SizedBox(width: 4),
                  InkWell(
                    onTap: () => setState(() => _isSidebarCollapsed = false),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: _isDarkSidebar ? AppColors.stone800 : AppColors.stone100,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Icon(Icons.keyboard_double_arrow_right, size: 14, color: unselectedIconColor),
                    ),
                  ),
                ],
              ),
            ),

          // 2. Tenant Context & Role Badge (When not collapsed)
          if (!_isSidebarCollapsed || isDrawer) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 4),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.japaniPhal.withValues(alpha: _isDarkSidebar ? 0.15 : 0.07),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.japaniPhal.withValues(alpha: 0.25)),
                    ),
                    child: Row(
                      children: [
                        Icon(widget.authState.userRole.icon, size: 14, color: AppColors.japaniPhalDark),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            '${widget.authState.userRole.label} • ${widget.authState.branchName ?? "Gulberg Arena"}',
                            style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: titleColor),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (widget.onReturnToSuperAdmin != null) ...[
                    const SizedBox(height: 4),
                    InkWell(
                      onTap: widget.onReturnToSuperAdmin,
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                        decoration: BoxDecoration(
                          color: _isDarkSidebar ? AppColors.darkSurfaceElevated : AppColors.stone100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Text('🏢', style: TextStyle(fontSize: 11)),
                            const SizedBox(width: 6),
                            Text(
                              tr('back_to_super_admin'),
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: titleColor),
                            ),
                            const Spacer(),
                            const Icon(Icons.chevron_right, size: 13, color: AppColors.japaniPhalDark),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],

          const SizedBox(height: 2),

          // 3. Navigation Links (Translated dynamically)
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              itemCount: navItems.length,
              itemBuilder: (context, idx) {
                final item = navItems[idx];
                final isSelected = _selectedIndex == idx;

                if (_isSidebarCollapsed && !isDrawer) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Center(
                      child: Tooltip(
                        message: item.displayLabel,
                        child: InkWell(
                          onTap: () => setState(() => _selectedIndex = idx),
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.japaniPhalDark : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              isSelected ? item.activeIcon : item.icon,
                              color: isSelected ? Colors.white : unselectedIconColor,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }

                return Container(
                  margin: const EdgeInsets.only(bottom: 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    gradient: isSelected
                        ? const LinearGradient(
                            colors: [AppColors.japaniPhal, AppColors.japaniPhalDark],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                    color: !isSelected && !_isDarkSidebar ? Colors.transparent : null,
                  ),
                  child: ListTile(
                    dense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                    visualDensity: const VisualDensity(horizontal: 0, vertical: -2),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    leading: Icon(
                      isSelected ? item.activeIcon : item.icon,
                      color: isSelected ? Colors.white : unselectedIconColor,
                      size: 18,
                    ),
                    title: Text(
                      item.displayLabel,
                      style: TextStyle(
                        color: isSelected ? Colors.white : unselectedTextColor,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: item.badge != null
                        ? Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.white.withValues(alpha: 0.25)
                                  : (_isDarkSidebar ? AppColors.stone800 : AppColors.stone100),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              item.badge!,
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : (_isDarkSidebar ? AppColors.stone400 : AppColors.japaniPhalDark),
                                fontSize: 9.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        : null,
                    onTap: () {
                      setState(() => _selectedIndex = idx);
                      if (isDrawer) Navigator.pop(context);
                    },
                  ),
                );
              },
            ),
          ),

          // 4. Ultra-Sleek Minimalist Local Sync Pill
          if (!_isSidebarCollapsed || isDrawer) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  color: _isDarkSidebar ? AppColors.darkSurfaceElevated : AppColors.stone50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: borderColor),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _isSyncing ? AppColors.amber500 : AppColors.green600,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        _isSyncing ? 'Syncing...' : tr('local_engine_active'),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: _isSyncing ? AppColors.amber500 : (_isDarkSidebar ? AppColors.stone300 : AppColors.stone700),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    InkWell(
                      onTap: _isSyncing ? null : _triggerManualSync,
                      borderRadius: BorderRadius.circular(4),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.japaniPhalDark,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          tr('force_sync'),
                          style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ] else ...[
            // Collapsed Sync Icon
            Center(
              child: Tooltip(
                message: tr('force_sync'),
                child: IconButton(
                  icon: Icon(
                    Icons.sync,
                    size: 18,
                    color: _isSyncing ? AppColors.amber500 : AppColors.green600,
                  ),
                  onPressed: _isSyncing ? null : _triggerManualSync,
                ),
              ),
            ),
          ],

          // 5. User Profile Card
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: borderColor)),
            ),
            child: Row(
              mainAxisAlignment: _isSidebarCollapsed && !isDrawer ? MainAxisAlignment.center : MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 13,
                  backgroundColor: AppColors.japaniPhalDark,
                  child: Text(
                    widget.authState.fullName.isNotEmpty ? widget.authState.fullName[0].toUpperCase() : 'O',
                    style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
                if (!_isSidebarCollapsed || isDrawer) ...[
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.authState.fullName,
                          style: TextStyle(color: titleColor, fontWeight: FontWeight.bold, fontSize: 11),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          widget.authState.email ?? 'owner@metrofitness.com',
                          style: TextStyle(color: unselectedTextColor, fontSize: 9),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.logout, color: AppColors.stone400, size: 16),
                    tooltip: tr('sign_out'),
                    onPressed: () => widget.authState.logout(),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Desktop Top Header Bar (With Universal Language Selector)
  Widget _buildTopHeader(List<NavigationItemConfig> navItems) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.stone200)),
      ),
      child: Row(
        children: [
          // Sidebar Toggle Button
          IconButton(
            icon: Icon(
              _isSidebarCollapsed ? Icons.menu : Icons.menu_open,
              size: 20,
              color: AppColors.stone700,
            ),
            tooltip: _isSidebarCollapsed ? 'Expand Sidebar' : 'Collapse Sidebar',
            onPressed: () => setState(() => _isSidebarCollapsed = !_isSidebarCollapsed),
          ),
          const SizedBox(width: 4),

          // Breadcrumb / Screen Title
          Icon(navItems[_selectedIndex].icon, size: 17, color: AppColors.japaniPhalDark),
          const SizedBox(width: 8),
          Text(
            navItems[_selectedIndex].displayLabel,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5, color: AppColors.stone900),
          ),
          const SizedBox(width: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
            decoration: BoxDecoration(
              color: AppColors.japaniPhal.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              widget.authState.tenantName,
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.japaniPhalDark),
            ),
          ),

          const Spacer(),

          // 14 Days Remaining Pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3.5),
            decoration: BoxDecoration(
              color: AppColors.amber500.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: AppColors.amber500.withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.hourglass_top, size: 12, color: AppColors.amber500),
                const SizedBox(width: 4),
                Text(tr('pro_trial_remaining'), style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: AppColors.amber500)),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),

          // Branch Pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3.5),
            decoration: BoxDecoration(
              color: AppColors.stone50,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: AppColors.stone200),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.location_on, size: 12, color: AppColors.japaniPhalDark),
                const SizedBox(width: 4),
                Text(
                  widget.authState.branchName ?? 'Gulberg Main Arena',
                  style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: AppColors.stone700),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),

          // Dedicated Universal Language Selector
          const AppLanguageSelector(),
        ],
      ),
    );
  }

  /// Mobile App Bar
  PreferredSizeWidget _buildMobileAppBar(List<NavigationItemConfig> navItems) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.5,
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.menu, color: AppColors.stone800),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.authState.tenantName,
            style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: AppColors.stone900),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            '${navItems[_selectedIndex].displayLabel} • ${widget.authState.branchName ?? "HQ"}',
            style: const TextStyle(fontSize: 10, color: AppColors.stone500),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.sync, color: _isSyncing ? AppColors.amber500 : AppColors.japaniPhalDark, size: 19),
          tooltip: tr('force_sync'),
          onPressed: _triggerManualSync,
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 6),
          child: AppLanguageSelector(compact: true),
        ),
      ],
    );
  }
}

class NavigationItemConfig {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final String labelKey;
  final String? badge;
  final Widget screen;

  const NavigationItemConfig({
    required this.icon,
    required this.activeIcon,
    this.label = '',
    required this.labelKey,
    this.badge,
    required this.screen,
  });

  String get displayLabel {
    final translated = tr(labelKey);
    if (translated != labelKey && translated.isNotEmpty) return translated;
    if (label.isNotEmpty) return label;
    return translated;
  }
}
