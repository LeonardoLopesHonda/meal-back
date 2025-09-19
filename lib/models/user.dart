class User {
  final String id;
  final String cpf;
  final String name;
  final String role;
  final String? email;
  final String? phone;
  final DateTime createdAt;

  User({
    required this.id,
    required this.cpf,
    required this.name,
    required this.role,
    this.email,
    this.phone,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'],
    cpf: json['cpf'],
    name: json['name'],
    role: json['role'],
    email: json['email'],
    phone: json['phone'],
    createdAt: DateTime.parse(json['createdAt']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'cpf': cpf,
    'name': name,
    'role': role,
    'email': email,
    'phone': phone,
    'createdAt': createdAt.toIso8601String(),
  };

  bool get isAdmin => role == 'admin';
  bool get isStudent => role == 'student';
}
