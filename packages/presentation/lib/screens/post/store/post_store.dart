import 'package:applications/usecase/post/get_posts_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/enum/resource_state.dart';
import 'package:presentation/screens/post/viewmodel/post.dart';

class PostListState {
  final ResourceState resourceState;
  final List<PostViewModel> posts;
  final String? errorMessage;

  PostListState({
    required this.resourceState,
    required this.posts,
    this.errorMessage,
  });

  // 創建初始狀態
  factory PostListState.initial() => PostListState(
        resourceState: ResourceState.init,
        posts: [],
      );

  // 創建加載狀態
  factory PostListState.loading({List<PostViewModel>? currentPosts}) =>
      PostListState(
        resourceState: ResourceState.loading,
        posts: currentPosts ?? const [],
      );

  // 創建成功狀態
  factory PostListState.success(List<PostViewModel> posts) => PostListState(
        resourceState: ResourceState.success,
        posts: posts,
      );

  // 創建空狀態
  factory PostListState.empty() => PostListState(
        resourceState: ResourceState.empty,
        posts: [],
      );

  // 創建錯誤狀態
  factory PostListState.error(String message,
          {List<PostViewModel>? currentPosts}) =>
      PostListState(
        resourceState: ResourceState.error,
        posts: currentPosts ?? const [],
        errorMessage: message,
      );

  // 複製當前狀態並更新部分屬性
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
  // final Logger _logger = LoggerFactory.instance.getLogger('PostListStore');
  PostListStore(this._getPostsUseCase)
      : super(PostListState(resourceState: ResourceState.init, posts: []));

  Future<void> getPosts() async {
    // _logger.d("Starting getPosts() - setting state to loading");
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

        // logger.d(
        //     "Posts loaded successfully (${posts.length} items) - setting state to success");
        emit(PostListState.success(posts));
      }
    } catch (e) {
      // logger.e("Error loading posts: ${e.toString()}");
      emit(PostListState.error(e.toString(), currentPosts: state.posts));
    }
  }

  // 便捷方法，方便UI層訪問
  bool get isLoading => state.resourceState == ResourceState.loading;
  bool get isSuccess => state.resourceState == ResourceState.success;
  bool get isEmpty => state.resourceState == ResourceState.empty;
  bool get isError => state.resourceState == ResourceState.error;
  List<PostViewModel> get posts => state.posts;
  String? get apiErrorMessage => state.errorMessage;
  ResourceState get resourceState => state.resourceState;
}
