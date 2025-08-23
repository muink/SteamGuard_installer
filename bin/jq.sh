#!/bin/bash

CURDIR="$(cd "$(dirname $0)"; pwd)"


REPO=jqlang/jq
CPU_ABIS='x86_64:amd64
          x86:i386
          arm64-v8a:arm64
          armeabi-v7a:armhf'

RAWDATA="$(curl -sL "https://api.github.com/repos/$REPO/releases/latest")"
VERSION="$(echo "$RAWDATA" | jq -rc '.tag_name' 2>/dev/null)"
if [ -z "$VERSION" ]; then
    >&2 echo "Failed to get the latest version of jq, please retry later."
    exit 1
fi
echo "Latest version: $VERSION"

for cpu_abi in $CPU_ABIS; do
    jq_path="$CURDIR/${cpu_abi%%:*}/jq"
	checksum=($(echo "$RAWDATA" | jq -rc '.assets[]|select(.name == "jq-linux-'"${cpu_abi##*:}"'")|.digest' | tr ':' ' '))

    mkdir -p "$(dirname "$jq_path")" 2>/dev/null
	echo "${checksum[1]}  $jq_path" | ${checksum[0]}sum -c --status 2>/dev/null && continue || echo # skip download
    curl -Lo "$jq_path" https://github.com/$REPO/releases/download/$VERSION/jq-linux-${cpu_abi##*:}
	echo "${checksum[1]}  $jq_path" | ${checksum[0]}sum -c --status 2>/dev/null || { >&2 echo "Failed to download $VERSION/jq-linux-${cpu_abi##*:}, checksum does not match."; exit 1; }
	echo -n "${checksum[1]}" > "$jq_path.${checksum[0]}"
	echo "[${cpu_abi%%:*}] Download $VERSION/jq-linux-${cpu_abi##*:} completed."
done

echo "All done."
