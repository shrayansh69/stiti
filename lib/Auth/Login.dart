import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mpitiproject/Auth/SignUp.dart';
import 'package:mpitiproject/Home/Home.dart';
import 'package:mpitiproject/global.dart';
import 'package:http/http.dart' as http;

final data_variable = GetStorage();

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Future<Object> fetchResponse() async {
    final url =
        'https://shrayansh.in/yash/api/signedUp?email=$login_email&password=$login_password';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        print(responseData['name']);
        if (response.body == "false") {
          setState(() {});
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('User does not exists. Please Sign up.'),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              margin: EdgeInsets.all(16.0),
            ),
          );
        } else {
          if (responseData['status'] == 'P') {
            showModalBottomSheet(
              context: context,
              builder: (context) {
                return pendingg();
              },
            );
          } else if (responseData['status'] == 'R') {
            showModalBottomSheet(
              context: context,
              builder: (context) {
                return rejected();
              },
            );
          } else if (responseData['status'] == 'A') {
            data_variable.write('name', responseData['name']);
            data_variable.write('email', responseData['email']);
            data_variable.write('contact', responseData['contact']);
            data_variable.write('trade', responseData['trade']);
            data_variable.write('ID', responseData['ID']);
            data_variable.write('loggedIn', 'true');
            print(data_variable.read('name'));
            print(data_variable.read('email'));
            print(data_variable.read('contact'));
            print(data_variable.read('trade'));
            print(data_variable.read('ID'));
            navigateTo();
          }
        }
        return response.body == 'true';
      } else {
        throw Exception('Failed to fetch data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
      return false;
    }
  }

  void navigateTo() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return HomePage();
    }));
  }

  bool _obscureText = true;
  TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(color: Color(0xffF2F4FA)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                ),
                Image.asset(
                  'assets/chotu.png',
                  scale: 0.8,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.04,
                ),
                const Text(
                  'Welcome to IMC E learning ',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.0),
                ),
                const Text(
                  'Login',
                  style: TextStyle(
                      fontSize: 52,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2.0),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                const Row(
                  children: [
                    Text(
                      'Email Address',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      login_email = value;
                    });
                  },
                  onSubmitted: (value) {
                    setState(() {
                      login_email = value;
                    });
                  },
                  decoration: InputDecoration(
                      hintText: "Enter your Emai Address",
                      filled: true,
                      fillColor: Colors.white,
                      hintStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100),
                          borderSide: BorderSide(color: Color(0xffD7DCE5))),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100),
                          borderSide: BorderSide(color: Color(0xffD7DCE5)))),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                const Row(
                  children: [
                    Text(
                      'Password',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                TextField(
                  controller: _passwordController,
                  obscureText: _obscureText,
                  onChanged: (value) {
                    setState(() {
                      login_password = value;
                    });
                  },
                  onSubmitted: (value) {
                    setState(() {
                      login_password = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: "Enter your Password",
                    filled: true,
                    fillColor: Colors.white,
                    suffixIcon: IconButton(
                      icon: Icon(_obscureText
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                    hintStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100),
                      borderSide: BorderSide(color: Color(0xffD7DCE5)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100),
                      borderSide: BorderSide(color: Color(0xffD7DCE5)),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (login_email.isEmpty || login_password.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please enter all details correctly.'),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          margin: EdgeInsets.all(16.0),
                        ),
                      );
                    } else {
                      fetchResponse();
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Color(0xffFE586A)),
                    minimumSize: MaterialStateProperty.all<Size>(
                        Size(double.infinity, 58)), // Width 100%, height 48
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                  ),
                  child: Text(
                    'Login',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                SvgPicture.asset("assets/or.svg"),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUp()),
                    );
                  },
                  child: Text(
                    'Create Account',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xffFE586A)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class rejected extends StatelessWidget {
  const rejected({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.2,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Image.asset(
              'assets/rejected.png',
              height: 100,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Sign Up rejected by Admin.',
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.05,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                ),
                Text(
                  'Contact your Administrator Cell.',
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.03,
                      fontWeight: FontWeight.w400,
                      color: Colors.black),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class pendingg extends StatelessWidget {
  const pendingg({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.2,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Image.asset(
              'assets/pending.png',
              height: 100,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Sign up processing.',
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.05,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                ),
                Text(
                  'Please wait while we verify.',
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.03,
                      fontWeight: FontWeight.w400,
                      color: Colors.black),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
