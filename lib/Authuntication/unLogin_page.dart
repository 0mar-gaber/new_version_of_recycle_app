import 'package:flutter/material.dart';
import 'package:new_version_of_recycle_app/Constants/globals.dart';

import '../Constants/CustomStyles.dart';
import '../admin_dashboard.dart';
import 'Login_page.dart';
import 'Register_page.dart';

class UnloginPage extends StatefulWidget {
  const UnloginPage({super.key, required Function() onLogin});

  @override
  State<UnloginPage> createState() => _UnloginPageState();
}

class _UnloginPageState extends State<UnloginPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/Info.png",
                    width: 180,
                    fit: BoxFit.fitWidth,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterPage(),
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
                          "إنشاء حساب",
                          style: CustomStyles.ButtonsStyle.copyWith(
                              color: Color(0xFFf25d01)),
                        )),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginPage(),
                        ),
                      );
                    },
                    child: Container(
                      height: 47,
                      width: 200,
                      decoration: BoxDecoration(
                          color: Color(0xFFf25d01),
                          borderRadius: BorderRadius.circular(25)),
                      child: Center(
                          child: Text(
                        "تسجيل الدخول",
                        style: CustomStyles.ButtonsStyle,
                      )),
                    ),
                  )
                ],
              ),
      ],
    );
  }
}
