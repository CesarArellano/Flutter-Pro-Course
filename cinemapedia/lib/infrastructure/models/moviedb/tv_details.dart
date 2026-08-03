class TvDetails {
  TvDetails({
    this.adult,
    this.backdropPath,
    this.episodeRunTime,
    this.firstAirDate,
    this.genres,
    this.homepage,
    this.id,
    this.inProduction,
    this.languages,
    this.lastAirDate,
    this.name,
    this.numberOfEpisodes,
    this.numberOfSeasons,
    this.originCountry,
    this.originalLanguage,
    this.originalName,
    this.overview,
    this.popularity,
    this.posterPath,
    this.status,
    this.tagline,
    this.voteAverage,
    this.voteCount,
  });

  factory TvDetails.fromJson(Map<String, dynamic> json) => TvDetails(
    adult: json["adult"],
    backdropPath: json["backdrop_path"] ?? '',
    episodeRunTime: json["episode_run_time"] == null
        ? []
        : List<int>.from((json["episode_run_time"] as List).map((x) => x)),
    firstAirDate: json["first_air_date"] != null && json["first_air_date"] != ''
        ? DateTime.parse(json["first_air_date"])
        : null,
    genres: json["genres"] == null
        ? []
        : List<Genre>.from(
            (json["genres"] as List).map((x) => Genre.fromJson(x)),
          ),
    homepage: json["homepage"],
    id: json["id"],
    inProduction: json["in_production"],
    languages: json["languages"] == null
        ? []
        : List<String>.from((json["languages"] as List).map((x) => x)),
    lastAirDate: json["last_air_date"] != null && json["last_air_date"] != ''
        ? DateTime.parse(json["last_air_date"])
        : null,
    name: json["name"],
    numberOfEpisodes: json["number_of_episodes"],
    numberOfSeasons: json["number_of_seasons"],
    originCountry: json["origin_country"] == null
        ? []
        : List<String>.from((json["origin_country"] as List).map((x) => x)),
    originalLanguage: json["original_language"],
    originalName: json["original_name"],
    overview: json["overview"],
    popularity: (json["popularity"] as num?)?.toDouble(),
    posterPath: json["poster_path"],
    status: json["status"],
    tagline: json["tagline"],
    voteAverage: (json["vote_average"] as num?)?.toDouble(),
    voteCount: json["vote_count"],
  );
  bool? adult;
  String? backdropPath;
  List<int>? episodeRunTime;
  DateTime? firstAirDate;
  List<Genre>? genres;
  String? homepage;
  int? id;
  bool? inProduction;
  List<String>? languages;
  DateTime? lastAirDate;
  String? name;
  int? numberOfEpisodes;
  int? numberOfSeasons;
  List<String>? originCountry;
  String? originalLanguage;
  String? originalName;
  String? overview;
  double? popularity;
  String? posterPath;
  String? status;
  String? tagline;
  double? voteAverage;
  int? voteCount;

  Map<String, dynamic> toJson() => {
    "adult": adult,
    "backdrop_path": backdropPath,
    "episode_run_time": episodeRunTime == null
        ? []
        : List<dynamic>.from(episodeRunTime!.map((x) => x)),
    "first_air_date": firstAirDate == null
        ? null
        : "${firstAirDate!.year.toString().padLeft(4, '0')}-${firstAirDate!.month.toString().padLeft(2, '0')}-${firstAirDate!.day.toString().padLeft(2, '0')}",
    "genres": genres == null
        ? []
        : List<dynamic>.from(genres!.map((x) => x.toJson())),
    "homepage": homepage,
    "id": id,
    "in_production": inProduction,
    "languages": languages == null
        ? []
        : List<dynamic>.from(languages!.map((x) => x)),
    "last_air_date": lastAirDate == null
        ? null
        : "${lastAirDate!.year.toString().padLeft(4, '0')}-${lastAirDate!.month.toString().padLeft(2, '0')}-${lastAirDate!.day.toString().padLeft(2, '0')}",
    "name": name,
    "number_of_episodes": numberOfEpisodes,
    "number_of_seasons": numberOfSeasons,
    "origin_country": originCountry == null
        ? []
        : List<dynamic>.from(originCountry!.map((x) => x)),
    "original_language": originalLanguage,
    "original_name": originalName,
    "overview": overview,
    "popularity": popularity,
    "poster_path": posterPath,
    "status": status,
    "tagline": tagline,
    "vote_average": voteAverage,
    "vote_count": voteCount,
  };
}

class Genre {
  Genre({this.id, this.name});

  factory Genre.fromJson(Map<String, dynamic> json) =>
      Genre(id: json["id"], name: json["name"]);
  int? id;
  String? name;

  Map<String, dynamic> toJson() => {"id": id, "name": name};
}
