import 'dart:async';
import 'package:flutter/material.dart';

abstract class ThemeRepository {
  /// 獲取當前主題模式
  Future<ThemeMode> getThemeMode();
  
  /// 設置主題模式
  Future<void> setThemeMode(ThemeMode themeMode);
  
  /// 獲取是否為暗黑模式
  Future<bool> isDarkMode();
}