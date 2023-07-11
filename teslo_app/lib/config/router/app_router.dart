import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:teslo_shop/features/auth/presentation/providers/auth_provider.dart';

import '../../features/auth/auth.dart';
import '../../features/products/products.dart';
import 'app_router_notifier.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  final goRouterNotifier = ref.read(goRouterNotifierProvider);

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: goRouterNotifier,
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const CheckAuthStatusScreen(),
      ),
      ///* Auth Routes
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),

      ///* Product Routes
      GoRoute(
        path: '/',
        builder: (context, state) => const ProductsScreen(),
      ),
    ],
    redirect: (context, state) {
      
      final isGoingTo = state.location;
      final authStatus = goRouterNotifier.authStatus;
      
      log('goRouter redirect: $isGoingTo, $authStatus');
      if( isGoingTo == '/splash' && authStatus == AuthStatus.checking ) return null;
      
      if( authStatus == AuthStatus.notAuthenticated ) {
        if( isGoingTo == '/login' || isGoingTo == '/register') {
          return null;
        }
        return '/login';
      }
      
      if( authStatus == AuthStatus.authenticated ) {
        if( isGoingTo == '/login' || isGoingTo == '/register' || isGoingTo == '/splash' ) {
          return '/';
        }
      }

      return isGoingTo;
    },
  );
});