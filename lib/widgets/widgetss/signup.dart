import 'package:blog/widgets/views/signin.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../service/auth_service.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  bool _isLoading = false;

  Future<void> _signUp() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      await authService.signUp(
        _emailController.text.trim(),
        _passwordController.text.trim(),
        _usernameController.text.trim(),
      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => SignInScreen()),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to sign up: ${error.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFE17888), // #E17888
              Color(0xFFAE3B8B), // #AE3B8B
              Color(0xFF1C5789), // #1C5789
              Color(0xFF341514), // #341514
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Create Account",
                style: GoogleFonts.lobster(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 60,
                ),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: GoogleFonts.roboto(
                    textStyle: TextStyle(
                      color: Colors.grey.shade800,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  filled: false,
                  fillColor: Colors.white.withOpacity(0.8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  labelStyle: GoogleFonts.roboto(
                    textStyle: TextStyle(
                      color: Colors.grey.shade800,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  filled: false,
                  fillColor: Colors.white.withOpacity(0.8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: GoogleFonts.roboto(
                    textStyle: TextStyle(
                      color: Colors.grey.shade800,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  filled: false,
                  fillColor: Colors.white.withOpacity(0.8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.white,
                    ),
                  ),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => SignInScreen()),
                  );
                },
                child: const Text(
                  'Already have an account? Sign In',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              _isLoading
                  ? const CircularProgressIndicator()
                  : SizedBox(
                width: 200,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Color(0xFF1C5789)),
                    elevation: MaterialStateProperty.all(20),
                  ),
                  onPressed: _signUp,
                  child: Text(
                    'Sign Up',
                    style: GoogleFonts.lobster(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
