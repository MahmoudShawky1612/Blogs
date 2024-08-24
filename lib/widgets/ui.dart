import 'package:blog/widgets/saved_blogs.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../modulw/module.dart';
import '../provider/provider.dart';
import 'add_blog.dart';
import 'edit_blog.dart';

class BlogListScreen extends StatefulWidget {
  @override
  _BlogListScreenState createState() => _BlogListScreenState();
}

class _BlogListScreenState extends State<BlogListScreen> {
  Future<void>? _fetchBlogsFuture;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchBlogsFuture = Provider.of<BlogProvider>(context, listen: false).fetchBlogs();
  }

  void _refreshBlogs() async {
    setState(() {
      _fetchBlogsFuture = Provider.of<BlogProvider>(context, listen: false).fetchBlogs();
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => SavedBlogsScreen()));
    }
  }

  void _editBlog(Blog blog) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => EditBlogScreen(blog: blog),
      ),
    );

    if (result == true) {
      // Refresh the blog list if changes were made
      _refreshBlogs();
    }
  }

  @override
  Widget build(BuildContext context) {
    final blogProvider = Provider.of<BlogProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Blogs')),
      body: FutureBuilder(
        future: _fetchBlogsFuture,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('An error occurred: ${snapshot.error}'));
          } else {
            return ListView.builder(
              itemCount: blogProvider.blogs.length,
              itemBuilder: (ctx, i) => ListTile(
                title: Text(blogProvider.blogs[i].title),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(blogProvider.blogs[i].description),
                    SizedBox(height: 4),
                    Text(
                      'Date: ${blogProvider.blogs[i].date.day}/${blogProvider.blogs[i].date.month} ${blogProvider.blogs[i].date.hour}:${blogProvider.blogs[i].date.minute.toString().padLeft(2, '0')}',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        blogProvider.blogs[i].saved ? Icons.bookmark : Icons.bookmark_border,
                      ),
                      onPressed: () {
                        blogProvider.toggleSaveBlog(blogProvider.blogs[i].id);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => _editBlog(blogProvider.blogs[i]),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: Text('Confirm Deletion'),
                            content: Text('Are you sure you want to delete this blog?'),
                            actions: [
                              TextButton(
                                child: Text('Cancel'),
                                onPressed: () {
                                  Navigator.of(ctx).pop();
                                },
                              ),
                              TextButton(
                                child: Text('Delete'),
                                onPressed: () {
                                  blogProvider.removeBlog(blogProvider.blogs[i].id);
                                  Navigator.of(ctx).pop();
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => AddBlogScreen()));
        },
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Blogs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Saved Blogs',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}