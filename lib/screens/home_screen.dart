import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import '../controllers/transaction_controller.dart';
import '../controllers/settings_controller.dart';
import '../controllers/navigation_controller.dart';
import '../widgets/balance_card.dart';
import '../widgets/transaction_tile.dart';
import '../widgets/section_header.dart';
import '../widgets/empty_state.dart';
import '../utils/theme.dart';
import 'add_transaction_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tCtrl = Get.find<TransactionController>();
    final sCtrl = Get.find<SettingsController>();
    final navCtrl = Get.find<NavigationController>();

    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          if (tCtrl.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final recent = tCtrl.recentTransactions;

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FadeInDown(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Good Morning,',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  sCtrl.userName.value,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () => Get.to(() => const ProfileScreen()),
                              child: CircleAvatar(
                                backgroundColor: Colors.grey[200],
                                child: const Icon(Icons.person, color: Colors.grey),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      FadeInUp(
                        delay: const Duration(milliseconds: 100),
                        child: BalanceCard(
                          balance: tCtrl.balance,
                          income: tCtrl.totalIncome,
                          expense: tCtrl.totalExpense,
                        ),
                      ),
                      const SizedBox(height: 32),
                      
                      // QUICK ACTIONS
                      FadeInUp(
                        delay: const Duration(milliseconds: 150),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'QUICK ACTIONS',
                              style: TextStyle(
                                fontSize: 12, 
                                fontWeight: FontWeight.bold, 
                                color: Colors.grey, 
                                letterSpacing: 1.2
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _QuickAction(
                                  icon: Icons.add_circle_outline, 
                                  label: 'Add', 
                                  color: AppTheme.primaryColor, 
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      builder: (context) => const AddTransactionScreen(),
                                    );
                                  }
                                ),
                                _QuickAction(icon: Icons.flag_outlined, label: 'Goals', color: Colors.orange, onTap: () => navCtrl.changeIndex(2)),
                                _QuickAction(icon: Icons.analytics_outlined, label: 'Insights', color: Colors.purple, onTap: () => navCtrl.changeIndex(3)),
                                _QuickAction(icon: Icons.history, label: 'History', color: Colors.blue, onTap: () => navCtrl.changeIndex(1)),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      FadeInUp(
                        delay: const Duration(milliseconds: 200),
                        child: SectionHeader(
                          title: 'Recent Transactions',
                          actionLabel: 'See All',
                          onAction: () => navCtrl.changeIndex(1),
                        ),
                      ),
                      if (recent.isEmpty)
                        FadeInUp(
                          delay: const Duration(milliseconds: 300),
                          child: EmptyState(
                            icon: Icons.account_balance_wallet,
                            message: 'No transactions yet. Add one!',
                            actionLabel: 'Add Transaction',
                            lottieUrl: 'https://assets5.lottiefiles.com/private_files/lf30_89unpvyq.json',
                            onAction: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (context) => const AddTransactionScreen(),
                              );
                            },
                          ),
                        )
                      else ...recent.asMap().entries.map((entry) {
                        final index = entry.key;
                        final transaction = entry.value;
                        return FadeInUp(
                          delay: Duration(milliseconds: 300 + (index * 80)),
                          child: TransactionTile(
                            transaction: transaction,
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (context) => AddTransactionScreen(transaction: transaction),
                              );
                            },
                            onDelete: () => tCtrl.deleteTransaction(transaction.id!),
                          ),
                        );
                      }).toList(),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon, 
    required this.label, 
    required this.color, 
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label, 
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)
        ),
      ],
    );
  }
}
