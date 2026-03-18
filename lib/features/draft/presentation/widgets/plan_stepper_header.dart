import 'package:flutter/material.dart';
import 'package:dota2_draft_plan_mobile/core/theme/app_colors.dart';

class PlanStepperHeader extends StatelessWidget {
  final int currentStep; // 1-based: 1=Details, 2=Bans, 3=Picks, 4=Threats

  const PlanStepperHeader({super.key, required this.currentStep});

  static const _steps = ['DETAILS', 'BANS', 'PICKS', 'THREATS'];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: Row(
        children: List.generate(_steps.length * 2 - 1, (index) {
          if (index.isOdd) {
            // Connector line
            final leftStep = index ~/ 2 + 1;
            final isCompleted = currentStep > leftStep;
            return Expanded(
              child: Container(
                height: 2,
                color: isCompleted ? AppColors.accent : AppColors.divider,
              ),
            );
          }
          final stepIndex = index ~/ 2;
          final stepNumber = stepIndex + 1;
          final isActive = stepNumber == currentStep;
          final isCompleted = stepNumber < currentStep;
          return _StepDot(
            number: stepNumber,
            label: _steps[stepIndex],
            isActive: isActive,
            isCompleted: isCompleted,
          );
        }),
      ),
    );
  }
}

class _StepDot extends StatelessWidget {
  final int number;
  final String label;
  final bool isActive;
  final bool isCompleted;

  const _StepDot({
    required this.number,
    required this.label,
    required this.isActive,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;
    if (isCompleted) {
      bgColor = AppColors.accent;
      textColor = Colors.white;
    } else if (isActive) {
      bgColor = AppColors.accent;
      textColor = Colors.white;
    } else {
      bgColor = AppColors.surfaceVariant;
      textColor = AppColors.textMuted;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: bgColor,
            shape: BoxShape.circle,
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: AppColors.accent.withValues(alpha: 0.5),
                      blurRadius: 8,
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: isCompleted
                ? const Icon(Icons.check, color: Colors.white, size: 14)
                : Text(
                    '$number',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: isActive || isCompleted
                ? AppColors.textPrimary
                : AppColors.textMuted,
            fontSize: 9,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.6,
          ),
        ),
      ],
    );
  }
}
