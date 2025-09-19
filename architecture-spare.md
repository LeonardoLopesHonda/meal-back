# ClassMate - School Meal Feedback System Architecture

## Project Overview

ClassMate is a comprehensive school meal feedback system that allows students to provide feedback on school meals while giving administrators tools to manage reviews and analyze feedback data.

## Core Features (MVP)

### 1. Authentication System

- CPF-based login with password authentication
- New user registration with CPF validation
- Password creation for existing students
- Registration request system for new students
- Secure password hashing using crypto package

### 2. Student Features

- View open meal reviews
- Submit feedback with mandatory score (0-10) and optional comments
- View meal images when available
- One feedback per review limitation
- Profile management

### 3. Admin Features

- Create new meal reviews with description, date, period, shifts
- Manual review closure
- View comprehensive reports and statistics
- User management (approve registration requests)
- Dashboard with analytics

### 4. Reports & Analytics

- Overall average scores
- Score distribution (0-10)
- Response statistics
- Shift-based grouping
- Visual charts and graphs

## Technical Architecture

### Data Models

1. **User** - CPF, name, role (student/admin), contact info
2. **MealReview** - description, date, period, shifts, closure date
3. **Feedback** - user, review, score, comment, timestamp
4. **RegistrationRequest** - name, CPF, contact, status

### File Structure

```
lib/
├── main.dart
├── theme.dart
├── models/
│   ├── user.dart
│   ├── meal_review.dart
│   ├── feedback.dart
│   └── registration_request.dart
├── services/
│   ├── auth_service.dart
│   ├── storage_service.dart
│   └── validation_service.dart
├── screens/
│   ├── login_screen.dart
│   ├── registration_screen.dart
│   ├── home_screen.dart
│   ├── feedback_screen.dart
│   ├── admin_dashboard.dart
│   └── reports_screen.dart
└── widgets/
    ├── meal_card.dart
    ├── feedback_form.dart
    ├── score_selector.dart
    └── statistics_card.dart
```

### Storage Strategy

- SharedPreferences for local data persistence
- JSON serialization for complex objects
- Secure password storage with hash+salt

### Security Implementation

- Password hashing using crypto package
- CPF validation and formatting
- Input sanitization and validation
- Session management

### UI/UX Design

- Modern Material Design 3 components
- Purple-based color scheme matching theme
- Card-based layouts for content organization
- Responsive design for different screen sizes
- Intuitive navigation with proper user flow

## Implementation Steps

1. **Setup Dependencies** - Add required packages to pubspec.yaml
2. **Data Models** - Create all necessary data models with JSON serialization
3. **Services Layer** - Implement authentication, storage, and validation services
4. **Authentication Flow** - Build login, registration, and password creation screens
5. **Student Interface** - Implement meal review listing and feedback submission
6. **Admin Interface** - Create admin dashboard and review management
7. **Reports System** - Build analytics and reporting functionality
8. **Testing & Debugging** - Comprehensive testing and error handling
9. **Final Compilation** - Ensure all code compiles without errors

## Non-Functional Requirements

- Response time < 2 seconds
- Secure authentication with hashed passwords
- Simple and intuitive interface
- Cross-platform compatibility
- Operation logging for admin actions
- Offline-first architecture with local storage
