class MovieCredit {
  MovieCredit({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.voteAverage,
    this.character,
    this.releaseDate,
  });
  final int id;
  final String title;
  final String posterPath;
  final double voteAverage;
  final String? character;
  final DateTime? releaseDate;
}
