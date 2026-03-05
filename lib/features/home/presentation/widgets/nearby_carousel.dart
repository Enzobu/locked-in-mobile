import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../l10n/app_localizations.dart';
import '../../domain/models/locker_bay_summary.dart';
import '../providers/home_provider.dart';
import 'nearby_carousel_card.dart';

class NearbyCarousel extends ConsumerStatefulWidget {
  const NearbyCarousel({
    super.key,
    required this.summaries,
    required this.gradients,
  });

  final List<LockerBaySummary> summaries;
  final List<List<Color>> gradients;

  @override
  ConsumerState<NearbyCarousel> createState() => _NearbyCarouselState();
}

class _NearbyCarouselState extends ConsumerState<NearbyCarousel> {
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final nearby = widget.summaries;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
          child: Row(
            children: [
              Icon(LucideIcons.navigation,
                  size: 16, color: colorScheme.primary),
              const SizedBox(width: 6),
              Text(
                l10n.nearbyBays,
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 170,
          child: PageView.builder(
            controller: PageController(viewportFraction: 0.85),
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemCount: nearby.length,
            itemBuilder: (context, index) {
              final s = nearby[index];
              final distance = ref.watch(
                formattedDistanceProvider(s.lockerBay.id),
              );
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: NearbyCarouselCard(
                  summary: s,
                  gradient: widget.gradients[index % widget.gradients.length],
                  distance: distance,
                  onTap: () => context.go('/home/${s.lockerBay.id}'),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            nearby.length,
            (i) => AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: i == _currentPage ? 24 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: i == _currentPage
                    ? colorScheme.primary
                    : colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
