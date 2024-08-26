import 'package:blog/service/auth_service.dart';
import 'package:blog/widgets/views/app_bar.dart';
import 'package:blog/widgets/views/bottom_navbar.dart';
import 'package:blog/widgets/views/saved_blogs.dart';
import 'package:blog/widgets/views/search_screen.dart';
import 'package:blog/widgets/views/signin.dart';
import 'package:blog/widgets/views/ui.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  int selectedIndex=0;
  void _onNavBarTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: const CustomAppBar(),
      body: selectedIndex == 0 ? BlogListScreen() : SavedBlogsScreen(),
      bottomNavigationBar:BottomNavBar(selectedIndex: selectedIndex,onItemTapped:_onNavBarTapped),
    );
  }
}