import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/auth_cubit.dart';
import '../bloc/auth_state.dart';
import '../../../../core/theme/app_theme.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameCtrl = TextEditingController();
  final _fullNameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _rePasswordCtrl = TextEditingController();

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _fullNameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _passwordCtrl.dispose();
    _rePasswordCtrl.dispose();
    super.dispose();
  }

  void _onRegister() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().register(
        username: _usernameCtrl.text.trim(),
        fullName: _fullNameCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        phone: _phoneCtrl.text.trim(),
        password: _passwordCtrl.text,
        rePassword: _rePasswordCtrl.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrasi Warga'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: BlocConsumer<AuthCubit, AuthState>(
          listenWhen: (prev, curr) => prev.status != curr.status,
          listener: (context, state) {
            if (state.status == AuthStatus.success) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Registrasi berhasil! Silakan login.'),
                  backgroundColor: AppColors.statusSelesaiFg,
                  behavior: SnackBarBehavior.floating,
                ),
              );
              context.go('/login');
            } else if (state.status == AuthStatus.failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage ?? 'Registrasi gagal'),
                  backgroundColor: Colors.red.shade700,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
          builder: (context, state) {
            final isLoading = state.status == AuthStatus.loading;
            
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          controller: _usernameCtrl,
                          enabled: !isLoading,
                          decoration: const InputDecoration(labelText: 'Username'),
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) return 'Username wajib diisi';
                            if (val.trim().length < 3 || val.trim().length > 30) return '3-30 karakter';
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _fullNameCtrl,
                          enabled: !isLoading,
                          decoration: const InputDecoration(labelText: 'Nama Lengkap'),
                          validator: (val) => val == null || val.trim().isEmpty ? 'Nama wajib diisi' : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _emailCtrl,
                          enabled: !isLoading,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(labelText: 'Email'),
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) return 'Email wajib diisi';
                            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(val)) return 'Format email tidak valid';
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _phoneCtrl,
                          enabled: !isLoading,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(labelText: 'Nomor HP'),
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) return 'Nomor HP wajib diisi';
                            if (!RegExp(r'^[0-9]+$').hasMatch(val.trim())) return 'Harus berupa angka';
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordCtrl,
                          enabled: !isLoading,
                          obscureText: true,
                          decoration: const InputDecoration(labelText: 'Password'),
                          validator: (val) {
                            if (val == null || val.isEmpty) return 'Password wajib diisi';
                            if (val.length < 8) return 'Minimal 8 karakter';
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _rePasswordCtrl,
                          enabled: !isLoading,
                          obscureText: true,
                          decoration: const InputDecoration(labelText: 'Konfirmasi Password'),
                          validator: (val) {
                            if (val == null || val.isEmpty) return 'Ulangi password';
                            if (val != _passwordCtrl.text) return 'Password tidak cocok';
                            return null;
                          },
                        ),
                        const SizedBox(height: 32),
                        ElevatedButton(
                          onPressed: isLoading ? null : _onRegister,
                          child: isLoading
                              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                              : const Text('DAFTAR', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
