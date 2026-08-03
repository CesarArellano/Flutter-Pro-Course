class PersonMovieCreditsResponse {
  factory PersonMovieCreditsResponse.fromJson(Map<String, dynamic> json) =>
      PersonMovieCreditsResponse(
        id: json["id"],
        cast: List<PersonCastMovie>.from(
          (json["cast"] as List).map((x) => PersonCastMovie.fromJson(x)),
        ),
      );
  PersonMovieCreditsResponse({required this.id, required this.cast});

  final int id;
  final List<PersonCastMovie> cast;

  Map<String, dynamic> toJson() => {
    "id": id,
    "cast": List<dynamic>.from(cast.map((x) => x.toJson())),
  };
}

class PersonCastMovie {
  factory PersonCastMovie.fromJson(Map<String, dynamic> json) =>
      PersonCastMovie(
        id: json["id"],
        title: json["title"] ?? '',
        character: json["character"],
        posterPath: json["poster_path"],
        releaseDate: json["release_date"] != null && json["release_date"] != ''
            ? DateTime.parse(json["release_date"])
            : null,
        voteAverage: (json["vote_average"] as num?)?.toDouble() ?? 0.0,
        creditId: json["credit_id"],
      );
  PersonCastMovie({
    required this.id,
    required this.title,
    required this.voteAverage,
    required this.creditId,
    this.character,
    this.posterPath,
    this.releaseDate,
  });

  final int id;
  final String title;
  final String? character;
  final String? posterPath;
  final DateTime? releaseDate;
  final double voteAverage;
  final String creditId;

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "character": character,
    "poster_path": posterPath,
    "release_date": releaseDate == null
        ? null
        : "${releaseDate!.year.toString().padLeft(4, '0')}-${releaseDate!.month.toString().padLeft(2, '0')}-${releaseDate!.day.toString().padLeft(2, '0')}",
    "vote_average": voteAverage,
    "credit_id": creditId,
  };
}
