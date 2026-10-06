#!/bin/sh
# Compiles the book to out/entering-<theme>.pdf, in both themes (dark, light).
# `./build.sh light` builds one theme. Extra typst options go in $TYPST_ARGS.
set -eu
cd "$(dirname "$0")"

themes=${1:-"dark light"}
./fetch-fonts.sh
mkdir -p out
for theme in $themes; do
    case $theme in
        dark | light) ;;
        *) echo "unknown theme: $theme (dark or light)" >&2; exit 1 ;;
    esac
    out="out/entering-$theme.pdf"
    # shellcheck disable=SC2086
    typst compile --font-path fonts --ignore-system-fonts ${TYPST_ARGS:-} --input theme="$theme" entering.typ "$out"
    echo "$out"
done
