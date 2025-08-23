#!/system/bin/sh
SKIPUNZIP=1

CPU_ABIS=$(getprop ro.product.cpu.abilist)

SUPPORTS_32BIT=false
SUPPORTS_64BIT=false

if [[ "$CPU_ABIS" == *"x86"* && "$CPU_ABIS" != "x86_64" || "$CPU_ABIS" == *"armeabi"* ]]; then
    SUPPORTS_32BIT=true
    ui_print "[-] Device supports 32-bit"
fi

if [[ "$CPU_ABIS" == *"x86_64"* || "$CPU_ABIS" == *"arm64-v8a"* ]]; then
    SUPPORTS_64BIT=true
    ui_print "[-] Device supports 64-bit"
fi

ui_print "[+] Extracting module files"
unzip -o "$ZIPFILE" -x 'bin/*' -x 'META-INF/*' -d $MODPATH >&2
set_perm_recursive $MODPATH 0 0 0755 0644

ui_print "[+] Install jq command"
unzip -o "$ZIPFILE" 'bin/*' -d $TMPDIR >&2
if [ "$ARCH" = "x86" ] || [ "$ARCH" = "x64" ]; then
    [ "$SUPPORTS_32BIT" = true ] && CPU_ABI='x86' || echo -n ''
    [ "$SUPPORTS_64BIT" = true ] && CPU_ABI='x86_64' || echo -n ''
else
    [ "$SUPPORTS_32BIT" = true ] && CPU_ABI='armeabi-v7a' || echo -n ''
    [ "$SUPPORTS_64BIT" = true ] && CPU_ABI='arm64-v8a' || echo -n ''
fi
file_path="$TMPDIR/bin/${CPU_ABI}/jq"
[ -f "$file_path" ] || abort "[-] jq binary for ${CPU_ABI} not found in the module zip."
(echo "$(cat "$file_path.sha256")  $file_path" | sha256sum -c -s -) || abort "[-] Failed to verify jq binary."
mkdir -p $MODPATH/system/bin 2>/dev/null
cp -f $file_path $MODPATH/system/bin/jq
set_perm $MODPATH/system/bin/jq 0 0 755

ui_print "[+] Installation completed!"
ui_print "[+] Please execute the \"Action\" after rebooting."
