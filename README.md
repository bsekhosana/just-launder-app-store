# Just Launder Laundrette App

**Flutter Mobile Application for Laundrette/Tenant Owners**

## Overview

The Just Launder Laundrette App is a Flutter-based mobile application that enables laundrette owners to:

- Manage branches and branch configurations
- Manage staff members
- View and manage orders
- Track analytics and revenue
- Manage subscriptions
- Configure services and pricing
- View performance metrics

## Technologies

### Core Framework
- **Flutter SDK**: ^3.7.2
- **Dart**: ^3.7.2
- **State Management**: Provider (^6.1.2)

### Key Packages
- **Networking**: Dio (^5.4.0), HTTP (^1.1.0)
- **Firebase**: Firebase Core, Firebase Messaging (FCM)
- **State Management**: Provider
- **Charts**: Flutter Charts (for analytics)
- **Storage**: Shared Preferences
- **UI**: Google Fonts, Flutter Animate

### Architecture
- **Pattern**: Clean Architecture
- **Layers**: Domain, Data, Presentation
- **State Management**: Provider Pattern

## Project Structure

```
lib/
├── core/
│   ├── services/         # Core services
│   └── widgets/         # Reusable widgets
├── data/
│   ├── models/          # Data models
│   ├── services/        # Mock data services
│   └── datasources/     # Remote data sources
├── features/
│   ├── auth/            # Authentication
│   ├── branches/        # Branch management
│   ├── staff/           # Staff management
│   ├── orders/          # Order management
│   ├── analytics/       # Analytics dashboard
│   ├── profile/          # Tenant profile
│   └── settings/        # App settings
└── main.dart            # App entry point
```

## Coding Standards

### Dart/Flutter Standards

1. **Dart Style Guide**
   - Follow [Effective Dart](https://dart.dev/guides/language/effective-dart)
   - Use `flutter_lints` package (configured in `analysis_options.yaml`)
   - Run `flutter analyze` before committing

2. **Naming Conventions**
   - Files: snake_case (e.g., `branch_screen.dart`)
   - Classes: PascalCase (e.g., `BranchScreen`)
   - Variables/Methods: camelCase (e.g., `branchId`, `getBranchById()`)
   - Constants: lowerCamelCase with `k` prefix

3. **Code Organization**
   - One class per file
   - Group imports: Dart, Flutter, Package, Relative
   - Keep widgets small and focused
   - Use `const` constructors where possible

4. **State Management**
   - Use Provider for state management
   - Keep providers focused on single responsibility
   - Dispose resources properly
   - Handle loading and error states

5. **API Integration**
   - Use Repository pattern
   - Handle errors gracefully
   - Implement proper retry logic
   - Replace mock data with API calls

6. **Mock Data**
   - Currently uses `MockDataService` extensively
   - Priority: Replace with API integration
   - Keep mock data for development/testing

### Code Quality

```bash
# Analyze code
flutter analyze

# Format code
flutter format .

# Run tests
flutter test
```

## Setup Instructions

### Prerequisites
- Flutter SDK 3.7.2+
- Dart SDK 3.7.2+
- Android Studio / Xcode
- Firebase account (for FCM)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd just_laundrette_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**
   - Add `google-services.json` (Android)
   - Add `GoogleService-Info.plist` (iOS)

4. **Configure API endpoint**
   - Update API base URL in data sources
   - Set: `https://justlaunder.co.uk/api/v1`

5. **Run the app**
   ```bash
   flutter run
   ```

## API Integration Status

- **Authentication**: ✅ 100% API-connected
- **Staff Creation**: ✅ 100% API-connected
- **Profile**: ✅ 100% API-connected
- **Onboarding**: ✅ 100% API-connected
- **Notifications**: ✅ 100% API-connected
- **Branches**: ⚠️ Uses mock data (needs API integration)
- **Staff Listing**: ⚠️ Uses mock data (needs API integration)
- **Orders**: ⚠️ Uses mock data (needs API integration)
- **Analytics**: ⚠️ Uses mock data (needs API integration)
- **Profile/Subscription**: ⚠️ Uses mock data (needs API integration)

**Overall API Integration**: 30%

## Testing

```bash
# Run unit tests
flutter test

# Run integration tests
flutter test integration_test/

# Run with coverage
flutter test --coverage
```

## Build Instructions

### Android
```bash
flutter build apk --release
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

## Current Status

- **UI Completion**: 95%
- **API Integration**: 30%
- **Overall**: 50% Complete

See `/docs/currentstatus/` for detailed status reports.

## Contributing

1. Create a feature branch from `main`
2. Follow Dart/Flutter coding standards
3. Write tests for new features
4. Update documentation
5. Run `flutter analyze` before committing
6. Submit pull request

## License

Proprietary - All rights reserved
