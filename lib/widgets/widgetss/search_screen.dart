import 'package:blog/widgets/Home.dart';
import 'package:blog/widgets/views/blog_list.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../provider/provider.dart';
import 'search_bar.dart' as custom; // Use an alias for the custom SearchBar

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

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
  void dispose() {
    // Reset the blog list to show all blogs when navigating back
    Provider.of<BlogProvider>(context, listen: false).fetchBlogs();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final blogProvider = Provider.of<BlogProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF144058),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          color: const Color(0xFFDD671E),
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (ctx) => const HomeScreen()),(_)=>false,
              );
            }
        ),
        backgroundColor: const Color(0xFF144058),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(70.0),
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
          ?  Center(child: Text('Enter a query to search',style: GoogleFonts.lobster(
          color: const Color(0xFFDD671E)
      ),))
          : blogProvider.blogs.isEmpty
          ?  Center(child: Text('No blogs match your search criteria',style: GoogleFonts.lobster(
          color: const Color(0xFFDD671E)
      ),))
          : const Padding(
        padding: EdgeInsets.all(10.0),
        child: BlogList(),
      ),
    );
  }
}