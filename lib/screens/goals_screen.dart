import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import '../controllers/goal_controller.dart';
import '../models/goal_model.dart';
import '../widgets/goal_card.dart';
import '../widgets/empty_state.dart';
import '../utils/theme.dart';

class GoalsScreen extends StatelessWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gCtrl = Get.find<GoalController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Savings Goals', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Obx(() {
        if (gCtrl.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            FadeInDown(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: gCtrl.isNoSpendActive.value 
                      ? Colors.orange.withOpacity(0.15) 
                      : Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: gCtrl.isNoSpendActive.value 
                        ? Colors.orange.withOpacity(0.5) 
                        : Colors.grey.withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.local_fire_department, color: Colors.orange, size: 28),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('No Spend Challenge', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            Text(
                              gCtrl.isNoSpendActive.value 
                                  ? 'Current Streak: ${gCtrl.checkStreak()} Days' 
                                  : 'Challenge Paused',
                              style: TextStyle(
                                color: gCtrl.isNoSpendActive.value ? Colors.orange : Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Switch.adaptive(
                          value: gCtrl.isNoSpendActive.value, 
                          onChanged: (_) => gCtrl.toggleNoSpend(),
                          activeColor: Colors.orange,
                        ),
                      ],
                    ),
                    if (gCtrl.isNoSpendActive.value)
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Text(
                          'Keep it up! Each day without non-essential spending grows your streak.',
                          style: TextStyle(fontSize: 12, color: Colors.grey[600], fontStyle: FontStyle.italic),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('YOUR GOALS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey, letterSpacing: 1.2)),
                TextButton.icon(
                  onPressed: () => _showAddGoalSheet(context),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add Goal'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            gCtrl.goals.isEmpty
                ? EmptyState(
                    icon: Icons.flag,
                    message: 'No goals set yet. Start saving for something special!',
                    actionLabel: 'Create Your First Goal',
                    lottieUrl: 'https://assets9.lottiefiles.com/packages/lf20_ghp9v02k.json',
                    onAction: () => _showAddGoalSheet(context),
                  )
                : Column(
                    children: gCtrl.goals.map((goal) {
                      return FadeInUp(
                        child: GoalCard(
                          goal: goal,
                          onTap: () {
                            gCtrl.updateProgress(goal, goal.savedAmount + 100);
                          },
                        ),
                      );
                    }).toList(),
                  ),
            const SizedBox(height: 100),
          ],
        );
      }),
    );
  }

  void _showAddGoalSheet(BuildContext context) {
    final titleCtrl = TextEditingController();
    final amountCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 24, right: 24, top: 24,
        ),
        decoration: BoxDecoration(
          color: context.theme.cardColor,
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('New Savings Goal', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            TextField(
              controller: titleCtrl,
              decoration: AppTheme.inputDecoration('What are you saving for?', Icons.flag),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: amountCtrl,
              keyboardType: TextInputType.number,
              decoration: AppTheme.inputDecoration('Target Amount', Icons.attach_money),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  final amount = double.tryParse(amountCtrl.text);
                  if (titleCtrl.text.isNotEmpty && amount != null) {
                    Get.find<GoalController>().addGoal(GoalModel(
                      title: titleCtrl.text,
                      targetAmount: amount,
                      savedAmount: 0,
                      deadline: DateTime.now().add(const Duration(days: 30)),
                    ));
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('Set Goal', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
