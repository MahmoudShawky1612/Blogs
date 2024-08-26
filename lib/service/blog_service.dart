import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/blog_user_model.dart';
import 'auth_service.dart';

class BlogService {
  final String baseUrl = 'http://192.168.1.112:3000/api/v1/blogs'; // Update with your backend URL
  final AuthService authService = AuthService();

  Future<List<Blog>> getBlogs() async {
    final token = await authService.getToken();
    if (token == null) {
      throw Exception('No token found');
    }

    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> json = data['data']['blogs'];
        return json.map((blog) => Blog.fromJson(blog)).toList();
      } else {
        final errorResponse = jsonDecode(response.body);
        throw Exception('Failed to load blogs: ${errorResponse['msg']}');
      }
    } catch (e) {
      print('Error getting blogs: $e');
      rethrow;
    }
  }

  Future<List<Blog>> searchBlogsByTitle(String titlePattern) async {
    try {
      final token = await authService.getToken();
      if (token == null || token.isEmpty) {
        throw Exception('No token found');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/search?blogTitle=$titlePattern'),
        headers: {'Authorization': 'Bearer $token'},
      );

      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      // Adjust success check
      if (response.statusCode == 200 && jsonResponse['success'] == 'success') {
        final List<dynamic> blogsJson = jsonResponse['data']['blogs'];
        return blogsJson.map((json) => Blog.fromJson(json)).toList();
      } else {
        throw Exception(jsonResponse['message'] ?? 'Failed to search blogs');
      }
    } catch (e) {
      print('Error searching blogs: $e');
      throw Exception('Failed to search blogs: $e');
    }
  }

  Future<Blog> createBlog(String title, String description) async {
    final token = await authService.getToken();
    if (token == null) {
      throw Exception('No token found');
    }

    try {
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
        final errorResponse = jsonDecode(response.body);
        throw Exception('Failed to create blog: ${errorResponse['msg']}');
      }
    } catch (e) {
      print('Error creating blog: $e');
      rethrow;
    }
  }

  Future<Blog> toggleSaveBlog(String blogID) async {
    final token = await authService.getToken();
    if (token == null) {
      throw Exception('No token found');
    }

    try {
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
        final errorResponse = jsonDecode(response.body);
        throw Exception('Failed to save blog: ${errorResponse['msg']}');
      }
    } catch (e) {
      print('Error toggling save blog: $e');
      rethrow;
    }
  }

  Future<void> deleteBlog(String blogID) async {
    final token = await authService.getToken();
    if (token == null) {
      throw Exception('No token found');
    }

    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/$blogID'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode != 200) {
        final errorResponse = jsonDecode(response.body);
        throw Exception('Failed to delete blog: ${errorResponse['msg']}');
      }
    } catch (e) {
      print('Error deleting blog: $e');
      rethrow;
    }
  }

  Future<Blog> editBlog(String blogID, String title, String description) async {
    final token = await authService.getToken();
    if (token == null) {
      throw Exception('No token found');
    }

    try {
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
        final errorResponse = jsonDecode(response.body);
        throw Exception('Failed to edit blog: ${errorResponse['msg']}');
      }
    } catch (e) {
      print('Error editing blog: $e');
      rethrow;
    }
  }

  Future<List<Blog>> getSavedBlogs() async {
    final token = await authService.getToken();
    if (token == null) {
      throw Exception('No token found');
    }

    try {
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
        final errorResponse = jsonDecode(response.body);
        throw Exception('Failed to load saved blogs: ${errorResponse['msg']}');
      }
    } catch (e) {
      print('Error getting saved blogs: $e');
      rethrow;
    }
  }
}
