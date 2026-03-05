import 'package:flutter/material.dart';

class LockerBaySkeleton extends StatefulWidget {
  const LockerBaySkeleton({super.key});

  @override
  State<LockerBaySkeleton> createState() => _LockerBaySkeletonState();
}

class _LockerBaySkeletonState extends State<LockerBaySkeleton>
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
    _animation = Tween<double>(
      begin: 0.3,
      end: 0.7,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        final shimmerColor = colorScheme.onSurface.withValues(
          alpha: _animation.value * 0.12,
        );
        return ListView(
          padding: const EdgeInsets.only(bottom: 24),
          physics: const NeverScrollableScrollPhysics(),
          children: [
            // Greeting skeleton
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
              child: _ShimmerBox(
                width: 140,
                height: 14,
                color: shimmerColor,
              ),
            ),
            // Title skeleton
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: _ShimmerBox(
                width: 220,
                height: 22,
                color: shimmerColor,
              ),
            ),
            // Search bar skeleton
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: shimmerColor,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            // Nearby section title skeleton
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
              child: _ShimmerBox(
                width: 160,
                height: 16,
                color: shimmerColor,
              ),
            ),
            // Nearby carousel skeleton
            SizedBox(
              height: 170,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: 2,
                separatorBuilder: (_, _) => const SizedBox(width: 12),
                itemBuilder: (_, _) => Container(
                  width: 280,
                  decoration: BoxDecoration(
                    color: shimmerColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 28),
            // City chips skeleton
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
              child: _ShimmerBox(
                width: 120,
                height: 16,
                color: shimmerColor,
              ),
            ),
            SizedBox(
              height: 60,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: 4,
                separatorBuilder: (_, _) => const SizedBox(width: 10),
                itemBuilder: (_, _) => Column(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: shimmerColor,
                    ),
                    const SizedBox(height: 4),
                    _ShimmerBox(
                      width: 40,
                      height: 10,
                      color: shimmerColor,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Bay list items skeleton
            ...List.generate(
              3,
              (_) => Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                child: Card(
                  margin: EdgeInsets.zero,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: shimmerColor,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _ShimmerBox(
                                width: 140,
                                height: 14,
                                color: shimmerColor,
                              ),
                              const SizedBox(height: 6),
                              _ShimmerBox(
                                width: 90,
                                height: 12,
                                color: shimmerColor,
                              ),
                            ],
                          ),
                        ),
                        _ShimmerBox(
                          width: 50,
                          height: 22,
                          color: shimmerColor,
                          radius: 6,
                        ),
                      ],
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
}

class _ShimmerBox extends StatelessWidget {
  const _ShimmerBox({
    required this.width,
    required this.height,
    required this.color,
    this.radius = 4,
  });

  final double width;
  final double height;
  final Color color;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
