import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/provider.dart';

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
      appBar: AppBar(title: Text('Saved Blogs')),
      body: FutureBuilder(
        future: _fetchSavedBlogsFuture,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('An error occurred: ${snapshot.error}'));
          } else {
            final savedBlogs = blogProvider.savedBlogs;

            if (savedBlogs.isEmpty) {
              return Center(child: Text('No saved blogs found.'));
            }

            return ListView.builder(
              itemCount: savedBlogs.length,
              itemBuilder: (ctx, i) => ListTile(
                title: Text(savedBlogs[i].title),
                subtitle: Text(savedBlogs[i].description),
                trailing: IconButton(
                  icon: Icon(
                    savedBlogs[i].saved ? Icons.bookmark : Icons.bookmark_border,
                  ),
                  onPressed: () {
                    blogProvider.toggleSaveBlog(savedBlogs[i].id);
                  },
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
