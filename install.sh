#!/bin/bash

echo "[*] Starting installation of wmarker"

echo "[*] Checking dependencies... "
for name in convert composite fzf; do
    [[ $(command -v $name 2>/dev/null) ]] || {
        echo -en "\n\t$name needs to be installed. See documentation'\n\n"
        exit 1
    }
done

echo "[*] Copying the binary to /usr/bin/"
sudo cp wmarker.sh /usr/bin/wmarker
echo "[*] Setting permissions"
sudo chmod go+x /usr/bin/wmarker
