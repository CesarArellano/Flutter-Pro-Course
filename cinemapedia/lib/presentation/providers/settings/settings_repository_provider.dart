import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../infrastructure/datasources/shared_preferences_datasource.dart';
import '../../../infrastructure/repositories/settings_repository_impl.dart';

// Inmutable Repository
final settingsRepositoryProvider = Provider<SettingsRepositoryImpl>((ref) {
  return SettingsRepositoryImpl(SharedPreferencesDatasource());
});
