
import 'package:go_router/go_router.dart';

import 'package:test_app/presentation/todo/screens/screens.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: TodoScreen.name ,
      builder: (context, state) => const TodoScreen(),
    )
  ]
);