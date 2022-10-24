import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'Models/Constants.dart';
import 'main.dart';
class NotificationFirebase extends StatefulWidget {
  @override
  _NotificationFirebaseState createState() => _NotificationFirebaseState();
}

class _NotificationFirebaseState extends State<NotificationFirebase> {
  int _counter = 0;

  late TextEditingController _textToken;
  late TextEditingController _textSetToken;
  late TextEditingController _textTitle;
  late TextEditingController _textBody;

  @override
  void dispose() {
    _textToken.dispose();
    _textTitle.dispose();
    _textBody.dispose();
    _textSetToken.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();

    _textToken = TextEditingController();
    _textSetToken = TextEditingController();
    _textTitle = TextEditingController();
    _textBody = TextEditingController();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification!.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                  channel.id, channel.name, channel.description,
                  color: Colors.blue,
                  playSound: true,
                  icon: '@mipmap/ic_launcher'),
            ));
      }
    });
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Notifications'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 50),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textToken,
                      decoration: InputDecoration(
                          enabled: false,
                          labelText: "My Token for this Device"),
                    ),
                  ),
                  SizedBox(width: 8),
                  Container(
                    width: 50,
                    height: 50,
                    child: IconButton(
                      icon: Icon(Icons.copy),
                      onPressed: () {
                        Clipboard.setData(
                            new ClipboardData(text: _textToken.text));
                      },
                    ),
                  )
                ],
              ),
              SizedBox(height: 8),
              TextButton(
                onPressed: () async {
                  _textToken.text = await token();
                },
                child: Text('Get Token'),
              ),
              TextField(
                controller: _textTitle,
                decoration: InputDecoration(labelText: "Enter Title"),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _textBody,
                decoration: InputDecoration(labelText: "Enter Body"),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _textSetToken,
                decoration: InputDecoration(labelText: "Enter Token"),
              ),
              SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        if (_textSetToken.text.isNotEmpty && check()) {
                          pushNotificationsSpecificDevice(
                            title: _textTitle.text,
                            body: _textBody.text,
                            token: _textSetToken.text,
                          );
                        }
                      },
                      child: Text('Send Notification for specific Device'),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        if (check())
                          pushNotificationsGroupDevice(
                            title: _textTitle.text,
                            body: _textBody.text,
                          );
                      },
                      child: Text('Send Notification Group Device'),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        if (check()) {
                          pushNotificationsAllUsers(
                            title: _textTitle.text,
                            body: _textBody.text,
                          );
                        }
                      },
                      child: Text('Send Notification All Devices'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: showNotification,
            tooltip: 'Increment',
            child: Icon(Icons.add),
          ),
          SizedBox(
            width: 16,
          ),
          FloatingActionButton(
            onPressed: () async {
              if (check()) {
                pushNotificationsAllUsers(
                  title: _textTitle.text,
                  body: _textBody.text,
                );
              }
            },
            tooltip: 'Push Notifications',
            child: Icon(Icons.send),
          )
        ],
      ),
    );
  }

  Future<bool> pushNotificationsSpecificDevice({
    required String token,
    required String title,
    required String body,
  }) async {
    String dataNotifications = '{ "to" : "$token",'
        ' "notification" : {'
        ' "title":"$title",'
        '"body":"$body"'
        ' }'
        ' }';

    await http.post(
      Uri.parse(Constants.BASE_URL),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key= ${Constants.KEY_SERVER}',
      },
      body: dataNotifications,
    );
    return true;
  }

  Future<bool> pushNotificationsGroupDevice({
    required String title,
    required String body,
  }) async {
    String dataNotifications = '{'
        '"operation": "create",'
        '"notification_key_name": "appUser-testUser",'
        '"registration_ids":["dV5pjB2aS_KAE1CuCrBPRG:APA91bHDjwDJbEBYVYtaBXdJ9hNHt2yNnoNhGU5k16AMvGcCFTAdK7h9GHWUu8rlthR8oQXbFJi5EBQQ1okFOZJC94m98manc6Or6CZr5TTDB-B8zzlMT1RrLzPakDg2kvM0Mir460bG","d1Kudv_ERRSY4ELxKjss-c:APA91bFMm-S56N35a6u8WAMiV88I3fNXKvhcLa8KbMrbjG7CdiVVCikJd3dyc0SgBkqlm3bsAJpU7rueX5esTYjOhILAUUNI8JXXZXDNXfWzi-wOWerYBfHFNR1JgL2N6c41iNJi8vaB"],'
        '"notification" : {'
        '"title":"$title",'
        '"body":"$body"'
        ' }'
        ' }';

    var response= await http.post(
      Uri.parse(Constants.BASE_URL),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key= ${Constants.KEY_SERVER}',
        'project_id': "${Constants.SENDER_ID}"
      },
      body: dataNotifications,
    );

    print(response.body.toString());

    return true;
  }

  Future<bool> pushNotificationsAllUsers({
    required String title,
    required String body,
  }) async {
    // FirebaseMessaging.instance.subscribeToTopic("myTopic1");

    String dataNotifications = '{ '
        ' "to" : "/topics/myTopic1" , '
        ' "notification" : {'
        ' "title":"$title" , '
        ' "body":"$body" '
        ' } '
        ' } ';

    var response = await http.post(
      Uri.parse(Constants.BASE_URL),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key= ${Constants.KEY_SERVER}',
      },
      body: dataNotifications,
    );
    print(response.body.toString());
    return true;
  }

  Future<String> token() async {
    return await FirebaseMessaging.instance.getToken() ?? "";
  }

  void showNotification() {
    setState(() {
      _counter++;
    });
    flutterLocalNotificationsPlugin.show(
        0,
        "Testing $_counter",
        "How you doin ?",
        NotificationDetails(
            android: AndroidNotificationDetails(
                channel.id, channel.name, channel.description,
                importance: Importance.high,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher')));
  }

  bool check() {
    if (_textTitle.text.isNotEmpty && _textBody.text.isNotEmpty) {
      return true;
    }
    return false;
  }
}