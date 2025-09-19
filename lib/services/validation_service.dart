class ValidationService {
  static String? validateCpf(String? value) {
    if (value == null || value.isEmpty) {
      return 'CPF é obrigatório';
    }

    // Remove non-digits
    String cpf = value.replaceAll(RegExp(r'[^0-9]'), '');

    // Check length
    if (cpf.length != 11) {
      return 'CPF deve ter 11 dígitos';
    }

    // Check for repeated digits
    if (RegExp(r'^(\d)\1+\$').hasMatch(cpf)) {
      return 'CPF inválido';
    }

    return null;
  }

  static bool _isValidCpf(String cpf) {
    List<int> digits = cpf.split('').map(int.parse).toList();

    // First verification digit
    int sum = 0;
    for (int i = 0; i < 9; i++) {
      sum += digits[i] * (10 - i);
    }
    int remainder = sum % 11;
    int firstDigit = remainder < 2 ? 0 : 11 - remainder;

    if (digits[9] != firstDigit) return false;

    // Second verification digit
    sum = 0;
    for (int i = 0; i < 10; i++) {
      sum += digits[i] * (11 - i);
    }
    remainder = sum % 11;
    int secondDigit = remainder < 2 ? 0 : 11 - remainder;

    return digits[10] == secondDigit;
  }

  static String formatCpf(String cpf) {
    // Remove non-digits
    cpf = cpf.replaceAll(RegExp(r'[^0-9]'), '');

    if (cpf.length != 11) return cpf;

    return '${cpf.substring(0, 3)}.${cpf.substring(3, 6)}.${cpf.substring(6, 9)}-${cpf.substring(9, 11)}';
  }

  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nome é obrigatório';
    }

    if (value.trim().length < 3) {
      return 'Nome deve ter pelo menos 3 caracteres';
    }

    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Senha é obrigatória';
    }

    if (value.length < 6) {
      return 'Senha deve ter pelo menos 6 caracteres';
    }

    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Email is optional
    }

    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Email inválido';
    }

    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Phone is optional
    }

    // Remove non-digits
    String phone = value.replaceAll(RegExp(r'[^0-9]'), '');

    if (phone.length < 10 || phone.length > 11) {
      return 'Telefone deve ter 10 ou 11 dígitos';
    }

    return null;
  }

  static String formatPhone(String phone) {
    // Remove non-digits
    phone = phone.replaceAll(RegExp(r'[^0-9]'), '');

    if (phone.length == 10) {
      return '(${phone.substring(0, 2)}) ${phone.substring(2, 6)}-${phone.substring(6, 10)}';
    } else if (phone.length == 11) {
      return '(${phone.substring(0, 2)}) ${phone.substring(2, 7)}-${phone.substring(7, 11)}';
    }

    return phone;
  }

  static String? validateScore(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nota é obrigatória';
    }

    final score = int.tryParse(value.trim());
    if (score == null) {
      return 'Nota deve ser um número';
    }

    if (score < 0 || score > 10) {
      return 'Nota deve estar entre 0 e 10';
    }

    return null;
  }

  static String? validateMealDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Descrição é obrigatória';
    }

    if (value.trim().length < 10) {
      return 'Descrição deve ter pelo menos 10 caracteres';
    }

    return null;
  }
}
