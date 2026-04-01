import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  final String actionLabel;
  final String? lottieUrl;
  final VoidCallback? onAction;

  const EmptyState({
    super.key,
    required this.icon,
    required this.message,
    required this.actionLabel,
    this.lottieUrl,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (lottieUrl != null)
              Lottie.network(
                lottieUrl!,
                height: 200,
                repeat: true,
              )
            else
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 64, color: Colors.grey[400]),
              ),
            const SizedBox(height: 24),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 24),
            if (onAction != null)
              ElevatedButton(
                onPressed: onAction,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(actionLabel),
              ),
          ],
        ),
      ),
    );
  }
}

