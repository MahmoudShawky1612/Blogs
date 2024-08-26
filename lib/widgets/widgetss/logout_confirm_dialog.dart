import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Confirm Logout',
              style: GoogleFonts.lobster(
                fontSize: 20,
                color: const Color(0xFFDD671E),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Are you sure you want to logout?',
              style: GoogleFonts.openSans(
                fontSize: 16,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
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