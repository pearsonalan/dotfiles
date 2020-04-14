#!/bin/bash

function _make_backup_dir() {
	echo "- Creating backup directory $1"
	if [ "$DRYRUN" != "1" ]; then
		mkdir $1
	else
		echo mkdir $1
	fi
}

# Usage:
#  _backup_file .bashrc $BACKUPDIR
function _backup_file() {
	local _source_file="$HOME/$1"
	local _backup_file="$2/$1"
	if [ -f ${_source_file} -a ! -h ${_source_file} ]; then
		echo "- Backing up ${_source_file} to ${_backup_file}"
		if [ "$DRYRUN" != "1" ]; then
			cp ${_source_file} ${_backup_file}
		else
			echo cp ${_source_file} ${_backup_file}
		fi
	fi

	if [ -h ${_source_file} ]; then
		echo "- Not backing up symlink at ${_source_file}"
	fi
}

# Usage:
#   _install bashrc .bashrc
function _install() {
	local _source_file="$DOTFILEDIR/$1"
	local _dest_file="$HOME/$2"
	echo "- Installing ${_source_file} to ${_dest_file}"
	if [ -f ${_dest_file} ]; then
		echo "- Removing existing ${_dest_file}"
		if [ "$DRYRUN" != "1" ]; then
			rm ${_dest_file}
		else
			echo rm ${_dest_file}
		fi
	fi

	echo "- Linking ${_source_file} at ${_dest_file}"
	if [ "$DRYRUN" != "1" ]; then
		ln -s ${_source_file} ${_dest_file}
	else
		echo ln -s ${_source_file} ${_dest_file}
	fi
}

# Usage:
#  _update_uninstall .bashrc $BACKUPDIR
function _update_uninstall() {
	local _dest_file="$HOME/$1"
	local _backup_file="$2/$1"

	if [ "$DRYRUN" != "1" ]; then
		echo "rm -f ${_dest_file}" >> $BACKUPDIR/uninstall.sh
		echo "cp ${_backup_file} ${_dest_file}" >> $BACKUPDIR/uninstall.sh
	fi
}

# Usage:
#   backup_and_install dotfile sourcefile backupdir
function backup_and_install() {
	_backup_file $1 $3
	_install $2 $1
	_update_uninstall $1 $3
}

echo "- Installing dotfiles..."

DOTFILEDIR=$PWD
DATE=`date +"%s"`
BACKUPDIR="$HOME/.dotfiles-$DATE"
DRYRUN=0

_make_backup_dir $BACKUPDIR
if [ "$DRYRUN" != "1" ]; then
	echo "#!/bin/bash" > $BACKUPDIR/uninstall.sh
	chmod 755 $BACKUPDIR/uninstall.sh
fi

backup_and_install .bashrc bashrc $BACKUPDIR
backup_and_install .bash_aliases bash_aliases $BACKUPDIR
backup_and_install .tmux.conf tmux.conf $BACKUPDIR
backup_and_install .vimrc vimrc $BACKUPDIR

