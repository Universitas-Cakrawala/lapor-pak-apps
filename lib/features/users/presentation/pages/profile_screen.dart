import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/theme_cubit.dart';
import '../bloc/profile_cubit.dart';
import '../bloc/profile_state.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/bloc/auth_cubit.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().fetchProfile();
  }

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        children: [
          const CircleAvatar(radius: 50, backgroundColor: Colors.white),
          const SizedBox(height: 16),
          Container(width: 150, height: 24, color: Colors.white),
          const SizedBox(height: 8),
          Container(width: 200, height: 16, color: Colors.white),
          const SizedBox(height: 32),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Container(
              height: 200,
              padding: const EdgeInsets.all(16),
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Saya'),
        automaticallyImplyLeading: false,
      ),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state.status == ProfileStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Error'),
                backgroundColor: Colors.red.shade700,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.status == ProfileStatus.loading || state.status == ProfileStatus.initial) {
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: _buildShimmer(),
            );
          }

          final user = state.user;
          if (user == null) {
            return Center(
              child: ElevatedButton(
                onPressed: () => context.read<ProfileCubit>().fetchProfile(),
                child: const Text('Coba Lagi'),
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: AppColors.civicBlue.withValues(alpha: 0.1),
                  child: Text(
                    user.fullName.substring(0, 1).toUpperCase(),
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: AppColors.civicBlue,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  user.fullName,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  user.email,
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 24),

                // Dark Mode Toggle
                Card(
                  child: BlocBuilder<ThemeCubit, ThemeMode>(
                    builder: (context, themeMode) {
                      final themeCubit = context.read<ThemeCubit>();
                      final isDark = themeCubit.isDark(context);
                      return ListTile(
                        leading: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          transitionBuilder: (child, animation) => RotationTransition(
                            turns: animation,
                            child: child,
                          ),
                          child: Icon(
                            isDark ? Icons.dark_mode : Icons.light_mode,
                            key: ValueKey(isDark),
                            color: isDark ? AppColors.amber : AppColors.civicBlue,
                          ),
                        ),
                        title: const Text('Mode Gelap'),
                        subtitle: Text(isDark ? 'Aktif' : 'Nonaktif'),
                        trailing: Switch(
                          value: isDark,
                          onChanged: (_) => themeCubit.toggleTheme(),
                          activeTrackColor: AppColors.amber.withValues(alpha: 0.5),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),

                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.person, color: AppColors.civicBlue),
                          title: const Text('Username'),
                          subtitle: Text(user.username),
                        ),
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.phone, color: AppColors.civicBlue),
                          title: const Text('Nomor HP'),
                          subtitle: Text(user.phone),
                        ),
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.badge, color: AppColors.civicBlue),
                          title: const Text('Role'),
                          subtitle: Text(user.role.name),
                        ),
                        if (user.instansi != null && user.instansi!.isNotEmpty) ...[
                          const Divider(),
                          ListTile(
                            leading: const Icon(Icons.business, color: AppColors.civicBlue),
                            title: const Text('Instansi'),
                            subtitle: Text(user.instansi!),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      await context.read<AuthCubit>().logout();
                      if (context.mounted) {
                        context.go('/login');
                      }
                    },
                    icon: const Icon(Icons.logout, color: Colors.red),
                    label: const Text('Keluar', style: TextStyle(color: Colors.red)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
