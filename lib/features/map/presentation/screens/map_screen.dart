import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/widgets/error_view.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../home/domain/models/locker_bay_summary.dart';
import '../providers/geolocation_provider.dart';
import '../providers/map_provider.dart';
import '../widgets/locker_bay_bottom_card.dart';
import '../widgets/locker_bay_marker.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen>
    with TickerProviderStateMixin {
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
    _animatedMove(
      LatLng(summary.lockerBay.latitude, summary.lockerBay.longitude),
      _mapController.camera.zoom.clamp(12.0, 18.0),
    );
  }

  void _onCardClosed() {
    ref.read(selectedLockerBayProvider.notifier).state = null;
  }

  void _onCardTapped(LockerBaySummary summary) {
    context.push('/home/${summary.lockerBay.id}');
  }

  void _zoomIn() {
    final zoom = (_mapController.camera.zoom + 1).clamp(3.0, 18.0);
    _animatedMove(_mapController.camera.center, zoom);
  }

  void _zoomOut() {
    final zoom = (_mapController.camera.zoom - 1).clamp(3.0, 18.0);
    _animatedMove(_mapController.camera.center, zoom);
  }

  void _resetCenter() {
    final center = ref.read(mapCenterProvider);
    _animatedMove(center, 6.0);
    ref.read(selectedLockerBayProvider.notifier).state = null;
  }

  Future<void> _locateMe() async {
    final geoNotifier = ref.read(geolocationProvider.notifier);
    await geoNotifier.requestLocation();

    final geoState = ref.read(geolocationProvider);

    if (geoState.hasPosition) {
      _animatedMove(geoState.position!, 13.0);
    } else {
      _showLocationError(geoState.status);
    }
  }

  void _showLocationError(GeolocationStatus status) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    String message;
    bool showSettingsButton = false;

    switch (status) {
      case GeolocationStatus.denied:
        message = l10n.mapLocationDenied;
      case GeolocationStatus.deniedForever:
        message = l10n.mapLocationDeniedForever;
        showSettingsButton = true;
      case GeolocationStatus.serviceDisabled:
        message = l10n.mapLocationServiceDisabled;
        showSettingsButton = true;
      default:
        message = l10n.mapLocationDenied;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              LucideIcons.mapPinOff,
              size: 18,
              color: colorScheme.onInverseSurface,
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        action: showSettingsButton
            ? SnackBarAction(
                label: l10n.mapOpenSettings,
                onPressed: () => Geolocator.openAppSettings(),
              )
            : null,
      ),
    );
  }

  void _selectNearest() {
    final geoState = ref.read(geolocationProvider);
    if (!geoState.hasPosition) return;

    final summaries = ref.read(mapLockerBaySummariesProvider).valueOrNull;
    if (summaries == null || summaries.isEmpty) return;

    final userPos = geoState.position!;
    final nearest = summaries.reduce((a, b) {
      final distA = distanceKm(
        userPos,
        LatLng(a.lockerBay.latitude, a.lockerBay.longitude),
      );
      final distB = distanceKm(
        userPos,
        LatLng(b.lockerBay.latitude, b.lockerBay.longitude),
      );
      return distA < distB ? a : b;
    });

    _onMarkerTapped(nearest);
  }

  void _animatedMove(LatLng destLocation, double destZoom) {
    final camera = _mapController.camera;
    final latTween = Tween<double>(
      begin: camera.center.latitude,
      end: destLocation.latitude,
    );
    final lngTween = Tween<double>(
      begin: camera.center.longitude,
      end: destLocation.longitude,
    );
    final zoomTween = Tween<double>(begin: camera.zoom, end: destZoom);

    final controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    final animation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOutCubic,
    );

    controller.addListener(() {
      _mapController.move(
        LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
        zoomTween.evaluate(animation),
      );
    });

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
      }
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final summariesAsync = ref.watch(mapLockerBaySummariesProvider);
    final selectedBay = ref.watch(selectedLockerBayProvider);
    final initialCenter = ref.watch(mapCenterProvider);
    final geoState = ref.watch(geolocationProvider);

    return Scaffold(
      body: summariesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => ErrorView(
          message: l10n.errorNetwork,
          onRetry: () => ref.invalidate(mapLockerBaySummariesProvider),
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
                  markers: [
                    // User position marker
                    if (geoState.hasPosition)
                      Marker(
                        point: geoState.position!,
                        width: 24,
                        height: 24,
                        child: const _UserPositionMarker(),
                      ),
                    // Locker bay markers
                    ...summaries.map((summary) {
                      final isSelected =
                          selectedBay?.lockerBay.id == summary.lockerBay.id;
                      return Marker(
                        point: LatLng(
                          summary.lockerBay.latitude,
                          summary.lockerBay.longitude,
                        ),
                        width: 80,
                        height: 50,
                        child: GestureDetector(
                          onTap: () => _onMarkerTapped(summary),
                          child: LockerBayMarker(
                            availableCount: summary.availableCount,
                            isSelected: isSelected,
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ],
            ),
            // Top-left: "Around me" pill button
            Positioned(
              left: 16,
              top: MediaQuery.of(context).padding.top + 12,
              child: _AroundMeButton(
                onPressed: _locateMe,
                isActive: geoState.hasPosition,
                isLoading: geoState.status == GeolocationStatus.loading,
              ),
            ),
            // Top-right: Nearest bay button (only visible when geolocation active)
            if (geoState.hasPosition)
              Positioned(
                right: 16,
                top: MediaQuery.of(context).padding.top + 12,
                child: _NearestButton(onPressed: _selectNearest),
              ),
            // Right side: Map controls
            Positioned(
              right: 16,
              bottom: selectedBay != null ? 200 : 32,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _MapButton(icon: LucideIcons.plus, onPressed: _zoomIn),
                  const SizedBox(height: 8),
                  _MapButton(icon: LucideIcons.minus, onPressed: _zoomOut),
                  const SizedBox(height: 8),
                  _MapButton(
                    icon: geoState.hasPosition
                        ? LucideIcons.navigation
                        : LucideIcons.locate,
                    onPressed: geoState.hasPosition
                        ? () => _animatedMove(geoState.position!, 13.0)
                        : _resetCenter,
                    isAccented: geoState.hasPosition,
                  ),
                ],
              ),
            ),
            // Bottom card
            if (selectedBay != null)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: SafeArea(
                  child: LockerBayBottomCard(
                    summary: selectedBay,
                    userPosition: geoState.position,
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

class _UserPositionMarker extends StatelessWidget {
  const _UserPositionMarker();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colorScheme.primary.withValues(alpha: 0.15),
        border: Border.all(color: colorScheme.primary, width: 2.5),
      ),
      child: Center(
        child: Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colorScheme.primary,
          ),
        ),
      ),
    );
  }
}

class _AroundMeButton extends StatelessWidget {
  const _AroundMeButton({
    required this.onPressed,
    required this.isActive,
    required this.isLoading,
  });

  final VoidCallback onPressed;
  final bool isActive;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Material(
      elevation: 3,
      borderRadius: BorderRadius.circular(24),
      color: isActive ? colorScheme.primary : colorScheme.surface,
      child: InkWell(
        onTap: isLoading ? null : onPressed,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isLoading)
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: isActive
                        ? colorScheme.onPrimary
                        : colorScheme.primary,
                  ),
                )
              else
                Icon(
                  LucideIcons.crosshair,
                  size: 16,
                  color: isActive ? colorScheme.onPrimary : colorScheme.primary,
                ),
              const SizedBox(width: 8),
              Text(
                l10n.mapAroundMe,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: isActive
                      ? colorScheme.onPrimary
                      : colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NearestButton extends StatelessWidget {
  const _NearestButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Material(
      elevation: 3,
      borderRadius: BorderRadius.circular(24),
      color: colorScheme.surface,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                LucideIcons.mapPin,
                size: 14,
                color: colorScheme.primary,
              ),
              const SizedBox(width: 6),
              Text(
                l10n.mapNearest,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MapButton extends StatelessWidget {
  const _MapButton({
    required this.icon,
    required this.onPressed,
    this.isAccented = false,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final bool isAccented;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(12),
      color: isAccented ? colorScheme.primary : colorScheme.surface,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(
            icon,
            size: 20,
            color: isAccented ? colorScheme.onPrimary : colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
