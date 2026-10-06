#!/bin/sh
# Compiles the book to out/entering-<YYYYMMDD-HHMM>-<sha>[-dirty]-<theme>.pdf: local build
# time, the short commit id of the revision being built, "-dirty" if the working copy has
# changes, and the theme. With no argument it builds both themes (dark, light);
# `./build.sh light` builds one. Extra typst options go in $TYPST_ARGS.
# With jj (colocated): the revision is @- and "dirty" means @ is not empty. Without jj
# (a plain git clone): HEAD and `git status --porcelain`.
set -eu
cd "$(dirname "$0")"

if [ -d .jj ] && command -v jj >/dev/null 2>&1; then
    sha=$(jj log --no-pager --color=never -r @- --no-graph -T 'commit_id.short(7)')
    [ "$(jj log --no-pager --color=never -r @ --no-graph -T 'empty')" = true ] || sha="$sha-dirty"
elif git rev-parse --git-dir >/dev/null 2>&1; then
    sha=$(git rev-parse --short=7 HEAD)
    [ -z "$(git status --porcelain)" ] || sha="$sha-dirty"
else
    sha=nogit
fi

themes=${1:-"dark light"}
./fetch-fonts.sh
mkdir -p out
base="out/entering-$(date +%Y%m%d-%H%M)-$sha"
for theme in $themes; do
    case $theme in
        dark | light) ;;
        *) echo "unknown theme: $theme (dark or light)" >&2; exit 1 ;;
    esac
    out="$base-$theme.pdf"
    # shellcheck disable=SC2086
    typst compile --font-path fonts --ignore-system-fonts ${TYPST_ARGS:-} --input theme="$theme" entering.typ "$out"
    echo "$out"
done
