import 'package:flutter/material.dart';
import 'package:mpitiproject/Auth/Login.dart';
import 'package:mpitiproject/Home/Home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void initState() {
    super.initState();
    // Call the function to navigate after 3 seconds
    navigateToNextScreen();
  }

  void navigateToNextScreen() {
    // Delay for 3 seconds
    Future.delayed(Duration(seconds: 3), () {
      // Navigate to the next screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => data_variable.read('loggedIn') == 'true'
                ? HomePage()
                : Login()), // Replace YourNextScreen() with your next screen widget
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(color: Color(0xffF2F4FA)),
        child: Center(child: Image.asset('assets/logo.png')),
      ),
    );
  }
}
