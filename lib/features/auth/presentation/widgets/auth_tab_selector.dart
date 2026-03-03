import 'package:flutter/material.dart';

class AuthTabSelector extends StatelessWidget {
  const AuthTabSelector({
    required this.selectedIndex,
    required this.loginLabel,
    required this.registerLabel,
    required this.onTabChanged,
    super.key,
  });

  final int selectedIndex;
  final String loginLabel;
  final String registerLabel;
  final ValueChanged<int> onTabChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(28),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => onTabChanged(0),
              child: Container(
                decoration: BoxDecoration(
                  color: selectedIndex == 0
                      ? theme.colorScheme.primary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(24),
                ),
                alignment: Alignment.center,
                child: Text(
                  loginLabel,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: selectedIndex == 0
                        ? theme.colorScheme.onPrimary
                        : theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => onTabChanged(1),
              child: Container(
                decoration: BoxDecoration(
                  color: selectedIndex == 1
                      ? theme.colorScheme.primary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(24),
                ),
                alignment: Alignment.center,
                child: Text(
                  registerLabel,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: selectedIndex == 1
                        ? theme.colorScheme.onPrimary
                        : theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
