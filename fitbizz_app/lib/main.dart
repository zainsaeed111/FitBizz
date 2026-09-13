import 'package:flutter/material.dart';

import 'core/network/api_client.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/auth_state.dart';
import 'features/auth/login_screen.dart';
import 'features/navigation/main_navigation_shell.dart';
import 'features/splash/splash_screen.dart';
import 'features/super_admin/super_admin_dashboard_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final apiClient = ApiClient();
  final authState = AuthState(apiClient: apiClient);

  runApp(FitBizzApp(apiClient: apiClient, authState: authState));
}

class FitBizzApp extends StatefulWidget {
  final ApiClient apiClient;
  final AuthState authState;

  const FitBizzApp({
    super.key,
    required this.apiClient,
    required this.authState,
  });

  @override
  State<FitBizzApp> createState() => _FitBizzAppState();
}

class _FitBizzAppState extends State<FitBizzApp> {
  bool _showSplash = true;
  bool _forceTenantView = false; // When Super Admin switches to tenant view

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitBizz Multi-Tenant SaaS',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: _showSplash
          ? SplashScreen(
              onSplashComplete: () {
                setState(() {
                  _showSplash = false;
                });
              },
            )
          : ListenableBuilder(
              listenable: widget.authState,
              builder: (context, _) {
                // If not authenticated, show Login Screen
                if (!widget.authState.isAuthenticated) {
                  return LoginScreen(
                    authState: widget.authState,
                    onLoginSuccess: () {
                      setState(() {
                        _forceTenantView = false;
                      });
                    },
                  );
                }

                // If Super Admin and not manually previewing tenant portal
                if (widget.authState.isSuperAdmin && !_forceTenantView) {
                  return SuperAdminDashboardScreen(
                    apiClient: widget.apiClient,
                    onSwitchToTenantPortal: () {
                      setState(() {
                        _forceTenantView = true;
                      });
                    },
                    onManageGym: (gym) {
                      widget.authState.switchTenantContext(
                        tenantId: gym.id,
                        tenantName: gym.gymName,
                        ownerName: gym.ownerName,
                        ownerEmail: gym.ownerEmail,
                        branchId: 'b_${gym.id}',
                        branchName: '${gym.gymName} (${gym.city})',
                      );
                      setState(() {
                        _forceTenantView = true;
                      });
                    },
                    onLogout: () {
                      widget.authState.logout();
                    },
                  );
                }

                // Main Multi-Role Tenant Navigation Shell
                return MainNavigationShell(
                  authState: widget.authState,
                  onReturnToSuperAdmin: widget.authState.isSuperAdmin
                      ? () {
                          setState(() {
                            _forceTenantView = false;
                          });
                        }
                      : null,
                );
              },
            ),
    );
  }
}
