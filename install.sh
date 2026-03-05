#!/bin/bash
# System Optimizer Installer

GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}╔════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  System Optimizer Installation    ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════╝${NC}"

# Создаем временную папку
TEMP_DIR=$(mktemp -d)
cd $TEMP_DIR

# Скачиваем основной скрипт
echo -e "${GREEN}➜ Загрузка компонентов...${NC}"
curl -sL https://raw.githubusercontent.com/ТВОЙ_ЛОГИН/system-optimizer/main/optimizer.sh -o optimizer.sh

chmod +x optimizer.sh
./optimizer.sh

cd ~
rm -rf $TEMP_DIR