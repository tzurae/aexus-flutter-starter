import 'package:domains/entity/user/user.dart';

class Post {
  final String id;
  final String title;
  final String content;
  final User author;
  final DateTime createdAt;

  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.author,
    required this.createdAt,
  });

  // 領域邏輯方法
  bool canBeEditedBy(User user) {
    return author.id == user.id;
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    try {
      return Post(
        id: map['id']?.toString() ?? '',
        title: map['title']?.toString() ?? '',
        content: map['content']?.toString() ?? '',
        author: map['author'] != null
            ? User.fromMap(Map<String, dynamic>.from(map['author'] as Map))
            : User(id: '', name: '', email: ''),
        createdAt: map['createdAt'] != null
            ? DateTime.tryParse(map['createdAt'].toString()) ?? DateTime.now()
            : DateTime.now(),
      );
    } catch (e, stack) {
      print('Error parsing Post from map: $map');
      print('Error details: $e');
      print('Stack trace: $stack');
      rethrow;
    }
  }
}
