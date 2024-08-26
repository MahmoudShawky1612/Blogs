import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../provider/provider.dart';
import 'add_blog.dart';
import 'blog_list.dart';
import 'floating_action_button.dart';

class BlogListScreen extends StatefulWidget {
  @override
  _BlogListScreenState createState() => _BlogListScreenState();
}

class _BlogListScreenState extends State<BlogListScreen> {
  Future<void>? _fetchBlogsFuture;

  @override
  void initState() {
    super.initState();
    _fetchBlogsFuture = Provider.of<BlogProvider>(context, listen: false).fetchBlogs();
    Provider.of<BlogProvider>(context, listen: false).fetchCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _fetchBlogsFuture,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('An error occurred: ${snapshot.error}'));
          } else {
            return const BlogList();
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: const FAB(),

    );
  }
}

