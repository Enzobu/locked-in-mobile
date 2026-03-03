import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/models/customer.dart';
import '../../../../l10n/app_localizations.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key, required this.customer});

  final Customer? customer;

  String _getInitials() {
    if (customer == null) return '?';
    final first = customer!.firstname.isNotEmpty ? customer!.firstname[0] : '';
    final last = customer!.lastname.isNotEmpty ? customer!.lastname[0] : '';
    return '$first$last'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        Container(
          width: 88,
          height: 88,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                theme.colorScheme.primary,
                theme.colorScheme.primary.withValues(alpha: 0.7),
              ],
            ),
          ),
          child: Center(
            child: Text(
              _getInitials(),
              style: theme.textTheme.headlineMedium?.copyWith(
                color: theme.colorScheme.onPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          customer?.fullName ?? '-',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          customer?.email ?? '-',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        if (customer != null) ...[
          const SizedBox(height: 4),
          Text(
            l10n.profileMemberSince(
              DateFormat.yMMMM(
                Localizations.localeOf(context).languageCode,
              ).format(customer!.createdAt),
            ),
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
            ),
          ),
        ],
      ],
    );
  }
}
