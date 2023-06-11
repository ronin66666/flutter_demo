import 'package:demo/example/flutter_bloc/flutter_infinite_list/posts/bloc/post_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/post_bloc.dart';
import '../bloc/post_state.dart';
import '../models/post.dart';

class PostsList extends StatefulWidget {
  const PostsList({super.key});

  @override
  State<PostsList> createState() => _PostsListState();
}

class _PostsListState extends State<PostsList> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostBloc, PostState>(
        builder: (context, state) {
          switch (state.status) {
            case PostStatus.failure:
              return const Center(child: Text('failed to fetch posts'),);
            case PostStatus.success:
              if (state.posts.isEmpty) {
                return const Center(child: Text('no Posts'),);
              }
              return ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    return index >= state.posts.length ? const BottomLoader(): PostsListItem(post: state.posts[index]);
                  },
                itemCount: state.hasReachedMax ? state.posts.length : state.posts.length + 1,
                controller: _scrollController,
              );
            case PostStatus.initial:
              return const Center(child: CircularProgressIndicator(),);
          }
        }
    );
  }

  @override
  void dispose() {
    _scrollController..removeListener(_onScroll)..dispose();
    super.dispose();
  }


  void _onScroll() {
    if (_isBottom) context.read<PostBloc>().add(PostFetched());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroller = _scrollController.position.maxScrollExtent;
    final currentScroller = _scrollController.offset;
    return currentScroller >= (maxScroller * 0.9);
  }
}

class BottomLoader extends StatelessWidget {
  const BottomLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator(strokeWidth: 1.5,),
      ),
    );
  }
}


class PostsListItem extends StatelessWidget {
  const PostsListItem({required this.post, super.key});
  final Post post;
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Material(
      child: ListTile(
        leading: Text('${post.id}', style: textTheme.bodySmall,),
        title: Text(post.title),
        isThreeLine: true,
        subtitle: Text(post.body),
        dense: true,
      ),
    );
  }
}
