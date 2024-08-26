import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/dimensions.dart';

class LogoutConfirmationDialog extends StatelessWidget {
  final VoidCallback onLogout;

  LogoutConfirmationDialog({required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: const Color(0xFF144058),
      child: Padding(
        padding:   EdgeInsets.all(Dimensions.sixteen),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Confirm Logout',
              style: GoogleFonts.lobster(
                fontSize: Dimensions.twenty,
                color: const Color(0xFFDD671E),
              ),
            ),
              SizedBox(height: Dimensions.sixteen),
            Text(
              'Are you sure you want to logout?',
              style: GoogleFonts.openSans(
                fontSize: Dimensions.sixteen,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
              SizedBox(height: Dimensions.twenty),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE58D2E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.lobster(
                      color: const Color(0xFF144058),
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFDD671E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: onLogout,
                  child: Text(
                    'Logout',
                    style: GoogleFonts.lobster(
                      color: const Color(0xFF4D181C),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}