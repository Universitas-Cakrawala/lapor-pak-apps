import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Placeholder screens for routing skeleton
class SplashScreen extends StatelessWidget { const SplashScreen({super.key}); @override Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Splash Screen'))); }
class RegisterScreen extends StatelessWidget { const RegisterScreen({super.key}); @override Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Register Screen'))); }
class LoginScreen extends StatelessWidget { const LoginScreen({super.key}); @override Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Login Screen'))); }
class HomeScreen extends StatelessWidget { const HomeScreen({super.key}); @override Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Home Screen'))); }
class ReportFormStep1Screen extends StatelessWidget { const ReportFormStep1Screen({super.key}); @override Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Report Step 1'))); }
class ReportFormStep2Screen extends StatelessWidget { const ReportFormStep2Screen({super.key}); @override Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Report Step 2'))); }
class SuccessScreen extends StatelessWidget { const SuccessScreen({super.key}); @override Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Success Screen'))); }
class MyReportsScreen extends StatelessWidget { const MyReportsScreen({super.key}); @override Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('My Reports Screen'))); }
class ReportDetailScreen extends StatelessWidget { final String id; const ReportDetailScreen({super.key, required this.id}); @override Widget build(BuildContext context) => Scaffold(body: Center(child: Text('Report Detail: $id'))); }
class AdminDashboardScreen extends StatelessWidget { const AdminDashboardScreen({super.key}); @override Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Admin Dashboard'))); }
class AdminUpdateStatusScreen extends StatelessWidget { final String id; const AdminUpdateStatusScreen({super.key, required this.id}); @override Widget build(BuildContext context) => Scaffold(body: Center(child: Text('Update Status: $id'))); }

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/splash', builder: (c, s) => const SplashScreen()),
    GoRoute(path: '/register', builder: (c, s) => const RegisterScreen()),
    GoRoute(path: '/login', builder: (c, s) => const LoginScreen()),
    GoRoute(path: '/home', builder: (c, s) => const HomeScreen()),
    GoRoute(path: '/reports/new/step1', builder: (c, s) => const ReportFormStep1Screen()),
    GoRoute(path: '/reports/new/step2', builder: (c, s) => const ReportFormStep2Screen()),
    GoRoute(path: '/reports/success', builder: (c, s) => const SuccessScreen()),
    GoRoute(path: '/reports', builder: (c, s) => const MyReportsScreen()),
    GoRoute(path: '/reports/:id', builder: (c, s) => ReportDetailScreen(id: s.pathParameters['id']!)),
    GoRoute(path: '/admin/dashboard', builder: (c, s) => const AdminDashboardScreen()),
    GoRoute(path: '/admin/reports/:id/status', builder: (c, s) => AdminUpdateStatusScreen(id: s.pathParameters['id']!)),
  ],
);
