import '../../domain/entities/movie_credit.dart';
import '../../domain/entities/person.dart';
import '../../domain/repositories/people_repository.dart';
import '../datasources/person_moviedb_datasource.dart';

class PeopleRepositoryImpl implements PeopleRepository {
  PeopleRepositoryImpl(this.datasource);

  final PersonMovieDbDatasource datasource;

  @override
  Future<List<Person>> getPopular({int page = 1}) {
    return datasource.getPopular(page: page);
  }

  @override
  Future<Person> getPersonById(String id) {
    return datasource.getPersonById(id);
  }

  @override
  Future<List<MovieCredit>> getMovieCreditsByPerson(int personId) {
    return datasource.getMovieCreditsByPerson(personId);
  }
}
