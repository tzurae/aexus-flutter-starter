import 'package:applications/mapper/locale_mapper.dart';
import 'package:flutter/material.dart';
import 'package:presentation/enum/resource_state.dart';

class LanguageState {
  final Locale currentLocale;
  final List<LocaleDTO> supportedLocales;
  final ResourceState status;
  final String? errorMessage;

  LanguageState._({
    required this.status,
    required this.currentLocale,
    required this.supportedLocales,
    this.errorMessage,
  }) : super();

  factory LanguageState.initial() => LanguageState._(
      status: ResourceState.init,
      currentLocale: const Locale('en', 'US'),
      supportedLocales:
          LocaleMapper.getSupportedLocales(const Locale('en', 'US')),
      errorMessage: null);

  LanguageState copyWith({
    ResourceState? status,
    Locale? currentLocale,
    bool? isLoading,
    List<LocaleDTO>? supportedLocales,
    String? errorMsg,
  }) {
    return LanguageState._(
      status: status ?? this.status,
      currentLocale: currentLocale ?? this.currentLocale,
      supportedLocales: supportedLocales ?? this.supportedLocales,
      errorMessage: errorMsg ?? errorMessage,
    );
  }

  String get languageCode => currentLocale.languageCode;
  String? get countryCode => currentLocale.countryCode;
  bool get hasError => status == ResourceState.error;
}
