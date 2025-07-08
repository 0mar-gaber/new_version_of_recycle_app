import 'dart:async';

import 'getApiService.dart';

class UserUpdater {
  final ApiService _apiService = ApiService();
  Timer? _timer;

  void startUpdating(String token, Function(Map<String, dynamic>) onUpdate) {
    _timer = Timer.periodic(Duration(minutes: 1), (timer) async {
      final response = await _apiService.fetchUserData(token);
      if (response['success']) {
        onUpdate(response['data']);
      }
    });
  }

  void stopUpdating() {
    _timer?.cancel();
  }
}
