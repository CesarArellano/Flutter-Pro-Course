import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../config/extensions/app_language_extensions.dart';
import '../../../config/network/network_service.dart';
import '../settings/app_language_provider.dart';

// Riverpod caches this instance per ProviderContainer, so every datasource
// that watches it shares the same Dio instance (and its interceptors).
// Watching appLanguageProvider means switching language rebuilds this (and
// every repository/datasource that depends on it), so the next API call uses
// the new TMDB language — already-fetched list state isn't retroactively
// re-fetched, only new requests are affected.
final networkServiceProvider = Provider<NetworkService>((ref) {
  final language = ref.watch(appLanguageProvider);

  return NetworkService(
    defaultQueryParameters: {'language': language.tmdbLanguageCode},
  );
});
