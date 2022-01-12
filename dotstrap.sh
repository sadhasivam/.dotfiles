#!/bin/sh

read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
echo "";
if [[ $REPLY =~ ^[Yy]$ ]]; then
    case "$(uname)" in
        Darwin*)
            ~/.dotfiles/install/macos.sh;
        ;;
        Linux*)
            echo "OS $(uname) not supported yet... "
        ;;
    esac
fi;
