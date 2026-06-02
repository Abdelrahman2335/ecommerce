# Copilot Agent Instructions — Provider → Bloc Migration (E-Commerce Flutter App)

## 1. Project Overview

This is a Flutter **e-commerce application** undergoing a full architectural migration away from `Provider`/`ChangeNotifier` toward `flutter_bloc` (Event/State pattern), with dependency injection managed by `get_it` + `injectable`.

The migration is driven by code quality and architectural correctness — not CV optics. The goal is a codebase where UI **never** mutates state directly, business logic is fully isolated from widgets, and every async operation is triggered by a typed Event.

**Deadline:** June 18, 2026.

---

## 2. Architecture Decision (Non-Negotiable)

### Why we are leaving Provider
- Provider/ChangeNotifier bleeds business logic into UI files.
- `notifyListeners()` is imperative and untrackable.
- State mutations are scattered across widgets and providers with no enforced boundary.

### What we adopted
- **`flutter_bloc`** — Event/State pattern. Inspired by Android's MVI pattern.
- **`get_it` + `injectable`** — compile-time safe DI via code generation.
- **Strict separation:** UI dispatches Events → Bloc processes → emits States → UI rebuilds. No exceptions.

### Rules that Copilot must enforce on every file it touches

1. **No `notifyListeners()`.** Delete it. It does not belong anywhere.
2. **No `Provider.of<T>(context)`** or `Consumer<T>` widgets. Replace with `BlocBuilder`, `BlocListener`, or `BlocConsumer`.
3. **No async operations in constructors.** Move all initialization logic into an `InitEvent` (or equivalent) dispatched from `initState`.
4. **No direct state mutation from the UI.** The only way for a widget to change state is `context.read<XBloc>().add(SomeEvent())`.
5. **No `ProxyProvider` or `ChangeNotifierProxyProvider`.** Cross-feature state sharing must use Bloc-to-Bloc communication or read from a parent Bloc's state.
6. **Blocs must be registered with `@injectable`.** Use the integrated terminal tool to execute `flutter pub run build_runner build --delete-conflicting-outputs` after adding any new `@injectable` annotated class.
7. **After each feature migration:** Run `flutter analyze` and resolve all warnings/errors before proceeding to the next feature.

---

## 3. File Structure Convention

Bloc files for each feature live under:

```
lib/
└── features/
    └── <feature_name>/
        └── presentation/
            └── manager/
                ├── <feature>_event.dart
                ├── <feature>_state.dart
                └── <feature>_bloc.dart
```

State models follow the pattern:

```dart
// <feature>_state.dart
abstract class CartState extends Equatable {}

class CartInitial extends CartState { ... }
class CartLoading extends CartState { ... }
class CartSuccess extends CartState { final CartModel cart; ... }
class CartError extends CartState { final String message; ... }
```

Events follow the pattern:

```dart
// <feature>_event.dart
abstract class CartEvent extends Equatable {}

class CartInitialized extends CartEvent { ... }
class CartItemAdded extends CartEvent { final Product product; ... }
class CartItemRemoved extends CartEvent { final String productId; ... }
class CartQuantityUpdated extends CartEvent { final String productId; final int quantity; ... }
```

---

## 4. Global Conventions (Apply to Every Feature)

These conventions were established during the Global Setup phase and must be respected on every file Copilot modifies:

- **State modeling:** Every Bloc must expose at minimum: `Initial`, `Loading`, `Success`, `Error` states.
- **Error mapping:** All errors (Firebase, Dio, domain `Failure` types) must be mapped to human-readable strings or typed `Failure` classes before reaching the UI. Do not let raw exceptions surface in State.
- **Validators:** Shared input validators live in `core/utils/validators.dart`. Do not duplicate validation logic inside Blocs or widgets.
- **No constructor side-effects:** `ChangeNotifier` constructors often called async methods. In Bloc, the constructor does nothing — the first event (`XInitialized`) is dispatched from the widget's `initState` or `BlocProvider`.
- **Ephemeral UI state:** You may use `StatefulWidget` only for local UI concerns like animations, focus, and expand/collapse toggles that are not business logic.

---

## 5. Migration Status

| Feature          | Status        | ETA              |
|------------------|---------------|------------------|
| Global Setup     | ✅ Done       | —                |
| Auth             | ✅ Done       | —                |
| Location         | ✅ Done       | —                |
| Home             | ✅ Done       | —                |
| Wishlist         | ✅ Done       | —                |
| **Cart**         | 🔲 Not started | Jun 3 – Jun 5   |
| **Checkout**     | 🔲 Not started | Jun 8 – Jun 12  |
| **Payment**      | 🔲 Not started | Jun 13 – Jun 15 |
| **Orders**       | 🔲 Not started | Jun 16 – Jun 18 |

---

## 6. Per-Feature Task Breakdown

### 6.1 — Cart Feature
**Component:** Cart | **Priority:** High

**Scope:** cart initialization, add item, remove item, quantity updates.

**Checklist (Execute one step at a time, complete each step fully before moving to the next):**

**Step 1: Bloc & DI**
1. [ ] Create `CartEvent` / `CartState` / `CartBloc` under `presentation/manager/`.
2. [ ] In `CartBloc`, ensure the constructor body is empty. Remove any `Future.microtask` or async initialization calls that exist in the old Provider class.
3. [ ] Remove duplicate repository initialization patterns (the old provider likely instantiated the repo directly — DI must own this now via `get_it`).

**Step 2: Repo Integration**
4. [ ] Confirm the existing repository persistence mechanism for cart rehydration; do not add new persistence.
5. [ ] Implement `CartInitialized` so it rehydrates state from the repo layer on startup.
6. [ ] If persistence read fails or data is corrupted during `CartInitialized`, catch the error, emit `CartError` with a clear reason, and fall back to an empty cart.

**Step 3: UI Replacement**
7. [ ] Dispatch `CartInitialized` from the cart screen's `initState` (or the `BlocProvider`'s `create` callback) to trigger rehydration on mount.
8. [ ] Replace all `cart_provider.dart` calls with typed Bloc events (`CartItemAdded`, `CartItemRemoved`, `CartQuantityUpdated`).

---

### 6.2 — Checkout Feature
**Component:** Orders | **Priority:** High

**Scope:** address selection, promo code validation, order summary, order confirmation.

**Checklist:**
- [ ] Create `CheckoutEvent` / `CheckoutState` / `CheckoutBloc` under `presentation/manager/`.
- [ ] Do not move address business logic into `CheckoutBloc`. Keep checkout-specific logic in `CheckoutBloc`, and read address data from a separate `AddressBloc` state or pass it into the event. **Do not use `ProxyProvider`.**
- [ ] Add dedicated typed events for:
  - `PromoCodeApplied` → validate and recompute totals.
  - `PromoCodeCleared` → revert totals.
  - `OrderSummaryLoaded` → fetch and emit totals.
- [ ] Add strict **pre-submit validations** inside the Bloc before emitting a success state:
  - Cart must be non-empty.
  - Address must be selected.
  - Payment method must be selected.
  - If any condition fails, emit a typed `CheckoutValidationError` state with a specific reason enum — do not use generic strings.

---

### 6.3 — Payment Feature
**Component:** Payments | **Priority:** High

**Scope:** payment method selection, payment processing.

**Checklist:**
- [ ] Create `PaymentEvent` / `PaymentState` / `PaymentBloc` under `presentation/manager/`.
- [ ] Move **payment method selection** into a `PaymentMethodSelected` event — the widget must not store the selected method in local state.
- [ ] Move **payment request** into a `PaymentSubmitted` event. The Bloc handles the API call.
- [ ] Remove all hardcoded customer placeholder values (e.g., hardcoded IDs, emails). Customer data must come from `AuthBloc` state or equivalent — inject the Bloc or pass values via the event.
- [ ] Implement **typed failure mapping:**
  - Network timeout → `PaymentTimeoutFailure`
  - Server rejection → `PaymentRejectedFailure` (with reason from API)
  - Unknown → `PaymentUnknownFailure`
- [ ] Add **retry logic:** On `PaymentTimeoutFailure`, allow the user to retry by re-dispatching `PaymentSubmitted`. Do not re-initiate from the widget — the Bloc should expose a `canRetry` flag in state.

---

### 6.4 — Order Management Feature
**Component:** Orders | **Priority:** High

**Scope:** place order, cancel order, fetch order history.

**Checklist:**
- [ ] Create `OrderEvent` / `OrderState` / `OrderBloc` under `presentation/manager/`.
- [ ] Model the three operations as **independent event-state paths** (not a single monolithic state):
  - `OrderPlaced` → `OrderPlacingLoading` / `OrderPlacingSuccess` / `OrderPlacingError`
  - `OrderCancelled` → `OrderCancellingLoading` / `OrderCancellingSuccess` / `OrderCancellingError`
  - `OrderHistoryFetched` → `OrderHistoryLoading` / `OrderHistorySuccess` / `OrderHistoryError`
- [ ] **Fix repository path issues before wiring:** Review the order repository for incorrect import paths or method signatures that return `ChangeNotifier` or require `BuildContext`. Refactor these to return raw `Future` or `Stream` data types before connecting to the Bloc.
- [ ] Ensure the Bloc does not hold a reference to a stale repository instance — all repo access goes through `get_it`.

---

## 7. What Done Looks Like (Definition of Done per Feature)

A feature migration is complete when:

1. **No Provider code remains** in the feature's `presentation/` layer. Old `ChangeNotifier` / `Provider` classes are deleted.
2. **All UI state reads** happen via `BlocBuilder` or `BlocSelector`. No `setState` is used for business state.
3. **All user actions** are dispatched as typed Events. Widgets do not call repository or service methods directly.
4. **`@injectable` annotation is present** on the Bloc and `flutter pub run build_runner build` has been run successfully.
5. **`flutter analyze` returns zero issues** for the feature's directory.
6. **Manual flow test passes:** The feature works end-to-end without crashes or regressions.

---

## 8. What Copilot Must NOT Do

- Do not suggest keeping any Provider or ChangeNotifier code as a "bridge" — full migration only.
- Do not use `setState` for anything that belongs in the Bloc.
- Do not create God Blocs. If a concern belongs to a different domain, it gets its own Bloc. Example: address selection in Checkout belongs in a dedicated `AddressBloc`, not `CheckoutBloc`. Promo code logic, however, is cohesive with checkout totals and stays in `CheckoutBloc`.
- Do not add `BlocProvider` manually in widgets if the Bloc is already provided higher up in the tree.
- Do not use `context.watch<XProvider>()` — this is Provider API and does not belong here.
- Do not leave `TODO` comments without a linked task. If something is deferred, mark it with `// DEFERRED: <reason>` and document it.