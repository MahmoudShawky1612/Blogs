import 'package:flutter/material.dart';
import '../modulw/module.dart';
import '../service/blog_service.dart';

class BlogProvider with ChangeNotifier {
  final BlogService _blogService;
  List<Blog> _blogs = [];
  bool _isLoading = false;

  BlogProvider(this._blogService);

  List<Blog> get blogs => _blogs;

  List<Blog> get savedBlogs => _blogs.where((blog) => blog.saved).toList();

  Future<void> fetchBlogs() async {
    _isLoading = true;
    notifyListeners();

    try {
      _blogs = await _blogService.getBlogs();
    } catch (error) {
      print('Error fetching blogs: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchSavedBlogs() async {
    _isLoading = true;
    notifyListeners();

    try {
      _blogs = await _blogService.getSavedBlogs();
    } catch (e) {
      print('Error fetching saved blogs: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addBlog(String title, String description) async {
    try {
      final newBlog = await _blogService.createBlog(title, description);
      _blogs.add(newBlog);
      notifyListeners();
    } catch (e) {
      print('Error adding blog: $e');
    }
  }

  Future<void> toggleSaveBlog(String blogID) async {
    try {
      final updatedBlog = await _blogService.toggleSaveBlog(blogID);
      final index = _blogs.indexWhere((blog) => blog.id == blogID);
      if (index != -1) {
        _blogs[index] = updatedBlog;
        notifyListeners();
      }
    } catch (e) {
      print('Error toggling save blog: $e');
    }
  }

  Future<void> removeBlog(String blogID) async {
    try {
      await _blogService.deleteBlog(blogID);
      _blogs.removeWhere((blog) => blog.id == blogID);
      notifyListeners();
    } catch (e) {
      print('Error removing blog: $e');
    }
  }

  Future<void> editBlog(String blogID, String title, String description) async {
    try {
      final updatedBlog = await _blogService.editBlog(blogID, title, description);
      final index = _blogs.indexWhere((blog) => blog.id == blogID);
      if (index != -1) {
        _blogs[index] = updatedBlog;
        notifyListeners();
      }
    } catch (e) {
      print('Error editing blog: $e');
    }
  }
}
