import 'package:get/get.dart';
import '../../data/models/teacher_model.dart';
import '../../data/providers/chat_provider.dart';
import '../../data/providers/teacher_provider.dart';
import '../../data/providers/subject_provider.dart';
import 'package:flutter/material.dart'
    '';

import '../../routes/app_pages.dart';

class TeachersController extends GetxController {
  final TeacherProvider _teacherProvider = TeacherProvider();
  final SubjectProvider _subjectProvider = SubjectProvider();
  final ChatProvider _chatProvider = ChatProvider();

  final int subjectId = Get.arguments['subjectId'];
  final String subjectTitle = Get.arguments['subjectTitle'];

  var isLoading = true.obs;
  var isRequestingJoin = false.obs;
  var teacherList = <Teacher>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchTeachers();
  }

  Future<void> fetchTeachers() async {
    try {
      isLoading.value = true;
      final teachers = await _teacherProvider.getTeachersForSubject(subjectId);
      teacherList.assignAll(teachers);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not load teachers: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> requestToJoin(int teacherId) async {
    try {
      isRequestingJoin.value = true;
      final message = await _subjectProvider.requestToJoinSubject(
        subjectId,
        teacherId,
      );
      Get.snackbar(
        'Success',
        message,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isRequestingJoin.value = false;
    }
  }

  Future<void> startConversation(Teacher teacher) async {
    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      final conversationId = await _chatProvider.createConversation(teacher.id);

      Get.back();
      Get.toNamed(
        Routes.CHAT,
        arguments: {
          'conversationId': conversationId,
          'otherUser': teacher.toUserModel(),
        },
      );
    } catch (e) {
      Get.back();
      Get.snackbar('Error', 'Could not start conversation: ${e.toString()}');
    }
  }
}
