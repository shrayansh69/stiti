import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mpitiproject/Auth/Login.dart';
import 'package:mpitiproject/global.dart';
import 'package:mpitiproject/test.dart';

class MyListItem extends StatelessWidget {
  final String title;
  // final String subtitle;
  final VoidCallback onPressed;

  const MyListItem({
    required this.title,
    // required this.subtitle,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(12.0),
        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: Color(0xFF333333).withOpacity(0.1), // Border color
            width: 2.0, // Border width
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0xFF333333).withOpacity(0.1),
              blurRadius: 54,
              spreadRadius: 0,
              offset: Offset(10, 24),
            ),
          ],
        ),
        child: Row(
          children: [
            // ClipRRect(
            //   borderRadius: BorderRadius.all(Radius.circular(10.0)),
            //   child: Image.network(
            //     width: 80.0,
            //     height: 80.0,
            //     fit: BoxFit.cover,
            //   ),
            // ),
            SizedBox(width: 16.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Color(0xFFFE586A),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 8.0),
                // Text(
                //   subtitle,
                //   style: TextStyle(
                //     fontSize: 15.0,
                //     color: Colors.grey,
                //   ),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

List<dynamic> demoData = [];

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<Object> fetchResponse() async {
    final url =
        'https://shrayansh.in/yash/api/quiz/${data_variable.read('trade')}';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        List<dynamic> responseData = jsonDecode(response.body);
        setState(() {
          demoData = responseData;
        });

        print(demoData);
      }
      return true;
    } catch (e) {
      print('Error fetching data: $e');
      return false;
    }
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Exit App'),
            content: Text('Do you want to exit the app?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () => SystemNavigator.pop(),
                child: Text('Exit'),
              ),
            ],
          ),
        )) ??
        false;
  }

  void _openPdf(String pdfPath, String quizName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MyPdfViewer(pdfPath: pdfPath, quizName: quizName),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchResponse();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFFFE586A),
          elevation: 0,
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(
                  Icons.menu,
                  color: Colors.white,
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            },
          ),
        ),
        drawer: Drawer(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Stack(
            children: [
              ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  DrawerHeader(
                    decoration: BoxDecoration(
                      color: Color(0xFFFE586A),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Profile',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                        Text(
                          "Name : ${data_variable.read('name')}",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          "Contact : +91 ${data_variable.read('contact')}",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          "Email : ${data_variable.read('email')}",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          "Trade : ${data_variable.read('trade')}",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Add more list items as needed
                ],
              ),
              Positioned(
                bottom: 0,
                child: GestureDetector(
                  onTap: () {
                    login_email = '';
                    login_password = '';
                    signup_name = '';
                    signup_email = '';
                    signup_phone = '';
                    signup_trade = '';
                    signup_password = '';
                    data_variable.write('loggedIn', 'false');
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Login()),
                    );
                  },
                  child: Container(
                    color: Color.fromARGB(255, 238, 238, 238),
                    child: Positioned(
                        bottom: 0,
                        right: MediaQuery.of(context).size.width * 0.1,
                        left: MediaQuery.of(context).size.width * 0.1,
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  'Sign Out',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Icon(Icons.logout),
                              ],
                            ),
                          ),
                        )),
                  ),
                ),
              )
            ],
          ),
        ),
        backgroundColor: Color(0xFFFE586A),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hello  ${data_variable.read('name')}",
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                  Text(
                    "Let's test your knowledge",
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32.0),
                    topRight: Radius.circular(32.0),
                  ),
                ),
                child: ListView.builder(
                  itemCount: demoData.length,
                  itemBuilder: (context, index) {
                    return MyListItem(
                      title: demoData[index]['name']!,
                      // subtitle: demoData[index]['subtitle']!,
                      onPressed: () {
                        // showModalBottomSheet(
                        //   context: context,
                        //   builder: (context) {
                        //     return quiz_decription();
                        //   },
                        // );
                        _openPdf(
                            'https://shrayansh.in/iti/pages/Quiz/${data_variable.read('trade')}/${demoData[index]['name']}.pdf'!,
                            '${data_variable.read('trade')}_${demoData[index]['name']}'!);
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class quiz_decription extends StatelessWidget {
  const quiz_decription({super.key});

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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
