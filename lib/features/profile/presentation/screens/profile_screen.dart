import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

/// User profile screen
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock logged-in user state
    final bool isLoggedIn = false;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Perfil',
                style: AppTypography.headlineLarge,
              ),
              const SizedBox(height: 24),

              // User card or login prompt
              if (isLoggedIn)
                _buildUserCard()
              else
                _buildLoginPrompt(context),

              const SizedBox(height: 32),

              // Settings sections
              _SectionHeader(title: 'Preferencias'),
              const SizedBox(height: 12),
              _SettingsCard(
                children: [
                  _SettingsTile(
                    icon: Icons.language_rounded,
                    title: 'País',
                    subtitle: 'España',
                    onTap: () {},
                  ),
                  _SettingsTile(
                    icon: Icons.euro_rounded,
                    title: 'Moneda',
                    subtitle: 'EUR (€)',
                    onTap: () {},
                  ),
                  _SettingsTile(
                    icon: Icons.dark_mode_rounded,
                    title: 'Tema oscuro',
                    trailing: Switch(
                      value: true,
                      onChanged: (value) {},
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              _SectionHeader(title: 'Notificaciones'),
              const SizedBox(height: 12),
              _SettingsCard(
                children: [
                  _SettingsTile(
                    icon: Icons.notifications_rounded,
                    title: 'Alertas de precio',
                    trailing: Switch(
                      value: true,
                      onChanged: (value) {},
                    ),
                  ),
                  _SettingsTile(
                    icon: Icons.local_offer_rounded,
                    title: 'Ofertas destacadas',
                    trailing: Switch(
                      value: false,
                      onChanged: (value) {},
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              _SectionHeader(title: 'Tiendas favoritas'),
              const SizedBox(height: 12),
              _SettingsCard(
                children: [
                  _SettingsTile(
                    icon: Icons.store_rounded,
                    title: 'Gestionar tiendas',
                    subtitle: '6 tiendas activas',
                    onTap: () {},
                  ),
                ],
              ),

              const SizedBox(height: 24),

              _SectionHeader(title: 'Información'),
              const SizedBox(height: 12),
              _SettingsCard(
                children: [
                  _SettingsTile(
                    icon: Icons.info_outline_rounded,
                    title: 'Acerca de',
                    onTap: () {},
                  ),
                  _SettingsTile(
                    icon: Icons.privacy_tip_outlined,
                    title: 'Política de privacidad',
                    onTap: () {},
                  ),
                  _SettingsTile(
                    icon: Icons.description_outlined,
                    title: 'Términos de uso',
                    onTap: () {},
                  ),
                  _SettingsTile(
                    icon: Icons.mail_outline_rounded,
                    title: 'Contacto',
                    onTap: () {},
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // App version
              Center(
                child: Text(
                  'ComoPrecio v1.0.0',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginPrompt(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.15),
            AppColors.primary.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person_outline_rounded,
              size: 40,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Inicia sesión',
            style: AppTypography.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Guarda tus alertas y sincroniza en todos tus dispositivos',
            textAlign: TextAlign.center,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    context.push('/login');
                  },
                  child: const Text('Registrarse'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    context.push('/login');
                  },
                  child: const Text('Iniciar sesión'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUserCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text(
                'JD',
                style: TextStyle(
                  color: AppColors.darkBackground,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'John Doe',
                  style: AppTypography.titleLarge,
                ),
                Text(
                  'john@example.com',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            color: AppColors.textMuted,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTypography.titleMedium.copyWith(
        color: AppColors.textSecondary,
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;

  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: children.asMap().entries.map((entry) {
          final isLast = entry.key == children.length - 1;
          return Column(
            children: [
              entry.value,
              if (!isLast)
                Divider(
                  height: 1,
                  indent: 56,
                  color: AppColors.surfaceVariant,
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          size: 20,
          color: AppColors.textSecondary,
        ),
      ),
      title: Text(
        title,
        style: AppTypography.bodyLarge,
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textMuted,
              ),
            )
          : null,
      trailing: trailing ??
          (onTap != null
              ? const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.textMuted,
                )
              : null),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }
}
