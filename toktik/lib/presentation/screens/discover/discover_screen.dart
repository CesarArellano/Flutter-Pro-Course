import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/discover_provider.dart';
import '../../widgets/shared/video_scrollable_view.dart';

class DiscoverScreen extends StatelessWidget {
  
  const DiscoverScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final discoverProvider = context.watch<DiscoverProvider>();
    return Scaffold(
      body: discoverProvider.initialLoading
        ? const Center(child: CircularProgressIndicator(strokeWidth: 2,))
        : VideoScrollableView(
          videos: discoverProvider.videos,
        )
    );
  }
}