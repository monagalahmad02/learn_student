import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/teacher_model.dart';
import '../../utils/helpers.dart';
import 'favorites_controller.dart';
import '../../routes/app_pages.dart';

class FavoriteTeachersScreen extends GetView<FavoritesController> {
  const FavoriteTeachersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'My Favorite Teachers',
          style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator(color: primaryColor));
        }
        if (controller.favoriteTeachersList.isEmpty) {
          return const Center(
            child: Text('No teachers have added you to their favorites yet.'),
          );
        }
        return RefreshIndicator(
          onRefresh: controller.fetchFavoriteTeachers,
          child: ListView.builder(
            itemCount: controller.favoriteTeachersList.length,
            itemBuilder: (context, index) {
              final teacher = controller.favoriteTeachersList[index];
              return _buildTeacherCard(context, teacher);
            },
          ),
        );
      }),
    );
  }

  Widget _buildTeacherCard(BuildContext context, Teacher teacher) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.all(10),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(
            teacher.name.substring(0, 1),
            style: TextStyle(color: primaryColor),
          ),
          backgroundColor: Colors.white,
        ),
        title: Text(teacher.name),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          Get.toNamed(
            Routes.FAVORITE_TESTS,
            arguments: {'teacherId': teacher.id, 'teacherName': teacher.name},
          );
        },
      ),
    );
  }
}
