import 'package:domains/entity/post/post.dart';

abstract class PostRepository {
  Future<List<Post>> getPosts({int? limit, int? offset, String? searchQuery});
  Future<Post?> getPostById(String id);
  Future<Post> createPost(Post post);
  Future<Post> updatePost(Post post);
  Future<bool> deletePost(String id);
}
