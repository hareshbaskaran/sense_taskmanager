import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:sense_task/adminview/admin_facultypage.dart';
import 'package:sense_task/adminview/adminpage.dart';
import 'package:sense_task/main.dart';
import 'package:sense_task/userview/userpage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
List<String> faculty_list = [
  'S.Anand',
  'J.Babu',
  'G.Balasubramani',
  'T.Devarajan',
  'A.Deepa',
  'R.Durairaj',
  'D.Gasper',
  'S.Harikrishnan',
  'S.Karthikeyan',
  'P.Narayanasamy',
  'M.Sreenivasulu',
  'E.Tamizharasan',
  'T.Yuvaraj',
];
String facultyvalue = "S.Anand";
String hive_page ="";
Box<dynamic> Hive_box = Hive.box('myBox');
bool isButtonDisabled = true;
User? user;
bool checkbox_value = false;
bool userlogin=false;
bool alertuser=false;
bool adminlogin=false;
bool alertlogin=false;
TextEditingController usernamevalue_admin = new TextEditingController();
TextEditingController passwordvalue_admin = new TextEditingController();
String username_admin = usernamevalue_admin.text;
String password_admin = passwordvalue_admin.text;
TextEditingController usernamevalue_user = new TextEditingController();
TextEditingController passwordvalue_user = new TextEditingController();
String username_user = usernamevalue_user.text;
String password_user = passwordvalue_user.text;
bool grey = true;
int pageview = 2;
final GoogleSignIn googleSignIn = GoogleSignIn();
bool isLoggedIn = false;

class Authentication {
  static SnackBar customSnackBar({required String content}) {
    return SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        content,
        style: TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
      ),
    );
  }

  static Future<FirebaseApp> initializeFirebase({
    required BuildContext context,
  }) async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => (pageview==1)?adminpage():userpage(user_box),
        ),
      );
    }

    return firebaseApp;
  }

  static Future<User?> signInWithGoogle({required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

      final GoogleSignIn googleSignIn = GoogleSignIn();

      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        try {
          final UserCredential userCredential =
              await auth.signInWithCredential(credential);

          user = userCredential.user;
        } on FirebaseAuthException catch (e) {
          if (e.code == 'account-exists-with-different-credential') {
            ScaffoldMessenger.of(context).showSnackBar(
              Authentication.customSnackBar(
                content:
                    'The account already exists with a different credential',
              ),
            );
          } else if (e.code == 'invalid-credential') {
            ScaffoldMessenger.of(context).showSnackBar(
              Authentication.customSnackBar(
                content:
                    'Error occurred while accessing credentials. Try again.',
              ),
            );
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            Authentication.customSnackBar(
              content: 'Error occurred using Google Sign In. Try again.',
            ),
          );
        }
      }


    return user;
  }

  static Future<void> signOut({required BuildContext context}) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        Authentication.customSnackBar(
          content: 'Error signing out. Try again.',
        ),
      );
    }
  }
}

class loginpage extends StatefulWidget {
  late final Box<dynamic> box;
  loginpage(this.box);
  @override
  State<loginpage> createState() => _loginpageState();
}

class _loginpageState extends State<loginpage> {
  late Box box1;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    createOpenBox();
    FutureBuilder(
      future: Authentication.initializeFirebase(context: context),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error initializing Firebase');
        } else if (snapshot.connectionState == ConnectionState.done) {
          return SizedBox();
        }
        return CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
        );
      },
    );
  }

  void createOpenBox() async {
    box1 = await Hive.openBox('myBox');
    getdata();
  }
  void getdata()async{
    if(box1.get('user')!=null){
      usernamevalue_user.text = box1.get('user');
      setState(() {
      });
    }
    pageview=box1.get('page');
    setState(() {
    });
  }
  void onLoginStatusChanged(bool isLoggedIn) {
    setState(() {
      isLoggedIn = isLoggedIn;
    });
  }
  bool searchusername(){
    for (int i = 0 ;i<faculty_list.length;i++)
      {
        if (faculty_list[i] == usernamevalue_user.text)
          return true;
      }
    return false;
  }

  var loggedIn = false;
  var firebaseAuth = FirebaseAuth.instance;
  bool grey = true;
  @override
  Widget build(BuildContext context) {
    Hive_box = widget.box;

    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FutureBuilder(
                  future: Authentication.initializeFirebase(context: context),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error initializing Firebase');
                    } else if (snapshot.connectionState == ConnectionState.done) {
                      return SizedBox();
                    }
                    return CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.black
                      ),
                    );
                  },
                ),
                Text(
                  textAlign: TextAlign.center,
                  'SENSE TASK\n MANAGEMENT',
                  style: GoogleFonts.lato(
                      color: Colors.black,
                      fontSize: MediaQuery.of(context).size.width * 0.075),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.025),
                Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.03,
                      right: MediaQuery.of(context).size.width * 0.03),
                  child: Container(
                      child:
                      Image(image: AssetImage('assets/images/loginpic.png'))),
                ),
                (pageview == 1)
                    ? Column(children: [
                  Row(
                children: [
                Padding(
                padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.08),
          child: Text('Login as Admin',
              style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontWeight: FontWeight.w300,
                  fontSize:
                  MediaQuery.of(context).size.width *
                      0.045)),
        ),
      ],
    ),
                  (adminlogin==false)?
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Center(
                            child: SingleChildScrollView(
                              child: Container(
                                width: MediaQuery.of(context)
                                    .size
                                    .width *
                                    0.7,
                                decoration: new BoxDecoration(
                                  color: Color(0xFFF7F8F8),
                                  shape: BoxShape.rectangle,
                                  border: Border.all(width: 2.0),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(15.0)),
                                ),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding:
                                      const EdgeInsets.all(8.0),
                                      child: Container(
                                        color: Colors.transparent,
                                        constraints: BoxConstraints(
                                            minHeight:
                                            MediaQuery.of(context)
                                                .size
                                                .height *
                                                0.05),
                                        child: TextField(
                                          style: GoogleFonts.poppins(
                                              color: Colors.black,
                                              fontWeight:
                                              FontWeight.w400,
                                              fontSize: MediaQuery.of(
                                                  context)
                                                  .size
                                                  .width *
                                                  0.036),
                                          cursorHeight: 20,
                                          maxLines: 1,
                                          onChanged: (_) {
                                            setState(() {});
                                          },
                                          decoration: InputDecoration(
                                            hintText:
                                            'Enter Admin Password',
                                            hintStyle: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontWeight:
                                                FontWeight.w200,
                                                fontSize: MediaQuery.of(
                                                    context)
                                                    .size
                                                    .width *
                                                    0.036),
                                            fillColor: Colors.black,
                                            border: InputBorder.none,
                                          ),
                                          cursorColor: Colors.black,
                                          controller:
                                          passwordvalue_admin,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          child: MaterialButton(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    right: 18.0),
                                child: Icon(
                                  Icons.chevron_right_outlined,
                                  color: Colors.black,
                                ),
                              ),
                              onPressed: () async {
                                if (passwordvalue_admin.text ==
                                    "Sense_Task") {
                                  setState(() {
                                    adminlogin = true;
                                  });
                                } else
                                  setState(() {
                                    alertlogin = true;
                                  });
                              }),
                          width:
                          MediaQuery.of(context).size.width * 0.1,
                        )
                      ],
                    ),
                  )
                      : Padding(
                    padding: const EdgeInsets.all(20.0),
                    child:  FutureBuilder(
                      future: Authentication.initializeFirebase(context: context),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text('Error initializing Firebase');
                        } else if (snapshot.connectionState == ConnectionState.done) {
                          return _googleSignInButton();
                        }
                        return CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.black
                          ),
                        );
                      },
                    ),
                  ),
                  (alertlogin==true&&adminlogin==false)?
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      'Invalid Password ! Try again !',
                      style: GoogleFonts.poppins(
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                          fontSize:
                          MediaQuery.of(context).size.width *
                              0.036),
                    ),
                  ):SizedBox(),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.1),
                        InkWell(
                          child: Text(
                            'Tap here, To Login as User',
                            style: GoogleFonts.lato(
                                decoration: TextDecoration.underline,
                                color: Colors.deepPurpleAccent,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.04),
                          ),
                          onTap: () {
                            setState(() {
                              alertlogin=false;
                              adminlogin=false;
                              passwordvalue_admin.clear();
                              pageview = 2;
                            });
                          },
                        ),
                      ])
                    : (pageview == 2)
                        ? Column(children: [
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          left:
                          MediaQuery.of(context).size.width * 0.08,
                        ),
                        child: Text('Login as User',
                            style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontWeight: FontWeight.w300,
                                fontSize:
                                MediaQuery.of(context).size.width *
                                    0.045)),
                      ),
                    ],
                  ),
                  (userlogin==false)?
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Center(
                            child: SingleChildScrollView(
                              child: Container(
                                width: MediaQuery.of(context)
                                    .size
                                    .width *
                                    0.7,
                                decoration: new BoxDecoration(
                                  color: Color(0xFFF7F8F8),
                                  shape: BoxShape.rectangle,
                                  border: Border.all(width: 2.0),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(15.0)),
                                ),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding:
                                      const EdgeInsets.all(
                                          8.0),
                                      child: Container(
                                        color: Colors.transparent,
                                        constraints: BoxConstraints(
                                            minHeight:
                                            MediaQuery.of(
                                                context)
                                                .size
                                                .height *
                                                0.05),
                                        child: TextField(
                                          style: GoogleFonts.poppins(
                                              color: Colors.black,
                                              fontWeight:
                                              FontWeight.w400,
                                              fontSize: MediaQuery.of(
                                                  context)
                                                  .size
                                                  .width *
                                                  0.036),
                                          cursorHeight: 20,
                                          maxLines: 1,
                                          onChanged: (_) {
                                            setState(() {});
                                          },
                                          decoration:
                                          InputDecoration(
                                            hintText:
                                            "Enter Your Name",
                                            hintStyle: GoogleFonts.poppins(
                                                color:
                                                Colors.black,
                                                fontWeight:
                                                FontWeight
                                                    .w200,
                                                fontSize: MediaQuery.of(
                                                    context)
                                                    .size
                                                    .width *
                                                    0.036),
                                            fillColor:
                                            Colors.black,
                                            border:
                                            InputBorder.none,
                                          ),
                                          cursorColor:
                                          Colors.black,
                                          controller:
                                          usernamevalue_user,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          child: MaterialButton(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  right: 10.0),
                              child: Icon(
                                Icons.chevron_right_rounded,
                                color: Colors.black,
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                if (searchusername()) {
                                  userlogin = true;
                                } else {
                                  alertuser = true;
                                }
                              });
                            },
                          ),
                          width:
                          MediaQuery.of(context).size.width *
                              0.1,
                        )
                      ],
                    ),
                  )
                      : Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child:  FutureBuilder(
                        future: Authentication.initializeFirebase(context: context),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Text('Error initializing Firebase');
                          } else if (snapshot.connectionState == ConnectionState.done) {
                            return _googleSignInButton();
                          }
                          return CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.black
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  (alertuser==true &&userlogin==false)?
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      'No Such User Exists !',
                      style: GoogleFonts.poppins(
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                          fontSize:
                          MediaQuery.of(context).size.width *
                              0.036),
                    ),
                  )//
                      : SizedBox(),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.1),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: InkWell(
                      child: Text(
                        'Tap here, to Login as admin',
                        style: GoogleFonts.lato(
                            decoration: TextDecoration.underline,
                            color: Colors.deepPurpleAccent,
                            fontSize:
                            MediaQuery.of(context).size.width *
                                0.04),
                      ),
                                onTap: () {
                                  setState(() {
                                    usernamevalue_user.clear();
                                    userlogin=false;
                                    alertuser=false;
                                    pageview = 1;
                                  });
                                },
                              ),
                            ),
                          ])
                        : Text('nothing')
              ],
            ),
          ),
      ),
        ));
  }

  Widget _googleSignInButton() {
    bool _isSigningIn = false;
    bool hasInternet = false;
    return Container(
      height: 60,
      width: 340,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: MaterialButton(
        splashColor: Colors.white,
        color: Colors.black,
        onPressed: () async {
          if(pageview==2){
            box1.put('user',usernamevalue_user.text);
            setState(() {
            });
          }
          setState(() {
            _isSigningIn = true;
          });
          hasInternet = await InternetConnectionChecker().hasConnection;
              User? user =await Authentication.signInWithGoogle(context: context).then((result) {
                if(User!=null) {
                  (pageview==2)?box1.put('page',2):(pageview==1)?box1.put('page',1):box1.put('page',0);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) {
                          return (pageview == 2)
                              ? userpage(user_box)
                              : (pageview == 1)
                              ? adminpage()
                              : userpage(user_box);
                        }
                    ),

                  );
                }
              });
   /*      else
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  ' No Internet Connection !',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                  ),
                ),
                duration: const Duration(seconds: 3),
              ),
            );*/
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        highlightElevation: 0,
        height: 60,
        minWidth: 320,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  alignment: Alignment.centerLeft,
                  height: 38,
                  width: 38,
                  child:
                  Image(image: AssetImage('assets/images/googlelogo.png'))),
              SizedBox(
                width: 20,
              ),
              Text(
                'Sign in with Google',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: MediaQuery.of(context).size.width * 0.045),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

///todo:implement this in onpressed else in login page
class ErrorCred extends StatelessWidget {
  const ErrorCred({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Text(
        "The given Credentials are wrong",
        style: TextStyle(
          color: Colors.red,
          fontSize: 12,
        ),
      ),
    );
  }
}

SnackBar customSnackBar({required String content}) {
  return SnackBar(
    backgroundColor: Colors.black,
    content: Text(
      content,
      style: TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
    ),
  );
}

Future<void> signOut({required BuildContext context}) async {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  try {
    await FirebaseAuth.instance.signOut();
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      customSnackBar(
        content: 'Error signing out. Try again.',
      ),
    );
  }
}
