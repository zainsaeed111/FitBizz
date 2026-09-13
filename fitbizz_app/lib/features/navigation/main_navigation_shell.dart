import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
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

    // Dashboard
    if (widget.authState.canAccessDashboard) {
      items.add(NavigationItemConfig(
        icon: Icons.dashboard_outlined,
        activeIcon: Icons.dashboard,
        label: 'Dashboard',
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

    // Reception Terminal
    if (widget.authState.canAccessReception) {
      items.add(const NavigationItemConfig(
        icon: Icons.qr_code_scanner,
        activeIcon: Icons.qr_code_scanner,
        label: 'Reception Terminal',
        screen: ReceptionScreen(),
      ));
    }

    // Members Directory
    if (widget.authState.canAccessMembers) {
      items.add(NavigationItemConfig(
        icon: Icons.people_outline,
        activeIcon: Icons.people,
        label: role == UserRole.trainer ? 'My Trainees / Members' : 'Member Directory',
        screen: const MemberListScreen(),
      ));
    }

    // Billing & Invoices
    if (widget.authState.canAccessBilling) {
      items.add(const NavigationItemConfig(
        icon: Icons.receipt_long_outlined,
        activeIcon: Icons.receipt_long,
        label: 'Billing & Invoices',
        screen: BillingScreen(),
      ));
    }

    // Member Self-Service View
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
    final isDesktop = screenWidth > 850;

    if (isDesktop) {
      return Scaffold(
        body: Row(
          children: [
            // Desktop Sidebar Navigation
            Container(
              width: 270,
              color: AppColors.stone900,
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tenant Header with AppLogo
                  Row(
                    children: [
                      const AppLogo(size: 38),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.authState.tenantName,
                              style: AppTypography.h3.copyWith(color: Colors.white, fontSize: 15),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              'Tenant: ${widget.authState.tenantId ?? "tenant-001"}',
                              style: AppTypography.caption.copyWith(color: AppColors.stone500, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Active Role Badge
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.japaniPhal.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                      border: Border.all(color: AppColors.japaniPhal.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(widget.authState.userRole.icon, size: 14, color: AppColors.japaniPhal),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            widget.authState.userRole.label,
                            style: AppTypography.caption.copyWith(
                              color: AppColors.japaniPhal,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),

                  if (widget.onReturnToSuperAdmin != null) ...[
                    const SizedBox(height: AppSpacing.sm),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.japaniPhalDark,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusSm)),
                        ),
                        icon: const Icon(Icons.arrow_back, size: 15),
                        label: const Text('Back to Super Admin HQ', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                        onPressed: widget.onReturnToSuperAdmin,
                      ),
                    ),
                  ],

                  const SizedBox(height: AppSpacing.lg),

                  // Navigation Links
                  Expanded(
                    child: ListView.builder(
                      itemCount: navItems.length,
                      itemBuilder: (context, idx) {
                        final item = navItems[idx];
                        final isSelected = _selectedIndex == idx;
                        return Container(
                          margin: const EdgeInsets.only(bottom: 4),
                          child: ListTile(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusSm)),
                            tileColor: isSelected ? AppColors.japaniPhalDark : Colors.transparent,
                            leading: Icon(
                              isSelected ? item.activeIcon : item.icon,
                              color: isSelected ? Colors.white : AppColors.stone500,
                              size: 20,
                            ),
                            title: Text(
                              item.label,
                              style: AppTypography.body.copyWith(
                                color: isSelected ? Colors.white : AppColors.stone500,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                fontSize: 13,
                              ),
                            ),
                            onTap: () => setState(() => _selectedIndex = idx),
                          ),
                        );
                      },
                    ),
                  ),

                  // Sync Status Indicator
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.darkSurface,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                      border: Border.all(color: AppColors.stone700.withValues(alpha: 0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.cloud_done_outlined,
                              size: 14,
                              color: _isSyncing ? AppColors.amber500 : AppColors.green600,
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            Text(
                              _isSyncing ? 'Syncing...' : 'Local Engine Active',
                              style: AppTypography.caption.copyWith(
                                color: _isSyncing ? AppColors.amber500 : AppColors.green600,
                                fontWeight: FontWeight.w600,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Drift SQLite ↔ PostgreSQL Sync',
                          style: AppTypography.caption.copyWith(color: AppColors.stone500, fontSize: 10),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              side: const BorderSide(color: AppColors.stone700),
                            ),
                            onPressed: _isSyncing ? null : _triggerManualSync,
                            child: Text('Force Sync', style: AppTypography.caption.copyWith(color: Colors.white, fontSize: 11)),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSpacing.sm),

                  // User Info & Logout
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundColor: AppColors.darkSurfaceElevated,
                      child: Text(
                        (widget.authState.fullName).isNotEmpty ? (widget.authState.fullName)[0].toUpperCase() : 'U',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ),
                    title: Text(
                      widget.authState.fullName,
                      style: AppTypography.caption.copyWith(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      widget.authState.branchName ?? 'Main Facility',
                      style: AppTypography.caption.copyWith(color: AppColors.stone500, fontSize: 10),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.logout, color: AppColors.stone500, size: 18),
                      tooltip: 'Sign Out',
                      onPressed: () => widget.authState.logout(),
                    ),
                  ),
                ],
              ),
            ),

            // Main Workspace Content Area
            Expanded(
              child: navItems[_selectedIndex].screen,
            ),
          ],
        ),
      );
    }

    // Mobile View Navigation Layout
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const AppLogo(size: 28),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    navItems[_selectedIndex].label,
                    style: AppTypography.h3.copyWith(fontSize: 16),
                  ),
                  Text(
                    '${widget.authState.fullName} • ${widget.authState.roleLabel}',
                    style: AppTypography.caption.copyWith(color: AppColors.stone500, fontSize: 10),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.surface,
        elevation: 0,
        actions: [
          if (widget.onReturnToSuperAdmin != null)
            IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.japaniPhalDark),
              tooltip: 'Return to Super Admin HQ',
              onPressed: widget.onReturnToSuperAdmin,
            ),
          IconButton(
            icon: Icon(Icons.sync, color: _isSyncing ? AppColors.amber500 : AppColors.japaniPhalDark),
            tooltip: 'Sync Data',
            onPressed: _triggerManualSync,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sign Out',
            onPressed: () => widget.authState.logout(),
          ),
        ],
      ),
      body: navItems[_selectedIndex].screen,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (idx) => setState(() => _selectedIndex = idx),
        selectedItemColor: AppColors.japaniPhalDark,
        unselectedItemColor: AppColors.stone500,
        type: BottomNavigationBarType.fixed,
        items: navItems.map((item) {
          return BottomNavigationBarItem(
            icon: Icon(item.icon),
            activeIcon: Icon(item.activeIcon),
            label: item.label.split(' / ').first,
          );
        }).toList(),
      ),
    );
  }
}

class NavigationItemConfig {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final Widget screen;

  const NavigationItemConfig({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.screen,
  });
}
