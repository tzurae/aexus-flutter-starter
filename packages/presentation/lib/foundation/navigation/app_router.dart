import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:presentation/features/auth/login.dart';
import 'package:presentation/features/auth/store/auth_store.dart';
import 'package:presentation/features/home/home.dart';
import 'package:presentation/features/post/post_list.dart';
import 'package:presentation/features/postdetail/post_detail.dart';

class AppRouter {
  static GoRouter get router => _router;
  static const String home = 'home';
  static const String login = 'login';
  static const String postList = 'post-list';
  static const String postDetail = 'post-detail';

  static const String homePath = '/home';
  static const String loginPath = '/login';
  static const String postLIstPath = '/posts';
  static const String postDetailPath = '/posts/:postId';

  static final GoRouter _router = GoRouter(
      debugLogDiagnostics: true,
      initialLocation: homePath,
      routes: [
        GoRoute(
          name: home,
          path: homePath,
          builder: (context, state) => HomeScreen.create(),
        ),
        GoRoute(
          name: login,
          path: loginPath,
          builder: (context, state) => LoginScreen.create(),
        ),
        GoRoute(
          name: postList,
          path: postLIstPath,
          builder: (context, state) => const PostListScreen(),
          routes: [
            GoRoute(
                name: postDetail,
                path: ':postId',
                builder: (context, state) {
                  final postId = state.pathParameters['postId'];
                  return PostDetailScreen(postId: postId!);
                })
          ],
        ),
      ],
      redirect: (
        BuildContext context,
        GoRouterState state,
      ) async {
        final authStore = GetIt.instance<AuthStore>();
        final isLoggedIn = authStore.state.isLoggedIn;
        final isLoggingIn = state.matchedLocation == loginPath;
        if (!isLoggedIn && !isLoggingIn) {
          return loginPath;
        }
        if (isLoggedIn && isLoggingIn) {
          return homePath;
        }
        return null;
      },
      errorBuilder: (
        context,
        state,
      ) =>
          const Scaffold(
            body: Center(
              child: Text('404'),
            ),
          ));
}
