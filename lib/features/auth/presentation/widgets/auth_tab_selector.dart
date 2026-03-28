import 'package:flutter/material.dart';

class AuthTabSelector extends StatefulWidget {
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
  State<AuthTabSelector> createState() => _AuthTabSelectorState();
}

class _AuthTabSelectorState extends State<AuthTabSelector>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    // Start from opposite position and animate to selected
    final from = widget.selectedIndex == 0 ? 1.0 : 0.0;
    final to = widget.selectedIndex.toDouble();

    _slideAnimation = Tween<double>(
      begin: from,
      end: to,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
      child: AnimatedBuilder(
        animation: _slideAnimation,
        builder: (context, _) {
          final progress = _slideAnimation.value;

          return Stack(
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  final tabWidth = constraints.maxWidth / 2;
                  return Transform.translate(
                    offset: Offset(progress * tabWidth, 0),
                    child: Container(
                      width: tabWidth,
                      height: 40,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                  );
                },
              ),
              Row(
                children: [
                  _TabLabel(
                    label: widget.loginLabel,
                    progress: 1 - progress,
                    onTap: () => widget.onTabChanged(0),
                  ),
                  _TabLabel(
                    label: widget.registerLabel,
                    progress: progress,
                    onTap: () => widget.onTabChanged(1),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _TabLabel extends StatelessWidget {
  const _TabLabel({
    required this.label,
    required this.progress,
    required this.onTap,
  });

  final String label;
  final double progress;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Center(
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Color.lerp(
                theme.colorScheme.onSurfaceVariant,
                theme.colorScheme.onPrimary,
                progress,
              ),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
