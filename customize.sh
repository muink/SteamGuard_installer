#!/system/bin/sh
SKIPUNZIP=1

CPU_ABIS=$(getprop ro.product.cpu.abilist)

ui_print "[+] Extracting module files"
unzip -o "$ZIPFILE" -x 'bin/*' -x 'META-INF/*' -d $MODPATH >&2
set_perm_recursive $MODPATH 0 0 0755 0644

ui_print "[+] Install jq command"
unzip -o "$ZIPFILE" 'bin/*' -d $TMPDIR >&2
file_path="$TMPDIR/bin/${CPU_ABIS}/jq"
(echo "$(cat "$file_path.sha256")  $file_path" | sha256sum -c -s -) || abort "[-] Failed to verify jq binary."
mkdir -p $MODPATH/system/bin 2>/dev/null
cp -f $file_path $MODPATH/system/bin/jq
set_perm $MODPATH/system/bin/jq 0 0 755

ui_print "[+] Installation completed!"
ui_print "[+] Please execute the \"Action\" after rebooting."
