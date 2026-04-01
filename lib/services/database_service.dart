import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../models/transaction_model.dart';
import '../models/goal_model.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;

  // In-memory mock storage for Web to prevent MissingPluginExceptions
  final List<TransactionModel> _mockTransactions = [];
  final List<GoalModel> _mockGoals = [];
  bool _mockInitialized = false;
  int _mockIdCounter = 100;

  DatabaseService._init();

  Future<void> initWebMock() async {
    if (_mockInitialized) return;
    final now = DateTime.now();
    _mockTransactions.addAll([
      TransactionModel(id: 1, amount: 3000.0, type: 'income', category: 'Salary', date: now.subtract(const Duration(days: 10)), notes: 'Monthly Salary'),
      TransactionModel(id: 2, amount: 50.0, type: 'expense', category: 'Food', date: now.subtract(const Duration(days: 9)), notes: 'Groceries'),
      TransactionModel(id: 3, amount: 15.0, type: 'expense', category: 'Transport', date: now.subtract(const Duration(days: 8)), notes: 'Uber'),
      TransactionModel(id: 4, amount: 120.0, type: 'expense', category: 'Bills', date: now.subtract(const Duration(days: 7)), notes: 'Electricity'),
      TransactionModel(id: 5, amount: 40.0, type: 'expense', category: 'Food', date: now.subtract(const Duration(days: 6)), notes: 'Dinner'),
      TransactionModel(id: 6, amount: 200.0, type: 'income', category: 'Freelance', date: now.subtract(const Duration(days: 5)), notes: 'Design project'),
    ]);

    _mockGoals.addAll([
      GoalModel(id: 1, title: 'New Laptop', targetAmount: 2000.0, savedAmount: 500.0, deadline: now.add(const Duration(days: 180)), isActive: true),
      GoalModel(id: 2, title: 'Vacation', targetAmount: 1000.0, savedAmount: 200.0, deadline: now.add(const Duration(days: 90)), isActive: true),
    ]);
    _mockInitialized = true;
  }

  Future<Database?> get database async {
    if (kIsWeb) {
      await initWebMock();
      return null;
    }
    if (_database != null) return _database!;
    _database = await initDB('finora_db.db');
    return _database!;
  }

  Future<Database> initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        amount REAL NOT NULL,
        type TEXT NOT NULL,
        category TEXT NOT NULL,
        date TEXT NOT NULL,
        notes TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE goals (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        targetAmount REAL NOT NULL,
        savedAmount REAL NOT NULL,
        deadline TEXT NOT NULL,
        isActive INTEGER NOT NULL
      )
    ''');
    
    await _seedInitialData(db);
  }

  Future<void> _seedInitialData(Database db) async {
    final now = DateTime.now();
    final List<Map<String, dynamic>> initialTransactions = [
      {'amount': 3000.0, 'type': 'income', 'category': 'Salary', 'date': now.subtract(const Duration(days: 10)).toIso8601String(), 'notes': 'Monthly Salary'},
      {'amount': 50.0, 'type': 'expense', 'category': 'Food', 'date': now.subtract(const Duration(days: 9)).toIso8601String(), 'notes': 'Groceries'},
      {'amount': 15.0, 'type': 'expense', 'category': 'Transport', 'date': now.subtract(const Duration(days: 8)).toIso8601String(), 'notes': 'Uber'},
    ];

    for (var t in initialTransactions) {
      await db.insert('transactions', t);
    }

    final List<Map<String, dynamic>> initialGoals = [
      {'title': 'New Laptop', 'targetAmount': 2000.0, 'savedAmount': 500.0, 'deadline': now.add(const Duration(days: 180)).toIso8601String(), 'isActive': 1},
    ];

    for (var g in initialGoals) {
      await db.insert('goals', g);
    }
  }

  // --- Transaction Methods ---
  Future<TransactionModel> insertTransaction(TransactionModel transaction) async {
    if (kIsWeb) {
      final t = TransactionModel(
        id: ++_mockIdCounter,
        amount: transaction.amount,
        type: transaction.type,
        category: transaction.category,
        date: transaction.date,
        notes: transaction.notes,
      );
      _mockTransactions.insert(0, t);
      return t;
    }

    final db = (await instance.database)!;
    final id = await db.insert('transactions', transaction.toMap());
    return TransactionModel(
      id: id,
      amount: transaction.amount,
      type: transaction.type,
      category: transaction.category,
      date: transaction.date,
      notes: transaction.notes,
    );
  }

  Future<List<TransactionModel>> getAllTransactions() async {
    if (kIsWeb) {
      await initWebMock();
      final sorted = List<TransactionModel>.from(_mockTransactions);
      sorted.sort((a, b) => b.date.compareTo(a.date));
      return sorted;
    }

    final db = (await instance.database)!;
    final result = await db.query('transactions', orderBy: 'date DESC');
    return result.map((json) => TransactionModel.fromMap(json)).toList();
  }

  Future<int> updateTransaction(TransactionModel transaction) async {
    if (kIsWeb) {
      final idx = _mockTransactions.indexWhere((t) => t.id == transaction.id);
      if (idx != -1) _mockTransactions[idx] = transaction;
      return 1;
    }

    final db = (await instance.database)!;
    return await db.update(
      'transactions',
      transaction.toMap(),
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
  }

  Future<int> deleteTransaction(int id) async {
    if (kIsWeb) {
      _mockTransactions.removeWhere((t) => t.id == id);
      return 1;
    }

    final db = (await instance.database)!;
    return await db.delete(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // --- Goal Methods ---
  Future<GoalModel> insertGoal(GoalModel goal) async {
    if (kIsWeb) {
      final g = GoalModel(
        id: ++_mockIdCounter,
        title: goal.title,
        targetAmount: goal.targetAmount,
        savedAmount: goal.savedAmount,
        deadline: goal.deadline,
        isActive: goal.isActive,
      );
      _mockGoals.add(g);
      return g;
    }

    final db = (await instance.database)!;
    final id = await db.insert('goals', goal.toMap());
    return GoalModel(
      id: id,
      title: goal.title,
      targetAmount: goal.targetAmount,
      savedAmount: goal.savedAmount,
      deadline: goal.deadline,
      isActive: goal.isActive,
    );
  }

  Future<List<GoalModel>> getAllGoals() async {
    if (kIsWeb) {
      await initWebMock();
      return _mockGoals;
    }

    final db = (await instance.database)!;
    final result = await db.query('goals', orderBy: 'deadline ASC');
    return result.map((json) => GoalModel.fromMap(json)).toList();
  }

  Future<int> updateGoal(GoalModel goal) async {
    if (kIsWeb) {
      final idx = _mockGoals.indexWhere((g) => g.id == goal.id);
      if (idx != -1) _mockGoals[idx] = goal;
      return 1;
    }

    final db = (await instance.database)!;
    return await db.update(
      'goals',
      goal.toMap(),
      where: 'id = ?',
      whereArgs: [goal.id],
    );
  }

  Future<int> deleteGoal(int id) async {
    if (kIsWeb) {
      _mockGoals.removeWhere((g) => g.id == id);
      return 1;
    }

    final db = (await instance.database)!;
    return await db.delete(
      'goals',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

