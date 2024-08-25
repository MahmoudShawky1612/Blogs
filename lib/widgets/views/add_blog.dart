
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/provider.dart';

class AddBlogScreen extends StatelessWidget {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  AddBlogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final blogProvider = Provider.of<BlogProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Add Blog')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await blogProvider.addBlog(
                  _titleController.text,
                  _descriptionController.text,
                );
                Navigator.of(context).pop();
              },
              child: const Text('Add Blog'),
            ),
          ],
        ),
      ),
    );
  }
}