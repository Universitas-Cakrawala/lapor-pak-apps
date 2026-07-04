import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/models/user_model.dart';
import '../bloc/auth_cubit.dart';
import '../bloc/auth_state.dart';
import '../../../../core/theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Beri sedikit delay untuk efek transisi
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        context.read<AuthCubit>().checkSession();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (prev, curr) => prev.status != curr.status,
      listener: (context, state) {
        if (state.status == AuthStatus.success) {
          if (state.user?.role == UserRole.ADMIN) {
            context.go('/admin/dashboard');
          } else {
            context.go('/home');
          }
        } else if (state.status == AuthStatus.failure) {
          context.go('/login');
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.civicBlue,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.report_problem, size: 80, color: Colors.white),
              const SizedBox(height: 24),
              Text(
                'Lapor Pak',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              const CircularProgressIndicator(color: AppColors.amber),
            ],
          ),
        ),
      ),
    );
  }
}
