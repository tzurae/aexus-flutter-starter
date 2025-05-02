import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:rizzlt_flutter_starter/core/bootstrap/app_config_service.dart'; // Import AppConfigService

class SupabaseClientWrapper {
  late final SupabaseClient _client;

  SupabaseClientWrapper() {
    _client = Supabase.instance.client;
  }

  SupabaseClient get client => _client;

  static Future<void> initialize() async {
    // Ensure AppConfigService is initialized before accessing it
    // This assumes AppConfigService.init() is called during AppBootstrap
    final appConfig = AppConfigService.instance;

    // Retrieve keys from AppConfigService
    final supabaseUrl = appConfig.supabaseUrl;
    final supabaseAnonKey = appConfig.supabaseAnonKey;

    // Check if keys are available (AppConfigService already handles throwing in release mode)
    if (supabaseUrl.isEmpty || supabaseAnonKey.isEmpty) {
      // Log or handle the error appropriately if not in release mode
      // AppConfigService should have already logged/thrown if needed.
      print("Error: Supabase URL or Anon Key is missing. Check --dart-define flags.");
      // Potentially throw an exception here as well if initialization cannot proceed
      // throw Exception("Supabase configuration missing.");
      return; // Or handle more gracefully
    }

    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
  }
}
