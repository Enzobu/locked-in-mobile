import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/widgets/auth_text_field.dart';
import '../providers/profile_provider.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _firstnameController;
  late final TextEditingController _lastnameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    final customer = ref.read(currentCustomerProvider);
    _firstnameController = TextEditingController(text: customer?.firstname);
    _lastnameController = TextEditingController(text: customer?.lastname);
    _emailController = TextEditingController(text: customer?.email);
    _phoneController = TextEditingController(text: customer?.phone ?? '');
  }

  @override
  void dispose() {
    _firstnameController.dispose();
    _lastnameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final phone = _phoneController.text.trim();
    final success = await ref
        .read(profileUpdateProvider.notifier)
        .updateProfile(
          firstname: _firstnameController.text.trim(),
          lastname: _lastnameController.text.trim(),
          email: _emailController.text.trim(),
          phone: phone.isEmpty ? null : phone,
        );

    if (!mounted) return;

    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final updateState = ref.read(profileUpdateProvider);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.profileEditSuccess),
          backgroundColor: theme.colorScheme.primary,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
      Navigator.of(context).pop();
    } else if (!updateState.hasFieldErrors) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(updateState.errorMessage ?? l10n.profileEditError),
          backgroundColor: theme.colorScheme.error,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final updateState = ref.watch(profileUpdateProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.profileEdit),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilledButton(
              onPressed: updateState.isLoading ? null : _submit,
              child: updateState.isLoading
                  ? SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: theme.colorScheme.onPrimary,
                      ),
                    )
                  : Text(l10n.save),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AuthTextField(
                label: l10n.firstname,
                controller: _firstnameController,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return l10n.firstnameRequired;
                  }
                  final serverError =
                      updateState.fieldErrors['firstname'];
                  if (serverError != null) return serverError;
                  return null;
                },
              ),
              const SizedBox(height: 16),
              AuthTextField(
                label: l10n.lastname,
                controller: _lastnameController,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return l10n.lastnameRequired;
                  }
                  final serverError =
                      updateState.fieldErrors['lastname'];
                  if (serverError != null) return serverError;
                  return null;
                },
              ),
              const SizedBox(height: 16),
              AuthTextField(
                label: l10n.email,
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autocorrect: false,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return l10n.emailRequired;
                  }
                  final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
                  if (!emailRegex.hasMatch(value.trim())) {
                    return l10n.emailInvalid;
                  }
                  final serverError =
                      updateState.fieldErrors['email'];
                  if (serverError != null) return serverError;
                  return null;
                },
              ),
              const SizedBox(height: 16),
              AuthTextField(
                label: l10n.phone,
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.done,
                autocorrect: false,
                validator: (value) {
                  final serverError =
                      updateState.fieldErrors['phone'];
                  if (serverError != null) return serverError;
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
