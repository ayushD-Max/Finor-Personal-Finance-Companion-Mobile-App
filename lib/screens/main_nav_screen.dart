import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'transactions_screen.dart';
import 'goals_screen.dart';
import 'insights_screen.dart';
import 'add_transaction_screen.dart';
import '../utils/theme.dart';
import 'package:get/get.dart';
import '../controllers/navigation_controller.dart';

class MainNavScreen extends StatefulWidget {
  const MainNavScreen({super.key});

  @override
  State<MainNavScreen> createState() => _MainNavScreenState();
}

class _MainNavScreenState extends State<MainNavScreen> {
  final NavigationController navCtrl = Get.put(NavigationController());
  
  final List<Widget> _screens = [
    const HomeScreen(),
    const TransactionsScreen(),
    const GoalsScreen(),
    const InsightsScreen(),
  ];

  void _onTabTapped(int index) {
    navCtrl.changeIndex(index);
  }

  void _showAddTransactionSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddTransactionScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _screens[navCtrl.selectedIndex.value],
        transitionBuilder: (child, animation) {
          final index = navCtrl.selectedIndex.value;
          if (index == 3 || index == 2) {
            return FadeTransition(
              opacity: animation,
              child: ScaleTransition(scale: animation, child: child),
            );
          } else if (index == 1) {
            return SlideTransition(
              position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero).animate(animation),
              child: child,
            );
          } else {
            return FadeTransition(opacity: animation, child: child);
          }
        },
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTransactionSheet,
        backgroundColor: AppTheme.primaryColor,
        tooltip: 'Add Transaction',
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        height: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(0, Icons.home, Icons.home_outlined, 'Home'),
            _buildNavItem(1, Icons.list_alt, Icons.list, 'Transactions'),
            const SizedBox(width: 48), // Space for FAB
            _buildNavItem(2, Icons.flag, Icons.flag_outlined, 'Goals'),
            _buildNavItem(3, Icons.bar_chart, Icons.bar_chart_outlined, 'Insights'),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData activeIcon, IconData inactiveIcon, String label) {
    return Obx(() {
      final isSelected = navCtrl.selectedIndex.value == index;
      return GestureDetector(
        onTap: () => _onTabTapped(index),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedScale(
              scale: isSelected ? 1.3 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isSelected ? activeIcon : inactiveIcon,
                color: isSelected ? AppTheme.primaryColor : Colors.grey,
              ),
            ),
            const SizedBox(height: 4),
            AnimatedOpacity(
              opacity: isSelected ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Text(
                label,
                style: TextStyle(
                  color: AppTheme.primaryColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
