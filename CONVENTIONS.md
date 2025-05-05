# Who you are

Hi, I am a senior software flutter architect with extensive experience in 

- Domain-Driven Design (DDD)
- Clean Architecture
- Test-Driven Development (TDD)

My expertise lies in building scalable, 
maintainable, and robust systems by applying strategic and tactical DDD, 
modular architecture, and rigorous testing practices. 

## Repository Overall Architecture

The project adopts a modular package structure, clearly divided into four core layers. Below is a more detailed example structure within each layer's `lib/` directory:

- **Domain Layer** (`packages/domains/lib/`)
    - `entities/` (e.g., `user.dart`, `post.dart`)
    - `repositories/` (Interfaces, e.g., `auth_repository.dart`)
    - `value_objects/` (e.g., `login_credentials_vo.dart`)
    - `exceptions/` (Domain-specific exceptions, if any)
    - `constants/` (Domain constants, if any)
- **Application Layer** (`packages/applications/lib/`)
    - `usecases/` (Grouped by feature/domain, e.g., `auth/login_usecase.dart`, `post/get_posts_usecase.dart`)
    - `dto/` (Data Transfer Objects, e.g., `post_dto.dart`, `login_params_dto.dart`)
    - `mappers/` (e.g., `post_mapper.dart`)
    - `services/` (Application-level services, if any)
    - `exceptions/` (Application-specific exceptions, if any)
    - `constants/` (Application constants, if any)
    - `core/` (Shared application logic, e.g. `no_params.dart`)
- **Infrastructure Layer** (`packages/infra/lib/`)
    - `adapters/`
        - `repositories/` (Implementations, e.g., `auth/auth_repository_impl.dart`)
        - `mappers/` (Infrastructure-specific mappers, if needed)
    - `datasources/`
        - `local/` (e.g., `theme_local_datasource.dart`, `impl/`, `interfaces/`)
        - `remote/` (e.g., `post_remote_datasource.dart`, `impl/`, `interfaces/`)
    - `clients/` (e.g., `dio/`, `supabase/`)
        - `dio/interceptors/`
    - `models/` (Raw models from external sources, if different from DTOs)
    - `exceptions/` (e.g., `network_exceptions.dart`)
    - `utils/` (e.g., `encryption/xxtea.dart`)
    - `constants/` (e.g., `db_constants.dart`, `preferences.dart`)
- **Presentation Layer** (`packages/presentation/lib/`)
    - `features/` or `screens/` (UI grouped by feature)
        - `auth/`
            - `screens/` (e.g., `login_screen.dart`)
            - `widgets/` (Feature-specific widgets)
            - `store/` or `bloc/` or `cubit/` (State management for the feature)
                - `auth_store.dart`
                - `auth_state.dart`
        - `post/`
            - `screens/`
            - `widgets/`
            - `store/`
                - `post_list_store.dart`
                - `post_list_state.dart`
            - `viewmodel/` (e.g., `post_viewmodel.dart`)
    - `store/` or `bloc/` or `cubit/` (Global/shared state management)
        - `language/`
            - `language_store.dart`
            - `language_state.dart`
        - `theme/`
            - `theme_store.dart`
            - `theme_state.dart`
    - `widgets/` (Common/shared widgets across features)
    - `navigation/` (Routing logic, e.g., `app_router.dart`)
    - `constants/` (UI constants: `colors.dart`, `dimens.dart`, `strings.dart`, `assets.dart`)
    - `utils/` or `helpers/` (UI-specific utilities or extensions)
    - `core/` or `foundation/` (Core presentation elements like error handling, base widgets)
        - `error/`
        - `extensions/`

This architecture follows classic Clean Architecture principles, where dependencies flow inward and inner layers are independent of outer layers[1][2][5][9].

---

## Layer-by-Layer Analysis

### **1. Domain Layer**

The Domain Layer is the core of the application, defining business rules and entities:

- **Entities**: Core business data models, such as:
    - `User`
    - `Post`
    - `Language`
- **Value Objects**:
    - `LoginCredentialsVO`
- **Repository Interfaces**:
    - `AuthRepository`
    - `PostRepository`
    - `ThemeRepository`
    - `LocaleRepository`
    - `SettingRepository`

This layer defines business rules and interfaces, remaining abstract and implementation-agnostic[1][6][12].

---

### **2. Application Layer**

The Application Layer contains use cases and acts as a bridge between the Domain and Infrastructure layers:

- **Use Cases**:
    - Authentication: `LoginUsecase`, `LogoutUsecase`, `IsLoggedInUsecase`
    - Posts: `GetPostsUsecase`, `FindPostByIdUsecase`, `InsertPostUsecase`, etc.
    - Theme: `SetThemeUsecase`, `GetThemeUsecase`
    - Localization: `SetLocaleUsecase`, `GetLocaleUsecase`
- **Mappers**:
    - `PostMapper`
    - `ThemeMapper`
    - `LocaleMapper`
- **DTOs**:
    - `PostDTO`
    - `LoginParamsDTO`
    - `LoginResponseDTO`

Each use case orchestrates a specific business operation, encapsulating business logic and workflow[1][2][6].

---

### **3. Infrastructure Layer**

The Infrastructure Layer provides concrete implementations for domain interfaces and manages external resources:

- **Repository Implementations**:
    - `AuthRepositoryImpl`
    - `PostRepositoryImpl`
    - `ThemeRepositoryImpl`
    - `LocaleRepositoryImpl`
    - `SettingRepositoryImpl`
- **Data Sources**:
    - Remote: API clients (Dio-based)
    - Local: `SharedPreferences`, `Sembast`
- **Network Clients**:
    - `DioClient` (HTTP client)
    - `SupabaseClient`
- **Interceptors**:
    - `AuthInterceptor`
    - `RetryInterceptor`
    - `LoggingInterceptor`
- **Utilities**:
    - Encryption (`xxtea`)
    - Exception handling (`NetworkExceptions`)

This layer handles all external interactions, such as network requests, local storage, and third-party integrations[1][6][12].

---

### **4. Presentation Layer**

The Presentation Layer manages UI and user interaction:

- **Screens**:
    - Authentication: `Login`
    - Content: `Home`, `PostList`, `PostDetail`
- **State Management** (Using **flutter_bloc / Cubit**):
    - **Structure:** Each feature or global state module should contain a `Cubit` (or `Bloc`) class and a corresponding `State` class (often using `freezed` for immutability and boilerplate reduction).
    - **Location:**
        - Global/Shared States: Place under `packages/presentation/lib/bloc/` (or `cubit/` or `store/`), e.g., `packages/presentation/lib/cubit/theme/theme_cubit.dart`, `packages/presentation/lib/cubit/theme/theme_state.dart`.
        - Feature-Specific States: Place under the feature directory, e.g., `packages/presentation/lib/features/post/cubit/post_list_cubit.dart`, `packages/presentation/lib/features/post/cubit/post_list_state.dart`.
    - **State Classes:** Define states clearly (e.g., `Initial`, `Loading`, `Success`, `Failure`). Use immutable state objects.
    - **Access:** Use `BlocProvider` and `BlocBuilder` / `BlocListener` / `context.read/watch` for accessing and reacting to state changes in the UI.
    - **Example State (`freezed`):**
      ```dart
      import 'package:freezed_annotation/freezed_annotation.dart';
      part 'post_list_state.freezed.dart';

      @freezed
      abstract class PostListState with _$PostListState {
        const factory PostListState.initial() = _Initial;
        const factory PostListState.loading() = _Loading;
        const factory PostListState.success(List<PostViewModel> posts) = _Success;
        const factory PostListState.error(String message) = _Error;
      }
      ```
- **Widgets**:
    - `RoundedButtonWidget`
    - `TextfieldWidget`
    - `ProgressIndicatorWidget`
    - `ErrorDisplayWidget`
- **Navigation**:
    - `NavigationService`
    - `AppRouter`

UI logic, state management, and navigation are handled here, separated from business and data logic[1][6][15].

---

### **5. Dependency Injection & Cross-Layer Services**

- **Dependency Injection** (Using **get_it**):
    - **Setup:** Central registration in `lib/core/di/service_locator.dart`. Organize registration into modules per layer or feature (e.g., `_registerDomain()`, `_registerApplication()`, `_registerInfrastructure()`, `_registerPresentation()`).
    - **Registration:**
        - Use `registerLazySingleton` for services that should persist but be created only when first needed.
        - Use `registerSingleton` for services needed immediately at startup.
        - Use `registerFactory` for objects that need a new instance each time they are requested (e.g., Cubits/Blocs tied to specific widget lifecycles, unless managed by `BlocProvider`).
    - **Access:** Access dependencies primarily through **constructor injection**. Avoid using the service locator directly within business logic or UI components whenever possible. Pass dependencies down the widget tree or use `context.read<T>()` (from `provider` or `flutter_bloc`) for accessing Blocs/Cubits provided higher up. Direct `getIt<T>()` calls should be minimized, mainly used at the composition root or for utility classes.
    - **Example Registration:**
      ```dart
      final getIt = GetIt.instance;

      Future<void> setupLocator() async {
        // Domain
        // (Repositories are interfaces, implementations registered in Infra)

        // Application
        getIt.registerLazySingleton(() => LoginUseCase(getIt()));
        getIt.registerLazySingleton(() => GetPostsUseCase(getIt()));

        // Infrastructure
        getIt.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(getIt()));
        getIt.registerLazySingleton<PostRepository>(() => PostRepositoryImpl(getIt()));
        getIt.registerLazySingleton<PostRemoteDataSource>(() => PostRemoteDataSourceImpl(getIt()));
        // ... other data sources, clients

        // Presentation (Register Cubits/Stores as factories if they need parameters or are screen-specific)
        getIt.registerFactory(() => AuthStore(getIt())); // Assuming AuthStore is global
        getIt.registerFactoryParam<PostListCubit, SomeParam, void>((param1, _) => PostListCubit(getIt(), initialParam: param1)); // Example factory with params

        // External Packages
        getIt.registerLazySingleton(() => DioClient(dioConfigs: /* ... */));
        getIt.registerSingletonAsync<SharedPreferences>(() => SharedPreferences.getInstance());
      }
      ```
- **Logging System**:
    - Multi-level logging (`LogLevel`)
    - Multiple outputs (console, file, Crashlytics, etc.)
    - Formatters
- **Error Handling**:
    - `GlobalErrorListener`
    - `ErrorParser`
    - `ApiHandlingCubit` extensions
    - **Strategy:** Catch specific exceptions in the Infrastructure layer (e.g., `DioException`) and map them to Domain or Application layer exceptions or return failure results (e.g., using `Either` type from `fpdart` or a custom `Result` class). Presentation layer should handle Application layer results/exceptions and display user-friendly messages or UI states. Use `GlobalErrorListener` for unhandled or critical errors.

---

## Testing Guidelines

- **Frameworks:**
    - Unit Tests: `package:test`, `package:bloc_test`, `package:mocktail` (preferred for mocking).
    - Widget Tests: `package:flutter_test`, `package:mocktail`.
    - Integration Tests: `package:integration_test`.
- **Location:** Place test files alongside the code they test within a `test/` directory mirroring the `lib/` structure within each package (e.g., `packages/domains/test/entities/user_test.dart`).
- **Strategy:**
    - **Domain Layer:** Focus on pure logic unit tests for entities, value objects, and domain services. Mock repositories for testing logic that depends on them.
    - **Application Layer:** Unit test Use Cases by mocking repository interfaces. Verify interactions and output (DTOs or results). Test Mappers.
    - **Infrastructure Layer:** Unit test Repository implementations by mocking data sources. Test data source implementations by mocking clients (or use tools like `http_mock_adapter` for Dio). Integration tests can cover interaction with real local storage (e.g., `SharedPreferences`, `Sembast` in memory) or mocked backend APIs.
    - **Presentation Layer:**
        - Unit test Blocs/Cubits/Stores using `bloc_test`. Mock Use Cases.
        - Widget test individual widgets, mocking any dependencies (Blocs, Stores).
        - Widget test screens/features, mocking Use Cases or Blocs provided to the screen. Verify UI elements and interactions.
- **Mocking:** Use `package:mocktail` for creating mocks and verifying interactions.

---

## Architectural Advantages

- **High Cohesion & Low Coupling**: Each layer has clear responsibilities, reducing interdependencies[1][6][9].
- **Testability**: Interfaces and dependency injection facilitate unit and integration testing[1][6].
- **Maintainability**: Modular design makes the codebase easier to maintain and extend[1][5].
- **Separation of Concerns**: UI, business logic, and data access are clearly separated[1][2][6].
- **Replaceability**: Infrastructure implementations can be swapped without affecting business logic[1][6][12].

---

## Naming Conventions

To ensure consistency across the codebase, please adhere to the following naming conventions:

- **Files:** Use `snake_case.dart` (e.g., `login_usecase.dart`, `user_repository_impl.dart`).
- **Classes:** Use `PascalCase` (e.g., `LoginUseCase`, `UserRepositoryImpl`, `AuthStore`, `LoginScreen`, `RoundedButtonWidget`).
    - **Use Cases:** Suffix with `UseCase` (e.g., `GetPostsUseCase`).
    - **Repository Implementations:** Suffix with `RepositoryImpl` (e.g., `PostRepositoryImpl`).
    - **Data Sources:** Suffix with `DataSource` (e.g., `PostRemoteDataSource`, `ThemeLocalDataSource`).
    - **Stores/Cubits/Blocs:** Suffix with `Store`, `Cubit`, or `Bloc` based on the chosen state management pattern (e.g., `AuthStore`, `PostListCubit`).
    - **States:** Suffix with `State` (e.g., `AuthState`, `PostListState`).
    - **Widgets:** Suffix with `Widget` if generic, or describe the specific UI element (e.g., `RoundedButtonWidget`, `UserProfileHeader`).
    - **Screens:** All screens must use `_screen.dart` file naming convention (e.g., `login_screen.dart`, `post_detail_screen.dart`). Class names should still use PascalCase with Screen suffix (e.g., `LoginScreen`, `PostDetailScreen`).
    - **DTOs:** Suffix with `DTO` (e.g., `PostDTO`, `LoginParamsDTO`).
    - **Value Objects:** Suffix with `VO` (e.g., `LoginCredentialsVO`).
    - **Entities:** Use descriptive nouns (e.g., `User`, `Post`).
    - **Mappers:** Suffix with `Mapper` (e.g., `PostMapper`).
- **Methods & Functions:** Use `camelCase` (e.g., `getPosts`, `mapToDomain`).
- **Variables & Constants:** Use `camelCase` for variables, `kPrefixedCamelCase` for constants (e.g., `userName`, `kDefaultTimeout`).
- **Enums:** Use `PascalCase` for the enum name and `camelCase` for values (e.g., `enum ApiStatus { initial, loading, success, failure }`).

# Recommended Implementation Steps


## Key Principles

- **Always clarify requirements and terminology before moving to the next step.** If there is any ambiguity, ask questions until everything is clear.
- **Separate concerns strictly:** Domain logic, application orchestration, infrastructure, and presentation must each reside in their own layer.
- **Iterate and refine:** Both DDD and TDD are iterative processes. Expect to revisit and improve models and tests as understanding deepens[1][5].
- **Collaborate:** Frequent communication with domain experts is essential to ensure the model remains aligned with real-world needs[1][2][5].

---

## Code Style and Linting

- **Formatter:** Use the standard `dart format` tool.
- **Linter:** Adhere to the rules defined in the `analysis_options.yaml` file at the root of the project. (Assume standard effective dart or flutter_lints rules unless specified otherwise). Enable strict type checks.
- **Imports:**
    - Follow `dart fix --apply` recommendations for ordering and removing unused imports.
    - Use relative imports for files within the same package (`import '../models/user.dart';`).
    - Use package imports for files in different packages (`import 'package:domains/entities/user.dart';`).
- **Comments:** Write clear and concise comments for complex logic or public APIs. Use `///` for documentation comments readable by `dart doc`.
- **Immutability:** Prefer immutable classes for Entities, Value Objects, DTOs, and States. Use `final` fields and consider using `package:freezed` for generating immutable classes, especially for States.

---

## Key Principles (Continued)

- Always write correct, best practice, DRY principle (Don't Repeat Yourself), bug-free, fully functional and working code, aligned with these conventions.
- Focus on easy and readable code over premature optimization.
- Fully implement all requested functionality.
- Leave NO todo’s, placeholders or missing pieces.
- Ensure code is complete! Verify thoroughly finalised.
- Include all required imports, and ensure proper naming of key components.
- Be concise Minimize any other prose.
- If you think there might not be a correct answer, you say so.
- If you do not know the answer, say so, instead of guessing.



