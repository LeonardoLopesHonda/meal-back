import 'package:flutter/material.dart';
import 'package:meal_back/services/auth_service.dart';
import 'package:meal_back/services/validation_service.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Create Password Form
  final _createPasswordFormKey = GlobalKey<FormState>();
  final _createCpfController = TextEditingController();
  final _createNameController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _createPasswordLoading = false;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  // Request Registration Form
  final _requestFormKey = GlobalKey<FormState>();
  final _requestNameController = TextEditingController();
  final _requestCpfController = TextEditingController();
  final _requestEmailController = TextEditingController();
  final _requestPhoneController = TextEditingController();
  bool _requestLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _createCpfController.dispose();
    _createNameController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _requestNameController.dispose();
    _requestCpfController.dispose();
    _requestEmailController.dispose();
    _requestPhoneController.dispose();
    super.dispose();
  }

  Future<void> _createPassword() async {
    if (!_createPasswordFormKey.currentState!.validate()) return;

    if (_newPasswordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Senhas não conferem'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    setState(() => _createPasswordLoading = true);

    final result = await AuthService.createPassword(
      _createCpfController.text.trim(),
      _createNameController.text.trim(),
      _newPasswordController.text.trim(),
    );

    setState(() => _createPasswordLoading = false);

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
        Navigator.of(context).pop();
      }
    }
  }

  Future<void> _requestRegistration() async {
    if (!_requestFormKey.currentState!.validate()) return;

    setState(() => _requestLoading = true);

    final result = await AuthService.requestRegistration(
      name: _requestNameController.text.trim(),
      cpf: _requestCpfController.text.trim(),
      email: _requestEmailController.text.trim().isEmpty
          ? null
          : _requestEmailController.text.trim(),
      phone: _requestPhoneController.text.trim().isEmpty
          ? null
          : _requestPhoneController.text.trim(),
    );

    setState(() => _requestLoading = false);

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
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Acesso ao Sistema'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Criar Senha'),
            Tab(text: 'Solicitar Cadastro'),
          ],
          labelColor: Theme.of(context).colorScheme.primary,
          unselectedLabelColor: Theme.of(context).colorScheme.onSurfaceVariant,
          indicatorColor: Theme.of(context).colorScheme.primary,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildCreatePasswordTab(), _buildRequestRegistrationTab()],
      ),
    );
  }

  Widget _buildCreatePasswordTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            elevation: 0,
            color: Theme.of(
              context,
            ).colorScheme.surfaceVariant.withValues(alpha: 0.3),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Icon(
                    Icons.key,
                    size: 48,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Criar Senha',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Se seu CPF já está cadastrado na escola, você pode criar uma senha para acessar o sistema.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          Form(
            key: _createPasswordFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _createCpfController,
                  decoration: InputDecoration(
                    labelText: 'CPF',
                    hintText: '000.000.000-00',
                    prefixIcon: Icon(
                      Icons.badge_outlined,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                  ),
                  validator: ValidationService.validateCpf,
                  keyboardType: TextInputType.number,
                ),

                const SizedBox(height: 16),

                TextFormField(
                  controller: _createNameController,
                  decoration: InputDecoration(
                    labelText: 'Nome Completo',
                    prefixIcon: Icon(
                      Icons.person_outline,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                  ),
                  validator: ValidationService.validateName,
                  textCapitalization: TextCapitalization.words,
                ),

                const SizedBox(height: 16),

                TextFormField(
                  controller: _newPasswordController,
                  obscureText: _obscureNewPassword,
                  decoration: InputDecoration(
                    labelText: 'Nova Senha',
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureNewPassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureNewPassword = !_obscureNewPassword;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                  ),
                  validator: ValidationService.validatePassword,
                ),

                const SizedBox(height: 16),

                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  decoration: InputDecoration(
                    labelText: 'Confirmar Senha',
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                  ),
                  validator: ValidationService.validatePassword,
                ),

                const SizedBox(height: 24),

                FilledButton(
                  onPressed: _createPasswordLoading ? null : _createPassword,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  ),
                  child: _createPasswordLoading
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Theme.of(context).colorScheme.onPrimary,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text('Criar Senha'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestRegistrationTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            elevation: 0,
            color: Theme.of(
              context,
            ).colorScheme.surfaceVariant.withValues(alpha: 0.3),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Icon(
                    Icons.person_add,
                    size: 48,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Solicitar Cadastro',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Se você não está cadastrado na escola, envie uma solicitação de cadastro que será analisada pela administração.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          Form(
            key: _requestFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _requestNameController,
                  decoration: InputDecoration(
                    labelText: 'Nome Completo',
                    prefixIcon: Icon(
                      Icons.person_outline,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                  ),
                  validator: ValidationService.validateName,
                  textCapitalization: TextCapitalization.words,
                ),

                const SizedBox(height: 16),

                TextFormField(
                  controller: _requestCpfController,
                  decoration: InputDecoration(
                    labelText: 'CPF',
                    hintText: '000.000.000-00',
                    prefixIcon: Icon(
                      Icons.badge_outlined,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                  ),
                  validator: ValidationService.validateCpf,
                  keyboardType: TextInputType.number,
                ),

                const SizedBox(height: 16),

                TextFormField(
                  controller: _requestEmailController,
                  decoration: InputDecoration(
                    labelText: 'Email (opcional)',
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                  ),
                  validator: ValidationService.validateEmail,
                  keyboardType: TextInputType.emailAddress,
                ),

                const SizedBox(height: 16),

                TextFormField(
                  controller: _requestPhoneController,
                  decoration: InputDecoration(
                    labelText: 'Telefone (opcional)',
                    hintText: '(11) 99999-9999',
                    prefixIcon: Icon(
                      Icons.phone_outlined,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                  ),
                  validator: ValidationService.validatePhone,
                  keyboardType: TextInputType.phone,
                ),

                const SizedBox(height: 24),

                FilledButton(
                  onPressed: _requestLoading ? null : _requestRegistration,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  ),
                  child: _requestLoading
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Theme.of(context).colorScheme.onPrimary,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text('Enviar Solicitação'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
