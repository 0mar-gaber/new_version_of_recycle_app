import 'dart:core';
import 'package:flutter/material.dart';
import 'package:new_version_of_recycle_app/admin_dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Constants/CustomStyles.dart';
import '../Constants/globals.dart';

class UserProfilePage extends StatefulWidget {
  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  @override
  Widget build(BuildContext context) {
    setState(() {
    });
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 18.0),
                child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 90,
                    backgroundImage: AssetImage(
                        "assets/images/succefully.png") // Default image
                    ),
              ),
            ),
          ),
          Text(
            "Name:" + Globals().username,
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 10),
          Text(
            "Email:" + Globals().email,
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 10),
          Text(
            "Phone:" + Globals().phone,
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 10),
          Text(
            "Address:" + Globals().address,
            style: TextStyle(fontSize: 18),
          ),
          Globals().phone == "01000000000"
              ? Padding(
                padding: const EdgeInsets.only(top: 18.0),
                child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AdminDashboard(),
                        ),
                      );
                    },
                    child: Container(
                      height: 47,
                      width: 200,
                      decoration: BoxDecoration(
                          border: Border.all(color: Color(0xFFf25d01)),
                          borderRadius: BorderRadius.circular(25)),
                      child: Center(
                          child: Text(
                        "dashboard",
                        style: CustomStyles.ButtonsStyle.copyWith(
                            color: Color(0xFFf25d01)),
                      )),
                    ),
                  ),
              )
              : SizedBox(),
        ],
      ),
    );
  }
}
