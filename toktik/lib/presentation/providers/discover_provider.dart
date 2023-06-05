import 'package:flutter/material.dart';
import 'package:toktik/domain/repositories/video_posts_repository.dart';

import '../../domain/entities/video_post.dart';

class DiscoverProvider extends ChangeNotifier {
  
  final VideoPostRepository videoPostRepository;
  
  bool initialLoading = true;
  List<VideoPost> videos = [];

  DiscoverProvider({
    required this.videoPostRepository
  });
  
  Future<void> loadNextPage() async {
    final newVideos = await videoPostRepository.getTrendingVideosByPage(1);
    videos.addAll(newVideos);
    initialLoading = false;
    notifyListeners();
  }
}