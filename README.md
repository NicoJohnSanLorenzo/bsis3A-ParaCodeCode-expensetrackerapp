# 💸 Expense Tracker

> A Flutter mobile application for managing personal finances — offline-first, with optional REST API sync.

---

## 📋 Table of Contents

- [Overview](#overview)
- [Tech Stack](#tech-stack)
- [Features](#features)
- [Project Structure](#project-structure)
- [Data Flow](#data-flow)
- [Configuration](#configuration)
- [Dependencies](#dependencies)
- [Getting Started](#getting-started)

---

## Overview

Expense Tracker is a Flutter mobile app that lets users record, edit, and delete personal expenses. Data is stored locally in SQLite for reliable offline access. User preferences (currency) are persisted via SharedPreferences. A REST API sync feature is available once a backend URL is configured.

---

## Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter (Dart) |
| State Management | Provider / ChangeNotifier |
| Local Database | sqflite (SQLite) |
| Preferences | shared_preferences |
| Networking | http package |
| Architecture | 3-layer: UI → Provider → (SQLite + API) |

---

## Features

### ➕ Core Expense Management

| Feature | Description |
|---|---|
| Add Expense | Create a new expense with a title and amount. Saved instantly to SQLite. |
| Edit Expense | Modify the title and/or amount of any existing expense. |
| Delete Expense | Remove an expense permanently from local storage. |
| Expense List | View all expenses in a scrollable list ordered by creation time. |
| Total Summary | A card at the top shows the running sum of all expenses. |
| Expense Count | Subtitle on the summary card shows the total number of expenses. |

---

### 🗄️ Offline-First with SQLite

| Feature | Description |
|---|---|
| Persistent Storage | All expenses stored in `expenses.db` via sqflite. |
| Instant Load | Expenses load from SQLite on startup — no network required. |
| Full CRUD | Insert, read, update, and delete via `ExpenseDatabase`. |
| Safe Re-insert | Uses `ConflictAlgorithm.replace` so duplicate IDs are handled safely. |
| Ordered Fetch | Expenses fetched by `rowid` (insertion order). |
| API Cache Sync | `replaceAll()` atomically swaps local data with API results in a transaction. |

---

### 💱 Currency Preferences (SharedPreferences)

| Feature | Description |
|---|---|
| Currency Picker | Tap the currency icon in the app bar to switch currencies. |
| Supported Currencies | ₱ PHP, $ USD, € EUR, ¥ JPY, ₩ KRW |
| Persistent Setting | Selection saved via SharedPreferences and restored on relaunch. |
| Live Update | Changing currency instantly re-renders all amounts in the list. |
| Default Currency | Defaults to ₱ (Philippine Peso) if no preference is saved. |

---

### 🌐 REST API Sync

| Feature | Description |
|---|---|
| Manual Sync | Tap the sync icon in the app bar to pull from the remote backend. |
| Full Replace | Remote data atomically replaces the local SQLite cache. |
| Last Sync Time | Timestamp of last successful sync saved and displayed on screen. |
| Loading State | Linear progress indicator shown while sync is in progress. |
| Error Banner | Orange banner with a Retry button shown on sync failure. |
| Configurable URL | Set `ApiService.baseUrl` to point to your own backend. |
| Full CRUD API | `ApiService` supports GET, POST, PUT, and DELETE endpoints. |

---

### 🎨 User Interface

| Feature | Description |
|---|---|
| Home Screen | Total summary card, expense list, and action buttons. |
| Add/Edit Screen | Shared form screen; switches between add and edit mode based on context. |
| Fade Transitions | Custom `FadeRoute` provides smooth fade-in/out between screens. |
| Custom App Bar | Green-themed app bar with currency picker and sync button. |
| Material Design | Cards with rounded corners, elevation shadows, and CircleAvatar icons. |
| Empty State | Displays "No expenses yet." when the list is empty. |
| FAB | Floating Action Button for quickly adding a new expense. |

---

## Project Structure

```
lib/
├── main.dart                    # App entry point, MultiProvider setup
├── models/
│   └── expense.dart             # Expense model (toMap, fromMap, toJson, fromJson)
├── db/
│   └── expense_database.dart    # SQLite singleton, all CRUD operations
├── providers/
│   └── expenses_provider.dart   # Business logic; coordinates DB + API + prefs
├── services/
│   └── api_service.dart         # HTTP client (GET / POST / PUT / DELETE)
└── screens/
    ├── home_screen.dart          # Main screen: summary card + expense list
    └── add_expense_screen.dart   # Add & edit expense form
```

---

## Data Flow

### App Startup
1. `WidgetsFlutterBinding.ensureInitialized()` called before any plugin loads.
2. `ExpensesProvider` initializes → loads SharedPreferences (currency, lastSync).
3. SQLite database opens → all expenses fetched and rendered instantly.

### Add / Edit / Delete
1. User action triggers a provider method (`addExpense`, `editExpense`, `deleteExpense`).
2. In-memory list updated immediately for instant UI feedback.
3. SQLite write performed asynchronously.
4. `notifyListeners()` triggers a UI rebuild.

### API Sync
1. User taps Sync → `syncFromApi()` called on the provider.
2. Loading state set → progress indicator shown.
3. `ApiService` fetches expenses from the remote backend.
4. `replaceAll()` atomically clears SQLite and inserts remote data.
5. `lastSync` timestamp saved to SharedPreferences.
6. UI rebuilds with fresh data.

---

## Configuration

### Backend URL

Update `baseUrl` in `lib/services/api_service.dart`:

```dart
static const String baseUrl = 'http://your-backend-url:port';
```

> **Android emulator connecting to localhost:** use `http://10.0.2.2:3000`

---

### Default Currency

Change the default in `lib/providers/expenses_provider.dart`:

```dart
String _currency = '₱'; // Change to '$', '€', '¥', or '₩'
```

---

## Dependencies

```yaml
dependencies:
  provider: ^6.x.x          # State management — ChangeNotifier pattern
  sqflite: ^2.x.x            # SQLite database for offline-first storage
  path: ^1.x.x               # Cross-platform path resolution for SQLite
  shared_preferences: ^2.x.x # Key-value storage for user settings
  http: ^1.x.x               # HTTP client for REST API communication
```

---

## Getting Started

```bash
# 1. Install dependencies
flutter pub get

# 2. Run the app
flutter run
```

> The app works fully offline out of the box. API sync is optional — configure `ApiService.baseUrl` and tap the sync icon whenever your backend is ready.

---

## Notes

- Expense IDs are generated from `DateTime.now().millisecondsSinceEpoch` — guaranteed unique for local creates.
- The database uses a single `expenses` table with columns: `id TEXT`, `title TEXT`, `amount REAL`.
- `ExpenseDatabase` is a singleton — one connection is shared across the app lifetime.
- API sync is a **full replace**, not a merge. Local-only changes will be overwritten on sync.