#!/bin/bash
# //====================================================
# //	System Request:Debian 9+/Ubuntu 18.04+/20+
# //	Author:	Julak Bantur
# //	Dscription: Xray Menu Management
# //	email: putrameratus2@gmail.com
# //  telegram: https://t.me/Cibut2d
# //====================================================
# // font color configuration | JULAK BANTUR AUTOSCRIPT
###########- COLOR CODE -##############
colornow=$(cat /etc/julak/theme/color.conf)
NC="\e[0m"
RED="\033[0;31m"
grenbo="\e[92;1m"
GRENN="\e[92;1m"
WC='\033[0m'
COLOR1="$(cat /etc/julak/theme/$colornow | grep -w "TEXT" | cut -d: -f2|sed 's/ //g')"
COLBG1="$(cat /etc/julak/theme/$colornow | grep -w "BG" | cut -d: -f2|sed 's/ //g')"
WH='\033[1;37m'
###########- END COLOR CODE -##########
total_ram=$(grep "MemTotal: " /proc/meminfo | awk '{ print $2}')
totalram=$(($total_ram / 1024))
MYIP=$(curl -sS ipv4.icanhazip.com)
LAST_DOMAIN="$(cat /etc/xray/domain)"
NS="$(cat /etc/xray/dns)"
red() { echo -e "\\033[32;1m${*}\\033[0m"; }

function get_acme_domain() {

    echo -e "${GREEN}--->${NC}     Start "
    systemctl stop nginx
    systemctl stop haproxy
    echo -e "${GREEN}--->${NC}     Starting renew cert "
    echo -e "${GREEN}--->$NC     Getting acme for cert"
    /root/.acme.sh/acme.sh --upgrade --auto-upgrade
    /root/.acme.sh/acme.sh --set-default-ca --server letsencrypt
    /root/.acme.sh/acme.sh --issue -d $domain --standalone -k ec-256
    /root/.acme.sh/acme.sh --installcert -d $domain --fullchainpath /etc/xray/xray.crt --keypath /etc/xray/xray.key --ecc
    rm -rf /etc/xray/domain
    echo $domain >/etc/xray/domain
    echo -e "${GREEN}--->${NC}     Renew cert done "
    sed -i "s/${LAST_DOMAIN}/${domain}/g" /etc/nginx/conf.d/xray.conf
    chown www-data.www-data /etc/xray/xray.key
    chown www-data.www-data /etc/xray/xray.crt
    systemctl daemon-reload
    systemctl restart nginx
    systemctl restart server
    systemctl restart xray
    sleep 2
    echo ""

}
ns_domain_cloudflare() {
    DOMAINNS="sshvpn.xyz"
    DAOMIN="$domain"
    SUB=$(tr </dev/urandom -dc a-z0-9 | head -c8)
    SUB_DOMAIN=${SUB}."sshvpn.xyz"
    NS_DOMAIN=ns.${SUB_DOMAIN}
    CF_ID=putrameratus2@gmail.com
CF_KEY=8d5c58d345dbb3b34b8420b9b15df5f6b8292
    set -euo pipefail
    IP=$(wget -qO- ipinfo.io/ip)
    ZONE=$(
        curl -sLX GET "https://api.cloudflare.com/client/v4/zones?name=${DOMAINNS}&status=active" \
            -H "X-Auth-Email: ${CF_ID}" \
            -H "X-Auth-Key: ${CF_KEY}" \
            -H "Content-Type: application/json" | jq -r .result[0].id
    )

    RECORD=$(
        curl -sLX GET "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records?name=${NS_DOMAIN}" \
            -H "X-Auth-Email: ${CF_ID}" \
            -H "X-Auth-Key: ${CF_KEY}" \
            -H "Content-Type: application/json" | jq -r .result[0].id
    )

    if [[ "${#RECORD}" -le 10 ]]; then
        RECORD=$(
            curl -sLX POST "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records" \
                -H "X-Auth-Email: ${CF_ID}" \
                -H "X-Auth-Key: ${CF_KEY}" \
                -H "Content-Type: application/json" \
                --data '{"type":"NS","name":"'${NS_DOMAIN}'","content":"'${DAOMIN}'","proxied":false}' | jq -r .result.id
        )
    fi

    RESULT=$(
        curl -sLX PUT "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records/${RECORD}" \
            -H "X-Auth-Email: ${CF_ID}" \
            -H "X-Auth-Key: ${CF_KEY}" \
            -H "Content-Type: application/json" \
            --data '{"type":"NS","name":"'${NS_DOMAIN}'","content":"'${DAOMIN}'","proxied":false}'
    )
    echo $NS_DOMAIN >/etc/xray/dns
    sed -i "s/$NS/$NS_DOMAIN/g" /etc/systemd/system/client.service
    sed -i "s/$NS/$NS_DOMAIN/g" /etc/systemd/system/server.service
}
gendns() {
    sec=3
    spinner=(⣻ ⢿ ⡿ ⣟ ⣯ ⣷)
    while [ $sec -gt 0 ]; do
        echo -ne "\e[33m ${spinner[sec]} Generator PubKey $sec seconds...\r"
        sleep 1
        sec=$(($sec - 1))
    done
    clear
    echo -e "\e[1;32mSUKSES MEMPERBAHARUI PUBKEY\e[0m\n"
    cd /etc/slowdns
    ./dnstt-server -gen-key -privkey-file server.key -pubkey-file server.pub 
    systemctl daemon-reload
    systemctl restart server
    systemctl restart client
    cd

}
clear
echo -e "$COLOR1   ┌──────────────────────────────────────────┐$NC"
echo -e "$COLOR1   │$NC            ${COLBG1}CHANGE DOMAIN VPS${NC}             ${COLOR1}|${NC}"
echo -e "$COLOR1   └──────────────────────────────────────────┘$NC"
echo -e "     ${RED}Autoscript xray vpn lite (multi port)${NC}"
echo -e "${WH}Make sure the internet is smooth when installing the script${NC}"
echo -e "───────────────────────────────────────────────────────"
echo -e ""
echo -e "       ${WH}Hostname${NC}    :  $LAST_DOMAIN"
echo -e "       ${WH}Public IP${NC}   :  $MYIP"
echo -e "       ${WH}Total RAM${NC}   :  $totalram MB"
echo -e ""
echo -e "───────────────────────────────────────────────────────"
echo -e "${WH}1.${NC} ${COLOR1}CHANGE DOMAIN + NS RANDOM (recommended}${NC}"
echo -e "${WH}2.${NC} ${COLOR1}CHANGE NS SLOWDNS + XRAYDNS${NC}"
echo -e "${WH}3.${NC} ${COLOR1}CHANGE PUBKEY SLOWDNS + XRAYDNS${NC}"
echo -e "     CTRL + C to go back "
domaion_random() {
    read -rp "Input your Domain/Host : " -e domain
    if [ -z $domain ]; then
        echo -e "
        Tidak ada domain yang di input"
    else
    echo "$domain" > /etc/xray/domain
    echo $domain > /root/domain
    echo "IP=$domain" > /var/lib/julak/ipvps.conf
    fi
}

ns_only() {
    read -rp "Input ur NS Domain : " -e NS_DOMAIN
    echo $NS_DOMAIN >/etc/xray/dns
    sed -i "s/$NS/$NS_DOMAIN/g" /etc/systemd/system/client.service
    sed -i "s/$NS/$NS_DOMAIN/g" /etc/systemd/system/server.service
    systemctl daemon-reload
    systemctl restart server
    systemctl restart client
    echo "Change NS DOMAIN (SLOWDNS + XRAYDNS) Successfully"
}
echo -e ""
read -p "Select From Options : " menu_num

case $menu_num in
1)
    domaion_random
    get_acme_domain
    ns_domain_cloudflare
    ;;
2)
    ns_only
    ;;
3)
    gendns
    ;;
*)
    echo -e "${RED}You wrong command !${FONT}"
    ;;
esac
