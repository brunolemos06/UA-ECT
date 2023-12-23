import 'package:flutter/material.dart';
import 'login_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ridemate/pages/main_page.dart';

class Message {
  String sender;
  String conversation;
  String conversation_name;
  String message;
  String name;

  Message({
    required this.sender,
    required this.conversation,
    required this.conversation_name,
    required this.name,
    required this.message,
  });
}

final List<Message> _messages = [];
String chatid = '';
String c_name = '';
String name = '';
String trip_name = '';

class MessagePage extends StatefulWidget {
  const MessagePage({Key? key}) : super(key: key);

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  bool loading = true;
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final storage = FlutterSecureStorage();
    // token
    final String tokenKey = 'token';
    final String? token = await storage.read(key: tokenKey);
    if (token != null) {
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
      // pop up
      if (response.statusCode == 200) {
        final responseJson = json.decode(response.body);
        debugPrint('Response: ${response.body}', wrapWidth: 1024);
        name = responseJson['fname'];
        final String lname = responseJson['lname'];
        final String email = responseJson['email'];
        final String id = responseJson['id'];

        // get id for chat
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
          final responseJson = json.decode(responsefetch.body);
          chatid = responseJson['chat_id'];
          final responsechat = await http.get(Uri.parse(
              'http://ridemate.deti/service-review/v1/conversations?author=$chatid'));
          if (responsechat.statusCode == 200) {
            final responseJson = json.decode(responsechat.body);
            debugPrint('Response: ${responsechat.body}', wrapWidth: 1024);
            //get the messages array in the jsonresponse;
            if (responseJson.length > 0) {
              final messages = responseJson[0]['messages'];
              debugPrint('Messages: ${messages.length}', wrapWidth: 1024);
              final c_id = responseJson[0]['id'];
              c_name = responseJson[0]['friendly_name'];
              //add the messages to the list
              _messages.clear();
              _messages.add(Message(
                  sender: 'RideMate',
                  conversation: c_id,
                  conversation_name: c_name,
                  name: 'RideMate',
                  message: 'Welcome to RideMate!'));
              setState(() {
                for (var message in messages) {
                  _messages.insert(
                      0,
                      Message(
                          sender: message['author'],
                          conversation: c_id,
                          conversation_name: c_name,
                          name: name,
                          message: message['body']));
                }
                loading = false;
              });
            }
          }
          //request trip details
          final String url = 'http://ridemate.deti/trip?id=$c_name';
          final response = await http.get(Uri.parse(url));
          final data = json.decode(response.body);
          trip_name =
              data['msg'][0]['origin'] + ' to ' + data['msg'][0]['destination'];

          debugPrint('tripname: ${trip_name}', wrapWidth: 1024);
        } else {
          setState(() {
            loading = false;
          });
        }

        //request to get chat to composer
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    //set of tuples
    Set<String> uniqueSenders = Set<String>();

// Loop through messages and add unique senders to the set
    for (var message in _messages) {
      if (!uniqueSenders.contains(message.conversation)) {
        uniqueSenders.add(message.conversation);
      }
    }
    return MaterialApp(
      home: loading
          ? LoadingScreen()
          : Scaffold(
              backgroundColor: const Color(0x808080),
              appBar: AppBar(
                title: const Text("Messages"),
                backgroundColor: Colors.grey[800],
                // text color white
                foregroundColor: Colors.white,
              ),
              body: ListView.builder(
                itemCount: uniqueSenders.length,
                itemBuilder: (context, index) {
                  // Get the sender at the current index
                  String sender = uniqueSenders.elementAt(index);

                  // Find the first message with the current sender
                  Message firstMessage = _messages
                      .firstWhere((message) => message.conversation == sender);

                  return ListTile(
                    title: Container(
                      child: Text(
                        trip_name,
                        style: TextStyle(
                          color:
                              Colors.green, // set the text color of the title
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    subtitle: Text(firstMessage.message,
                        style: TextStyle(
                          color: Colors
                              .white, // set the text color of the subtitle
                        )),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MessageConversationPage(
                              sender: firstMessage.sender, messages: _messages),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
    );
  }
}

class MessageConversationPage extends StatefulWidget {
  final String sender;

  const MessageConversationPage(
      {Key? key, required this.sender, required List<Message> messages})
      : super(key: key);

  @override
  State<MessageConversationPage> createState() =>
      _MessageConversationPageState();
}

class _MessageConversationPageState extends State<MessageConversationPage> {
  @override
  Widget build(BuildContext context) {
    final conversation_id = _messages[0].conversation;

    return Scaffold(
      backgroundColor: const Color(0x808080),
      appBar: AppBar(
        title: Text(trip_name),
        backgroundColor: Colors.grey[800],
      ),
      body: ListView.builder(
        reverse: true,
        itemCount: _messages.length,
        itemBuilder: (context, index) {
          final message = _messages[index];
          final isSender = message.sender == chatid;
          final textAlign = isSender ? TextAlign.start : TextAlign.end;
          return ListTile(
            title: Align(
              alignment:
                  isSender ? Alignment.centerRight : Alignment.centerLeft,
              child: Text(message.message,
                  style: TextStyle(
                    color: Colors.white, // Replace with desired color
                  ),
                  textAlign: textAlign),
            ),
            subtitle: Align(
              alignment:
                  isSender ? Alignment.centerRight : Alignment.centerLeft,
              child: Text(
                message.name,
                style: TextStyle(
                  color: Colors.green, // Replace with desired color
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color(0x828282),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  decoration: const InputDecoration(
                    hintText: "Type a message...",
                    hintStyle: TextStyle(
                      color: Colors.white70,
                    ),
                    // when the textfield is focused
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.green,
                      ),
                    ),
                  ),
                  onFieldSubmitted: (value) async {
                    setState(() {
                      _messages.insert(
                          0,
                          Message(
                            sender: chatid,
                            conversation: conversation_id,
                            conversation_name: c_name,
                            name: name,
                            message: value,
                          ));
                    });

                    final response = await http.post(Uri.parse(
                        'http://ridemate.deti/service-review/v1/conversations?author=$chatid&f_name=$c_name&message=$value'));
                    if (response.statusCode == 200) {
                      debugPrint('Response send: ${response.body}',
                          wrapWidth: 1024);
                    }
                  },
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                //field submitted
                debugPrint('mensagem enviada', wrapWidth: 1024);
              },
              icon: const Icon(Icons.send),
              color: Colors.green,
            ),
          ],
        ),
      ),
    );
  }
}

// Define the loading screen widget
class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
        ),
      ),
    );
  }
}
