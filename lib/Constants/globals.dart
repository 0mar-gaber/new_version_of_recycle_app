// globals.dart
class Globals {
  static final Globals _instance = Globals._internal();
  static const baseUrl = "https://078f1d57e229.ngrok-free.app";
  // static const baseUrl = "https://10.0.2.2:7201/api";
  static const String emailRegex = r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";

  factory Globals() {
    return _instance;
  }

  Globals._internal();
  String userRole='user';
  String username='batta';
  String address='minya';
  String email='batta@gmail.com';
  String phone='01111111111';
  bool isLoggedIn=false;
  int totalCoins = 0;
  int totalCash =0;
  int totalRecycledItems=0;

}