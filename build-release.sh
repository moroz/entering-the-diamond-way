#!/bin/sh
# Builds both themes from the pushed master and publishes them as a GitHub release.
# `./build-release.sh` tags v<YYYY.MM.DD>; `./build-release.sh v2026.10.06-2` picks the tag.
# The assets keep their build names (entering-<YYYYMMDD-HHMM>-<sha>-<theme>.pdf, see
# build.sh); never rename them.
#
# Needs jj, gh (signed in) and what build.sh needs. Pushing may rewrite commit ids (signing),
# so the release is built only once master is on GitHub: the sha in the file names is then
# the remote one.
set -eu
cd "$(dirname "$0")"

repo=moroz/entering-the-diamond-way
tag=${1:-v$(date +%Y.%m.%d)}
log() { jj log --no-pager --color=never --no-graph -r "$1" -T "$2"; }

[ "$(log @ 'empty')" = true ] || { echo "the working copy has changes; commit them first" >&2; exit 1; }
jj git fetch --no-pager >/dev/null
head=$(log @- 'commit_id')
[ "$head" = "$(log master 'commit_id')" ] || { echo "@- is not master; build from master" >&2; exit 1; }
[ "$head" = "$(log master@origin 'commit_id')" ] || { echo "master is not pushed; run jj git push first" >&2; exit 1; }
if gh release view "$tag" -R "$repo" >/dev/null 2>&1; then
    echo "release $tag exists; pass another tag, e.g. $tag-2" >&2
    exit 1
fi

files=$(./build.sh | tee /dev/stderr)
case $files in *-dirty-*) echo "built a dirty copy; not releasing" >&2; exit 1 ;; esac
short=$(log @- 'commit_id.short(7)')

# shellcheck disable=SC2086
gh release create "$tag" $files -R "$repo" --target "$head" \
    --title "當藏傳佛教與西方相遇 — $tag" \
    --notes "The Traditional Chinese edition typeset for reading on an iPad or a phone (164 × 236 mm page, the iPad 11th gen screen ratio), in a dark and a light theme. Built from $short with \`./build.sh\`."
gh release view "$tag" -R "$repo" --json url -q .url
