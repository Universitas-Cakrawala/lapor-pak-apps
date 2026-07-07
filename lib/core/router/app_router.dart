import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/models/report_model.dart';

import '../di/service_locator.dart';
import '../../features/auth/presentation/bloc/auth_cubit.dart';
import '../../features/auth/presentation/pages/splash_screen.dart';
import '../../features/auth/presentation/pages/login_screen.dart';
import '../../features/auth/presentation/pages/register_screen.dart';
import '../../features/users/presentation/pages/profile_screen.dart';
import '../../features/users/presentation/bloc/profile_cubit.dart';
import '../../features/reports/presentation/pages/home_screen.dart';
import '../../features/reports/presentation/pages/report_list_screen.dart';
import '../../features/reports/presentation/pages/report_detail_screen.dart';
import '../../features/reports/presentation/pages/report_form_step1_screen.dart';
import '../../features/reports/presentation/pages/report_form_step2_screen.dart';
import '../../features/reports/presentation/pages/success_screen.dart';
import '../../features/reports/presentation/bloc/home_stats_cubit.dart';
import '../../features/reports/presentation/bloc/report_list_cubit.dart';
import '../../features/reports/presentation/bloc/report_detail_cubit.dart';
import '../../features/reports/presentation/bloc/report_form_cubit.dart';
import '../../features/reports/presentation/pages/admin_update_status_screen.dart';
import '../../features/reports/presentation/bloc/admin_update_status_cubit.dart';

import '../../features/reports/presentation/pages/admin_dashboard_screen.dart';
import '../../features/reports/presentation/bloc/dashboard_cubit.dart';

import '../../shared/widgets/main_shell_screen.dart';
import '../../shared/widgets/admin_shell_screen.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

// Navigator keys for shell branches
final GlobalKey<NavigatorState> _citizenHomeNavKey = GlobalKey<NavigatorState>(debugLabel: 'citizenHome');
final GlobalKey<NavigatorState> _citizenReportsNavKey = GlobalKey<NavigatorState>(debugLabel: 'citizenReports');
final GlobalKey<NavigatorState> _citizenProfileNavKey = GlobalKey<NavigatorState>(debugLabel: 'citizenProfile');
final GlobalKey<NavigatorState> _adminDashboardNavKey = GlobalKey<NavigatorState>(debugLabel: 'adminDashboard');
final GlobalKey<NavigatorState> _adminProfileNavKey = GlobalKey<NavigatorState>(debugLabel: 'adminProfile');

/// Helper to build a page with a smooth slide transition.
CustomTransitionPage<T> _buildSlideTransition<T>({
  required Widget child,
  required GoRouterState state,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final offsetAnimation = Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOutCubic));
      return SlideTransition(position: offsetAnimation, child: child);
    },
    transitionDuration: const Duration(milliseconds: 300),
  );
}

/// Helper to build a page with a fade transition.
CustomTransitionPage<T> _buildFadeTransition<T>({
  required Widget child,
  required GoRouterState state,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(opacity: animation, child: child);
    },
    transitionDuration: const Duration(milliseconds: 400),
  );
}

final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/splash',
  routes: [
    // --- Auth routes (no bottom nav) ---
    GoRoute(
      path: '/splash', 
      pageBuilder: (c, s) => _buildFadeTransition(
        state: s,
        child: BlocProvider(create: (_) => sl<AuthCubit>(), child: const SplashScreen()),
      ),
    ),
    GoRoute(
      path: '/register', 
      pageBuilder: (c, s) => _buildSlideTransition(
        state: s,
        child: BlocProvider(create: (_) => sl<AuthCubit>(), child: const RegisterScreen()),
      ),
    ),
    GoRoute(
      path: '/login', 
      pageBuilder: (c, s) => _buildFadeTransition(
        state: s,
        child: BlocProvider(create: (_) => sl<AuthCubit>(), child: const LoginScreen()),
      ),
    ),

    // --- Citizen Shell (Persistent Bottom Nav: Beranda, Laporan, Profil) ---
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainShellScreen(navigationShell: navigationShell);
      },
      branches: [
        // Branch 0: Beranda
        StatefulShellBranch(
          navigatorKey: _citizenHomeNavKey,
          routes: [
            GoRoute(
              path: '/home',
              pageBuilder: (c, s) => _buildFadeTransition(
                state: s,
                child: BlocProvider(create: (_) => sl<HomeStatsCubit>(), child: const HomeScreen()),
              ),
            ),
          ],
        ),
        // Branch 1: Laporan
        StatefulShellBranch(
          navigatorKey: _citizenReportsNavKey,
          routes: [
            GoRoute(
              path: '/reports',
              pageBuilder: (c, s) => _buildFadeTransition(
                state: s,
                child: MultiBlocProvider(
                  providers: [
                    BlocProvider(create: (_) => sl<ReportListCubit>()),
                    BlocProvider(create: (_) => sl<ProfileCubit>()..fetchProfile()),
                  ],
                  child: const ReportListScreen(),
                ),
              ),
            ),
          ],
        ),
        // Branch 2: Profil
        StatefulShellBranch(
          navigatorKey: _citizenProfileNavKey,
          routes: [
            GoRoute(
              path: '/profile',
              pageBuilder: (c, s) => _buildFadeTransition(
                state: s,
                child: MultiBlocProvider(
                  providers: [
                    BlocProvider(create: (_) => sl<ProfileCubit>()),
                    BlocProvider(create: (_) => sl<AuthCubit>()),
                  ],
                  child: const ProfileScreen(),
                ),
              ),
            ),
          ],
        ),
      ],
    ),

    // --- Admin Shell (Persistent Bottom Nav: Dashboard, Profil) ---
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return AdminShellScreen(navigationShell: navigationShell);
      },
      branches: [
        // Branch 0: Dashboard
        StatefulShellBranch(
          navigatorKey: _adminDashboardNavKey,
          routes: [
            GoRoute(
              path: '/admin/dashboard',
              pageBuilder: (c, s) => _buildFadeTransition(
                state: s,
                child: BlocProvider(create: (_) => sl<DashboardCubit>(), child: const AdminDashboardScreen()),
              ),
            ),
          ],
        ),
        // Branch 1: Profil (Admin)
        StatefulShellBranch(
          navigatorKey: _adminProfileNavKey,
          routes: [
            GoRoute(
              path: '/admin/profile',
              pageBuilder: (c, s) => _buildFadeTransition(
                state: s,
                child: MultiBlocProvider(
                  providers: [
                    BlocProvider(create: (_) => sl<ProfileCubit>()),
                    BlocProvider(create: (_) => sl<AuthCubit>()),
                  ],
                  child: const ProfileScreen(),
                ),
              ),
            ),
          ],
        ),
      ],
    ),

    // --- Top-level routes (no bottom nav, overlay fullscreen) ---
    GoRoute(
      path: '/reports/new/step1', 
      parentNavigatorKey: rootNavigatorKey,
      pageBuilder: (c, s) => _buildSlideTransition(
        state: s,
        child: BlocProvider(create: (_) => sl<ProfileCubit>()..fetchProfile(), child: const ReportFormStep1Screen()),
      ),
    ),
    GoRoute(
      path: '/reports/new/step2', 
      parentNavigatorKey: rootNavigatorKey,
      pageBuilder: (c, s) => _buildSlideTransition(
        state: s,
        child: BlocProvider(create: (_) => sl<ReportFormCubit>(), child: const ReportFormStep2Screen()),
      ),
    ),
    GoRoute(
      path: '/reports/success', 
      parentNavigatorKey: rootNavigatorKey,
      pageBuilder: (c, s) => _buildFadeTransition(
        state: s,
        child: const SuccessScreen(),
      ),
    ),
    GoRoute(
      path: '/reports/:id', 
      parentNavigatorKey: rootNavigatorKey,
      pageBuilder: (c, s) => _buildSlideTransition(
        state: s,
        child: BlocProvider(create: (_) => sl<ReportDetailCubit>(), child: ReportDetailScreen(id: s.pathParameters['id']!)),
      ),
    ),
    GoRoute(
      path: '/reports/:id/edit', 
      parentNavigatorKey: rootNavigatorKey,
      pageBuilder: (c, s) => _buildSlideTransition(
        state: s,
        child: BlocProvider(
          create: (_) => sl<ReportFormCubit>(), 
          child: ReportFormStep2Screen(existingReport: s.extra as ReportModel?),
        ),
      ),
    ),
    GoRoute(
      path: '/admin/reports', 
      parentNavigatorKey: rootNavigatorKey,
      pageBuilder: (c, s) => _buildSlideTransition(
        state: s,
        child: MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => sl<ReportListCubit>()),
            BlocProvider(create: (_) => sl<ProfileCubit>()..fetchProfile()),
          ],
          child: const ReportListScreen(),
        ),
      ),
    ),
    GoRoute(
      path: '/admin/reports/:id/status', 
      parentNavigatorKey: rootNavigatorKey,
      pageBuilder: (c, s) => _buildSlideTransition(
        state: s,
        child: BlocProvider(create: (_) => sl<AdminUpdateStatusCubit>(), child: AdminUpdateStatusScreen(id: s.pathParameters['id']!)),
      ),
    ),
  ],
);
