import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ProfileSection extends StatelessWidget {
  const ProfileSection({
    super.key,
    required this.title,
    required this.icon,
    required this.children,
  });

  final String title;
  final IconData icon;
  final List<ProfileSectionTile> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Row(
            children: [
              Icon(icon, size: 16, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              for (int i = 0; i < children.length; i++) ...[
                children[i],
                if (i < children.length - 1)
                  Divider(
                    height: 1,
                    indent: 56,
                    color: theme.colorScheme.outlineVariant.withValues(
                      alpha: 0.5,
                    ),
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class ProfileSectionTile extends StatelessWidget {
  const ProfileSectionTile({
    super.key,
    required this.icon,
    required this.label,
    this.value,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String? value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 20, color: theme.colorScheme.onSurfaceVariant),
            const SizedBox(width: 16),
            Expanded(child: Text(label, style: theme.textTheme.bodyMedium)),
            if (value != null)
              Text(
                value!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            if (onTap != null) ...[
              const SizedBox(width: 4),
              Icon(
                LucideIcons.chevronRight,
                size: 18,
                color: theme.colorScheme.onSurfaceVariant.withValues(
                  alpha: 0.5,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
