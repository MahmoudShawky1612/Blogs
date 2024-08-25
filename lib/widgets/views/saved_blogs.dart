import 'package:blog/widgets/views/blog_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/provider.dart';

class SavedBlogsScreen extends StatefulWidget {
  @override
  _SavedBlogsScreenState createState() => _SavedBlogsScreenState();
}

class _SavedBlogsScreenState extends State<SavedBlogsScreen> {
  Future<void>? _fetchSavedBlogsFuture;

  @override
  void initState() {
    super.initState();
    _fetchSavedBlogsFuture = Provider.of<BlogProvider>(context, listen: false).fetchSavedBlogs();
  }

  @override
  Widget build(BuildContext context) {
    final blogProvider = Provider.of<BlogProvider>(context);

    return Scaffold(
      appBar: AppBar(
          title: const Text('Saved Blogs')),
      body: FutureBuilder(
        future: _fetchSavedBlogsFuture,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('An error occurred: ${snapshot.error}'));
          } else {
            final savedBlogs = blogProvider.savedBlogs;

            if (savedBlogs.isEmpty) {
              return const Center(child: Text('No saved blogs found.'));
            }

            return const BlogList();
          }
        },
      ),
    );
  }
}
