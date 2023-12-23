import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';


import 'package:ridemate/pages/messages_page.dart';
import 'package:ridemate/pages/add_page.dart';
import 'package:ridemate/pages/home_page.dart';
import 'package:ridemate/pages/profile_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ridemate/pages/login_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key:key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late int _currentindex = 0;
  List pages = [ HomePage(),AddPage() ,ProfilePage() ,MessagePage() ];

  final _storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _currentindex = 0;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: pages[_currentindex],
      bottomNavigationBar: Container(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 7),
          child:       GNav(
            backgroundColor: Colors.transparent,
            color: Colors.white,
            activeColor: Colors.green,
            tabBackgroundColor: Colors.grey.shade800,
            gap: 3,
            onTabChange: (index) async {
                              // token
                final String tokenKey = 'token';
                final String? token = await _storage.read(key: tokenKey);
                if (index == 0){
                    setState(() {
                      _currentindex = index;
                    });
                  return;
                }
                if (token != null) {
                  // Perform API request with token here
                    
                  final String url = 'http://ridemate.deti/service-review/v1/auth/info';
                  final String url2 = 'http://ridemate.deti/service-review/v1/auth/auth';
                  final Map<String, String> headers = {
                    'Content-Type': 'application/json',
                    'Accept': 'application/json',
                    'x-access-token': token 
                  };
                  final response3 = await http.post(Uri.parse(url2), headers: headers);
                  if (response3.statusCode != 200) {
                      debugPrint('Token not valid', wrapWidth: 1024);
                      // go to login page
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    return ;
                  }
                  final response = await http.post(Uri.parse(url), headers: headers);

                  if (response.statusCode == 200) {
                    setState(() {
                      _currentindex = index;
                    });
                    debugPrint('Sucess: $token', wrapWidth: 1024);                   
                  } else {
                    debugPrint('Error: ${response.statusCode}', wrapWidth: 1024);
                  }

                  debugPrint('Token: $token', wrapWidth: 1024);
                } else {
                  debugPrint('Token not found', wrapWidth: 1024);
                  // go to login page
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                }
            },
            padding: EdgeInsets.all(16),
            tabs: const [
              GButton(
                icon: Icons.search,
                text: "Search",
              ),
              GButton(
                icon: Icons.add,
                text: "add",
              ),
              GButton(
                icon: Icons.person_outline_outlined,
                text: "Profile",
              ),
              GButton(
                icon: Icons.messenger_outline_sharp,
                text: "SMS",
              ),
            ],
          ),
        ),
      ),
    );
  }
}