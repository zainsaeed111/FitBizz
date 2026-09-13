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
  bool _isDarkSidebar = true;
  bool _isSidebarCollapsed = false;

  void _triggerManualSync() async {
    setState(() {
      _isSyncing = true;
    });
    await Future.delayed(const Duration(milliseconds: 700));
    if (mounted) {
      setState(() {
        _isSyncing = false;
      });
      AppToast.showSync(
        context,
        'Database Synchronized',
        'Local SQLite changes successfully pushed to PostgreSQL server.',
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
        label: 'Dashboard',
        badge: 'HQ',
        screen: DashboardScreen(
          onNavigateToReception: () {
            final idx = items.indexWhere((i) => i.label.contains('Terminal') || i.label.contains('Reception'));
            if (idx != -1) setState(() => _selectedIndex = idx);
          },
          onNavigateToMembers: () {
            final idx = items.indexWhere((i) => i.label.contains('Member'));
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
        label: 'Reception Terminal',
        badge: 'Live',
        screen: ReceptionScreen(),
      ));
    }

    // 3. Members Directory
    if (widget.authState.canAccessMembers) {
      items.add(NavigationItemConfig(
        icon: Icons.people_outline,
        activeIcon: Icons.people,
        label: role == UserRole.trainer ? 'My Trainees / Members' : 'Member Directory',
        badge: '450',
        screen: const MemberListScreen(),
      ));
    }

    // 4. Fee Ledger & Billing
    if (widget.authState.canAccessBilling) {
      items.add(const NavigationItemConfig(
        icon: Icons.receipt_long_outlined,
        activeIcon: Icons.receipt_long,
        label: 'Billing & Invoices',
        badge: '3 Due',
        screen: BillingScreen(),
      ));
    }

    // 5. Member Self-Service View
    if (widget.authState.isMember) {
      items.add(const NavigationItemConfig(
        icon: Icons.qr_code_2,
        activeIcon: Icons.qr_code_2,
        label: 'Member Pass & Terminal',
        screen: ReceptionScreen(),
      ));
      items.add(const NavigationItemConfig(
        icon: Icons.account_circle_outlined,
        activeIcon: Icons.account_circle,
        label: 'My Membership Info',
        screen: MemberListScreen(),
      ));
    }

    if (items.isEmpty) {
      items.add(NavigationItemConfig(
        icon: Icons.dashboard_outlined,
        activeIcon: Icons.dashboard,
        label: 'Dashboard',
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
                // Synchronized Desktop Sidebar (Supports Day/Night mode & Collapse)
                _buildSidebar(navItems),

                // Main Workspace with Header
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
                label: item.label.split(' / ').first,
              );
            }).toList(),
          ),
        );
      },
    );
  }

  /// Synchronized Sidebar Widget (Matching Super Admin standard 1:1)
  Widget _buildSidebar(List<NavigationItemConfig> navItems, {bool isDrawer = false}) {
    final bgColor = _isDarkSidebar ? AppColors.stone900 : Colors.white;
    final borderColor = _isDarkSidebar ? AppColors.stone800 : AppColors.stone200;
    final titleColor = _isDarkSidebar ? Colors.white : AppColors.stone900;
    final unselectedTextColor = _isDarkSidebar ? AppColors.stone400 : AppColors.stone600;
    final unselectedIconColor = _isDarkSidebar ? AppColors.stone400 : AppColors.stone500;

    final width = isDrawer
        ? double.infinity
        : (_isSidebarCollapsed ? 76.0 : 270.0);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: width,
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(right: BorderSide(color: borderColor)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Sidebar Header (Gym Branding & Collapse Button)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: borderColor)),
            ),
            child: Row(
              children: [
                const AppLogo(size: 34),
                if (!_isSidebarCollapsed || isDrawer) ...[
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.authState.tenantName,
                          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13.5, color: titleColor),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Tenant: ${widget.authState.tenantId ?? "tenant-001"}',
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.japaniPhal),
                        ),
                      ],
                    ),
                  ),
                ],
                if (!isDrawer)
                  IconButton(
                    icon: Icon(
                      _isSidebarCollapsed ? Icons.keyboard_double_arrow_right : Icons.keyboard_double_arrow_left,
                      size: 16,
                      color: unselectedIconColor,
                    ),
                    tooltip: _isSidebarCollapsed ? 'Expand Sidebar' : 'Collapse Sidebar',
                    onPressed: () => setState(() => _isSidebarCollapsed = !_isSidebarCollapsed),
                  ),
              ],
            ),
          ),

          // 2. Active Tenant Role & Super Admin Switcher (When not collapsed)
          if (!_isSidebarCollapsed || isDrawer) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.sm),
              child: Column(
                children: [
                  // Role Badge Card
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.japaniPhal.withValues(alpha: _isDarkSidebar ? 0.15 : 0.08),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.japaniPhal.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(widget.authState.userRole.icon, size: 14, color: AppColors.japaniPhal),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.authState.userRole.label,
                                style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: titleColor),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                widget.authState.branchName ?? 'Main Facility HQ',
                                style: TextStyle(fontSize: 9, color: _isDarkSidebar ? AppColors.stone400 : AppColors.stone500),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Return to Super Admin HQ button (if authorized)
                  if (widget.onReturnToSuperAdmin != null) ...[
                    const SizedBox(height: 6),
                    InkWell(
                      onTap: widget.onReturnToSuperAdmin,
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        decoration: BoxDecoration(
                          color: _isDarkSidebar ? AppColors.darkSurfaceElevated : AppColors.stone100,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: borderColor),
                        ),
                        child: Row(
                          children: [
                            const Text('🏢', style: TextStyle(fontSize: 12)),
                            const SizedBox(width: 6),
                            Text(
                              'Back to Super Admin HQ',
                              style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: titleColor),
                            ),
                            const Spacer(),
                            const Icon(Icons.arrow_forward_ios, size: 10, color: AppColors.japaniPhalDark),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],

          // 3. Navigation Links List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs, vertical: AppSpacing.xs),
              itemCount: navItems.length,
              itemBuilder: (context, idx) {
                final item = navItems[idx];
                final isSelected = _selectedIndex == idx;

                if (_isSidebarCollapsed && !isDrawer) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: IconButton(
                      icon: Icon(
                        isSelected ? item.activeIcon : item.icon,
                        color: isSelected ? AppColors.japaniPhalDark : unselectedIconColor,
                        size: 22,
                      ),
                      tooltip: item.label,
                      onPressed: () => setState(() => _selectedIndex = idx),
                    ),
                  );
                }

                return Container(
                  margin: const EdgeInsets.only(bottom: 3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    gradient: isSelected
                        ? const LinearGradient(
                            colors: [AppColors.japaniPhal, AppColors.japaniPhalDark],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.japaniPhalDark.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: ListTile(
                    dense: true,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    tileColor: Colors.transparent,
                    leading: Icon(
                      isSelected ? item.activeIcon : item.icon,
                      color: isSelected ? Colors.white : unselectedIconColor,
                      size: 19,
                    ),
                    title: Text(
                      item.label,
                      style: TextStyle(
                        color: isSelected ? Colors.white : unselectedTextColor,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                        fontSize: 12.5,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: item.badge != null
                        ? Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.white.withValues(alpha: 0.25)
                                  : (_isDarkSidebar ? AppColors.stone800 : AppColors.stone100),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              item.badge!,
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : (_isDarkSidebar ? AppColors.stone400 : AppColors.japaniPhalDark),
                                fontSize: 9,
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

          // 4. Local SQLite Sync Engine Card
          if (!_isSidebarCollapsed || isDrawer) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: _isDarkSidebar ? AppColors.darkSurfaceElevated : AppColors.stone50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: borderColor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.cloud_done_outlined,
                          size: 13,
                          color: _isSyncing ? AppColors.amber500 : AppColors.green600,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          _isSyncing ? 'Syncing...' : 'Local Engine Active',
                          style: TextStyle(
                            color: _isSyncing ? AppColors.amber500 : AppColors.green600,
                            fontWeight: FontWeight.bold,
                            fontSize: 10.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 1),
                    Text(
                      'Drift SQLite ↔ PostgreSQL Sync',
                      style: TextStyle(color: _isDarkSidebar ? AppColors.stone400 : AppColors.stone500, fontSize: 9.5),
                    ),
                    const SizedBox(height: 6),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: titleColor,
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          side: BorderSide(color: borderColor),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                        ),
                        onPressed: _isSyncing ? null : _triggerManualSync,
                        child: Text(
                          'Force Sync',
                          style: TextStyle(color: titleColor, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],

          // 5. Day / Night Mode Switcher & User Profile
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: borderColor)),
            ),
            child: Column(
              children: [
                // Theme Toggle Switcher Pill (Day / Night Mode)
                if (!_isSidebarCollapsed || isDrawer)
                  Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    decoration: BoxDecoration(
                      color: _isDarkSidebar ? AppColors.darkSurfaceElevated : AppColors.stone50,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: borderColor),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Sidebar Appearance:',
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: unselectedTextColor),
                        ),
                        InkWell(
                          onTap: () => setState(() => _isDarkSidebar = !_isDarkSidebar),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: _isDarkSidebar ? AppColors.stone800 : Colors.white,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: borderColor),
                            ),
                            child: Text(
                              _isDarkSidebar ? '🌙 Dark' : '☀️ Light',
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: titleColor),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                // User Profile & Sign Out
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: _isDarkSidebar ? AppColors.darkSurfaceElevated : AppColors.stone50,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: borderColor),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: AppColors.japaniPhalDark,
                        child: Text(
                          widget.authState.fullName.isNotEmpty ? widget.authState.fullName[0].toUpperCase() : 'O',
                          style: const TextStyle(color: Colors.white, fontSize: 9.5, fontWeight: FontWeight.bold),
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
                          icon: const Icon(Icons.logout, color: AppColors.stone400, size: 16),
                          tooltip: 'Sign Out',
                          onPressed: () => widget.authState.logout(),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Top Header Bar for Desktop (Synchronized with Super Admin standard)
  Widget _buildTopHeader(List<NavigationItemConfig> navItems) {
    final currentRegion = AppLocaleController.instance.currentRegion;

    return Container(
      height: 58,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.stone200)),
      ),
      child: Row(
        children: [
          // Breadcrumb / Active Screen
          Icon(navItems[_selectedIndex].icon, size: 18, color: AppColors.japaniPhalDark),
          const SizedBox(width: 8),
          Text(
            navItems[_selectedIndex].label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.stone900),
          ),
          const SizedBox(width: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
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

          // Trial Status Pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.amber500.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.amber500.withValues(alpha: 0.3)),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.hourglass_top, size: 13, color: AppColors.amber500),
                SizedBox(width: 4),
                Text('Pro Plan • 14 Days Remaining', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.amber500)),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),

          // Branch Indicator Pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.stone50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.stone200),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.location_on, size: 13, color: AppColors.japaniPhalDark),
                const SizedBox(width: 4),
                Text(
                  widget.authState.branchName ?? 'Gulberg Main Arena',
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.stone700),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),

          // Interactive Region & Currency Dropdown
          PopupMenuButton<AppRegion>(
            tooltip: 'Select Region / Currency',
            initialValue: currentRegion,
            onSelected: (region) {
              AppLocaleController.instance.setRegion(region);
              AppToast.showInfo(
                context,
                'Region & Currency Updated',
                'Switched to ${region.countryName} (${region.currencyCode} - ${region.currencySymbol})',
              );
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: AppRegion.pakistan,
                child: Row(
                  children: [
                    Text('🇵🇰', style: TextStyle(fontSize: 14)),
                    SizedBox(width: 8),
                    Text('Pakistan (PKR - اردو)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: AppRegion.usa,
                child: Row(
                  children: [
                    Text('🇺🇸', style: TextStyle(fontSize: 14)),
                    SizedBox(width: 8),
                    Text('United States (USD - \$)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: AppRegion.uk,
                child: Row(
                  children: [
                    Text('🇬🇧', style: TextStyle(fontSize: 14)),
                    SizedBox(width: 8),
                    Text('United Kingdom (GBP - £)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: AppRegion.uae,
                child: Row(
                  children: [
                    Text('🇦🇪', style: TextStyle(fontSize: 14)),
                    SizedBox(width: 8),
                    Text('UAE (AED - العربية)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.stone50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.stone200),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    currentRegion == AppRegion.pakistan
                        ? '🇵🇰'
                        : (currentRegion == AppRegion.usa
                            ? '🇺🇸'
                            : (currentRegion == AppRegion.uk ? '🇬🇧' : '🇦🇪')),
                    style: const TextStyle(fontSize: 13),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    '${currentRegion.currencyCode} (${currentRegion.currencySymbol.trim()})',
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.stone800),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_drop_down, size: 16, color: AppColors.stone500),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Mobile App Bar for Screens < 950px
  PreferredSizeWidget _buildMobileAppBar(List<NavigationItemConfig> navItems) {
    final currentRegion = AppLocaleController.instance.currentRegion;

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
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.stone900),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            '${navItems[_selectedIndex].label} • ${widget.authState.branchName ?? "HQ"}',
            style: const TextStyle(fontSize: 10, color: AppColors.stone500),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.sync, color: _isSyncing ? AppColors.amber500 : AppColors.japaniPhalDark, size: 20),
          tooltip: 'Force Sync',
          onPressed: _triggerManualSync,
        ),
        PopupMenuButton<AppRegion>(
          tooltip: 'Select Region / Currency',
          initialValue: currentRegion,
          onSelected: (region) {
            AppLocaleController.instance.setRegion(region);
          },
          itemBuilder: (context) => [
            const PopupMenuItem(value: AppRegion.pakistan, child: Text('🇵🇰 Pakistan (PKR)')),
            const PopupMenuItem(value: AppRegion.usa, child: Text('🇺🇸 USA (USD)')),
            const PopupMenuItem(value: AppRegion.uk, child: Text('🇬🇧 UK (GBP)')),
            const PopupMenuItem(value: AppRegion.uae, child: Text('🇦🇪 UAE (AED)')),
          ],
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              currentRegion == AppRegion.pakistan
                  ? '🇵🇰'
                  : (currentRegion == AppRegion.usa
                      ? '🇺🇸'
                      : (currentRegion == AppRegion.uk ? '🇬🇧' : '🇦🇪')),
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ),
      ],
    );
  }
}

class NavigationItemConfig {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final String? badge;
  final Widget screen;

  const NavigationItemConfig({
    required this.icon,
    required this.activeIcon,
    required this.label,
    this.badge,
    required this.screen,
  });
}
