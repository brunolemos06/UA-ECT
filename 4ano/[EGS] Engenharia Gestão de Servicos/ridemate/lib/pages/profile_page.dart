import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'login_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ridemate/pages/main_page.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final storage = FlutterSecureStorage();
  int _publishrating = 0;
  List<Review> _reviews = [];
  String _rating = "?";
  String _id = "";
  String _fname = "";
  String _lname = "";
  String _email = "";
  String _avatar = "";
  int _personid = -1;

  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _titleController = TextEditingController();

  String trip_id = "";
  String chat_id = "";

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  // create trip
  final List<Travel> _trips = [];
  final List<Participant> _participating = [];
  final List<Trip> _travels = [];

  String user_id = "";

  Future<void> fetchData() async {
    _trips.clear();
    _participating.clear();
    _travels.clear();
    // token
    _reviews.clear();
    debugPrint('fetching data', wrapWidth: 1024);
    final String tokenKey = 'token';
    final String? token = await storage.read(key: tokenKey);

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
        return;
      }
      final response = await http.post(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        final responseJson = json.decode(response.body);
        debugPrint('Response: ${response.body}', wrapWidth: 1024);
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

        debugPrint('Response: ${responsefetch.body}', wrapWidth: 1024);
        if (responsefetch.statusCode == 200) {
          debugPrint('Fetch success', wrapWidth: 1024);
          final responseJson = json.decode(responsefetch.body);
          final int id = responseJson["reviewid"];
          debugPrint('ID: $id', wrapWidth: 1024);
          setState(() {
            _id = id.toString();
            chat_id = responseJson['chat_id'];
          });
          // get trips for loged user
          final String url_owner = 'http://ridemate.deti/owner/';
          final response_owner = (await http.get(Uri.parse(url_owner)));
          final data = json.decode(response_owner.body);
          debugPrint("OWNER ->");
          debugPrint(data.toString());
          setState(() {
            data['msg'].forEach((k, v) {
              
              if (k == responseJson['trip_id'] && v != null) {
                for (var trip in data['msg'][k]) {
                  var trip_id = trip['id'];
                  var origin = trip['origin'];
                  var destination = trip['destination'];
                  var available_sits = trip['available_sits'];
                  var owner_id = k;
                  var starting_date = trip['starting_date'];
                  _trips.add(Travel(
                      id: trip_id,
                      origin: origin,
                      destination: destination,
                      available_sits: available_sits,
                      starting_date: starting_date,
                      owner_id: owner_id));
                }
              }
            });
          });
          debugPrint(responseJson['trip_id'].toString());
          user_id = responseJson['trip_id'];
          final String url_get_participating =
              'http://ridemate.deti/participant?trip_id=$user_id';
          final response_get_participating =
              await http.get(Uri.parse(url_get_participating));
          debugPrint(response_get_participating.body);
          final data_get_participating =
              json.decode(response_get_participating.body);
          debugPrint("PARTICIPATING");
          // debugPrint(data_get_participating.toString());
          setState(() {
            // add dict to _participating list => data_get_participating = {msg: [{id: 0e4aefcb-ab8a-415f-9731-32a1f4bd7705, pickup_location: 39.5572,-8.0317, price: 36.68, trip_id_id: 7ac6d883-aeec-42cd-a516-09bb7afd0d91}], v: true}, {id: 0e4aefcb-ab8a-415f-9731-32a1f4bd7705, pickup_location: 39.5572,-8.0317, price: 36.68, trip_id_id: 7ac6d883-aeec-42cd-a516-09bb7afd0d91}], v: true}]
            for (var i = 0; i < data_get_participating['msg'].length; i++) {
              _participating.add(Participant(trip_id : data_get_participating['msg'][i]['trip_id_id'], owner_id : data_get_participating['msg'][i]['id']));
              // _participating.add(data_get_participating['msg'][i]['trip_id_id']);
              debugPrint("OWNER IDAI: ${data_get_participating['msg'][i]['trip_id_id']}");
              debugPrint("OWNER IDAI2: ${data_get_participating['msg'][i]['id']}");


            }
          });
        } else {
          debugPrint('Fetch fail', wrapWidth: 1024);
        }
        // print _participating
        // debugPrint(_participating.toString());

        final String urlTrips = 'http://ridemate.deti/trip/';
        final responseTrips = await http.get(Uri.parse(urlTrips));
        final dataTrips = json.decode(responseTrips.body);
        debugPrint(dataTrips.toString(), wrapWidth: 1024);
        setState(() {
          for (var trip in dataTrips['msg']) {
            var origin = trip['origin'];
            var destination = trip['destination'];
            var id = trip['id'];
            var available_sits = trip['available_sits'];
            var owner_id = trip['owner_id'];
            var starting_date = trip['starting_date'];
            var info = trip['info'];
            var money = 10;
            var origin_coords = LatLng(trip['info']['origin_coords']['lat'],
                trip['info']['origin_coords']['lng']);
            var destination_coords = LatLng(
                trip['info']['destination_coords']['lat'],
                trip['info']['destination_coords']['lng']);
            List<LatLng> waypoints_coords = [];
            // for (var waypoint in trip['info']['waypoints_coords']) {
            //   waypoints_coords.add(LatLng(waypoint['lat'], waypoint['lng']));
            // }
            debugPrint(waypoints_coords.toString());
            _travels.add(Trip(
                id: id,
                origin: origin,
                destination: destination,
                available_sits: available_sits,
                starting_date: starting_date,
                owner_id: owner_id,
                money: money,
                origin_coords: origin_coords,
                destination_coords: destination_coords,
                waypoints_coords: waypoints_coords));
          }
        });

        debugPrint(_travels.toString(), wrapWidth: 1024);

        setState(() {
          _fname = name;
          _lname = lname;
          _email = email;
          try {
            final int size = responseJson['avatar'].length;
            _avatar = responseJson['avatar'];
          } catch (e) {
            _avatar = "http://www.gravatar.com/avatar/?d=mp";
          }

          debugPrint("Name    -> $_fname", wrapWidth: 1024);
          debugPrint("LName   -> $_lname", wrapWidth: 1024);
          debugPrint("Email   -> $_email", wrapWidth: 1024);
          debugPrint("Avatar  -> $_avatar", wrapWidth: 1024);
        });
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

    final response = await http.get(Uri.parse(
        'http://ridemate.deti/service-review/v1/review/rating?personid=$_id'));
    final response2 = await http.get(Uri.parse(
        'http://ridemate.deti/service-review/v1/review?personid=$_id'));

    final data = json.decode(response.body);
    final data2 = json.decode(response2.body);
    debugPrint('Response: ${response.body}', wrapWidth: 1024);
    setState(() {
      var rat = data['reviews'][0]['rating'].toString();
      // if rat = "3.15432" then _rating = "3.15"
      try {
        _rating = rat.substring(0, 4);
      } catch (e) {
        _rating = rat;
      }
      for (var review in data2["reviews"]) {
        var rating = review["rating"];
        var name = review["personid"]
            .toString(); // Replace with the name of the person who wrote the review
        var title = review["title"];
        var description = review["description"];

        _reviews.add(Review(
            rating: rating,
            name: name,
            title: title,
            description: description));
      }
    });
    // refresh page
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.login),
            onPressed: () async {
              final storage = FlutterSecureStorage();
              await storage.delete(key: 'token');

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => MainPage()),
                (route) => false,
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Logged OUT successfully!!",
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.red,
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 120,
                height: 120,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image(
                    image: NetworkImage(_avatar),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                _fname + " " + _lname,
                style: Theme.of(context).textTheme.headline5,
              ),
              const SizedBox(height: 10),
              Text(
                _email,
                style: Theme.of(context).textTheme.bodyText1,
              ),
              const SizedBox(height: 20),
              Text(
                'Number of Travels: 2',
                style: Theme.of(context).textTheme.headline6,
              ),
              // rating
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Rating: ',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    _rating,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  Icon(
                    Icons.star,
                    color: Colors.yellow,
                  ),
                ],
              ),
              // icon
              SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[600],
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _trips.length,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _trips[index].destination,
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Departure: ${_trips[index].origin}, Time: ${_trips[index].starting_date}',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          // button
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              // sizebox to separate buttons to secound button go to end of the row
                              SizedBox(
                                width: 150,
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  var owner_id = _trips[index].owner_id;
                                  debugPrint(_trips[index].id.toString());
                                  final url_delete_conversation =
                                      await http.delete(Uri.parse(
                                          'http://ridemate.deti/service-review/v1/conversations?f_name=$owner_id'));
                                  final String url =
                                      'http://ridemate.deti/trip/';
                                  final response = await http.delete(
                                      Uri.parse(url),
                                      headers: {
                                        'Content-Type': 'application/json',
                                      },
                                      body:
                                          jsonEncode({'id': _trips[index].id}));
                                  if (response.statusCode == 200) {
                                    fetchData();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          "Trip finished successfully",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          "Trip deletion failed!",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                },
                                child: Text('Finish'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[600],
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _participating.length,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    debugPrint("participating: $_participating");
                    var trip_id = "";
                    var origin = "";
                    var destination = "";
                    var date = "";
                    _travels.forEach((element) {
                      if (element.id == _participating[index].trip_id) {
                        trip_id = element.id.toString();
                        origin = element.origin;
                        destination = element.destination;
                        date = element.starting_date;
                      }
                    });
                    return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              destination,
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Departure: $origin, Time: $date",
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                // sizebox to separate buttons to secound button go to end of the row
                                SizedBox(
                                  width: 150,
                                ),
                                ElevatedButton(
                                onPressed: () async {
                                  // Show dialog with form to submit review
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Submit Review'),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TextFormField(
                                              decoration: InputDecoration(
                                                labelText: 'Title',
                                              ),
                                              controller: _titleController,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please enter a title';
                                                }
                                                return null;
                                              },
                                            ),
                                            TextFormField(
                                              decoration: InputDecoration(
                                                labelText: 'Description',
                                              ),
                                              controller:
                                                  _descriptionController,
                                              maxLines: null,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please enter a description';
                                                }
                                                return null;
                                              },
                                            ),
                                            SizedBox(height: 16),
                                            RatingBar.builder(
                                              initialRating: 0,
                                              minRating: 1,
                                              direction: Axis.horizontal,
                                              allowHalfRating: false,
                                              itemCount: 5,
                                              itemPadding: EdgeInsets.symmetric(
                                                  horizontal: 4.0),
                                              itemBuilder: (context, _) => Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                              ),
                                              onRatingUpdate: (rating) {
                                                _publishrating = rating.toInt();
                                              },
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              // Dismiss dialog
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('Cancel'),
                                          ),
                                          ElevatedButton(
                                            onPressed: () async {
                                              debugPrint(
                                                      "PAPI JOHNNNNNNNNNNNNNN",
                                                      wrapWidth: 1024);
                                              final description =
                                                  _descriptionController.text;
                                              final title =
                                                  _titleController.text;
                                              if (description.isEmpty ||
                                                  title.isEmpty) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      "Fill required!",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    backgroundColor: Colors.red,
                                                  ),
                                                );
                                                return;
                                              }
                                              // Dismiss dialog

                                              // Submit review
                                              // get owner id from trip HEREHERE
                                              debugPrint("AIIIIIIIIIIIIIIIIIIIII" + _travels[0].owner_id);
                                              var ownerid = _travels[0].owner_id;
                                              // find id in travel and return the owner id
                                              debugPrint("owner id of trip i clicled: $ownerid");
                                              final url3 =
                                                  'http://ridemate.deti/service-review/v1/review?trip_id=$ownerid';
                                              final response3 = (await http
                                                  .get(Uri.parse(url3)));
                                              debugPrint(response3.statusCode
                                                  .toString());
                                              if (response3.statusCode == 200) {
                                                final data = jsonDecode(response3.body);
                                                _personid = int.parse(data.toString());
                                                debugPrint("person id: $_personid");
                                                // post review
                                                final url = 'http://ridemate.deti/service-review/v1/review';
                                                // get title and description from form
                                                debugPrint(
                                                    "person id: $_personid",
                                                    wrapWidth: 1024);
                                                debugPrint(
                                                    "rating: $_publishrating",
                                                    wrapWidth: 1024);
                                                debugPrint(
                                                    "title: ${_titleController.text}",
                                                    wrapWidth: 1024);
                                                debugPrint(
                                                    "description: ${_descriptionController.text}",
                                                    wrapWidth: 1024);
                                                final response =
                                                    await http.post(
                                                  Uri.parse(url),
                                                  headers: <String, String>{
                                                    'Content-Type':
                                                        'application/json; charset=UTF-8',
                                                  },
                                                  body: jsonEncode(<String,
                                                      dynamic>{
                                                    'title': title,
                                                    'description': description,
                                                    'rating': int.parse(
                                                        _publishrating
                                                            .toString()),
                                                    'person_id': _personid,
                                                  }),
                                                );
                                                if (response.statusCode ==
                                                    200) {
                                                  // pop
                                                  Navigator.of(context).pop();
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        "Review submitted!",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      backgroundColor:
                                                          Colors.green,
                                                    ),
                                                  );
                                                  fetchData();
                                                } else {
                                                  // something went wrong
                                                  // pop
                                                  debugPrint(
                                                      "something went wrong",
                                                      wrapWidth: 1024);
                                                  Navigator.of(context).pop();
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        "Something went wrong with adding review!",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      backgroundColor:
                                                          Colors.red,
                                                    ),
                                                  );
                                                }
                                              } else {
                                                // something went wrong
                                                // pop
                                                debugPrint(
                                                    "something went wrong",
                                                    wrapWidth: 1024);
                                                Navigator.of(context).pop();
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      "Something went wrong!",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    backgroundColor: Colors.red,
                                                  ),
                                                );
                                              }
                                            },
                                            child: Text('Submit'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.blue),
                                ),
                                child: Text('Review'),
                              ),
                            ElevatedButton(
                              onPressed: () async {
                                final String url_delete_participant =
                                    'http://ridemate.deti/participant/';
                                final response_delete_participant =
                                    await http.delete(
                                  Uri.parse(url_delete_participant),
                                  headers: {
                                    'Content-Type': 'application/json',
                                  },
                                  body: jsonEncode({
                                    'id': user_id,
                                  }),
                                );
                                debugPrint("response_delete_participant");
                                debugPrint(response_delete_participant.body,
                                    wrapWidth: 1024);
                                if (response_delete_participant.statusCode ==
                                    200) {
                                  fetchData();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "Removed from trip successfully",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "Participant deletion failed!",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                              child: Text('Exit Trip'),
                            ),
                              ],
                            ),
                          ],
                        ));
                  },
                ),
              ),
              const SizedBox(height: 15),
              ListView.builder(
                shrinkWrap: true,
                itemCount: _reviews.length,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                            // put _reviews[index].rating.toString() number of stars
                            // others are grey
                            children: [
                              for (var i = 0; i < 5; i++)
                                if (i < _reviews[index].rating)
                                  Icon(
                                    Icons.star,
                                    color: Colors.yellow,
                                  )
                                else
                                  Icon(
                                    Icons.star,
                                    color: Colors.grey,
                                  ),
                            ]),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          _reviews[index].title,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          _reviews[index].description,
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Review {
  final int rating;
  final String name;
  final String title;
  final String description;

  Review({
    required this.rating,
    required this.name,
    required this.title,
    required this.description,
  });
}

class Travel {
  final String id;
  final String origin;
  final String destination;
  final int available_sits;
  final String starting_date;
  final String owner_id;

  Travel({
    required this.id,
    required this.origin,
    required this.destination,
    required this.available_sits,
    required this.starting_date,
    required this.owner_id,
  });
}

class Trip {
  final String id;
  final String origin;
  final String destination;
  final int available_sits;
  final String starting_date;
  final String owner_id;
  final int money;
  final LatLng origin_coords;
  final LatLng destination_coords;
  final List<LatLng> waypoints_coords;

  Trip(
      {required this.id,
      required this.origin,
      required this.destination,
      required this.available_sits,
      required this.starting_date,
      required this.owner_id,
      required this.money,
      required this.origin_coords,
      required this.destination_coords,
      required this.waypoints_coords});
}

class Participant {
  final String trip_id;
  final String owner_id;

  Participant({
    required this.trip_id,
    required this.owner_id});

}
