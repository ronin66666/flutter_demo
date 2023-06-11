
import 'package:equatable/equatable.dart';

import '../models/post.dart';

enum PostStatus {
  initial,
  success,
  failure
}

class PostState extends Equatable {

  const PostState({
    this.status = PostStatus.initial,
    this.posts = const <Post>[],
    this.hasReachedMax = false
  });

  final PostStatus status;
  final List<Post> posts;
  final bool hasReachedMax;

  PostState copyWith({
    PostStatus? status,
    List<Post>? posts,
    bool? hasReachedMax,
  }) {
    return PostState(
      status: status ?? this.status,
      posts: posts ?? this.posts,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() {
    return '''
    PostState { state: $status, hashReachedMax: $hasReachedMax, posts: ${posts.length} }
    ''';
  }

  @override
  List<Object?> get props => [status, posts, hasReachedMax];
}