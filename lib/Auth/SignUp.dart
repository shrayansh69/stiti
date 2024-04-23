import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mpitiproject/Auth/Login.dart';
import 'package:mpitiproject/Home/Home.dart';
import 'package:mpitiproject/global.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String UserID = '';
  Future<Object> fetchResponse(String phoneNumber) async {
    final url = 'https://shrayansh.in/yash/api/signedUp?phone=$signup_phone';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        print(response.body);
        if (response.body == "false") {
          fetchResponse2();

          // Navigator.push(context, MaterialPageRoute(builder: (context) {
          //   return OTPPage();
          // }));
        } else {
          setState(() {
            // ispressed = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('User already exists. Please login.'),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              margin: EdgeInsets.all(16.0),
            ),
          );
        }
        return response.body == 'true';
      } else {
        // If the response status code is not 200, throw an exception or handle
        // the error accordingly.
        throw Exception('Failed to fetch data: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exceptions if any occur during the request.
      print('Error fetching data: $e');
      return false; // Return false in case of an error.
    }
  }

  Future<Object> fetchResponse2() async {
    final url = 'https://shrayansh.in/yash/api/count';
    String CountUser = '';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        print(response.body);
        CountUser = response.body;
        if (CountUser.length == 1) {
          UserID = 'ITI0000$CountUser';
        } else if (CountUser.length == 2) {
          UserID = 'ITI000$CountUser';
        } else if (CountUser.length == 3) {
          UserID = 'ITI00$CountUser';
        } else if (CountUser.length == 4) {
          UserID = 'ITI0$CountUser';
        } else {
          UserID = 'ITI$CountUser';
        }
        print(UserID);
        signUp();
        return response.body == 'true';
      } else {
        throw Exception('Failed to fetch data: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exceptions if any occur during the request.
      print('Error fetching data: $e');
      return false; // Return false in case of an error.
    }
  }

  Future<void> signUp() async {
    // Define the API endpoint
    String apiUrl = 'https://shrayansh.in/yash/api/signup';

    // Create the request body
    Map<String, String> requestBody = {
      'id': UserID,
      'name': signup_name,
      'email': signup_email,
      'contact': signup_phone,
      'password': signup_password,
      'trade': signup_trade
    };

    // Convert the request body to JSON format
    String jsonBody = jsonEncode(requestBody);

    try {
      // Make the POST request
      http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonBody,
      );

      // Check if the request was successful (status code 200)
      if (response.statusCode == 200) {
        print('Sign up successful');
        data_variable.write('name', signup_name);
        data_variable.write('email', signup_email);
        data_variable.write('contact', signup_phone);
        data_variable.write('trade', signup_trade);
        data_variable.write('ID', UserID);
        data_variable.write('loggedIn', 'true');
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return SignupSuccess();
          },
        );
        // Navigator.push(context, MaterialPageRoute(builder: (context) {
        //   return HomePage();
        // }));
        // You can handle the response here if needed
      } else {
        // Handle error if the request was not successful
        print('Failed to sign up. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exceptions if any occur during the request
      print('Error signing up: $e');
    }
  }

  String confirm_password = '';
  String _selectedOption = 'Electrician';
  bool _obscureText = true;
  bool _obscureText2 = true;
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _passwordController2 = TextEditingController();
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
                  'SignUp',
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
                      'Full Name',
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
                      signup_name = value;
                    });
                  },
                  onSubmitted: (value) {
                    setState(() {
                      signup_name = value;
                    });
                  },
                  decoration: InputDecoration(
                      hintText: "Enter your Full Name",
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
                      signup_email = value;
                    });
                  },
                  onSubmitted: (value) {
                    setState(() {
                      signup_email = value;
                    });
                  },
                  decoration: InputDecoration(
                      hintText: "Enter your Email Address",
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
                      'Phone Number',
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
                      signup_phone = value;
                    });
                  },
                  onSubmitted: (value) {
                    setState(() {
                      signup_phone = value;
                    });
                  },
                  decoration: InputDecoration(
                      hintText: "Enter your Phone Number",
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
                //-
                const Row(
                  children: [
                    Text(
                      'Select Trade',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.07,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100.0),
                      border: Border.all(color: Color(0xFFD7DCE5))),
                  child: DropdownButton<String>(
                    icon: Icon(
                      Icons.downhill_skiing,
                      color: Colors.transparent,
                    ),
                    underline: SizedBox(),
                    value: _selectedOption,
                    items: <String>[
                      'Electrician',
                      'Fitter',
                      'Solar Technician (Electrical)',
                      'Cosmetology'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(color: Colors.grey),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedOption = newValue!;
                        signup_trade = newValue;
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                const Row(
                  children: [
                    Text(
                      'Create Password',
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
                      signup_password = value;
                    });
                  },
                  onSubmitted: (value) {
                    setState(() {
                      signup_password = value;
                    });
                  },
                  controller: _passwordController,
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                    hintText: "Create Password",
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
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                const Row(
                  children: [
                    Text(
                      'Re-Enter Password',
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
                      confirm_password = value;
                    });
                  },
                  onSubmitted: (value) {
                    setState(() {
                      confirm_password = value;
                    });
                  },
                  controller: _passwordController2,
                  obscureText: _obscureText2,
                  decoration: InputDecoration(
                    hintText: "Re-Enter Password",
                    filled: true,
                    fillColor: Colors.white,
                    suffixIcon: IconButton(
                      icon: Icon(_obscureText
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined),
                      onPressed: () {
                        setState(() {
                          _obscureText2 = !_obscureText2;
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
                    if (signup_email.isEmpty ||
                        signup_name.isEmpty ||
                        signup_password.isEmpty ||
                        signup_phone.isEmpty ||
                        signup_trade.isEmpty ||
                        confirm_password.isEmpty) {
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
                      if (signup_password != confirm_password) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Password does not matche.'),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            margin: EdgeInsets.all(16.0),
                          ),
                        );
                      } else {
                        print(signup_email);
                        print(signup_name);
                        print(signup_password);
                        print(signup_phone);
                        print(signup_trade);
                        print(confirm_password);
                        fetchResponse(signup_phone);
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => HomePage()),
                        // );
                      }
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
                    'Signup',
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
                      MaterialPageRoute(builder: (context) => Login()),
                    );
                  },
                  child: Text(
                    'Login',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xffFE586A)),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SignupSuccess extends StatelessWidget {
  const SignupSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.27,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              children: [
                Image.asset(
                  'assets/chotu.png',
                  height: 100,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Request submitted\nsuccessfully.',
                      textAlign: TextAlign.center,
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
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
                );
              },
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Color(0xffFE586A)),
                minimumSize: MaterialStateProperty.all<Size>(
                    Size(double.infinity, 58)), // Width 100%, height 48
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
              child: Text(
                'Login',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
