class GoalModel {
  final int? id;
  final String title;
  final double targetAmount;
  final double savedAmount;
  final DateTime deadline;
  final bool isActive;

  GoalModel({
    this.id,
    required this.title,
    required this.targetAmount,
    required this.savedAmount,
    required this.deadline,
    this.isActive = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'targetAmount': targetAmount,
      'savedAmount': savedAmount,
      'deadline': deadline.toIso8601String(),
      'isActive': isActive ? 1 : 0,
    };
  }

  factory GoalModel.fromMap(Map<String, dynamic> map) {
    return GoalModel(
      id: map['id'],
      title: map['title'],
      targetAmount: map['targetAmount'],
      savedAmount: map['savedAmount'],
      deadline: DateTime.parse(map['deadline']),
      isActive: map['isActive'] == 1,
    );
  }
}
