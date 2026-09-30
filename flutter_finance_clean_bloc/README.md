# Flutter Finance

A personal finance tracker built with Flutter, Dart, BLoC, Clean Architecture, and local Hive persistence.

## Features

- Create, edit, and delete income and expense transactions.
- Browse monthly activity and see income, expenses, and balance.
- Persist transactions locally with Hive.
- Responsive Material 3 interface with system light and dark themes.
- Form validation, loading, empty, and error states.

## Architecture

The finance feature follows Presentation → Domain and Data → Domain dependency rules. Presentation dispatches events to `FinanceBloc`; the bloc coordinates use cases; use cases depend on the `FinanceRepository` contract; the data implementation maps entities to models and accesses the local datasource. Domain contains no Flutter or Hive imports.

```text
lib/
├── app/                         # App composition, theme, and BLoC observer
├── core/                        # Database, errors, shared use case and utilities
└── features/finance/
    ├── domain/                  # Entities, repository contract, use cases
    ├── data/                    # Hive datasource, models, repository implementation
    └── presentation/            # BLoC, pages, and widgets
```

## Technical decisions

- Manual dependency injection keeps the object graph explicit and limited to the application composition root.
- Hive is initialized once before `runApp`; persistence stays behind the datasource and repository.
- Monthly navigation filters the already loaded in-memory collection.
- Repository failures are translated into user-facing messages at the presentation boundary.
- `ThemeMode.system` selects the Material 3 light or dark theme.

## Requirements

- Flutter SDK compatible with the Dart SDK constraint in `pubspec.yaml`.
- Web, Android, iOS, Windows, macOS, or Linux tooling for the selected target.

## Run

```sh
flutter pub get
flutter run
```

## Test and analyze

```sh
flutter analyze
flutter test
```

## Build

```sh
flutter build web
```

## Screenshots

Screenshots can be added here after capturing the app on supported form factors.

## CI

GitHub Actions runs dependency resolution, static analysis, unit/widget tests, and a web build on pushes and pull requests.

## Future improvements

- Add export and backup options.
- Add configurable currencies and category management.
- Expand repository and BLoC failure-path coverage.
