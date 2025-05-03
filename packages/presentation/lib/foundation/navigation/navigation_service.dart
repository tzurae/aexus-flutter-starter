import 'package:go_router/go_router.dart';

import 'app_router.dart';

class NavigationService {
  final GoRouter _router;

  NavigationService(this._router);

  Future<void> goToHome() async {
    _router.goNamed(AppRouter.home);
  }

  Future<void> goToLogin() async {
    _router.goNamed(AppRouter.login);
  }

  Future<void> goToPostList() async {
    _router.goNamed(AppRouter.postList);
  }

  Future<void> goToPostDetail(String postId) async {
    _router.goNamed(AppRouter.postDetail, pathParameters: {'postId': postId});
  }

  void pop<T>([T? result]) async {
    _router.pop(result);
  }
}
