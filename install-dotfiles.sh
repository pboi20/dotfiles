#!/usr/bin/env bash

#
# Config
#
LINK="true"
FILES=".bashrc .vimrc .vimrc-plugins .gitconfig"
TEMPLATES=".npmrc"
BUILD_DIR="build"

#
# Helper functions
#
function backup_file() {
    local ORIG="$1"
    local BACKUP="$ORIG-bk-$(date +%s)"

    if [ -e "$ORIG" ]; then
        mv "$ORIG" "$BACKUP" 
    fi
}

function install_file() {
    local BUILD="$1"
    local ORIG="$2"

    if [ "$LINK" == "true" ]; then
        ln -s "$BUILD" "$ORIG"
    else
        cp -r "$BUILD" "$ORIG"
    fi
}

#
# Build directory for templates
#
if [ -n $BUILD_DIR ]; then
    mkdir $BUILD_DIR
fi

#
# Install static files
#
for f in $FILES; do
    NEW="$PWD/$f"
    ORIG="$HOME/$f"
    BACKUP="$HOME/$f-bk-$(date +%s)"

    backup_file "$ORIG"
    install_file "$NEW" "$ORIG"
done

#
# Build and install templated files
#
for f in $TEMPLATES; do
    TEMPLATE="$PWD/$f.template"
    BUILD="$PWD/$BUILD_DIR/$f"
    ORIG="$HOME/$f"

    backup_file "$ORIG"
    backup_file "$BUILD"
    bash "$TEMPLATE" > "$BUILD"
    install_file "$BUILD" "$ORIG"
done

#
# Platform-specific
#
if [ "$(uname)" == "Linux" ]
then
    # Nothing here
fi

if [ "$(uname)" == "Darwin" ]
then
    BASHRC="$HOME/.bashrc"
    PROFILE="$HOME/.profile"

    backup_file "$PROFILE"
    ln -s "$BASHRC" "$PROFILE"
fi

