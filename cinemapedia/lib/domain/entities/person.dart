class Person {
  Person({
    required this.id,
    required this.name,
    required this.profilePath,
    required this.popularity,
    this.knownForDepartment,
    this.gender,
    this.adult,
    this.biography,
    this.birthday,
    this.deathday,
    this.placeOfBirth,
  });
  final int id;
  final String name;
  final String profilePath;
  final double popularity;
  final String? knownForDepartment;
  final int? gender;
  final bool? adult;
  final String? biography;
  final DateTime? birthday;
  final DateTime? deathday;
  final String? placeOfBirth;
}
