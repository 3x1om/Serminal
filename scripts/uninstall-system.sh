#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
REMOVE_SOURCE=true

if [[ "${1:-}" == "--keep-source" ]]; then
  REMOVE_SOURCE=false
fi

rm -f /usr/bin/serminal
rm -f /usr/share/applications/serminal.desktop
rm -f /usr/share/mime/packages/serminal.xml

update-desktop-database /usr/share/applications || true
update-mime-database /usr/share/mime || true

echo "Removed Serminal system-wide files."

if [[ "$REMOVE_SOURCE" == true ]]; then
  case "$PROJECT_ROOT" in
    /|"" )
      echo "error: refusing to remove unsafe path '$PROJECT_ROOT'" >&2
      exit 1
      ;;
  esac

  BASENAME="$(basename "$PROJECT_ROOT")"
  if [[ "$BASENAME" != "Serminal" ]]; then
    echo "error: refusing to remove source dir '$PROJECT_ROOT' (expected folder name: Serminal)" >&2
    echo "Use --keep-source and delete manually if needed." >&2
    exit 1
  fi

  rm -rf "$PROJECT_ROOT"
  echo "Deleted source folder: $PROJECT_ROOT"
else
  echo "Kept source folder: $PROJECT_ROOT"
fi
