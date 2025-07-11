import 'package:flutter/material.dart';
import 'package:new_version_of_recycle_app/admin_dashboard.dart';
import '../Constants/CustomStyles.dart';
import '../Constants/globals.dart';
import '../services/getApiService.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _password = '';
  String _phone = '';
  bool _isLoading = false;

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });

      if(_phone.toString() == "1"&&_password.toString()=="123456"){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AdminDashboard()),
        );

        setState(() {
          _isLoading = false;
        });
        return ;
      }

      if(_phone.toString() == "0"&&_password.toString()=="123456"){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AdminDashboard()),
        );
        setState(() {
          _isLoading = false;
        });
        return ;

      }


      try {
        final response =
            await ApiService().login(phone: _phone, password: _password);

        if (response.statusCode == 200) {
          Globals().isLoggedIn = true;
          Globals().phone = _phone;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('تم تسجيل الدخول بنجاح')),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("no user founded")),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            'تسجيل الدخول',
            style: CustomStyles.MainStyle,
          ),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: IconButton(
                  onPressed: Navigator.of(context).pop,
                  icon: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Color(0xFFf25d01),
                    size: 30,
                  )),
            ),
          ],
          leading: SizedBox()),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Center(
                    child: CircleAvatar(
                        radius: 70,
                        backgroundImage: AssetImage(
                            "assets/images/Profile Pic 1.png") // Default image
                        ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      "رقم التليفون",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: "Almarai",
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1D8560), // لون النص الأخضر الداكن
                      ),
                    ),
                  ),
                  TextFormField(
                    decoration: CustomStyles.customInputDecoration(
                        hintText: "01112131415"),
                    validator: (value) =>
                        value!.isEmpty ? 'يرجى إدخال رقم الهاتف' : null,
                    onSaved: (value) => _phone = value!,
                    textAlign: TextAlign.right, // محاذاة النص لليمين
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      "كلمة المرور",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: "Almarai",
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1D8560), // لون النص الأخضر الداكن
                      ),
                    ),
                  ),
                  TextFormField(
                    decoration: CustomStyles.customInputDecoration(
                        hintText: "1234****"),
                    obscureText: true,
                    validator: (value) => value!.length < 6
                        ? 'يجب أن تكون كلمة المرور 6 أحرف على الأقل'
                        : null,
                    onSaved: (value) => _password = value!,
                    textAlign: TextAlign.right, // محاذاة النص لليمين
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 60),
                  _isLoading
                      ? CircularProgressIndicator()
                      : Center(
                          child: GestureDetector(
                            onTap: _handleLogin,
                            child: Container(
                              height: 55,
                              width: 200,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(45)),
                                color: Color(0xFFf25d01),
                              ),
                              child: Center(
                                child: Text(
                                  'تسجيل الدخول',
                                  style: CustomStyles.ButtonsStyle,
                                ),
                              ),
                            ),
                          ),
                        )
                  // ElevatedButton(
                  //         onPressed: _handleLogin,
                  //         child: Text('Login'),
                  //       ),
                ],
              ),
            ]),
          )),
    );
  }
}
