#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────────
# SecureVault — First-time setup script
# Run this once from inside the secure_vault/ directory:
#   bash setup.sh
#
# What it does:
#   1. Checks Flutter is installed
#   2. Creates a temp Flutter project to get the platform folders
#   3. Copies android/ ios/ web/ macos/ windows/ linux/ into this project
#   4. Cleans up the temp project
#   5. Runs flutter pub get
#   6. Runs build_runner for code generation
# ─────────────────────────────────────────────────────────────────────────────

set -e  # exit on any error

# ── Colors ────────────────────────────────────────────────────────────────────
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # no color

log()  { echo -e "${GREEN}✅ $1${NC}"; }
warn() { echo -e "${YELLOW}⚠️  $1${NC}"; }
err()  { echo -e "${RED}❌ $1${NC}"; exit 1; }

# ── Check we're in the right place ────────────────────────────────────────────
if [ ! -f "pubspec.yaml" ]; then
  err "Run this script from inside the secure_vault/ directory"
fi

if ! grep -q "name: secure_vault" pubspec.yaml; then
  err "This doesn't look like the secure_vault project (pubspec.yaml mismatch)"
fi

# ── Check Flutter is installed ────────────────────────────────────────────────
if ! command -v flutter &> /dev/null; then
  err "Flutter not found. Install it first: https://docs.flutter.dev/get-started/install"
fi

FLUTTER_VERSION=$(flutter --version --machine 2>/dev/null | python3 -c "import sys,json; print(json.load(sys.stdin)['frameworkVersion'])" 2>/dev/null || flutter --version | head -1)
log "Flutter found: $FLUTTER_VERSION"

# ── Enable all desktop platforms ─────────────────────────────────────────────
log "Enabling desktop platforms..."
flutter config --enable-macos-desktop  --quiet
flutter config --enable-windows-desktop --quiet
flutter config --enable-linux-desktop  --quiet
flutter config --enable-web            --quiet

# ── Create temp project ───────────────────────────────────────────────────────
TEMP_DIR=$(mktemp -d)
TEMP_PROJECT="$TEMP_DIR/sv_tmp"

log "Creating temporary Flutter project for platform scaffolding..."
flutter create \
  --org com.flutterforge \
  --project-name secure_vault \
  --platforms ios,android,web,macos,windows,linux \
  --quiet \
  "$TEMP_PROJECT"

log "Temporary project created at $TEMP_PROJECT"

# ── Copy platform folders ─────────────────────────────────────────────────────
PLATFORMS=(android ios web macos windows linux)

for platform in "${PLATFORMS[@]}"; do
  if [ -d "$TEMP_PROJECT/$platform" ]; then
    if [ -d "$platform" ]; then
      warn "$platform/ already exists — skipping (delete it manually to regenerate)"
    else
      cp -r "$TEMP_PROJECT/$platform" .
      log "Copied $platform/"
    fi
  else
    warn "$platform/ not available on this machine (ok — skip for now)"
  fi
done

# ── Copy other generated files ────────────────────────────────────────────────
# .gitignore additions from flutter create
if [ ! -f ".metadata" ]; then
  cp "$TEMP_PROJECT/.metadata" . 2>/dev/null || true
fi

# ── Clean up temp project ─────────────────────────────────────────────────────
rm -rf "$TEMP_DIR"
log "Cleaned up temporary project"

# ── Install dependencies ──────────────────────────────────────────────────────
log "Running flutter pub get..."
flutter pub get

# ── Code generation ───────────────────────────────────────────────────────────
log "Running build_runner (generates Riverpod, Freezed, Drift files)..."
dart run build_runner build --delete-conflicting-outputs

# ── Done ──────────────────────────────────────────────────────────────────────
echo ""
echo -e "${GREEN}────────────────────────────────────────────────${NC}"
echo -e "${GREEN}  SecureVault is ready! Try running it:${NC}"
echo -e "${GREEN}────────────────────────────────────────────────${NC}"
echo ""
echo "  flutter run -d chrome          # Web (fastest)"
echo "  flutter run -d macos           # macOS desktop"
echo "  flutter run                    # Mobile (pick device)"
echo ""
