import 'package:applications/usecase/post/get_posts_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/features/post/viewmodel/post.dart';
import 'package:presentation/shared/enum/resource_state.dart';

class PostListState {
  final ResourceState resourceState;
  final List<PostViewModel> posts;
  final String? errorMessage;

  PostListState({
    required this.resourceState,
    required this.posts,
    this.errorMessage,
  });

  factory PostListState.initial() => PostListState(
        resourceState: ResourceState.init,
        posts: [],
      );

  factory PostListState.loading({List<PostViewModel>? currentPosts}) =>
      PostListState(
        resourceState: ResourceState.loading,
        posts: currentPosts ?? const [],
      );

  factory PostListState.success(List<PostViewModel> posts) => PostListState(
        resourceState: ResourceState.success,
        posts: posts,
      );

  factory PostListState.empty() => PostListState(
        resourceState: ResourceState.empty,
        posts: [],
      );

  factory PostListState.error(String message,
          {List<PostViewModel>? currentPosts}) =>
      PostListState(
        resourceState: ResourceState.error,
        posts: currentPosts ?? const [],
        errorMessage: message,
      );

  PostListState copyWith({
    ResourceState? resourceState,
    List<PostViewModel>? posts,
    String? errorMessage,
  }) {
    return PostListState(
      resourceState: resourceState ?? this.resourceState,
      posts: posts ?? this.posts,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class PostListStore extends Cubit<PostListState> {
  final GetPostsUseCase _getPostsUseCase;
  PostListStore(this._getPostsUseCase)
      : super(PostListState(resourceState: ResourceState.init, posts: []));

  Future<void> getPosts() async {
    emit(PostListState.loading(currentPosts: state.posts));
    try {
      final postsListDTO = await _getPostsUseCase.call(params: null);

      if (postsListDTO.isEmpty) {
        // logger.d("Posts empty - setting state to empty");
        emit(PostListState.empty());
      } else {
        final posts = postsListDTO
            .map(
              (postDTO) => PostViewModel(post: postDTO),
            )
            .toList();
        emit(PostListState.success(posts));
      }
    } catch (e) {
      emit(PostListState.error(e.toString(), currentPosts: state.posts));
    }
  }

  bool get isLoading => state.resourceState == ResourceState.loading;
  bool get isSuccess => state.resourceState == ResourceState.success;
  bool get isEmpty => state.resourceState == ResourceState.empty;
  bool get isError => state.resourceState == ResourceState.error;
  List<PostViewModel> get posts => state.posts;
  String? get apiErrorMessage => state.errorMessage;
  ResourceState get resourceState => state.resourceState;
}
