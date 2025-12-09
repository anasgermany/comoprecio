import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

/// Login/Register screen
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLogin = true;
  bool _isLoading = false;
  bool _obscurePassword = true;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button
              IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: () => context.pop(),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(height: 32),

              // Logo
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.compare_arrows_rounded,
                  color: AppColors.darkBackground,
                  size: 32,
                ),
              ),
              const SizedBox(height: 24),

              // Title
              Text(
                _isLogin ? 'Bienvenido de nuevo' : 'Crear cuenta',
                style: AppTypography.headlineLarge,
              ),
              const SizedBox(height: 8),
              Text(
                _isLogin
                    ? 'Inicia sesión para sincronizar tus alertas'
                    : 'Regístrate para guardar tus alertas',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 40),

              // Email field
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
              ),
              const SizedBox(height: 16),

              // Password field
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                    onPressed: () {
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
                  ),
                ),
              ),

              if (_isLogin) ...[
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // TODO: Forgot password
                    },
                    child: Text(
                      '¿Olvidaste tu contraseña?',
                      style: AppTypography.labelMedium.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 32),

              // Submit button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleSubmit,
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.darkBackground,
                          ),
                        )
                      : Text(_isLogin ? 'Iniciar sesión' : 'Crear cuenta'),
                ),
              ),
              const SizedBox(height: 24),

              // Divider
              Row(
                children: [
                  const Expanded(
                    child: Divider(color: AppColors.surfaceVariant),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'o continúa con',
                      style: AppTypography.labelMedium.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Divider(color: AppColors.surfaceVariant),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Social login buttons
              Row(
                children: [
                  Expanded(
                    child: _SocialButton(
                      icon: '🔵',
                      label: 'Google',
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _SocialButton(
                      icon: '⚫',
                      label: 'Apple',
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Toggle login/register
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _isLogin
                        ? '¿No tienes cuenta?'
                        : '¿Ya tienes cuenta?',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() => _isLogin = !_isLogin);
                    },
                    child: Text(
                      _isLogin ? 'Regístrate' : 'Inicia sesión',
                      style: AppTypography.labelLarge.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleSubmit() async {
    setState(() => _isLoading = true);

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isLoading = false);

    // Navigate back
    if (mounted) {
      context.go('/');
    }
  }
}

class _SocialButton extends StatelessWidget {
  final String icon;
  final String label;
  final VoidCallback onPressed;

  const _SocialButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(icon, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
    );
  }
}
