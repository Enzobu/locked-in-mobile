import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../features/auth/presentation/providers/auth_provider.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/home/presentation/screens/home_screen.dart';
import '../features/map/presentation/screens/map_screen.dart';
import '../features/profile/presentation/screens/profile_screen.dart';
import '../features/reservations/presentation/screens/reservations_screen.dart';
import '../l10n/app_localizations.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/home',
    redirect: (context, state) {
      final isAuthenticated = authState.status == AuthStatus.authenticated;
      final isOnLogin = state.matchedLocation == '/login';

      if (authState.status == AuthStatus.initial ||
          authState.status == AuthStatus.loading) {
        return null;
      }

      if (!isAuthenticated && !isOnLogin) return '/login';
      if (isAuthenticated && isOnLogin) return '/home';
      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNavBar(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/map',
                builder: (context, state) => const MapScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/reservations',
                builder: (context, state) => const ReservationsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});

class ScaffoldWithNavBar extends StatelessWidget {
  const ScaffoldWithNavBar({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(LucideIcons.home),
            selectedIcon: const Icon(LucideIcons.home),
            label: l10n.home,
          ),
          NavigationDestination(
            icon: const Icon(LucideIcons.map),
            selectedIcon: const Icon(LucideIcons.map),
            label: l10n.map,
          ),
          NavigationDestination(
            icon: const Icon(LucideIcons.calendarCheck),
            selectedIcon: const Icon(LucideIcons.calendarCheck),
            label: l10n.reservations,
          ),
          NavigationDestination(
            icon: const Icon(LucideIcons.user),
            selectedIcon: const Icon(LucideIcons.user),
            label: l10n.profile,
          ),
        ],
      ),
    );
  }
}
