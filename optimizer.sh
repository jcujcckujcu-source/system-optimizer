#!/bin/bash
# System Optimizer Pro v2.0

# Цвета
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

clear

# Страшный ASCII арт
echo -e "${RED}"
cat << "EOF"
  ██████  ██▓   ▓█████ ▄████▄  ██▓▄▄▄█████▓ ██▓ ▒█████   ███▄    █ 
▒██    ▒ ▓██▒   ▓█   ▀▒██▀ ▀█ ▓██▒▓  ██▒ ▓▒▓██▒▒██▒  ██▒ ██ ▀█   █ 
░ ▓██▄   ▒██░   ▒███  ▒▓█    ▄▒██▒▒ ▓██░ ▒░▒██▒▒██░  ██▒▓██  ▀█ ██▒
  ▒   ██▒▒██░   ▒▓█  ▄▒▓▓▄ ▄██░██░░ ▓██▓ ░ ░██░▒██   ██░▓██▒  ▐▌██▒
▒██████▒▒░██████░▒████▒ ▓███▀ ░██░  ▒██▒ ░ ░██░░ ████▓▒░▒██░   ▓██░
▒ ▒▓▒ ▒ ░░ ▒░▓  ░░ ▒░ ░ ░▒ ▒  ░▓    ▒ ░░   ░▓  ░ ▒░▒░▒░ ░ ▒░   ▒ ▒ 
░ ░▒  ░ ░░ ░ ▒  ░░ ░  ░ ░  ▒   ▒ ░    ░     ▒ ░  ░ ▒ ▒░ ░ ░░   ░ ▒░
░  ░  ░    ░ ░     ░  ░        ▒ ░  ░       ▒ ░░ ░ ░ ▒     ░   ░ ░ 
      ░      ░  ░  ░  ░ ░      ░            ░      ░ ░           ░ 
                  ░                                                
EOF
echo -e "${NC}"

echo -e "\n${YELLOW}╔════════════════════════════════════════════════════════╗${NC}"
echo -e "${YELLOW}║     АНАЛИЗ СИСТЕМЫ БЕЗОПАСНОСТИ                      ║${NC}"
echo -e "${YELLOW}╚════════════════════════════════════════════════════════╝${NC}\n"

# Сбор информации
USERNAME=$(whoami)
HOSTNAME=$(hostname)
IP=$(ip route get 1 2>/dev/null | awk '{print $NF;exit}' || echo "не определен")
OS=$(uname -o)
KERNEL=$(uname -r)

echo -e "${CYAN}Система:${NC} $OS"
echo -e "${CYAN}Ядро:${NC} $KERNEL"
echo -e "${CYAN}Пользователь:${NC} $USERNAME"
echo -e "${CYAN}Хост:${NC} $HOSTNAME"
echo -e "${CYAN}IP-адрес:${NC} $IP"
echo ""

# Сканирование
echo -e "${RED}🔍 Сканирование уязвимостей...${NC}"
sleep 2

critical_files=(
    "/etc/passwd"
    "/etc/shadow"
    "$HOME/.bash_history"
    "$HOME/.ssh/id_rsa"
    "/var/log/auth.log"
    "/etc/sudoers"
)

found=0
for file in "${critical_files[@]}"; do
    if [ -f "$file" ]; then
        echo -e "${RED}  ⚠️  НАЙДЕН: $file${NC}"
        ((found++))
    fi
    sleep 0.3
done

# "Вирусы"
echo -e "\n${PURPLE}🦠 Обнаруженные угрозы:${NC}"
malware=("Linux.Trojan.Agent" "Rootkit.Linux.XOR" "Backdoor.Linux.Mumble")
for m in "${malware[@]}"; do
    if [ $((RANDOM % 2)) -eq 1 ]; then
        echo -e "${RED}  ✗ $m${NC}"
    fi
    sleep 0.5
done

# Прогресс-бар "уничтожения"
echo -e "\n${RED}💀 Активация протокола уничтожения...${NC}"
for i in {1..20}; do
    echo -ne "\r${RED}["
    for j in $(seq 1 $i); do echo -ne "█"; done
    for j in $(seq $i 19); do echo -ne " "; done
    echo -ne "] $((i*5))%${NC}"
    sleep 0.2
done
echo ""

# Создаем папку с "удаленными" файлами
mkdir -p ~/Desktop/СИСТЕМА_УНИЧТОЖЕНА_$(date +%Y%m%d)
for i in {1..30}; do
    echo "ФАЙЛ УДАЛЕН: system_$i.dll" > ~/Desktop/СИСТЕМА_УНИЧТОЖЕНА_$(date +%Y%m%d)/deleted_$i.txt
done

# Финальный аккорд
echo -e "\n\n${RED}╔════════════════════════════════════════════════════════╗${NC}"
echo -e "${RED}║     ❌ СИСТЕМА ПОЛНОСТЬЮ УНИЧТОЖЕНА ❌                ║${NC}"
echo -e "${RED}╚════════════════════════════════════════════════════════╝${NC}\n"

echo -e "${BLUE}Для восстановления нажмите Enter...${NC}"
read -s

clear
echo -e "${GREEN}╔════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║     🎉 ЭТО БЫЛ РОЗЫГРЫШ! 🎉                          ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════╝${NC}\n"
echo -e "${GREEN}Ничего не удалено! Файлы в папке на рабочем столе${NC}"
read