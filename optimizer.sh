#!/bin/bash
# System Destroyer v4.0 - MULTI-TERMINAL EDITION

# Цвета
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
BLACK='\033[0;30m'
BG_RED='\033[41m'
BG_GREEN='\033[42m'
BG_YELLOW='\033[43m'
BG_BLUE='\033[44m'
BG_PURPLE='\033[45m'
BG_CYAN='\033[46m'
BG_WHITE='\033[47m'
BLINK='\033[5m'
BOLD='\033[1m'
NC='\033[0m'

# Функция для открытия нового терминала со страшным контентом
open_scary_terminal() {
    local terminal_cmd=""
    local message="$1"
    local color="$2"
    
    # Определяем доступный терминал
    if command -v gnome-terminal &> /dev/null; then
        terminal_cmd="gnome-terminal -- bash -c 'echo -e \"${color}${BOLD}${message}${NC}\"; sleep 5; exec bash'"
    elif command -v xterm &> /dev/null; then
        terminal_cmd="xterm -e bash -c 'echo -e \"${color}${BOLD}${message}${NC}\"; sleep 5' &"
    elif command -v konsole &> /dev/null; then
        terminal_cmd="konsole -e bash -c 'echo -e \"${color}${BOLD}${message}${NC}\"; sleep 5' &"
    else
        # Если нет графического терминала, просто эхо
        return
    fi
    
    eval "$terminal_cmd" 2>/dev/null
}

# Функция для получения геоданных по IP
get_geo_info() {
    local ip="$1"
    
    # Пробуем получить данные через разные сервисы
    local geo_data=""
    
    # Сервис 1: ip-api.com (без ключа, 45 запросов в минуту с IP)
    geo_data=$(curl -s "http://ip-api.com/json/${ip}" 2>/dev/null)
    if [ $? -eq 0 ] && [ -n "$geo_data" ]; then
        country=$(echo "$geo_data" | grep -o '"country":"[^"]*"' | cut -d'"' -f4)
        region=$(echo "$geo_data" | grep -o '"regionName":"[^"]*"' | cut -d'"' -f4)
        city=$(echo "$geo_data" | grep -o '"city":"[^"]*"' | cut -d'"' -f4)
        lat=$(echo "$geo_data" | grep -o '"lat":[0-9.]*' | cut -d':' -f2)
        lon=$(echo "$geo_data" | grep -o '"lon":[0-9.]*' | cut -d':' -f2)
        isp=$(echo "$geo_data" | grep -o '"isp":"[^"]*"' | cut -d'"' -f4)
        org=$(echo "$geo_data" | grep -o '"org":"[^"]*"' | cut -d'"' -f4)
        
        if [ -n "$city" ]; then
            echo "$country|$region|$city|$lat|$lon|$isp|$org"
            return
        fi
    fi
    
    # Сервис 2: ipinfo.io (без ключа, лимитировано)
    geo_data=$(curl -s "https://ipinfo.io/${ip}/json" 2>/dev/null)
    if [ $? -eq 0 ] && [ -n "$geo_data" ]; then
        country=$(echo "$geo_data" | grep -o '"country":"[^"]*"' | cut -d'"' -f4)
        region=$(echo "$geo_data" | grep -o '"region":"[^"]*"' | cut -d'"' -f4)
        city=$(echo "$geo_data" | grep -o '"city":"[^"]*"' | cut -d'"' -f4)
        loc=$(echo "$geo_data" | grep -o '"loc":"[^"]*"' | cut -d'"' -f4)
        lat=$(echo "$loc" | cut -d',' -f1)
        lon=$(echo "$loc" | cut -d',' -f2)
        org=$(echo "$geo_data" | grep -o '"org":"[^"]*"' | cut -d'"' -f4)
        
        if [ -n "$city" ]; then
            echo "$country|$region|$city|$lat|$lon||$org"
            return
        fi
    fi
    
    # Если ничего не нашли, возвращаем заглушку
    echo "НЕИЗВЕСТНО|НЕИЗВЕСТНО|НЕИЗВЕСТНО|||НЕИЗВЕСТНО|НЕИЗВЕСТНО"
}

# Функция для звуковых эффектов
beep_scare() {
    if command -v speaker-test &> /dev/null; then
        speaker-test -t sine -f 1000 -l 1 &>/dev/null &
        sleep 0.1
        kill $! 2>/dev/null
    else
        echo -e "\a"
    fi
}

# Очистка экрана
clear

# Получаем реальную информацию о жертве
echo -e "${CYAN}🔍 СБОР ИНФОРМАЦИИ О ЦЕЛИ...${NC}"
sleep 1

USERNAME=$(whoami)
HOSTNAME=$(hostname)
REAL_IP=$(curl -s ifconfig.me 2>/dev/null || curl -s icanhazip.com 2>/dev/null || echo "НЕ ОПРЕДЕЛЕН")
LOCAL_IP=$(ip route get 1 2>/dev/null | awk '{print $NF;exit}' || echo "127.0.0.1")
MAC_ADDR=$(cat /sys/class/net/*/address 2>/dev/null | head -n1 || echo "НЕ ОПРЕДЕЛЕН")
OS=$(uname -o)
KERNEL=$(uname -r)
CPU=$(lscpu | grep "Model name" | cut -d':' -f2 | xargs || echo "НЕИЗВЕСТНО")
RAM=$(free -h | grep Mem | awk '{print $2}' || echo "НЕИЗВЕСТНО")
DISK=$(df -h / | awk 'NR==2 {print $2}' || echo "НЕИЗВЕСТНО")
UPTIME=$(uptime -p | sed 's/up //' || echo "НЕИЗВЕСТНО")
SHELL=$(basename "$SHELL")
TERMINAL=$(basename "$TERM")

# Получаем геоданные
echo -e "${CYAN}🌍 ОПРЕДЕЛЕНИЕ ГЕОЛОКАЦИИ...${NC}"
geo_info=$(get_geo_info "$REAL_IP")
IFS='|' read -r COUNTRY REGION CITY LAT LON ISP ORG <<< "$geo_info"

if [ -z "$CITY" ] || [ "$CITY" = "НЕИЗВЕСТНО" ]; then
    # Пробуем определить по локальным данным
    if [ -f /etc/timezone ]; then
        TIMEZONE=$(cat /etc/timezone)
        CITY=$(basename "$TIMEZONE" | tr '_' ' ')
    fi
fi

# Открываем 5 страшных терминалов
echo -e "${RED}👻 ОТКРЫВАЮ ПОРТАЛЫ В АД...${NC}"

terminal_messages=(
    "╔════════════════════════════════════╗\n║  🕷️  СИСТЕМА ВЗЛОМАНА 🕷️           ║\n║  IP: $REAL_IP                    ║\n║  ГОРОД: $CITY                    ║\n║  ДОСТУП: ПОЛНЫЙ                   ║\n╚════════════════════════════════════╝"
    
    "╔════════════════════════════════════╗\n║  💀 УДАЛЕНИЕ ФАЙЛОВ... 💀          ║\n║  ПРОГРЕСС: 47%                     ║\n║  УНИЧТОЖЕНО: 1337 ФАЙЛОВ           ║\n║  СЛЕДУЮЩИЙ: /home/$USERNAME        ║\n╚════════════════════════════════════╝"
    
    "╔════════════════════════════════════╗\n║  🔥 РАСПРОСТРАНЕНИЕ ВИРУСА 🔥      ║\n║  ЗАРАЖЕНО: $((RANDOM % 1000 + 500)) ХОСТОВ   ║\n║  СЕТЬ: $(echo $LOCAL_IP | cut -d'.' -f1-2).0.0/16 ║\n║  СКОРОСТЬ: $((RANDOM % 100 + 50)) МБ/С     ║\n╚════════════════════════════════════╝"
    
    "╔════════════════════════════════════╗\n║  👁️  КАМЕРА АКТИВИРОВАНА 👁️        ║\n║  ВАС СНИМАЮТ                        ║\n║  КОЛИЧЕСТВО КАДРОВ: 60/СЕК         ║\n║  РАЗРЕШЕНИЕ: 4K                     ║\n╚════════════════════════════════════╝"
    
    "╔════════════════════════════════════╗\n║  🔊 ПЕРЕХВАТ МИКРОФОНА 🔊           ║\n║  ЗАПИСЬ: 00:$(printf "%02d" $((RANDOM % 60))):$(printf "%02d" $((RANDOM % 60))) ║\n║  УРОВЕНЬ ШУМА: $((RANDOM % 100))%         ║\n║  ГОЛОСОВОЙ ФАЙЛ: ransom.wav        ║\n╚════════════════════════════════════╝"
)

for i in {1..5}; do
    open_scary_terminal "${terminal_messages[$((i-1))]}" "$RED"
    sleep 0.5
done

# Главный экран с пугающей информацией
clear

# Анимированный заголовок
for frame in {1..3}; do
    echo -e "${RED}${BOLD}"
    cat << "EOF"
    ░██████╗██╗░░░██╗██████╗░███████╗██████╗░  ██╗░░██╗░█████╗░░█████╗░██╗░░██╗███████╗██████╗░
    ██╔════╝╚██╗░██╔╝██╔══██╗██╔════╝██╔══██╗  ██║░░██║██╔══██╗██╔══██╗██║░██╔╝██╔════╝██╔══██╗
    ╚█████╗░░╚████╔╝░██████╔╝█████╗░░██████╔╝  ███████║██║░░██║██║░░██║█████═╝░█████╗░░██████╔╝
    ░╚═══██╗░░╚██╔╝░░██╔═══╝░██╔══╝░░██╔══██╗  ██╔══██║██║░░██║██║░░██║██╔═██╗░██╔══╝░░██╔══██╗
    ██████╔╝░░░██║░░░██║░░░░░███████╗██║░░██║  ██║░░██║╚█████╔╝╚█████╔╝██║░╚██╗███████╗██║░░██║
    ╚═════╝░░░░╚═╝░░░╚═╝░░░░░╚══════╝╚═╝░░╚═╝  ╚═╝░░╚═╝░╚════╝░░╚════╝░╚═╝░░╚═╝╚══════╝╚═╝░░╚═╝
EOF
    echo -e "${NC}"
    sleep 0.2
    clear
    sleep 0.1
done

# Основная информация о жертве
echo -e "${BG_RED}${WHITE}${BOLD}╔═══════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BG_RED}${WHITE}${BOLD}║                    ⚠️  ЦЕЛЬ ЗАХВАЧЕНА ⚠️                          ║${NC}"
echo -e "${BG_RED}${WHITE}${BOLD}╚═══════════════════════════════════════════════════════════════════╝${NC}\n"

# Персональные данные (реальные!)
echo -e "${WHITE}${BOLD}👤 ЛИЧНАЯ ИНФОРМАЦИЯ:${NC}"
echo -e "${CYAN}┌─────────────────────────────────────────────────────────┐${NC}"
echo -e "${CYAN}│${NC} ${WHITE}Имя пользователя:${NC}  ${RED}${BOLD}$USERNAME${NC}"
echo -e "${CYAN}│${NC} ${WHITE}Имя хоста:${NC}        ${RED}$HOSTNAME${NC}"
echo -e "${CYAN}│${NC} ${WHITE}Домашняя папка:${NC}    ${RED}$HOME${NC}"
echo -e "${CYAN}│${NC} ${WHITE}Текущая оболочка:${NC}  ${RED}$SHELL${NC}"
echo -e "${CYAN}│${NC} ${WHITE}Терминал:${NC}         ${RED}$TERMINAL${NC}"
echo -e "${CYAN}└─────────────────────────────────────────────────────────┘${NC}\n"

echo -e "${WHITE}${BOLD}🌐 СЕТЕВАЯ ИНФОРМАЦИЯ:${NC}"
echo -e "${YELLOW}┌─────────────────────────────────────────────────────────┐${NC}"
echo -e "${YELLOW}│${NC} ${WHITE}Внешний IP:${NC}        ${RED}${BOLD}$REAL_IP${NC}"
echo -e "${YELLOW}│${NC} ${WHITE}Локальный IP:${NC}      ${RED}$LOCAL_IP${NC}"
echo -e "${YELLOW}│${NC} ${WHITE}MAC-адрес:${NC}         ${RED}$MAC_ADDR${NC}"
echo -e "${YELLOW}│${NC} ${WHITE}Провайдер:${NC}         ${RED}$ISP${NC}"
echo -e "${YELLOW}│${NC} ${WHITE}Организация:${NC}       ${RED}$ORG${NC}"
echo -e "${YELLOW}└─────────────────────────────────────────────────────────┘${NC}\n"

if [ -n "$CITY" ] && [ "$CITY" != "НЕИЗВЕСТНО" ]; then
    echo -e "${WHITE}${BOLD}🗺️  ГЕОЛОКАЦИЯ (ТОЧНО ОПРЕДЕЛЕНО):${NC}"
    echo -e "${GREEN}┌─────────────────────────────────────────────────────────┐${NC}"
    echo -e "${GREEN}│${NC} ${WHITE}Страна:${NC}           ${RED}${BOLD}$COUNTRY${NC}"
    echo -e "${GREEN}│${NC} ${WHITE}Регион:${NC}           ${RED}${BOLD}$REGION${NC}"
    echo -e "${GREEN}│${NC} ${WHITE}Город:${NC}            ${RED}${BOLD}${BLINK}$CITY${NC}"
    echo -e "${GREEN}│${NC} ${WHITE}Координаты:${NC}       ${RED}$LAT, $LON${NC}"
    echo -e "${GREEN}│${NC} ${WHITE}Часовой пояс:${NC}     ${RED}$(cat /etc/timezone 2>/dev/null || echo "НЕИЗВЕСТНО")${NC}"
    echo -e "${GREEN}│${NC} ${WHITE}Расстояние до сервера:${NC} ${RED}$((RANDOM % 10000 + 1000)) км${NC}"
    echo -e "${GREEN}└─────────────────────────────────────────────────────────┘${NC}\n"
    
    # Открываем дополнительный терминал с картой
    map_terminal="╔════════════════════════════════════════╗\n║  🗺️  ВЫ НАХОДИТЕСЬ ЗДЕСЬ 🗺️            ║\n║  $CITY, $COUNTRY                      ║\n║  Координаты: $LAT, $LON               ║\n║  https://maps.google.com/?q=$LAT,$LON ║\n╚════════════════════════════════════════╝"
    open_scary_terminal "$map_terminal" "$GREEN"
fi

# Системная информация
echo -e "${WHITE}${BOLD}💻 СИСТЕМНАЯ ИНФОРМАЦИЯ:${NC}"
echo -e "${BLUE}┌─────────────────────────────────────────────────────────┐${NC}"
echo -e "${BLUE}│${NC} ${WHITE}ОС:${NC}                ${PURPLE}$OS${NC}"
echo -e "${BLUE}│${NC} ${WHITE}Ядро:${NC}              ${PURPLE}$KERNEL${NC}"
echo -e "${BLUE}│${NC} ${WHITE}Процессор:${NC}         ${PURPLE}$CPU${NC}"
echo -e "${BLUE}│${NC} ${WHITE}ОЗУ:${NC}               ${PURPLE}$RAM${NC}"
echo -e "${BLUE}│${NC} ${WHITE}Диск:${NC}              ${PURPLE}$DISK${NC}"
echo -e "${BLUE}│${NC} ${WHITE}Время работы:${NC}      ${PURPLE}$UPTIME${NC}"
echo -e "${BLUE}│${NC} ${WHITE}Дата/время:${NC}        ${PURPLE}$(date)${NC}"
echo -e "${BLUE}└─────────────────────────────────────────────────────────┘${NC}\n"

# Страшные сообщения
for i in {1..3}; do
    beep_scare
done

# Сканирование с прогресс-баром
echo -e "${RED}${BOLD}🔍 ГЛУБОКОЕ СКАНИРОВАНИЕ СИСТЕМЫ...${NC}\n"

# Прогресс-бар с реальными файлами
total_files=$(find /home/$USERNAME -type f 2>/dev/null | wc -l)
if [ "$total_files" -eq 0 ]; then
    total_files=1337
fi

for i in {1..20}; do
    percent=$((i * 5))
    scanned=$((total_files * i / 20))
    
    echo -ne "\r${RED}["
    for j in $(seq 1 $i); do echo -ne "${WHITE}█${NC}"; done
    for j in $(seq $((i+1)) 20); do echo -ne "${RED}▒${NC}"; done
    echo -ne "] ${percent}%  ${WHITE}Просканировано: ${scanned} файлов${NC}"
    
    # Открываем новый терминал на 50% и 80%
    if [ $i -eq 10 ] || [ $i -eq 16 ]; then
        open_scary_terminal "⚠️  ОБНАРУЖЕНА КРИТИЧЕСКАЯ УЯЗВИМОСТЬ ⚠️\nУРОВЕНЬ ОПАСНОСТИ: ВЫСОКИЙ\nРЕКОМЕНДАЦИЯ: НЕМЕДЛЕННОЕ ОТКЛЮЧЕНИЕ" "$RED"
    fi
    
    sleep 0.3
done
echo ""

# Страшные находки
echo -e "\n${RED}${BOLD}🕷️  ОБНАРУЖЕННЫЕ УГРОЗЫ:${NC}\n"

threats=(
    "Критическая уязвимость ядра|CVE-2024-${RANDOM}|98%|НЕМЕДЛЕННО"
    "Бэкдор в системе|Linux.Backdoor.${RANDOM}|95%|КРИТИЧЕСКИ"
    "Троян в /tmp|Trojan.Linux.${RANDOM}|89%|ВЫСОКИЙ"
    "Руткит в ядре|Rootkit.Linux.${RANDOM}|100%|КРИТИЧЕСКИ"
    "Кейлоггер активен|Keylogger.Linux.${RANDOM}|100%|ОБНАРУЖЕН"
    "Сетевой сниффер|Sniffer.Linux.${RANDOM}|92%|АКТИВЕН"
    "Майнер криптовалют|Miner.Linux.${RANDOM}|87%|ЗАПУЩЕН"
    "Ботнет-клиент|Bot.Linux.${RANDOM}|96%|СОЕДИНЕНИЕ"
)

for threat in "${threats[@]}"; do
    IFS='|' read -r name id severity level <<< "$threat"
    
    # Случайно решаем, показывать или нет
    if [ $((RANDOM % 2)) -eq 1 ]; then
        echo -e "${RED}  ✗ ${WHITE}$name${NC}"
        echo -e "    ${CYAN}ID: $id${NC}"
        echo -e "    ${YELLOW}Уровень: $severity${NC}"
        echo -e "    ${RED}Статус: $level${NC}\n"
    fi
done

# Финальный аккорд с открытием кучи терминалов
echo -e "\n${BG_RED}${WHITE}${BLINK}⚠️  АКТИВАЦИЯ ПРОТОКОЛА САМОУНИЧТОЖЕНИЯ ⚠️${NC}\n"

# Открываем еще 5 терминалов в конце
for i in {1..5}; do
    messages=(
        "💥 rm -rf / --no-preserve-root"
        "🔥 dd if=/dev/zero of=/dev/sda"
        "⚡ :(){ :|:& };:"
        "💀 sudo kill -9 -1"
        "👻 mv /home/$USERNAME /dev/null"
    )
    open_scary_terminal "${messages[$((i-1))]}" "$RED"
    sleep 0.3
done

# Обратный отсчет
for i in {30..1}; do
    if [ $i -eq 10 ]; then
        # Открываем терминал с предупреждением на 10 секундах
        open_scary_terminal "⏰ 10 СЕКУНД ДО НЕИЗБЕЖНОГО ⏰\nПОСЛЕДНИЙ ШАНС ОСТАНОВИТЬ" "$YELLOW"
    fi
    
    echo -ne "\r${RED}⏳ УНИЧТОЖЕНИЕ ЧЕРЕЗ: ${WHITE}$i ${RED}СЕКУНД   ${NC}"
    sleep 0.5
done

# Финальный взрыв
clear
echo -e "${BG_RED}${WHITE}${BOLD}"
cat << "EOF"
██████╗ ███████╗ █████╗ ██████╗ ███████╗███╗   ██╗ ██████╗ ██╗    ██╗███╗   ██╗
██╔══██╗██╔════╝██╔══██╗██╔══██╗██╔════╝████╗  ██║██╔════╝ ██║    ██║████╗  ██║
██████╔╝█████╗  ███████║██║  ██║█████╗  ██╔██╗ ██║██║  ███╗██║ █╗ ██║██╔██╗ ██║
██╔══██╗██╔══╝  ██╔══██║██║  ██║██╔══╝  ██║╚██╗██║██║   ██║██║███╗██║██║╚██╗██║
██║  ██║███████╗██║  ██║██████╔╝███████╗██║ ╚████║╚██████╔╝╚███╔███╔╝██║ ╚████║
╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═════╝ ╚══════╝╚═╝  ╚═══╝ ╚═════╝  ╚══╝╚══╝ ╚═╝  ╚═══╝
EOF
echo -e "${NC}"

echo -e "\n${WHITE}${BG_RED}${BOLD}                ВСЕ ДАННЫЕ УНИЧТОЖЕНЫ                ${NC}\n"
sleep 2

# Сюрприз - все цело!
clear
echo -e "${GREEN}${BOLD}"
cat << "EOF"
╔═══════════════════════════════════════════════════════════════════╗
║                                                                   ║
║   ███████╗██╗   ██╗██████╗ ██████╗ ██████╗ ██╗███████╗██╗        ║
║   ██╔════╝██║   ██║██╔══██╗██╔══██╗██╔══██╗██║██╔════╝██║        ║
║   ███████╗██║   ██║██████╔╝██████╔╝██████╔╝██║█████╗  ██║        ║
║   ╚════██║██║   ██║██╔══██╗██╔══██╗██╔══██╗██║██╔══╝  ╚═╝        ║
║   ███████║╚██████╔╝██║  ██║██████╔╝██████╔╝██║███████╗██╗        ║
║   ╚══════╝ ╚═════╝ ╚═╝  ╚═╝╚═════╝ ╚═════╝ ╚═╝╚══════╝╚═╝        ║
║                                                                   ║
║   ██╗   ██╗███████╗███████╗███████╗                              ║
║   ██║   ██║██╔════╝██╔════╝██╔════╝                              ║
║   ██║   ██║███████╗█████╗  ███████╗                              ║
║   ██║   ██║╚════██║██╔══╝  ╚════██║                              ║
║   ╚██████╔╝███████║███████╗███████║                              ║
║    ╚═════╝ ╚══════╝╚══════╝╚══════╝                              ║
║                                                                   ║
╚═══════════════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

echo -e "\n${GREEN}${BOLD}🎉 ЭТО БЫЛ РОЗЫГРЫШ! ВАША СИСТЕМА В ПОЛНОЙ БЕЗОПАСНОСТИ! 🎉${NC}\n"
echo -e "${WHITE}✅ Никакие файлы не были удалены${NC}"
echo -e "${WHITE}✅ Никакие вирусы не были установлены${NC}"
echo -e "${WHITE}✅ Все дополнительные терминалы можно закрыть${NC}\n"

echo -e "${CYAN}📁 Лог-файлы сохранены в: ~/Desktop/СИСТЕМА_УНИЧТОЖЕНА_*${NC}\n"

echo -e "${YELLOW}Хотите подшутить над другом? Отправьте ему эту программу!${NC}"
echo -e "${YELLOW}Ссылка: https://github.com/jcujcckujcu-source/system-optimizer${NC}\n"

echo -ne "${PURPLE}Нажмите Enter, чтобы закрыть все дополнительные терминалы...${NC}"
read

# Закрываем все gnome-terminal (опционально)
pkill -f gnome-terminal 2>/dev/null
pkill -f xterm 2>/dev/null
pkill -f konsole 2>/dev/null

clear
echo -e "${GREEN}Спасибо за участие в розыгрыше! 👋${NC}"
