import 'package:applications/core/use_case.dart';
import 'package:applications/dto/post_dto.dart';
import 'package:applications/mapper/post_mapper.dart';
import 'package:applications/usecase/post/params/GetPostsParams.dart';
import 'package:domains/post/post_repository.dart';

class GetPostsUseCase extends UseCase<List<PostDTO>, GetPostsParams> {
  final PostRepository _postRepository;

  GetPostsUseCase(this._postRepository);

  @override
  Future<List<PostDTO>> call({GetPostsParams? params}) async {
    try {
      final posts = await _postRepository.getPosts();
      return posts.map((post) => PostMapper.fromDomain(post)).toList();
    } catch (e) {
      throw Exception('Failed to get posts: ${e.toString()}');
    }
  }
}
