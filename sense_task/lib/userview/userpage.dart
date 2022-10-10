import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:rounded_expansion_tile/rounded_expansion_tile.dart';
import 'package:sense_task/Services/firebase_crud.dart';
import 'package:sense_task/UserInfo.dart';

import '../../LoginPage.dart';
import '../../adminview/adminpage.dart';
import '../adminview/AssignTask_Admin.dart';
String user_hive="";
Box<dynamic> user_box = Hive.box('myBox');
int snaplength = 2;
bool drawer = false;
int status = 0;
String tasktype = 'All Tasks';
User? fac;
Color bb = Color(0xFFADA4A5);
Color b = Color(0xFF817B7C);
int _selectedIndexuser = 0;
int assignedtasks = 0;

class userpage extends StatefulWidget {
  late final Box<dynamic> box;
  userpage(this.box);

  @override
  State<userpage> createState() => _userpageState();
}

class _userpageState extends State<userpage> {
  @override
  void initstate(){
    user_box=widget.box;
    user_box.get('user');
    super.initState();
  }
  late Box box1;
  @override
  Widget build(BuildContext context) {
    setState(() {
      user_hive=user_box.get('user');
    });
    void _onItemTapped(int index) {
      setState(() {
        _selectedIndexuser = index;
        print('index is ');
        print(_selectedIndexuser);
      });
    }

    return Scaffold(
        body: SafeArea(
            child: Container(
      constraints: BoxConstraints.expand(),
      decoration: BoxDecoration(
        image: DecorationImage(
          alignment: Alignment.topCenter,
          image: AssetImage('assets/images/bgnd.png'),

          // color: Colors.amber,
        ),
      ),
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Padding(
              padding: EdgeInsets.only(top: 10),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () async {
                        User? user = await signInWithGoogle(context: context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              settings: RouteSettings(arguments: user),
                              builder: (context) =>
                                  UserInfoScreen(user: user!)),
                        );
                      },
                      icon: Icon(Icons.menu)),
                  Text(
                    'Hello, ',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: MediaQuery.of(context).size.width * 0.06),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      '$user_hive !',
                      style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: MediaQuery.of(context).size.width * 0.052),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 8, 0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '$assignedtasks tasks waiting for you ...',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: MediaQuery.of(context).size.width * 0.04),
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.7,
            child: Divider(
              color: Colors.transparent,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
            child: Row(
              children: [
                Text(
                  'Ongoing Tasks',
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: MediaQuery.of(context).size.width * 0.045),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.3,
              decoration: new BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                border: Border.all(width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: StreamBuilder(
                    stream: UsernameQuery.UserOngoing(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: Colors.deepPurpleAccent,
                          ),
                        );
                      }
                      assignedtasks = snapshot.data!.docs.length;
                      return ListView(
                        shrinkWrap: true,
                        children: snapshot.data!.docs.map((document) {
                          return Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 8),
                            child: Dismissible(
                              key: UniqueKey(),
                              background: Container(
                                decoration: new BoxDecoration(
                                  color: Theme.of(context).errorColor,
                                  shape: BoxShape.rectangle,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.0)),
                                ),
                                child: Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 35,
                                ),
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.only(left: 20),
                                margin: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 8),
                              ),
                              secondaryBackground: Container(
                                decoration: new BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.rectangle,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.0)),
                                ),
                                child: Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 35,
                                ),
                                alignment: Alignment.centerRight,
                                padding: EdgeInsets.only(right: 20),
                                margin: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 8),
                              ),
                              onDismissed: (direction) {
                                if (direction == DismissDirection.endToStart) {
                                  setState(() {
                                    showDialog(
                                      routeSettings:
                                          RouteSettings(arguments: document),
                                      context: context,
                                      builder: (_) =>
                                          FunkyOverlayacceptdecline(accept: 1),
                                    );
                                  });
                                } else {
                                  setState(() {
                                    showDialog(
                                      routeSettings:
                                          RouteSettings(arguments: document),
                                      context: context,
                                      builder: (_) => FunkyOverlayacceptdecline(
                                        accept: 0,
                                      ),
                                    );
                                  });
                                }
                              },
                              child: Align(
                                  child: Stack(children: <Widget>[
                                Container(
                                  decoration: new BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.rectangle,
                                    border: Border.all(width: 2.0),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15.0)),
                                  ),
                                  child: Card(
                                    elevation: 0,
                                    color: Colors.white,
                                    child: RoundedExpansionTile(
                                      rotateTrailing: false,
                                      trailing: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Icon(
                                            Icons.arrow_drop_down_outlined,
                                            color: Colors.black,
                                          ),
                                        ],
                                      ),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(4)),
                                      title: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          largetext(text: document['title']),
                                          standardtext(
                                              text:
                                                  "${document['startdate']} - ${document['enddate']}",
                                              c: Colors.deepPurpleAccent),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.15),
                                                  ],
                                                ),
                                                SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.01),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(height: 20),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                standardtext(
                                                    text: 'Category :  ',
                                                    c: bb),
                                                standardtext(
                                                    text:
                                                        '${document['category']}',
                                                    c: Colors.deepPurpleAccent)
                                              ],
                                            ),
                                            SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.01),
                                            standardtext(
                                                text: 'Event Description:',
                                                c: bb),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Text(
                                                document['description'],
                                                textAlign: TextAlign.left,
                                                style: GoogleFonts.poppins(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.04),
                                              ),
                                            ),
                                            (pageview == 1)
                                                ? Column(
                                                    children: [
                                                      standardtext(
                                                          text: document[
                                                              'reason'],
                                                          c: Colors.red),
                                                    ],
                                                  )
                                                : SizedBox(
                                                    height: 0,
                                                  ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                (document['status'] == 0)
                                    ? StatusTag(Colors.black, 'Assigned')
                                    : (document['status'] == 1)
                                        ? StatusTag(Colors.green, 'Accepted')
                                        : (document['status'] == 2)
                                            ? StatusTag(
                                                Colors.redAccent, 'Rejected')
                                            : (document['status'] == 3)
                                                ? StatusTag(
                                                    Colors.deepOrangeAccent,
                                                    'Overdue')
                                                : SizedBox(),
                                Padding(
                                  padding: const EdgeInsets.only(top: 50),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.11,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.03,
                                          decoration: ShapeDecoration(
                                              color: Color(0xff555556),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.0))),
                                          child: MaterialButton(
                                            onPressed: () {},
                                            child: Text(
                                              "",
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.11,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.03,
                                          decoration: ShapeDecoration(
                                              //color: Color(0xff22C087),
                                              color: Color(0xff555556),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.0))),
                                          child: MaterialButton(
                                            onPressed: () {},
                                            child: Text(
                                              "",
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ])),
                            ),
                          );
                        }).toList(),
                      );
                    }),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
            child: Row(
              children: [
                Text(
                  'Accepted Tasks',
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: MediaQuery.of(context).size.width * 0.045),
                ),
                Spacer(),
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                      onPressed: () {}, icon: Icon(Icons.filter_alt_sharp)),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: StreamBuilder(
                stream: UsernameQuery.UserAccepted(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ListView(
                    shrinkWrap: true,
                    children: snapshot.data!.docs.map((document) {
                      return Padding(
                        padding: EdgeInsets.fromLTRB(6, 0, 6, 8),
                        child: Align(
                            child: Stack(children: <Widget>[
                          Container(
                            decoration: new BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.rectangle,
                              border: Border.all(width: 2.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0)),
                            ),
                            child: Card(
                              elevation: 0,
                              color: Colors.white,
                              child: RoundedExpansionTile(
                                rotateTrailing: false,
                                trailing: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Icon(
                                      Icons.arrow_drop_down_outlined,
                                      color: Colors.black,
                                    ),
                                  ],
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4)),
                                title: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    largetext(text: document['title']),
                                    standardtext(
                                      text:
                                          "${document['startdate']} - ${document['enddate']}",
                                      c: Colors.deepPurpleAccent,
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.15),
                                            ],
                                          ),
                                          SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.01),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 20),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          standardtext(
                                              text: 'Category :  ', c: bb),
                                          standardtext(
                                              text: '${document['category']}',
                                              c: Colors.deepPurpleAccent)
                                        ],
                                      ),
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.01),
                                      standardtext(
                                          text: 'Event Description:', c: bb),
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(
                                          document['description'],
                                          textAlign: TextAlign.left,
                                          style: GoogleFonts.poppins(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.04),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          (document['status'] == 0)
                              ? StatusTag(Colors.black, 'Assigned')
                              : (document['status'] == 1)
                                  ? StatusTag(Colors.green, 'Accepted')
                                  : (document['status'] == 2)
                                      ? StatusTag(Colors.redAccent, 'Rejected')
                                      : (document['status'] == 3)
                                          ? StatusTag(Colors.deepOrangeAccent,
                                              'Overdue')
                                          : SizedBox(),
                          Padding(
                            padding: const EdgeInsets.only(top: 50),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.11,
                                    height: MediaQuery.of(context).size.height *
                                        0.03,
                                    decoration: ShapeDecoration(
                                        color: Color(0xff555556),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15.0))),
                                    child: MaterialButton(
                                      onPressed: () {},
                                      child: Text(
                                        "",
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.11,
                                    height: MediaQuery.of(context).size.height *
                                        0.03,
                                    decoration: ShapeDecoration(
                                        //color: Color(0xff22C087),
                                        color: Color(0xff555556),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15.0))),
                                    child: MaterialButton(
                                      onPressed: () {},
                                      child: Text(
                                        "",
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ])),
                      );
                    }).toList(),
                  );
                }),
          ),
        ],
      ),
    )));
  }
}

class FunkyOverlayacceptdecline extends StatefulWidget {
  int accept = 1;
  FunkyOverlayacceptdecline({required this.accept});
  @override
  State<StatefulWidget> createState() => FunkyOverlayacceptdeclineState();
}

class FunkyOverlayacceptdeclineState extends State<FunkyOverlayacceptdecline>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.elasticInOut);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    QueryDocumentSnapshot? document =
        ModalRoute.of(context)!.settings.arguments as QueryDocumentSnapshot?;
    return Center(
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: scaleAnimation,
          child: Container(
            decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0))),
            child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                    height: MediaQuery.of(context).size.height * 0.24,
                    width: MediaQuery.of(context).size.width * 0.88,
                    decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0))),
                    child: (widget.accept == 1)
                        ? Column(
                            children: [
                              Text(
                                "Do you wish to accept the task ?",
                                style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.035),
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            elevation: 5.0,
                                            shape: StadiumBorder(),
                                            primary: Colors.black),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.04,
                                              12,
                                              MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.04,
                                              12),
                                          child: Text(
                                            'No',
                                            style: GoogleFonts.lato(
                                                color: Colors.white,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.02),
                                          ),
                                        )),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            elevation: 5.0,
                                            shape: StadiumBorder(),
                                            primary: Colors.black),
                                        onPressed: () async {
                                          setState(() {
                                            status = 1;
                                          });

                                          ///todo:accept to be work
                                          if (document != null) {
                                            await FirebaseTask.updateTask(
                                              admindb: document['admin'],
                                                    categorydb:
                                                        document['category'],
                                                    titledb: document['title'],
                                                    descriptiondb:
                                                        document['description'],
                                                    startdatedb:
                                                        document['startdate'],
                                                    enddatedb:
                                                        document['enddate'],
                                                    duedatedb:
                                                        document['duedate'],
                                                    duetimedb:
                                                        document['duetime'],
                                                    facultydb:
                                                        document['faculty'],
                                                    statusdb: status,
                                                    reasondb: 'NIL',
                                                    docId: document.id)
                                                .whenComplete(
                                              () => Navigator.pop(context),
                                            );
                                            print(document['category']);
                                            print(document['title']);
                                            print(document['description']);
                                            print(document['startdate']);
                                            print(document['enddate']);
                                            print(document['duedate']);
                                            print(document['faculty']);
                                            print(document['status']);
                                            print(document['reason']);
                                            print('Accepted !');
                                          } else {
                                            print('dopcument is null');
                                          }
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.04,
                                              12,
                                              MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.04,
                                              12),
                                          child: Text(
                                            'Accept',
                                            style: GoogleFonts.lato(
                                                color: Colors.white,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.02),
                                          ),
                                        )),
                                  ),
                                ],
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              Text(
                                "Do you wish to decline the task ? ",
                                style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.035),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: 40,
                                  child: TextField(
                                    decoration: InputDecoration(
                                      fillColor: Colors.black,
                                      hintText: 'Type the reason to decline',
                                      hintStyle: GoogleFonts.poppins(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w200,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.032),
                                    ),
                                    keyboardType: TextInputType.text,
                                    maxLines: 2,
                                    cursorColor: Colors.black,
                                    controller: taskreasoncontroller,
                                    // onSubmitted: (helo) async {
                                    //   setState(() {
                                    //     status = -1;
                                    //   });
                                    //   Navigator.pop(context);
                                    // },
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            elevation: 5.0,
                                            shape: StadiumBorder(),
                                            primary: Colors.black),
                                        onPressed: () {
                                          taskreasoncontroller.clear();
                                          Navigator.pop(context);
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.04,
                                              12,
                                              MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.04,
                                              12),
                                          child: Text(
                                            'Close',
                                            style: GoogleFonts.lato(
                                                color: Colors.white,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.02),
                                          ),
                                        )),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            elevation: 5.0,
                                            shape: StadiumBorder(),
                                            primary: Colors.black),
                                        onPressed: () async {
                                          setState(() {
                                            status = 2;
                                            reason = taskreasoncontroller.text;
                                          });

                                          ///todo:accept to be work
                                          if (document != null) {
                                            await FirebaseTask.updateTask(
                                              admindb: document['admin'],
                                                    categorydb:
                                                        document['category'],
                                                    titledb: document['title'],
                                                    descriptiondb:
                                                        document['description'],
                                                    startdatedb:
                                                        document['startdate'],
                                                    enddatedb:
                                                        document['enddate'],
                                                    duedatedb:
                                                        document['duedate'],
                                                    duetimedb:
                                                        document['duetime'],
                                                    facultydb:
                                                        document['faculty'],
                                                    statusdb: status,
                                                    reasondb: reason,
                                                    docId: document.id)
                                                .whenComplete(
                                              () => Navigator.pop(context),
                                            );
                                            print(document['category']);
                                            print(document['title']);
                                            print(document['description']);
                                            print(document['startdate']);
                                            print(document['enddate']);
                                            print(document['duedate']);
                                            print(document['faculty']);
                                            print(document['status']);
                                            print(document['reason']);
                                            print('Rejected !');
                                            taskreasoncontroller.clear();
                                          }
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.04,
                                              12,
                                              MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.04,
                                              12),
                                          child: Text(
                                            'Done',
                                            style: GoogleFonts.lato(
                                                color: Colors.white,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.02),
                                          ),
                                        )),
                                  ),
                                ],
                              ),
                            ],
                          ))),
          ),
        ),
      ),
    );
  }
}
