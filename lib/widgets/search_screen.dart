import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../modulw/module.dart';
import '../provider/provider.dart';
import 'edit_blog.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _searchQuery = '';
  bool _hasSearched = false;

  void _searchBlogs() async {
    if (_searchQuery.isNotEmpty) {
      setState(() {
        _hasSearched = true;
      });

      try {
        await Provider.of<BlogProvider>(context, listen: false).searchBlogsByTitle(_searchQuery);
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
        title: Text('Search Blogs'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(56.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Search by title',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                      if (_searchQuery.isNotEmpty) {
                        _searchBlogs();
                      }
                    },
                    onSubmitted: (value) => _searchBlogs(),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _searchBlogs,
                ),
              ],
            ),
          ),
        ),
      ),
      body: blogProvider.isLoading
          ? Center(child: CircularProgressIndicator())
          : !_hasSearched
          ? Center(child: Text('Enter a query to search'))
          : blogProvider.blogs.isEmpty
          ? Center(child: Text('No blogs match your search criteria'))
          : ListView.builder(
        itemCount: blogProvider.blogs.length,
        itemBuilder: (ctx, i) => ListTile(
          title: Text(blogProvider.blogs[i].title),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(blogProvider.blogs[i].description),
              Text('By: ${blogProvider.blogs[i].username}'),
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
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => EditBlogScreen(blog: blogProvider.blogs[i]),
                    ),
                  );
                },
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
      ),
    );
  }
}