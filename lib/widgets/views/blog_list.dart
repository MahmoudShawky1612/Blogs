import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../model/blog_user_model.dart';
import '../../provider/provider.dart';
import 'delete_confirm_dialog.dart';
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
      physics: BouncingScrollPhysics(),
      itemCount: blogProvider.blogs.length,
      itemBuilder: (ctx, i) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 8.0), // Add padding between blog cards
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Card(
              color: const Color(0xFF144058),
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 3,
                      blurRadius: 6,
                      offset: const Offset(13, 5), // changes position of shadow
                    ),
                  ],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${blogProvider.blogs[i].date.day}/${blogProvider.blogs[i].date.month} ${blogProvider.blogs[i].date.hour}:${blogProvider.blogs[i].date.minute.toString().padLeft(2, '0')}',
                            style: GoogleFonts.openSans(
                              fontSize: 12,
                              color: const Color(0xFFDD671E),
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(
                                  blogProvider.blogs[i].saved ? Icons.bookmark : Icons.bookmark_border,
                                  color: Colors.orange,
                                  size: 17,
                                ),
                                onPressed: () {
                                  blogProvider.toggleSaveBlog(blogProvider.blogs[i].id);
                                },
                              ),
                              if (blogProvider.isAuthor(blogProvider.blogs[i].username)) ...[
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Color(0xFFDD671E),size: 17,),
                                  onPressed: () => _editBlog(blogProvider.blogs[i]),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Color(0xFFDD671E), size: 17),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (ctx) => DeleteConfirmationDialog(
                                        onDelete: () {
                                          blogProvider.removeBlog(blogProvider.blogs[i].id);
                                          Navigator.of(ctx).pop();
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                      Text(
                        blogProvider.blogs[i].title,
                        style: GoogleFonts.lobster(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFE58D2E),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        blogProvider.blogs[i].description,
                        style: GoogleFonts.openSans(
                          fontSize: 16,
                          color: const Color(0xFFDD671E),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: -20,
              left: 16,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDD671E),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(2, 2), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Text(
                      blogProvider.isAuthor(blogProvider.blogs[i].username)?
                      "You":blogProvider.blogs[i].username ,
                      style: GoogleFonts.lobsterTwo(
                        fontSize: 14,
                        color: const Color(0xFF144058),
                      ),
                    ),
                  ),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE58D2E),
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}