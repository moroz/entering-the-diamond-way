#!/bin/sh
# Downloads the book's fonts (SIL OFL, from the Google Fonts repository) into fonts/ unless
# they are already there. They are not kept in git: Noto Serif TC alone is 16 MB.
set -eu
cd "$(dirname "$0")"

base=https://github.com/google/fonts/raw/main/ofl
mkdir -p fonts
fetch() {
    [ -f "fonts/$1" ] && return
    echo "fetching fonts/$1" >&2
    curl -fsSL -o "fonts/$1.part" "$base/$2" && mv "fonts/$1.part" "fonts/$1"
}
fetch NotoSerifTC.ttf 'notoseriftc/NotoSerifTC%5Bwght%5D.ttf'
fetch SourceSerif4.ttf 'sourceserif4/SourceSerif4%5Bopsz,wght%5D.ttf'
fetch SourceSerif4-Italic.ttf 'sourceserif4/SourceSerif4-Italic%5Bopsz,wght%5D.ttf'
