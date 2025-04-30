import 'dart:async';

import 'package:applications/core/no_params.dart';
import 'package:applications/core/use_case.dart';
import 'package:domains/locale/locale_repository.dart';
import 'package:flutter/material.dart';

class GetLocaleUseCase implements UseCase<Locale, NoParams> {
  final LocaleRepository _localeRepository;

  GetLocaleUseCase(this._localeRepository);

  @override
  Future<Locale> call({required NoParams params}) {
    return _localeRepository.getLocale();
  }
}
