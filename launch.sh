#!/bin/bash

# ==============================================
#    GAUTAM TOOLKIT - Master Launcher
#    Admin: Gautam Kumar
# ==============================================

R='\033[0;31m'
G='\033[0;32m'
Y='\033[1;33m'
B='\033[0;34m'
C='\033[0;36m'
W='\033[1;37m'
NC='\033[0m'

clear
echo -e "${G}╔══════════════════════════════════════════╗${NC}"
echo -e "${G}║${NC}  ${C}🛡️ GAUTAM TOOLKIT${NC}                       ${G}║${NC}"
echo -e "${G}║${NC}  ${Y}Admin: Gautam Kumar${NC}                    ${G}║${NC}"
echo -e "${G}╚══════════════════════════════════════════╝${NC}"
echo ""

echo -e "${B}┌───────────── AVAILABLE TOOLS ──────────┐${NC}"
echo -e "${B}│${NC} 1. ${G}GAUTAM RECON PRO v2.0${NC}               ${B}│${NC}"
echo -e "${B}│${NC} 2. ${C}GAUTAM NMAP PRO${NC}                      ${B}│${NC}"
echo -e "${B}│${NC} 3. ${Y}ZPHISHER${NC}                             ${B}│${NC}"
echo -e "${B}│${NC} 4. ${P}GAUTAM CAM${NC}                           ${B}│${NC}"
echo -e "${B}│${NC} 5. ${W}NGROK${NC}                                ${B}│${NC}"
echo -e "${B}│${NC} 6. ${R}EXIT${NC}                                 ${B}│${NC}"
echo -e "${B}└────────────────────────────────────────┘${NC}"
echo ""

read -p "$(echo -e ${G}"Select Tool [1-6]: "${NC})" choice

case $choice in
    1)
        echo -e "${Y}[*] Launching GAUTAM RECON PRO...${NC}"
        cd ~/Gautam-Toolkit
        ./gautam_recon.sh
        ;;
    2)
        echo -e "${Y}[*] Launching GAUTAM NMAP PRO...${NC}"
        cd ~/Gautam-Toolkit/gautam-nmap-pro
        chmod +x gautam_nmap.sh
        ./gautam_nmap.sh
        ;;
    3)
        echo -e "${Y}[*] Launching ZPHISHER...${NC}"
        cd ~/Gautam-Toolkit/zphisher
        bash zphisher.sh
        ;;
    4)
        echo -e "${Y}[*] Launching GAUTAM CAM...${NC}"
        cd ~/Gautam-Toolkit/gautam-cam
        bash start.sh
        ;;
    5)
        echo -e "${Y}[*] Launching NGROK...${NC}"
        cd ~/Gautam-Toolkit/ngrok
        ./ngrok
        ;;
    6)
        echo -e "${G}[✓] Thanks for using GAUTAM TOOLKIT!${NC}"
        exit 0
        ;;
    *)
        echo -e "${R}[!] Invalid option!${NC}"
        ;;
esac
