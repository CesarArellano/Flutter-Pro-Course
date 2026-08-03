import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../infrastructure/datasources/tv_moviedb_datasource.dart';
import '../../../infrastructure/repositories/series_repository_impl.dart';
import '../network/network_service_provider.dart';

// Inmutable Repository
final seriesRepositoryProvider = Provider<SeriesRepositoryImpl>((ref) {
  return SeriesRepositoryImpl(
    TvMovieDbDatasource(ref.watch(networkServiceProvider)),
  );
});
