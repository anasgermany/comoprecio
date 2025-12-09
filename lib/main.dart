import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core/theme/theme.dart';
import 'features/search/presentation/screens/home_screen.dart';
import 'features/search/presentation/screens/search_results_screen.dart';
import 'features/product/presentation/screens/product_detail_screen.dart';
import 'features/alerts/presentation/screens/alerts_screen.dart';
import 'features/profile/presentation/screens/profile_screen.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'shared/widgets/main_scaffold.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: ComoPrecioApp(),
    ),
  );
}

class ComoPrecioApp extends StatelessWidget {
  const ComoPrecioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'ComoPrecio',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: _router,
    );
  }
}

// Navigation keys for nested navigation
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

// Router configuration
final _router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    // Main shell with bottom navigation
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => MainScaffold(child: child),
      routes: [
        // Home / Search
        GoRoute(
          path: '/',
          name: 'home',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: HomeScreen(),
          ),
        ),
        // Search Results
        GoRoute(
          path: '/search',
          name: 'search',
          pageBuilder: (context, state) {
            final query = state.uri.queryParameters['q'] ?? '';
            return NoTransitionPage(
              child: SearchResultsScreen(query: query),
            );
          },
        ),
        // Alerts
        GoRoute(
          path: '/alerts',
          name: 'alerts',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: AlertsScreen(),
          ),
        ),
        // Profile
        GoRoute(
          path: '/profile',
          name: 'profile',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: ProfileScreen(),
          ),
        ),
      ],
    ),
    // Product detail (full screen)
    GoRoute(
      path: '/product/:id',
      name: 'product',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final productId = state.pathParameters['id']!;
        return ProductDetailScreen(productId: productId);
      },
    ),
    // Auth (full screen)
    GoRoute(
      path: '/login',
      name: 'login',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const LoginScreen(),
    ),
  ],
);
