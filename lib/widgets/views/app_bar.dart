import 'dart:math';
import 'package:blog/widgets/views/search_screen.dart';
import 'package:blog/widgets/views/signin.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../provider/provider.dart';
import '../../service/auth_service.dart';
import 'logout_confirm_dialog.dart';

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
    final blogProvider = Provider.of<BlogProvider>(context);

    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(30), // Adjust radius as needed
        ),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF144058), // color3
                Color(0xFFDD671E),
              ],
              transform: GradientRotation(pi / 1),
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: AppBar(
            backgroundColor: Colors.transparent, // Make AppBar background transparent
            title: Row(
              children: [
                const Icon(Icons.circle, color: Colors.green, size: 10),
                const SizedBox(width: 5),
                const Icon(Icons.person, size: 27, color: Color(0xFF144058)),
                const SizedBox(width: 5),
                Text(
                  blogProvider.currentUser?.username ?? '',
                  style: GoogleFonts.lobsterTwo(
                    color: const Color(0xFF144058),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.search),
                color: const Color(0xFFDD671E),
                tooltip: 'Search',
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (ctx) => const SearchScreen()),(_)=>false,
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.restart_alt),
                color: const Color(0xFFDD671E),
                tooltip: 'Refresh',
                onPressed: res,
              ),
              IconButton(
                icon: const Icon(Icons.logout),
                color: const Color(0xFFDD671E),
                tooltip: 'Logout',
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => LogoutConfirmationDialog(
                      onLogout: () {
                        _authService.logout();
                        Navigator.of(ctx).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (ctx) => SignInScreen()),
                              (Route<dynamic> route) => false,
                        );
                      },
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