import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meal_back/services/storage_service.dart';
import 'package:meal_back/services/auth_service.dart';
import 'package:meal_back/models/meal_review.dart';
import 'package:meal_back/models/registration_request.dart';
import 'package:meal_back/screens/reports_screen.dart';
import 'package:meal_back/screens/create_review_screen.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<MealReview> _reviews = [];
  List<RegistrationRequest> _requests = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      final reviews = await StorageService.getMealReviews();
      final requests = await StorageService.getRegistrationRequests();

      setState(() {
        _reviews = reviews..sort((a, b) => b.createdAt.compareTo(a.createdAt));
        _requests = requests.where((r) => r.isPending).toList()
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _closeReview(MealReview review) async {
    try {
      final allReviews = await StorageService.getMealReviews();
      final index = allReviews.indexWhere((r) => r.id == review.id);

      if (index != -1) {
        allReviews[index] = MealReview(
          id: review.id,
          description: review.description,
          dateOffered: review.dateOffered,
          period: review.period,
          shifts: review.shifts,
          closureDate: review.closureDate,
          imageUrl: review.imageUrl,
          isActive: false,
          createdAt: review.createdAt,
          createdBy: review.createdBy,
        );

        await StorageService.saveMealReviews(allReviews);
        await _loadData();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Avaliação encerrada com sucesso'),
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao encerrar avaliação: \$e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _approveRequest(RegistrationRequest request) async {
    final result = await AuthService.approveRegistrationRequest(request.id);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.success ? result.message! : result.error!),
          backgroundColor: result.success
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.error,
        ),
      );

      if (result.success) {
        await _loadData();
      }
    }
  }

  void _navigateToCreateReview() {
    Navigator.of(context)
        .push(
          MaterialPageRoute(builder: (context) => const CreateReviewScreen()),
        )
        .then((_) => _loadData());
  }

  void _navigateToReports(MealReview review) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => ReportsScreen(review: review)),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!AuthService.isAdmin) {
      return Scaffold(
        appBar: AppBar(title: const Text('Acesso Negado')),
        body: const Center(
          child: Text('Você não tem permissão para acessar esta área.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Painel Administrativo'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Visão Geral'),
            Tab(text: 'Avaliações'),
            Tab(text: 'Solicitações'),
          ],
          labelColor: Theme.of(context).colorScheme.primary,
          unselectedLabelColor: Theme.of(context).colorScheme.onSurfaceVariant,
          indicatorColor: Theme.of(context).colorScheme.primary,
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(),
                _buildReviewsTab(),
                _buildRequestsTab(),
              ],
            ),
      floatingActionButton: _tabController.index == 1
          ? FloatingActionButton.extended(
              onPressed: _navigateToCreateReview,
              icon: Icon(
                Icons.add,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              label: Text(
                'Nova Avaliação',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              backgroundColor: Theme.of(context).colorScheme.primary,
            )
          : null,
    );
  }

  Widget _buildOverviewTab() {
    final activeReviews = _reviews.where((r) => r.isOpen).length;
    final closedReviews = _reviews.where((r) => !r.isOpen).length;
    final pendingRequests = _requests.length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Resumo do Sistema',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Statistics Cards
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Avaliações Ativas',
                  activeReviews.toString(),
                  Icons.rate_review,
                  Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Avaliações Encerradas',
                  closedReviews.toString(),
                  Icons.check_circle,
                  Colors.green,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Solicitações Pendentes',
                  pendingRequests.toString(),
                  Icons.pending_actions,
                  Colors.orange,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Total de Avaliações',
                  _reviews.length.toString(),
                  Icons.assessment,
                  Theme.of(context).colorScheme.secondary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Recent Activities
          Text(
            'Atividades Recentes',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          if (_reviews.isEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 48,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Nenhuma avaliação criada ainda',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Crie a primeira avaliação de merenda',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else
            ..._reviews
                .take(3)
                .map(
                  (review) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _buildRecentActivityCard(review),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 0,
      color: color.withValues(alpha: 0.1),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: color),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivityCard(MealReview review) {
    final dateFormat = DateFormat('dd/MM/yyyy');

    return Card(
      elevation: 0,
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: review.isOpen
                ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.2)
                : Theme.of(context).colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            review.isOpen ? Icons.rate_review : Icons.check_circle,
            color: review.isOpen
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        title: Text(
          review.description,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          '${dateFormat.format(review.dateOffered)} • ${review.formattedPeriod}',
        ),
        trailing: review.isOpen
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'ATIVA',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : null,
        onTap: () => _navigateToReports(review),
      ),
    );
  }

  Widget _buildReviewsTab() {
    return RefreshIndicator(
      onRefresh: _loadData,
      child: _reviews.isEmpty
          ? const Center(child: Text('Nenhuma avaliação criada ainda'))
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _reviews.length,
              itemBuilder: (context, index) {
                final review = _reviews[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildReviewCard(review),
                );
              },
            ),
    );
  }

  Widget _buildReviewCard(MealReview review) {
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    return Card(
      elevation: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: review.isOpen
                    ? Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.2)
                    : Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                review.isOpen ? Icons.rate_review : Icons.check_circle,
                color: review.isOpen
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            title: Text(
              review.description,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Data: ${DateFormat('dd/MM/yyyy').format(review.dateOffered)}',
                ),
                Text('Período: ${review.formattedPeriod}'),
                Text('Turnos: ${review.shifts.join(', ')}'),
                Text('Encerramento: ${dateFormat.format(review.closureDate)}'),
              ],
            ),
            trailing: review.isOpen
                ? Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'ATIVA',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : Icon(Icons.check_circle, color: Colors.green),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Row(
              children: [
                OutlinedButton.icon(
                  onPressed: () => _navigateToReports(review),
                  icon: const Icon(Icons.analytics),
                  label: const Text('Ver Relatórios'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 8),
                if (review.isOpen)
                  FilledButton.icon(
                    onPressed: () => _showCloseConfirmation(review),
                    icon: const Icon(Icons.close),
                    label: const Text('Encerrar'),
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showCloseConfirmation(MealReview review) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Encerrar Avaliação'),
        content: const Text(
          'Tem certeza que deseja encerrar esta avaliação? Esta ação não pode ser desfeita.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              _closeReview(review);
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Encerrar'),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestsTab() {
    return RefreshIndicator(
      onRefresh: _loadData,
      child: _requests.isEmpty
          ? const Center(child: Text('Nenhuma solicitação pendente'))
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _requests.length,
              itemBuilder: (context, index) {
                final request = _requests[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildRequestCard(request),
                );
              },
            ),
    );
  }

  Widget _buildRequestCard(RegistrationRequest request) {
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    return Card(
      elevation: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.person_add, color: Colors.orange),
            ),
            title: Text(
              request.name,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('CPF: ${request.cpf}'),
                if (request.email != null) Text('Email: ${request.email}'),
                if (request.phone != null) Text('Telefone: ${request.phone}'),
                Text('Solicitado em: ${dateFormat.format(request.createdAt)}'),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // TODO: Implement reject functionality
                    },
                    icon: const Icon(Icons.close),
                    label: const Text('Rejeitar'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () => _approveRequest(request),
                    icon: const Icon(Icons.check),
                    label: const Text('Aprovar'),
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
