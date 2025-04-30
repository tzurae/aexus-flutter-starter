import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseClientWrapper {
  late final SupabaseClient _client;

  SupabaseClientWrapper() {
    _client = Supabase.instance.client;
  }

  SupabaseClient get client => _client;

  static Future<void> initialize() async {
    await dotenv.load(fileName: ".env");
    await Supabase.initialize(
      url: dotenv.get("SUPABASE_URL"),
      anonKey: dotenv.get("SUPABASE_ANON_KEY"),
    );
  }
}
