function dotboot() {
    rm -rf ~/.tmux/tmux.conf && ln symlink/tmux.conf ~/.tmux/tmux.conf
    rm -rf ~/.vim/.vimrc    && ln symlink/vimrc ~/.vim/.vimrc   
    rm -rf ~/.gitconfig && ln symlink/gitconfig ~/.gitconfig
    rm -rf ~/.npmrc && ln symlink/npmrc ~/.npmrc

    ./install/brew.sh
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