import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import './features/presentation/movies_screen.dart';

GoRouter router = GoRouter(initialLocation: '/', routes: [
  GoRoute(
    path: '/',
    builder: (context, state) => const MoviesScreen(),
  ),
  /*GoRoute(
    path: '/login',
    builder: (context, state) => const LoginScreen(),
    pageBuilder: defaultPageBuilder<LoginScreen>(const LoginScreen()),
  ),
  GoRoute(
    path: '/main',
    builder: (context, state) => const MainScreen(),
    pageBuilder: defaultPageBuilder<MainScreen>(const MainScreen()),
  ),
  GoRoute(
    path: '/search',
    builder: (context, state) => const SearchScreen(),
    pageBuilder: defaultPageBuilder<SearchScreen>(const SearchScreen()),
  ),

  GoRoute(
    path: '/movie/:id',
    builder: (context, state) => MovieScreen(state.params['id']!),
  ),
  GoRoute(
    path: '/tv/:id',
    builder: (context, state) => TVShowScreen(state.params['id']!),
  )*/
]);

CustomTransitionPage buildPageWithDefaultTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        FadeTransition(opacity: animation, child: child),
  );
}

Page<dynamic> Function(BuildContext, GoRouterState) defaultPageBuilder<T>(
        Widget child) =>
    (BuildContext context, GoRouterState state) {
      return buildPageWithDefaultTransition<T>(
        context: context,
        state: state,
        child: child,
      );
    };
