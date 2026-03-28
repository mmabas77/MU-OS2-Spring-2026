import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post_model.dart';

class PostsData {
  static Future<List<PostModel>> fetchPosts() async {
    final response = await http.get(
      Uri.parse('https://dummyjson.com/posts'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> decoded = json.decode(response.body) as Map<String, dynamic>;
      final List<dynamic> data = decoded['posts'] as List<dynamic>;
      return data
          .map((item) => PostModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load posts: ${response.statusCode}');
    }
  }
}
