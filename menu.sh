#!/bin/bash 
# COLOR VALIDATION
clear
y='\033[1;33m' #yellow
l='\033[0;37m'
BGX="\033[42m"
CYAN="\033[96m"
z="\033[96m"
zx="\033[97;1m" # // putih
RED='\033[0;31m'
NC='\033[0m'
gray="\e[1;30m"
Blue="\033[0;34m"
green='\033[1;32m'
grenbo="\e[92;1m"
purple="\033[1;95m"
YELL='\033[0;33m'
cyan="\033[1;36m"
c="\033[5;33m"

# // Gettings Info
ISP=$(cat /etc/xray/isp)
CITY=$(cat /etc/xray/city)
IPVPS=$(curl -s ipv4.icanhazip.com)
domain=$(cat /etc/xray/domain)
ns=$(cat /etc/xray/dns)
RAM=$(free -m | awk 'NR==2 {print $2}')
USAGERAM=$(free -m | awk 'NR==2 {print $3}')
MEMOFREE=$(printf '%-1s' "$(free -m | awk 'NR==2{printf "%.2f%%", $3*100/$2 }')")
LOADCPU=$(printf '%-0.00001s' "$(top -bn1 | awk '/Cpu/ { cpu = "" 100 - $8 "%" }; END { print cpu }')")
MODEL=$(cat /etc/os-release | grep -w PRETTY_NAME | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/PRETTY_NAME//g')
CORE=$(printf '%-1s' "$(grep -c cpu[0-9] /proc/stat)")
DATEVPS=$(date +'%d/%m/%Y')
TIMEZONE=$(printf '%(%H:%M:%S)T')
SERONLINE=$(uptime -p | cut -d " " -f 2-10000)
clear
MYIP=$(curl -sS ipv4.icanhazip.com)
echo ""
#########################
# // USERNAME IZIN
rm -f /usr/bin/user
username=$(curl -sS https://raw.githubusercontent.com/xssh99/reg/main/ip | grep $MYIP | awk '{print $2}')
echo "$username" >/usr/bin/user

# // VALIDITY
rm -f /usr/bin/e
valid=$(curl -sS https://raw.githubusercontent.com/xssh99/reg/main/ip | grep $MYIP | awk '{print $3}')
echo "$valid" > /usr/bin/e

# // DETAIL ORDER IZIN IP
username=$(cat /usr/bin/user)
oid=$(cat /usr/bin/ver)
exp=$(cat /usr/bin/e)

clear
# // DAYS LEFT
d1=$(date -d "$valid" +%s)
d2=$(date -d "$today" +%s)
certifacate=$(((d1 - d2) / 86400))

# // VPS INFORMATION
DATE=$(date +'%Y-%m-%d')
datediff() {
    d1=$(date -d "$1" +%s)
    d2=$(date -d "$2" +%s)
    echo -e "$COLOR1 $NC Expiry In   : $(( (d1 - d2) / 86400 )) Days"
}
mai="datediff "$Exp" "$DATE""

# Status ExpiRED Active | Geo Project

# // AKTIVATED & EXPIRED
Info="${green}Activated${NC}"
Error="${RED}Expired ${NC}"
#//
today=`date -d "0 days" +"%Y-%m-%d"`
Exp1=$(curl -sS https://raw.githubusercontent.com/xssh99/reg/main/ip | grep $MYIP | awk '{print $3}')
if [[ $today < $Exp1 ]]; then
sts="${Info}"
else
sts="${Error}"
fi
echo -e "\e[32mloading...\e[0m"
clear

# // GETTINGS SYSTEM
uptime="$(uptime -p | cut -d " " -f 2-10)"
cpu_usage1="$(ps aux | awk 'BEGIN {sum=0} {sum+=$3}; END {print sum}')"
cpu_usage="$((${cpu_usage1/\.*} / ${coREDiilik:-1}))"
cpu_usage+=" %"
WKT=$(curl -s ipinfo.io/timezone )
DAY=$(date +%A)
DATE=$(date +%m/%d/%Y)
DATE2=$(date -R | cut -d " " -f -5)
IPVPS=$(curl -s ipinfo.io/ip )
cname=$( awk -F: '/model name/ {name=$2} END {print name}' /proc/cpuinfo )
cores=$( awk -F: '/model name/ {core++} END {print core}' /proc/cpuinfo )
freq=$( awk -F: ' /cpu MHz/ {freq=$2} END {print freq}' /proc/cpuinfo )
tram=$( free -m | awk 'NR==2 {print $2}' )
uram=$( free -m | awk 'NR==2 {print $3}' )
fram=$( free -m | awk 'NR==2 {print $4}' )
clear
ssh_service=$(/etc/init.d/ssh status | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
dropbear_service=$(/etc/init.d/dropbear status | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
haproxy_service=$(systemctl status haproxy | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
xray_service=$(systemctl status xray | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
nginx_service=$(systemctl status nginx | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
#Status | Geo Project
clear


# // RUNNING SSH
if [[ $ssh_service == "running" ]]; then 
   status_ssh="${green}ON ✅${NC}"
else
   status_ssh="${z}OF ❌${NC} "
fi

# // RUNNING WEBSOCKET
ssh_ws=$( systemctl status ws | grep Active | awk '{print $3}' | sed 's/(//g' | sed 's/)//g' )
if [[ $ssh_ws == "running" ]]; then
    status_ws_epro="${green}ON✅${NC}"
else
    status_ws_epro="${z}OF ❌${NC} "
fi

# RUNNING HAPROXY
if [[ $haproxy_service == "running" ]]; then 
   status_haproxy="${green}ON ✅${NC}"
else
   status_haproxy="${z}OF ❌${NC} "
fi

# RUNNING XRAY
if [[ $xray_service == "running" ]]; then 
   status_xray="${green}ON ✅${NC}"
else
   status_xray="${z}OF ❌${NC} "
fi

# RUNNING NGINX
if [[ $nginx_service == "running" ]]; then 
   status_nginx="${green}ON ✅${NC}"
else
   status_nginx="${z}OF ❌${NC} "
fi

# RUNNING DROPBEAR
if [[ $dropbear_service == "running" ]]; then 
   status_dropbear="${green}ON ✅${NC}"
else
   status_dropbear="${z}OF ❌${NC} "
fi
# // UPDATE / REVISI all menu
julak="https://raw.githubusercontent.com/xssh99/scx/main/rabah/"

# // INFO CREATE ACCOUNT
# \\ Vless account //
vlx=$(grep -c -E "^#& " "/etc/xray/config.json")
let vla=$vlx/2
# \\ Vmess account //
vmc=$(grep -c -E "^### " "/etc/xray/config.json")
let vma=$vmc/2
# \\ Trojan account //
ssh1="$(awk -F: '$3 >= 1000 && $1 != "nobody" {print $1}' /etc/passwd | wc -l)"
trx=$(grep -c -E "^#! " "/etc/xray/config.json")
let trb=$trx/2
# \\ shadowsocks account //
ssx=$(grep -c -E "^#!# " "/etc/xray/config.json")
let ssa=$ssx/2
# // ---- >>>
########### // JULAK // BANTUR
TZ="\033[1;35m___\033[1;34m___\033[1;32m___\033[1;36m___\033[1;37m___\033[1;34m"
vers="VERSION  JB-02 LITE"
# // ----->>>
r="\033[1;31m"  #REDTERANG
a=" ${z}ACCOUNT PREMIUM" 
BG_RED="\033[45;1m"
echo -e " "
echo -e " ${z}╭══════════════════════════════════════════════════════════╮${NC}"
echo -e " ${z}│$NC\033[5;33m                     Premium Autoscript                    $NC${z}│$NC"
echo -e " ${z}╰══════════════════════════════════════════════════════════╯${NC}"
echo -e " ${z}╭══════════════════════════════════════════════════════════╮${NC}"
echo -e " ${z}│$NC • $NC${z} System OS ${NC}     ${z}=$NC $MODEL${NC}"
echo -e " ${z}│$NC • $NC${z} Core Cpu ${NC}      ${z}=$NC $CORE${NC}"
echo -e " ${z}│$NC • $NC${z} Server RAM ${NC}    ${z}=$NC $uram/$RAM MB $NC"
echo -e " ${z}│$NC • $NC${z} Uptime Server ${NC} ${z}=$NC $SERONLINE${NC}"
echo -e " ${z}│$NC • $NC${z} Domain ${NC}        ${z}=$NC $domain${NC}"
echo -e " ${z}│$NC • $NC${z} Ns Domain ${NC}     ${z}=$NC $ns${NC}"
echo -e " ${z}│$NC • $NC${z} IP VPS ${NC}        ${z}=$NC $IPVPS${NC}"
echo -e " ${z}│$NC • $NC${z} ISP ${NC}           ${z}=$NC $ISP${NC}"
echo -e " ${z}│$NC • $NC${z} City ${NC}          ${z}=$NC $CITY${NC}"
echo -e " ${z}│$NC • $NC${z} Cpu Usage ${NC}     ${z}=$NC $cpu_usage${NC}"
echo -e " ${z}╰══════════════════════════════════════════════════════════╯${NC}"
echo -e "    ${zx} NGINX$NC : $status_nginx ${zx} WS-EPRO$NC : $status_ws_epro ${zx} DROPBEAR$NC : $status_dropbear ${zx} HAPROXY$NC : $status_haproxy   $NC${zx}$NC" 
echo -e ""
echo -e "                        ${BG_RED}ACCOUNT INFO${NC}"
echo -e "        SSH & OPENVPN : $ssh1 TROJAN : $trb  SHADOWSOCKS-R : $ssa"
echo -e "                        VLESS : $vla VMESS : $vma"
echo -e " ${z}╭══════════════════════════════════════════════════════════╮${NC}"
echo -e " ${z}│$NC   [${green}01${NC}] ${c}SSH${NC}                     [${green}07${NC}] ${c}CHECK RUNNING${NC} ${z}       │$NC" 
echo -e " ${z}│$NC   [${green}02${NC}] ${c}VMESS${NC}                   [${green}08${NC}] ${c}CHECK BANDWITH${NC} ${z}      │$NC"    
echo -e " ${z}│$NC   [${green}03${NC}] ${c}VLESS${NC}                   [${green}09${NC}] ${c}SPEEDTEST${NC} ${z}           │$NC"  
echo -e " ${z}│$NC   [${green}04${NC}] ${c}TROJAN${NC}                  [${green}10${NC}] ${c}BACKUP/RESTORE${NC} ${z}      │$NC"
echo -e " ${z}│$NC   [${green}05${NC}] ${c}SHADOW${NC}                  [${green}11${NC}] ${c}ADD BOT${NC} ${z}             │$NC"
echo -e " ${z}│$NC   [${green}06${NC}] ${c}SETTING${NC}                 [${green}12${NC}] ${c}UPDATE AUTOSCRIPT${NC} ${z}   │$NC"
echo -e " ${z}╰══════════════════════════════════════════════════════════╯${NC}"
echo -e " ${z}╭══════════════════════════════════════════════════════════╮${NC}"
echo -e " ${z}│$NC${z} AUTHOR$NC          ${z}=$NC Julak Bantur"
echo -e " ${z}│$NC${z} CLIENT$NC          ${z}=$NC $username [$sts]"
echo -e " ${z}│$NC${z} EXPIRED SCRIPT$NC  ${z}=$NC $exp / $certifacate Days$NC "
echo -e " ${z}╰══════════════════════════════════════════════════════════╯${NC}"
echo -e "                        ${vers}"
echo -e "                        ${TZ} ${NC}"
echo
read -p " Select Options 1/12 : " wZtXtQ
echo -e ""
case $wZtXtQ in
1)
clear
m-sshws
;;
2)
clear
m-vmess
;;
3)
clear
m-vless
;;
4)
clear
m-trojan
;;
5)
clear
m-ssws
;;
6)
clear
utility
;;
7)
clear
run
;;
8)
clear
bw
;;
9)
clear
speedtest
;;
10)
clear
menu-backup
;;
11)
clear
add-bot-panel
;;
12)
clear
rm -rf update.sh && wget ${julak}update.sh && chmod +x update.sh && ./update.sh
;;
*)
clear
menu
;;
esac
