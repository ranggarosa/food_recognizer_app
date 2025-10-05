import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  final String? _apiKey = dotenv.env['GEMINI_API_KEY'];

  void getFoodNutrition() {
    if (_apiKey == null) {
      print("API Key not found!");
      return;
    }

    print('Using API Key: $_apiKey');
  }
}
