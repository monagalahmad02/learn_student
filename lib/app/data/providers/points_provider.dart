import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import '../../constant/app_constant.dart';
import '../../services/storage_service.dart';
import '../models/points_model.dart';

class PointsProvider {
  final StorageService _storageService = Get.find<StorageService>();

  Future<Map<String, String>> _getHeaders() async {
    final token = await _storageService.getToken();
    return {'Accept': 'application/json', 'Authorization': 'Bearer $token'};
  }

  Future<List<PointsRecord>> getStudentPoints() async {
    final url = Uri.parse('${AppConstant.baseUrl}/get/points/student');
    final response = await http.get(url, headers: await _getHeaders());

    if (response.statusCode == 200) {
      final List<dynamic> pointsJson = jsonDecode(
        response.body,
      )['points_by_teachers'];
      return pointsJson.map((json) => PointsRecord.fromJson(json)).toList();
    } else {
      if (response.statusCode == 404) return [];
      throw Exception(
        jsonDecode(response.body)['message'] ?? 'Failed to load points',
      );
    }
  }
}
