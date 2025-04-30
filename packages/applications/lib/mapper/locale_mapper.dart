import 'package:flutter/material.dart';

class LocaleDTO {
  final String languageCode;
  final String? countryCode;
  final String displayName;
  final bool isSelected;

  const LocaleDTO({
    required this.languageCode,
    this.countryCode,
    required this.displayName,
    required this.isSelected,
  });

  LocaleDTO copyWith({bool? isSelected}) {
    return LocaleDTO(
      languageCode: this.languageCode,
      countryCode: this.countryCode,
      displayName: this.displayName,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}

class LocaleMapper {
  static LocaleDTO toDTO(Locale locale, {bool isSelected = false}) {
    return LocaleDTO(
      languageCode: locale.languageCode,
      countryCode: locale.countryCode,
      displayName: _getDisplayName(locale.languageCode),
      isSelected: isSelected,
    );
  }

  static Locale toDomain(LocaleDTO dto) {
    return Locale(dto.languageCode, dto.countryCode);
  }

  static List<LocaleDTO> getSupportedLocales(Locale currentLocale) {
    return [
      Locale('en', 'US'),
      Locale('da', 'DK'),
      Locale('es', 'ES'),
    ]
        .map((locale) => toDTO(locale,
            isSelected: locale.languageCode == currentLocale.languageCode))
        .toList();
  }

  static String _getDisplayName(String languageCode) {
    switch (languageCode) {
      case 'en':
        return 'English';
      case 'da':
        return 'Danish';
      case 'es':
        return 'Spanish';
      default:
        return languageCode;
    }
  }
}
