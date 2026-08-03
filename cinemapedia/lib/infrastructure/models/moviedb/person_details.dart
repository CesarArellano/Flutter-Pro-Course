class PersonDetails {
  PersonDetails({
    this.adult,
    this.biography,
    this.birthday,
    this.deathday,
    this.gender,
    this.homepage,
    this.id,
    this.imdbId,
    this.knownForDepartment,
    this.name,
    this.placeOfBirth,
    this.popularity,
    this.profilePath,
  });

  factory PersonDetails.fromJson(Map<String, dynamic> json) => PersonDetails(
    adult: json["adult"],
    biography: json["biography"],
    birthday: json["birthday"] != null && json["birthday"] != ''
        ? DateTime.parse(json["birthday"])
        : null,
    deathday: json["deathday"] != null && json["deathday"] != ''
        ? DateTime.parse(json["deathday"])
        : null,
    gender: json["gender"],
    homepage: json["homepage"],
    id: json["id"],
    imdbId: json["imdb_id"],
    knownForDepartment: json["known_for_department"],
    name: json["name"],
    placeOfBirth: json["place_of_birth"],
    popularity: (json["popularity"] as num?)?.toDouble(),
    profilePath: json["profile_path"],
  );

  bool? adult;
  String? biography;
  DateTime? birthday;
  DateTime? deathday;
  int? gender;
  String? homepage;
  int? id;
  String? imdbId;
  String? knownForDepartment;
  String? name;
  String? placeOfBirth;
  double? popularity;
  String? profilePath;

  Map<String, dynamic> toJson() => {
    "adult": adult,
    "biography": biography,
    "birthday": birthday == null
        ? null
        : "${birthday!.year.toString().padLeft(4, '0')}-${birthday!.month.toString().padLeft(2, '0')}-${birthday!.day.toString().padLeft(2, '0')}",
    "deathday": deathday == null
        ? null
        : "${deathday!.year.toString().padLeft(4, '0')}-${deathday!.month.toString().padLeft(2, '0')}-${deathday!.day.toString().padLeft(2, '0')}",
    "gender": gender,
    "homepage": homepage,
    "id": id,
    "imdb_id": imdbId,
    "known_for_department": knownForDepartment,
    "name": name,
    "place_of_birth": placeOfBirth,
    "popularity": popularity,
    "profile_path": profilePath,
  };
}
