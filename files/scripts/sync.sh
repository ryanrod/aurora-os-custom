#!/usr/bin/env bash
set -Eeuo pipefail

# -------- CONFIG --------
REMOTE_NAME="gdrive"
REMOTE_BASE="M11BB-Linux-Mint-Backup"
LOCAL_HOME="$HOME"

DIRS=(
  "Desktop"
  "Documents"
  "Family History"
  "Music"
  "My Audio Recordings"
  "My Documents From D (Old)"
  "Pictures"
  "Videos"
)
# ------------------------

RESYNC=false
DRY_RUN=false

# -------- ERROR HANDLER --------
trap 'echo; echo "ERROR: Script failed at line $LINENO."; echo "Press Enter to exit..."; read' ERR

# -------- ARG PARSING --------
for arg in "$@"; do
  case "$arg" in
    --resync)
      RESYNC=true
      ;;
    --dry-run)
      DRY_RUN=true
      ;;
    *)
      echo "Unknown option: $arg"
      exit 1
      ;;
  esac
done

# -------- WARNINGS --------
if $RESYNC; then
  echo "⚠️  WARNING: --resync forces rclone to rebuild sync state."
  echo "⚠️  This can cause deletions if your folders are not aligned."
  echo
  read -p "Type YES to continue: " CONFIRM
  if [[ "$CONFIRM" != "YES" ]]; then
    echo "Aborted."
    exit 1
  fi
fi

if $DRY_RUN; then
  echo "ℹ️  DRY RUN ENABLED — no changes will be made."
fi

# -------- BUILD RCLONE FLAGS --------
RCLONE_FLAGS=(
  --verbose
  --progress
)

$RESYNC && RCLONE_FLAGS+=(--resync)
$DRY_RUN && RCLONE_FLAGS+=(--dry-run)

# -------- SYNC LOOP --------
for DIR in "${DIRS[@]}"; do
  LOCAL_PATH="$LOCAL_HOME/$DIR"
  REMOTE_PATH="$REMOTE_NAME:$REMOTE_BASE/$DIR"

  if [[ ! -d "$LOCAL_PATH" ]]; then
    echo "Skipping missing directory: $LOCAL_PATH"
    continue
  fi

  echo
  echo "=== Syncing $DIR ==="

  rclone bisync "$LOCAL_PATH" "$REMOTE_PATH" "${RCLONE_FLAGS[@]}"
done

echo
echo "All sync operations completed."
read -p "Press Enter to exit..."