import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'CreateAccountPage.dart';
import 'home_page.dart';
import 'package:http/http.dart' as http;
import 'package:ridemate/pages/main_page.dart';
import 'package:url_launcher/url_launcher.dart';




class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _url = 'http://ridemate.deti/webdiv'; // replace with your URL
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _shouldShowLoginForm = true;
  bool _isLoading = false; // add this line
  final _storage = FlutterSecureStorage();

  late WebViewController _webViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 75), // empty space at the top
          Visibility(
            visible: _shouldShowLoginForm,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                    ),
                  ),
                ),
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 150,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          // get username and password
                          final username = _usernameController.text;
                          final password = _passwordController.text;
                          // required username and password
                          if (username.isEmpty || password.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Username and password are required!",
                                  style: TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }

                          // send request to server
                          final String url = 'http://ridemate.deti/service-review/v1/auth/login';
                          final response = await http.post(
                            Uri.parse(url),
                            headers: {
                              'Content-Type': 'application/json',
                            },
                            body: jsonEncode({
                              'email': username,
                              'password': password,
                            }),
                          );
                          // check response
                          if (response.statusCode == 202){
                            // save token
                            final token = jsonDecode(response.body)['token'];
                            debugPrint(token, wrapWidth: 1024);
                            // save token to secure storage
                            _storage.write(key: 'token', value: token);
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => MainPage()),
                              (route) => false,
                            );
                            // show success message
                           
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Logged in successfully!",
                                  style: TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Colors.green,
                              ),
                            );
                          }else{
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Email or password is incorrect!",
                                  style: TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }
                        },
                        child: Text('Login'),
                      ),
                    ),
                    SizedBox(width: 20),
                    SizedBox(
                      width: 150,
                      height: 50,
                      child: ElevatedButton(
                      onPressed: () async {
                          Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CreateAccountPage()),
                          );
                        },
                        child: Text('Create Account'),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
          if (_isLoading) CircularProgressIndicator(), // add this line
          Expanded(
            child: WebView(
              // 
              initialUrl: _url,
              javascriptMode: JavascriptMode.unrestricted,
              
              onWebViewCreated: (WebViewController controller) {
                _webViewController = controller;
              },
              onPageFinished: (url) async {
                if (url != null && (url.contains("github/callback") || url.contains("google/callback"))) {
                  // get status page
                  final statusPage = await _webViewController.currentUrl();
                  if (statusPage != null && statusPage.contains("error")) {
                    // exit webview
                    // clear all cookies and cache
                    WebView.platform.clearCookies();

                    Navigator.of(context).pop();
                    
                    // show not sucess message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Login Failed!",
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                  } else {
                    // Extract JSON data from the web page
                    final jsonString = await _webViewController.evaluateJavascript("document.body.innerText");
                    final jsonData = jsonDecode(jsonString);
                    
                    final res = jsonData.toString();
                    debugPrint(res, wrapWidth: 1024);
                    final out = res.split(" ");
                    final token = out[3].replaceAll('"', '').replaceAll('}', '').replaceAll('\n', '');
                    debugPrint("Token -> " + token, wrapWidth: 1024);
                    // save token to secure storage
                    
                    final String url2 = 'http://ridemate.deti/service-review/v1/auth/auth';
                    final Map<String, String> headers2 = {
                      'Content-Type': 'application/json',
                      'Accept': 'application/json',
                      'x-access-token': token 
                    };
                    final response3 = await http.post(Uri.parse(url2), headers: headers2);
                    if (response3.statusCode != 200) {
                        debugPrint('Token not valid', wrapWidth: 1024);
                        // go to login page
                        ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Login Failed! Please try again",
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return ;
                    }
                    await _storage.write(key: 'token', value: token);
                    WebView.platform.clearCookies();
                    // close webview
                    Navigator.of(context).pop();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => MainPage()),
                      (route) => false,
                    );
                    //  loading waiting 2 seconds with animation
                    // here

                    // show success message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Logged in successfully!",
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.green,
                      ),
                    );



                    final String url = 'http://ridemate.deti/service-review/v1/auth/info';
                    final Map<String, String> headers = {
                      'Content-Type': 'application/json',
                      'Accept': 'application/json',
                      'x-access-token': token,
                    };
                    final response = await http.post(Uri.parse(url), headers: headers);
                    debugPrint("STT -> ${response.statusCode}");
                    if (response.statusCode == 200) {
                      final responseJson = json.decode(response.body);
                      final String name = responseJson['fname'];
                      final String lname = responseJson['lname'];
                      final String email = responseJson['email'];
                      final String avatar = responseJson['avatar'];
                      final String id = responseJson['id'];



                      debugPrint("Name -> $name", wrapWidth: 1024);
                      debugPrint("Lname -> $lname", wrapWidth: 1024);
                      debugPrint("Email -> $email", wrapWidth: 1024);
                      debugPrint("Avatar -> $avatar", wrapWidth: 1024);
                      debugPrint("ID -> $id", wrapWidth: 1024);
                      
                 
                    } else {
                      debugPrint('Error: ${response.statusCode}', wrapWidth: 1024);
                    }
                    _webViewController.clearCache();
                  }
                }
                // clear cache


                if (url.contains("google") || url.contains("github")) {
                  setState(() {
                    _shouldShowLoginForm = false;
                  });
                } else {
                  setState(() {
                    _shouldShowLoginForm = true;
                  });
                }
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () async {
                // verify i am logged in
                final storage = FlutterSecureStorage();
                final String tokenKey = 'token';
                final String? token = await storage.read(key: tokenKey);
                WebView.platform.clearCookies();
                Navigator.of(context).pop();
                Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => MainPage()),
                (route) => false,
              );
              },
            ),
          ],
        ),
      ),
    );
  }
}