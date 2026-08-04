import '../entities/app_language.dart';
import '../entities/theme_preference.dart';

abstract class SettingsRepository {
  Future<ThemePreference> getThemePreference();

  Future<void> setThemePreference(ThemePreference preference);

  Future<AppLanguage> getAppLanguage();

  Future<void> setAppLanguage(AppLanguage language);
}
