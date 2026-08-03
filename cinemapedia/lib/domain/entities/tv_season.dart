class TvSeason {
  TvSeason({
    required this.seasonNumber,
    required this.name,
    required this.posterPath,
    required this.airDate,
    required this.episodeCount,
    required this.voteAverage,
    required this.overview,
  });
  final int? seasonNumber;
  final String? name;
  final String? posterPath;
  final DateTime? airDate;
  final int? episodeCount;
  final double? voteAverage;
  final String? overview;
}
