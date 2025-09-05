#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# --- Konfigurasi lalai ---
DEFAULT_EMAIL="admin@localhost"
default_email="${default_email:-$DEFAULT_EMAIL}"

# dapatkan IP awam (fallback jika wget tak berjaya)
MYIP="$(wget -qO- icanhazip.com 2>/dev/null || curl -s ifconfig.me 2>/dev/null || echo "0.0.0.0")"

# Fungsi ringkas untuk output dengan warna (mengelakkan echo -e)
cecho() {
  # usage: cecho "<format-string>" "arg1" ...
  # format-string boleh ada \e escape sequences
  printf '%b\n' "$1"
}

cecho "\e[1;32m════════════════════════════════════════════════════════════\e[0m"
cecho ""
cecho "   \e[1;32mPlease enter your email Domain/Cloudflare.\e[0m"
cecho "   \e[1;31m(Press ENTER for default email)\e[0m"
read -rp "   Email : " email

# gunakan default jika tiada input
if [[ -z "${email:-}" ]]; then
  sts="$default_email"
else
  sts="$email"
fi

# pastikan direktori wujud dan simpan email
mkdir -p /usr/local/etc/xray/
printf '%s\n' "$sts" > /usr/local/etc/xray/email

cecho ""
mkdir -p /var/lib/premium-script
# tulis IP sekali (gunakan > untuk elak append berganda)
printf 'IP=%s\n' "$MYIP" > /var/lib/premium-script/ipvps.conf

cecho "\e[1;32mPlease enter your subdomain/domain. If not, please press enter.\e[0m"
read -rp "Recommended (Subdomain): " host
# simpan domain (kosongkan fail jika tiada input)
if [[ -z "${host:-}" ]]; then
  : > /root/domain
else
  printf '%s\n' "$host" > /root/domain
fi

cecho ""
mkdir -p /usr/local/etc/xray/
cecho ""
cecho "\e[1;32mPlease enter the name of provider.\e[0m"
read -rp "Name : " nm
printf '%s\n' "${nm:-}" > /root/provided

clear
cecho "\e[0;32mREADY FOR INSTALLATION SCRIPT...\e[0m"
sleep 2

# Helper untuk muat turun & jalankan dengan nama sesi screen yang selamat
fetch_and_run() {
  local url="$1"
  local fname
  fname="$(basename "$url")"
  if wget -q --tries=3 --timeout=20 -O "$fname" "$url"; then
    chmod +x "$fname" || true
    # gunakan nama sesi tanpa titik/ruang (gantikan . dengan - jika ada)
    local sess="${fname//./-}"
    # jalankan dalam screen jika ada screen, jika tidak jalankan di background
    if command -v screen >/dev/null 2>&1; then
      screen -dmS "$sess" ./"$fname"
    else
      ./"$fname" &
    fi
  else
    cecho "\e[1;31mFailed to download $url\e[0m"
  fi
}

#install SSH & OVPN
wget https://raw.githubusercontent.com/melody97rain/SyntaxError/main/install/ssh-vpn.sh && chmod +x ssh-vpn.sh && screen -S ssh-vpn ./ssh-vpn.sh
echo -e "\e[0;32mDONE INSTALLING SSH & OVPN\e[0m"
clear
#install Xray
echo -e "\e[0;32mINSTALLING XRAY CORE...\e[0m"
sleep 1
wget https://raw.githubusercontent.com/melody97rain/SyntaxError/main/install/ins-xray.sh && chmod +x ins-xray.sh && screen -S ins-xray ./ins-xray.sh
echo -e "\e[0;32mDONE INSTALLING XRAY CORE\e[0m"
clear
#install Trojan GO
echo -e "\e[0;32mINSTALLING TROJAN GO...\e[0m"
sleep 1
wget https://raw.githubusercontent.com/melody97rain/SyntaxError/main/install/trojan-go.sh && chmod +x trojan-go.sh && screen -S trojan-go ./trojan-go.sh
echo -e "\e[0;32mDONE INSTALLING TROJAN GO\e[0m"
clear
#install ssr
echo -e "\e[0;32mINSTALLING SS & SSR...\e[0m"
sleep 1
wget https://raw.githubusercontent.com/melody97rain/SyntaxError/main/install/ssr.sh && chmod +x ssr.sh && screen -S ssr ./ssr.sh
wget https://raw.githubusercontent.com/melody97rain/SyntaxError/main/install/sodosok.sh && chmod +x sodosok.sh && screen -S ss ./sodosok.sh
echo -e "\e[0;32mDONE INSTALLING SS & SSR\e[0m"
clear
#install ohp-server
echo -e "\e[0;32mINSTALLING OHP...\e[0m"
sleep 1
wget https://raw.githubusercontent.com/melody97rain/SyntaxError/main/install/ohp.sh && chmod +x ohp.sh && ./ohp.sh
wget https://raw.githubusercontent.com/melody97rain/SyntaxError/main/install/ohp-dropbear.sh && chmod +x ohp-dropbear.sh && ./ohp-dropbear.sh
wget https://raw.githubusercontent.com/melody97rain/SyntaxError/main/install/ohp-ssh.sh && chmod +x ohp-ssh.sh && ./ohp-ssh.sh
echo -e "\e[0;32mDONE INSTALLING OHP PORT\e[0m"
clear
#install websocket
echo -e "\e[0;32mINSTALLING WEBSOCKET...\e[0m"
wget https://raw.githubusercontent.com/melody97rain/SyntaxError/main/websocket-python/websocket.sh && chmod +x websocket.sh && screen -S websocket.sh ./websocket.sh
echo -e "\e[0;32mDONE INSTALLING WEBSOCKET PORT\e[0m"
clear
#install SET-BR
echo -e "\e[0;32mINSTALLING SET-BR...\e[0m"
sleep 1
wget https://raw.githubusercontent.com/melody97rain/SyntaxError/main/install/set-br.sh && chmod +x set-br.sh && ./set-br.sh
echo -e "\e[0;32mDONE INSTALLING SET-BR...\e[0m"
clear
rm -f /root/ssh-vpn.sh
rm -f /root/ss.sh
rm -f /root/ssr.sh
rm -f /root/ins-xray.sh
rm -f /root/trojan-go.sh
rm -f /root/set-br.sh
rm -f /root/ohp.sh
rm -f /root/ohp-dropbear.sh
rm -f /root/ohp-ssh.sh
rm -f /root/websocket.sh
# Colour Default
echo "1;36m" > /etc/banner
echo "30m" > /etc/box
echo "1;31m" > /etc/line
echo "1;32m" > /etc/text
echo "1;33m" > /etc/below
echo "47m" > /etc/back
echo "1;35m" > /etc/number
echo 3d > /usr/bin/test
clear
echo " "
echo "Installation has been completed!!"
echo " "
echo "=========================[Script By NiLphreakz]========================" | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "   >>> Service & Port"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "    [INFORMASI SSH & OpenVPN]" | tee -a log-install.txt
echo "    -------------------------" | tee -a log-install.txt
echo "   - OpenSSH                 : 22"  | tee -a log-install.txt
echo "   - OpenVPN                 : TCP 1194, UDP 2200"  | tee -a log-install.txt
echo "   - OpenVPN SSL             : 110"  | tee -a log-install.txt
echo "   - Stunnel4                : 222, 777"  | tee -a log-install.txt
echo "   - Dropbear                : 442, 109"  | tee -a log-install.txt
echo "   - OHP Dropbear            : 8585"  | tee -a log-install.txt
echo "   - OHP SSH                 : 8686"  | tee -a log-install.txt
echo "   - OHP OpenVPN             : 8787"  | tee -a log-install.txt
echo "   - Websocket SSH(HTTP)     : 2081"  | tee -a log-install.txt
echo "   - Websocket SSL(HTTPS)    : 222"  | tee -a log-install.txt
echo "   - Websocket OpenVPN       : 2084"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "    [INFORMASI Sqd, Bdvp, Ngnx]" | tee -a log-install.txt
echo "    ---------------------------" | tee -a log-install.txt
echo "   - Squid Proxy             : 3128, 8000 (limit to IP Server)"  | tee -a log-install.txt
echo "   - Badvpn                  : 7100, 7200, 7300"  | tee -a log-install.txt
echo "   - Nginx                   : 81"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "    [INFORMASI NOOBZVPN]"  | tee -a log-install.txt
echo "    --------------" | tee -a log-install.txt
echo "   - Noobzvpn Tls            : 2096"  | tee -a log-install.txt
echo "   - Noobzvpn Non Tls        : 2086"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "    [INFORMASI Shadowsocks-R & Shadowsocks]"  | tee -a log-install.txt
echo "    ---------------------------------------" | tee -a log-install.txt
echo "   - Shadowsocks-R           : 1443-1543"  | tee -a log-install.txt
echo "   - SS-OBFS TLS             : 2443-2543"  | tee -a log-install.txt
echo "   - SS-OBFS HTTP            : 3443-3543"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "    [INFORMASI XRAY]"  | tee -a log-install.txt
echo "    ----------------" | tee -a log-install.txt
echo "   - Xray Vmess Ws Tls       : 443"  | tee -a log-install.txt
echo "   - Xray Vless Ws Tls       : 443"  | tee -a log-install.txt
echo "   - Xray Vless Tcp Xtls     : 443"  | tee -a log-install.txt
echo "   - Xray Vmess Ws None Tls  : 8443"  | tee -a log-install.txt
echo "   - Xray Vless Ws None Tls  : 8442"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "    [INFORMASI TROJAN]"  | tee -a log-install.txt
echo "    ------------------" | tee -a log-install.txt
echo "   - Xray Trojan Tcp Tls     : 443"  | tee -a log-install.txt
echo "   - Trojan Go               : 2083"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "    [INFORMASI CLASH FOR ANDROID (YAML)]"  | tee -a log-install.txt
echo "    -----------------------------------" | tee -a log-install.txt
echo "   - Xray Vmess Ws Yaml      : Yes"  | tee -a log-install.txt
echo "   - Shadowsocks Yaml        : Yes"  | tee -a log-install.txt
echo "   - ShadowsocksR Yaml       : Yes"  | tee -a log-install.txt
echo "   --------------------------------------------------------------" | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "   >>> Server Information & Other Features"  | tee -a log-install.txt
echo "   - Timezone                : Asia/Kuala_Lumpur (GMT +8)"  | tee -a log-install.txt
echo "   - Fail2Ban                : [ON]"  | tee -a log-install.txt
echo "   - Dflate                  : [ON]"  | tee -a log-install.txt
echo "   - IPtables                : [ON]"  | tee -a log-install.txt
echo "   - Auto-Reboot             : [ON]"  | tee -a log-install.txt
echo "   - IPv6                    : [OFF]"  | tee -a log-install.txt
echo "   - Autoreboot On 05.00 GMT +8" | tee -a log-install.txt
echo "   - Autobackup Data" | tee -a log-install.txt
echo "   - Restore Data" | tee -a log-install.txt
echo "   - Auto Delete Expired Account" | tee -a log-install.txt
echo "   - Full Orders For Various Services" | tee -a log-install.txt
echo "   - White Label" | tee -a log-install.txt
echo "   - Installation Log --> /root/log-install.txt"  | tee -a log-install.txt
echo "=========================[Script By NiLphreakz]========================" | tee -a log-install.txt
clear
echo ""
echo ""
echo -e "    \e[1;32m.------------------------------------------.\e[0m"
echo -e "    \e[1;32m|     SUCCESFULLY INSTALLED THE SCRIPT     |\e[0m"
echo -e "    \e[1;32m'------------------------------------------'\e[0m"
echo ""
echo -e "   \e[1;32mSERVER WILL AUTOMATICALLY REBOOT IN 10 SECONDS\e[0m"
rm -r setup2.sh
sleep 10
reboot
