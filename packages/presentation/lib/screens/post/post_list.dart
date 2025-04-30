import 'package:another_flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/enum/resource_state.dart';
import 'package:presentation/screens/post/store/post_store.dart';
import 'package:presentation/screens/post/viewmodel/post.dart';
import 'package:presentation/utils/locale/app_localization.dart';
import 'package:presentation/widgets/progress_indicator_widget.dart';
import 'package:rizzlt_flutter_starter/di/service_locator.dart';

class PostListScreen extends StatefulWidget {
  const PostListScreen({super.key});

  @override
  PostListScreenState createState() => PostListScreenState();
}

class PostListScreenState extends State<PostListScreen> {
  //stores:-------------------------------------------------------------------
  final PostListStore _postStore = getIt<PostListStore>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // check to see if already called api
    if (!_postStore.isLoading) {
      _postStore.getPosts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  // body methods:--------------------------------------------------------------
  Widget _buildBody() {
    return Stack(
      children: <Widget>[
        _handleErrorMessage(),
        _buildMainContent(),
      ],
    );
  }

  Widget _buildMainContent() {
    return BlocBuilder<PostListStore, PostListState>(
      bloc: _postStore,
      builder: (context, state) {
        print('當前狀態: ${state.resourceState}, 帖子數量: ${state.posts.length}');

        switch (state.resourceState) {
          case ResourceState.loading:
            return const CustomProgressIndicatorWidget();
          case ResourceState.empty:
            return Center(
                child: Text(
              AppLocalizations.of(context).translate('home_tv_no_post_found"'),
            ));
          case ResourceState.success:
            return _buildListView(state.posts);
          case ResourceState.error:
            return _buildListView(state.posts);
          default:
            return Container();
        }
      },
    );
  }

  Widget _buildListView(List<PostViewModel> posts) {
    return posts.isNotEmpty
        ? ListView.separated(
            itemCount: posts.length,
            separatorBuilder: (context, position) {
              return const Divider();
            },
            itemBuilder: (context, position) {
              return _buildListItem(position, posts);
            },
          )
        : Center(
            child: Text(
              AppLocalizations.of(context).translate('home_tv_no_post_found'),
            ),
          );
  }

  Widget _buildListItem(int position, List<PostViewModel> posts) {
    return ListTile(
      dense: true,
      leading: const Icon(Icons.cloud_circle),
      title: Text(
        posts[position].title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        softWrap: false,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      subtitle: Text(
        posts[position].content,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        softWrap: false,
      ),
    );
  }

  Widget _handleErrorMessage() {
    return BlocBuilder<PostListStore, PostListState>(
      bloc: _postStore,
      builder: (context, state) {
        if (state.errorMessage != null) {
          return _showErrorMessage(state.errorMessage!);
        }
        return const SizedBox.shrink();
      },
    );
  }

  // General Methods:-----------------------------------------------------------
  SizedBox _showErrorMessage(String message) {
    Future.delayed(const Duration(milliseconds: 0), () {
      if (message.isNotEmpty) {
        FlushbarHelper.createError(
          message: message,
          title: AppLocalizations.of(context).translate('home_tv_error'),
          duration: const Duration(seconds: 3),
        ).show(context);
      }
    });

    return const SizedBox.shrink();
  }
}
