#!/bin/bash
dateFromServer=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
biji=`date +"%Y-%m-%d" -d "$dateFromServer"`
###########- COLOR CODE -##############
colornow=$(cat /etc/mXvx/theme/color.conf)
NC="\e[0m"
RED="\033[0;31m" 
COLOR1="$(cat /etc/mXvx/theme/$colornow | grep -w "TEXT" | cut -d: -f2|sed 's/ //g')"
COLBG1="$(cat /etc/mXvx/theme/$colornow | grep -w "BG" | cut -d: -f2|sed 's/ //g')"                    
###########- END COLOR CODE -##########

export RED='\033[0;31m'
export GREEN='\033[0;32m'

# // SSH Websocket Proxy
ssh_ws=$( systemctl status ws-stunnel | grep Active | awk '{print $3}' | sed 's/(//g' | sed 's/)//g' )
if [[ $ssh_ws == "running" ]]; then
    status_ws="${GREEN}ON${NC}"
else
    status_ws="${RED}OFF${NC}"
fi

# // nginx
nginx=$( systemctl status nginx | grep Active | awk '{print $3}' | sed 's/(//g' | sed 's/)//g' )
if [[ $nginx == "running" ]]; then
    status_nginx="${GREEN}ON${NC}"
else
    status_nginx="${RED}OFF${NC}"
fi

# // SSH Websocket Proxy
xray=$( systemctl status xray | grep Active | awk '{print $3}' | sed 's/(//g' | sed 's/)//g' )
if [[ $xray == "running" ]]; then
    status_xray="${GREEN}ON${NC}"
else
    status_xray="${RED}OFF${NC}"
fi

function add-host(){
clear
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│${NC} ${COLBG1}               • ADD VPS HOST •                ${NC} $COLOR1│$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
read -rp "  New Host Name : " -e host
echo ""
if [ -z $host ]; then
echo -e "  [INFO] Type Your Domain/sub domain"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo ""
read -n 1 -s -r -p "  Press any key to back on menu"
menu
else
echo "IP=$host" > /var/lib/mXvx/ipvps.conf
echo ""
echo "  [INFO] Dont forget to renew cert"
echo ""
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo ""
read -n 1 -s -r -p "  Press any key to Renew Cret"
crtxray
fi
}
function updatews(){
clear

echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│${NC} ${COLBG1}            • UPDATE SCRIPT VPS •              ${NC} $COLOR1│$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│${NC}  $COLOR1[INFO]${NC} Check for Script updates"
sleep 2
wget -q -O /root/update.sh "https://raw.githubusercontent.com/MXVXID/vx/main/v2/menu/update.sh" && chmod +x /root/update.sh
sleep 2
./update.sh
sleep 2
rm /root/update.sh
rm /opt/.ver
version_up=$( curl -sS https://raw.githubusercontent.com/MXVXID/vx/main/v2/version_up)
echo "$version_up" > /opt/.ver
echo -e "$COLOR1│${NC}  $COLOR1[INFO]${NC} Successfully Up To Date!"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌────────────────────── BY ───────────────────────┐${NC}"
echo -e "$COLOR1│${NC}              • MXVX •                $COLOR1│$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}" 
echo ""
read -n 1 -s -r -p "  Press any key to back on menu"
menu
}
clear
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│${NC} ${COLBG1}               • MENU PANEL VPS •              ${NC} $COLOR1│$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e "                  Some Information             "
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
uphours=`uptime -p | awk '{print $2,$3}' | cut -d , -f1`
upminutes=`uptime -p | awk '{print $4,$5}' | cut -d , -f1`
uptimecek=`uptime -p | awk '{print $6,$7}' | cut -d , -f1`
cekup=`uptime -p | grep -ow "day"`
spd="menu-speedtest"
log="logcleaner"
WKT=$(curl -s ipinfo.io/timezone )
IPVPS=$(curl -s ipinfo.io/ip )
ISP=$(curl -s ipinfo.io/org | cut -d " " -f 2-10 )
CITY=$(curl -s ipinfo.io/city )
DAY=$(date +%A)
tram=$( free -m | awk 'NR==2 {print $2}' )
uram=$( free -m | awk 'NR==2 {print $3}' )
fram=$( free -m | awk 'NR==2 {print $4}' )
serverV=$( curl -sS https://raw.githubusercontent.com//MXVXID/vx/main/v2/version_up)
Isadmin=ON
Name=MXVX
if [ "$Isadmin" = "ON" ]; then
uis="${GREEN}Premium User$NC"
else
uis="${RED}Free Version$NC"
fi

if [ "$cekup" = "day" ]; then
echo -e "$COLOR1│$NC System Uptime  : $uphours $upminutes $uptimecek"
else
echo -e "$COLOR1│$NC System Uptime  : $uphours $upminutes"
fi
echo -e "$COLOR1│$NC Memory Usage   : $uram / $tram"
echo -e "$COLOR1│$NC ISP & City     : $ISP & $CITY"
echo -e "$COLOR1│$NC Current Domain : $(cat /etc/xray/domain)"
echo -e "$COLOR1│$NC IP-VPS         : ${COLOR1}$IPVPS${NC}"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e "                     List Menu                  "
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "  ${COLOR1}[01]${NC} • [${YELLOW}Menu${NC}] SSHWS     ${COLOR1}[07]${NC} • [${YELLOW}Menu${NC}] THEME     $COLOR1│$NC"   
echo -e "  ${COLOR1}[02]${NC} • [${YELLOW}Menu${NC}] VMESS     ${COLOR1}[08]${NC} • [${YELLOW}Menu${NC}] BACKUP    $COLOR1│$NC"  
echo -e "  ${COLOR1}[03]${NC} • [${YELLOW}Menu${NC}] VLESS     ${COLOR1}[09]${NC} • [${YELLOW}Menu${NC}] SETTINGS  $COLOR1│$NC"  
echo -e "  ${COLOR1}[04]${NC} • [${YELLOW}Menu${NC}] TROJAN    ${COLOR1}[10]${NC} • INFORMATION      $COLOR1│$NC"  
echo -e "  ${COLOR1}[05]${NC} • [${YELLOW}Menu${NC}] SS WS     ${COLOR1}[11]${NC} • ADD HOST/DOMAIN  $COLOR1│$NC"
echo -e "  ${COLOR1}[06]${NC} • [${YELLOW}Menu${NC}] SET DNS   ${COLOR1}[12]${NC} • RENEW CERT       $COLOR1│$NC"
if [ "$Isadmin" = "ON" ]; then
echo -e "                                                  $COLOR1│$NC"
echo -e "  ${COLOR1}[13]${NC} • [${YELLOW}Menu${NC}] Speedtest    ${COLOR1}[14]${NC} • [${YELLOW}Log{NC}] Cleaner   $COLOR1│$NC"

fi
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌────────────────────── BY ───────────────────────┐${NC}"
echo -e "$COLOR1│${NC}              • MXVX •            $COLOR1│$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}" 
echo -e ""
echo -ne " Select menu : "; read opt
case $opt in
01 | 1) clear ; menu-ssh ;;
02 | 2) clear ; menu-vmess ;;
03 | 3) clear ; menu-vless ;;
04 | 4) clear ; menu-trojan ;;
05 | 5) clear ; menu-ss ;;
06 | 6) clear ; menu-dns ;;
06 | 7) clear ; menu-theme ;;
07 | 8) clear ; menu-backup ;;
09 | 9) clear ; menu-set ;;
10) clear ; info ;;
11) clear ; add-host ;;
12) clear ; crtxray ;;
13) clear ; $spd ;;
14) clear ; $log ;;
00 | 0) clear ; menu ;;
*) clear ; menu ;;
esac
