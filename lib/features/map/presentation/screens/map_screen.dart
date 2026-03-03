import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../home/domain/models/locker_bay_summary.dart';
import '../providers/map_provider.dart';
import '../widgets/locker_bay_bottom_card.dart';
import '../widgets/locker_bay_marker.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  late final MapController _mapController;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  void _onMarkerTapped(LockerBaySummary summary) {
    ref.read(selectedLockerBayProvider.notifier).state = summary;
    _mapController.move(
      LatLng(summary.lockerBay.latitude, summary.lockerBay.longitude),
      _mapController.camera.zoom,
    );
  }

  void _onCardClosed() {
    ref.read(selectedLockerBayProvider.notifier).state = null;
  }

  void _onCardTapped(LockerBaySummary summary) {
    context.go('/home/${summary.lockerBay.id}');
  }

  void _zoomIn() {
    final zoom = _mapController.camera.zoom + 1;
    _mapController.move(_mapController.camera.center, zoom);
  }

  void _zoomOut() {
    final zoom = _mapController.camera.zoom - 1;
    _mapController.move(_mapController.camera.center, zoom);
  }

  void _resetCenter() {
    final center = ref.read(mapCenterProvider);
    _mapController.move(center, 6.0);
    ref.read(selectedLockerBayProvider.notifier).state = null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final summariesAsync = ref.watch(mapLockerBaySummariesProvider);
    final selectedBay = ref.watch(selectedLockerBayProvider);
    final initialCenter = ref.watch(mapCenterProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(l10n.map),
        backgroundColor: colorScheme.surface.withValues(alpha: 0.85),
        elevation: 0,
      ),
      body: summariesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                LucideIcons.alertTriangle,
                size: 48,
                color: colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                l10n.error,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              FilledButton.icon(
                onPressed: () => ref.invalidate(mapLockerBaySummariesProvider),
                icon: const Icon(LucideIcons.refreshCw, size: 16),
                label: Text(l10n.retry),
              ),
            ],
          ),
        ),
        data: (summaries) => Stack(
          children: [
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: initialCenter,
                initialZoom: 6.0,
                minZoom: 3.0,
                maxZoom: 18.0,
                onTap: (_, _) => _onCardClosed(),
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.lockedin.mobile',
                ),
                MarkerLayer(
                  markers: summaries.map((summary) {
                    final isSelected =
                        selectedBay?.lockerBay.id == summary.lockerBay.id;
                    return Marker(
                      point: LatLng(
                        summary.lockerBay.latitude,
                        summary.lockerBay.longitude,
                      ),
                      width: 60,
                      height: 40,
                      child: GestureDetector(
                        onTap: () => _onMarkerTapped(summary),
                        child: LockerBayMarker(
                          availableCount: summary.availableCount,
                          isSelected: isSelected,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
            Positioned(
              right: 16,
              bottom: selectedBay != null ? 180 : 32,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _MapButton(icon: LucideIcons.plus, onPressed: _zoomIn),
                  const SizedBox(height: 8),
                  _MapButton(icon: LucideIcons.minus, onPressed: _zoomOut),
                  const SizedBox(height: 8),
                  _MapButton(icon: LucideIcons.locate, onPressed: _resetCenter),
                ],
              ),
            ),
            if (selectedBay != null)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: SafeArea(
                  child: LockerBayBottomCard(
                    summary: selectedBay,
                    onTap: () => _onCardTapped(selectedBay),
                    onClose: _onCardClosed,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _MapButton extends StatelessWidget {
  const _MapButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(12),
      color: colorScheme.surface,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(icon, size: 20, color: colorScheme.onSurface),
        ),
      ),
    );
  }
}
