import 'package:infra/clients/supabase/supabase_client.dart';
import 'package:infra/core/exceptions/network_exceptions.dart';
import 'package:infra/datasources/remote/interfaces/auth_remote_datasource.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClientWrapper _supabaseClient;

  AuthRemoteDataSourceImpl(this._supabaseClient);

  @override
  Future<bool> login(String email, String password) async {
    try {
      final res = await _supabaseClient.client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return res.user != null;
    } catch (e) {
      throw NetworkException(message: "Authentication failed: ${e.toString()}");
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    return _supabaseClient.client.auth.currentUser != null;
  }

  @override
  Future<void> logout() async {
    try {
      await _supabaseClient.client.auth.signOut();
    } catch (e) {
      throw NetworkException(message: "Logout failed: ${e.toString()}");
    }
  }
}
