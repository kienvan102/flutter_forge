# ─────────────────────────────────────────────────────────────────────────────
# Flutter Forge — Makefile
# Usage: make <command>
# Run `make help` to see all available commands
# ─────────────────────────────────────────────────────────────────────────────

DART        := dart run --enable-asserts
FLUTTER     := flutter
VAULT       := secure_vault
TOUR        := dart_tour

# ── Help ──────────────────────────────────────────────────────────────────────
.PHONY: help
help:
	@echo ""
	@echo "  Flutter Forge"
	@echo "  ─────────────────────────────────────────────────────"
	@echo ""
	@echo "  Dart Tour"
	@echo "    make tour-01        Run dart_tour exercise 01 (basics)"
	@echo "    make tour-02        Run dart_tour exercise 02 (null safety)"
	@echo "    make tour-03        Run dart_tour exercise 03 (collections)"
	@echo "    make tour-04        Run dart_tour exercise 04 (async/await)"
	@echo "    make tour-05        Run dart_tour exercise 05 (streams)"
	@echo "    make tour-06        Run dart_tour exercise 06 (oop)"
	@echo "    make tour-07        Run dart_tour exercise 07 (functional)"
	@echo "    make tour-all       Run all exercises in sequence"
	@echo ""
	@echo "  Solutions"
	@echo "    make solution-01    Run solution for exercise 01"
	@echo ""
	@echo "  SecureVault"
	@echo "    make setup          First-time setup (generates platform folders)"
	@echo "    make codegen        Run build_runner (Riverpod, Drift, Freezed)"
	@echo "    make run-web        Run on Chrome"
	@echo "    make run-macos      Run on macOS desktop"
	@echo "    make run-mobile     Run on connected mobile device/simulator"
	@echo "    make run-ios        Run on iOS simulator"
	@echo "    make run-android    Run on Android emulator"
	@echo ""
	@echo "  Build"
	@echo "    make build-web      Build Flutter web bundle"
	@echo "    make build-macos    Build macOS app"
	@echo "    make build-android  Build Android APK (debug)"
	@echo "    make build-all      Build web + macOS + android"
	@echo ""
	@echo "  Quality"
	@echo "    make test           Run all tests"
	@echo "    make test-coverage  Run tests with coverage report"
	@echo "    make analyze        Run Flutter static analysis"
	@echo "    make check          analyze + test (run before committing)"
	@echo ""

# ── Dart Tour ─────────────────────────────────────────────────────────────────
.PHONY: tour-01 tour-02 tour-03 tour-04 tour-05 tour-06 tour-07 tour-all

tour-01:
	@echo "▶  dart_tour/01_basics"
	@cd $(TOUR) && $(DART) 01_basics/main.dart

tour-02:
	@echo "▶  dart_tour/02_null_safety"
	@cd $(TOUR) && $(DART) 02_null_safety/main.dart

tour-03:
	@echo "▶  dart_tour/03_collections"
	@cd $(TOUR) && $(DART) 03_collections/main.dart

tour-04:
	@echo "▶  dart_tour/04_async_await"
	@cd $(TOUR) && $(DART) 04_async_await/main.dart

tour-05:
	@echo "▶  dart_tour/05_streams"
	@cd $(TOUR) && $(DART) 05_streams/main.dart

tour-06:
	@echo "▶  dart_tour/06_oop"
	@cd $(TOUR) && $(DART) 06_oop/main.dart

tour-07:
	@echo "▶  dart_tour/07_functional"
	@cd $(TOUR) && $(DART) 07_functional/main.dart

tour-all:
	@echo "▶  Running all dart_tour exercises...\n"
	@$(MAKE) tour-01
	@$(MAKE) tour-02
	@$(MAKE) tour-03
	@$(MAKE) tour-04
	@$(MAKE) tour-05
	@$(MAKE) tour-06
	@$(MAKE) tour-07
	@echo "\n🏁 All tour exercises passed!"

# ── Solutions ─────────────────────────────────────────────────────────────────
.PHONY: solution-01

solution-01:
	@echo "▶  solutions/01_basics"
	@cd $(TOUR) && $(DART) solutions/01_basics.dart

# ── SecureVault Setup ─────────────────────────────────────────────────────────
.PHONY: setup codegen

setup:
	@echo "▶  Running first-time setup..."
	@cd $(VAULT) && bash setup.sh

codegen:
	@echo "▶  Running build_runner..."
	@cd $(VAULT) && dart run build_runner build --delete-conflicting-outputs

# ── Run ───────────────────────────────────────────────────────────────────────
.PHONY: run-web run-macos run-mobile run-ios run-android

run-web:
	@cd $(VAULT) && $(FLUTTER) run -d chrome -t lib/main.dart

run-macos:
	@cd $(VAULT) && $(FLUTTER) run -d macos -t lib/main.dart

run-mobile:
	@cd $(VAULT) && $(FLUTTER) run -t lib/main.dart

run-ios:
	@cd $(VAULT) && $(FLUTTER) run -d iPhone -t lib/main.dart

run-android:
	@cd $(VAULT) && $(FLUTTER) run -d emulator -t lib/main.dart

# ── Build ─────────────────────────────────────────────────────────────────────
.PHONY: build-web build-macos build-android build-all

build-web:
	@echo "▶  Building Flutter web..."
	@cd $(VAULT) && $(FLUTTER) build web --release -t lib/main.dart

build-macos:
	@echo "▶  Building macOS app..."
	@cd $(VAULT) && $(FLUTTER) build macos --release -t lib/main.dart

build-android:
	@echo "▶  Building Android APK (debug)..."
	@cd $(VAULT) && $(FLUTTER) build apk --debug -t lib/main.dart

build-all: build-web build-macos build-android
	@echo "✅  All builds complete"

# ── Quality ───────────────────────────────────────────────────────────────────
.PHONY: test test-coverage analyze check

test:
	@echo "▶  Running tests..."
	@cd $(VAULT) && $(FLUTTER) test

test-coverage:
	@echo "▶  Running tests with coverage..."
	@cd $(VAULT) && $(FLUTTER) test --coverage
	@cd $(VAULT) && genhtml coverage/lcov.info -o coverage/html --quiet
	@echo "✅  Coverage report: $(VAULT)/coverage/html/index.html"
	@open $(VAULT)/coverage/html/index.html 2>/dev/null || true

analyze:
	@echo "▶  Running flutter analyze..."
	@cd $(VAULT) && $(FLUTTER) analyze

check: analyze test
	@echo "✅  All checks passed — safe to commit"
