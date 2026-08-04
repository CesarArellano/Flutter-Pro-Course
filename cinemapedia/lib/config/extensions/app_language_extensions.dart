import 'dart:ui';

import '../../domain/entities/app_language.dart';

extension AppLanguageX on AppLanguage {
  String get tmdbLanguageCode => switch (this) {
    AppLanguage.en => 'en-US',
    AppLanguage.es => 'es-MX',
  };

  Locale get locale => Locale(name);
}
