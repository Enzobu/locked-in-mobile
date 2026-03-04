import 'package:flutter/material.dart';

class ReservationSkeleton extends StatefulWidget {
  const ReservationSkeleton({super.key});

  @override
  State<ReservationSkeleton> createState() => _ReservationSkeletonState();
}

class _ReservationSkeletonState extends State<ReservationSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.3, end: 0.7).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _SectionHeaderSkeleton(opacity: _animation.value),
            const SizedBox(height: 8),
            ...List.generate(
              2,
              (_) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _ReservationCardSkeleton(opacity: _animation.value),
              ),
            ),
            const SizedBox(height: 16),
            _SectionHeaderSkeleton(opacity: _animation.value),
            const SizedBox(height: 8),
            ...List.generate(
              3,
              (_) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _ReservationCardSkeleton(opacity: _animation.value),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SectionHeaderSkeleton extends StatelessWidget {
  const _SectionHeaderSkeleton({required this.opacity});

  final double opacity;

  @override
  Widget build(BuildContext context) {
    final shimmerColor = Theme.of(context).colorScheme.onSurface.withValues(
      alpha: opacity * 0.12,
    );

    return Row(
      children: [
        Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            color: shimmerColor,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          height: 14,
          width: 140,
          decoration: BoxDecoration(
            color: shimmerColor,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }
}

class _ReservationCardSkeleton extends StatelessWidget {
  const _ReservationCardSkeleton({required this.opacity});

  final double opacity;

  @override
  Widget build(BuildContext context) {
    final shimmerColor = Theme.of(context).colorScheme.onSurface.withValues(
      alpha: opacity * 0.12,
    );

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: shimmerColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 14,
                        width: 120,
                        decoration: BoxDecoration(
                          color: shimmerColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        height: 12,
                        width: 80,
                        decoration: BoxDecoration(
                          color: shimmerColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 22,
                  width: 60,
                  decoration: BoxDecoration(
                    color: shimmerColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  height: 12,
                  width: 200,
                  decoration: BoxDecoration(
                    color: shimmerColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const Spacer(),
                Container(
                  height: 14,
                  width: 60,
                  decoration: BoxDecoration(
                    color: shimmerColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
