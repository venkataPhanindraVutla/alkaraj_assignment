# Flutter Full-Stack CRUD Module

## Objective

This project implements a full-stack CRUD (Create, Read, Update, Delete) module in Flutter. The goal is to demonstrate understanding of API integration, local data persistence, UI updates, and basic app architecture using the BLoC pattern.

## Requirements Implemented

*   **Data Model:** Defined a data model for items (Tasks) including title, description, status, created date, and priority.
*   **UI Screens:** Implemented screens for listing, adding, editing, and deleting items.
*   **API Integration:** Integrated with Firebase for data storage and retrieval.
*   **Local Caching:** (To be implemented/detailed)
*   **Real-time UI Updates:** Ensured UI updates reflect changes.
*   **User Feedback:** Provided user feedback using mechanisms like Snackbars.
*   **State Management:** Used the BLoC (Business Logic Component) pattern.
*   **Error Handling:** Implemented error handling for data operations.
*   **Responsive UI:** Designed a UI that works on different screen sizes.

## Guidance Followed

*   Used `ListView` to display items.
*   Implemented deletion confirmation dialogs.
*   Used forms with validators for add/edit operations.
*   Used dedicated screens/dialogs for add/edit actions with proper navigation.
*   Organized code using a layered architecture (Data, Business Logic, Presentation).
*   Used the `flutter_bloc` package.
*   Considered dependency injection (details in Architecture Overview).
*   Implemented loading states and empty state handling.
*   Handled network connectivity changes (details in Technical Implementation Details).

## Technical Implementation Details

*   **Repository Pattern:** Implemented a repository pattern to abstract data sources.
*   **API Services:** Used Firebase SDKs for data operations.
*   **Error Handling & Retry:** Implemented error handling for data calls.
*   **JSON Serialization/Deserialization:** Handled data conversion for Firebase.
*   **Authentication:** Integrated Google Sign-In authentication.
*   **Reusable UI Components:** Created reusable widgets.
*   **Logging:** Added logging for debugging.
*   **Optimistic Updates:** (To be implemented/detailed)

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

Data operations are handled through the Firebase SDKs within the application, specifically interacting with Firestore collections.

## Usage Instructions

Once the application is set up and running, you can:

*   Sign in to the application using the Google Sign-In option.
*   View the list of items (Tasks) on the home screen.
*   Add new tasks using the add task button/dialog.
*   Tap on a task to view its details or edit it.
*   Swipe on a task (if implemented) or use a context menu to delete it.
*   Use filter controls (if implemented) to filter the task list.

## Architecture Overview

This project follows a layered architecture to ensure separation of concerns and maintainability:

*   **Presentation Layer (`lib/presentation/`):** Contains the UI components (screens and widgets) responsible for displaying data and handling user interaction. It consumes the BLoC for state updates and dispatches events.
*   **Business Logic Layer (`lib/business_logic/`):** Contains the BLoC (`lib/business_logic/bloc/`) for managing application state and business rules. Services (`lib/business_logic/services/`) handle specific operations and interact with the data layer.
*   **Data Layer (`lib/data/`):** Responsible for data fetching and storage. This includes repositories (`lib/data/repositories/`) that abstract data sources (Firebase/Firestore and potentially a local database like SQLite or Hive) and data models (`lib/data/models/`).
*   **Dependency Injection:** (Details on how dependency injection is used, e.g., using a package like `get_it` or `provider` to provide instances of services and repositories).

This structure promotes testability and allows for easier swapping of data sources or business logic implementations.

## Testing Information

(Details on testing strategy, types of tests included - unit, widget, integration, and how to run them)

## Evaluation Criteria

This project will be evaluated based on:

*   Flutter code organization and architecture.
*   API integration quality and error handling.
*   Flutter UI/UX design and responsiveness.
*   Error handling and edge cases in the Flutter application.
*   Flutter best practices and code quality.
*   Documentation quality and adherence to Flutter conventions.

## Bonus Features

List of implemented bonus features from the assignment : Search, Sorting/Filtering, Offline-first, Dark/Light Theme, Google Sign-In