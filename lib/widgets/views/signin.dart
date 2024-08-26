import 'package:blog/widgets/views/signup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../service/auth_service.dart';
import '../../utils/dimensions.dart';
import '../Home.dart';
import 'package:google_fonts/google_fonts.dart';



class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _signIn() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      await authService.signIn(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to sign in: ${error.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print("height"+MediaQuery.of(context).size.height.toString());
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFE17888), // #E17888
              Color(0xFFAE3B8B), // #AE3B8B
              Color(0xFF1C5789), // #1C5789
              Color(0xFF341514),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding:  EdgeInsets.all(Dimensions.sixteen),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
               Text("Welcome to Loot", style: GoogleFonts.lobster(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: Dimensions.fiftyFive,
          ),),
               SizedBox(height: Dimensions.thirty,),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
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
               SizedBox(height: Dimensions.thirty),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  filled: false,
                  fillColor: Colors.white.withOpacity(0.8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    // Set the border radius here
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20), // Set the border radius here
                    borderSide: const BorderSide(
                      color: Colors.grey, // No border color when enabled
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12), // Set the border radius here
                    borderSide: const BorderSide(
                      color: Colors.white, // Border color when focused
                    ),
                  ),
                ),
                obscureText: true,
              ),

              TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => SignUpScreen()),
                  );
                },
                child: const Text('Don\'t have an account? Sign Up',style: TextStyle(color: Colors.white),),
              ),

                 SizedBox(height: Dimensions.twenty),
              _isLoading
                  ? const CircularProgressIndicator()
                  :  SizedBox(
                      width: Dimensions.twoHundred,
                    child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(const Color(0xFF1C5789)),
                              elevation: MaterialStateProperty.all(20),
                            ),
                            onPressed: _signIn,
                            child:  Text('Sign In',style: GoogleFonts.lobster(color: Colors.white,
                              fontWeight: FontWeight.bold,

                            ),),
                                  ),
                  ),

            ],
          ),
        ),
      ),
    );
  }
}
