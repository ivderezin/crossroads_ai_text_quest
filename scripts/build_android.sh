#!/usr/bin/env bash
# Builds a release APK (and an App Bundle with --aab) into dist/.
# Usage: scripts/build_android.sh [--aab] [extra flutter build args]
set -euo pipefail
cd "$(dirname "$0")/.."

FLUTTER="${FLUTTER:-fvm flutter}"
BUILD_AAB=false
ARGS=()
for arg in "$@"; do
  if [[ "$arg" == "--aab" ]]; then BUILD_AAB=true; else ARGS+=("$arg"); fi
done

scripts/codegen.sh

$FLUTTER build apk --release ${ARGS[@]+"${ARGS[@]}"}
mkdir -p dist
cp build/app/outputs/flutter-apk/app-release.apk dist/

if $BUILD_AAB; then
  $FLUTTER build appbundle --release ${ARGS[@]+"${ARGS[@]}"}
  cp build/app/outputs/bundle/release/app-release.aab dist/
fi

echo "Artifacts in $(pwd)/dist"
