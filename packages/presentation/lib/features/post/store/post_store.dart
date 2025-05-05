import 'package:applications/dto/post_dto.dart';
import 'package:applications/usecase/post/get_posts_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/features/post/store/post_state.dart';
import 'package:presentation/features/post/viewmodel/post_viewmodel.dart';
import 'package:presentation/foundation/extensions/api_handling_Cubit.dart';
import 'package:presentation/foundation/services/api_handler_service.dart';
import 'package:presentation/shared/enum/resource_state.dart';

class PostListStore extends Cubit<PostListState> {
  final ApiHandlerService _apiHandler;
  final GetPostsUseCase _getPostsUseCase;

  PostListStore(
    this._apiHandler,
    this._getPostsUseCase,
  ) : super(PostListState.initial());

  Future<void> getPosts() async {
    await handleApiRequest<List<dynamic>>(
      apiHandler: _apiHandler,
      apiCall: () async {
        return await _getPostsUseCase.call(params: null);
      },
      loadingStateBuilder: (state) => state.copyWith(
        resourceState: ResourceState.loading,
        clearErrorMessage: true,
      ),
      successStateBuilder: (state, postsListDTO) {
        if (postsListDTO.isEmpty) {
          return state.copyWith(resourceState: ResourceState.empty);
        } else {
          final posts = postsListDTO
              .map(
                (postDTO) => PostViewModel(post: postDTO as PostDTO),
              )
              .toList();
          return state.copyWith(
            resourceState: ResourceState.success,
            posts: posts,
          );
        }
      },
      errorStateBuilder: (state, errorMessage) => state.copyWith(
        resourceState: ResourceState.error,
        errorMessage: errorMessage,
      ),
      context: 'PostListStore.getPosts',
      handleAsGlobal: false,
    );
  }

  List<PostViewModel> get posts => state.posts;
  String? get apiErrorMessage => state.errorMessage;

  @override
  void emitError(String message) {
    emit(state.copyWith(
      resourceState: ResourceState.error,
      errorMessage: message,
    ));
  }

  @override
  void resetError() {
    if (state.hasError) {
      emit(state.copyWith(
        resourceState: ResourceState.init,
        clearErrorMessage: true,
      ));
    }
  }
}
