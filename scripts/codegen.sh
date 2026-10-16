#!/usr/bin/env bash
# Regenerates localizations and freezed/json/retrofit/injectable code.
set -euo pipefail
cd "$(dirname "$0")/.."

FLUTTER="${FLUTTER:-fvm flutter}"
DART="${DART:-fvm dart}"

$FLUTTER pub get
$FLUTTER gen-l10n
$DART run build_runner build
