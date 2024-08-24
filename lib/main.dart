import 'package:blog/widgets/ui.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'service/auth_service.dart';
import 'service/blog_service.dart';
import 'provider/provider.dart';
import 'widgets/signin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthService>(
          create: (context) => AuthService(),
        ),
        ChangeNotifierProvider<BlogProvider>(
          create: (context) => BlogProvider(BlogService()),
        ),
      ],
      child: MaterialApp(
        home: BlogListScreen(),
      ),
    );
  }
}
