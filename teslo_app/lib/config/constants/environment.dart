import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static Future<void> initEnvironment() => dotenv.load();
  static String apiUrl = dotenv.env['API_URL'] ?? "It's not configured .env file";
}