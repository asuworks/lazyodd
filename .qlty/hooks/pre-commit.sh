#!/bin/sh
qlty fmt --trigger pre-commit --index-file="$GIT_INDEX_FILE"
qlty check \
	--trigger pre-commit \
	--skip-errored-plugins
