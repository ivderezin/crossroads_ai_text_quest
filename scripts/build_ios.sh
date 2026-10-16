#!/usr/bin/env bash
# Builds a signed release IPA into dist/.
# Requires Xcode with a signing team configured for the Runner target.
# Usage: scripts/build_ios.sh [--export-options path/to/ExportOptions.plist] [extra flutter build args]
set -euo pipefail
cd "$(dirname "$0")/.."

FLUTTER="${FLUTTER:-fvm flutter}"

scripts/codegen.sh

$FLUTTER build ipa --release "$@"
mkdir -p dist
cp build/ios/ipa/*.ipa dist/

echo "Artifacts in $(pwd)/dist"
