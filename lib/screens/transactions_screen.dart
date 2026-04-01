import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import '../controllers/transaction_controller.dart';
import '../widgets/transaction_tile.dart';
import '../widgets/category_chip.dart';
import '../widgets/empty_state.dart';
import 'add_transaction_screen.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  final TransactionController tCtrl = Get.find<TransactionController>();
  String _selectedType = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              onChanged: (val) => tCtrl.searchTransactions(val),
              decoration: InputDecoration(
                hintText: 'Search transactions...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.withOpacity(0.1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: ['All', 'Income', 'Expense'].map((type) {
                final isSelected = _selectedType == type;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: CategoryChip(
                    label: type,
                    icon: type == 'Income' 
                        ? Icons.arrow_downward 
                        : type == 'Expense' 
                            ? Icons.arrow_upward 
                            : Icons.list,
                    isSelected: isSelected,
                    onTap: () {
                      setState(() => _selectedType = type);
                      tCtrl.filterByType(type);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Obx(() {
              if (tCtrl.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (tCtrl.filteredTransactions.isEmpty) {
                return EmptyState(
                  icon: Icons.search_off,
                  message: 'No transactions found.',
                  actionLabel: 'Clear Search',
                  onAction: () {
                    tCtrl.searchTransactions('');
                  },
                );
              }

              final grouped = tCtrl.groupedTransactions;
              final keys = grouped.keys.toList();

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: keys.length,
                itemBuilder: (context, groupIndex) {
                  final groupKey = keys[groupIndex];
                  final groupItems = grouped[groupKey]!;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Text(
                          groupKey.toUpperCase(),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[400],
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      ...groupItems.map((t) {
                        return FadeInUp(
                          duration: const Duration(milliseconds: 400),
                          child: TransactionTile(
                            transaction: t,
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (context) => AddTransactionScreen(transaction: t),
                              );
                            },
                            onDelete: () => tCtrl.deleteTransaction(t.id!),
                          ),
                        );
                      }).toList(),
                    ],
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
