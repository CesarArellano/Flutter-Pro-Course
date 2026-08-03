import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../infrastructure/datasources/actor_moviedb_datasource.dart';
import '../../../infrastructure/repositories/actors_repository_impl.dart';
import '../network/network_service_provider.dart';

// Inmutable Repository
final actorsRepositoryProvider = Provider<ActorsRepositoryImpl>((ref) {
  return ActorsRepositoryImpl(
    ActorMovieDbDatasource(ref.watch(networkServiceProvider)),
  );
});
