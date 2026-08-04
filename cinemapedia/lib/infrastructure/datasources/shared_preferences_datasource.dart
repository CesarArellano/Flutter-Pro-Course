import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/datasources/settings_datasource.dart';
import '../../domain/entities/app_language.dart';
import '../../domain/entities/theme_preference.dart';

class SharedPreferencesDatasource implements SettingsDatasource {
  static const _themePreferenceKey = 'theme_preference';
  static const _appLanguageKey = 'app_language';

  @override
  Future<ThemePreference> getThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_themePreferenceKey);

    return ThemePreference.values.firstWhere(
      (preference) => preference.name == value,
      orElse: () => ThemePreference.dark,
    );
  }

  @override
  Future<void> setThemePreference(ThemePreference preference) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themePreferenceKey, preference.name);
  }

  @override
  Future<AppLanguage> getAppLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_appLanguageKey);

    return AppLanguage.values.firstWhere(
      (language) => language.name == value,
      orElse: () => AppLanguage.en,
    );
  }

  @override
  Future<void> setAppLanguage(AppLanguage language) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_appLanguageKey, language.name);
  }
}
