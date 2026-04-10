#!/bin/sh

# Parse flags
AUTO_YES=false
for arg in "$@"; do
    case $arg in
        -y|--yes)
            AUTO_YES=true
            shift
            ;;
        -h|--help)
            echo "Usage: dotstrap.sh [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  -y, --yes    Skip confirmation prompt and proceed automatically"
            echo "  -h, --help   Show this help message"
            exit 0
            ;;
        *)
            echo "Unknown option: $arg"
            echo "Use -h or --help for usage information"
            exit 1
            ;;
    esac
done

# Confirm unless -y flag is provided
if [ "$AUTO_YES" = false ]; then
    read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
    echo "";
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

case "$(uname)" in
    Darwin*)
        ~/.dotfiles/install/macos.sh;
    ;;
    Linux*)
        echo "OS $(uname) not supported yet... "
    ;;
esac
