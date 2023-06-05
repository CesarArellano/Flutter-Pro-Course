import '../../domain/datasources/video_posts_datasource.dart';
import '../../domain/entities/video_post.dart';
import '../../shared/data/local_video_post.dart';
import '../models/local_video_model.dart';

class LocalVideoDatasourceImpl implements VideoPostDatasource {
  @override
  Future<List<VideoPost>> getFavoriteVideosByUser(String userId) {
    // TODO: implement getFavoriteVideosByUser
    throw UnimplementedError();
  }

  @override
  Future<List<VideoPost>> getTrendingVideosByPage(int page) async {
    await Future.delayed( const Duration(seconds: 2) );
    
    final List<VideoPost> newVideos = videoPosts.map(
      (video) => LocalVideoModel.fromJson(video).toVideoPostEntity()
    ).toList();

    return newVideos;
  }

}