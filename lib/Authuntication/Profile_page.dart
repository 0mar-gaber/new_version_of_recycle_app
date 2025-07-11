import 'package:flutter/material.dart';
import 'package:new_version_of_recycle_app/Authuntication/unLogin_page.dart';
import 'package:new_version_of_recycle_app/Authuntication/user_profile_page.dart';
import '../Constants/globals.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}
class _ProfilePageState extends State<ProfilePage> {
  late bool isLoggedIn;

  @override
  void initState() {
    super.initState();
    // مناداة واحدة فقط عند الدخول للصفحة
  }

  void updateLoginStatus(bool status) {
    setState(() {
      isLoggedIn = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    isLoggedIn = Globals().isLoggedIn;
    return Scaffold(
      body: Center(
        child: isLoggedIn
            ? UserProfilePage()
            : UnloginPage(
          onLogin: () {
            updateLoginStatus(true);
          },
        ),
      ),
    );
  }
}
