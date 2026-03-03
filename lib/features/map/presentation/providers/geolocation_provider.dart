import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

enum GeolocationStatus {
  initial,
  loading,
  granted,
  denied,
  deniedForever,
  serviceDisabled,
}

class GeolocationState {
  const GeolocationState({
    this.status = GeolocationStatus.initial,
    this.position,
  });

  final GeolocationStatus status;
  final LatLng? position;

  bool get hasPosition => position != null;

  GeolocationState copyWith({GeolocationStatus? status, LatLng? position}) {
    return GeolocationState(
      status: status ?? this.status,
      position: position ?? this.position,
    );
  }
}

class GeolocationNotifier extends StateNotifier<GeolocationState> {
  GeolocationNotifier() : super(const GeolocationState());

  static const defaultPosition = LatLng(48.8566, 2.3522); // Paris

  Future<void> requestLocation() async {
    state = state.copyWith(status: GeolocationStatus.loading);

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        state = state.copyWith(status: GeolocationStatus.serviceDisabled);
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          state = state.copyWith(status: GeolocationStatus.denied);
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        state = state.copyWith(status: GeolocationStatus.deniedForever);
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 10),
        ),
      );
      state = GeolocationState(
        status: GeolocationStatus.granted,
        position: LatLng(position.latitude, position.longitude),
      );
    } catch (_) {
      state = state.copyWith(status: GeolocationStatus.denied);
    }
  }
}

final geolocationProvider =
    StateNotifierProvider<GeolocationNotifier, GeolocationState>(
      (ref) => GeolocationNotifier(),
    );

/// Calculates distance in km between two LatLng points (Haversine formula).
double distanceKm(LatLng from, LatLng to) {
  const earthRadius = 6371.0;
  final dLat = _toRadians(to.latitude - from.latitude);
  final dLng = _toRadians(to.longitude - from.longitude);
  final a =
      sin(dLat / 2) * sin(dLat / 2) +
      cos(_toRadians(from.latitude)) *
          cos(_toRadians(to.latitude)) *
          sin(dLng / 2) *
          sin(dLng / 2);
  final c = 2 * atan2(sqrt(a), sqrt(1 - a));
  return earthRadius * c;
}

double _toRadians(double degrees) => degrees * pi / 180;

/// Formats distance for display.
String formatDistance(double km) {
  if (km < 1) {
    return '${(km * 1000).round()} m';
  }
  if (km < 10) {
    return '${km.toStringAsFixed(1)} km';
  }
  return '${km.round()} km';
}

enum SortMode { defaultSort, proximity }

final sortModeProvider = StateProvider<SortMode>((ref) => SortMode.defaultSort);
