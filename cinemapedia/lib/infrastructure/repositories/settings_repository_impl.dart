import '../../domain/entities/app_language.dart';
import '../../domain/entities/theme_preference.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/shared_preferences_datasource.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl(this.datasource);

  final SharedPreferencesDatasource datasource;

  @override
  Future<ThemePreference> getThemePreference() {
    return datasource.getThemePreference();
  }

  @override
  Future<void> setThemePreference(ThemePreference preference) {
    return datasource.setThemePreference(preference);
  }

  @override
  Future<AppLanguage> getAppLanguage() {
    return datasource.getAppLanguage();
  }

  @override
  Future<void> setAppLanguage(AppLanguage language) {
    return datasource.setAppLanguage(language);
  }
}
