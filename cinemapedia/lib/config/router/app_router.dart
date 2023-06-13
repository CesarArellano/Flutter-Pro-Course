
import 'package:cinemapedia/presentation/views/views.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/screens/screens.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (_, __, child) => HomeScreen(
        childView: child,
      ),
      routes: [
        GoRoute(
          path: '/',
          builder: (_, __) => const HomeView(),
          routes: [
            GoRoute(
              path: 'movie/:id',
              name: MovieScreen.name,
              builder: (_, state)  {
                final String movieId = state.pathParameters['id'] ?? 'no-id';
                return MovieScreen( movieId: movieId );
              }
            ),
          ]
        ),
        GoRoute(
          path: '/favorites',
          builder: (_, __) => const FavoritesView(),
        ),
      ]
    ),
    // Father / Child Route
    // GoRoute(
    //   path: '/',
    //   name: HomeScreen.name,
    //   builder: (_, __) => const HomeScreen(),
    //   routes: [
    //     GoRoute(
    //       path: 'movie/:id',
    //       name: MovieScreen.name,
    //       builder: (_, state)  {
    //         final String movieId = state.pathParameters['id'] ?? 'no-id';
    //         return MovieScreen( movieId: movieId );
    //       }
    //     ),
    //   ]
    // ),
  ]
);

