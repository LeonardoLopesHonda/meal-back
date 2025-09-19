import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meal_back/models/meal_review.dart';
import 'package:meal_back/models/feedback.dart';
import 'package:meal_back/services/storage_service.dart';
import 'package:meal_back/widgets/statistics_card.dart';

class ReportsScreen extends StatefulWidget {
  final MealReview review;

  const ReportsScreen({super.key, required this.review});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  List<FeedbackModel> _feedback = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFeedback();
  }

  Future<void> _loadFeedback() async {
    try {
      final feedback = await StorageService.getFeedbackForReview(
        widget.review.id,
      );
      setState(() {
        _feedback = feedback;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Map<String, dynamic> _calculateStatistics() {
    if (_feedback.isEmpty) {
      return {
        'average': 0.0,
        'total': 0,
        'distribution': List.filled(11, 0),
        'byScore': <int, int>{},
      };
    }

    final scores = _feedback.map((f) => f.score).toList();
    final average = scores.reduce((a, b) => a + b) / scores.length;

    final distribution = List.filled(11, 0);
    final byScore = <int, int>{};

    for (final score in scores) {
      distribution[score]++;
      byScore[score] = (byScore[score] ?? 0) + 1;
    }

    return {
      'average': average,
      'total': _feedback.length,
      'distribution': distribution,
      'byScore': byScore,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Relatórios de Avaliação'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildReviewInfo(),
                  const SizedBox(height: 24),
                  _buildStatistics(),
                  const SizedBox(height: 24),
                  _buildScoreDistribution(),
                  const SizedBox(height: 24),
                  _buildFeedbackList(),
                ],
              ),
            ),
    );
  }

  Widget _buildReviewInfo() {
    final dateFormat = DateFormat('dd/MM/yyyy');

    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.analytics,
                    color: Theme.of(context).colorScheme.onPrimary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Relatório da Avaliação',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(
                            context,
                          ).colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        dateFormat.format(widget.review.dateOffered),
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onPrimaryContainer
                              .withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Text(
              widget.review.description,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    widget.review.formattedPeriod,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Turnos: ${widget.review.shifts.join(', ')}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onPrimaryContainer.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatistics() {
    final stats = _calculateStatistics();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Estatísticas Gerais',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(
              child: StatisticsCard(
                title: 'Média Geral',
                value: stats['average'].toStringAsFixed(1),
                icon: Icons.star,
                color: _getAverageColor(stats['average']),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatisticsCard(
                title: 'Total de Respostas',
                value: stats['total'].toString(),
                icon: Icons.people,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: StatisticsCard(
                title: 'Satisfação',
                value: _getSatisfactionLevel(stats['average']),
                icon: Icons.sentiment_satisfied,
                color: _getAverageColor(stats['average']),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatisticsCard(
                title: 'Status',
                value: widget.review.isOpen ? 'Ativa' : 'Encerrada',
                icon: widget.review.isOpen
                    ? Icons.radio_button_checked
                    : Icons.check_circle,
                color: widget.review.isOpen
                    ? Colors.green
                    : Theme.of(context).colorScheme.outline,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildScoreDistribution() {
    final stats = _calculateStatistics();
    final distribution = stats['distribution'] as List<int>;
    final total = stats['total'] as int;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Distribuição de Notas',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),

        Card(
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Chart bars
                if (total > 0)
                  ...List.generate(11, (index) {
                    final score = index;
                    final count = distribution[score];
                    final percentage = total > 0 ? (count / total * 100) : 0.0;

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 30,
                            child: Text(
                              score.toString(),
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Stack(
                              children: [
                                Container(
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.surfaceVariant,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                if (count > 0)
                                  FractionallySizedBox(
                                    widthFactor: percentage / 100,
                                    child: Container(
                                      height: 24,
                                      decoration: BoxDecoration(
                                        color: _getScoreColor(score),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          SizedBox(
                            width: 60,
                            child: Text(
                              '$count (${percentage.toStringAsFixed(1)}%)',
                              style: Theme.of(context).textTheme.bodySmall,
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    );
                  })
                else
                  Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.bar_chart,
                            size: 48,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Nenhuma avaliação ainda',
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeedbackList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Comentários dos Alunos',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${_feedback.where((f) => f.comment?.isNotEmpty == true).length}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        if (_feedback.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.comment,
                      size: 48,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Nenhum feedback ainda',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        else
          ..._feedback.where((f) => f.comment?.isNotEmpty == true).map((
            feedback,
          ) {
            final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getScoreColor(
                              feedback.score,
                            ).withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${feedback.score}/10',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: _getScoreColor(feedback.score),
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getScoreColor(
                              feedback.score,
                            ).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            feedback.scoreText,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: _getScoreColor(feedback.score),
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          dateFormat.format(feedback.createdAt),
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                        ),
                      ],
                    ),

                    if (feedback.comment != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        feedback.comment!,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ],
                ),
              ),
            );
          }),
      ],
    );
  }

  Color _getAverageColor(double average) {
    if (average >= 8) return Colors.green;
    if (average >= 6) return Colors.orange;
    if (average >= 4) return Colors.deepOrange;
    return Colors.red;
  }

  Color _getScoreColor(int score) {
    if (score >= 8) return Colors.green;
    if (score >= 6) return Colors.orange;
    if (score >= 4) return Colors.deepOrange;
    return Colors.red;
  }

  String _getSatisfactionLevel(double average) {
    if (average >= 9) return 'Excelente';
    if (average >= 7) return 'Bom';
    if (average >= 5) return 'Regular';
    if (average >= 3) return 'Ruim';
    return 'Péssimo';
  }
}
