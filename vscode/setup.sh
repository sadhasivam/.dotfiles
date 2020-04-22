function setupCode() {
    rm -rf ~/Library/Application\ Support/Code/User
    ln -s ~/dotfiles/vscode/User ~/Library/Application\ Support/Code/User
}

read -p "This may overwrite existing files in your Visual Code User Settings directory. Are you sure? (y/n) " -n 1;
echo "";
if [[ $REPLY =~ ^[Yy]$ ]]; then
    case "$(uname)" in
        Darwin*)
            setupCode;
        ;;
        Linux*)
            echo "OS $(uname) not supported yet... "
        ;;
    esac
fi;
