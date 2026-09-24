#!/usr/bin/env bash
set -Eeuo pipefail

LOCAL_BIN="$HOME/.local/bin"
CONFIG_DIR="$HOME/.config"
BACKUP_DIR="$HOME/dotfiles-backups"

say() {
    printf '\n==> %s\n' "$*"
}

fail() {
    printf 'Error: %s\n' "$*" >&2
    exit 1
}

for command_name in curl dirname id uname; do
    command -v "$command_name" >/dev/null 2>&1 || fail "Required command '$command_name' is missing. Install it manually, then run install.sh again."
done

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
CURRENT_USER="$(id -un)"

backup_path() {
    local source="$1"
    local destination="$2"
    local candidate="$destination"
    local suffix=1

    while [[ -e "$candidate" || -L "$candidate" ]]; do
        candidate="$destination.$suffix"
        ((suffix += 1))
    done
    say "Backing up $source"
    mv -- "$source" "$candidate"
}

login_shell_for_user() {
    if [[ "$(uname -s)" == "Darwin" ]]; then
        dscl . -read "/Users/$CURRENT_USER" UserShell 2>/dev/null | awk '{print $2}'
    else
        getent passwd "$CURRENT_USER" | cut -d: -f7
    fi
}

check_required_commands() {
    local missing=()
    local command_name
    for command_name in "${REQUIRED_COMMANDS[@]}"; do
        command -v "$command_name" >/dev/null 2>&1 || missing+=("$command_name")
    done
    if (( ${#missing[@]} > 0 )); then
        printf 'Error: required utilities are missing: %s\n' "${missing[*]}" >&2
        printf 'Install them manually, then run install.sh again.\n' >&2
        return 1
    fi
}

[[ -d "$SCRIPT_DIR/.config" ]] || fail "Could not find .config in $SCRIPT_DIR. Run the installer from a complete repository checkout."
[[ -d "$SCRIPT_DIR/deps" ]] || fail "Could not find deps in $SCRIPT_DIR."
cd -- "$SCRIPT_DIR"

OS_NAME="$(uname -s)"
case "$OS_NAME" in
    Darwin)
        PLATFORM=mac
        ;;
    Linux)
        if [[ -r /etc/os-release ]]; then
            . /etc/os-release
            DISTRO_IDS="${ID:-} ${ID_LIKE:-}"
            case " $DISTRO_IDS " in
                *" arch "*) PLATFORM=arch ;;
                *" debian "*|*" ubuntu "*) PLATFORM=debian ;;
                *) PLATFORM=unsupported ;;
            esac
        else
            PLATFORM=unsupported
        fi
        ;;
    *)
        PLATFORM=unsupported
        ;;
esac

if [[ "$PLATFORM" == unsupported || ! -f "$SCRIPT_DIR/deps/$PLATFORM" ]]; then
    printf 'Automatic dependency installation is not supported on %s (%s).\n' "$(uname -s)" "${ID:-unknown distribution}" >&2
    printf 'The installer needs these utilities: bash, curl, git, stow, zsh, sudo, chsh, awk, cut, dirname, id, ln, mkdir, mv, uname, and getent (Linux) or dscl (macOS).\n' >&2
    if [[ ! -t 0 ]]; then
        printf 'Cannot ask whether to continue because standard input is not a terminal. Install the utilities manually and run install.sh again.\n' >&2
        exit 1
    fi
    read -r -p 'Continue without automatic dependency installation? [y/N] ' answer
    case "$answer" in
        [yY]|[yY][eE][sS]) ;;
        *) printf 'Installation cancelled.\n'; exit 0 ;;
    esac
fi

REQUIRED_COMMANDS=(awk cut git ln mkdir mv stow sudo chsh zsh)
if [[ "$OS_NAME" == Darwin ]]; then
    REQUIRED_COMMANDS+=(dscl)
else
    REQUIRED_COMMANDS+=(getent)
fi
if [[ "$PLATFORM" != unsupported ]]; then
    say "Installing system dependencies"
    curl --fail --location --silent --show-error \
        https://raw.githubusercontent.com/owpk/dots-misc/refs/heads/main/install-deps.sh |
        bash -s -- "$SCRIPT_DIR/deps"
fi
check_required_commands || exit 1

mkdir -p -- "$CONFIG_DIR" "$LOCAL_BIN"

say "Backing up existing dotfiles to $BACKUP_DIR"
mkdir -p -- "$BACKUP_DIR/.config"

shopt -s nullglob dotglob
for path in "$SCRIPT_DIR/.config/"*; do
    [[ -e "$path" || -L "$path" ]] || continue
    name="${path##*/}"
    existing="$CONFIG_DIR/$name"
    if [[ -e "$existing" || -L "$existing" ]]; then
        backup_path "$existing" "$BACKUP_DIR/.config/$name"
    fi
done

for name in .zshenv .tmux.conf; do
    existing="$HOME/$name"
    if [[ -e "$existing" || -L "$existing" ]]; then
        backup_path "$existing" "$BACKUP_DIR/$name"
    fi
done

say "Linking configuration files"
stow --adopt --verbose --target="$CONFIG_DIR" .config
stow --adopt --verbose --target="$LOCAL_BIN" scripts
ln -sfn -- "$SCRIPT_DIR/.zshenv" "$HOME/.zshenv"
ln -sfn -- "$SCRIPT_DIR/.tmux.conf" "$HOME/.tmux.conf"

say "Preparing Git branch for $CURRENT_USER"
if git -C "$SCRIPT_DIR" show-ref --verify --quiet "refs/heads/$CURRENT_USER"; then
    git -C "$SCRIPT_DIR" checkout "$CURRENT_USER"
else
    git -C "$SCRIPT_DIR" checkout -b "$CURRENT_USER"
fi

if command -v zsh >/dev/null 2>&1; then
    ZSH_PATH="$(command -v zsh)"
    if [[ "$(login_shell_for_user)" != "$ZSH_PATH" ]]; then
        say "Setting $ZSH_PATH as the login shell for $CURRENT_USER"
        sudo chsh -s "$ZSH_PATH" "$CURRENT_USER"
    else
        say "Zsh is already the login shell"
    fi
else
    fail "Zsh was not installed. Install it and run the installer again to set it as the login shell."
fi

say "Installing GigaChat client"
curl --fail --location --silent --show-error \
    https://github.com/owpk/gigachat-grpc-client/raw/main/install.sh |
    bash

say "Installation complete. Backups are in $BACKUP_DIR."
