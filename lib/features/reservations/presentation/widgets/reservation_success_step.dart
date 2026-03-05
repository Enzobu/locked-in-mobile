import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../l10n/app_localizations.dart';

class ReservationSuccessStep extends StatefulWidget {
  const ReservationSuccessStep({
    required this.publicForm,
    required this.onBackToHome,
    required this.onViewReservations,
    super.key,
  });

  final String publicForm;
  final VoidCallback onBackToHome;
  final VoidCallback onViewReservations;

  @override
  State<ReservationSuccessStep> createState() => _ReservationSuccessStepState();
}

class _ReservationSuccessStepState extends State<ReservationSuccessStep>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        children: [
          const Spacer(flex: 2),

          // Success icon with animation
          ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF16A34A).withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                LucideIcons.checkCircle2,
                size: 64,
                color: Color(0xFF16A34A),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Title
          Text(
            l10n.reservationSuccessTitle,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),

          // Subtitle
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              l10n.reservationSuccessSubtitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 32),

          // Reservation code card
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: colorScheme.primary.withValues(alpha: 0.15),
              ),
            ),
            child: Column(
              children: [
                Text(
                  l10n.reservationCode,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      LucideIcons.qrCode,
                      size: 24,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(width: 14),
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          widget.publicForm,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            letterSpacing: 3,
                            color: colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Copy button
                TextButton.icon(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: widget.publicForm));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(widget.publicForm),
                        behavior: SnackBarBehavior.floating,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  icon: const Icon(LucideIcons.copy, size: 16),
                  label: Text(
                    l10n.reservationCode,
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
              ],
            ),
          ),

          const Spacer(flex: 3),

          // Action buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FilledButton(
                  onPressed: widget.onViewReservations,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    l10n.reservationViewAll,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                OutlinedButton(
                  onPressed: widget.onBackToHome,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    side: BorderSide(color: colorScheme.primary),
                  ),
                  child: Text(
                    l10n.reservationBackToHome,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
