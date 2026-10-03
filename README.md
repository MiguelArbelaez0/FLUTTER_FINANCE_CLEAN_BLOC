# Flutter Finance Clean BLoC

A Flutter personal finance application built with Dart, BLoC, Clean Architecture principles, and local data persistence using Hive.

## 📱 Overview

Flutter Finance Clean BLoC is a finance management application focused on recording and organizing personal transactions.

The project demonstrates how to structure a Flutter application with separated presentation, domain, and data responsibilities while using BLoC for state management and Hive for local persistence.

## 🚀 Features

- Create financial transactions
- View recorded transactions
- Update transaction information
- Delete transactions
- Calculate monthly totals
- Calculate balance from stored transactions
- Persist financial data locally
- Reactive state management with BLoC
- Separation of application responsibilities
- Clean Architecture principles

## 🏗️ Architecture

The application follows a Clean Architecture-inspired structure:

```text
Presentation
     ↓
BLoC
     ↓
Use Cases
     ↓
Repository
     ↓
Local Data Source
     ↓
Hive
```

The architecture separates the user interface and state management from business logic and data persistence.

## 🧩 Technologies

| Technology | Usage |
|---|---|
| Flutter | Application framework |
| Dart | Programming language |
| flutter_bloc | State management |
| BLoC | Business/application state |
| Hive | Local persistence |
| Equatable | Value equality |
| Clean Architecture | Application organization |
| Repository Pattern | Data abstraction |

## 💰 Transaction Management

The application allows users to manage financial transactions locally.

Transactions can be created, viewed, updated, and deleted through the application interface.

Each transaction contributes to the financial calculations used to display the user's current and monthly financial information.

## 📊 Financial Calculations

The application includes calculations for:

- Total income
- Total expenses
- Monthly totals
- Current balance

The calculations are based on the transactions stored in the local database.

## 💾 Local Persistence

Hive is used to persist transaction data locally.

This allows financial records to remain available between application sessions without requiring a remote backend.

## ⚡ State Management

BLoC is responsible for managing application state and coordinating changes between the presentation layer and the domain/data layers.

This keeps business operations separated from UI components and makes state transitions easier to reason about.

## 📂 Project Structure

The project is organized around the main responsibilities of the application:

```text
lib/
├── core/
├── data/
├── domain/
└── presentation/
```

### Presentation

Contains screens, widgets, and BLoC state management.

### Domain

Contains business entities, repository contracts, and use cases.

### Data

Contains local data access, models, and repository implementations.

### Core

Contains shared application functionality and utilities.

## ⚙️ Installation

### 1. Clone the repository

```bash
git clone https://github.com/MiguelArbelaez0/FLUTTER_FINANCE_CLEAN_BLOC.git
cd FLUTTER_FINANCE_CLEAN_BLOC
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Run the application

```bash
flutter run
```

Make sure Flutter and Dart are correctly installed and configured on your development environment.

## 🎯 What This Project Demonstrates

This project demonstrates practical experience with:

- Flutter and Dart
- BLoC state management
- Clean Architecture principles
- Repository Pattern
- Use Case design
- Local database persistence
- Hive
- CRUD operations
- Financial calculations
- Separation of concerns

## 🧪 Testing

The project includes testing for core application functionality.

The separation between presentation, domain, and data layers also provides a structure that can be tested independently.

## 📌 Project Status

The project is a completed academic/personal development project created to practice Flutter application architecture, state management, local persistence, and financial data handling.

## 👨‍💻 Author

**Miguel Arbeláez Vallejo**

Software Developer | Flutter / Dart | Full-Stack Development

- GitHub: https://github.com/MiguelArbelaez0
- LinkedIn: https://www.linkedin.com/in/miguel-arbelaez-v-57719542b/
