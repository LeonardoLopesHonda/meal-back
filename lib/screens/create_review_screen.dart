import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meal_back/services/storage_service.dart';
import 'package:meal_back/services/auth_service.dart';
import 'package:meal_back/services/validation_service.dart';
import 'package:meal_back/models/meal_review.dart';

class CreateReviewScreen extends StatefulWidget {
  const CreateReviewScreen({super.key});

  @override
  State<CreateReviewScreen> createState() => _CreateReviewScreenState();
}

class _CreateReviewScreenState extends State<CreateReviewScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String _selectedPeriod = 'morning';
  List<String> _selectedShifts = [];
  DateTime _closureDate = DateTime.now().add(const Duration(days: 3));

  bool _isLoading = false;

  final List<String> _periods = ['morning', 'afternoon', 'evening'];

  final Map<String, String> _periodNames = {
    'morning': 'Manhã',
    'afternoon': 'Tarde',
    'evening': 'Noite',
  };

  final List<String> _availableShifts = [
    'Manhã A',
    'Manhã B',
    'Tarde A',
    'Tarde B',
    'Noite A',
    'Noite B',
  ];

  // Sample meal images
  final List<String> _sampleImages = [
    'https://pixabay.com/get/gccc2efe1f63a634d19737bec9e4f85c33f214ce3a81725b9833dab318993c411702dc6a75765dad38d873d93be34b8b1fede82c1adb1f8f2da7417ef19f7bbd8_1280.jpg',
    'https://pixabay.com/get/g2275fed313b832ade0b2e3301cd4f08230c2dea49e29294b640dc80977b5b49f9067c460e3cd4fda76266dac101179e253815747551c262c720b9b3b3b5efac3_1280.jpg',
    'https://pixabay.com/get/gbb9065d8b03cf1244a67e435dfd82edbe7617c0ed599204ab060d44a3668a75cd189d2f118501ca717ba1135c2726bd8fb3de77e2ec9bdf7d5098eb18f5544de_1280.jpg',
    'https://pixabay.com/get/g7b8373f091c5acbd8cf05e2c97d26dbcd07f6232c516aee497a9eb1b2e4f1426be2add1374c243693767adb6ebd4a3937e47340e5d5c300ad560d5426fa4b198_1280.jpg',
    'https://pixabay.com/get/g4fb470c712b897b35bf6108ab181035aab37a6ed3c91c5379a2389700d2e024d043ac75473e8cac1dc5a490b77562b02c4c1f4d99bc0b77ff225245abd916f59_1280.jpg',
  ];

  @override
  void dispose() {
    _descriptionController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 7)),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );

    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _selectClosureDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _closureDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );

    if (picked != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_closureDate),
      );

      if (time != null) {
        setState(() {
          _closureDate = DateTime(
            picked.year,
            picked.month,
            picked.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  void _selectSampleImage() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selecionar Imagem de Exemplo',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _sampleImages.length,
                itemBuilder: (context, index) {
                  final imageUrl = _sampleImages[index];
                  return GestureDetector(
                    onTap: () {
                      _imageUrlController.text = imageUrl;
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      width: 120,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Theme.of(
                            context,
                          ).colorScheme.outline.withValues(alpha: 0.3),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Theme.of(
                                context,
                              ).colorScheme.surfaceVariant,
                              child: Icon(
                                Icons.restaurant,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Future<void> _createReview() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedShifts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Selecione pelo menos um turno'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final reviews = await StorageService.getMealReviews();

      final newReview = MealReview(
        id: 'review_${DateTime.now().millisecondsSinceEpoch}',
        description: _descriptionController.text.trim(),
        dateOffered: _selectedDate,
        period: _selectedPeriod,
        shifts: List.from(_selectedShifts),
        closureDate: _closureDate,
        imageUrl: _imageUrlController.text.trim().isEmpty
            ? null
            : _imageUrlController.text.trim(),
        createdAt: DateTime.now(),
        createdBy: AuthService.currentUser?.id ?? 'unknown',
      );

      reviews.add(newReview);
      await StorageService.saveMealReviews(reviews);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Avaliação criada com sucesso!'),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );

        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao criar avaliação: \$e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova Avaliação'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Card
              Card(
                elevation: 0,
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.restaurant_menu,
                        size: 32,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Criar Nova Avaliação',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onPrimaryContainer,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Text(
                              'Configure os detalhes da refeição para avaliação',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
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
                ),
              ),

              const SizedBox(height: 24),

              // Description
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Descrição da Refeição',
                  hintText: 'Ex: Arroz, feijão, frango grelhado e salada',
                  prefixIcon: Icon(
                    Icons.description,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                ),
                validator: ValidationService.validateMealDescription,
                maxLines: 3,
                textCapitalization: TextCapitalization.sentences,
              ),

              const SizedBox(height: 16),

              // Date Selection
              InkWell(
                onTap: _selectDate,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(
                        context,
                      ).colorScheme.outline.withValues(alpha: 0.5),
                    ),
                    borderRadius: BorderRadius.circular(12),
                    color: Theme.of(context).colorScheme.surface,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Data da Refeição',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                                  ),
                            ),
                            Text(
                              DateFormat('dd/MM/yyyy').format(_selectedDate),
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Period Selection
              Text(
                'Período',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: _periods.map((period) {
                  final isSelected = period == _selectedPeriod;
                  return FilterChip(
                    label: Text(_periodNames[period]!),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() => _selectedPeriod = period);
                    },
                    selectedColor: Theme.of(
                      context,
                    ).colorScheme.primaryContainer,
                    labelStyle: TextStyle(
                      color: isSelected
                          ? Theme.of(context).colorScheme.onPrimaryContainer
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 16),

              // Shifts Selection
              Text(
                'Turnos Aplicáveis',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: _availableShifts.map((shift) {
                  final isSelected = _selectedShifts.contains(shift);
                  return FilterChip(
                    label: Text(shift),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedShifts.add(shift);
                        } else {
                          _selectedShifts.remove(shift);
                        }
                      });
                    },
                    selectedColor: Theme.of(
                      context,
                    ).colorScheme.secondaryContainer,
                    labelStyle: TextStyle(
                      color: isSelected
                          ? Theme.of(context).colorScheme.onSecondaryContainer
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 16),

              // Closure Date
              InkWell(
                onTap: _selectClosureDate,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(
                        context,
                      ).colorScheme.outline.withValues(alpha: 0.5),
                    ),
                    borderRadius: BorderRadius.circular(12),
                    color: Theme.of(context).colorScheme.surface,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.timer,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Data/Hora de Encerramento',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                                  ),
                            ),
                            Text(
                              DateFormat(
                                'dd/MM/yyyy HH:mm',
                              ).format(_closureDate),
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Image URL
              TextFormField(
                controller: _imageUrlController,
                decoration: InputDecoration(
                  labelText: 'URL da Imagem (opcional)',
                  hintText: 'https://exemplo.com/imagem.jpg',
                  prefixIcon: Icon(
                    Icons.image,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.photo_library,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: _selectSampleImage,
                    tooltip: 'Escolher exemplo',
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                ),
                keyboardType: TextInputType.url,
              ),

              const SizedBox(height: 32),

              // Create Button
              FilledButton(
                onPressed: _isLoading ? null : _createReview,
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
                    : const Text('Criar Avaliação'),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
