import '../models/post_model.dart';

class PostsLogic {
  /// Returns only posts whose title contains the given query (case-insensitive).
  static List<PostModel> filterByTitle(
    List<PostModel> posts,
    String query,
  ) {
    if (query.isEmpty) return posts;
    final lower = query.toLowerCase();
    return posts
        .where((p) => p.title.toLowerCase().contains(lower))
        .toList();
  }

  /// Returns the first [limit] posts from the list.
  static List<PostModel> limit(List<PostModel> posts, int limit) {
    if (posts.length <= limit) return posts;
    return posts.sublist(0, limit);
  }
}
