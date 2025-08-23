#!/system/bin/sh
#
# depends jq

MODDIR=${0%/*}

# Please encode the dump of SteamGuardDump using base64 and place it between the two single quotes below.
DumpDATA=''
# Samples
guardPATH='/data_mirror/data_ce/null/0/com.valvesoftware.android.steam.community/files/Steamguard-7612341512311041'
uuid_xmlPATH='/data_mirror/data_ce/null/0/com.valvesoftware.android.steam.community/shared_prefs/steam.uuid.xml'
RKStoragePATH='/data_mirror/data_ce/null/0/com.valvesoftware.android.steam.community/databases/RKStorage'

# Common functions
sleep_pause() {
    # APatch and KernelSU needs this
    # but not KSU_NEXT, MMRL
    if [ -z "$MMRL" ] && [ -z "$KSU_NEXT" ] && { [ "$KSU" = "true" ] || [ "$APATCH" = "true" ]; }; then
        sleep 6
    fi
}

# func <str>
decodeBase64Str() {
    echo -n "$1" | jq -Rrc '@base64d' 2>/dev/null
}

# func <str>
encodeBase64Str() {
    echo -n "$1" | jq -Rrc '@base64' 2>/dev/null
}

# func <objvar> <filters> [args]
jsonSelect() {
    local obj filters="$2"
    eval "obj=\"\$$1\""
    shift 2

    eval "echo \"\$obj\" | jq -c --args '${filters:-.}' \"\$@\" | jq -r './/\"\"'"
}



# Main
[ -n "${DumpDATA}" ] || { echo "[+] DumpDATA is empty! exit..."; sleep_pause; exit 1; }
DumpDATA="$(decodeBase64Str "$DumpDATA")"
[ "$?" = "0" ] || { echo "[+] DumpDATA decode failed! exit..."; sleep_pause; exit 1; }
echo "$DumpDATA" | jq >/dev/null 2>&1 || { echo "[+] Decoded DumpDATA is not a valid json! exit..."; sleep_pause; exit 1; }

OWNGRP="$(ls -l "$uuid_xmlPATH" | awk '{print $3":"$4}')"
UUID="$(jsonSelect DumpDATA '.uuid_key')"

echo "[+] Install Steamguard file..."
for steamID in $(jsonSelect DumpDATA '.accounts|keys[]'); do
    jsonSelect DumpDATA '.accounts["'"${steamID}"'"]' > "$(dirname "$guardPATH")/Steamguard-${steamID}"
    chown $OWNGRP "$(dirname "$guardPATH")/Steamguard-${steamID}"
    chmod 600     "$(dirname "$guardPATH")/Steamguard-${steamID}"
    echo "[-] Steamguard-${steamID} installed."
done
echo

#```json
#{
#    "shared_secret": "sJHkjdx1gluzJlwB6L7LklYSg=",
#    "serial_number": "9343661234462106438",
#    "revocation_code": "Z14513",
#    "uri": "otpauth:\/\/totp\/Steam:zhangsan123?secret=W123Wfds1123fdsH123JI&issuer=Steam",
#    "account_name": "zhangsan123",
#    "token_gid": "25e5x55f001449ee",
#    "identity_secret": "HY8\/eDpZYcrasdvfewtkyweEfs=",
#    "secret_1": "Qywu12fY9L7Bt\/JVaOmQ123wr8=",
#    "steamguard_scheme": 2,
#    "steamid": "7612341512311041"
#}
#```

echo "[+] Install steam.uuid.xml..."
cat <<-XML > "$uuid_xmlPATH"
<?xml version='1.0' encoding='utf-8' standalone='yes' ?>
<map>
    <string name="uuidKey">${UUID}</string>
</map>
XML
chown $OWNGRP "$uuid_xmlPATH"
chmod 660     "$uuid_xmlPATH"
echo "[+] Installation Completed."
echo

#```xml
#<?xml version='1.0' encoding='utf-8' standalone='yes' ?>
#<map>
#    <string name="uuidKey">android:400ef0e0-1003-4558-ae2e-6400000000</string>
#</map>
#```

echo "[+] Remove RKStorage..."
rm -f "$RKStoragePATH"
echo "[+] RKStorage remove Completed."
echo

echo "> Done!"
sleep_pause
exit 0
