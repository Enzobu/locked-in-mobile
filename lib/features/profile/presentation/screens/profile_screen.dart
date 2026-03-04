import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../app/locale_provider.dart';
import '../../../../app/notification_provider.dart';
import '../../../../app/theme.dart';
import '../../../../core/models/customer.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/profile_provider.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_section.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final customer = ref.watch(currentCustomerProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 0,
            floating: true,
            title: Text(l10n.profile),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  ProfileHeader(customer: customer),
                  const SizedBox(height: 24),
                  _PersonalInfoSection(
                    customer: customer,
                    onEdit: () => context.push('/profile/edit'),
                  ),
                  const SizedBox(height: 16),
                  _PreferencesSection(),
                  const SizedBox(height: 16),
                  _AboutSection(),
                  const SizedBox(height: 24),
                  _LogoutButton(),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PersonalInfoSection extends StatelessWidget {
  const _PersonalInfoSection({required this.customer, this.onEdit});

  final Customer? customer;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ProfileSection(
      title: l10n.profilePersonalInfo,
      icon: LucideIcons.user,
      trailing: IconButton(
        onPressed: onEdit,
        icon: Icon(
          LucideIcons.edit,
          size: 18,
          color: Theme.of(context).colorScheme.primary,
        ),
        tooltip: l10n.profileEdit,
      ),
      children: [
        ProfileSectionTile(
          icon: LucideIcons.mail,
          label: l10n.email,
          value: customer?.email ?? '-',
        ),
        ProfileSectionTile(
          icon: LucideIcons.phone,
          label: l10n.phone,
          value: '-',
        ),
      ],
    );
  }
}

class _PreferencesSection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);
    final notificationsEnabled = ref.watch(notificationsProvider);

    final themeModeLabel = switch (themeMode) {
      ThemeMode.system => l10n.systemMode,
      ThemeMode.light => l10n.lightMode,
      ThemeMode.dark => l10n.darkMode,
    };

    final localeLabel = switch (locale.languageCode) {
      'fr' => l10n.french,
      'en' => l10n.english,
      'de' => l10n.german,
      'it' => l10n.italian,
      _ => l10n.french,
    };

    return ProfileSection(
      title: l10n.profilePreferences,
      icon: LucideIcons.settings,
      children: [
        ProfileSectionTile(
          icon: LucideIcons.sun,
          label: l10n.theme,
          value: themeModeLabel,
          onTap: () => _showThemePicker(context, ref, themeMode),
        ),
        ProfileSectionTile(
          icon: LucideIcons.globe,
          label: l10n.language,
          value: localeLabel,
          onTap: () => _showLanguagePicker(context, ref, locale),
        ),
        ProfileSectionTile(
          icon: LucideIcons.bell,
          label: l10n.notifications,
          trailing: Switch.adaptive(
            value: notificationsEnabled,
            onChanged: (_) => ref.read(notificationsProvider.notifier).toggle(),
            activeTrackColor: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }

  void _showThemePicker(
    BuildContext context,
    WidgetRef ref,
    ThemeMode current,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.theme,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              _ThemeOption(
                icon: LucideIcons.smartphone,
                label: l10n.systemMode,
                selected: current == ThemeMode.system,
                onTap: () {
                  ref
                      .read(themeModeProvider.notifier)
                      .setThemeMode(ThemeMode.system);
                  Navigator.pop(context);
                },
              ),
              _ThemeOption(
                icon: LucideIcons.sun,
                label: l10n.lightMode,
                selected: current == ThemeMode.light,
                onTap: () {
                  ref
                      .read(themeModeProvider.notifier)
                      .setThemeMode(ThemeMode.light);
                  Navigator.pop(context);
                },
              ),
              _ThemeOption(
                icon: LucideIcons.moon,
                label: l10n.darkMode,
                selected: current == ThemeMode.dark,
                onTap: () {
                  ref
                      .read(themeModeProvider.notifier)
                      .setThemeMode(ThemeMode.dark);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLanguagePicker(
    BuildContext context,
    WidgetRef ref,
    Locale current,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    final languages = [
      (const Locale('fr'), l10n.french, '🇫🇷'),
      (const Locale('en'), l10n.english, '🇬🇧'),
      (const Locale('de'), l10n.german, '🇩🇪'),
      (const Locale('it'), l10n.italian, '🇮🇹'),
    ];

    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.language,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              ...languages.map(
                (lang) => _ThemeOption(
                  label: '${lang.$3}  ${lang.$2}',
                  selected: current.languageCode == lang.$1.languageCode,
                  onTap: () {
                    ref.read(localeProvider.notifier).setLocale(lang.$1);
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  const _ThemeOption({
    this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData? icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      leading: icon != null
          ? Icon(
              icon,
              color: selected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurfaceVariant,
            )
          : null,
      title: Text(
        label,
        style: TextStyle(
          color: selected
              ? theme.colorScheme.primary
              : theme.colorScheme.onSurface,
          fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      trailing: selected
          ? Icon(LucideIcons.check, color: theme.colorScheme.primary)
          : null,
      onTap: onTap,
    );
  }
}

class _AboutSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ProfileSection(
      title: l10n.profileAbout,
      icon: LucideIcons.info,
      children: [
        ProfileSectionTile(
          icon: LucideIcons.helpCircle,
          label: l10n.profileHelp,
          onTap: () {},
        ),
        ProfileSectionTile(
          icon: LucideIcons.fileText,
          label: l10n.profileTerms,
          onTap: () {},
        ),
        ProfileSectionTile(
          icon: LucideIcons.shield,
          label: l10n.profilePrivacy,
          onTap: () {},
        ),
        ProfileSectionTile(
          icon: LucideIcons.sparkles,
          label: l10n.appName,
          value: l10n.profileVersion('1.0.0'),
        ),
      ],
    );
  }
}

class _LogoutButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => _confirmLogout(context, ref),
        icon: Icon(
          LucideIcons.logOut,
          size: 18,
          color: theme.colorScheme.error,
        ),
        label: Text(
          l10n.logout,
          style: TextStyle(color: theme.colorScheme.error),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: theme.colorScheme.error.withValues(alpha: 0.5),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              Icon(
                LucideIcons.logOut,
                size: 48,
                color: theme.colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                l10n.logout,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.profileLogoutConfirm,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(l10n.cancel),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ref.read(authProvider.notifier).logout();
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: theme.colorScheme.error,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(l10n.logout),
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
}
