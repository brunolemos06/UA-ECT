import 'package:flutter/material.dart';
import 'login_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
class CreateAccountPage extends StatefulWidget {
  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final _emailController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Account'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          SizedBox(height: 16),
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Email',
            ),
          ),
          SizedBox(height: 16),
          TextField(
            controller: _firstNameController,
            decoration: InputDecoration(
              labelText: 'First Name',
            ),
          ),
          SizedBox(height: 16),
          TextField(
            controller: _lastNameController,
            decoration: InputDecoration(
              labelText: 'Last Name',
            ),
          ),
          SizedBox(height: 16),
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Password',
            ),
          ),
          SizedBox(height: 16),
          TextField(
            controller: _confirmPasswordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Confirm Password',
            ),
          ),
          SizedBox(height: 32),
          ElevatedButton(
            onPressed: () async {
              // ..
                            // Implement create account logic here
            // {
            //   "email": "email",
            //   "firstName": "name",
            //   "lastName": "name",
            //   "password": "password"
            // }

            var email = _emailController.text;
            var firstName = _firstNameController.text;
            var lastName = _lastNameController.text;
            var password = _passwordController.text;
            var confirmPassword = _confirmPasswordController.text;

            // all fields are required
            if (email.isEmpty || firstName.isEmpty || lastName.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "All fields are required",
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.red,
                ),
              );
              return;
              
            // password and confirm password must match
            } else if (password != confirmPassword) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Passwords do not match",
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.red,
                ),
              );
              return;
            }
            else {
              // create account
              final String url = 'http://ridemate.deti/service-review/v1/auth/register';
              final response = await http.post(
                Uri.parse(url),
                headers: {
                  'Content-Type': 'application/json',
                },
                body: jsonEncode({
                  "email": email,
                  "firstName": firstName,
                  "lastName": lastName,
                  "password": password
                }),
              );
              // check response
              if (response.statusCode == 201){
                  ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Account created successfully",
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              }
              else if(response.statusCode == 202){
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Account already exists",
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.orange,
                  ),
                );
              }else{
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Account creation failed!",
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            }
              // finish creating account
            },
            child: Text('Create Account'),
          ),
        ],
      ),
    );
  }
}
