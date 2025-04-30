import 'package:applications/dto/index.dart';
import 'package:intl/intl.dart';

class PostViewModel {
  final PostDTO post;
  bool isSelected;
  bool isExpanded;

  PostViewModel({
    required this.post,
    this.isSelected = false,
    this.isExpanded = false,
  });

  // 委託基本屬性
  String get id => post.id;
  String get title => post.title;
  String get content => post.content;
  String get authorName => post.authorName;
  String get authorId => post.authorId;
  DateTime get createdAt => post.createdAt;

  // UI特定的計算屬性
  String get formattedDate => DateFormat('yyyy年MM月dd日').format(createdAt);
  String get formattedTime => DateFormat('HH:mm').format(createdAt);
  String get truncatedContent =>
      content.length > 100 ? '${content.substring(0, 100)}...' : content;

  // 用於比較的方法
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PostViewModel &&
        other.id == id &&
        other.isSelected == isSelected &&
        other.isExpanded == isExpanded;
  }

  @override
  int get hashCode => id.hashCode ^ isSelected.hashCode ^ isExpanded.hashCode;
}
