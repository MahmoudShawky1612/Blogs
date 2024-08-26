import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/dimensions.dart';

class SearchBar extends StatelessWidget {
  final Function(String) onSearch;
  final Function(String) onQueryChanged;

  const SearchBar({
    required this.onSearch,
    required this.onQueryChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:   EdgeInsets.only(top: Dimensions.thirty,left: Dimensions.twentyFive,right: Dimensions.twentyFive),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration:  InputDecoration(
                labelText: 'Search by title',
                labelStyle: GoogleFonts.lobster(
                  color: const Color(0xFFDD671E),
                  fontSize: Dimensions.thirTeen
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
              onChanged: onQueryChanged,
              onSubmitted: onSearch,
            ),
          ),
        ],
      ),
    );
  }
}