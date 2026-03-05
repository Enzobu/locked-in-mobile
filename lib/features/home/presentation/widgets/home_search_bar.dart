import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../l10n/app_localizations.dart';
import 'filter_bottom_sheet.dart';

class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.isFocused,
    required this.searchQuery,
    required this.isFilterActive,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isFocused;
  final String searchQuery;
  final bool isFilterActive;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isFocused
                ? colorScheme.outline.withValues(alpha: 0.3)
                : colorScheme.outlineVariant.withValues(alpha: 0.4),
          ),
        ),
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          onChanged: onChanged,
          style: theme.textTheme.bodyMedium,
          textInputAction: TextInputAction.search,
          cursorColor: colorScheme.primary,
          decoration: InputDecoration(
            hintText: l10n.searchLockerBays,
            hintStyle: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            prefixIcon: Icon(
              LucideIcons.search,
              size: 20,
              color: colorScheme.onSurfaceVariant,
            ),
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (searchQuery.isNotEmpty)
                  GestureDetector(
                    onTap: onClear,
                    child: Container(
                      width: 32,
                      alignment: Alignment.center,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: colorScheme.onSurfaceVariant
                              .withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          LucideIcons.x,
                          size: 14,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                GestureDetector(
                  onTap: () => FilterBottomSheet.show(context),
                  child: Container(
                    margin: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: isFilterActive
                          ? colorScheme.primary
                          : colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      LucideIcons.slidersHorizontal,
                      size: 18,
                      color: isFilterActive
                          ? colorScheme.onPrimary
                          : colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
            filled: false,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ),
    );
  }
}
