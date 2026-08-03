import '../../config/network/network_service.dart';
import '../../domain/datasources/people_datasource.dart';
import '../../domain/entities/movie_credit.dart';
import '../../domain/entities/person.dart';
import '../mappers/movie_credit_mapper.dart';
import '../mappers/person_mapper.dart';
import '../models/moviedb/person_details.dart';
import '../models/moviedb/person_movie_credits_response.dart';
import '../models/moviedb/person_moviedb.dart';

class PersonMovieDbDatasource implements PeopleDatasource {
  PersonMovieDbDatasource(this.networkService);

  final NetworkService networkService;

  @override
  Future<List<Person>> getPopular({int page = 1}) async {
    final response = await networkService.get(
      '/person/popular',
      queryParameters: {'page': page},
    );

    final PersonMovieDbResponse personDbResponse =
        PersonMovieDbResponse.fromJson(response.data);

    return personDbResponse.results
        .map((personDb) => PersonMapper.personDBToEntity(personDb))
        .toList();
  }

  @override
  Future<Person> getPersonById(String id) async {
    final response = await networkService.get('/person/$id');

    if (response.statusCode != 200) {
      throw Exception('Person with id: $id not found');
    }

    final personDetails = PersonDetails.fromJson(response.data);

    return PersonMapper.personDetailsToEntity(personDetails);
  }

  @override
  Future<List<MovieCredit>> getMovieCreditsByPerson(int personId) async {
    final response = await networkService.get(
      '/person/$personId/movie_credits',
    );

    final creditsResponse = PersonMovieCreditsResponse.fromJson(response.data);

    return creditsResponse.cast
        .map((cast) => MovieCreditMapper.castToEntity(cast))
        .toList();
  }
}
