import 'package:blog/utils/dimensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../provider/provider.dart';

class AddBlogScreen extends StatelessWidget {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  AddBlogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final blogProvider = Provider.of<BlogProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: const Icon(Icons.arrow_back_ios_new,color: Color(0xFFDD671E),)),
      backgroundColor: Color(0xFF144058),
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
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDD671E), // Use the same color scheme
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () async {
                if (_titleController.text.isEmpty || _descriptionController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill in all fields'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                await blogProvider.addBlog(
                  _titleController.text,
                  _descriptionController.text,
                );
                Navigator.of(context).pop();
              },
              child: Text(
                'Add Blog',
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