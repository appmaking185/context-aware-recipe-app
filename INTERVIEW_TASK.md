# Flutter E-Commerce Interview Task (Provider)

## Objective

Build a clean, scalable Flutter E-Commerce app that demonstrates mid-level skills: API integration, Firebase Google Auth, **Provider** state management, pagination, cart, offline handling, and responsive UI.

## API

- Base: `https://dummyjson.com/products`
- Docs: https://dummyjson.com/docs/products
- Pagination: `?limit=10&skip=0`
- Search: `/products/search?q=phone`
- Category: `/products/category/{slug}`
- Categories list: `/products/categories` → array of `{slug, name, url}`

### Sample product fields

`id`, `title`, `description`, `category`, `price`, `discountPercentage`, `rating`, `stock`, `brand`, `thumbnail`, `images`, `availabilityStatus` (`In Stock`, `Low Stock`, etc.)

## Mandatory features

| Module | Requirements |
|--------|----------------|
| **Auth** | Google Sign-In (Firebase), persistent session, logout, auto-login, cancel/error handling |
| **Dashboard** | Profile image, name, email, human-readable address, permission states |
| **Products** | List with image, title, price, discount %, rating, brand, stock status |
| **Pagination** | Infinite scroll, loading footer, no duplicate calls, pull-to-refresh, end-of-list |
| **Details** | Image carousel, description, prices, rating, category, brand, availability |
| **Cart** | Add/update/remove, no duplicate rows, sync across screens, subtotal/discount/payable |
| **Search/Filter** | Search, category filter, sort (price ↑↓, rating) |
| **Offline** | Connectivity listener, retry, optional cart + listing cache (Hive) |

## State management

**Provider** (`ChangeNotifier` + `Consumer` / `context.watch`)

Layers: UI → Provider → Repository → API/Local service

## Architecture

```
lib/ecommerce/
  core/
  data/        (models, services, repositories)
  domain/      (repository contracts)
  presentation/ (providers, screens, widgets)
```

## Run this project scaffold

```bash
flutter pub get

# Firebase setup (required for Google login)
# 1. Create Firebase project
# 2. Add Android google-services.json + SHA-1
# 3. Add iOS GoogleService-Info.plist
# 4. flutterfire configure

flutter run -t lib/main_ecommerce.dart
```

## Submission

- Source code
- Release APK
- README: setup, architecture, Provider usage, libraries, assumptions

## Evaluation weights

| Area | Weight |
|------|--------|
| Architecture & code quality | 25% |
| State management (Provider) | 20% |
| Firebase auth | 15% |
| API & pagination | 15% |
| Cart logic | 10% |
| UI/UX | 10% |
| Error handling | 5% |

## Bonus

- Dark mode, shimmer, debounced search, DI, unit/widget tests
