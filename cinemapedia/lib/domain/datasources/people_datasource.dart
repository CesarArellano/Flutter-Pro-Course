import 'package:clappy/domain/entities/entities.dart';

abstract class PeopleDatasource {
  Future<List<Person>> getPopular({int page = 1});

  Future<Person> getPersonById(String id);

  Future<List<MovieCredit>> getMovieCreditsByPerson(int personId);
}
