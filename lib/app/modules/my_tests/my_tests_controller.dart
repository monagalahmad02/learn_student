import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/test_history_model.dart';
import '../../data/providers/test_history_provider.dart';
import '../../routes/app_pages.dart';

class MyTestsController extends GetxController {
  final TestHistoryProvider _provider = TestHistoryProvider();

  var isLoading = true.obs;
  var testHistoryList = <TestHistory>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchTestHistory();
  }

  Future<void> fetchTestHistory() async {
    try {
      isLoading.value = true;
      final tests = await _provider.getUserTests();
      testHistoryList.assignAll(tests);
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> viewTestResult(int testId) async {
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );
    try {
      final result = await _provider.getTestResult(testId);
      Get.back();
      Get.toNamed(Routes.QUIZ_RESULT, arguments: {'testId': testId});
    } catch (e) {
      Get.back();
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }
}
