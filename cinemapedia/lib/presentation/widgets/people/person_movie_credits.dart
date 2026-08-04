import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../config/extensions/null_extensions.dart';
import '../../../domain/entities/movie_credit.dart';
import '../../../l10n/app_localizations.dart';
import '../../providers/providers.dart';
import '../shared/app_network_image.dart';

final personMovieCreditsProvider = FutureProvider.family((ref, int personId) {
  final peopleRepository = ref.watch(peopleRepositoryProvider);
  return peopleRepository.getMovieCreditsByPerson(personId);
});

class PersonMovieCredits extends ConsumerWidget {
  const PersonMovieCredits({super.key, required this.personId});

  final int personId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final creditsFuture = ref.watch(personMovieCreditsProvider(personId));

    return creditsFuture.when(
      data: (credits) => _CreditsList(credits: credits),
      error: (_, _) => Center(
        child: Text(AppLocalizations.of(context)!.couldNotLoadContent),
      ),
      loading: () =>
          const Center(child: CircularProgressIndicator(strokeWidth: 2)),
    );
  }
}

class _CreditsList extends StatelessWidget {
  const _CreditsList({required this.credits});
  final List<MovieCredit> credits;

  @override
  Widget build(BuildContext context) {
    if (credits.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            AppLocalizations.of(context)!.moviesLabel,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 5),
        SizedBox(
          height: 250,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: credits.length,
            itemBuilder: (context, index) =>
                _CreditCard(credit: credits[index]),
          ),
        ),
      ],
    );
  }
}

class _CreditCard extends StatelessWidget {
  const _CreditCard({required this.credit});
  final MovieCredit credit;

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => context.push('/home/0/movie/${credit.id}'),
      child: Container(
        width: 150,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isDarkTheme ? Colors.black38 : Colors.white,
          boxShadow: const <BoxShadow>[
            BoxShadow(blurRadius: 6, color: Colors.black12),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: AppNetworkImage(
                imageUrl: credit.posterPath,
                width: double.infinity,
                height: 170,
                cacheWidth: 150,
              ),
            ),
            const SizedBox(height: 8),
            Flexible(
              child: Text(
                credit.title,
                maxLines: 1,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Flexible(
              child: Text(
                credit.character.value(
                  AppLocalizations.of(context)!.noCharacter,
                ),
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
