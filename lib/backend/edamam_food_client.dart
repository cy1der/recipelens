import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:recipelens/util/api_result.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EdamamFoodClient {
  final SharedPreferences prefs;

  EdamamFoodClient(this.prefs);

  Future<ApiResult<Map<String, dynamic>>> searchFoods(
      String searchQuery) async {
    final String appId = prefs.getString('edamam_food_app_id') ??
        (dotenv.env['EDAMAM_FOOD_APP_ID'] ?? '');
    final String appKey = prefs.getString('edamam_food_app_key') ??
        (dotenv.env['EDAMAM_FOOD_APP_KEY'] ?? '');
    final String baseUrl =
        dotenv.env['EDAMAM_BASE_URL'] ?? 'https://api.edamam.com';

    final Map<String, String> queryParams = {
      'app_id': appId,
      'app_key': appKey,
      'nutrition-type': 'cooking',
      'ingr': searchQuery
    };

    final Uri queryUri = Uri.parse('$baseUrl/api/food-database/v2/parser')
        .replace(queryParameters: queryParams);

    final response = await http.get(queryUri);

    switch (response.statusCode) {
      case 200:
        {
          Map<String, dynamic> data = json.decode(response.body);
          return ApiResult.success(data: data);
        }

      default:
        return ApiResult.error(response.statusCode);
    }
  }

  Future<ApiResult<List<dynamic>>> autocomplete(String searchQuery) async {
    final String appId = prefs.getString('edamam_food_app_id') ??
        (dotenv.env['EDAMAM_FOOD_APP_ID'] ?? '');
    final String appKey = prefs.getString('edamam_food_app_key') ??
        (dotenv.env['EDAMAM_FOOD_APP_KEY'] ?? '');
    final String baseUrl =
        dotenv.env['EDAMAM_BASE_URL'] ?? 'https://api.edamam.com';

    final Map<String, String> queryParams = {
      'app_id': appId,
      'app_key': appKey,
      'q': searchQuery,
      'limit': '5'
    };

    final Uri queryUri = Uri.parse('$baseUrl/auto-complete')
        .replace(queryParameters: queryParams);

    final response = await http.get(queryUri);

    switch (response.statusCode) {
      case 200:
        {
          List<dynamic> data = json.decode(response.body);
          return ApiResult.success(data: data);
        }

      default:
        return ApiResult.error(response.statusCode);
    }
  }
}
