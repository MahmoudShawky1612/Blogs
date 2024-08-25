import 'package:blog/widgets/views/blog_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/provider.dart';
import 'edit_blog.dart';
import 'search_bar.dart' as custom; // Use an alias for the custom SearchBar

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _searchQuery = '';
  bool _hasSearched = false;

  void _searchBlogs(String query) async {
    if (query.isNotEmpty) {
      setState(() {
        _hasSearched = true;
      });

      try {
        await Provider.of<BlogProvider>(context, listen: false).searchBlogsByTitle(query);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to search blogs: ${e.toString()}')),
        );
      }
    } else {
      setState(() {
        _hasSearched = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final blogProvider = Provider.of<BlogProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Blogs'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56.0),
          child: custom.SearchBar( // Use the alias here
            onSearch: _searchBlogs,
            onQueryChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
              if (_searchQuery.isNotEmpty) {
                _searchBlogs(_searchQuery);
              }
            },
          ),
        ),
      ),
      body: blogProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : !_hasSearched
          ? const Center(child: Text('Enter a query to search'))
          : blogProvider.blogs.isEmpty
          ? const Center(child: Text('No blogs match your search criteria'))
          : const BlogList(),
    );
  }
}