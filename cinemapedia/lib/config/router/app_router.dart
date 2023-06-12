
import 'package:go_router/go_router.dart';

import '../../presentation/screens/screens.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: HomeScreen.name,
      builder: (_, __) => const HomeScreen(),
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
  ]
);