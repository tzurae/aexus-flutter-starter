import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:rizzlt_flutter_starter/constants/enums/env_enum.dart';

class AppConfigService {
  static final AppConfigService _instance = AppConfigService._internal();
  static AppConfigService get instance => _instance;
  AppConfigService._internal();
  bool _initialized = false;
  late EnvEnum _env;

  late String _supabaseUrl;
  late String _supabaseAnonKey;
  late bool _enableCrashReporting;
  late bool _enableAnalytics;

  Future<void> init() async {
    if (_initialized) return;
    await dotenv.load();
    final envString = dotenv.env['ENV'] ?? 'dev';
    _env = _parseEnv(envString);
    // 讀取其他配置
    _supabaseUrl = dotenv.env['SUPABASE_URL'] ?? '';
    _supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'] ?? '';

    // 根據環境設置預設值
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

  /// 獲取當前環境
  EnvEnum get environment => _env;

  /// 獲取環境名稱
  EnvEnum get env => _env;

  /// Supabase URL
  String get supabaseUrl => _supabaseUrl;

  /// Supabase 匿名密鑰
  String get supabaseAnonKey => _supabaseAnonKey;

  /// 是否啟用崩潰報告
  bool get enableCrashReporting => _enableCrashReporting;

  /// 是否啟用分析
  bool get enableAnalytics => _enableAnalytics;

  /// 獲取指定的環境變數
  String? getEnv(String key) {
    return dotenv.env[key];
  }
}
