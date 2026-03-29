#!/bin/bash -e

set -o pipefail

submodules=$(git submodule)
if [ -z "$submodules" ]; then
	exit 0
fi

git config get -f .gitmodules --all --regexp '\.url$' | while read -r url; do
	case "$url" in
		http://*) ;;
		https://*) ;;
		*) echo "error: found non-HTTP url \"$url\"" 1>&2; exit 1;;
	esac
done

exit 0
