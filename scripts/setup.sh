
mkdir ~/dotfiles/backup

cp ~/.tmux/tmux.conf ~/dotfiles/backup/tmux_`date +%d-%m-%Y`.conf
rm ~/.tmux/tmux.conf 2> /dev/null
ln ~/dotfiles/symlink/tmux.conf ~/.tmux/tmux.conf

cp ~/.vim/.vimrc ~/dotfiles/backup/vimrc_`date +%d-%m-%Y`.conf
rm ~/.vim/.vimrc 2> /dev/null
ln ~/dotfiles/symlink/vimrc ~/.vim/.vimrc