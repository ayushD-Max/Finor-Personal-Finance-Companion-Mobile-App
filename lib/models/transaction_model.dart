class TransactionModel {
  final int? id;
  final double amount;
  final String type; // 'income' or 'expense'
  final String category;
  final DateTime date;
  final String? notes;

  TransactionModel({
    this.id,
    required this.amount,
    required this.type,
    required this.category,
    required this.date,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'type': type,
      'category': category,
      'date': date.toIso8601String(),
      'notes': notes,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'],
      amount: map['amount'],
      type: map['type'],
      category: map['category'],
      date: DateTime.parse(map['date']),
      notes: map['notes'],
    );
  }
}
