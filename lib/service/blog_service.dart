import 'dart:convert';
import 'package:http/http.dart' as http;
import '../modulw/module.dart';
import 'auth_service.dart';

class BlogService {
  final String baseUrl = 'http://localhost:3000/api/v1/blogs'; // Update with your backend URL
  final AuthService authService = AuthService();

  Future<List<Blog>> getBlogs({int page = 1, int limit = 10}) async {
    final token = await authService.getToken();
    if (token == null) {
      throw Exception('No token found');
    }

    final response = await http.get(
      Uri.parse('$baseUrl?page=$page&limit=$limit'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> json = data['data']['blogs'];
      return json.map((blog) => Blog.fromJson(blog)).toList();
    } else {
      throw Exception('Failed to load blogs');
    }
  }

  Future<Blog> createBlog(String title, String description) async {
    final token = await authService.getToken();
    if (token == null) {
      throw Exception('No token found');
    }

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'title': title, 'description': description}),
    );

    if (response.statusCode == 201) {
      final json = jsonDecode(response.body)['data'];
      return Blog.fromJson(json);
    } else {
      throw Exception('Failed to create blog');
    }
  }

  Future<Blog> toggleSaveBlog(String blogID) async {
    final token = await authService.getToken();
    if (token == null) {
      throw Exception('No token found');
    }

    final response = await http.patch(
      Uri.parse('$baseUrl/save/$blogID'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body)['data']['blog'];
      return Blog.fromJson(json);
    } else {
      throw Exception('Failed to save blog');
    }
  }

  Future<void> deleteBlog(String blogID) async {
    final token = await authService.getToken();
    if (token == null) {
      throw Exception('No token found');
    }

    final response = await http.delete(
      Uri.parse('$baseUrl/$blogID'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete blog');
    }
  }

  Future<Blog> editBlog(String blogID, String title, String description) async {
    final token = await authService.getToken();
    if (token == null) {
      throw Exception('No token found');
    }

    final response = await http.patch(
      Uri.parse('$baseUrl/$blogID'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'title': title, 'description': description}),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body)['data']['blog'];
      return Blog.fromJson(json);
    } else {
      throw Exception('Failed to edit blog');
    }
  }

  Future<List<Blog>> getSavedBlogs() async {
    final token = await authService.getToken();
    if (token == null) {
      throw Exception('No token found');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/saved'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> json = jsonDecode(response.body)['data']['blogs'];
      return json.map((blog) => Blog.fromJson(blog)).toList();
    } else {
      throw Exception('Failed to load saved blogs');
    }
  }
}
