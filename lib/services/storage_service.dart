import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meal_back/models/user.dart';
import 'package:meal_back/models/meal_review.dart';
import 'package:meal_back/models/feedback.dart';
import 'package:meal_back/models/registration_request.dart';

class StorageService {
  static const String _usersKey = 'users';
  static const String _reviewsKey = 'meal_reviews';
  static const String _feedbackKey = 'feedback';
  static const String _requestsKey = 'registration_requests';
  static const String _currentUserKey = 'current_user';
  static const String _passwordsKey = 'passwords';

  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // User Management
  static Future<List<User>> getUsers() async {
    await init();
    final String? usersJson = _prefs!.getString(_usersKey);
    if (usersJson == null) return [];

    final List<dynamic> usersList = json.decode(usersJson);
    return usersList.map((json) => User.fromJson(json)).toList();
  }

  static Future<void> saveUsers(List<User> users) async {
    await init();
    final String usersJson = json.encode(
      users.map((user) => user.toJson()).toList(),
    );
    await _prefs!.setString(_usersKey, usersJson);
  }

  static Future<User?> getUserById(String id) async {
    final users = await getUsers();
    try {
      return users.firstWhere((user) => user.id == id);
    } catch (e) {
      return null;
    }
  }

  static Future<User?> getUserByCpf(String cpf) async {
    final users = await getUsers();
    try {
      return users.firstWhere((user) => user.cpf == cpf);
    } catch (e) {
      return null;
    }
  }

  // Current User Session
  static Future<User?> getCurrentUser() async {
    await init();
    final String? userJson = _prefs!.getString(_currentUserKey);
    if (userJson == null) return null;
    return User.fromJson(json.decode(userJson));
  }

  static Future<void> setCurrentUser(User user) async {
    await init();
    await _prefs!.setString(_currentUserKey, json.encode(user.toJson()));
  }

  static Future<void> clearCurrentUser() async {
    await init();
    await _prefs!.remove(_currentUserKey);
  }

  // Password Management
  static Future<Map<String, String>> getPasswords() async {
    await init();
    final String? passwordsJson = _prefs!.getString(_passwordsKey);
    if (passwordsJson == null) return {};
    return Map<String, String>.from(json.decode(passwordsJson));
  }

  static Future<void> savePassword(String cpf, String hashedPassword) async {
    await init();
    final passwords = await getPasswords();
    passwords[cpf] = hashedPassword;
    await _prefs!.setString(_passwordsKey, json.encode(passwords));
  }

  // Meal Reviews
  static Future<List<MealReview>> getMealReviews() async {
    await init();
    final String? reviewsJson = _prefs!.getString(_reviewsKey);
    if (reviewsJson == null) return [];

    final List<dynamic> reviewsList = json.decode(reviewsJson);
    return reviewsList.map((json) => MealReview.fromJson(json)).toList();
  }

  static Future<void> saveMealReviews(List<MealReview> reviews) async {
    await init();
    final String reviewsJson = json.encode(
      reviews.map((review) => review.toJson()).toList(),
    );
    await _prefs!.setString(_reviewsKey, reviewsJson);
  }

  static Future<MealReview?> getMealReviewById(String id) async {
    final reviews = await getMealReviews();
    try {
      return reviews.firstWhere((review) => review.id == id);
    } catch (e) {
      return null;
    }
  }

  // Feedback
  static Future<List<FeedbackModel>> getFeedback() async {
    await init();
    final String? feedbackJson = _prefs!.getString(_feedbackKey);
    if (feedbackJson == null) return [];

    final List<dynamic> feedbackList = json.decode(feedbackJson);
    return feedbackList.map((json) => FeedbackModel.fromJson(json)).toList();
  }

  static Future<void> saveFeedback(List<FeedbackModel> feedback) async {
    await init();
    final String feedbackJson = json.encode(
      feedback.map((f) => f.toJson()).toList(),
    );
    await _prefs!.setString(_feedbackKey, feedbackJson);
  }

  static Future<List<FeedbackModel>> getFeedbackForReview(
    String reviewId,
  ) async {
    final allFeedback = await getFeedback();
    return allFeedback.where((f) => f.reviewId == reviewId).toList();
  }

  static Future<FeedbackModel?> getUserFeedbackForReview(
    String userId,
    String reviewId,
  ) async {
    final allFeedback = await getFeedback();
    try {
      return allFeedback.firstWhere(
        (f) => f.userId == userId && f.reviewId == reviewId,
      );
    } catch (e) {
      return null;
    }
  }

  // Registration Requests
  static Future<List<RegistrationRequest>> getRegistrationRequests() async {
    await init();
    final String? requestsJson = _prefs!.getString(_requestsKey);
    if (requestsJson == null) return [];

    final List<dynamic> requestsList = json.decode(requestsJson);
    return requestsList
        .map((json) => RegistrationRequest.fromJson(json))
        .toList();
  }

  static Future<void> saveRegistrationRequests(
    List<RegistrationRequest> requests,
  ) async {
    await init();
    final String requestsJson = json.encode(
      requests.map((request) => request.toJson()).toList(),
    );
    await _prefs!.setString(_requestsKey, requestsJson);
  }

  // Initialize sample data
  static Future<void> initializeSampleData() async {
    final users = await getUsers();
    if (users.isEmpty) {
      // Create admin user
      final admin = User(
        id: 'admin_001',
        cpf: '12345678901',
        name: 'Administrador Sistema',
        role: 'admin',
        email: 'admin@escola.com',
        createdAt: DateTime.now(),
      );

      // Create sample students
      final students = [
        User(
          id: 'student_001',
          cpf: '98765432100',
          name: 'Ana Silva',
          role: 'student',
          email: 'ana@email.com',
          createdAt: DateTime.now(),
        ),
        User(
          id: 'student_002',
          cpf: '11122233344',
          name: 'Carlos Santos',
          role: 'student',
          phone: '(11) 99999-9999',
          createdAt: DateTime.now(),
        ),
      ];

      await saveUsers([admin, ...students]);

      // Set default passwords
      await savePassword('12345678901', 'admin123'); // Admin password
      await savePassword('98765432100', 'ana123'); // Ana password
    }

    final reviews = await getMealReviews();
    if (reviews.isEmpty) {
      final sampleReviews = [
        MealReview(
          id: 'review_001',
          description: 'Arroz, feijão, frango grelhado e salada verde',
          dateOffered: DateTime.now().subtract(const Duration(days: 1)),
          period: 'afternoon',
          shifts: ['Tarde A', 'Tarde B'],
          closureDate: DateTime.now().add(const Duration(days: 2)),
          imageUrl:
              'https://img.freepik.com/fotos-premium/arroz-feijao-frango-grelhado-file-salada-farofa_538646-12942.jpg',
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
          createdBy: 'admin_001',
        ),
        MealReview(
          id: 'review_002',
          description: 'Macarrão ao molho de tomate com carne moída',
          dateOffered: DateTime.now(),
          period: 'morning',
          shifts: ['Manhã A', 'Manhã B'],
          closureDate: DateTime.now().add(const Duration(days: 1)),
          imageUrl:
              'https://vovonaoca.com.br/wp-content/uploads/2023/09/Macarrao-com-Carne-Moida.jpg',
          createdAt: DateTime.now(),
          createdBy: 'admin_001',
        ),
      ];

      await saveMealReviews(sampleReviews);
    }
  }
}
