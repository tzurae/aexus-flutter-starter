# Refactoring Tasks for Codebase Improvement

Based on an analysis guided by Clean Architecture principles and project conventions, the following refactoring tasks are prioritized to enhance testability, maintainability, and adherence to architectural best practices.

## Priority 1: Implement Comprehensive Testing Strategy

**Goal:** Ensure adequate test coverage across Application and Presentation layers, aligning with TDD practices.

*   [ ] **Application Layer:**
    *   [ ] Implement unit tests for all Use Cases in `packages/applications/lib/usecase/`.
        *   Mock repository dependencies.
        *   Verify correct interaction with repositories.
        *   Verify correct handling of parameters (DTOs/Params).
        *   Verify correct return values/DTOs or exception handling.
    *   [ ] Implement unit tests for all Mappers in `packages/applications/lib/mapper/` (if any complex mapping logic exists).
    *   [ ] Activate Application tests in `test/all_test.dart`.
    *   [ ] Ensure `packages/applications/test/all_application_test.dart` correctly runs all application tests.
*   [ ] **Presentation Layer:**
    *   [ ] Implement unit tests for Stores/Cubits (e.g., `PostListStore`, `ThemeStore`) in `packages/presentation/lib/screens/**/store/` and `packages/presentation/lib/store/`.
        *   Mock Use Case dependencies.
        *   Verify correct initial state.
        *   Verify correct state transitions based on Use Case results (loading, success, error, empty).
        *   Verify correct emission of states (`emit(...)`).
    *   [ ] Implement widget tests for critical reusable Widgets in `packages/presentation/lib/widgets/`.
    *   [ ] Implement widget tests for key Screens in `packages/presentation/lib/screens/` to verify basic layout and interaction with Stores.
    *   [ ] Activate Presentation tests in `test/all_test.dart`.
    *   [ ] Ensure `packages/presentation/test/all_presentation_test.dart` correctly runs all presentation tests.
*   [ ] **Infrastructure Layer:**
    *   [ ] Ensure `packages/infra/test/all_infra_test.dart` correctly runs all existing and future infrastructure tests.
    *   [ ] Add tests for any untested infrastructure components (Data Sources, Clients, etc.).

## Priority 2: Refine Presentation Layer Logic & Separation of Concerns

**Goal:** Ensure Presentation layer components (Stores/Cubits) strictly manage UI state and delegate all non-UI logic to the Application layer.

*   [ ] Review `PostListStore` (`packages/presentation/lib/screens/post/store/post_store.dart`):
    *   [ ] Verify that DTO-to-ViewModel mapping is simple and UI-focused. If complex, consider moving logic to an Application layer Mapper or having the Use Case return a ViewModel-like structure.
    *   [ ] Ensure no business rules or complex data orchestration logic exists within the store; such logic should be in `GetPostsUseCase`.
    *   [ ] Confirm `ResourceState` transitions are purely based on Use Case outcomes.
*   [ ] Review other Stores/Cubits (e.g., `ThemeStore`, `LanguageStore` if implemented) for similar potential logic leaks.
*   [ ] Ensure consistent and proper use of logging within Presentation components (e.g., remove commented-out log lines, use injected logger instance). Standardize logger usage if necessary (links to Priority 3).

## Priority 3: Evaluate and Standardize Logging Implementation

**Goal:** Replace the custom logging system (`lib/core/logger/`) with a standard library to improve maintainability and reduce custom code burden.

*   [ ] **Evaluation:**
    *   [ ] Analyze the specific features used from the current custom logger (`ConsoleFormatter`, `FileFormatter`, levels, colors, file rotation etc. defined in `LogConfig`).
    *   [ ] Research standard Dart/Flutter logging packages (e.g., `package:logger`, `package:logging`).
    *   [ ] Select a standard package that meets the feature requirements identified above.
*   [ ] **Implementation:**
    *   [ ] Add the chosen standard logging package as a dependency.
    *   [ ] Create a central configuration for the new logger (potentially wrapping it in a project-specific service) to replicate the settings from `LogConfig` (levels, outputs, formatting).
    *   [ ] Replace all instances of the custom logger (`Log.getLogger(...)`, logger method calls) throughout the codebase (`packages/infra/`, `packages/presentation/`, etc.) with the API of the new standard logger.
    *   [ ] Ensure logging works as expected in different environments (debug, release) and outputs (console, file if configured).
*   [ ] **Cleanup:**
    *   [ ] Remove the `lib/core/logger/` directory and all its files.
    *   [ ] Remove any dependencies solely used by the custom logger.
    *   [ ] Update dependency injection setup (`service_locator.dart`) if the logger instantiation changes.