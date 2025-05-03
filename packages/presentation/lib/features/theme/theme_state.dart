import 'package:applications/mapper/theme_mapper.dart';
import 'package:flutter/material.dart';
import 'package:presentation/shared/enum/resource_state.dart';

class ThemeState {
  final ThemeMode themeMode;
  final ResourceState toggleThemeStatus;
  final String? errorMessage;
  final List<ThemeDTO> availableThemes;

  ThemeState(
      {required this.toggleThemeStatus,
      required this.themeMode,
      required this.availableThemes,
      this.errorMessage})
      : super();

  factory ThemeState.initial() => ThemeState(
        toggleThemeStatus: ResourceState.init,
        themeMode: ThemeMode.system,
        availableThemes: ThemeMapper.getAllThemeModes(ThemeMode.system),
        errorMessage: null,
      );

  ThemeState copyWith({
    ResourceState? toggleThemeStatus,
    ThemeMode? themeMode,
    bool? isLoading,
    List<ThemeDTO>? availableThemes,
    String? errorMessage,
  }) {
    return ThemeState(
      toggleThemeStatus: toggleThemeStatus ?? this.toggleThemeStatus,
      themeMode: themeMode ?? this.themeMode,
      availableThemes: availableThemes ?? this.availableThemes,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  bool get isDarkMode => themeMode == ThemeMode.dark;
  bool get isLightMode => themeMode == ThemeMode.light;
  bool get isSystemMode => themeMode == ThemeMode.system;
  bool get hasError => errorMessage != null;
}
