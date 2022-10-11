import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:rounded_expansion_tile/rounded_expansion_tile.dart';
import 'package:sense_task/Services/firebase_crud.dart';
import 'package:sense_task/UserInfo.dart';

import '../../LoginPage.dart';
import '../../adminview/adminpage.dart';
import '../adminview/AssignTask_Admin.dart';

String user_hive = "";
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
int ctu = 0;

class userpage extends StatefulWidget {
  late final Box<dynamic> box;
  userpage(this.box);

  @override
  State<userpage> createState() => _userpageState();
}

class _userpageState extends State<userpage> {
  @override
  void initstate() {
    user_box = widget.box;
    user_box.get('user');
    super.initState();
  }

  late Box box1;
  @override
  Widget build(BuildContext context) {
    setState(() {
      user_hive = user_box.get('user');
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
            child: RefreshIndicator(
      color: Colors.black,
      onRefresh: () async {
        await Future.delayed(Duration(seconds: 1));
        setState(() {
          ctu += 1;
        });
      },
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
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    IconButton(
                        onPressed: () async {
                          User? user = await Authentication.signInWithGoogle(
                              context: context);
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
                            fontSize:
                                MediaQuery.of(context).size.width * 0.052),
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
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(1, 2), // changes position of shadow
                    ),
                  ],
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
                              color: Colors.black,
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
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.3),
                                        spreadRadius: 1,
                                        blurRadius: 7,
                                        offset: Offset(
                                            1, 2), // changes position of shadow
                                      ),
                                    ],
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
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.3),
                                        spreadRadius: 1,
                                        blurRadius: 7,
                                        offset: Offset(
                                            1, 2), // changes position of shadow
                                      ),
                                    ],
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
                                  if (direction ==
                                      DismissDirection.endToStart) {
                                    setState(() {
                                      showDialog(
                                        routeSettings:
                                            RouteSettings(arguments: document),
                                        context: context,
                                        builder: (_) =>
                                            FunkyOverlayacceptdecline(
                                                accept: 1),
                                      );
                                    });
                                  } else {
                                    setState(() {
                                      showDialog(
                                        routeSettings:
                                            RouteSettings(arguments: document),
                                        context: context,
                                        builder: (_) =>
                                            FunkyOverlayacceptdecline(
                                          accept: 0,
                                        ),
                                      );
                                    });
                                  }
                                  setState(() {});
                                },
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(6, 0, 6, 8),
                                  child: Align(
                                      child: Stack(children: <Widget>[
                                    Container(
                                      decoration: new BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.1),
                                            spreadRadius: 1,
                                            blurRadius: 3,
                                            offset: Offset(1,
                                                2), // changes position of shadow
                                          ),
                                        ],
                                        color: Colors.white,
                                        shape: BoxShape.rectangle,
                                        border: Border.all(width: 2.0),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15.0)),
                                      ),
                                      child: Card(
                                        elevation: 0,
                                        color: Colors.white,
                                        child: RoundedExpansionTile(
                                            // onTap: () {
                                            //   expanded = !expanded;
                                            // },
                                            rotateTrailing: false,
                                            trailing: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Icon(
                                                  Icons
                                                      .arrow_drop_down_outlined,
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
                                                Row(
                                                  children: [
                                                    // Padding(
                                                    //   padding: EdgeInsets.fromLTRB(
                                                    //       0, 25, 5, 0),
                                                    //   child: Icon(
                                                    //     Icons.more_outlined,
                                                    //     color: Colors.black,
                                                    //   ),
                                                    // ),
                                                    // Flexible(
                                                    //        child: Container(
                                                    //          padding:
                                                    //              EdgeInsets.fromLTRB(
                                                    //                  0, 25, 15, 0),
                                                    //          child: Text(
                                                    //            document['category'],
                                                    //            overflow:
                                                    //                TextOverflow.ellipsis,
                                                    //            style: GoogleFonts.poppins(
                                                    //                fontWeight:
                                                    //                    FontWeight.w500,
                                                    //                color: Colors.black,
                                                    //                fontSize: MediaQuery.of(
                                                    //                            context)
                                                    //                        .size
                                                    //                        .width *
                                                    //                    0.04),
                                                    //          ),
                                                    //        ),
                                                    //      )
                                                    Container(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              0, 25, 0, 0),
                                                      constraints: BoxConstraints(
                                                          maxWidth: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.6),
                                                      child: Text(
                                                        document['category'],
                                                        style: GoogleFonts.poppins(
                                                            fontWeight:
                                                                FontWeight.w300,
                                                            color: Colors.black,
                                                            fontSize: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.043),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                Container(
                                                  constraints: BoxConstraints(
                                                      maxWidth:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.6),
                                                  child: Text(
                                                    document['title'],
                                                    style: GoogleFonts.poppins(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black,
                                                        fontSize: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.04),
                                                  ),
                                                ),
                                                if (document['duedate'] != '')
                                                  Container(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            0, 5, 0, 0),
                                                    child: Text(
                                                      "Due on : " +
                                                          "${document['duedate']},  ${document['duetime']}",
                                                      textAlign: TextAlign.left,
                                                      style: GoogleFonts.poppins(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.035),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                            children: [
                                              Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 15.0),
                                                      child: Text(
                                                        "Description :",
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: GoogleFonts.poppins(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.035),
                                                      ),
                                                    ),
                                                    Container(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              15, 5, 0, 0),
                                                      constraints: BoxConstraints(
                                                          maxWidth: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.8),
                                                      child: Text(
                                                        '        ' +
                                                            document[
                                                                'description'],
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: GoogleFonts.poppins(
                                                            color: Colors.black,
                                                            fontSize: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.035),
                                                      ),
                                                    ),
                                                    (document['startdate'] !=
                                                                '' &&
                                                            document[
                                                                    'enddate'] !=
                                                                '')
                                                        ? Container(
                                                            padding: EdgeInsets
                                                                .fromLTRB(15, 5,
                                                                    0, 0),
                                                            child: Text(
                                                              'Dates : ${document['startdate']} - ${document['enddate']}',
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: GoogleFonts.poppins(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.035),
                                                            ),
                                                          )
                                                        : (document['startdate'] !=
                                                                    '' ||
                                                                document[
                                                                        'enddate'] !=
                                                                    '')
                                                            ? Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                    (document['startdate'] !=
                                                                            '')
                                                                        ? Container(
                                                                            padding: EdgeInsets.fromLTRB(
                                                                                15,
                                                                                5,
                                                                                0,
                                                                                0),
                                                                            child:
                                                                                Text(
                                                                              'Event Starts on ${document['startdate']}',
                                                                              textAlign: TextAlign.left,
                                                                              style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.w600, fontSize: MediaQuery.of(context).size.width * 0.035),
                                                                            ),
                                                                          )
                                                                        : (document['enddate'] !=
                                                                                '')
                                                                            ? Container(
                                                                                padding: EdgeInsets.fromLTRB(15, 5, 0, 0),
                                                                                child: Text(
                                                                                  'Event Ends on ${document['enddate']}',
                                                                                  textAlign: TextAlign.left,
                                                                                  style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.w600, fontSize: MediaQuery.of(context).size.width * 0.035),
                                                                                ),
                                                                              )
                                                                            : SizedBox(
                                                                                height: 0,
                                                                                width: 0,
                                                                              )
                                                                  ])
                                                            : SizedBox()
                                                  ])
                                            ]),
                                      ),
                                    ),
                                    (document['status'] == 0)
                                        ? StatusTag(Colors.black, 'Assigned')
                                        : (document['status'] == 1)
                                            ? StatusTag(
                                                Colors.green, 'Accepted')
                                            : (document['status'] == 2)
                                                ? StatusTag(Colors.redAccent,
                                                    'Rejected')
                                                : (document['status'] == 3)
                                                    ? StatusTag(
                                                        Colors.deepOrangeAccent,
                                                        'Overdue')
                                                    : SizedBox(),
                                  ])),
                                ),
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
                  tasktypetitle(
                    text: 'Accepted Tasks',
                  ),
                  Spacer(),
                  // Align(
                  //   alignment: Alignment.centerRight,
                  //   child: IconButton(
                  //       onPressed: () {}, icon: Icon(Icons.filter_alt_sharp)),
                  // )
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
                        child: CircularProgressIndicator(
                          color: Colors.black,
                        ),
                      );
                    }

                    return ListView(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      children: snapshot.data!.docs.map((document) {
                        //bool expanded = false;
                        return Padding(
                          padding: EdgeInsets.fromLTRB(6, 0, 6, 8),
                          child: Align(
                              child: Stack(children: <Widget>[
                            Container(
                              decoration: new BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    spreadRadius: 1,
                                    blurRadius: 3,
                                    offset: Offset(
                                        1, 2), // changes position of shadow
                                  ),
                                ],
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
                                    // onTap: () {
                                    //   expanded = !expanded;
                                    // },
                                    rotateTrailing: false,
                                    trailing: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
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
                                        borderRadius: BorderRadius.circular(4)),
                                    title: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            // Padding(
                                            //   padding: EdgeInsets.fromLTRB(
                                            //       0, 25, 5, 0),
                                            //   child: Icon(
                                            //     Icons.more_outlined,
                                            //     color: Colors.black,
                                            //   ),
                                            // ),
                                            // Flexible(
                                            //        child: Container(
                                            //          padding:
                                            //              EdgeInsets.fromLTRB(
                                            //                  0, 25, 15, 0),
                                            //          child: Text(
                                            //            document['category'],
                                            //            overflow:
                                            //                TextOverflow.ellipsis,
                                            //            style: GoogleFonts.poppins(
                                            //                fontWeight:
                                            //                    FontWeight.w500,
                                            //                color: Colors.black,
                                            //                fontSize: MediaQuery.of(
                                            //                            context)
                                            //                        .size
                                            //                        .width *
                                            //                    0.04),
                                            //          ),
                                            //        ),
                                            //      )
                                            Container(
                                              padding: EdgeInsets.fromLTRB(
                                                  0, 25, 0, 0),
                                              constraints: BoxConstraints(
                                                  maxWidth:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.6),
                                              child: Text(
                                                document['category'],
                                                style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.w300,
                                                    color: Colors.black,
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.043),
                                              ),
                                            )
                                          ],
                                        ),
                                        Container(
                                          constraints: BoxConstraints(
                                              maxWidth: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.6),
                                          child: Text(
                                            document['title'],
                                            style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.04),
                                          ),
                                        ),
                                        if (document['duedate'] != '')
                                          Container(
                                            padding:
                                                EdgeInsets.fromLTRB(0, 5, 0, 0),
                                            child: Text(
                                              "Due on : " +
                                                  "${document['duedate']},  ${document['duetime']}",
                                              textAlign: TextAlign.left,
                                              style: GoogleFonts.poppins(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.035),
                                            ),
                                          ),
                                      ],
                                    ),
                                    children: [
                                      Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 15.0),
                                              child: Text(
                                                "Description :",
                                                textAlign: TextAlign.left,
                                                style: GoogleFonts.poppins(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.035),
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.fromLTRB(
                                                  15, 5, 0, 0),
                                              constraints: BoxConstraints(
                                                  maxWidth:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.8),
                                              child: Text(
                                                '        ' +
                                                    document['description'],
                                                textAlign: TextAlign.left,
                                                style: GoogleFonts.poppins(
                                                    color: Colors.black,
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.035),
                                              ),
                                            ),
                                            (document['startdate'] != '' &&
                                                    document['enddate'] != '')
                                                ? Container(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            15, 5, 0, 0),
                                                    child: Text(
                                                      'Dates : ${document['startdate']} - ${document['enddate']}',
                                                      textAlign: TextAlign.left,
                                                      style: GoogleFonts.poppins(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.035),
                                                    ),
                                                  )
                                                : (document['startdate'] !=
                                                            '' ||
                                                        document['enddate'] !=
                                                            '')
                                                    ? Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                            (document['startdate'] !=
                                                                    '')
                                                                ? Container(
                                                                    padding: EdgeInsets
                                                                        .fromLTRB(
                                                                            15,
                                                                            5,
                                                                            0,
                                                                            0),
                                                                    child: Text(
                                                                      'Event Starts on ${document['startdate']}',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .left,
                                                                      style: GoogleFonts.poppins(
                                                                          color: Colors
                                                                              .black,
                                                                          fontWeight: FontWeight
                                                                              .w600,
                                                                          fontSize:
                                                                              MediaQuery.of(context).size.width * 0.035),
                                                                    ),
                                                                  )
                                                                : (document['enddate'] !=
                                                                        '')
                                                                    ? Container(
                                                                        padding: EdgeInsets.fromLTRB(
                                                                            15,
                                                                            5,
                                                                            0,
                                                                            0),
                                                                        child:
                                                                            Text(
                                                                          'Event Ends on ${document['enddate']}',
                                                                          textAlign:
                                                                              TextAlign.left,
                                                                          style: GoogleFonts.poppins(
                                                                              color: Colors.black,
                                                                              fontWeight: FontWeight.w600,
                                                                              fontSize: MediaQuery.of(context).size.width * 0.035),
                                                                        ),
                                                                      )
                                                                    : SizedBox(
                                                                        height:
                                                                            0,
                                                                        width:
                                                                            0,
                                                                      )
                                                          ])
                                                    : SizedBox()
                                          ])
                                    ]),
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
                                            ? StatusTag(Colors.deepOrangeAccent,
                                                'Overdue')
                                            : SizedBox(),
                          ])),
                        );
                      }).toList(),
                    );
                  }),
            ),
          ],
        ),
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
                child: (widget.accept == 1)
                    ? Container(
                        height: MediaQuery.of(context).size.height * 0.14,
                        width: MediaQuery.of(context).size.width * 0.88,
                        decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0))),
                        child: Column(
                          children: [
                            Text(
                              "Do you wish to accept the task ?",
                              style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: MediaQuery.of(context).size.width *
                                      0.040),
                            ),
                            Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
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
                                            MediaQuery.of(context).size.height *
                                                0.04,
                                            12,
                                            MediaQuery.of(context).size.height *
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
                                  padding: const EdgeInsets.all(10.0),
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
                                          showDialog(
                                              context: context,
                                              builder: (_) =>
                                                  SpinKitFoldingCube(
                                                    color: Colors.black,
                                                  ));
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
                                                  reasondb: '',
                                                  docId: document.id)
                                              .whenComplete(
                                            () => Navigator.pop(context),
                                          );
                                          Navigator.pop(context);
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
                                            MediaQuery.of(context).size.height *
                                                0.04,
                                            12,
                                            MediaQuery.of(context).size.height *
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
                        ))
                    : Container(
                        height: MediaQuery.of(context).size.height * 0.24,
                        width: MediaQuery.of(context).size.width * 0.88,
                        decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0))),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Do you wish to decline the task ? ",
                                style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.040),
                              ),
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
                                        fontSize:
                                            MediaQuery.of(context).size.width *
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
                            Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
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
                                            MediaQuery.of(context).size.height *
                                                0.04,
                                            12,
                                            MediaQuery.of(context).size.height *
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
                                  padding: const EdgeInsets.all(10.0),
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
                                          showDialog(
                                              context: context,
                                              builder: (_) =>
                                                  SpinKitFoldingCube(
                                                    color: Colors.black,
                                                  ));
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
                                          Navigator.pop(context);
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
                                            MediaQuery.of(context).size.height *
                                                0.04,
                                            12,
                                            MediaQuery.of(context).size.height *
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
