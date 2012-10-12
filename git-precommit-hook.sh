#!/bin/sh

# Pre-commit hook passing files through jshint
# Heavily based on https://gist.github.com/3088698 by @svnlto

ROOT_DIR=$(git rev-parse --show-toplevel) # gets the path of this repo
CONF="--config=${ROOT_DIR}/build/config/jshint.json" # path of your jshint config
JSHINT=$(which jshint) # jshint path

if git rev-parse --verify HEAD >/dev/null 2>&1; then
    against=HEAD
else
    # Initial commit: diff against an empty tree object
    against=4b825dc642cb6eb9a060e54bf8d69288fbee4904
fi


for file in $(git diff-index --name-only ${against} -- | egrep \.js); do
    if $JSHINT $file ${CONF} 2>&1 | grep 'No errors found' ; then
        echo "jslint passed ${file}"
        exit 0
    else
        $JSHINT $file
        exit 1
    fi
done
