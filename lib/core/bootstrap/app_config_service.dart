import 'package:flutter/foundation.dart'
    show kDebugMode; // For print statements
import 'package:rizzlt_flutter_starter/constants/enums/env_enum.dart';

class AppConfigService {
  static final AppConfigService _instance = AppConfigService._internal();
  static AppConfigService get instance => _instance;
  AppConfigService._internal();
  bool _initialized = false;
  late EnvEnum _env;

  late String _supabaseUrl;
  late String _supabaseAnonKey;
  late String _xxteaPassword; // Added for xxtea password
  late bool _enableCrashReporting;
  late bool _enableAnalytics;

  Future<void> init() async {
    if (_initialized) return;

    // Read environment from --dart-define
    const envString = String.fromEnvironment('ENV', defaultValue: 'dev');
    _env = _parseEnv(envString);

    // Read Supabase keys from --dart-define
    _supabaseUrl = const String.fromEnvironment('SUPABASE_URL');
    _supabaseAnonKey = const String.fromEnvironment('SUPABASE_ANON_KEY');

    // Read xxtea password from --dart-define
    _xxteaPassword = const String.fromEnvironment('XXTEA_PASSWORD');

    // Validate required keys, especially for production
    if (_env == EnvEnum.production) {
      if (_supabaseUrl.isEmpty) {
        throw Exception(
            'SUPABASE_URL must be provided via --dart-define for production builds.');
      }
      if (_supabaseAnonKey.isEmpty) {
        throw Exception(
            'SUPABASE_ANON_KEY must be provided via --dart-define for production builds.');
      }
      if (_xxteaPassword.isEmpty) {
        // Decide if xxtea password is required for production
        // If yes, uncomment the line below:
        // throw Exception('XXTEA_PASSWORD must be provided via --dart-define for production builds.');
        // If no, you might want to log a warning or handle it differently
        if (kDebugMode) {
          // Only print warnings in debug/dev mode
          print(
              'Warning: XXTEA_PASSWORD not provided via --dart-define for production build.');
        }
      }
    } else {
      // Optional: Print warnings in non-production environments if keys are missing
      if (_supabaseUrl.isEmpty && kDebugMode) {
        print('Warning: SUPABASE_URL not provided via --dart-define.');
      }
      if (_supabaseAnonKey.isEmpty && kDebugMode) {
        print('Warning: SUPABASE_ANON_KEY not provided via --dart-define.');
      }
      if (_xxteaPassword.isEmpty && kDebugMode) {
        print('Warning: XXTEA_PASSWORD not provided via --dart-define.');
        // Consider setting a default development password if applicable
        // _xxteaPassword = 'default_dev_password';
      }
    }

    _enableCrashReporting = _env == EnvEnum.production;
    _enableAnalytics = _env != EnvEnum.test;

    _initialized = true;
  }

  EnvEnum _parseEnv(String env) {
    switch (env.toLowerCase()) {
      case 'prod':
      case 'production':
        return EnvEnum.production;
      case 'test':
      case 'testing':
        return EnvEnum.test;
      case 'dev':
      case 'development':
      default:
        return EnvEnum.development;
    }
  }

  EnvEnum get environment => _env;

  EnvEnum get env => _env;

  String get supabaseUrl => _supabaseUrl;

  String get supabaseAnonKey => _supabaseAnonKey;

  String get xxteaPassword => _xxteaPassword; // Added getter for xxtea password

  bool get enableCrashReporting => _enableCrashReporting;

  bool get enableAnalytics => _enableAnalytics;
}
