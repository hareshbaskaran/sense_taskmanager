import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sense_task/adminview/AssignTask_Admin.dart';
import 'package:sense_task/LoginPage.dart';
import 'package:sense_task/Models/FirebaseResponse.dart';
import 'package:sense_task/adminview/adminpage.dart';
import 'package:sense_task/userview/userpage.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _UserCollection = _firestore.collection('SenseTask');
final CollectionReference _taskCollection = _firestore.collection('Tasks');

class FirebaseCrud {
  static Future<Response> addUserDetails({
    required String username,
  }) async {
    Response response = Response();
    DocumentReference documentReferencer = _UserCollection.doc();

    Map<String, dynamic> data = <String, dynamic>{"username": username};

     await documentReferencer.set(data).whenComplete(() {
      response.code = 200;
      response.message = "Sucessfully added to the database";
    }).catchError((e) {
      response.code = 500;
      response.message = e;
    });

    return response;
  }

  static Stream<QuerySnapshot> readItems() {
    CollectionReference notesItemCollection =
        _UserCollection.doc().collection('SenseTask');
    print(notesItemCollection.snapshots());
    return notesItemCollection.snapshots();
  }
}

class FirebaseTask {
  ///add
  static Future<Response> addTask(
      {required String categorydb,
      required String titledb,
      required String descriptiondb,
      required String startdatedb,
      required String enddatedb,
      required String duedatedb,
      required String duetimedb,
      required String facultydb,
        required String admindb,
        required String todaydatedb,
      required int statusdb,
      required String reasondb}
      ) async {
    Response response = Response();
    DocumentReference documentReferencer = _taskCollection.doc();

    Map<String, dynamic> data = <String, dynamic>{
      "category": categorydb,
      "title": titledb,
      "description": descriptiondb,
      "startdate": startdatedb,
      "enddate": enddatedb,
      "duedate": duedatedb,
      "duetime": duetimedb,
      "faculty": facultydb,
      "status": statusdb,
      "reason": reasondb,
      "admin":admindb,
      "today":todaydatedb
    };

    var result = await documentReferencer.set(data).whenComplete(() {
      response.code = 200;
      response.message = "Sucessfully added to the database";
    }).catchError((e) {
      response.code = 500;
      response.message = e;
    });

    return response;
  }

  ///read
  static Stream<QuerySnapshot> readTask() {
    CollectionReference notesItemCollection = _taskCollection;
    return notesItemCollection.snapshots();
  }


  static Future<List<QuerySnapshot<Object?>>> DropdownFaculty() {
    CollectionReference notesItemCollection = _taskCollection;
    return notesItemCollection
        .where(
          "faculty",

          ///todo:add querry search string inside equal to
          isEqualTo: "",
        )
        .snapshots()
        .toList();
  }

  ///edit
  static Future<Response> updateTask(
      {
        required String categorydb,
      required String titledb,
      required String descriptiondb,
      required String startdatedb,
      required String enddatedb,
      required String duedatedb,
      required String duetimedb,
      required String facultydb,
      required int statusdb,
      required String reasondb,
        required String admindb,
      required String docId}) async {
    Response response = Response();
    DocumentReference documentReferencer = _taskCollection.doc(docId);

    Map<String, dynamic> data = <String, dynamic>{
      "category": categorydb,
      "title": titledb,
      "description": descriptiondb,
      "startdate": startdatedb,
      "enddate": enddatedb,
      "duedate": duedatedb,
      "duetime": duetimedb,
      "faculty": facultydb,
      "status": statusdb,
      "reason": reasondb,
      "admin":admindb
    };

    await documentReferencer.update(data).whenComplete(() {
      response.code = 200;
      response.message = "Sucessfully updated Employee";
    }).catchError((e) {
      response.code = 500;
      response.message = e;
    });

    return response;
  }

  ///delete
  static Future<Response> deleteTask({
    required String docId,
  }) async {
    Response response = Response();
    DocumentReference documentReferencer = _taskCollection.doc(docId);

    await documentReferencer.delete().whenComplete(() {
      response.code = 200;
      response.message = "Sucessfully Deleted Employee";
    }).catchError((e) {
      response.code = 500;
      response.message = e;
    });

    return response;
  }
}
class AdminQuery{
  static Stream<QuerySnapshot> TodayTasks() {
    CollectionReference notesItemCollection = _taskCollection;
    return notesItemCollection
        .where(
      "today",
      isEqualTo: todayDateinString,
    ).snapshots();
  }

  static Stream<QuerySnapshot> AdminStatus() {
    CollectionReference notesItemCollection = _taskCollection;
    return notesItemCollection
        .where(
      "status",
      isEqualTo: adminquery,
    ).snapshots();
  }
  static Stream<QuerySnapshot> DateQuery() {
    CollectionReference notesItemCollection = _taskCollection;
    return notesItemCollection
        .where(
      "startdate",
      isEqualTo: querydateinstring,
    ).snapshots();
  }
  static Stream<QuerySnapshot> FacultyQuery() {
    CollectionReference notesItemCollection = _taskCollection;
    return notesItemCollection
        .where(
      "faculty",
      isEqualTo: queryfaculty,
    ).snapshots();
  }
}
class UsernameQuery{
  static Stream<QuerySnapshot> UserOngoing() {
    CollectionReference notesItemCollection = _taskCollection;
    return notesItemCollection
        .where(
      "status",
      isEqualTo: 0,
    ).where("faculty",
      ///todo:change my name to stringfield catches username
      isEqualTo: user_hive
    ).snapshots();
  }
  static Stream<QuerySnapshot> UserAccepted() {
    CollectionReference notesItemCollection = _taskCollection;
    return notesItemCollection
        .where(
      "status",
      isEqualTo: 1,
    ).where("faculty",
        ///todo:change my name to stringfield catches username
        isEqualTo: user_hive
    ).snapshots();
  }
}