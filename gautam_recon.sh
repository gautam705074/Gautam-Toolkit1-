#!/bin/bash

# ==============================================
#    GAUTAM RECON PRO v2.0 - ULTIMATE EDITION
#    Admin: Gautam Kumar
#    Version: 2.0
#    Features: HTML Report, Telegram, Email, Location, JSON, Auto-Update, Schedule, Progress Bar, Animation
# ==============================================

# =================== COLORS ===================
R='\033[0;31m'
G='\033[0;32m'
Y='\033[1;33m'
B='\033[0;34m'
P='\033[0;35m'
C='\033[0;36m'
W='\033[1;37m'
NC='\033[0m'
BL='\033[1m'

# =================== VARIABLES ===================
VERSION="2.0"
CURRENT_TARGET=""
LOG_FILE="logs/recon.log"
BOT_TOKEN=""
CHAT_ID=""

# =================== CREATE DIRECTORIES ===================
mkdir -p results logs 2>/dev/null

# =================== ASCII ANIMATION ===================
ascii_animation() {
    clear
    frames=(
        "██████╗  █████╗ ██╗   ██╗████████╗ █████╗ ███╗   ███╗"
        "██╔══██╗██╔══██╗██║   ██║╚══██╔══╝██╔══██╗████╗ ████║"
        "██████╔╝███████║██║   ██║   ██║   ███████║██╔████╔██║"
        "██╔═══╝ ██╔══██║██║   ██║   ██║   ██╔══██║██║╚██╔╝██║"
        "██║     ██║  ██║╚██████╔╝   ██║   ██║  ██║██║ ╚═╝ ██║"
        "╚═╝     ╚═╝  ╚═╝ ╚═════╝    ╚═╝   ╚═╝  ╚═╝╚═╝     ╚═╝"
    )
    
    for frame in "${frames[@]}"; do
        clear
        echo -e "${G}$frame${NC}"
        echo -e "${Y}   GAUTAM RECON PRO v2.0${NC}"
        echo -e "${C}   Loading...${NC}"
        sleep 0.15
    done
}

# =================== PROGRESS BAR ===================
progress_bar() {
    local duration=${1:-10}
    local steps=50
    echo ""
    for ((i=0; i<=steps; i++)); do
        percent=$((i * 100 / steps))
        filled=$((i * 50 / steps))
        bar=$(printf "%${filled}s" | tr ' ' '█')
        printf "\r[${G}%-50s${NC}] ${Y}%3d%%${NC}" "$bar" "$percent"
        sleep $(echo "$duration / $steps" | bc -l 2>/dev/null || echo 0.05)
    done
    echo ""
}

# =================== BANNER ===================
show_banner() {
    clear
    echo -e "${G}╔══════════════════════════════════════════════════╗${NC}"
    echo -e "${G}║${NC}  ${C}🛡️ GAUTAM RECON PRO v2.0${NC}                       ${G}║${NC}"
    echo -e "${G}║${NC}  ${Y}👤 Admin: Gautam Kumar${NC}                        ${G}║${NC}"
    echo -e "${G}║${NC}  ${W}🎯 Target: ${G}$CURRENT_TARGET${NC}                     ${G}║${NC}"
    echo -e "${G}╚══════════════════════════════════════════════════╝${NC}"
    echo ""
}

# =================== SET TARGET ===================
set_target() {
    echo -e "${Y}═══════════════════════════════════════════${NC}"
    echo -e "${B}🎯 SET TARGET${NC}"
    echo -e "${Y}═══════════════════════════════════════════${NC}"
    echo -e "${W}Current Target: ${G}$CURRENT_TARGET${NC}"
    echo ""
    read -p "$(echo -e ${G}"Enter new target (domain/IP): "${NC})" target
    
    if [ -z "$target" ]; then
        echo -e "${R}[!] Target cannot be empty!${NC}"
        sleep 1
        return
    fi
    
    CURRENT_TARGET="$target"
    echo -e "${G}[✓] Target changed to: $CURRENT_TARGET${NC}"
    
    IP=$(dig +short $CURRENT_TARGET 2>/dev/null | head -1)
    if [ ! -z "$IP" ]; then
        echo -e "${G}[✓] IP: $IP${NC}"
    fi
    
    if ping -c 1 -W 2 $CURRENT_TARGET &> /dev/null; then
        echo -e "${G}[✓] Host is ALIVE!${NC}"
    else
        echo -e "${R}[✗] Host is DOWN!${NC}"
    fi
    sleep 2
}

# =================== QUICK SCAN ===================
quick_scan() {
    target=$1
    echo -e "${C}[+] QUICK SCAN: $target${NC}"
    echo -e "${Y}[*] Scanning top 100 ports...${NC}"
    
    progress_bar 3
    
    {
        echo "========== QUICK SCAN =========="
        echo "Target: $target"
        echo "Date: $(date)"
        echo "================================="
        echo ""
        nmap -T4 -F $target 2>/dev/null
        echo ""
        echo "Open Ports:"
        nmap -T4 -F $target 2>/dev/null | grep -E "^[0-9]" | grep open
    } > results/quick_$target.txt
    
    echo -e "${G}[✓] Quick scan complete!${NC}"
    echo -e "${G}[✓] Saved: results/quick_$target.txt${NC}"
}

# =================== FULL RECON ===================
full_recon() {
    target=$1
    echo -e "${C}[+] FULL RECON: $target${NC}"
    echo -e "${Y}[*] Running all modules...${NC}"
    
    progress_bar 8
    
    mkdir -p results/$target
    
    # WHOIS
    echo -e "${Y}[*] WHOIS Lookup...${NC}"
    whois $target 2>/dev/null > results/$target/whois.txt
    
    # DNS
    echo -e "${Y}[*] DNS Enumeration...${NC}"
    {
        echo "========== DNS RECORDS =========="
        echo "A: $(dig $target A +short 2>/dev/null)"
        echo "MX: $(dig $target MX +short 2>/dev/null)"
        echo "NS: $(dig $target NS +short 2>/dev/null)"
        echo "TXT: $(dig $target TXT +short 2>/dev/null)"
    } > results/$target/dns.txt
    
    # Port Scan
    echo -e "${Y}[*] Port Scan...${NC}"
    nmap -T4 -F $target 2>/dev/null > results/$target/ports.txt
    
    # Summary
    {
        echo "========== RECON SUMMARY =========="
        echo "Target: $target"
        echo "Date: $(date)"
        echo "IP: $(dig +short $target | head -1)"
        echo ""
        echo "Open Ports:"
        nmap -T4 -F $target 2>/dev/null | grep -E "^[0-9]" | grep open
        echo ""
        echo "WHOIS Info:"
        whois $target 2>/dev/null | grep -E "Domain Name:|Registrar:|Creation Date:" | head -3
    } > results/$target/summary.txt
    
    echo -e "${G}[✓] Full recon complete!${NC}"
    echo -e "${G}[✓] Results: results/$target/${NC}"
}

# =================== HTML REPORT GENERATOR ===================
generate_html_report() {
    target=$1
    echo -e "${C}[+] Generating HTML Report...${NC}"
    
    IP=$(dig +short $target 2>/dev/null | head -1)
    OPEN_PORTS=$(nmap -T4 -F $target 2>/dev/null | grep -E "^[0-9]" | grep open | wc -l)
    
    cat > results/report_$target.html << EOF
<!DOCTYPE html>
<html>
<head>
    <title>GAUTAM RECON PRO - $target</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { 
            font-family: 'Segoe UI', Arial; 
            background: #0a0e17; 
            color: #00ff88;
            padding: 20px;
        }
        .container { max-width: 1200px; margin: auto; }
        .header {
            background: linear-gradient(135deg, #0a1628, #1a2a4a);
            padding: 30px;
            border-radius: 15px;
            border: 1px solid #00ff88;
            margin-bottom: 20px;
        }
        .header h1 { color: #00ff88; font-size: 2.5em; }
        .header h2 { color: #ffaa00; }
        .card {
            background: #0d1b2a;
            padding: 20px;
            border-radius: 10px;
            margin: 15px 0;
            border: 1px solid #1a3a5a;
        }
        .card h3 { color: #ffaa00; margin-bottom: 10px; }
        .green { color: #00ff88; }
        .red { color: #ff4444; }
        .yellow { color: #ffaa00; }
        table { width: 100%; border-collapse: collapse; }
        td, th { 
            border: 1px solid #1a3a5a; 
            padding: 10px; 
            text-align: left;
        }
        th { background: #1a2a4a; color: #ffaa00; }
        .footer { 
            text-align: center; 
            padding: 20px; 
            color: #666;
            border-top: 1px solid #1a3a5a;
            margin-top: 20px;
        }
        pre {
            background: #0a0a0a;
            padding: 15px;
            border-radius: 8px;
            overflow-x: auto;
            color: #00ff88;
        }
        .badge {
            display: inline-block;
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 12px;
            margin: 5px;
        }
        .badge-alive { background: #00ff8822; border: 1px solid #00ff88; color: #00ff88; }
        .badge-down { background: #ff444422; border: 1px solid #ff4444; color: #ff4444; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🛡️ GAUTAM RECON PRO</h1>
            <h2>Target: $target</h2>
            <p>📅 Date: $(date)</p>
            <p>👤 Admin: Gautam Kumar</p>
            <p>📌 Version: 2.0</p>
        </div>
        
        <div class="card">
            <h3>📌 Target Information</h3>
            <table>
                <tr><td>Target</td><td>$target</td></tr>
                <tr><td>IP Address</td><td>$IP</td></tr>
                <tr><td>Status</td><td>$(ping -c 1 $target &>/dev/null && echo "<span class='badge badge-alive'>✅ ALIVE</span>" || echo "<span class='badge badge-down'>❌ DOWN</span>")</td></tr>
                <tr><td>Open Ports</td><td>$OPEN_PORTS</td></tr>
                <tr><td>Scan Date</td><td>$(date)</td></tr>
            </table>
        </div>
        
        <div class="card">
            <h3>🔍 Open Ports</h3>
            <pre>$(nmap -T4 -F $target 2>/dev/null | grep -E "^[0-9]" | grep open || echo "No open ports found")</pre>
        </div>
        
        <div class="card">
            <h3>📊 DNS Records</h3>
            <pre>$(dig $target ANY +short 2>/dev/null | head -20 || echo "No DNS records found")</pre>
        </div>
        
        <div class="card">
            <h3>📋 WHOIS Information</h3>
            <pre>$(whois $target 2>/dev/null | head -20 || echo "No WHOIS data found")</pre>
        </div>
        
        <div class="footer">
            <p>© 2026 Gautam Kumar | 🔒 Ethical Use Only</p>
            <p>Made with ❤️ by Gautam</p>
        </div>
    </div>
</body>
</html>
EOF
    
    echo -e "${G}[✓] HTML Report: results/report_$target.html${NC}"
    echo -e "${Y}[!] Open: firefox results/report_$target.html${NC}"
}

# =================== JSON EXPORT ===================
export_json() {
    target=$1
    ip=$(dig +short $target 2>/dev/null | head -1)
    
    cat > results/data_$target.json << EOF
{
    "tool": "GAUTAM RECON PRO",
    "version": "2.0",
    "admin": "Gautam Kumar",
    "target": "$target",
    "ip": "$ip",
    "date": "$(date)",
    "status": "$(ping -c 1 $target &>/dev/null && echo "alive" || echo "down")",
    "open_ports": $(nmap -T4 -F $target 2>/dev/null | grep -E "^[0-9]" | grep open | wc -l),
    "results": {
        "whois": "$(whois $target 2>/dev/null | head -5 | tr '\n' ' ' | sed 's/"/\\"/g')",
        "dns": "$(dig $target ANY +short 2>/dev/null | head -5 | tr '\n' ' ' | sed 's/"/\\"/g')"
    }
}
EOF
    
    echo -e "${G}[✓] JSON: results/data_$target.json${NC}"
}

# =================== IP LOCATION MAP ===================
ip_location_map() {
    target=$1
    ip=$(dig +short $target 2>/dev/null | head -1)
    
    if [ -z "$ip" ]; then
        echo -e "${R}[!] Could not resolve IP${NC}"
        return
    fi
    
    echo -e "${C}[+] IP Location Map${NC}"
    
    location=$(curl -s "http://ip-api.com/json/$ip" 2>/dev/null)
    lat=$(echo $location | jq -r '.lat' 2>/dev/null)
    lon=$(echo $location | jq -r '.lon' 2>/dev/null)
    city=$(echo $location | jq -r '.city' 2>/dev/null)
    country=$(echo $location | jq -r '.country' 2>/dev/null)
    
    {
        echo "========== IP LOCATION =========="
        echo "IP: $ip"
        echo "City: $city"
        echo "Country: $country"
        echo "Latitude: $lat"
        echo "Longitude: $lon"
        echo "Google Maps: https://www.google.com/maps?q=$lat,$lon"
    } > results/location_$target.txt
    
    echo -e "${G}[✓] Location: results/location_$target.txt${NC}"
    echo -e "${Y}[!] Google Maps: https://www.google.com/maps?q=$lat,$lon${NC}"
}

# =================== TELEGRAM BOT ===================
setup_telegram() {
    echo -e "${Y}[*] Setup Telegram Bot${NC}"
    echo -e "${W}1. Go to @BotFather on Telegram${NC}"
    echo -e "${W}2. Send: /newbot${NC}"
    echo -e "${W}3. Get your Bot Token${NC}"
    echo -e "${W}4. Get Chat ID from @userinfobot${NC}"
    echo ""
    read -p "Enter Bot Token: " BOT_TOKEN
    read -p "Enter Chat ID: " CHAT_ID
    
    echo "export BOT_TOKEN='$BOT_TOKEN'" >> ~/.bashrc
    echo "export CHAT_ID='$CHAT_ID'" >> ~/.bashrc
    source ~/.bashrc
    
    echo -e "${G}[✓] Telegram Bot configured!${NC}"
}

send_telegram() {
    target=$1
    
    if [ -z "$BOT_TOKEN" ] || [ -z "$CHAT_ID" ]; then
        echo -e "${Y}[!] Telegram not configured! Use option 7 to setup.${NC}"
        return
    fi
    
    message="🛡️ GAUTAM RECON PRO%0A%0A✅ Scan Complete: $target%0A📅 Date: $(date)%0A👤 Admin: Gautam Kumar%0A%0A📁 Results saved in results/%0A📊 HTML Report: results/report_$target.html%0A%0A🔗 https://github.com/gautam705074/gautam-recon-pro"
    
    curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" \
        -d chat_id="$CHAT_ID" \
        -d text="$message" \
        > /dev/null 2>&1
    
    echo -e "${G}[✓] Telegram notification sent!${NC}"
}

# =================== EMAIL ALERT ===================
send_email_alert() {
    target=$1
    
    echo -e "${Y}[*] Sending email alert...${NC}"
    
    if ! command -v sendmail &> /dev/null; then
        echo -e "${Y}[!] Installing mailutils...${NC}"
        sudo apt install mailutils -y &> /dev/null
    fi
    
    read -p "Enter email address: " email
    
    if [ -z "$email" ]; then
        echo -e "${R}[!] Email required${NC}"
        return
    fi
    
    {
        echo "Subject: 🛡️ GAUTAM RECON PRO - Scan Complete: $target"
        echo ""
        echo "=========================================="
        echo "   GAUTAM RECON PRO v2.0"
        echo "=========================================="
        echo ""
        echo "Target: $target"
        echo "Date: $(date)"
        echo "Admin: Gautam Kumar"
        echo ""
        echo "Results saved in results/ folder"
        echo "HTML Report: results/report_$target.html"
        echo "JSON Data: results/data_$target.json"
        echo ""
        echo "=========================================="
        echo "© 2026 Gautam Kumar | Ethical Use Only"
        echo "=========================================="
    } | sendmail "$email" 2>/dev/null
    
    echo -e "${G}[✓] Email sent to $email${NC}"
}

# =================== SCHEDULE SCAN ===================
schedule_scan() {
    echo -e "${Y}[*] Schedule Daily Scan${NC}"
    read -p "Enter target: " target
    read -p "Enter time (HH:MM, e.g., 06:00): " time
    
    if [ -z "$target" ] || [ -z "$time" ]; then
        echo -e "${R}[!] Target and time required${NC}"
        return
    fi
    
    cat > ~/scheduled_scan.sh << EOF
#!/bin/bash
cd ~/gautam-recon-pro
./gautam_recon.sh "$target"
EOF
    chmod +x ~/scheduled_scan.sh
    
    (crontab -l 2>/dev/null; echo "$time * * * ~/scheduled_scan.sh") | crontab -
    
    echo -e "${G}[✓] Daily scan scheduled at $time for $target${NC}"
}

# =================== AUTO-UPDATE ===================
auto_update() {
    echo -e "${C}[+] Checking for updates...${NC}"
    
    if ! command -v git &> /dev/null; then
        echo -e "${Y}[!] Git not installed${NC}"
        return
    fi
    
    git fetch 2>/dev/null
    LOCAL=$(git rev-parse HEAD 2>/dev/null)
    REMOTE=$(git rev-parse @{u} 2>/dev/null)
    
    if [ -z "$REMOTE" ]; then
        echo -e "${Y}[!] No remote set${NC}"
        return
    fi
    
    if [ "$LOCAL" != "$REMOTE" ]; then
        echo -e "${Y}[!] Update available!${NC}"
        read -p "Update now? (y/n): " choice
        if [[ "$choice" == "y" ]]; then
            git pull
            echo -e "${G}[✓] Updated successfully!${NC}"
            echo -e "${Y}[!] Restarting...${NC}"
            exec ./gautam_recon.sh
        fi
    else
        echo -e "${G}[✓] Already up to date!${NC}"
    fi
}

# =================== VIEW RESULTS ===================
view_results() {
    echo -e "${Y}═══════════════════════════════════════════${NC}"
    echo -e "${B}📁 AVAILABLE RESULTS${NC}"
    echo -e "${Y}═══════════════════════════════════════════${NC}"
    
    if [ ! -d "results" ] || [ -z "$(ls -A results 2>/dev/null)" ]; then
        echo -e "${Y}[!] No results found!${NC}"
        sleep 1
        return
    fi
    
    ls -lh results/
    echo ""
    read -p "Enter filename to view (or 'q' to quit): " file
    
    if [ "$file" = "q" ]; then
        return
    fi
    
    if [ -f "results/$file" ]; then
        cat results/$file | less
    else
        echo -e "${R}[!] File not found!${NC}"
        sleep 1
    fi
}

# =================== DELETE RESULTS ===================
delete_results() {
    echo -e "${R}⚠️  WARNING: This will delete ALL scan results!${NC}"
    read -p "Are you sure? (y/n): " confirm
    
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        rm -rf results/*
        echo -e "${G}[✓] All results deleted!${NC}"
    else
        echo -e "${Y}[!] Cancelled${NC}"
    fi
    sleep 1
}

# =================== MAIN MENU ===================
main_menu() {
    while true; do
        show_banner
        echo -e "${B}┌───────────── SCAN OPTIONS ─────────────┐${NC}"
        echo -e "${B}│${NC} 1. ${W}Set Target${NC}                                ${B}│${NC}"
        echo -e "${B}│${NC} 2. ${G}Full Recon (All Modules)${NC}                  ${B}│${NC}"
        echo -e "${B}│${NC} 3. ${C}Quick Scan${NC}                                ${B}│${NC}"
        echo -e "${B}└────────────────────────────────────────┘${NC}"
        echo ""
        echo -e "${B}┌───────────── REPORT OPTIONS ───────────┐${NC}"
        echo -e "${B}│${NC} 4. ${P}Generate HTML Report${NC}                      ${B}│${NC}"
        echo -e "${B}│${NC} 5. ${Y}Export JSON Data${NC}                          ${B}│${NC}"
        echo -e "${B}│${NC} 6. ${C}IP Location Map${NC}                           ${B}│${NC}"
        echo -e "${B}└────────────────────────────────────────┘${NC}"
        echo ""
        echo -e "${B}┌───────────── NOTIFICATION ────────────┐${NC}"
        echo -e "${B}│${NC} 7. ${Y}Telegram Alert${NC}                            ${B}│${NC}"
        echo -e "${B}│${NC} 8. ${G}Email Alert${NC}                               ${B}│${NC}"
        echo -e "${B}└────────────────────────────────────────┘${NC}"
        echo ""
        echo -e "${B}┌───────────── UTILITIES ──────────────┐${NC}"
        echo -e "${B}│${NC} 9. ${C}Schedule Daily Scan${NC}                       ${B}│${NC}"
        echo -e "${B}│${NC} 10. ${Y}Check for Updates${NC}                        ${B}│${NC}"
        echo -e "${B}│${NC} 11. ${W}View Results${NC}                             ${B}│${NC}"
        echo -e "${B}│${NC} 12. ${R}Delete Results${NC}                           ${B}│${NC}"
        echo -e "${B}│${NC} 13. ${G}Exit${NC}                                    ${B}│${NC}"
        echo -e "${B}└────────────────────────────────────────┘${NC}"
        echo ""
        read -p "$(echo -e ${G}"Select Option [1-13]: "${NC})" choice
        
        case $choice in
            1) 
                set_target
                ;;
            2) 
                if [ -z "$CURRENT_TARGET" ]; then
                    echo -e "${R}[!] Set target first!${NC}"
                    sleep 1
                    continue
                fi
                full_recon "$CURRENT_TARGET"
                generate_html_report "$CURRENT_TARGET"
                export_json "$CURRENT_TARGET"
                ip_location_map "$CURRENT_TARGET"
                read -p "Press Enter..."
                ;;
            3)
                if [ -z "$CURRENT_TARGET" ]; then
                    echo -e "${R}[!] Set target first!${NC}"
                    sleep 1
                    continue
                fi
                quick_scan "$CURRENT_TARGET"
                read -p "Press Enter..."
                ;;
            4)
                if [ -z "$CURRENT_TARGET" ]; then
                    echo -e "${R}[!] Set target first!${NC}"
                    sleep 1
                    continue
                fi
                generate_html_report "$CURRENT_TARGET"
                read -p "Press Enter..."
                ;;
            5)
                if [ -z "$CURRENT_TARGET" ]; then
                    echo -e "${R}[!] Set target first!${NC}"
                    sleep 1
                    continue
                fi
                export_json "$CURRENT_TARGET"
                read -p "Press Enter..."
                ;;
            6)
                if [ -z "$CURRENT_TARGET" ]; then
                    echo -e "${R}[!] Set target first!${NC}"
                    sleep 1
                    continue
                fi
                ip_location_map "$CURRENT_TARGET"
                read -p "Press Enter..."
                ;;
            7)
                if [ -z "$BOT_TOKEN" ] || [ -z "$CHAT_ID" ]; then
                    setup_telegram
                else
                    send_telegram "$CURRENT_TARGET"
                fi
                read -p "Press Enter..."
                ;;
            8)
                if [ -z "$CURRENT_TARGET" ]; then
                    echo -e "${R}[!] Set target first!${NC}"
                    sleep 1
                    continue
                fi
                send_email_alert "$CURRENT_TARGET"
                read -p "Press Enter..."
                ;;
            9)
                schedule_scan
                read -p "Press Enter..."
                ;;
            10)
                auto_update
                read -p "Press Enter..."
                ;;
            11)
                view_results
                ;;
            12)
                delete_results
                ;;
            13)
                echo -e "${G}[✓] Thanks for using GAUTAM RECON PRO!${NC}"
                echo -e "${Y}👤 Admin: Gautam Kumar${NC}"
                echo -e "${Y}🔗 https://github.com/gautam705074/gautam-recon-pro${NC}"
                exit 0
                ;;
            *)
                echo -e "${R}[!] Invalid option!${NC}"
                sleep 1
                ;;
        esac
    done
}

# =================== SCRIPT START ===================
clear

# Check requirements
for tool in nmap dig whois curl jq; do
    if ! command -v $tool &> /dev/null; then
        echo -e "${Y}[!] Installing $tool...${NC}"
        sudo apt install $tool -y &> /dev/null
    fi
done

# Show animation
ascii_animation

# Set default target
CURRENT_TARGET="google.com"

echo -e "${G}[✓] GAUTAM RECON PRO v2.0 Ready!${NC}"
echo -e "${Y}[!] Default target: $CURRENT_TARGET${NC}"
echo -e "${Y}[!] Use Option 1 to change target${NC}"
sleep 2

# Start main menu
main_menu
