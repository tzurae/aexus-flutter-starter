import 'dart:async';

import 'package:applications/core/no_params.dart';
import 'package:applications/core/use_case.dart';
import 'package:domains/theme/theme_repository.dart';
import 'package:flutter/material.dart';

class GetThemeUseCase implements UseCase<ThemeMode, NoParams> {
  final ThemeRepository _themeRepository;

  GetThemeUseCase(this._themeRepository);

  @override
  Future<ThemeMode> call({required NoParams params}) {
    return _themeRepository.getThemeMode();
  }
}
