import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/goal_model.dart';
import '../services/database_service.dart';

class GoalController extends GetxController {
  final db = DatabaseService.instance;
  var goals = <GoalModel>[].obs;
  var isLoading = true.obs;
  var isNoSpendActive = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadGoals();
  }

  void toggleNoSpend() {
    isNoSpendActive.toggle();
    Get.snackbar(
      isNoSpendActive.value ? 'Challenge On!' : 'Challenge Off',
      isNoSpendActive.value ? 'Try not to spend today!' : 'Challenge paused.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: isNoSpendActive.value ? Colors.orange.withOpacity(0.8) : Colors.grey.withOpacity(0.8),
      colorText: Colors.white,
    );
  }

  Future<void> loadGoals() async {
    isLoading(true);
    final data = await db.getAllGoals();
    goals.assignAll(data);
    isLoading(false);
  }

  Future<void> addGoal(GoalModel goal) async {
    await db.insertGoal(goal);
    await loadGoals();
  }

  Future<void> updateProgress(GoalModel goal, double newAmount) async {
    final updated = GoalModel(
      id: goal.id,
      title: goal.title,
      targetAmount: goal.targetAmount,
      savedAmount: newAmount,
      deadline: goal.deadline,
      isActive: goal.isActive,
    );
    await db.updateGoal(updated);
    await loadGoals();
  }

  Future<void> deleteGoal(int id) async {
    await db.deleteGoal(id);
    await loadGoals();
  }

  int checkStreak() {
    // Placeholder logic for returning streak
    // In a real app we'd check consecutive days of saving.
    return 5; 
  }
}
