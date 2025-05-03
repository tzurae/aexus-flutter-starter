<br />
<div style="text-align: center; width: 100%;">
  <img src="./assets/images/aexus.svg" alt="aexus logo" style="width: 100%;">
</div>

---
# Aexus 


Welcome! 👋 

**Aexus** provides a robust starter kit for building Flutter applications using **Clean Architecture** principles.
It's designed to be scalable, maintainable, and testable, incorporating many best practices and common features needed for modern app development.
Whether you're starting a new project or looking for a solid foundation, this template aims to accelerate your development process.

## Table of Contents

*   [Why Use This Starter Kit?](#why-use-this-starter-kit)
*   [Architecture Overview](#architecture-overview)
    *   [The Layers](#the-layers)
    *   [Dependency Rule](#dependency-rule)
*   [Key Features](#key-features-)
*   [Getting Started](#getting-started-)
    *   [Prerequisites](#prerequisites)
    *   [Setup Steps](#setup-steps)
*   [Renaming the Project](#renaming-the-project-)
*   [How to Add a Feature (Examples)](#how-to-add-a-feature-examples-)
    *   [Example 1: Fetching User Profile](#example-1-fetching-user-profile)
    *   [Example 2: Adding a Setting Toggle](#example-2-adding-a-setting-toggle)
*   [Core Technologies](#core-technologies-)
*   [Contributing](#contributing-)
*   [License](#license-)

## Why Use This Starter Kit?

Building apps that grow complex over time requires a solid architectural foundation. This starter kit leverages **Clean Architecture** to achieve:

*   ✨ **Separation of Concerns:** Business logic is independent of UI, frameworks, and databases.
*   🔧 **Maintainability:** Changes in one layer (like swapping a database) have minimal impact on others.
*   🧪 **Testability:** Core business logic and application use cases can be tested without UI or external dependencies.
*   🏗️ **Scalability:** The modular structure makes it easier to add new features and manage complexity as the app grows.
*   🚀 **Productivity:** Includes pre-configured setup for common tasks like routing, state management, networking, and more, letting you focus on features faster.

## Architecture Overview

This project follows the principles of Clean Architecture, dividing the application into distinct layers with specific responsibilities.

### The Layers

The codebase is organized into packages, each representing a layer:

1.  **`packages/domains` (Domain Layer):**
    *   **Heart of the Application:** Contains the core business logic and rules, completely independent of any UI or infrastructure details.
    *   **Contents:** Entities (like `User`, `Post`), Value Objects, and *interfaces* for Repositories (contracts for data access, e.g., `AuthRepository`).
    *   **Key Principle:** Knows *nothing* about the layers outside it.

2.  **`packages/applications` (Application Layer):**
    *   **Orchestrator:** Contains application-specific logic (Use Cases) that coordinates the flow of data between the UI and the Domain layer.
    *   **Contents:** Use Case implementations (e.g., `LoginUseCase`, `GetPostsUseCase`), Data Transfer Objects (DTOs) for moving data between layers, and Mappers to convert between Domain Entities and DTOs.
    *   **Key Principle:** Depends only on the `domains` layer.

3.  **`packages/infra` (Infrastructure Layer):**
    *   **External Interactions:** Handles all communication with the outside world – databases, network APIs, device sensors, third-party SDKs.
    *   **Contents:** Concrete implementations of Repository interfaces (e.g., `AuthRepositoryImpl`), API clients (`DioClient`, `SupabaseClientWrapper`), local/remote data source abstractions, and infrastructure-specific utilities (error handling, encryption).
    *   **Key Principle:** Implements interfaces defined in `domains` and depends on `domains` (and sometimes `applications` for DTOs). Handles the "how" of data persistence and retrieval.

4.  **`packages/presentation` (Presentation Layer):**
    *   **User Interface:** Manages everything the user sees and interacts with.
    *   **Contents:** Screens/Pages, Widgets, State Management logic (Bloc/Cubit stores like `AuthStore`, `PostListStore`), UI constants (colors, themes, assets), navigation logic (`AppRouter`), and UI utilities.
    *   **Key Principle:** Depends on the `applications` layer to trigger actions and receive data (usually via DTOs).

5.  **Root `lib/` Directory:**
    *   **Entry Point & Globals:** Contains the main application entry point (`main.dart`), global service initialization (Dependency Injection, Logging, Configuration), and core shared services or constants.

### Dependency Rule

Crucially, dependencies flow **inwards**:

`Presentation` -> `Application` -> `Domain` <- `Infrastructure`

The `Domain` layer is the center and knows nothing about the outer layers. The `Infrastructure` layer implements interfaces defined in the `Domain` layer, effectively inverting the dependency. This makes the core logic independent and replaceable.

```
+-------------------+      +------------------+      +----------------+      +----------------------+
| Presentation      | ---> | Application      | ---> | Domain         | <--- | Infrastructure       |
| (UI, State Mgmt)  |      | (Use Cases, DTOs)|      | (Entities,Rules|      | (DB, API, Devices)   |
| depends on App    |      | depends on Domain|      | Interfaces)    |      | implements Domain    |
+-------------------+      +------------------+      +----------------+      +----------------------+
```

## Key Features 🚀

This starter kit comes packed with features to get you going:

*   🧱 **Layered Architecture:** Enforces Clean Architecture for maintainability and testability.
*   🔄 **State Management:** Predictable state management using Flutter Bloc / Cubit.
*   💉 **Dependency Injection:** `get_it` configured for easy dependency management across layers.
*   🧭 **Routing:** Declarative, type-safe navigation powered by `go_router`.
*   🌐 **Networking:** Robust HTTP requests using `dio`, including interceptors for logging, retries, and auth.
*   🔒 **Authentication:** Example flow using Supabase Auth (easily adaptable).
*   💾 **Local Storage:**
    *   `shared_preferences` for simple key-value pairs (settings, auth status).
    *   `sembast` example structure for embedded NoSQL storage, including encryption (`xxtea`).
*   ☁️ **Remote Data:** Supabase integration example (Auth uses Supabase client, Posts use Dio - adaptable).
*   ⚙️ **Configuration Management:** Environment-specific settings using `.env` files via `flutter_dotenv`.
*   📝 **Logging:** Flexible custom logging (`core/logger`) with levels, formatting, and multiple output options (Console included, easy to add File, Analytics, etc.).
*   ⚠️ **Error Handling:** Centralized (`GlobalErrorStore`) and localized error handling patterns.
*   🎨 **Theming:** Dynamic light/dark theme support (`ThemeStore`).
*   🌍 **Localization (i18n):** Multi-language support using JSON files (`LanguageStore`, `AppLocalizations`).
*   ⚙️ **Code Generation:** Uses `build_runner` for essential code generation (DI, potentially JSON serialization).
*   💻 **Cross-Platform Ready:** Base structure supports iOS, Android, Web, Linux, macOS, and Windows.

## Getting Started 🏁

Ready to dive in? Follow these steps:

### Prerequisites

*   [Flutter SDK](https://docs.flutter.dev/get-started/install) installed.
*   An IDE like [VS Code](https://code.visualstudio.com/) or [Android Studio](https://developer.android.com/studio) with Flutter plugins.
*   (For Renaming Script) A Bash-compatible shell (Linux, macOS, Git Bash/WSL on Windows).

### Setup Steps

1.  **Clone the Repository:**
    Choose a name for your new project directory.
    ```bash
    git clone https://github.com/your-username/flutter_starter-main.git your_new_project_name
    cd your_new_project_name
    ```
    *(Replace `https://github.com/your-username/flutter_starter-main.git` with the actual repository URL)*

2.  **(Recommended) Rename the Project:**
    Use the provided script to update project identifiers. See the [Renaming the Project](#renaming-the-project-) section below for details.

3.  **Install Dependencies:**
    Fetch all the required packages.
    ```bash
    flutter pub get
    ```

4.  **Configure Environment:**
    *   This project uses `--dart-define` for environment configuration rather than `.env` files.
    *   Required environment variables:
    ```
        ENV=dev|test|prod         # Application environment
        SUPABASE_URL=your_url     # Your Supabase project URL
        SUPABASE_ANON_KEY=your_key # Your Supabase anonymous key
        XXTEA_PASSWORD=your_password # Password for local database encryption
    ```
*   When running from command line:
    ```bash
    flutter run --dart-define=ENV=dev --dart-define=SUPABASE_URL=your_url --dart-define=SUPABASE_ANON_KEY=your_key --dart-define=XXTEA_PASSWORD=your_password
    ```
*   For production builds:
    ```bash
    flutter build apk --dart-define=ENV=prod --dart-define=SUPABASE_URL=your_url --dart-define=SUPABASE_ANON_KEY=your_key --dart-define=XXTEA_PASSWORD=your_password
    ```

### IDE Configuration for Sensitive Information

#### VS Code
1. Create a `launch.json` file in the `.vscode` folder (create if it doesn't exist):
   ```json
   {
     "version": "0.2.0",
     "configurations": [
       {
         "name": "Flutter Development",
         "request": "launch",
         "type": "dart",
         "args": [
           "--dart-define=ENV=dev",
           "--dart-define=SUPABASE_URL=your_url",
           "--dart-define=SUPABASE_ANON_KEY=your_key",
           "--dart-define=XXTEA_PASSWORD=your_password"
         ]
       },
       {
         "name": "Flutter Production",
         "request": "launch",
         "type": "dart",
         "args": [
           "--dart-define=ENV=prod",
           "--dart-define=SUPABASE_URL=your_url",
           "--dart-define=SUPABASE_ANON_KEY=your_key",
           "--dart-define=XXTEA_PASSWORD=your_password"
         ]
       }
     ]
   }
   ```
2. Add `.vscode/launch.json` to your `.gitignore` file to avoid committing secrets.
3. For team sharing, you can create a `launch.json.example` with placeholders instead of real values.

#### JetBrains IDEs (IntelliJ IDEA, Android Studio)
1. Go to **Run** > **Edit Configurations**.
2. Select your Flutter application configuration.
3. In the **Additional run args** field, add:
   ```
   --dart-define=ENV=dev --dart-define=SUPABASE_URL=your_url --dart-define=SUPABASE_ANON_KEY=your_key --dart-define=XXTEA_PASSWORD=your_password
   ```
4. For different environments, create multiple run configurations with appropriate variables.
5. For secure team sharing:
    * Use the Jetbrains built-in passwords safe to store sensitive values
    * Create shared run configurations with placeholders using `$VARIABLE_NAME$` syntax
    * Each developer can define their own values in Environment Variables settings

### CI/CD Configuration

For CI/CD pipelines, securely store these values as encrypted environment variables or secrets in your CI/CD provider (GitHub Actions, CircleCI, etc.) and pass them during build steps.

5.  **Run Code Generation:**
    This project relies on code generation (e.g., for `get_it` dependency injection setup). Run this command once:
    ```bash
    flutter pub run build_runner build --delete-conflicting-outputs
    ```
    *   **Development Tip:** For automatic regeneration whenever you save relevant files, use the `watch` command:
        ```bash
        flutter pub run build_runner watch --delete-conflicting-outputs
        ```

6.  **Run the Application:**
    Launch the app on your desired emulator, simulator, or device.
    ```bash
    flutter run
    ```

## Renaming the Project 🏷️

A helper script (`rename_flutter_project.sh`) is included to automate renaming the project across various configuration files (Flutter, Android, iOS, etc.).

**Important:** Run this script *before* making significant code changes.

**Steps:**

1.  **Navigate to Root:** Ensure you are in the root directory of your cloned project in your terminal.
2.  **Grant Execute Permissions:**
    ```bash
    chmod +x rename_flutter_project.sh
    ```
3.  **Run the Script:**
    ```bash
    ./rename_flutter_project.sh
    ```
4.  **Follow Prompts:**
    *   Enter the new **project name** (e.g., `my_cool_app` - lowercase with underscores).
    *   Enter the new **package name** (e.g., `com.mycompany.mycoolapp` - reverse domain format).
    *   Enter the new **display name** (e.g., `My Cool App` - the name users see).
    *   Carefully review the proposed changes and confirm with `y` or `Y`.

## How to Add a Feature (Examples) 💡

Here’s how the architecture guides feature development:

### Example 1: Fetching User Profile

**Goal:** Create a screen to show the logged-in user's profile (name, email).

1.  **`domains` Layer:**
    *   Define a `UserProfile` entity (if needed, maybe `User` is enough) in `packages/domains/lib/entity/user/`.
    *   Add a method contract to `UserRepository` (`packages/domains/lib/user/user_repository.dart` - create if doesn't exist):
        ```dart
        abstract class UserRepository {
          Future<UserProfile> getUserProfile(String userId);
          // ... other user-related methods
        }
        ```

2.  **`applications` Layer:**
    *   Create `UserProfileDTO` (`packages/applications/lib/dto/`) if the UI needs a specific data shape.
    *   Create `UserProfileMapper` (`packages/applications/lib/mapper/`) if using a DTO.
    *   Create `GetUserProfileUseCase` (`packages/applications/lib/usecase/user/`):
        *   Inject `UserRepository`.
        *   Implement a `call()` method that takes `userId`, calls `userRepository.getUserProfile(userId)`, maps to DTO if needed, and returns it.
    *   Register `GetUserProfileUseCase` with `GetIt` (`packages/applications/lib/di/`).

3.  **`infra` Layer:**
    *   Create `UserRepositoryImpl` (`packages/infra/lib/adapters/repository/user/`) implementing `UserRepository`.
    *   Inject necessary data sources (e.g., `SupabaseClientWrapper` or a dedicated `UserApi` using `DioClient`).
    *   Implement `getUserProfile`: Call the backend API, handle errors, map the response to the `UserProfile` entity.
    *   Register `UserRepositoryImpl` with `GetIt` (`packages/infra/lib/di/`).

4.  **`presentation` Layer:**
    *   Create `ProfileScreen` (`packages/presentation/lib/screens/profile/`).
    *   Create `ProfileStore` (Cubit/Bloc) (`packages/presentation/lib/screens/profile/store/`):
        *   Inject `GetUserProfileUseCase`.
        *   Manage states: `initial`, `loading`, `success(UserProfileDTO data)`, `error(String message)`.
        *   Add a method `fetchProfile()` that calls the use case and emits states accordingly.
    *   Register `ProfileStore` with `GetIt` (`packages/presentation/lib/di/`).
    *   In `ProfileScreen`:
        *   Provide/Access `ProfileStore` (e.g., using `BlocProvider`).
        *   Use `BlocBuilder` to display UI based on the store's state (show loader, error, or profile data).
    *   Add a route for `/profile` in `AppRouter` (`packages/presentation/lib/utils/app_router.dart`).
    *   Add navigation (e.g., a button in `HomeScreen`) using `NavigationService` to go to the profile screen.

### Example 2: Adding a Setting Toggle

**Goal:** Add a switch in settings to enable/disable analytics.

1.  **`domains` Layer:**
    *   Add methods to `SettingRepository` (`packages/domains/lib/setting/setting_repository.dart`):
        ```dart
        abstract class SettingRepository {
          Future<void> setAnalyticsEnabled(bool enabled);
          Future<bool> isAnalyticsEnabled();
          // ... other settings
        }
        ```

2.  **`infra` Layer:**
    *   Implement the new methods in `SettingRepositoryImpl` (`packages/infra/lib/adapters/repository/setting/`).
    *   Inject `SharedPreferenceHelper`.
    *   Use `SharedPreferenceHelper` to save/retrieve the boolean value. Define a constant key in `Preferences` (`packages/infra/lib/datasources/local/sharedpref/constants/preferences.dart`).
    *   Add corresponding methods to `SharedPreferenceHelper` itself.

3.  **`applications` Layer:**
    *   Create `SetAnalyticsEnabledUseCase` and `GetAnalyticsEnabledUseCase` (`packages/applications/lib/usecase/setting/`).
    *   Inject `SettingRepository` into them.
    *   Implement `call()` methods that simply invoke the repository methods.
    *   Register the use cases with `GetIt`.

4.  **`presentation` Layer:**
    *   Add state and methods to `SettingsStore` (or create one) (`packages/presentation/lib/store/` or `screens/settings/store/`).
        *   Inject the new use cases.
        *   Hold the `isAnalyticsEnabled` state.
        *   Provide a method `toggleAnalytics(bool newValue)` that calls `SetAnalyticsEnabledUseCase` and updates the state (potentially re-fetching with `GetAnalyticsEnabledUseCase`).
    *   In your `SettingsScreen`:
        *   Use `BlocBuilder` to get the current `isAnalyticsEnabled` state from the store.
        *   Add a `SwitchListTile` widget.
        *   Set its `value` from the store's state.
        *   In `onChanged`, call the `toggleAnalytics` method in the store.
    *   (Optional) Use `GetAnalyticsEnabledUseCase` during app startup (`main.dart` or splash screen logic) to conditionally initialize analytics services.

## Core Technologies 🛠️

This starter kit integrates several popular and robust libraries:

*   **UI Framework:** [Flutter](https://flutter.dev/)
*   **Language:** [Dart](https://dart.dev/)
*   **State Management:** [Bloc / Cubit](https://bloclibrary.dev/)
*   **Dependency Injection:** [GetIt](https://pub.dev/packages/get_it)
*   **Routing:** [GoRouter](https://pub.dev/packages/go_router)
*   **HTTP Client:** [Dio](https://pub.dev/packages/dio)
*   **Backend-as-a-Service:** [Supabase Flutter](https://pub.dev/packages/supabase_flutter) (for Auth, adaptable for DB/Storage)
*   **Embedded Database:** [Sembast](https://pub.dev/packages/sembast) (example structure included)
*   **Key-Value Storage:** [shared\_preferences](https://pub.dev/packages/shared_preferences)
*   **Environment Variables:** [flutter\_dotenv](https://pub.dev/packages/flutter_dotenv)
*   **Internationalization:** [intl](https://pub.dev/packages/intl) / `AppLocalizations`
*   **Logging:** Custom Logger (`core/logger`)
*   **Code Generation:** [build\_runner](https://pub.dev/packages/build_runner)

## Contributing 🤝

Contributions are welcome! If you find a bug, have a suggestion, or want to add a feature:

1.  Please check the [Issues](https://github.com/your-username/flutter_starter-main/issues) tab first to see if a similar topic exists.
2.  If not, feel free to open a new issue to discuss your idea or report the bug.
3.  For code changes, please fork the repository, create a feature branch, and submit a Pull Request.

## License 📄

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details. Happy coding!
