#!/usr/bin/env bash
# Install this Herdr config into ~/.config/herdr/config.toml
# Safe to re-run. Backs up an existing config.toml first.
set -euo pipefail

REPO="https://github.com/blankdean/tech-lead-herdr-config"
HERDR_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/herdr"
DEST="${HERDR_CONFIG_PATH:-$HERDR_DIR/config.toml}"
LINK=0

usage() {
    cat <<'EOF'
Usage: ./install.sh [--link]

  (default)  Copy config.toml into ~/.config/herdr/config.toml
  --link     Symlink that path to this repo (for developing the config)

Does not install Herdr itself. See https://herdr.dev/docs/install/
EOF
}

while [ "${1:-}" != "" ]; do
    case "$1" in
    -h | --help)
        usage
        exit 0
        ;;
    --link)
        LINK=1
        ;;
    *)
        echo "unknown option: $1" >&2
        usage >&2
        exit 2
        ;;
    esac
    shift
done

bold() { printf '\n\033[1m==> %s\033[0m\n' "$*"; }
warn() { printf '\033[33mwarn:\033[0m %s\n' "$*"; }

# Resolve the directory that contains config.toml.
# curl | bash has no sibling files, so clone a throwaway copy.
ROOT=""
if [ -f "${BASH_SOURCE[0]:-}" ]; then
    ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
fi
if [ ! -f "${ROOT}/config.toml" ]; then
    TMP="$(mktemp -d "${TMPDIR:-/tmp}/tech-lead-herdr-config.XXXXXX")"
    bold "Cloning ${REPO}"
    git clone --depth 1 "$REPO" "$TMP/tech-lead-herdr-config"
    ROOT="$TMP/tech-lead-herdr-config"
fi
SRC="${ROOT}/config.toml"

mkdir -p "$(dirname "$DEST")"

if [ -e "$DEST" ] || [ -L "$DEST" ]; then
    backup="${DEST}.bak.$(date +%Y%m%d%H%M%S)"
    bold "Backing up existing config to ${backup}"
    cp -a "$DEST" "$backup"
    rm -f "$DEST"
fi

if [ "$LINK" -eq 1 ]; then
    bold "Symlinking ${DEST} -> ${SRC}"
    ln -s "$SRC" "$DEST"
else
    bold "Installing ${DEST}"
    cp "$SRC" "$DEST"
fi

if ! command -v herdr >/dev/null 2>&1; then
    cat <<'EOF'

Herdr is not on PATH. Install it, then reload:

  curl -fsSL https://herdr.dev/install.sh | sh
  herdr config check
  herdr server reload-config

EOF
    exit 0
fi

bold "Validating"
herdr config check

if herdr status >/dev/null 2>&1; then
    bold "Reloading running server"
    herdr server reload-config
else
    warn "Herdr server is not running — config applies on next launch"
fi

printf '\nDone. Config: %s\n' "$DEST"
printf 'Help inside Herdr: prefix then ?  (prefix is Ctrl-a)\n'
