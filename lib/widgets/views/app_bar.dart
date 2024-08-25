import 'package:blog/widgets/views/search_screen.dart';
import 'package:blog/widgets/views/signin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/provider.dart';
import '../../service/auth_service.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  Future<void>? _fetchBlogsFuture;
  final AuthService _authService = AuthService();

  void res() {
    setState(() {
      _fetchBlogsFuture = Provider.of<BlogProvider>(context, listen: false).fetchBlogs();
    });
  }

  void logout() {
    try {
      _authService.logout();
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (ctx) => SignInScreen()), (Route<dynamic> route) => false
      );
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Blogs'),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (ctx) => SearchScreen()),
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.hail),
          onPressed: res,
        ),
        IconButton(
          icon: const Icon(Icons.login_outlined),
          onPressed: logout,
        ),
      ],
    );
  }
}