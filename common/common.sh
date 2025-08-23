#!/system/bin/sh
#
# depends jq

sleep_pause() {
    # APatch and KernelSU needs this
    # but not KSU_NEXT, MMRL
    if [ -z "$MMRL" ] && [ -z "$KSU_NEXT" ] && { [ "$KSU" = "true" ] || [ "$APATCH" = "true" ]; }; then
        sleep 6
    fi
}

# func <str>
decodeBase64Str() {
	jq -Rrc '@base64d' <<< "$1" 2>/dev/null
}

# func <str>
encodeBase64Str() {
	echo -n "$1" | jq -Rrc '@base64' 2>/dev/null
}

# func <objvar> <filters> [args]
jsonSelect() {
	local obj="${!1}" filters="$2"
	shift 2

	eval "echo \"\$obj\" | jq -c --args '${filters:-.}' \"\$@\" | jq -r './/\"\"'"
}
