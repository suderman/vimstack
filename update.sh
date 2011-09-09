# Resolve current stack
cd $HOME/.vim/current/
CURRENT_STACK=`pwd -P`
cd - > /dev/null

# Empty and recreate the stack's bundle dir
rm -rf $CURRENT_STACK/.bundle
mkdir -p $CURRENT_STACK/.bundle
mkdir -p $CURRENT_STACK/bundle
mkdir -p $HOME/.vim/bundle

# Look for all bundle mentions
echo "Collecting bundle mentions in $CURRENT_STACK..."
grep -hir "BUNDLE:\|BUNDLE-COMMAND:" $CURRENT_STACK > $CURRENT_STACK/bundle/.bundle

# Read each line
while read LINE ; do

  # Attempt a bundle command
  BUNDLE_COMMAND=${LINE#*BUNDLE-COMMAND: }
  if [[ $BUNDLE_COMMAND != *BUNDLE:* ]]; then
    echo "$BUNDLE_NAME command found. Running..."
    cd $BUNDLE_PATH
    eval $BUNDLE_COMMAND
    cd - > /dev/null
    continue
  fi

  # Parse line for variables
  STRING=${LINE#*//}; STRING=${STRING#*/}; STRING=${STRING%.git*}
  BUNDLE_NAME=`echo $STRING | sed -e 's/\//-/g'`
  BUNDLE_URL=${LINE#*BUNDLE: }
  BUNDLE_PATH="$HOME/.vim/bundle/$BUNDLE_NAME"

  # Check if the bundle already exists
  if [ -d "$BUNDLE_PATH" ]; then
    
    # Attempt to update if it's a git repository
    if [ -d "$BUNDLE_PATH/.git" ]; then
      echo "$BUNDLE_NAME found. Updating..."
      cd $BUNDLE_PATH
      git pull
      cd - > /dev/null

    # Just a regular directory
    else
      echo "$BUNDLE_NAME found."
    fi

  # If it's new, clone the repository
  else
    echo "$BUNDLE_NAME is new! Installing..."
    git clone $BUNDLE_URL $BUNDLE_PATH
  fi
  
  # Symlink the bundle into the stack's bundle dir
  ln -sf $BUNDLE_PATH $CURRENT_STACK/.bundle/$BUNDLE_NAME

done < $CURRENT_STACK/bundle/.bundle
