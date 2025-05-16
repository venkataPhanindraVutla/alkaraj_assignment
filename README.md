# Alkaraj Assignment

This is a Flutter project for the Alkaraj assignment.

## Setup Instructions

To set up and run this project locally, follow these steps:

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/venkataPhanindraVutla/alkaraj_assignment
    cd alkaraj_assignment
    ```

2.  **Install Flutter:**
    If you don't have Flutter installed, follow the official guide: [Install Flutter](https://docs.flutter.dev/get-started/install)

3.  **Get dependencies:**
    Navigate to the project directory and run:
    ```bash
    flutter pub get
    ```

4.  **Set up Firebase:**
    This project uses Firebase. You need to set up a Firebase project and add the configuration files (`google-services.json` for Android and `GoogleService-Info.plist` for iOS) to the respective platform directories (`android/app/` and `ios/Runner/`).
    Refer to the official Firebase documentation for detailed steps: [Add Firebase to your Flutter app](https://firebase.google.com/docs/flutter/setup)

5.  **Run the application:**
    Connect a device or start an emulator and run:
    ```bash
    flutter run
    ```

## API Endpoints Documentation

This project primarily interacts with Firebase services for data storage and retrieval. There is no separate backend server with traditional REST API endpoints.

Data operations are handled through the Firebase SDKs within the application.

## Usage Instructions

Once the application is set up and running, you can:

-   Navigate through the different screens (e.g., Home, Splash).
-   Interact with UI elements like the task list and filter controls.
-   Add new tasks using the add task bottom sheet.
-   View task details using the task detail dialog.

Specific usage flows and features would be detailed here.

-   Sign in to the application using the Google Sign-In option.

## Architecture Overview

This project appears to follow a layered architecture, common in Flutter applications using state management patterns like BLoC (based on the presence of `lib/business_logic/bloc/item_bloc.dart`).

-   **Presentation Layer:** Contains the UI components (screens and widgets) responsible for displaying data and handling user interaction (`lib/presentation/`).
-   **Business Logic Layer:** Contains the BLoC for managing application state and business rules (`lib/business_logic/bloc/`). Services like `ItemService` handle specific operations (`lib/business_logic/services/`).
-   **Data Layer:** Responsible for data fetching and storage. This includes repositories (`lib/data/repositories/`) and potentially local databases (`lib/data/local_database/`) or remote data sources (Firebase).
-   **Models:** Data structures used throughout the application (`lib/data/models/`).

This structure promotes separation of concerns and testability.

