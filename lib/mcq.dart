import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mpitiproject/Auth/Login.dart';
import 'package:mpitiproject/Home/Home.dart';
import 'package:http/http.dart' as http;

String finalScore = '';

class MCQTestPage extends StatefulWidget {
  final String quizName;
  const MCQTestPage({required this.quizName});

  @override
  _MCQTestPageState createState() => _MCQTestPageState();
}

List<dynamic> quizData = [];

class _MCQTestPageState extends State<MCQTestPage> {
  Future<void> uploadResult() async {
    // Define the API endpoint
    String apiUrl = 'https://shrayansh.in/yash/api/uploadResult';
    int score = calculateScore();
    // Create the request body
    Map<String, String> requestBody = {
      'table': "${widget.quizName}_result",
      'studentID': data_variable.read('ID'),
      'score': finalScore,
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
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultsPage(
                score: score,
                quizName: quizData[0]['topic'],
                totalQuestions: questions.length),
          ),
        );
      } else {
        // Handle error if the request was not successful
        print('Failed to sign up. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exceptions if any occur during the request
      print('Error signing up: $e');
    }
  }

  PageController _pageController = PageController();

  int currentPageIndex = 0;
  bool reachedLastQuestion = false;
  List<dynamic> questions = [];
//  https://shrayansh.in/yash/api/quizDetails/Electrician_yash
  Future<Object> fetchResponse() async {
    final url = 'https://shrayansh.in/yash/api/quizDetails/${widget.quizName}';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          quizData = jsonDecode(response.body);
          questions = quizData;
        });

        print(quizData);
      }
      return true;
    } catch (e) {
      print('Error fetching data: $e');
      return false;
    }
  }

  // Demo data for questions and options

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    fetchResponse();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MCQ Test'),
      ),
      body: Column(
        children: [
          // Show the progress
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              'Question ${currentPageIndex + 1}/${questions.length!}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: questions.length,
              itemBuilder: (context, index) {
                return AnimatedBuilder(
                  animation: _pageController,
                  builder: (context, child) {
                    double value = 1;
                    if (_pageController.position.haveDimensions) {
                      // value = (_pageController.page - index).toDouble();
                      value = (1 - (value.abs() * 0.5)).clamp(0.0, 1.0);
                    }
                    return SizedBox(
                      height: Curves.easeInOut.transform(value) * 300,
                      width: Curves.easeInOut.transform(value) * 250,
                      child: child,
                    );
                  },
                  child: buildQuestionPage(questions[index]),
                );
              },
              onPageChanged: (index) {
                setState(() {
                  currentPageIndex = index;
                  if (index == questions.length - 1) {
                    reachedLastQuestion = true;
                  } else {
                    reachedLastQuestion = false;
                  }
                });
              },
            ),
          ),
          if (reachedLastQuestion)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    // Set the button color based on its state
                    if (states.contains(MaterialState.disabled)) {
                      // Return the disabled color if button is disabled
                      return Colors.grey.shade300;
                    }
                    // Return the enabled color if button is enabled
                    return Colors.green;
                  }),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(50.0), // Set border radius
                    ),
                  ),
                  minimumSize: MaterialStateProperty.all(
                      Size(double.infinity, 50)), // Set width and height
                ),
                onPressed: () {
                  // Calculate score and navigate to results page
                  int score = calculateScore();
                  setState(() {
                    finalScore = '$score/${questions.length}';
                  });
                  uploadResult();
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => ResultsPage(
                  //         score: score,
                  //         quizName: quizData[0]['topic'],
                  //         totalQuestions: questions.length),
                  //   ),
                  // );
                },
                child: Text(
                  'Submit Test',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 15),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0, top: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed:
                      currentPageIndex > 0 ? () => goToPreviousPage() : null,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      // Set the button color based on its state
                      if (states.contains(MaterialState.disabled)) {
                        // Return the disabled color if button is disabled
                        return Colors.grey.shade300;
                      }
                      // Return the enabled color if button is enabled
                      return Color(0xffFE586A);
                    }),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10.0), // Set border radius
                      ),
                    ),
                    minimumSize: MaterialStateProperty.all(
                        Size(150, 50)), // Set width and height
                  ),
                  child: Text(
                    'Previous',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                        fontSize: 15),
                  ),
                ),
                ElevatedButton(
                  onPressed: currentPageIndex < questions.length - 1
                      ? () => goToNextPage()
                      : null,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      // Set the button color based on its state
                      if (states.contains(MaterialState.disabled)) {
                        // Return the disabled color if button is disabled
                        return Colors.grey;
                      }
                      // Return the enabled color if button is enabled
                      return Color(0xffFE586A);
                    }),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10.0), // Set border radius
                      ),
                    ),
                    minimumSize: MaterialStateProperty.all(
                        Size(150, 50)), // Set width and height
                  ),
                  child: Text(
                    'Next',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                        fontSize: 15),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildQuestionPage(Map<String, dynamic> questionData) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            questionData['question'],
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
              4, // Assuming there are always four options
              (index) {
                final option = questionData[
                    'option${index + 1}']; // Accessing option1, option2, option3, option4
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      questionData['selectedOption'] =
                          questionData['option${index + 1}'];
                    });
                  },
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: questionData['selectedOption'] ==
                              questionData['option${index + 1}']
                          ? Color(0xffFE586A) // Change color as needed
                          : Color.fromARGB(255, 212, 249, 255),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: EdgeInsets.all(12.0),
                    margin: EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      option,
                      style: TextStyle(
                        color: questionData['selectedOption'] ==
                                questionData['option${index + 1}']
                            ? Colors.white // Change text color as needed
                            : Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void goToPreviousPage() {
    _pageController.previousPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void goToNextPage() {
    _pageController.nextPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  int calculateScore() {
    int score = 0;

    for (int i = 0; i < questions.length; i++) {
      String selec = questions[i]['selectedOption'] == null
          ? 'null'
          : questions[i]['selectedOption'].trim();
      String corre = questions[i]['correct_answer'].trim();
      print(selec + " : " + corre);
      if (selec == corre) {
        print('hello');
        score++;
      }
    }
    return score;
  }
}

class ResultsPage extends StatefulWidget {
  final int score;
  final int totalQuestions;
  final String quizName;

  const ResultsPage(
      {Key? key,
      required this.score,
      required this.quizName,
      required this.totalQuestions})
      : super(key: key);

  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Add animation for the score display
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.2,
              ),
              child: SvgPicture.asset(
                "assets/result.svg",
                width: MediaQuery.of(context).size.width * 0.7,
                height: MediaQuery.of(context).size.height * 0.25,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      // Text(
                      //   'Test Title : ${widget.quizName}',
                      //   style: TextStyle(
                      //       color: Colors.black,
                      //       fontWeight: FontWeight.w500,
                      //       fontSize: 15),
                      // ),
                    ],
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  // Row(
                  //   children: [
                  //     Text(
                  //       'Test Description : ',
                  //       style: TextStyle(
                  //           color: Colors.black,
                  //           fontWeight: FontWeight.w500,
                  //           fontSize: 15),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
            // Expanded(child: Container()),
            Text(
              'Test Title : ${widget.quizName.toUpperCase()}',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 15),
            ),
            AnimatedTextScore(
                score: widget.score, totalQuestions: widget.totalQuestions),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.08,
                  right: MediaQuery.of(context).size.width * 0.08,
                  bottom: MediaQuery.of(context).size.height * 0.05),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    // Set the button color based on its state
                    if (states.contains(MaterialState.disabled)) {
                      // Return the disabled color if button is disabled
                      return Colors.grey;
                    }
                    // Return the enabled color if button is enabled
                    return Color(0xffFE586A);
                  }),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10.0), // Set border radius
                    ),
                  ),
                  minimumSize: MaterialStateProperty.all(
                      Size(double.infinity, 50)), // Set width and height
                ),
                onPressed: () {
                  // Navigate back to the home page
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                },
                child: Text(
                  'Back to Home',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 15),
                ),
              ),
            ),
            SizedBox(
              height: 16.0,
            )
          ],
        ),
      ),
    );
  }
}

class AnimatedTextScore extends StatefulWidget {
  final int score;
  final int totalQuestions;

  const AnimatedTextScore(
      {Key? key, required this.score, required this.totalQuestions})
      : super(key: key);

  @override
  _AnimatedTextScoreState createState() => _AnimatedTextScoreState();
}

class _AnimatedTextScoreState extends State<AnimatedTextScore>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    _animation = Tween<double>(begin: 0, end: widget.score.toDouble())
        .animate(_controller)
      ..addListener(() {
        setState(() {});
      });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      'Total Score: ${_animation.value.toInt()}/${widget.totalQuestions}',
      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    );
  }
}
