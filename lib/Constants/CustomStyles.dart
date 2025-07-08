import 'package:flutter/material.dart';

class CustomStyles {
  static const TextStyle MainStyle = TextStyle(
    fontSize: 25,
    fontWeight: FontWeight.normal,
    fontFamily: "Almarai",
    color: Color(0xFFf25d01)
);
  static const TextStyle ButtonsStyle = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      fontFamily: "Almarai",
      color: Colors.white
  );
  static const TextStyle SelectedLabel = TextStyle(
      fontSize:14,
      fontWeight: FontWeight.normal,
      fontFamily: "Almarai",
      color: Color(0xFF1D8560)

  );
  static const TextStyle UnSelectedLabel = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      fontFamily: "Almarai",
      color: Color(0xFFf25d01)
  );

  // Custom Decoration Function
 static InputDecoration customInputDecoration({required String hintText}) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        fontSize: 14,
        color: Colors.grey, // لون النص الرمادي الفاتح
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFf25d01), width: 2.0), // خط برتقالي عند التمكين
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFf25d01), width: 2.0), // خط برتقالي عند التركيز
      ),
      contentPadding: EdgeInsets.only(bottom: 8), // تقليل المسافة لتطابق التصميم
    );
  }



// Add more styles as needed
}
