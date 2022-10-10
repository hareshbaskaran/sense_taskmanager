import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sense_task/AdminView/adminpage.dart';
import 'package:sense_task/UserView/userpage.dart';
import 'LoginPage.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({Key? key, required User user})
      : _user = user,
        super(key: key);

  final User _user;

  @override
  _UserInfoScreenState createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  late User _user;
  bool _isSigningOut = false;

  Route _routeToSignInScreen() {
    return PageRouteBuilder(
      settings: RouteSettings(arguments: user),
      pageBuilder: (context, animation, secondaryAnimation) =>
      (pageview == 1) ? adminpage() : userpage(user_box),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(-1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
        Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  void initState() {
    _user = widget._user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            bottom: 20.0,
          ),
          child: Stack(
            children: <Widget>[
              (pageview == 2)
                  ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(),
                  _user.photoURL != null
                      ? ClipOval(
                    child: Material(
                      child: Image.network(
                        _user.photoURL!,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  )
                      : ClipOval(
                    child: Material(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Icon(
                          Icons.person,
                          size: 60,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  (pageview == 2)
                      ? Text(
                    textAlign: TextAlign.center,
                    '${usernamevalue_user.text}',
                    style: GoogleFonts.lato(
                        color: Colors.black,
                        fontSize:
                        MediaQuery.of(context).size.width *
                            0.075),
                  )
                      : (pageview == 1)
                      ? Text(
                    textAlign: TextAlign.center,
                    'Admin',
                    style: GoogleFonts.lato(
                        color: Colors.black,
                        fontSize:
                        MediaQuery.of(context).size.width *
                            0.075),
                  )
                      : SizedBox(),
                  SizedBox(height: 8.0),
                  Text(
                    '( ${_user.email!} )',
                    style: GoogleFonts.lato(
                      letterSpacing: 0.5,
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.3,
                  ),
                  _isSigningOut
                      ? CircularProgressIndicator(
                    valueColor:
                    AlwaysStoppedAnimation<Color>(Colors.white),
                  )
                      : ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Colors.deepPurpleAccent,
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    onPressed: () async {
                      setState(() {
                        _isSigningOut = true;
                      });
                      await signOut(context: context);
                      setState(() {
                        _isSigningOut = false;
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                loginpage(Hive_box)),
                      );
                    },
                    child: Padding(
                      padding:
                      EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: Text(
                        'Sign Out',
                        style: GoogleFonts.lato(
                          letterSpacing: 2,
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              )
                  : (pageview == 1)
                  ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Center(
                      child: Text(
                        'Hey Admin ! want To LOGOUT ?',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontSize: 24),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  _isSigningOut
                      ? CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.white),
                  )
                      : ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all(
                        Colors.deepPurpleAccent,
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    onPressed: () async {
                      setState(() {
                        passwordvalue_admin.clear();
                        usernamevalue_user.clear();
                        userlogin = false;
                        alertuser = false;
                        _isSigningOut = true;
                      });
                      await signOut(context: context);
                      setState(() {
                        _isSigningOut = false;
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                loginpage(Hive_box)),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: 8.0, bottom: 8.0),
                      child: Text(
                        'Sign Out',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),
                ],
              )
                  : Text(
                  'You are Not allowed to Use this Application! Kindly LogOut'),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: BackButton(
                    color: Colors.black,
                    onPressed: () {
                      Navigator.of(context)
                          .pushReplacement(_routeToSignInScreen());
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}