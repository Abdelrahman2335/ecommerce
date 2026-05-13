# E-Commerce Refactor Migration Checkpoints

## Purpose
This document defines the refactor checkpoints to move the project from Provider to Bloc, clean up legacy/deprecated patterns, and raise code quality to production-level standards.

## Goals
- Replace Provider/ChangeNotifier flows with Bloc (event + state + bloc files) per feature.
- Remove fragile patterns and deprecated usage where found.
- Improve reliability, testability, and maintainability across all features.
- Keep the app functional while migrating feature by feature.

## Migration Rules
- Migrate one feature at a time.
- For each migrated feature, create:
  - feature_event.dart
  - feature_state.dart
  - feature_bloc.dart
- Bloc talks to repository interfaces only.
- Remove old provider files only after parity checks pass.
- No feature is marked complete without tests and manual flow verification.

---

## Global Checkpoints (Apply To All Features)
- [ ] Add flutter_bloc dependency and project-level Bloc conventions.
- [ ] Standardize loading/success/error state modeling.
- [ ] Standardize error mapping (Firebase/Dio/domain failures).
- [ ] Remove direct Provider.of/Consumer usage in migrated screens.
- [ ] Add route safety checks for protected pages and route extras.
- [ ] Add shared validators in core utils and remove duplicated regex in widgets.
- [ ] Ensure no constructor async side-effects (move init to events).
- [ ] Add/refresh unit tests and widget tests for migrated flows.
- [ ] Run analyze and resolve warnings/errors after each feature migration.

---

## Feature Checkpoints

### 1) Auth Feature
Scope:
- create_user, login, registration, address flows.

Checkpoints:
- [ ] Create separate blocs for signup, login/session, registration, and address.
- [ ] Add explicit field-change events (email/password/name/phone/age/gender).
- [ ] Replace provider form mutations with event-driven state updates.
- [x] Migrate registration screens to BlocBuilder/BlocListener.
- [ ] Migrate create user and login screens to BlocBuilder/BlocListener.
- [ ] Preserve repository contracts and normalize error handling paths.
- [ ] Verify navigation outcomes for success/failure states.
- [ ] Remove legacy auth providers after parity confirmation.

Definition of done:
- Auth flows work end-to-end with no Provider dependency in auth screens.

### 2) Home Feature
Scope:
- product load, category filter, search.

Checkpoints:
- [ ] Create HomeEvent/HomeState/HomeBloc.
- [ ] Move fetch/filter/search logic into events.
- [ ] Add clear empty/loading/error UI states.
- [ ] Migrate home widgets to consume bloc state only.
- [ ] Validate behavior parity for categories and item listing.

Definition of done:
- Home screen behavior matches current behavior with better state clarity.

### 3) Cart Feature
Scope:
- cart init, add/remove item, quantity updates.

Checkpoints:
- [ ] Create CartEvent/CartState/CartBloc.
- [ ] Replace cart provider calls with bloc events.
- [ ] Remove duplicate repository initialization patterns.
- [ ] Remove constructor microtask initialization and use init event.
- [ ] Add persistence checkpoint (cart state survives restart).

Definition of done:
- Cart operations are stable, event-driven, and persisted.

### 4) Wishlist Feature
Scope:
- wishlist init and item toggle.

Checkpoints:
- [ ] Create WishlistEvent/WishlistState/WishlistBloc.
- [ ] Migrate wishlist screen and controls to bloc-driven state.
- [ ] Optimize repository usage to avoid unnecessary refetching.
- [ ] Validate add/remove parity with current behavior.

Definition of done:
- Wishlist flow uses bloc and performs efficiently.

### 5) Checkout Feature
Scope:
- address selection, promo validation, summary, confirmation.

Checkpoints:
- [ ] Create CheckoutEvent/CheckoutState/CheckoutBloc.
- [ ] Merge or coordinate address checkout state without ProxyProvider.
- [ ] Add dedicated events for promo apply/validate and totals recompute.
- [ ] Add strict pre-submit validations (cart, address, payment method).
- [ ] Migrate checkout widgets and button enable/disable logic to bloc state.

Definition of done:
- Checkout flow is deterministic and validated before submit.

### 6) Payment Feature
Scope:
- payment method selection and payment processing.

Checkpoints:
- [ ] Create PaymentEvent/PaymentState/PaymentBloc.
- [ ] Move method selection and payment request to events.
- [ ] Remove hardcoded customer placeholders and use checkout/auth state.
- [ ] Add typed failure mapping and retry/timeout handling.
- [ ] Verify successful payment transition into order flow.

Definition of done:
- Payment flow is secure, predictable, and error-resilient.

### 7) Order Management Feature
Scope:
- place order, cancel order, fetch order history.

Checkpoints:
- [ ] Create OrderEvent/OrderState/OrderBloc.
- [ ] Fix repository path and correctness issues before final wiring.
- [ ] Model place/cancel/history as independent event-state paths.
- [ ] Ensure order result states are reflected in checkout completion UX.

Definition of done:
- Order lifecycle works correctly and is observable in UI states.

### 8) Location Shared Flow
Scope:
- geolocation, reverse geocoding, address setup interactions.

Checkpoints:
- [ ] Create LocationEvent/LocationState/LocationBloc.
- [ ] Replace location provider/viewmodel usage in shared widgets.
- [ ] Align location outputs with auth registration and checkout address flow.
- [ ] Add failure states for permission denied/location unavailable.

Definition of done:
- Location behavior is unified and reusable across features.

### 9) Unsplash Feature (Decision Gate)
Scope:
- currently partial/inactive integration.

Checkpoints:
- [ ] Decide keep vs remove.
- [ ] If keep: migrate to UnsplashEvent/UnsplashState/UnsplashBloc.
- [ ] If remove: delete dead code and dependency references.

Definition of done:
- No ambiguous partial feature remains.

---

## Final Cleanup Checkpoints
- [ ] Remove CreateUserProvider and other migrated provider files.
- [ ] Remove Provider wiring from app bootstrap when all features are migrated.
- [ ] Keep dependency graph clean (remove unused packages/imports).
- [ ] Normalize folder naming inconsistencies after functional parity.

## Verification Gate (Before Marking Migration Complete)
- [ ] flutter analyze passes with no new issues.
- [ ] Unit tests for bloc transitions pass.
- [ ] Widget tests cover loading/error/success states for main feature screens.
- [ ] Manual E2E path passes: signup/login -> browse -> cart -> checkout -> payment -> order.
- [ ] Failure path passes: invalid data, network failure, payment failure, retry.

## Notes
- This checklist is intentionally ordered for safe incremental migration.
- Feature implementation can be split into small PRs, one bloc migration at a time.
