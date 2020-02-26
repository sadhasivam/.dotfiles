function dotboot() {
    rm -rf ~/.tmux/tmux.conf && ln symlink/tmux.conf ~/.tmux/tmux.conf
    rm -rf ~/.vim/.vimrc    && ln symlink/vimrc ~/.vim/.vimrc   
    rm -rf ~/.npmrc && ln symlink/npmrc ~/.npmrc

    rm -rf ~/.editorconfig
    
    rm -rf ~/.gitignore_global && ln git/.gitignore_global ~/.gitignore_global
    rm -rf ~/.gitconfig && ln git/.gitconfig ~/.gitconfig
    # ./install/brew.sh
}

read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
echo "";
if [[ $REPLY =~ ^[Yy]$ ]]; then
    case "$(uname)" in
        Darwin*)
            dotboot;
        ;;
        Linux*)
            echo "OS $(uname) not supported yet... "
        ;;
    esac
fi;
