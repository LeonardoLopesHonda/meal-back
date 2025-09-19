import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:meal_back/models/user.dart';
import 'package:meal_back/models/registration_request.dart';
import 'package:meal_back/services/storage_service.dart';

class AuthService {
  static User? _currentUser;

  static User? get currentUser => _currentUser;

  static Future<void> initialize() async {
    _currentUser = await StorageService.getCurrentUser();
  }

  static String _generateSalt() {
    final random = Random.secure();
    final saltBytes = List<int>.generate(32, (i) => random.nextInt(256));
    return base64.encode(saltBytes);
  }

  static String _hashPassword(String password, String salt) {
    final saltedPassword = password + salt;
    final bytes = utf8.encode(saltedPassword);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  static Future<AuthResult> login(String cpf, String password) async {
    try {
      // Clean CPF
      final cleanCpf = cpf.replaceAll(RegExp(r'[^0-9]'), '');

      // Get user by CPF
      final user = await StorageService.getUserByCpf(cleanCpf);
      if (user == null) {
        return AuthResult.error('Usuário não encontrado');
      }

      // Check if user has a password
      final passwords = await StorageService.getPasswords();
      final storedHash = passwords[cleanCpf];
      if (storedHash == null) {
        return AuthResult.error('Usuário não possui senha cadastrada');
      }

      // For demo purposes, we'll use simple password hashing
      // In a real app, you'd use proper salt and hashing
      final hashedInput = _hashPassword(password, 'demo_salt');

      if (storedHash == password || storedHash == hashedInput) {
        // Allow direct comparison for demo
        _currentUser = user;
        await StorageService.setCurrentUser(user);
        return AuthResult.success(user);
      } else {
        return AuthResult.error('Senha incorreta');
      }
    } catch (e) {
      return AuthResult.error('Erro ao fazer login: \$e');
    }
  }

  static Future<AuthResult> createPassword(
    String cpf,
    String name,
    String password,
  ) async {
    try {
      // Clean CPF
      final cleanCpf = cpf.replaceAll(RegExp(r'[^0-9]'), '');

      // Check if user exists with this CPF and name
      final user = await StorageService.getUserByCpf(cleanCpf);
      if (user == null) {
        return AuthResult.error('CPF não encontrado na base de dados');
      }

      if (user.name.toLowerCase() != name.toLowerCase()) {
        return AuthResult.error('Nome não confere com o CPF informado');
      }

      // Check if user already has a password
      final passwords = await StorageService.getPasswords();
      if (passwords.containsKey(cleanCpf)) {
        return AuthResult.error('Usuário já possui senha cadastrada');
      }

      // Create password hash
      final salt = _generateSalt();
      final hashedPassword = _hashPassword(password, salt);

      // For demo purposes, store simple password
      await StorageService.savePassword(cleanCpf, password);

      return AuthResult.success(user, message: 'Senha criada com sucesso');
    } catch (e) {
      return AuthResult.error('Erro ao criar senha: \$e');
    }
  }

  static Future<AuthResult> requestRegistration({
    required String name,
    required String cpf,
    String? email,
    String? phone,
  }) async {
    try {
      // Clean CPF
      final cleanCpf = cpf.replaceAll(RegExp(r'[^0-9]'), '');

      // Check if user already exists
      final existingUser = await StorageService.getUserByCpf(cleanCpf);
      if (existingUser != null) {
        return AuthResult.error('CPF já cadastrado no sistema');
      }

      // Check if there's already a pending request
      final requests = await StorageService.getRegistrationRequests();
      final existingRequest = requests
          .where((r) => r.cpf == cleanCpf && r.isPending)
          .isNotEmpty;
      if (existingRequest) {
        return AuthResult.error(
          'Já existe uma solicitação pendente para este CPF',
        );
      }

      // Create registration request
      final request = RegistrationRequest(
        id: 'req_${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        cpf: cleanCpf,
        email: email,
        phone: phone,
        createdAt: DateTime.now(),
      );

      requests.add(request);
      await StorageService.saveRegistrationRequests(requests);

      return AuthResult.success(
        null,
        message: 'Solicitação enviada para análise',
      );
    } catch (e) {
      return AuthResult.error('Erro ao enviar solicitação: \$e');
    }
  }

  static Future<void> logout() async {
    _currentUser = null;
    await StorageService.clearCurrentUser();
  }

  static bool get isLoggedIn => _currentUser != null;
  static bool get isAdmin => _currentUser?.isAdmin ?? false;
  static bool get isStudent => _currentUser?.isStudent ?? false;

  static Future<AuthResult> approveRegistrationRequest(String requestId) async {
    try {
      final requests = await StorageService.getRegistrationRequests();
      final requestIndex = requests.indexWhere((r) => r.id == requestId);

      if (requestIndex == -1) {
        return AuthResult.error('Solicitação não encontrada');
      }

      final request = requests[requestIndex];

      // Create new user
      final newUser = User(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        cpf: request.cpf,
        name: request.name,
        role: 'student',
        email: request.email,
        phone: request.phone,
        createdAt: DateTime.now(),
      );

      // Add user to users list
      final users = await StorageService.getUsers();
      users.add(newUser);
      await StorageService.saveUsers(users);

      // Update request status
      requests[requestIndex] = RegistrationRequest(
        id: request.id,
        name: request.name,
        cpf: request.cpf,
        email: request.email,
        phone: request.phone,
        status: 'approved',
        createdAt: request.createdAt,
        reviewedBy: _currentUser?.id,
        reviewedAt: DateTime.now(),
      );

      await StorageService.saveRegistrationRequests(requests);

      return AuthResult.success(
        newUser,
        message: 'Solicitação aprovada com sucesso',
      );
    } catch (e) {
      return AuthResult.error('Erro ao aprovar solicitação: \$e');
    }
  }
}

class AuthResult {
  final bool success;
  final User? user;
  final String? error;
  final String? message;

  AuthResult.success(this.user, {this.message}) : success = true, error = null;
  AuthResult.error(this.error) : success = false, user = null, message = null;
}
