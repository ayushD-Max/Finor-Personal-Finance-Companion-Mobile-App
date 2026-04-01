import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../utils/formatters.dart';
import '../utils/theme.dart';

class TransactionTile extends StatelessWidget {
  final TransactionModel transaction;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const TransactionTile({
    super.key,
    required this.transaction,
    required this.onTap,
    required this.onDelete,
  });

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Food': return Icons.fastfood;
      case 'Transport': return Icons.directions_car;
      case 'Shopping': return Icons.shopping_bag;
      case 'Rent': return Icons.home;
      case 'Entertainment': return Icons.movie;
      case 'Bills': return Icons.receipt;
      case 'Salary': return Icons.account_balance_wallet;
      case 'Freelance': return Icons.work;
      default: return Icons.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.type == 'income';
    
    return Dismissible(
      key: Key(transaction.id.toString()),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppTheme.errorColor,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 0,
        child: ListTile(
          onTap: onTap,
          contentPadding: const EdgeInsets.all(12),
          leading: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isIncome 
                ? AppTheme.secondaryColor.withOpacity(0.1) 
                : AppTheme.errorColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getCategoryIcon(transaction.category),
              color: isIncome ? AppTheme.secondaryColor : AppTheme.errorColor,
            ),
          ),
          title: Text(
            transaction.category,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          subtitle: Text(
            Formatters.formatDate(transaction.date),
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          trailing: Text(
            '${isIncome ? '+' : '-'}${Formatters.formatCurrency(transaction.amount)}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: isIncome ? AppTheme.secondaryColor : AppTheme.errorColor,
            ),
          ),
        ),
      ),
    );
  }
}
