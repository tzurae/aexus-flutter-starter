import 'dart:async';

import 'package:applications/core/use_case.dart';
import 'package:domains/theme/theme_repository.dart';
import 'package:flutter/material.dart';

class SetThemeUseCase implements UseCase<void, ThemeMode> {
  final ThemeRepository _themeRepository;

  SetThemeUseCase(this._themeRepository);

  @override
  Future<void> call({required ThemeMode params}) {
    return _themeRepository.setThemeMode(params);
  }
}
