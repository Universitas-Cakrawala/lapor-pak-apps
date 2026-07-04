
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

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

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash', 
      builder: (c, s) => BlocProvider(create: (_) => sl<AuthCubit>(), child: const SplashScreen()),
    ),
    GoRoute(
      path: '/register', 
      builder: (c, s) => BlocProvider(create: (_) => sl<AuthCubit>(), child: const RegisterScreen()),
    ),
    GoRoute(
      path: '/login', 
      builder: (c, s) => BlocProvider(create: (_) => sl<AuthCubit>(), child: const LoginScreen()),
    ),
    GoRoute(
      path: '/profile', 
      builder: (c, s) => MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => sl<ProfileCubit>()),
          BlocProvider(create: (_) => sl<AuthCubit>()),
        ],
        child: const ProfileScreen(),
      ),
    ),
    GoRoute(
      path: '/home', 
      builder: (c, s) => BlocProvider(create: (_) => sl<HomeStatsCubit>(), child: const HomeScreen()),
    ),
    GoRoute(
      path: '/reports/new/step1', 
      builder: (c, s) => BlocProvider(create: (_) => sl<ProfileCubit>()..fetchProfile(), child: const ReportFormStep1Screen()),
    ),
    GoRoute(
      path: '/reports/new/step2', 
      builder: (c, s) => BlocProvider(create: (_) => sl<ReportFormCubit>(), child: const ReportFormStep2Screen()),
    ),
    GoRoute(
      path: '/reports/success', 
      builder: (c, s) => const SuccessScreen(),
    ),
    GoRoute(
      path: '/reports', 
      builder: (c, s) => BlocProvider(create: (_) => sl<ReportListCubit>(), child: const ReportListScreen()),
    ),
    GoRoute(
      path: '/reports/:id', 
      builder: (c, s) => BlocProvider(create: (_) => sl<ReportDetailCubit>(), child: ReportDetailScreen(id: s.pathParameters['id']!)),
    ),
    GoRoute(
      path: '/admin/dashboard', 
      builder: (c, s) => BlocProvider(create: (_) => sl<DashboardCubit>(), child: const AdminDashboardScreen()),
    ),
    GoRoute(
      path: '/admin/reports/:id/status', 
      builder: (c, s) => BlocProvider(create: (_) => sl<AdminUpdateStatusCubit>(), child: AdminUpdateStatusScreen(id: s.pathParameters['id']!)),
    ),
  ],
);
