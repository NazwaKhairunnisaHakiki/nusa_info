import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/post.dart';

class PostService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';

  // GET: Mengambil semua pengumuman
  Future<List<Post>> fetchPosts() async {
    final url = Uri.parse('$baseUrl/posts');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      return data.map((json) => Post.fromJson(json)).toList();
    } else {
      throw Exception('Gagal mengambil pengumuman: ${response.statusCode}');
    }
  }

  // GET: Mengambil komentar berdasarkan ID pengumuman
  Future<List<Map<String, dynamic>>> fetchComments(int postId) async {
    final url = Uri.parse('$baseUrl/posts/$postId/comments');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      return data.map((json) => Map<String, dynamic>.from(json)).toList();
    } else {
      throw Exception('Gagal mengambil komentar: ${response.statusCode}');
    }
  }

  // POST: Mengirim pengumuman baru
  Future<Post> createPost(Post post) async {
    final url = Uri.parse('$baseUrl/posts');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(post.toJson()),
    );

    if (response.statusCode == 201) {
      return Post.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal membuat pengumuman: ${response.statusCode}');
    }
  }
}
