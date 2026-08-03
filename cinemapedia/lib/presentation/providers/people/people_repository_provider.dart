import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../infrastructure/datasources/person_moviedb_datasource.dart';
import '../../../infrastructure/repositories/people_repository_impl.dart';
import '../network/network_service_provider.dart';

// Inmutable Repository
final peopleRepositoryProvider = Provider<PeopleRepositoryImpl>((ref) {
  return PeopleRepositoryImpl(
    PersonMovieDbDatasource(ref.watch(networkServiceProvider)),
  );
});
