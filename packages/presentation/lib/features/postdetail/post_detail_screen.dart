import 'package:flutter/material.dart';

class PostDetailScreen extends StatefulWidget {
  final String postId;
  const PostDetailScreen({
    required this.postId,
    super.key,
  });

  @override
  _PostDetailDetail createState() => _PostDetailDetail();
}

class _PostDetailDetail extends State<PostDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Text('Hello Post Detail, ${widget.postId}');
  }
}
