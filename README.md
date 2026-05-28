# Business Bosses Mobile App

The official Business Bosses mobile application built with Flutter. It features a marketplace, community feeds, business profile management, and AI-driven growth tools.

## Features

- **Marketplace**: Buy and sell products/services, post buyer requests, and explore partner deals.
- **Boss Up**: Community feed and social interaction for business owners.
- **Reach Score**: Real-time tracking of your business impact and visibility.
- **AI Integration**: AI-powered content generation and promotion.

## Setup Instructions

1.  **Prerequisites**:
    - Flutter SDK (Version 3.44.0 or compatible)
    - Android Studio / VS Code with Flutter extension
    - Java 17

2.  **Environment Setup**:
    - Create a `.env` file in the root directory.
    - Ensure you have the necessary signing keys if building for release (see `docs/ANDROID_SIGNING_GUIDE.md`).

3.  **Install Dependencies**:
    ```bash
    flutter pub get
    ```

4.  **Run the App**:
    ```bash
    flutter run
    ```

## Build Release APK

To build a release APK, ensure your environment is configured for signing and run:
```bash
flutter build apk --release
```
