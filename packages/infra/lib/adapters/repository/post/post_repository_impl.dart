// packages/infra/lib/repositories/post_repository_impl.dart
import 'dart:async';

import 'package:domains/entity/post/post.dart';
import 'package:domains/post/post_repository.dart';
import 'package:infra/core/exceptions/network_exceptions.dart';
import 'package:infra/datasources/remote/interfaces/post_remote_datasource.dart';
import 'package:rizzlt_flutter_starter/core/logger/index.dart';

class PostRepositoryImpl implements PostRepository {
  final PostRemoteDataSource _postRemoteDataSource;
  final logger = Log.getLogger('Post_Repository');

  PostRepositoryImpl(this._postRemoteDataSource);

  @override
  Future<List<Post>> getPosts(
      {int? limit, int? offset, String? searchQuery}) async {
    try {
      final List<Map<String, dynamic>> postsData = await _postRemoteDataSource
          .getPosts(limit: limit, offset: offset, searchQuery: searchQuery);

      return postsData.map((postMap) => Post.fromMap(postMap)).toList();
    } on NetworkException catch (e, stackTrace) {
      logger.e("Repository: Network error fetching posts",
          error: e, stackTrace: stackTrace);
      rethrow;
    } catch (e) {
      logger.e("Repository: Failed to load posts: ${e.toString()}");
      throw Exception('Repository: Failed to load posts: ${e.toString()}');
    }
  }

  @override
  Future<Post> createPost(Post post) {
    // TODO: implement createPost
    throw UnimplementedError();
  }

  @override
  Future<bool> deletePost(String id) {
    // TODO: implement deletePost
    throw UnimplementedError();
  }

  @override
  Future<Post?> getPostById(String id) {
    // TODO: implement getPostById
    throw UnimplementedError();
  }

  @override
  Future<Post> updatePost(Post post) {
    // TODO: implement updatePost
    throw UnimplementedError();
  }

// 其他方法實現...
}
