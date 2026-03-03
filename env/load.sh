ENV_DIR="${DOTFILES:-$HOME/.dotfiles}/env"

for f in "$ENV_DIR"/*.sh; do
  [ -f "$f" ] || continue
  case "$f" in
    */load.sh) continue ;;
  esac
  source "$f"
done
