
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../infrastructure/datasources/actor_moviedb_datasource.dart';
import '../../../infrastructure/repositories/actors_repository_impl.dart';

// Inmutable Repository
final actorsRepositoryProvider = Provider<ActorsRepositoryImpl>((ref) {
  return ActorsRepositoryImpl( ActorMovieDbDatasource() );
});