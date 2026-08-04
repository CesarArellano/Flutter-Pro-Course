import 'package:clappy/domain/entities/app_language.dart';
import 'package:clappy/infrastructure/repositories/settings_repository_impl.dart';
import 'package:clappy/presentation/providers/settings/settings_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appLanguageProvider =
    StateNotifierProvider<AppLanguageNotifier, AppLanguage>((ref) {
      return AppLanguageNotifier(ref.watch(settingsRepositoryProvider));
    });

class AppLanguageNotifier extends StateNotifier<AppLanguage> {
  // [initialValue] lets `main()` preload the persisted preference before
  // `runApp()` (see how it's overridden there) so the very first frame — and
  // the very first NetworkService built from it — already reflects it,
  // instead of racing HomeView's synchronous initState() against this
  // notifier's async SharedPreferences read.
  AppLanguageNotifier(this._repository, {AppLanguage? initialValue})
    : super(initialValue ?? AppLanguage.en) {
    if (initialValue == null) _loadPersisted();
  }

  final SettingsRepositoryImpl _repository;

  Future<void> _loadPersisted() async {
    final persisted = await _repository.getAppLanguage();
    // Only reassign if it actually changed — an unconditional `state = ...`
    // here would notify listeners on every launch even when the persisted
    // value equals the default, rebuilding networkServiceProvider (which
    // watches this provider) and cascading through every repository/notifier
    // that depends on it for no reason.
    if (!mounted || persisted == state) return;
    state = persisted;
  }

  Future<void> setAppLanguage(AppLanguage language) async {
    state = language;
    await _repository.setAppLanguage(language);
  }
}
