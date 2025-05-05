import 'package:presentation/features/post/viewmodel/post_viewmodel.dart';
import 'package:presentation/shared/enum/resource_state.dart';

class PostListState {
  final ResourceState resourceState;
  final List<PostViewModel> posts;
  final String? errorMessage;

  PostListState._({
    required this.resourceState,
    required this.posts,
    this.errorMessage,
  }) : super();

  factory PostListState.initial() => PostListState._(
        resourceState: ResourceState.init,
        posts: [],
        errorMessage: null,
      );

  PostListState copyWith({
    ResourceState? resourceState,
    List<PostViewModel>? posts,
    String? errorMessage,
    // Helper to easily clear error
    bool clearErrorMessage = false,
  }) {
    return PostListState._(
      resourceState: resourceState ?? this.resourceState,
      posts: posts ?? this.posts,
      errorMessage:
          clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
    );
  }

  bool get isLoading => resourceState == ResourceState.loading;
  bool get isSuccess => resourceState == ResourceState.success;
  bool get isEmpty => resourceState == ResourceState.empty;
  bool get hasError =>
      resourceState == ResourceState.error && errorMessage != null;
}
