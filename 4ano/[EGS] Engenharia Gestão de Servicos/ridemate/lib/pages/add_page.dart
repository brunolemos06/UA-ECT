import 'dart:convert';

import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:date_field/date_field.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'login_page.dart';

class AddPage extends StatefulWidget {
  const AddPage({Key? key}) : super(key: key);

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final _id = TextEditingController();
  final _pontodepartida = TextEditingController();
  final _destination = TextEditingController();
  final _additionalInfo = TextEditingController();
  final _npassager = TextEditingController();
  late var _startdate;
  final _aditionalinfo = TextEditingController();
  int _selectedPassengerCount = 1;
  List<int> get passengerCountOptions => [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

  final _storage = FlutterSecureStorage();

  bool _arcondicionado = false;
  bool _wifi = false;
  bool _animais = false;
  bool _eat = false;

  String _owner_id = "";
  String _chat_id = "";
  String _travelchat_id = "";

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add a new travel'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 10),
              Text(
                'Add a new travel',
                style: GoogleFonts.bebasNeue(
                  fontSize: 40,
                  color: Colors.green,
                ),
              ),
              SizedBox(height: 30),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Starting point',
                ),
                controller: _pontodepartida,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter valid name';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Destination',
                ),
                controller: _destination,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter valid name';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<int>(
                value: _selectedPassengerCount,
                items: passengerCountOptions
                    .map<DropdownMenuItem<int>>((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(value.toString()),
                  );
                }).toList(),
                onChanged: (int? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedPassengerCount = newValue;
                    });
                  }
                },
              ),
              DateTimeFormField(
                decoration: const InputDecoration(
                  hintStyle: TextStyle(color: Colors.black45),
                  errorStyle: TextStyle(color: Colors.redAccent),
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.event_note),
                  labelText: 'Only time',
                ),
                mode: DateTimeFieldPickerMode.dateAndTime,
                autovalidateMode: AutovalidateMode.always,
                validator: (e) =>
                    (e?.day ?? 0) == 1 ? 'Please not the first day' : null,
                onDateSelected: (DateTime value) {
                  print(value);
                  _startdate = value;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Aditional information',
                ),
                controller: _additionalInfo,
                // can be empty
              ),
              SizedBox(height: 30),
              CheckboxListTile(
                title: const Text('Allow animals'),
                secondary: const Icon(Icons.adb),
                autofocus: false,
                activeColor: Colors.green,
                checkColor: Colors.white,
                selected: _animais,
                value: _animais,
                onChanged: (animais) {
                  setState(() {
                    _animais = animais!;
                  });
                },
              ),
              CheckboxListTile(
                title: const Text('Allow to eat'),
                secondary: const Icon(Icons.fastfood_sharp),
                autofocus: false,
                activeColor: Colors.green,
                checkColor: Colors.white,
                selected: _eat,
                value: _eat,
                onChanged: (eat) {
                  setState(() {
                    _eat = eat!;
                  });
                },
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final String tokenKey = 'token';
                      final String? token = await _storage.read(key: tokenKey);

                      if (token != null) {
                        // Perform API request with token here

                        final String url =
                            'http://ridemate.deti/service-review/v1/auth/info';
                        final String url2 =
                            'http://ridemate.deti/service-review/v1/auth/auth';
                        final Map<String, String> headers = {
                          'Content-Type': 'application/json',
                          'Accept': 'application/json',
                          'x-access-token': token
                        };
                        final response3 =
                            await http.post(Uri.parse(url2), headers: headers);
                        if (response3.statusCode != 200) {
                          debugPrint('Token not valid', wrapWidth: 1024);
                          // go to login page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()),
                          );
                          return;
                        }
                        final response =
                            await http.post(Uri.parse(url), headers: headers);

                        if (response.statusCode == 200) {
                          final responseJson = json.decode(response.body);
                          debugPrint('Response: ${response.body}',
                              wrapWidth: 1024);
                          final String name = responseJson['fname'];
                          final String lname = responseJson['lname'];
                          final String email = responseJson['email'];
                          final String id = responseJson['id'];

                          // get id for reviews
                          final String url =
                              'http://ridemate.deti/service-review/v1/auth/fetchdata';
                          final responsefetch = await http.post(
                            Uri.parse(url),
                            headers: {
                              'Content-Type': 'application/json',
                            },
                            body: jsonEncode({
                              "auth_id": id,
                              "email": email,
                            }),
                          );

                          debugPrint('Response: ${responsefetch.body}',
                              wrapWidth: 1024);
                          if (responsefetch.statusCode == 200) {
                            debugPrint('Fetch success', wrapWidth: 1024);
                            final responseJson =
                                json.decode(responsefetch.body);
                            // debugPrint(responseJson.toString());
                            final String id = responseJson["trip_id"];
                            final String chat_id = responseJson["chat_id"];
                            debugPrint('ID: $id', wrapWidth: 1024);
                            setState(() {
                              _owner_id = id.toString();
                              _chat_id = chat_id.toString();
                            });
                          } else {
                            debugPrint('Fetch fail', wrapWidth: 1024);
                          }
                          // .
                        }
                      }
                      debugPrint('Validated!');
                      debugPrint(_owner_id);
                      debugPrint("owner_id");
                      final String url = 'http://ridemate.deti/trip/';
                      final response = await http.post(
                        Uri.parse(url),
                        headers: {
                          'Content-Type': 'application/json',
                        },
                        body: jsonEncode({
                          "id": _id.text,
                          "origin": _pontodepartida.text,
                          "destination": _destination.text,
                          "available_sits": _selectedPassengerCount,
                          "starting_date": _startdate == null
                              ? null
                              : _startdate.toIso8601String(),
                          "owner_id": _owner_id
                        }),
                      );

                      if (response.statusCode == 201) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Trip created successfully",
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.green,
                          ),
                        );

                        // create chat
                        final String url =
                            'http://ridemate.deti/service-review/v1/new_conversation?friendly_name=$_owner_id';
                        final response = await http.post(
                          Uri.parse(url),
                        );
                        if (response.statusCode == 200) {
                          final responseJson = json.decode(response.body);
                          setState(() {
                            _travelchat_id = responseJson["friendly_name"];
                          });
                          debugPrint('FNAME:: ${_travelchat_id}',
                              wrapWidth: 1024);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Chat created successfully",
                                style: TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Colors.green,
                            ),
                          );
                          // update conversation
                          final String url =
                              'http://ridemate.deti/service-review/v1/conversations?f_name=$_travelchat_id&member=$_chat_id';

                          final response2 = await http.post(
                            Uri.parse(url),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Chat creation failed!",
                                style: TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Trip creation failed!",
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                  child: const Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
