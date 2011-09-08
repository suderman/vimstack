# Resolve this script's directory despite where it's called from and any symlinks
# http://stackoverflow.com/questions/59895/can-a-bash-script-tell-what-directory-its-stored-in/179231#179231
VIMSTACK="${BASH_SOURCE[0]}";
if([ -h "${VIMSTACK}" ]); then while([ -h "${VIMSTACK}" ]) do VIMSTACK=`readlink "${VIMSTACK}"`; done; fi
pushd . > /dev/null; cd `dirname ${VIMSTACK}` > /dev/null; VIMSTACK=`pwd`; popd  > /dev/null

# Link up vimrc
ln -sf "$VIMSTACK/vimrc.vim" "$HOME/.vimrc"

mkdir -p "$HOME/.vim/bundle"
mkdir -p "$HOME/.vim/local/bundle"
mkdir -p "$HOME/.vim/stack/simple/bundle"

# Set something current
rm -f "$HOME/.vim/current"
ln -sf "$HOME/.vim/stack/simple" "$HOME/.vim/current"
