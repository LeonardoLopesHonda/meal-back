import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meal_back/models/meal_review.dart';
import 'package:meal_back/models/feedback.dart';
import 'package:meal_back/services/auth_service.dart';
import 'package:meal_back/services/storage_service.dart';
import 'package:meal_back/services/validation_service.dart';
import 'package:meal_back/widgets/score_selector.dart';

class FeedbackScreen extends StatefulWidget {
  final MealReview review;

  const FeedbackScreen({super.key, required this.review});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _formKey = GlobalKey<FormState>();
  final _commentController = TextEditingController();
  int _selectedScore = 5;
  bool _isLoading = false;
  bool _hasExistingFeedback = false;
  FeedbackModel? _existingFeedback;

  @override
  void initState() {
    super.initState();
    _checkExistingFeedback();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _checkExistingFeedback() async {
    final user = AuthService.currentUser;
    if (user != null) {
      final feedback = await StorageService.getUserFeedbackForReview(
        user.id,
        widget.review.id,
      );

      if (feedback != null) {
        setState(() {
          _existingFeedback = feedback;
          _hasExistingFeedback = true;
          _selectedScore = feedback.score;
          _commentController.text = feedback.comment ?? '';
        });
      }
    }
  }

  Future<void> _submitFeedback() async {
    if (!_formKey.currentState!.validate()) return;

    final user = AuthService.currentUser;
    if (user == null) return;

    if (!widget.review.isOpen) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Esta avaliação já foi encerrada'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final allFeedback = await StorageService.getFeedback();

      if (_hasExistingFeedback && _existingFeedback != null) {
        // Update existing feedback
        final index = allFeedback.indexWhere(
          (f) => f.id == _existingFeedback!.id,
        );
        if (index != -1) {
          allFeedback[index] = FeedbackModel(
            id: _existingFeedback!.id,
            userId: user.id,
            reviewId: widget.review.id,
            score: _selectedScore,
            comment: _commentController.text.trim().isEmpty
                ? null
                : _commentController.text.trim(),
            createdAt: _existingFeedback!.createdAt,
          );
        }
      } else {
        // Create new feedback
        final newFeedback = FeedbackModel(
          id: 'feedback_${DateTime.now().millisecondsSinceEpoch}',
          userId: user.id,
          reviewId: widget.review.id,
          score: _selectedScore,
          comment: _commentController.text.trim().isEmpty
              ? null
              : _commentController.text.trim(),
          createdAt: DateTime.now(),
        );

        allFeedback.add(newFeedback);
      }

      await StorageService.saveFeedback(allFeedback);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _hasExistingFeedback
                  ? 'Avaliação atualizada com sucesso!'
                  : 'Avaliação enviada com sucesso!',
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );

        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao enviar avaliação: \$e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    final timeFormat = DateFormat('HH:mm');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Avaliar Refeição'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildMealInfo(),
            const SizedBox(height: 24),
            _buildFeedbackForm(),
          ],
        ),
      ),
    );
  }

  Widget _buildMealInfo() {
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
                    Icons.restaurant,
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
                        'Refeição do Dia',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onPrimaryContainer
                              .withValues(alpha: 0.8),
                        ),
                      ),
                      Text(
                        dateFormat.format(widget.review.dateOffered),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(
                            context,
                          ).colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Meal Image
            if (widget.review.imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    widget.review.imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Theme.of(context).colorScheme.surface,
                        child: Icon(
                          Icons.restaurant,
                          size: 48,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                      );
                    },
                  ),
                ),
              ),

            if (widget.review.imageUrl != null) const SizedBox(height: 16),

            // Description
            Text(
              widget.review.description,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 12),

            // Period and Shifts
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
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Turnos: ${widget.review.shifts.join(', ')}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onPrimaryContainer.withValues(alpha: 0.8),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedbackForm() {
    if (!widget.review.isOpen) {
      return Card(
        elevation: 0,
        color: Theme.of(
          context,
        ).colorScheme.errorContainer.withValues(alpha: 0.3),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Icon(
                Icons.timer_off,
                size: 48,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                'Avaliação Encerrada',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'O prazo para avaliar esta refeição já expirou.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onErrorContainer,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Icon(
                    _hasExistingFeedback ? Icons.edit : Icons.star,
                    color: Theme.of(context).colorScheme.primary,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _hasExistingFeedback
                        ? 'Atualizar Avaliação'
                        : 'Sua Avaliação',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              if (_hasExistingFeedback) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primaryContainer.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Você já avaliou esta refeição. Você pode atualizar sua avaliação abaixo.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 24),

              // Score Selector
              Text(
                'Nota (obrigatória)',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              ScoreSelector(
                selectedScore: _selectedScore,
                onScoreSelected: (score) {
                  setState(() => _selectedScore = score);
                },
              ),

              const SizedBox(height: 24),

              // Comment Field
              Text(
                'Comentário (opcional)',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _commentController,
                decoration: InputDecoration(
                  hintText: 'Compartilhe sua opinião sobre a refeição...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Theme.of(
                    context,
                  ).colorScheme.surfaceVariant.withValues(alpha: 0.3),
                  contentPadding: const EdgeInsets.all(16),
                ),
                maxLines: 4,
                maxLength: 500,
                textCapitalization: TextCapitalization.sentences,
              ),

              const SizedBox(height: 24),

              // Submit Button
              FilledButton(
                onPressed: _isLoading ? null : _submitFeedback,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                ),
                child: _isLoading
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.onPrimary,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        _hasExistingFeedback
                            ? 'Atualizar Avaliação'
                            : 'Enviar Avaliação',
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
