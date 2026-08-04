import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fog_edge_blur/fog_edge_blur.dart';
import 'package:fog_edge_blur/fog_edge_child.dart';
import 'package:intl/intl.dart';

import '../../../config/extensions/null_extensions.dart';
import '../../../domain/entities/person.dart';
import '../../../l10n/app_localizations.dart';
import '../../providers/people/person_info_provider.dart';
import '../../widgets/widgets.dart';

class PersonScreen extends ConsumerStatefulWidget {
  const PersonScreen({super.key, required this.personId});

  static const name = 'person-screen';

  final String personId;

  @override
  ConsumerState<PersonScreen> createState() => _PersonScreenState();
}

class _PersonScreenState extends ConsumerState<PersonScreen> {
  @override
  void initState() {
    unawaited(
      ref.read(personInfoProvider.notifier).loadPerson(widget.personId),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Person? person = ref.watch(personInfoProvider)[widget.personId];

    if (person == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      // No CustomAppbar here — this screen already has its own hero-image
      // sliver header. Just the top-edge blur treatment, sized to match the
      // same status-bar-plus-toolbar band CustomAppbar uses elsewhere.
      body: FogEdgeBlur(
        edgeAlign: EdgeAlign.top,
        sigma: 20,
        fogEdgeChild: FogEdgeChild(heightEdge: kToolbarHeight - 10),
        child: CustomScrollView(
          physics: const ClampingScrollPhysics(),
          slivers: [
            _CustomSliverAppbar(person: person),
            SliverToBoxAdapter(child: _PersonDetails(person: person)),
          ],
        ),
      ),
    );
  }
}

class _CustomSliverAppbar extends StatelessWidget {
  const _CustomSliverAppbar({required this.person});

  final Person person;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SliverAppBar(
      foregroundColor: Colors.white,
      expandedHeight: size.height * 0.5,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        background: Stack(
          children: [
            SizedBox.expand(
              child: AppNetworkImage(
                imageUrl: person.profilePath,
                width: size.width,
                height: size.height * 0.5,
              ),
            ),
            const SizedBox.expand(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    stops: [0.0, 0.3],
                    colors: [Colors.black87, Colors.transparent],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PersonDetails extends StatelessWidget {
  const _PersonDetails({required this.person});

  final Person person;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _HeaderDetails(person: person),
        _Biography(person: person),
        const SizedBox(height: 8),
        PersonMovieCredits(personId: person.id),
        const SizedBox(height: 12),
      ],
    );
  }
}

class _HeaderDetails extends StatelessWidget {
  const _HeaderDetails({required this.person});

  final Person person;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final size = MediaQuery.of(context).size;
    final textStyles = Theme.of(context).textTheme;
    const TextStyle chipTextStyle = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
    );

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: AppNetworkImage(
              imageUrl: person.profilePath.value(),
              width: size.width * 0.3,
            ),
          ),
          const SizedBox(width: 15),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(person.name, style: textStyles.titleLarge),
                const SizedBox(height: 4),
                Text(
                  person.knownForDepartment.value(l10n.unknownDepartment),
                  style: textStyles.titleSmall,
                ),
                const SizedBox(height: 8),
                Chip(
                  backgroundColor: Colors.black,
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.trending_up, color: Colors.yellow),
                      const SizedBox(width: 5),
                      Text(
                        NumberFormat.decimalPatternDigits(
                          decimalDigits: 1,
                        ).format(person.popularity),
                        style: chipTextStyle,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Biography extends StatelessWidget {
  const _Biography({required this.person});
  final Person person;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.biography,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          _DetailRow(
            icon: Icons.cake_outlined,
            label: l10n.birthday,
            value: person.birthday != null
                ? '${person.birthday!.day}-${person.birthday!.month}-${person.birthday!.year}'
                : l10n.unknown,
          ),
          _DetailRow(
            icon: Icons.location_on_outlined,
            label: l10n.placeOfBirth,
            value: person.placeOfBirth.valueEmpty(l10n.unknown),
          ),
          const SizedBox(height: 8),
          Text(
            person.biography.valueEmpty(l10n.noBiographyAvailable),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: colors.primary),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value,
              style: textTheme.titleSmall,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
