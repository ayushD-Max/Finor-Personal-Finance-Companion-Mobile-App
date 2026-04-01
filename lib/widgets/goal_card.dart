import 'package:flutter/material.dart';
import '../models/goal_model.dart';
import '../utils/formatters.dart';
import '../utils/theme.dart';

class GoalCard extends StatefulWidget {
  final GoalModel goal;
  final VoidCallback onTap;

  const GoalCard({
    super.key,
    required this.goal,
    required this.onTap,
  });

  @override
  State<GoalCard> createState() => _GoalCardState();
}

class _GoalCardState extends State<GoalCard> with SingleTickerProviderStateMixin {
  late AnimationController _progressController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    
    final target = widget.goal.savedAmount / widget.goal.targetAmount;
    final safeTarget = target > 1.0 ? 1.0 : target;

    _animation = Tween<double>(begin: 0, end: safeTarget).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeOutCubic),
    );

    _progressController.forward();
  }

  @override
  void didUpdateWidget(GoalCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.goal.savedAmount != widget.goal.savedAmount) {
      final target = widget.goal.savedAmount / widget.goal.targetAmount;
      final safeTarget = target > 1.0 ? 1.0 : target;
      
      _animation = Tween<double>(begin: _animation.value, end: safeTarget).animate(
        CurvedAnimation(parent: _progressController, curve: Curves.easeOutCubic),
      );
      _progressController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progressVal = widget.goal.savedAmount / widget.goal.targetAmount;
    final isComplete = progressVal >= 1.0;

    return GestureDetector(
      onTap: widget.onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Animated Circular Ring Indicator
              SizedBox(
                width: 60,
                height: 60,
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        CircularProgressIndicator(
                          value: _animation.value,
                          strokeWidth: 6,
                          backgroundColor: Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            isComplete ? AppTheme.secondaryColor : AppTheme.primaryColor,
                          ),
                        ),
                        if (isComplete)
                          Icon(Icons.check, color: AppTheme.secondaryColor, size: 24)
                        else
                          Text(
                            '${(_animation.value * 100).toInt()}%',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.goal.title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${Formatters.formatCurrency(widget.goal.savedAmount)} of ${Formatters.formatCurrency(widget.goal.targetAmount)}',
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }
}
