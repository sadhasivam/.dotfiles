function dotboot() {
    rm -rf $HOME/.tmux/tmux.conf && ln symlink/tmux.conf $HOME/.tmux/tmux.conf
    rm -rf $HOME/.vim/.vimrc    && ln symlink/vimrc $HOME/.vim/.vimrc   
    rm -rf $HOME/.npmrc && ln symlink/npmrc $HOME/.npmrc

    rm -rf $HOME/.curlrc && ln symlink/curlrc $HOME/.curlrc    
    rm -rf $HOME/.gitignore_global && ln git/.gitignore_global $HOME/.gitignore_global
    rm -rf $HOME/.gitconfig && ln git/.gitconfig $HOME/.gitconfig
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
