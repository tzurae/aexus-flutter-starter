import 'dart:async';

import 'package:domains/auth/login_credentials_vo.dart';

abstract class AuthRepository {
  Future<bool> login(LoginCredentials params);
  Future<void> logout();
  Future<bool> isLoggedIn();
}
