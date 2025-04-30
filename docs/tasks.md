# Actionable Improvement Tasks

This document lists tasks to improve the codebase's architecture, quality, and maintainability, based on Clean Architecture and DDD principles outlined in `CONVENTIONS.md`.

## Architecture & Design Refinements

*   [ ] **Infrastructure Layer:** Refactor `SharedPreferenceHelper` usage. Introduce specific local data source interfaces (e.g., `AuthLocalDataSource`, `SettingsLocalDataSource`) and implementations, injecting these into repositories instead of the generic helper.
*   [ ] **Infrastructure Layer:** Abstract Supabase interactions. Create dedicated data source interfaces (e.g., `AuthRemoteDataSource`) to decouple repositories like `AuthRepositoryImpl` and APIs like `AuthIsLoggedInApi` from direct `SupabaseClient` dependency.
*   [ ] **Infrastructure Layer:** Consolidate Retry Interceptors. Review `packages/infra/lib/clients/dio/interceptors/dio_retry_interceptor.dart` and `packages/infra/lib/clients/dio/interceptors/retry_interceptor.dart`. Remove duplication or clarify distinct roles, ensuring only one is actively used or they serve different, clear purposes.
*   [ ] **Application Layer:** Review Use Case complexity. Ensure use cases primarily orchestrate calls to repositories and domain services. Move complex business logic applicable across multiple use cases into Domain Services within the Domain Layer.
*   [ ] **Dependency Injection:** Organize `service_locator.dart`. If not already done, split DI registrations into modules per layer or feature to improve organization and maintainability.
*   [ ] **Domain Layer:** Verify purity. Conduct a thorough review to ensure no infrastructure (e.g., specific database/API details) or presentation concerns leak into the Domain Layer entities, value objects, or repository interfaces.

## Code Quality & Maintainability

*   [ ] **Static Analysis:** Configure and enforce lint rules. Set up `analysis_options.yaml` with strict rules (e.g., `lints`, `flutter_lints`, or custom rules) and ensure the codebase passes `flutter analyze` without issues.
*   [ ] **Logging:** Ensure consistent logging. Review the codebase for consistent use of the established logging framework (`LoggerFactory`). Uncomment and utilize logging statements where valuable (e.g., in Stores/Cubits like `PostListStore`).
*   [ ] **Error Handling:** Refine error mapping. Ensure robust mapping from low-level exceptions (e.g., `DioException`, Supabase errors) to application-level `NetworkException` subtypes or `GlobalError` within the Infrastructure layer. Review `ApiHandlingCubit` for comprehensive error coverage.
*   [ ] **Code Duplication:** Identify and remove duplication. Actively look for and refactor duplicated code blocks, potentially into utility functions or shared components.
*   [ ] **Constants:** Review constant usage. Ensure all relevant magic strings/numbers are defined in the constants files (`constants/` directories in `presentation` and `infra`).
*   [ ] **State Management:** Standardize state management. Document and consistently apply the chosen state management approach (e.g., Bloc/Cubit, MobX) across the Presentation Layer.

## Testing Strategy

*   [ ] **Test Coverage:** Implement comprehensive tests. Write unit tests for Domain logic, Application Use Cases (mocking repositories), Infrastructure Repositories (mocking data sources), and Presentation layer logic (Stores/Cubits/ViewModels).
*   [ ] **Widget Tests:** Add widget tests for key UI components and screens to verify UI rendering and basic interactions.
*   [ ] **Integration Tests:** Develop integration tests for critical user flows (e.g., login, fetching data) to test interactions between layers.
*   [ ] **Testing Strategy Document:** Define and document the overall testing strategy, outlining what types of tests are required for different parts of the application.

## Security

*   [ ] **Secrets Management:** Review `AppConfigService` and key management. Ensure sensitive keys (Supabase keys, encryption passwords for `xxtea`) are not hardcoded and are loaded securely (e.g., via environment variables using `--dart-define`).
*   [ ] **Encryption:** Evaluate `xxtea` usage. Confirm that the encryption algorithm and its usage pattern (including key management) meet the project's security requirements.
*   [ ] **Data Storage:** Review local storage security. Assess if sensitive data stored via `SharedPreferences` requires encryption or more secure storage mechanisms.

## Documentation

*   [ ] **README Update:** Enhance the project `README.md` with setup instructions, architectural overview (linking to `CONVENTIONS.md`), and guidelines for contributors.
*   [ ] **Code Comments:** Add clarifying comments for complex logic, public APIs, and critical sections, especially where the intent isn't immediately obvious.
