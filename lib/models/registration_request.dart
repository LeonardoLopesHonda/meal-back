class RegistrationRequest {
  final String id;
  final String name;
  final String cpf;
  final String? email;
  final String? phone;
  final String status;
  final DateTime createdAt;
  final String? reviewedBy;
  final DateTime? reviewedAt;

  RegistrationRequest({
    required this.id,
    required this.name,
    required this.cpf,
    this.email,
    this.phone,
    this.status = 'pending',
    required this.createdAt,
    this.reviewedBy,
    this.reviewedAt,
  });

  factory RegistrationRequest.fromJson(Map<String, dynamic> json) =>
      RegistrationRequest(
        id: json['id'],
        name: json['name'],
        cpf: json['cpf'],
        email: json['email'],
        phone: json['phone'],
        status: json['status'] ?? 'pending',
        createdAt: DateTime.parse(json['createdAt']),
        reviewedBy: json['reviewedBy'],
        reviewedAt: json['reviewedAt'] != null
            ? DateTime.parse(json['reviewedAt'])
            : null,
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'cpf': cpf,
    'email': email,
    'phone': phone,
    'status': status,
    'createdAt': createdAt.toIso8601String(),
    'reviewedBy': reviewedBy,
    'reviewedAt': reviewedAt?.toIso8601String(),
  };

  bool get isPending => status == 'pending';
  bool get isApproved => status == 'approved';
  bool get isRejected => status == 'rejected';

  String get statusText {
    switch (status) {
      case 'pending':
        return 'Pendente';
      case 'approved':
        return 'Aprovado';
      case 'rejected':
        return 'Rejeitado';
      default:
        return status;
    }
  }
}
