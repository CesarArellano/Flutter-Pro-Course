import '../../domain/datasources/video_posts_datasource.dart';
import '../../domain/entities/video_post.dart';
import '../../domain/repositories/video_posts_repository.dart';

class VideoPostsRepositoryImpl  implements VideoPostRepository {

  final VideoPostDatasource videoPostDatasource;

  VideoPostsRepositoryImpl({
    required this.videoPostDatasource
  });
  
  @override
  Future<List<VideoPost>> getFavoriteVideosByUser(String userId) {
    throw UnimplementedError();
  }

  @override
  Future<List<VideoPost>> getTrendingVideosByPage(int page) {
    return videoPostDatasource.getTrendingVideosByPage(page);
  }

}