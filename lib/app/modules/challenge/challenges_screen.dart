import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../data/models/challenge_model.dart';
import '../../routes/app_pages.dart';
import '../../utils/helpers.dart';
import 'challenges_controller.dart';

class ChallengesScreen extends GetView<ChallengesController> {
  const ChallengesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Challenges',
          style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator(color: primaryColor));
        }
        if (controller.challengeList.isEmpty) {
          return Center(
            child: Text(
              'No challenges available for you yet.',
              style: TextStyle(color: primaryColor),
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: controller.fetchChallenges,
          child: ListView.builder(
            itemCount: controller.challengeList.length,
            itemBuilder: (context, index) {
              final challenge = controller.challengeList[index];
              return _buildChallengeCard(context, challenge);
            },
          ),
        );
      }),
    );
  }

  Widget _buildChallengeCard(BuildContext context, Challenge challenge) {
    final now = DateTime.now();
    final canStart = now.isAfter(challenge.startTime);
    final timeFormat = DateFormat('MMM d, yyyy - hh:mm a');

    final teacherName =
        controller.teachersMap[challenge.teacherId] ?? 'Unknown Teacher';

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.all(10),
      child: ListTile(
        leading: Icon(
          canStart ? Icons.play_circle_fill : Icons.timer_outlined,
          color: canStart ? Colors.green : Colors.orange,
        ),
        title: Text(
          challenge.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'By: $teacherName\nStarts at: ${timeFormat.format(challenge.startTime)}',
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          Get.toNamed(
            Routes.CHALLENGE_QUIZ,
            arguments: {'challengeId': challenge.id},
          );
        },
      ),
    );
  }
}
