# NirogGram Architecture

## Tech Stack
- Flutter
- Firebase Authentication
- Cloud Firestore
- Firebase Storage
- Google Maps Flutter
- Feature-based clean architecture

## Folder Structure (High Level)

```text
lib/
  app/
  core/
  features/
    auth/
    user_dashboard/
    complaints/
    admin/
```

## Folder Purpose

### lib/app
- `app.dart`: Root app widget.
- `router.dart`: Named routes and page mapping.
- `theme.dart`: App theme and color scheme.
- `app_initializer.dart`: Firebase init + dependency setup.

### lib/core
Shared utilities used by every feature.

- `constants/`: Enums and static constants.
- `di/`: GetIt service registration.
- `services/`: Firebase auth, complaint data, location, image upload.
- `utils/`: Shared formatters and helpers.
- `widgets/`: Shared UI widgets (example: primary button).

### lib/features/auth
Authentication flow and user account domain.

- `domain/entities/`: Core auth entities (`AppUser`).
- `presentation/controllers/`: Auth state handling.
- `presentation/pages/`: Login and registration UI.

### lib/features/user_dashboard
User-facing home dashboard.

- `presentation/pages/user_home_page.dart`: Entry page for villagers.

### lib/features/complaints
Sanitation issue reporting + tracking.

- `domain/entities/`: Complaint entity and serialization.
- `presentation/controllers/`: Report and history controllers.
- `presentation/pages/`: Report issue, history list, map screen.

### lib/features/admin
Admin workflow for complaint management.

- `presentation/controllers/`: Complaint stream and status updates.
- `presentation/pages/`: Admin login and dashboard.

## Firebase Collections

### users/{uid}
- uid
- name
- email
- role (`villager` or `admin`)
- createdAt

### complaints/{complaintId}
- id
- userId
- issueType (`garbage_dump`, `dirty_water`, `blocked_drainage`, `other`)
- description
- imageUrl
- latitude
- longitude
- status (`pending`, `inProgress`, `resolved`)
- createdAt
- updatedAt

## Status Flow
- `pending`
- `inProgress`
- `resolved`

## Setup Notes
1. Configure Firebase project and platform files (`google-services.json`, `GoogleService-Info.plist`).
2. Add Google Maps API key in Android/iOS configuration.
3. Enable Firestore and Storage rules deployment from root files:
   - `firestore.rules`
   - `firestore.indexes.json`
   - `firebase.json`
4. Run:
   - `flutter pub get`
   - `flutter analyze`
   - `flutter test`

## Current State of Scaffold
- Project compiles with `flutter analyze`.
- Tests pass with `flutter test`.
- End-to-end UI flows are scaffolded for both villager and admin.
- Production hardening needed for repository/use case layers, exhaustive validation, and robust error mapping.
