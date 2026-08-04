import 'package:clappy/infrastructure/datasources/movie_db_datasource.dart';
import 'package:clappy/infrastructure/repositories/movies_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../network/network_service_provider.dart';

// Inmutable Repository
final moviesRepositoryProvider = Provider<MoviesRepositoryImpl>((ref) {
  return MoviesRepositoryImpl(
    MovieDbDatasource(ref.watch(networkServiceProvider)),
  );
});
