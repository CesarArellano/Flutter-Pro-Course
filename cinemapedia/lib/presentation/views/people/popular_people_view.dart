import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/providers.dart';
import '../../widgets/widgets.dart';

class PopularPeopleView extends ConsumerStatefulWidget {
  const PopularPeopleView({super.key});

  @override
  PopularPeopleViewState createState() => PopularPeopleViewState();
}

class PopularPeopleViewState extends ConsumerState<PopularPeopleView>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    final popularPeople = ref.watch(popularPeopleProvider);

    if (popularPeople.isEmpty) {
      return const Center(child: CircularProgressIndicator(strokeWidth: 2));
    }

    return PersonMasonry(
      loadNextPage: () =>
          ref.read(popularPeopleProvider.notifier).loadNextPage(),
      people: popularPeople,
    );
  }

  @override
  bool get wantKeepAlive => true;
}
