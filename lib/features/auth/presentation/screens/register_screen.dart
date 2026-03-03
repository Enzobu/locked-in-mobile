import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../l10n/app_localizations.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_error_banner.dart';
import '../widgets/auth_tab_selector.dart';
import '../widgets/auth_text_field.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _firstnameController.dispose();
    _lastnameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _onRegister() async {
    if (!_formKey.currentState!.validate()) return;
    await ref
        .read(authProvider.notifier)
        .register(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          firstname: _firstnameController.text.trim(),
          lastname: _lastnameController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authState = ref.watch(authProvider);
    final theme = Theme.of(context);
    final isLoading = authState.status == AuthStatus.loading;

    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next.status == AuthStatus.registerSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.registerSuccess),
            backgroundColor: theme.colorScheme.primary,
          ),
        );
        context.go('/login');
      }
    });

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Column(
                      children: [
                        const SizedBox(height: 48),
                        Text(
                          l10n.registerTitle,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.registerSubtitle,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 32),
                        AuthTabSelector(
                          selectedIndex: 1,
                          loginLabel: l10n.login,
                          registerLabel: l10n.register,
                          onTabChanged: (index) {
                            if (index == 0) context.go('/login');
                          },
                        ),
                        const SizedBox(height: 32),
                        Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: AuthTextField(
                                      label: l10n.firstname,
                                      controller: _firstnameController,
                                      enabled: !isLoading,
                                      hintText: 'Jean',
                                      textInputAction: TextInputAction.next,
                                      validator: (value) {
                                        if (value == null ||
                                            value.trim().isEmpty) {
                                          return l10n.firstnameRequired;
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: AuthTextField(
                                      label: l10n.lastname,
                                      controller: _lastnameController,
                                      enabled: !isLoading,
                                      hintText: 'Dupont',
                                      textInputAction: TextInputAction.next,
                                      validator: (value) {
                                        if (value == null ||
                                            value.trim().isEmpty) {
                                          return l10n.lastnameRequired;
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              AuthTextField(
                                label: l10n.email,
                                controller: _emailController,
                                enabled: !isLoading,
                                hintText: 'nom@exemple.com',
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                autocorrect: false,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return l10n.emailRequired;
                                  }
                                  final emailRegex = RegExp(
                                    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                                  );
                                  if (!emailRegex.hasMatch(value.trim())) {
                                    return l10n.emailInvalid;
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              AuthTextField(
                                label: l10n.password,
                                controller: _passwordController,
                                enabled: !isLoading,
                                hintText: '••••••••',
                                obscureText: _obscurePassword,
                                textInputAction: TextInputAction.next,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? LucideIcons.eyeOff
                                        : LucideIcons.eye,
                                    size: 20,
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return l10n.passwordRequired;
                                  }
                                  if (value.length < 6) {
                                    return l10n.passwordTooShort;
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              AuthTextField(
                                label: l10n.confirmPassword,
                                controller: _confirmPasswordController,
                                enabled: !isLoading,
                                hintText: '••••••••',
                                obscureText: _obscureConfirmPassword,
                                textInputAction: TextInputAction.done,
                                onFieldSubmitted: (_) => _onRegister(),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureConfirmPassword
                                        ? LucideIcons.eyeOff
                                        : LucideIcons.eye,
                                    size: 20,
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscureConfirmPassword =
                                          !_obscureConfirmPassword;
                                    });
                                  },
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return l10n.confirmPasswordRequired;
                                  }
                                  if (value != _passwordController.text) {
                                    return l10n.passwordsDoNotMatch;
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                        if (authState.status == AuthStatus.error &&
                            authState.errorMessage != null) ...[
                          const SizedBox(height: 12),
                          AuthErrorBanner(message: authState.errorMessage!),
                        ],
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: FilledButton(
                            onPressed: isLoading ? null : _onRegister,
                            style: FilledButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                            ),
                            child: isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    l10n.register,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 24),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                l10n.alreadyHaveAccount,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                              TextButton(
                                onPressed: () => context.go('/login'),
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                  ),
                                  minimumSize: const Size(0, 36),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Text(
                                  l10n.login,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
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
