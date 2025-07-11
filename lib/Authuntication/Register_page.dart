import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:new_version_of_recycle_app/Constants/CustomStyles.dart';

import '../Constants/globals.dart';
import '../services/getApiService.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final _formKey = GlobalKey<FormState>();
  File? _selectedImage;
  String _name = '';
  String _address = '';
  String _email = '';
  String _password = '';
  String _phone = '';
  String _role = 'user';

  bool _isLoading = false;
//function اختيار الصورة
  Future<void> _pickImage() async {
    try {
      final pickedFile =
      await ImagePicker().pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path); // Store the selected image
        });
      }
    } catch (e) {
      // Handle error if needed
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  // استدعاء خدمة تسجيل المستخدم
  Future<void> _registerUser() async {

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });

      try {
        final response = await ApiService().registerUser(
          name: _name,
          address: _address,
          email: _email,
          password: _password,
          phone: _phone,
          role: "user",
        );

        if (response['message'] == "User registered successfully.") {
          Globals().isLoggedIn = true;
          Globals().username = _name;
          Globals().address = _address;
          Globals().email = _email;
          Globals().phone = _phone;
          Globals().userRole = _role;

          // نجاح التسجيل
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم التسجيل بنجاح')),
          );
          print("=======================================================");
          Navigator.pop(context); // العودة إلى الصفحة السابقة
        } else {
          // فشل التسجيل
          print(response['message']);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response['message'] ?? 'فشل التسجيل')),
          );
        }
      } catch (e) {
        print(e.toString());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('حدث خطأ: $e')),
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
            'إنشاء حساب جديد',
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
          leading: SizedBox()
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              //pick a picture
              Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  CircleAvatar(
                    radius: 79,
                    backgroundImage: _selectedImage != null
                        ? FileImage(_selectedImage!) // Show selected image
                        : AssetImage(
                                "assets/images/Profile Pic 1.png") // Default image
                            as ImageProvider,
                  ),
                  Positioned(
                    bottom: 10,
                    right: 120,
                    child: GestureDetector(
                      onTap: _pickImage, // Trigger image picker
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(
                              0xFFf25d01), // Background color for the icon
                        ),
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        "الاسم",
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
                          hintText: "فاطمة عوني"),
                      validator: (value) =>
                          value!.isEmpty ? 'يرجى إدخال الاسم' : null,
                      onSaved: (value) => _name = value!,
                      textAlign: TextAlign.right, // محاذاة النص لليمين
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        "العنوان",
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
                          hintText: "المنيا - مركز المنيا"),
                      validator: (value) =>
                          value!.isEmpty ? 'يرجى إدخال العنوان' : null,
                      onSaved: (value) => _address = value!,
                      textAlign: TextAlign.right, // محاذاة النص لليمين
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        "البريد الالكتروني",
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
                        hintText: "Fatimahawny@gmail.com",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'يرجى إدخال البريد الإلكتروني';
                        }

                        final emailRegExp = RegExp(Globals.emailRegex);
                        if (!emailRegExp.hasMatch(value)) {
                          return 'صيغة البريد الإلكتروني غير صحيحة';
                        }

                        return null; // كل شيء سليم
                      },
                      onSaved: (value) => _email = value!,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
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
                    const SizedBox(height: 20),
                    _isLoading
                        ? CircularProgressIndicator()
                        : Center(
                            child: GestureDetector(
                              onTap: _registerUser,
                              child: Container(
                                height: 60,
                                width: 220,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(45)),
                                  color: Color(0xFFf25d01),
                                ),
                                child: Center(
                                  child: Text(
                                    'إنشاء حساب',
                                    style: CustomStyles.ButtonsStyle,
                                  ),
                                ),
                              ),
                            ),
                          )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
