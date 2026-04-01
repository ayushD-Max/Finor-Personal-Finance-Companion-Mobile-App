import 'package:get/get.dart';
import '../models/transaction_model.dart';
import '../services/database_service.dart';

class TransactionController extends GetxController {
  final db = DatabaseService.instance;
  var allTransactions = <TransactionModel>[].obs;
  var filteredTransactions = <TransactionModel>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadTransactions();
  }

  // Load from DB
  Future<void> loadTransactions() async {
    isLoading(true);
    final data = await db.getAllTransactions();
    allTransactions.assignAll(data);
    filteredTransactions.assignAll(data);
    isLoading(false);
  }

  // Computed totals
  double get totalIncome => allTransactions
      .where((t) => t.type == 'income')
      .fold(0.0, (sum, t) => sum + t.amount);

  double get totalExpense => allTransactions
      .where((t) => t.type == 'expense')
      .fold(0.0, (sum, t) => sum + t.amount);

  double get balance => totalIncome - totalExpense;

  List<TransactionModel> get recentTransactions => allTransactions.take(5).toList();

  // CRUD
  Future<void> addTransaction(TransactionModel transaction) async {
    await db.insertTransaction(transaction);
    await loadTransactions();
  }

  Future<void> editTransaction(TransactionModel transaction) async {
    await db.updateTransaction(transaction);
    await loadTransactions();
  }

  Future<void> deleteTransaction(int id) async {
    await db.deleteTransaction(id);
    await loadTransactions();
  }

  // Filters
  void filterByType(String? type) {
    if (type == null || type == 'All') {
      filteredTransactions.assignAll(allTransactions);
    } else {
      filteredTransactions.assignAll(
          allTransactions.where((t) => t.type == type.toLowerCase()).toList());
    }
  }

  void filterByCategory(String? category) {
    if (category == null || category == 'All') {
      filteredTransactions.assignAll(allTransactions);
    } else {
      filteredTransactions.assignAll(
          allTransactions.where((t) => t.category == category).toList());
    }
  }

  void searchTransactions(String query) {
    if (query.isEmpty) {
      filteredTransactions.assignAll(allTransactions);
    } else {
      query = query.toLowerCase();
      filteredTransactions.assignAll(allTransactions.where((t) {
        final matchesCat = t.category.toLowerCase().contains(query);
        final matchesNote = t.notes?.toLowerCase().contains(query) ?? false;
        return matchesCat || matchesNote;
      }).toList());
    }
  }
  // Grouping for UI
  Map<String, List<TransactionModel>> get groupedTransactions {
    final groups = <String, List<TransactionModel>>{};
    for (var t in filteredTransactions) {
      final dateStr = _getDateString(t.date);
      if (groups[dateStr] == null) groups[dateStr] = [];
      groups[dateStr]!.add(t);
    }
    return groups;
  }

  String _getDateString(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final tDate = DateTime(date.year, date.month, date.day);

    if (tDate == today) return 'Today';
    if (tDate == yesterday) return 'Yesterday';
    return '${date.day} ${_getMonthName(date.month)} ${date.year}';
  }

  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }
}
