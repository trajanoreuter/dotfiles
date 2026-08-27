#!/bin/sh
# navigator.sh — navegação vim-aware entre panes do herdr.
#
# Equivalente ao guard `is_vim` que o christoomey/vim-tmux-navigator instalava
# no .tmux.conf: <C-h/j/k/l> movem o foco entre panes, mas quando o pane em
# foco está rodando (n)vim a tecla é repassada para o editor, que decide entre
# trocar de split ou devolver o movimento ao herdr (ver
# ~/.config/nvim/lua/trajanoreuter/core/herdr.lua).
#
# Ligado em [[keys.command]] no ~/.config/herdr/config.toml.
# Docs: https://herdr.dev/docs/cli-reference/#panes

set -eu

direction="${1:?usage: navigator.sh left|down|up|right}"
pane="${HERDR_ACTIVE_PANE_ID:-}"
[ -n "$pane" ] || exit 0

herdr="${HERDR_BIN_PATH:-herdr}"

case "$direction" in
left) key="ctrl+h" ;;
down) key="ctrl+j" ;;
up) key="ctrl+k" ;;
right) key="ctrl+l" ;;
*) exit 1 ;;
esac

info=$("$herdr" pane process-info --pane "$pane" 2>/dev/null || true)

case "$info" in
*'"name":"nvim"'* | *'"name":"vim"'* | *'"name":"view"'* | *'"name":"nvim.bin"'*)
	exec "$herdr" pane send-keys "$pane" "$key"
	;;
*)
	exec "$herdr" pane focus --pane "$pane" --direction "$direction"
	;;
esac
