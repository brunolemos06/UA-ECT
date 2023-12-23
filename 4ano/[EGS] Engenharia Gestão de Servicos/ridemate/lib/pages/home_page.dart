import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'catalogo_page.dart';
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _destination;

  final List<String> _destinations = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final String url = 'http://ridemate.deti:5015/directions/trip/';
    final response = (await http.get(Uri.parse(url)));
    final data = json.decode(response.body);

    setState(() {
      //add all destinations to the list
      _destinations.add("All");
      for (var trip in data['msg']) {
        // if(trip['destination'] in _destinations) continue;
        if (_destinations.contains(trip['destination'])) continue;
        String destination = trip['destination'];
        _destinations.add(destination);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
      ),
      backgroundColor: Colors.grey.shade900,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 25.0,
              vertical: 30.0,
            ),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Join the ride  ',
                    style: GoogleFonts.bebasNeue(
                      fontSize: 80,
                    ),
                  ),
                  TextSpan(
                    text: ' with RIDEMATE',
                    style: GoogleFonts.bebasNeue(
                      fontSize: 55,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 10),
          // search bar ponto de partida

          SizedBox(height: 15),

          // search bar destino
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: DropdownButtonFormField<String>(
              value: _destination,
              decoration: InputDecoration(
                labelText: 'Destination',
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              style: TextStyle(color: Colors.white),
              onChanged: (newValue) {
                setState(() {
                  _destination = newValue;
                });
              },
              items: _destinations
                  .map(
                    (destination) => DropdownMenuItem(
                      value: destination,
                      child: Text(destination),
                    ),
                  )
                  .toList(),
            ),
          ),

          SizedBox(height: 5),

          Padding(
            padding: EdgeInsets.only(left: 295.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => catalogo_page(
                      pontodechegada: _destination,
                    ),
                  ),
                );
              },
              child: Text('Search'),
            ),
          ),

          SizedBox(height: 20),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Icon(
              size: 120,
              color: Colors.green,
              Icons.emoji_people_sharp,
            ),
          ),
        ],
      ),
    );
  }
}
