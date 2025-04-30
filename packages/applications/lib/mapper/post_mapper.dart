import 'package:applications/dto/index.dart';
import 'package:domains/entity/post/post.dart';

class PostMapper {
  static PostDTO fromDomain(Post post) {
    return PostDTO(
      id: post.id,
      title: post.title,
      content: post.content,
      authorId: post.author.id,
      authorName: post.author.name,
      createdAt: post.createdAt,
    );
  }
}
