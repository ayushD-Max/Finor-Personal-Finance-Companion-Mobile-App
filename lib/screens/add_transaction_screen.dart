import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../models/transaction_model.dart';
import '../controllers/transaction_controller.dart';
import '../utils/theme.dart';

class AddTransactionScreen extends StatefulWidget {
  final TransactionModel? transaction;
  const AddTransactionScreen({super.key, this.transaction});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  late final TextEditingController _amountController;
  late final TextEditingController _notesController;
  late String _selectedType;
  late String _selectedCategory;
  late DateTime _selectedDate;

  final List<String> _categories = [
    'Food', 'Transport', 'Shopping', 'Entertainment', 'Bills', 'Salary', 'Freelance', 'Other'
  ];

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(
      text: widget.transaction?.amount.toString() ?? '',
    );
    _notesController = TextEditingController(
      text: widget.transaction?.notes ?? '',
    );
    _selectedType = widget.transaction?.type ?? 'expense';
    _selectedCategory = widget.transaction?.category ?? 'Food';
    _selectedDate = widget.transaction?.date ?? DateTime.now();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _submit() {
    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      Get.snackbar('Error', 'Please enter a valid amount');
      return;
    }

    final transaction = TransactionModel(
      id: widget.transaction?.id,
      amount: amount,
      type: _selectedType,
      category: _selectedCategory,
      date: _selectedDate,
      notes: _notesController.text.isEmpty ? null : _notesController.text,
    );

    final ctrl = Get.find<TransactionController>();
    if (widget.transaction == null) {
      ctrl.addTransaction(transaction);
    } else {
      ctrl.editTransaction(transaction);
    }
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.theme.cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 48,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Add Transaction',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Type Toggle
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedType = 'expense'),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: _selectedType == 'expense' ? AppTheme.errorColor : Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            'Expense',
                            style: TextStyle(
                              color: _selectedType == 'expense' ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedType = 'income'),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: _selectedType == 'income' ? AppTheme.secondaryColor : Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            'Income',
                            style: TextStyle(
                              color: _selectedType == 'income' ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Amount Input
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Amount',
                  prefixText: '₹ ',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),

              // Category Dropdown
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (val) => setState(() => _selectedCategory = val!),
                decoration: InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),

              // Date Picker
              ListTile(
                title: const Text('Date'),
                subtitle: Text(DateFormat('MMM dd, yyyy').format(_selectedDate)),
                trailing: const Icon(Icons.calendar_today),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey[400]!),
                ),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (picked != null) {
                    setState(() => _selectedDate = picked);
                  }
                },
              ),
              const SizedBox(height: 16),

              // Notes Input
              TextField(
                controller: _notesController,
                decoration: InputDecoration(
                  labelText: 'Notes (Optional)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 32),

              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('Save Transaction', style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
