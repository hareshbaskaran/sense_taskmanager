import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sense_task/adminview/AssignTask_Admin.dart';

import '../LoginPage.dart';
import 'adminpage.dart';

class facultystatus extends StatefulWidget {
  const facultystatus({Key? key}) : super(key: key);

  @override
  State<facultystatus> createState() => _facultystatusState();
}

class _facultystatusState extends State<facultystatus> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Padding(
            padding: EdgeInsets.only(top: 10),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Choose a Faculty to check\n their progress ! ',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: MediaQuery.of(context).size.width * 0.05),
                  ),
                ),
              ],
            ),
          ),
        ),
        ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: faculty_list.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {},
                child: Ink(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: new BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                        border: Border.all(width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      ),
                      child: Card(
                          elevation: 0,
                          child: Text(
                              style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.04),
                              faculty_list[index])),
                    ),
                  ),
                ),
              );
            })
      ],
    );
  }
}
