import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../l10n/app_localizations.dart';

enum OpenLockerState { loading, success, error }

class OpenLockerOverlay extends StatefulWidget {
  const OpenLockerOverlay({
    required this.state,
    required this.onDone,
    required this.onRetry,
    super.key,
  });

  final OpenLockerState state;
  final VoidCallback onDone;
  final VoidCallback onRetry;

  @override
  State<OpenLockerOverlay> createState() => _OpenLockerOverlayState();
}

class _OpenLockerOverlayState extends State<OpenLockerOverlay>
    with TickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final AnimationController _successController;
  late final AnimationController _lockController;

  late final Animation<double> _pulseAnimation;
  late final Animation<double> _successScale;
  late final Animation<double> _successOpacity;
  late final Animation<double> _lockRotation;
  late final Animation<double> _checkScale;
  late final Animation<double> _ringExpand;
  late final Animation<double> _ringOpacity;
  late final Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();

    // Pulse animation for loading state
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Lock icon rotation
    _lockController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _lockRotation = Tween<double>(begin: 0, end: -0.1).animate(
      CurvedAnimation(parent: _lockController, curve: Curves.elasticOut),
    );

    // Success animation controller
    _successController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _successScale = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _successController,
        curve: const Interval(0, 0.5, curve: Curves.elasticOut),
      ),
    );
    _successOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _successController,
        curve: const Interval(0, 0.3, curve: Curves.easeOut),
      ),
    );
    _checkScale = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _successController,
        curve: const Interval(0.3, 0.7, curve: Curves.elasticOut),
      ),
    );
    _ringExpand = Tween<double>(begin: 0.5, end: 1.5).animate(
      CurvedAnimation(
        parent: _successController,
        curve: const Interval(0, 0.8, curve: Curves.easeOut),
      ),
    );
    _ringOpacity = Tween<double>(begin: 0.6, end: 0).animate(
      CurvedAnimation(
        parent: _successController,
        curve: const Interval(0.2, 0.8, curve: Curves.easeOut),
      ),
    );
    _shimmerAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _successController,
        curve: const Interval(0.4, 1, curve: Curves.easeInOut),
      ),
    );

    if (widget.state == OpenLockerState.loading) {
      _lockController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(OpenLockerOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.state != widget.state) {
      if (widget.state == OpenLockerState.success) {
        _pulseController.stop();
        _lockController.stop();
        _successController.forward();
      } else if (widget.state == OpenLockerState.error) {
        _pulseController.stop();
        _lockController.stop();
      } else if (widget.state == OpenLockerState.loading) {
        _successController.reset();
        _pulseController.repeat(reverse: true);
        _lockController.repeat(reverse: true);
      }
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _successController.dispose();
    _lockController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return PopScope(
      canPop: false,
      child: Positioned.fill(
        child: Material(
          color: Colors.black.withValues(alpha: 0.85),
          child: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildIcon(colorScheme),
                    const SizedBox(height: 32),
                    _buildTitle(theme, l10n),
                    const SizedBox(height: 12),
                    _buildSubtitle(theme, l10n),
                    if (widget.state == OpenLockerState.success ||
                        widget.state == OpenLockerState.error) ...[
                      const SizedBox(height: 40),
                      _buildButton(theme, l10n),
                      if (widget.state == OpenLockerState.error) ...[
                        const SizedBox(height: 12),
                        _buildCloseButton(theme, l10n),
                      ],
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(ColorScheme colorScheme) {
    return SizedBox(
      width: 160,
      height: 160,
      child: switch (widget.state) {
        OpenLockerState.loading => _buildLoadingIcon(colorScheme),
        OpenLockerState.success => _buildSuccessIcon(colorScheme),
        OpenLockerState.error => _buildErrorIcon(),
      },
    );
  }

  Widget _buildLoadingIcon(ColorScheme colorScheme) {
    return AnimatedBuilder(
      animation: Listenable.merge([_pulseController, _lockController]),
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer glow ring
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: colorScheme.primary.withValues(alpha: 0.2),
                    width: 2,
                  ),
                ),
              ),
              // Spinning ring
              SizedBox(
                width: 130,
                height: 130,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: colorScheme.primary,
                  backgroundColor: colorScheme.primary.withValues(alpha: 0.15),
                ),
              ),
              // Inner icon container
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorScheme.primary.withValues(alpha: 0.15),
                  border: Border.all(
                    color: colorScheme.primary.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: Transform.rotate(
                  angle: _lockRotation.value,
                  child: Icon(
                    LucideIcons.unlock,
                    size: 36,
                    color: colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSuccessIcon(ColorScheme colorScheme) {
    const successColor = Color(0xFF16A34A);
    return AnimatedBuilder(
      animation: _successController,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Expanding ring
            Transform.scale(
              scale: _ringExpand.value,
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: successColor.withValues(alpha: _ringOpacity.value),
                    width: 3,
                  ),
                ),
              ),
            ),
            // Particle effects
            ..._buildParticles(successColor),
            // Main circle
            Transform.scale(
              scale: _successScale.value,
              child: Opacity(
                opacity: _successOpacity.value,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: successColor.withValues(alpha: 0.15),
                    border: Border.all(
                      color: successColor.withValues(alpha: 0.4),
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: successColor.withValues(alpha: 0.3),
                        blurRadius: 24,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: Transform.scale(
                    scale: _checkScale.value,
                    child: const Icon(
                      LucideIcons.unlock,
                      size: 44,
                      color: successColor,
                    ),
                  ),
                ),
              ),
            ),
            // Shimmer overlay
            if (_shimmerAnimation.value > 0 && _shimmerAnimation.value < 1)
              Positioned.fill(
                child: ClipOval(
                  child: ShaderMask(
                    shaderCallback: (bounds) {
                      return LinearGradient(
                        begin: Alignment(
                          -1 + 3 * _shimmerAnimation.value,
                          -0.5,
                        ),
                        end: Alignment(0 + 3 * _shimmerAnimation.value, 0.5),
                        colors: [
                          Colors.transparent,
                          Colors.white.withValues(alpha: 0.3),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ).createShader(bounds);
                    },
                    blendMode: BlendMode.srcATop,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: successColor.withValues(alpha: 0.1),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  List<Widget> _buildParticles(Color color) {
    return List.generate(8, (index) {
      final angle = (index * pi * 2) / 8;
      final delay = index * 0.05;
      final particleProgress = (_successController.value - delay).clamp(
        0.0,
        1.0,
      );
      final distance = 60.0 + (particleProgress * 30);
      final opacity = (1.0 - particleProgress).clamp(0.0, 1.0);

      return Positioned(
        left: 80 + cos(angle) * distance - 4,
        top: 80 + sin(angle) * distance - 4,
        child: Opacity(
          opacity: opacity * 0.8,
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
              boxShadow: [
                BoxShadow(color: color.withValues(alpha: 0.5), blurRadius: 6),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildErrorIcon() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 500),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFDC2626).withValues(alpha: 0.15),
              border: Border.all(
                color: const Color(0xFFDC2626).withValues(alpha: 0.4),
                width: 3,
              ),
            ),
            child: const Icon(
              LucideIcons.alertTriangle,
              size: 44,
              color: Color(0xFFDC2626),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTitle(ThemeData theme, AppLocalizations l10n) {
    final text = switch (widget.state) {
      OpenLockerState.loading => l10n.openLockerOpening,
      OpenLockerState.success => l10n.openLockerSuccess,
      OpenLockerState.error => l10n.error,
    };

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: Text(
        text,
        key: ValueKey(widget.state),
        style: theme.textTheme.headlineSmall?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w800,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildSubtitle(ThemeData theme, AppLocalizations l10n) {
    final text = switch (widget.state) {
      OpenLockerState.loading => null,
      OpenLockerState.success => l10n.openLockerSuccessSubtitle,
      OpenLockerState.error => l10n.openLockerError,
    };

    if (text == null) return const SizedBox(height: 20);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: Text(
        text,
        key: ValueKey(widget.state),
        style: theme.textTheme.bodyLarge?.copyWith(
          color: Colors.white.withValues(alpha: 0.7),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildButton(ThemeData theme, AppLocalizations l10n) {
    final isSuccess = widget.state == OpenLockerState.success;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Opacity(opacity: value.clamp(0.0, 1.0), child: child),
        );
      },
      child: SizedBox(
        width: double.infinity,
        child: FilledButton.icon(
          onPressed: isSuccess ? widget.onDone : widget.onRetry,
          icon: Icon(
            isSuccess ? LucideIcons.check : LucideIcons.refreshCw,
            size: 20,
          ),
          label: Text(isSuccess ? l10n.openLockerDone : l10n.retry),
          style: FilledButton.styleFrom(
            backgroundColor: isSuccess
                ? const Color(0xFF16A34A)
                : theme.colorScheme.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCloseButton(ThemeData theme, AppLocalizations l10n) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: widget.onDone,
        style: TextButton.styleFrom(
          foregroundColor: Colors.white.withValues(alpha: 0.7),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        child: Text(l10n.cancel),
      ),
    );
  }
}
