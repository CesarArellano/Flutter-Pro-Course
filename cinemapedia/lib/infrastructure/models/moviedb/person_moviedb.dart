class PersonMovieDB {
  factory PersonMovieDB.fromJson(Map<String, dynamic> json) => PersonMovieDB(
    adult: json["adult"] ?? false,
    gender: json["gender"],
    id: json["id"],
    knownForDepartment: json["known_for_department"],
    name: json["name"],
    originalName: json["original_name"],
    popularity: (json["popularity"] as num?)?.toDouble() ?? 0.0,
    profilePath: json["profile_path"],
  );
  PersonMovieDB({
    required this.adult,
    required this.gender,
    required this.id,
    required this.knownForDepartment,
    required this.name,
    required this.originalName,
    required this.popularity,
    required this.profilePath,
  });

  final bool adult;
  final int? gender;
  final int id;
  final String? knownForDepartment;
  final String name;
  final String? originalName;
  final double popularity;
  final String? profilePath;

  Map<String, dynamic> toJson() => {
    "adult": adult,
    "gender": gender,
    "id": id,
    "known_for_department": knownForDepartment,
    "name": name,
    "original_name": originalName,
    "popularity": popularity,
    "profile_path": profilePath,
  };
}

class PersonMovieDbResponse {
  PersonMovieDbResponse({
    this.page,
    required this.results,
    this.totalPages,
    this.totalResults,
  });

  factory PersonMovieDbResponse.fromJson(Map<String, dynamic> json) =>
      PersonMovieDbResponse(
        page: json["page"],
        results: json["results"] == null
            ? []
            : List<PersonMovieDB>.from(
                (json["results"] as List).map((x) => PersonMovieDB.fromJson(x)),
              ),
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
      );
  int? page;
  List<PersonMovieDB> results;
  int? totalPages;
  int? totalResults;

  Map<String, dynamic> toJson() => {
    "page": page,
    "results": List<dynamic>.from(results.map((x) => x.toJson())),
    "total_pages": totalPages,
    "total_results": totalResults,
  };
}
