import 'package:flutter/material.dart';

class ScoreSelector extends StatelessWidget {
  final int selectedScore;
  final Function(int) onScoreSelected;

  const ScoreSelector({
    super.key,
    required this.selectedScore,
    required this.onScoreSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Score buttons grid
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List.generate(11, (index) {
            final score = index;
            final isSelected = score == selectedScore;

            return GestureDetector(
              onTap: () => onScoreSelected(score),
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(
                            context,
                          ).colorScheme.outline.withValues(alpha: 0.3),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    score.toString(),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: isSelected
                          ? Theme.of(context).colorScheme.onPrimary
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.w500,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),

        const SizedBox(height: 16),

        // Score description
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _getScoreColor(
              context,
              selectedScore,
            ).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _getScoreColor(
                context,
                selectedScore,
              ).withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                _getScoreIcon(selectedScore),
                color: _getScoreColor(context, selectedScore),
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nota $selectedScore/10',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: _getScoreColor(context, selectedScore),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _getScoreDescription(selectedScore),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: _getScoreColor(context, selectedScore),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // Scale reference
        Row(
          children: [
            Icon(
              Icons.info_outline,
              size: 16,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'Escala: 0 (Péssimo) • 5 (Regular) • 10 (Excelente)',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Color _getScoreColor(BuildContext context, int score) {
    if (score >= 8) {
      return Colors.green;
    } else if (score >= 6) {
      return Colors.orange;
    } else if (score >= 4) {
      return Colors.deepOrange;
    } else {
      return Colors.red;
    }
  }

  IconData _getScoreIcon(int score) {
    if (score >= 8) {
      return Icons.sentiment_very_satisfied;
    } else if (score >= 6) {
      return Icons.sentiment_satisfied;
    } else if (score >= 4) {
      return Icons.sentiment_neutral;
    } else if (score >= 2) {
      return Icons.sentiment_dissatisfied;
    } else {
      return Icons.sentiment_very_dissatisfied;
    }
  }

  String _getScoreDescription(int score) {
    switch (score) {
      case 0:
        return 'Péssimo - Completamente insatisfatório';
      case 1:
        return 'Muito Ruim - Extremamente insatisfatório';
      case 2:
        return 'Ruim - Muito insatisfatório';
      case 3:
        return 'Ruim - Insatisfatório';
      case 4:
        return 'Regular - Abaixo das expectativas';
      case 5:
        return 'Regular - Atende minimamente';
      case 6:
        return 'Bom - Satisfatório';
      case 7:
        return 'Bom - Bem satisfatório';
      case 8:
        return 'Muito Bom - Muito satisfatório';
      case 9:
        return 'Excelente - Extremamente satisfatório';
      case 10:
        return 'Perfeito - Excepcional';
      default:
        return 'Regular';
    }
  }
}
