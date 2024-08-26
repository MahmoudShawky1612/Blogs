import 'package:blog/utils/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../model/blog_user_model.dart';
import '../../provider/provider.dart';

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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields'),
          backgroundColor: Colors.red,
        ),
      );
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
       ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please fill in all fields'),
            backgroundColor: Colors.red,
          ));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFFDD671E)),
        ),
        backgroundColor: const Color(0xFF144058),
      ),
      backgroundColor: const Color(0xFF144058),
      body: Padding(
        padding:  EdgeInsets.all(Dimensions.sixteen),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                labelStyle: GoogleFonts.lobster(
                  color: const Color(0xFFDD671E),
                  fontSize: Dimensions.thirTeen,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: Color(0xFFDD671E), // Border color
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: Color(0xFFE58D2E), // Border color when enabled
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: Color(0xFFDD671E), // Border color when focused
                  ),
                ),
              ),
            ),
             SizedBox(height: Dimensions.thirty),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                labelStyle: GoogleFonts.lobster(
                  color: const Color(0xFFDD671E),
                  fontSize: Dimensions.thirTeen,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: Color(0xFFDD671E), // Border color
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: Color(0xFFE58D2E), // Border color when enabled
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: Color(0xFFDD671E), // Border color when focused
                  ),
                ),
              ),
            ),
              SizedBox(height: Dimensions.twenty),
            if (_isLoading)
              const CircularProgressIndicator()
            else
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFDD671E), // Use the same color scheme
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: _submit,
                child: Text(
                  'Save',
                  style: GoogleFonts.lobster(
                    color: const Color(0xFF4D181C),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}