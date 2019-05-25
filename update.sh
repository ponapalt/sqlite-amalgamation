#!/bin/bash

# Copyright (c) 2019 Mezumona Kosaki
# This script is released under the 2-Clause BSD License.
# See https://opensource.org/licenses/BSD-2-Clause

# SQLite Source Code Is Public Domain.
# See https://www.sqlite.org/copyright.html

GIT_URL='git@github.com:mezum/sqlite-amalgamation-mirror.git'
BASE_URL='https://www.sqlite.org/'
HTML_PATH='download.html'
TMP_DIR='./temp/sqlite'
INSTALL_DIR='./src'
VERSION_PATH='./VERSION'

ZIP_FILE_PATH="$(curl -sS $BASE_URL$HTML_PATH | grep -o -e '[0-9]*/sqlite-amalgamation-[0-9]*\.zip')"
ZIP_FILE_URL="$BASE_URL$ZIP_FILE_PATH"

PREV_URL="$(cat "$VERSION_PATH")"

if [[ $ZIP_FILE_URL == $PREV_URL ]]; then
	echo 'up to date.'
	exit 0
fi

rm -rf "$TMP_DIR"
mkdir -p "$TMP_DIR"
curl -LsS -o "$TMP_DIR/sqlite.zip" $ZIP_FILE_URL

git remote set-url origin "$GIT_URL"
git checkout master

unzip -j "$TMP_DIR/sqlite.zip" -d "$INSTALL_DIR"
echo -n "$ZIP_FILE_URL" > "$VERSION_PATH"

git add "$INSTALL_DIR" "$VERSION_PATH"
git commit -m "update to '$ZIP_FILE_PATH'."
git push origin master
