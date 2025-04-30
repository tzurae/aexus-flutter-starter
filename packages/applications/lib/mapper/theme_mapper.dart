import 'package:flutter/material.dart';

/// 主題數據傳輸對象，用於Presentation層
class ThemeDTO {
  final ThemeMode themeMode;
  final String displayName;
  final bool isSelected;
  final IconData icon;

  const ThemeDTO({
    required this.themeMode,
    required this.displayName,
    required this.isSelected,
    required this.icon,
  });

  /// 創建一個新的ThemeDTO，更新isSelected屬性
  ThemeDTO copyWith({bool? isSelected}) {
    return ThemeDTO(
      themeMode: this.themeMode,
      displayName: this.displayName,
      isSelected: isSelected ?? this.isSelected,
      icon: this.icon,
    );
  }
}

class ThemeMapper {
  static ThemeDTO toDTO(ThemeMode themeMode, {bool isSelected = false}) {
    return ThemeDTO(
      themeMode: themeMode,
      displayName: _getDisplayName(themeMode),
      isSelected: isSelected,
      icon: _getThemeIcon(themeMode),
    );
  }

  static ThemeMode toDomain(ThemeDTO dto) {
    return dto.themeMode;
  }

  static List<ThemeDTO> getAllThemeModes(ThemeMode currentThemeMode) {
    return [
      ThemeMode.system,
      ThemeMode.light,
      ThemeMode.dark,
    ].map((mode) => toDTO(mode, isSelected: mode == currentThemeMode)).toList();
  }

  static String _getDisplayName(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.system:
        return 'System';
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      default:
        return themeMode.toString();
    }
  }

  static IconData _getThemeIcon(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.system:
        return Icons.settings_suggest;
      case ThemeMode.light:
        return Icons.wb_sunny;
      case ThemeMode.dark:
        return Icons.nightlight_round;
      default:
        return Icons.help_outline;
    }
  }
}
