import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'add_blog.dart';

class FAB extends StatefulWidget {
  const FAB({super.key});

  @override
  State<FAB> createState() => _FABState();
}

class _FABState extends State<FAB> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Color(0xFF4D181C),
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (ctx) => AddBlogScreen()),
        );
      },
      shape:  RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0),
      ),
      child: const FaIcon(FontAwesomeIcons.plus,color: Colors.white,),
    );
  }
}
