# Presentation Layer Architecture

## Overview

The Presentation Layer handles the user interface, state management, and interaction logic, serving as the direct interface between users and the application. Our architecture follows principles of clear separation of concerns and business domain cohesion.

## Core Principles

- **Clear Separation of Concerns**: Store, ViewModel, and Screen each have distinct responsibilities
- **Business Domain Organization**: Code is organized by business features (rather than technical layers) to enhance cohesion
- **Testability**: Each component is designed to be independently testable
- **State Management**: Predictable state management using the Store pattern

## Architecture Components

### Layered Architecture

The Presentation Layer consists of the following core concepts:

1. **Store**:
   - Responsible for state management and business logic coordination
   - Interacts with Application layer UseCases
   - Manages UI states (loading, error, success, etc.)

2. **ViewModel**:
   - Responsible for UI data transformation and preparation
   - Converts business models to UI-friendly formats
   - Handles formatting, filtering, and UI-specific logic

3. **Screen/Widget**:
   - Pure UI presentation layer
   - Consumes data provided by ViewModels
   - Handles user interactions and forwards events to the Store

### Folder Structure

We organize code by business domain rather than technical layers to improve related code cohesion:

```
lib/
  ├── features/                      # Organized by business domain
  │   ├── auth/                      # Authentication features
  │   │   ├── store/                 # Authentication state management
  │   │   ├── viewmodel/             # Authentication UI logic
  │   │   └── screens/               # Authentication screens
  │   │
  │   ├── post/                      # Post-related features
  │   │   ├── store/                 # Post state management
  │   │   ├── viewmodel/             # Post UI logic
  │   │   └── screens/               # Post-related screens
  │   │
  │   └── ... (other business domains)
  │
  ├── shared/                        # Shared resources
  │   ├── widgets/                   # Reusable UI components
  │   ├── constants/                 # Application constants
  │   └── utils/                     # Pure utility functions
  │
  ├── foundation/                    # Foundation infrastructure
  │   ├── error/                     # Error handling
  │   ├── navigation/                # Navigation infrastructure
  │   └── state/                     # State management infrastructure
  │
  └── di/                            # Dependency injection
      └── presentation_di.dart
```

## Store and ViewModel Relationship

In designing the Presentation Layer, we've adopted a Store + ViewModel architectural pattern, where:

### Store Responsibilities:
- Holds and manages state (loading, error states, etc.)
- Calls Application layer UseCases to execute business operations
- Handles asynchronous operations and errors

### ViewModel Responsibilities:
- Receives raw data provided by the Store
- Transforms data into UI-friendly formats (date formatting, text truncation, etc.)
- Provides computed properties to meet specific UI requirements
- Doesn't hold state, focusing solely on data transformation

### Example: Post List Feature

In the Post List feature:

1. `PostStore` is responsible for:
   - Calling `GetPostsUsecase` to retrieve post data
   - Managing loading states and error handling
   - Holding the raw post data

2. `PostListViewModel` is responsible for:
   - Converting raw post data into formats required for UI display
   - Providing sorting, filtering, and other UI data processing functions
   - Formatting dates, generating summary text, etc.

3. `PostListScreen` is responsible for:
   - Displaying UI elements
   - Listening to user interactions
   - Rendering the interface using data provided by the ViewModel

## Why Choose ViewModel?

After team discussions, we decided to retain the ViewModel layer for the following reasons:

1. **Clearer Responsibilities**: Store focuses on state management, ViewModel focuses on UI data preparation
2. **Easier Testing**: Separation of UI logic from state management simplifies testing
3. **Prevents Store Bloat**: Prevents Stores from taking on too many responsibilities
4. **Flexibility**: Allows adding ViewModels for complex pages as needed, while simpler pages can use Stores directly

## Business Domain Cohesion

We chose to organize code by business domain (rather than technical layers) for the following reasons:

1. **Development and Maintenance Efficiency**: Developers typically work on business features (like "fix login functionality" rather than "fix all Stores")
2. **Improved Relevance**: Keeping related business code together reduces cross-directory searches
3. **Reduced Coupling**: Clear business boundaries help reduce dependencies between different business modules
4. **Extensibility**: Adding new functionality only requires adding a new business directory under features