import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../config/network/network_service.dart';

// Riverpod caches this instance per ProviderContainer, so every datasource
// that watches it shares the same Dio instance (and its interceptors).
final networkServiceProvider = Provider<NetworkService>((ref) {
  return NetworkService();
});
