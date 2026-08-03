import '../entities/entities.dart';

abstract class PeopleRepository {
  Future<List<Person>> getPopular({int page = 1});

  Future<Person> getPersonById(String id);

  Future<List<MovieCredit>> getMovieCreditsByPerson(int personId);
}
