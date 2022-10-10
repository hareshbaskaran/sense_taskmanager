import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:sense_task/LoginPage.dart';
import 'package:sense_task/adminview/AssignTask_Admin.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sense_task/UserInfo.dart';
import 'package:sense_task/adminview/adminpage.dart';
import 'package:sense_task/userview/userpage.dart';

import 'package:shared_preferences/shared_preferences.dart';

final tabsList = ['All Tasks', 'Assigned', 'Accepted', 'Rejected', 'Overdue'];
//
class SizeConfig {
  static MediaQueryData _mediaQueryData = const MediaQueryData();
  static double screenWidth = 0;
  static double screenHeight = 0;
  static double blockSizeHorizontal = 0;
  static double blockSizeVertical = 0;
  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;
  }
}

bool already_sign_in = false;
CheckloggedIn() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int? intValue = prefs.getInt('intValue');
  if (intValue == 1) {
    already_sign_in = true;
    print("true");
  } else {
    already_sign_in = false;
    print("false");
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Box<dynamic> Hive_box = await Hive.openBox('myBox');
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await CheckloggedIn();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          secondaryHeaderColor: Colors.black,
          splashColor: Colors.black,
        ),
        debugShowCheckedModeBanner: false,
        home: already_sign_in?adminpage():loginpage(Hive_box)
        //already_sign_in?(pageview==1)?adminpage():(pageview==2)?userpage(user_box):loginpage(Hive_box):loginpage(Hive_box)
        );
  }
}
