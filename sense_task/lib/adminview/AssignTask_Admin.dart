
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sense_task/Services/firebase_crud.dart';
import 'package:sense_task/adminview/adminpage.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../LoginPage.dart';

TextEditingController taskcategorycontroller = new TextEditingController();

TextEditingController tasktitlecontroller = new TextEditingController();
TextEditingController adminreasoncontroller = new TextEditingController();
TextEditingController taskdescriptioncontroller = new TextEditingController();

var checkInserttask = "Assign";
DateTime todayDate = DateTime.now();
String todayDateinString =
    "${startDate.day}/${startDate.month}/${startDate.year}";

String startDateInString = '';
DateTime startDate = DateTime.now();

String endDateInString = '';
DateTime endDate = DateTime.now();

String dueDateInString = '';
DateTime dueDate = DateTime.now();

String categoryvalue = category_list.first;
var category_list = [
  'HR office duty',
  'CTS office duty',
  'SENSE office duty',
  'Hostel duty',
  'Placement office duty',
  'Admissions office duty',
  'SW office duty',
  'Venue Preparation for VITEEE',
  'Venue Preparation for TRB/TNPSC exams',
];

String duetime = '';

int status = 0;

String reason = 'No reason';

class taskassign_a extends StatefulWidget {
  bool grey = true;

  @override
  State<taskassign_a> createState() => _taskassign_aState();
}

bool isDateSelected = false;
bool isRegister = true;
int ct = 0;

class _taskassign_aState extends State<taskassign_a> {
  @override
  Widget build(BuildContext context) {
    QueryDocumentSnapshot? document =
        ModalRoute.of(context)!.settings.arguments as QueryDocumentSnapshot?;

    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                'assets/images/Group 12.png',
              ),
              fit: BoxFit.cover)),
      child: SafeArea(
        child: Scaffold(
            backgroundColor: Colors.transparent,
            resizeToAvoidBottomInset: false,
            body: RefreshIndicator(
              color: Colors.black,
              onRefresh: () async {
                await Future.delayed(Duration(seconds: 1));
                setState(() {
                  ct += 1;
                });
              },
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Row(
                          children: [
                            BackButton(
                              onPressed: () {
                                Navigator.pop(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => adminpage()),
                                );
                                _clearassignpage();
                              },
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.16,
                            ),
                            Text(
                              "${checkInserttask}" + ' Task',
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize:
                                  MediaQuery.of(context).size.width * 0.06),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01),
                      Row(
                        children: [
                          mediumtext(
                            text: 'Task Category',
                          ),
                          Spacer(),
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0)),
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (_) => FunkyOverlayforcategory(),
                              );
                              setState(() {});
                            },
                            child: Text('Add Category',
                                style: GoogleFonts.lato(
                                  color: Colors.black,
                                  fontSize: 15,
                                )),
                          )
                        ],
                      ),
                      Center(
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.07,
                          width: MediaQuery.of(context).size.width * 0.9,
                          decoration: new BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.rectangle,
                            border: Border.all(width: 1.0),
                            borderRadius:
                            BorderRadius.all(Radius.circular(20.0)),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                children: [
                                  SizedBox(width: 20),
                                  new DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                        icon: Icon(
                                          Icons.arrow_drop_down,
                                          color: Colors.white,
                                          size: 20.09,
                                        ),
                                        alignment: Alignment.centerLeft,
                                        dropdownColor: Colors.black,
                                        value: categoryvalue,
                                        items: category_list.map((String item) {
                                          return DropdownMenuItem(
                                            value: item,
                                            child: Text(item),
                                          );
                                        }).toList(),
                                        // After selecting the desired option,it will
                                        // change button value to selected value
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            categoryvalue = newValue!;
                                          });
                                        },
                                        style: GoogleFonts.lato(
                                          color: Colors.white,
                                          fontSize: 15,
                                        )),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      mediumtext(
                        text: 'Choose Faculty',
                      ),
                      Center(
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.07,
                          width: MediaQuery.of(context).size.width * 0.9,
                          decoration: new BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.rectangle,
                            border: Border.all(width: 1.0),
                            borderRadius:
                            BorderRadius.all(Radius.circular(20.0)),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                children: [
                                  SizedBox(width: 20),
                                  new DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                        icon: Icon(
                                          Icons.arrow_drop_down,
                                          color: Colors.white,
                                          size: 20.09,
                                        ),
                                        alignment: Alignment.centerLeft,
                                        dropdownColor: Colors.black,
                                        value: facultyvalue,
                                        items:
                                        faculty_list.map((String faculty) {
                                          return DropdownMenuItem(
                                            value: faculty,
                                            child: Text(faculty),
                                          );
                                        }).toList(),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            facultyvalue = newValue!;
                                          });
                                        },
                                        style: GoogleFonts.lato(
                                          color: Colors.white,
                                          fontSize: 15,
                                        )),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.075,
                      ),
                      mediumtext(
                        text: 'Task Details',
                      ),

                      Center(
                        child: Column(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              decoration: new BoxDecoration(
                                color: Color(0xFFF7F8F8),
                                shape: BoxShape.rectangle,
                                border: Border.all(width: 1.0),
                                borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                      fontSize:
                                      MediaQuery.of(context).size.width *
                                          0.036),
                                  onChanged: (_) {
                                    if (_.length > 0)
                                      widget.grey = false;
                                    else
                                      widget.grey = true;
                                    setState(() {});
                                  },
                                  decoration: InputDecoration(
                                      alignLabelWithHint: true,
                                      fillColor: Colors.black,
                                      border: InputBorder.none,
                                      hintText: ' Enter title',
                                      hintStyle: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w200,
                                        fontSize: 16,
                                      )),
                                  keyboardType: TextInputType.text,
                                  cursorColor: Colors.black,

                                  controller: tasktitlecontroller,

                                  ///enter title
                                ),
                              ),
                            ),
                            SizedBox(
                                height:
                                MediaQuery.of(context).size.height * 0.01),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              decoration: new BoxDecoration(
                                color: Color(0xFFF7F8F8),
                                shape: BoxShape.rectangle,
                                border: Border.all(width: 1.0),
                                borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
                              ),
                              constraints: BoxConstraints(minHeight: 60),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: TextField(
                                  style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                      fontSize:
                                      MediaQuery.of(context).size.width *
                                          0.036),
                                  maxLines: null,
                                  onChanged: (_) {
                                    if (_.length > 0)
                                      widget.grey = false;
                                    else
                                      widget.grey = true;
                                    setState(() {});
                                  },
                                  decoration: InputDecoration(
                                      fillColor: Colors.white,
                                      border: InputBorder.none,
                                      hintText: ' Enter description',
                                      hintStyle: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w200,
                                        fontSize: 16,
                                      )),
                                  keyboardType: TextInputType.text,
                                  // maxLines: 20,
                                  cursorColor: Colors.black,
                                  controller: taskdescriptioncontroller,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      mediumtext(text: 'Event details'),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: OutlinedButton(
                                  onPressed: () async {
                                    final datePick = await showDatePicker(
                                      context: context,
                                      initialDate: startDate,
                                      firstDate: new DateTime(1900),
                                      lastDate: new DateTime.now()
                                          .add(Duration(days: 365)),
                                      builder: (context, child) {
                                        return Theme(
                                          data: Theme.of(context).copyWith(
                                            colorScheme: ColorScheme.light(
                                              primary: Colors
                                                  .black, // header background color
                                              onPrimary: Colors
                                                  .white, // header text color
                                              onSurface: Colors
                                                  .black, // body text color
                                            ),
                                            textButtonTheme:
                                            TextButtonThemeData(
                                              style: TextButton.styleFrom(
                                                primary: Colors
                                                    .black, // button text color
                                              ),
                                            ),
                                          ),
                                          child: child!,
                                        );
                                      },
                                    );
                                    if (datePick != null &&
                                        datePick != startDate) {
                                      setState(() {
                                        startDate = datePick;
                                        isDateSelected = true;

                                        // put it here
                                        startDateInString =
                                        "${startDate.day}/${startDate.month}/${startDate.year}";
                                        print(startDateInString); // 08/14/2019
                                      });
                                    }
                                    setState(() {});
                                  },
                                  style: OutlinedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(30.0)),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: (startDateInString != '')
                                        ? Text(
                                      startDateInString,
                                      style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 15,
                                      ),
                                    )
                                        : Text("Start date",
                                        style: GoogleFonts.poppins(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 15,
                                        )),
                                  ),
                                ),
                              ),
                              mediumtext(text: ' - '),
                              Center(
                                child: OutlinedButton(
                                  onPressed: () async {
                                    final datePick = await showDatePicker(
                                      context: context,
                                      initialDate: endDate,
                                      firstDate: startDate,
                                      lastDate: new DateTime.now()
                                          .add(Duration(days: 365)),
                                      builder: (context, child) {
                                        return Theme(
                                          data: Theme.of(context).copyWith(
                                            colorScheme: ColorScheme.light(
                                              primary: Colors
                                                  .black, // header background color
                                              onPrimary: Colors
                                                  .white, // header text color
                                              onSurface: Colors
                                                  .black, // body text color
                                            ),
                                            textButtonTheme:
                                            TextButtonThemeData(
                                              style: TextButton.styleFrom(
                                                primary: Colors
                                                    .black, // button text color
                                              ),
                                            ),
                                          ),
                                          child: child!,
                                        );
                                      },
                                    );
                                    if (datePick != null &&
                                        datePick != endDate) {
                                      setState(() {
                                        endDate = datePick;
                                        isDateSelected = true;

                                        // put it here
                                        endDateInString =
                                        "${endDate.day}/${endDate.month}/${endDate.year}";
                                        print(endDateInString); // 08/14/2019
                                      });
                                    }
                                    setState(() {});
                                  },
                                  style: OutlinedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(30.0)),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: (endDateInString != '')
                                        ? Text(
                                      endDateInString,
                                      style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 15,
                                      ),
                                    )
                                        : Text("End date",
                                        style: GoogleFonts.poppins(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 15,
                                        )),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Center(
                                  child: OutlinedButton(
                                    onPressed: () async {
                                      final datePick = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: startDate,
                                        builder: (context, child) {
                                          return Theme(
                                            data: Theme.of(context).copyWith(
                                              colorScheme: ColorScheme.light(
                                                primary: Colors
                                                    .black, // header background color
                                                onPrimary: Colors
                                                    .white, // header text color
                                                onSurface:
                                                Colors.black, // body text color
                                              ),
                                              textButtonTheme: TextButtonThemeData(
                                                style: TextButton.styleFrom(
                                                  primary: Colors
                                                      .black, // button text color
                                                ),
                                              ),
                                            ),
                                            child: child!,
                                          );
                                        },
                                      );
                                      if (datePick != null && datePick != dueDate) {
                                        setState(() {
                                          dueDate = datePick;
                                          isDateSelected = true;

                                          // put it here
                                          dueDateInString =
                                          "${dueDate.day}/${dueDate.month}/${dueDate.year}";
                                          print(dueDateInString); // 08/14/2019
                                        });
                                      }
                                      setState(() {});
                                    },
                                    style: OutlinedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(30.0)),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Container(
                                        child: Row(
                                          children: [
                                            (dueDateInString != '')
                                                ? Text(
                                              dueDateInString,
                                              style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 15,
                                              ),
                                            )
                                                : Text("Due Date",
                                                style: GoogleFonts.poppins(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 15,
                                                )),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.05,
                              ),
                              Container(
                                  height: MediaQuery.of(context).size.height * 0.08,
                                  width: MediaQuery.of(context).size.width * 0.35,
                                  child: DateTimePicker(
                                    type: DateTimePickerType.time,
                                    textAlign: TextAlign.center,
                                    timeHintText:
                                    (duetime != '') ? duetime : "Due Time",
                                    cursorColor: Colors.black,
                                    style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 15,
                                    ),
                                    timeFieldWidth: 0,
                                    onChanged: (value) {
                                      duetime = value;
                                      print(duetime);
                                    },
                                  )),
                            ],
                          )),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01),

                      Padding(
                        padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                        child: Text(
                          'Reason',
                          style: GoogleFonts.lato(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          decoration: new BoxDecoration(
                            color: Color(0xFFF7F8F8),
                            shape: BoxShape.rectangle,
                            border: Border.all(width: 1.0),
                            borderRadius:
                            BorderRadius.all(Radius.circular(15.0)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                  fontSize: MediaQuery.of(context).size.width *
                                      0.036),
                              onChanged: (_) {
                                if (_.length > 0)
                                  widget.grey = false;
                                else
                                  widget.grey = true;
                                setState(() {});
                              },
                              decoration: InputDecoration(
                                  alignLabelWithHint: true,
                                  fillColor: Colors.black,
                                  border: InputBorder.none,
                                  hintText:
                                  ' Enter why you chose this faculty here',
                                  hintStyle: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w200,
                                    fontSize: 16,
                                  )),
                              keyboardType: TextInputType.text,
                              cursorColor: Colors.black,

                              controller: adminreasoncontroller,

                              ///enter title
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.width*0.2)
                      ///TODO: Add task assigning datas with setting parameters
                      ///try ov-ai profile page and try to implement according to ui design
                    ],
                  ),
                ),
              ),
            ),
            floatingActionButton: (checkInserttask == 'Update')
                ? Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: MaterialButton(
                        onPressed: () async {
                          if (document != null) {
                            if (document['faculty'] == facultyvalue) {
                              await FirebaseTask.updateTask(
                                      categorydb: categoryvalue,
                                      titledb: tasktitlecontroller.text,
                                      descriptiondb:
                                          taskdescriptioncontroller.text,
                                      startdatedb: startDateInString,
                                      enddatedb: endDateInString,
                                      duedatedb: dueDateInString,
                                      duetimedb: duetime,
                                      facultydb: facultyvalue,
                                      statusdb: document['status'],
                                      reasondb: reason,
                                      admindb: adminreasoncontroller.text,
                                      docId: document!.id)
                                  .whenComplete(
                                () => Navigator.pop(context),
                              );
                            } else {
                              await FirebaseTask.updateTask(
                                      categorydb: categoryvalue,
                                      titledb: tasktitlecontroller.text,
                                      descriptiondb:
                                          taskdescriptioncontroller.text,
                                      startdatedb: startDateInString,
                                      enddatedb: endDateInString,
                                      duedatedb: dueDateInString,
                                      duetimedb: duetime,
                                      facultydb: facultyvalue,
                                      statusdb: status,
                                      reasondb: reason,
                                      admindb: adminreasoncontroller.text,
                                      docId: document!.id)
                                  .whenComplete(
                                () => Navigator.pop(context),
                              );
                            }
                            _clearassignpage();
                          }

                          print('updateeeeeeeeee');
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.05,
                          width: MediaQuery.of(context).size.width * 0.4,
                          decoration: new BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.rectangle,
                            border: Border.all(width: 2.0),
                            borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Center(
                              child: Text(
                                'Update',
                                style: GoogleFonts.lato(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize:12),
                              ),
                            ),
                          ),
                        )),
            )
                : (checkInserttask == 'Assign')
                    ? Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: MaterialButton(
                            onPressed: () {
                              setState(() {});
                              FirebaseTask.addTask(
                                  todaydatedb: todayDateinString,
                                  categorydb: categoryvalue,
                                  titledb: tasktitlecontroller.text,
                                  descriptiondb: taskdescriptioncontroller.text,
                                  startdatedb: startDateInString,
                                  enddatedb: endDateInString,
                                  duedatedb: dueDateInString,
                                  duetimedb: duetime,
                                  facultydb: facultyvalue,
                                  admindb: adminreasoncontroller.text,
                                  statusdb: status,
                                  reasondb: reason);
                              _clearassignpage();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => adminpage()),
                              );
                            },
    child: Container(
    height: MediaQuery.of(context).size.height * 0.05,
    width: MediaQuery.of(context).size.width * 0.4,
    decoration: new BoxDecoration(
    color: Colors.white,
    shape: BoxShape.rectangle,
    border: Border.all(width: 2.0),
    borderRadius:
    BorderRadius.all(Radius.circular(20.0)),
    ),
    child: Padding(
    padding: const EdgeInsets.all(10.0),
    child: Center(
    child: Text(
    'Add Task',
    style: GoogleFonts.lato(
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontSize: 12,
    ),
    ),
    ),
    ))))
        : SizedBox())));
  }

  void _clearassignpage() {
    checkInserttask = 'Assign';
    categoryvalue = "HR office duty";
    tasktitlecontroller.clear();
    taskdescriptioncontroller.clear();
    startDateInString = '';
    endDateInString = '';
    dueDateInString = '';
    duetime = "";
    facultyvalue = "S.Anand";
    adminreasoncontroller.clear();
  }
}

class FunkyOverlayforcategory extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => FunkyOverlayforcategoryState();
}

class FunkyOverlayforcategoryState extends State<FunkyOverlayforcategory>
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
                    child: Column(
                      children: [
                        Text(
                          " Add a new category ",
                          style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.035),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            height: 40,
                            child: TextField(
                              decoration: InputDecoration(
                                fillColor: Colors.black,
                                hintText: 'Type here',
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
                              controller: taskcategorycontroller,
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
                                    taskcategorycontroller.clear();
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
                              padding: const EdgeInsets.all(15.0),
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      elevation: 5.0,
                                      shape: StadiumBorder(),
                                      primary: Colors.black),
                                  onPressed: () {
                                    setState(() {
                                      category_list
                                          .add(taskcategorycontroller.text);
                                    });
                                    Navigator.pop(context);
                                    taskcategorycontroller.clear();
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

class tasktypetitle extends StatelessWidget {
  String text;
  tasktypetitle({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        '$text',
        style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: MediaQuery.of(context).size.width * 0.045),
      ),
    );
  }
}

class mediumtext extends StatelessWidget {
  String text;
  mediumtext({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Text(
        '$text',
        style: GoogleFonts.lato(
          color: Colors.black,
          fontSize: 16,
        ),
      ),
    );
  }
}