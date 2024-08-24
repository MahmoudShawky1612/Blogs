import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/provider.dart';
import '../modulw/module.dart';

class EditBlogScreen extends StatefulWidget {
  final Blog blog;

  EditBlogScreen({required this.blog});

  @override
  _EditBlogScreenState createState() => _EditBlogScreenState();
}

class _EditBlogScreenState extends State<EditBlogScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.blog.title;
    _descriptionController.text = widget.blog.description;
  }

  Future<void> _submit() async {
    final title = _titleController.text;
    final description = _descriptionController.text;

    if (title.isEmpty || description.isEmpty) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await Provider.of<BlogProvider>(context, listen: false)
          .editBlog(widget.blog.id, title, description);
      Navigator.of(context).pop(true); // Pass true to indicate changes were made
    } catch (error) {
      // Handle error (show a snackbar or dialog)
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Blog')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 20),
            if (_isLoading)
              CircularProgressIndicator()
            else
              ElevatedButton(
                onPressed: _submit,
                child: Text('Save'),
              ),
          ],
        ),
      ),
    );
  }
}
