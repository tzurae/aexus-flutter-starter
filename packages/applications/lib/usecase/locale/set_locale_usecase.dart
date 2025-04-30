import 'dart:async';

import 'package:applications/core/use_case.dart';
import 'package:domains/locale/locale_repository.dart';
import 'package:flutter/material.dart';

class SetLocaleUseCase implements UseCase<void, Locale> {
  final LocaleRepository _localeRepository;

  SetLocaleUseCase(this._localeRepository);

  @override
  Future<void> call({required Locale params}) {
    return _localeRepository.setLocale(params);
  }
}
