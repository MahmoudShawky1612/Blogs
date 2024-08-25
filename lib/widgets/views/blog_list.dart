import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../modulw/module.dart';
import '../../provider/provider.dart';
import 'edit_blog.dart';

class BlogList extends StatefulWidget {
  const BlogList({super.key});

  @override
  State<BlogList> createState() => _BlogListState();
}

class _BlogListState extends State<BlogList> {
  Future<void>? _fetchBlogsFuture;

  void _refreshBlogs() async {
    setState(() {
      _fetchBlogsFuture =
          Provider.of<BlogProvider>(context, listen: false).fetchBlogs();
    });
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

    return ListView.builder(
      itemCount: blogProvider.blogs.length,
      itemBuilder: (ctx, i) =>
          ListTile(
            title: Text(blogProvider.blogs[i].title),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(blogProvider.blogs[i].description),
                Text('By: ${blogProvider.blogs[i].username}'),
                const SizedBox(height: 4),
                Text(
                  'Date: ${blogProvider.blogs[i].date.day}/${blogProvider
                      .blogs[i].date.month} ${blogProvider.blogs[i].date
                      .hour}:${blogProvider.blogs[i].date.minute.toString()
                      .padLeft(2, '0')}',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    blogProvider.blogs[i].saved ? Icons.bookmark : Icons
                        .bookmark_border,
                  ),
                  onPressed: () {
                    blogProvider.toggleSaveBlog(blogProvider.blogs[i].id);
                  },
                ),
                if (blogProvider.isAuthor(blogProvider.blogs[i].username)) ...[
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _editBlog(blogProvider.blogs[i]),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (ctx) =>
                            AlertDialog(
                              title: const Text('Confirm Deletion'),
                              content: const Text(
                                  'Are you sure you want to delete this blog?'),
                              actions: [
                                TextButton(
                                  child: const Text('Cancel'),
                                  onPressed: () {
                                    Navigator.of(ctx).pop();
                                  },
                                ),
                                TextButton(
                                  child: const Text('Delete'),
                                  onPressed: () {
                                    blogProvider.removeBlog(
                                        blogProvider.blogs[i].id);
                                    Navigator.of(ctx).pop();
                                  },
                                ),
                              ],
                            ),
                      );
                    },
                  ),
                ],
              ],
            ),
          ),
    );
  }

}