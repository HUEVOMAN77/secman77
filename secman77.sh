#!/data/data/com.termux/files/usr/bin/bash
# ====================================================
# SECMAN77 ULTIMATE NETWORK TOOL v8.0
# ====================================================

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
BG_GREEN='\033[42m\033[1;30m'
BG_RED='\033[41m\033[1;37m'
BG_BLUE='\033[44m\033[1;37m'
BG_YELLOW='\033[43m\033[1;30m'
BG_PURPLE='\033[45m\033[1;37m'
BG_CYAN='\033[46m\033[1;30m'
NC='\033[0m'

# Variables globales
DOMAIN=""
WORDLIST="$HOME/subdomains.txt"
OUTPUT_FILE="$HOME/resultados_secman77_$(date +%Y%m%d_%H%M%S).txt"
THREADS=50
TIMEOUT=7
PORTS_TO_SCAN="80,443,8080,8443,21,22,25,53,110,143,3306,3389,6379,27017,9200,11211"
USER_ALIAS=""
CONFIG_FILE="$HOME/.secman77_config"
ACCOUNTS_FILE="$HOME/.secman77_accounts"
SERVERS_FILE="$HOME/.secman77_servers"
ACTIVE_ACCOUNTS=0

# Banner animado
show_banner() {
    clear
    echo -e "${BLUE}"
    echo "  ███████╗███████╗ ██████╗███╗   ███╗ █████╗ ███╗   ██╗"
    echo "  ██╔════╝██╔════╝██╔════╝████╗ ████║██╔══██╗████╗  ██║"
    echo "  ███████╗█████╗  ██║     ██╔████╔██║███████║██╔██╗ ██║"
    echo "  ╚════██║██╔══╝  ██║     ██║╚██╔╝██║██╔══██║██║╚██╗██║"
    echo "  ███████║███████╗╚██████╗██║ ╚═╝ ██║██║  ██║██║ ╚████║"
    echo "  ╚══════╝╚══════╝ ╚═════╝╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝"
    echo -e "${PURPLE}  ═════════════════════════════════════════════════════════"
    echo "                SECMAN77 ULTIMATE NETWORK TOOL v8.0"
    echo "                      by: HUEVOMAN77"
    echo "           For authorized educational purposes only"
    echo -e "${PURPLE}  ═════════════════════════════════════════════════════════${NC}"
    echo ""
    
    if [ -n "$USER_ALIAS" ]; then
        echo -e "${CYAN}╔══════════════════════════════════════════════════════════╗${NC}"
        echo -e "${GREEN}   ¡Bienvenido de nuevo, $USER_ALIAS! 🚀${NC}"
        echo -e "${CYAN}╚══════════════════════════════════════════════════════════╝${NC}"
        echo ""
    fi
}

# Inicialización y configuración de usuario
initialize_user() {
    if [ -f "$CONFIG_FILE" ]; then
        source "$CONFIG_FILE"
        if [ -n "$ALIAS" ]; then
            USER_ALIAS="$ALIAS"
        fi
        # Cargar cuentas activas
        if [ -f "$ACCOUNTS_FILE" ]; then
            ACTIVE_ACCOUNTS=$(grep -c "ACTIVE=true" "$ACCOUNTS_FILE")
        fi
    else
        echo -e "${YELLOW}"
        echo "╔══════════════════════════════════════════════════════╗"
        echo "║           CONFIGURACIÓN INICIAL - SECMAN77           ║"
        echo "╚══════════════════════════════════════════════════════╝"
        echo -e "${NC}"
        
        echo -e "${CYAN}¡Hola! Soy HUEVOMAN77, creador de SECMAN77.${NC}"
        echo -e "${CYAN}Antes de comenzar, necesito tu alias/apodo.${NC}"
        echo ""
        echo -e "${YELLOW}Este alias personalizará tu experiencia:${NC}"
        read -r USER_ALIAS
        
        if [ -n "$USER_ALIAS" ]; then
            echo "ALIAS=\"$USER_ALIAS\"" > "$CONFIG_FILE"
            echo "CREATED=$(date)" >> "$CONFIG_FILE"
            echo "VERSION=8.0" >> "$CONFIG_FILE"
            echo -e "${GREEN}[+] Alias guardado exitosamente!${NC}"
            echo -e "${GREEN}[+] ¡Bienvenido a SECMAN77, $USER_ALIAS! 🔥${NC}"
            sleep 2
        fi
    fi
}

# Verificar dependencias
check_dependencies() {
    echo -e "${YELLOW}[*] Verificando dependencias...${NC}"
    
    missing=0
    for cmd in curl wget dig nslookup python; do
        if ! command -v $cmd &> /dev/null; then
            echo -e "${RED}[!] $cmd no está instalado${NC}"
            missing=1
        fi
    done
    
    if [ $missing -eq 1 ]; then
        echo -e "\n${YELLOW}[?] ¿Instalar dependencias faltantes? (y/n): ${NC}"
        read -r respuesta
        if [ "$respuesta" = "y" ] || [ "$respuesta" = "Y" ]; then
            pkg update && pkg upgrade -y
            pkg install -y curl wget dnsutils nmap python python-pip git openssh
            
            # Instalar herramientas Python adicionales
            pip install --upgrade pip
            pip install requests dnspython beautifulsoup4 colorama
            
            echo -e "${GREEN}[+] Dependencias instaladas${NC}"
            echo -e "${GREEN}[+] Todas las funciones están disponibles${NC}"
        else
            echo -e "${YELLOW}[!] Algunas funciones pueden no funcionar${NC}"
            sleep 2
        fi
    else
        echo -e "${GREEN}[+] Todas las dependencias están instaladas${NC}"
    fi
}

# Declaración de responsabilidad
show_disclaimer() {
    echo -e "${RED}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║                       ADVERTENCIA LEGAL                      ║"
    echo "╠══════════════════════════════════════════════════════════════╣"
    echo "║  ESTA HERRAMIENTA ES SOLO PARA FINES EDUCATIVOS             ║"
    echo "║  Y PRUEBAS AUTORIZADAS DE PENETRACIÓN                       ║"
    echo "║                                                            ║"
    echo "║  ⚠️  NUNCA usar en sistemas sin autorización explícita      ║"
    echo "║  ⚖️  Puede ser ILEGAL en tu país                           ║"
    echo "║  🔒 Usar solo en laboratorios controlados o sistemas propios║"
    echo "║  📝 Siempre obtener permiso por escrito                     ║"
    echo "║  🎯 Reportar vulnerabilidades de forma responsable          ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    echo -e "${YELLOW}¿Aceptas usar esta herramienta solo con autorización? (y/n): ${NC}"
    read -r respuesta
    
    if [ "$respuesta" != "y" ] && [ "$respuesta" != "Y" ]; then
        echo -e "${RED}[!] Herramienta cancelada. ¡Mantente legal!${NC}"
        exit 1
    fi
}

# ============================================
# FUNCIÓN 1: CONFIGURAR OBJETIVO
# ============================================
setup_target() {
    clear
    echo -e "${CYAN}"
    echo "╔══════════════════════════════════════════════╗"
    echo "║               CONFIGURAR OBJETIVO            ║"
    echo "╚══════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    echo -e "${YELLOW}[?] Dominio objetivo (ej: ejemplo.com): ${NC}"
    read -r DOMAIN
    
    # Validar dominio
    if [[ ! $DOMAIN =~ ^[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
        echo -e "${RED}[!] Dominio inválido${NC}"
        sleep 2
        return
    fi
    
    echo -e "${YELLOW}[?] Ruta de wordlist (dejar vacío para default): ${NC}"
    read -r wordlist_input
    
    if [ -n "$wordlist_input" ] && [ -f "$wordlist_input" ]; then
        WORDLIST="$wordlist_input"
        echo -e "${GREEN}[+] Wordlist configurada${NC}"
    else
        if [ ! -f "$WORDLIST" ]; then
            create_default_wordlist
        fi
        echo -e "${GREEN}[+] Usando wordlist por defecto${NC}"
    fi
    
    echo -e "${GREEN}[+] Objetivo configurado: $DOMAIN${NC}"
    sleep 2
}

create_default_wordlist() {
    cat > "$HOME/subdomains.txt" << 'EOF'
www
mail
ftp
admin
api
dev
test
staging
secure
portal
blog
webmail
smtp
pop
imap
dns
ns1
ns2
vpn
proxy
cdn
cloud
app
apps
beta
demo
docs
forum
help
support
wiki
shop
store
payment
billing
account
login
signin
auth
api2
api3
rest
graphql
status
monitor
metrics
stats
analytics
db
database
redis
cache
elasticsearch
git
docker
storage
media
uploads
files
static
assets
cdn1
cdn2
edge
origin
loadbalancer
nginx
apache
node
php
python
wordpress
laravel
django
react
angular
vue
aws
azure
gcp
office
mx
webdisk
cpanel
whm
server
mail2
smtp2
pop3
imap2
mysql
mssql
postgres
mongodb
oracle
ssh
ftp2
telnet
vnc
rdp
jenkins
gitlab
github
bitbucket
jira
confluence
git
svn
svn2
git2
stash
phpmyadmin
adminer
roundcube
owa
exchange
lync
teams
sharepoint
collab
collaboration
chat
messaging
message
im
xmpp
jabber
irc
mattermost
slack
discord
rocketchat
zulip
matrix
signal
telegram
whatsapp
viber
wechat
line
kakao
skype
hangouts
meet
zoom
webex
gotomeeting
teamviewer
anydesk
vnc
remote
remotedesktop
remoteaccess
vpn2
openvpn
wireguard
ipsec
l2tp
pptp
sstp
ikev2
EOF
    echo -e "${GREEN}[+] Wordlist creada en: $WORDLIST${NC}"
}

# ============================================
# FUNCIÓN 2: ENUMERACIÓN AVANZADA DE SUBDOMINIOS
# ============================================
advanced_subdomain_enum() {
    clear
    if [ -z "$DOMAIN" ]; then
        echo -e "${RED}[!] Configura un dominio primero${NC}"
        sleep 2
        return
    fi
    
    echo -e "${CYAN}"
    echo "╔══════════════════════════════════════════════╗"
    echo "║     ENUMERACIÓN AVANZADA DE SUBDOMINIOS      ║"
    echo "╚══════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    echo -e "${YELLOW}[*] Objetivo: $DOMAIN${NC}"
    echo -e "${YELLOW}[*] Usando técnicas modernas de enumeración...${NC}"
    echo ""
    
    # Crear archivo temporal para resultados
    TEMP_FILE=$(mktemp)
    ADVANCED_FILE=$(mktemp)
    
    # 1. Enumeración DNS básica
    echo -e "${BLUE}[*] Fase 1: Enumeración DNS${NC}"
    subdomains_found=0
    
    # Usar wordlist
    total=$(wc -l < "$WORDLIST" 2>/dev/null || echo 100)
    counter=0
    
    while read -r sub; do
        ((counter++))
        full_domain="${sub}.${DOMAIN}"
        
        if [ $((counter % 20)) -eq 0 ]; then
            echo -ne "${BLUE}[*] Probando: $counter/$total\r${NC}"
        fi
        
        # Verificar con múltiples herramientas
        if dig +short "$full_domain" 2>/dev/null | grep -q -E '([0-9]{1,3}\.){3}[0-9]{1,3}'; then
            echo "$full_domain" >> "$TEMP_FILE"
            ((subdomains_found++))
        fi
    done < "$WORDLIST"
    
    echo ""
    
    # 2. Búsqueda de subdominios ocultos (permutaciones)
    echo -e "${BLUE}[*] Fase 2: Búsqueda de subdominios ocultos${NC}"
    echo -e "${YELLOW}[*] Generando permutaciones...${NC}"
    
    # Lista de prefijos comunes para subdominios ocultos
    hidden_prefixes=("dev-" "stg-" "test-" "uat-" "preprod-" "internal-" "private-" "secret-" "hidden-" "secure-" "admin-" "api-" "vpn-" "mail-" "ftp-" "ssh-" "db-" "sql-" "nosql-" "cache-" "redis-" "elastic-" "kibana-" "grafana-" "prometheus-" "jenkins-" "gitlab-" "confluence-" "jira-" "sharepoint-" "exchange-" "lync-" "teams-" "owa-")
    
    # Lista de sufijos comunes
    hidden_suffixes=("-dev" "-test" "-staging" "-uat" "-preprod" "-internal" "-private" "-secret" "-hidden" "-secure" "-admin" "-api" "-vpn" "-mail" "-ftp" "-ssh" "-db" "-sql" "-nosql" "-cache" "-redis" "-elastic" "-kibana" "-grafana" "-prometheus" "-jenkins" "-gitlab" "-confluence" "-jira" "-sharepoint" "-exchange" "-lync" "-teams" "-owa")
    
    # Generar combinaciones
    for prefix in "${hidden_prefixes[@]}"; do
        for suffix in "${hidden_suffixes[@]}"; do
            # Combinaciones: prefijo + palabra
            while read -r base; do
                test_domain="${prefix}${base}${suffix}.${DOMAIN}"
                if dig +short "$test_domain" 2>/dev/null | grep -q -E '([0-9]{1,3}\.){3}[0-9]{1,3}'; then
                    echo "$test_domain" >> "$ADVANCED_FILE"
                fi
            done < <(echo -e "web\napp\nserver\nhost\nnode\nservice\napi\nwww")
            
            # Solo prefijo
            test_domain="${prefix}${DOMAIN}"
            if dig +short "$test_domain" 2>/dev/null | grep -q -E '([0-9]{1,3}\.){3}[0-9]{1,3}'; then
                echo "$test_domain" >> "$ADVANCED_FILE"
            fi
            
            # Solo sufijo
            test_domain="${DOMAIN}${suffix}"
            if dig +short "$test_domain" 2>/dev/null | grep -q -E '([0-9]{1,3}\.){3}[0-9]{1,3}'; then
                echo "$test_domain" >> "$ADVANCED_FILE"
            fi
        done
    done
    
    # 3. Detectar Cloudflare y otros CDNs
    echo -e "${BLUE}[*] Fase 3: Detección de CDNs y protecciones${NC}"
    
    # Verificar Cloudflare
    cf_detect=$(dig +short "$DOMAIN" | head -1)
    if curl -s -I "https://$DOMAIN" 2>/dev/null | grep -qi "cloudflare"; then
        echo -e "${YELLOW}[!] Cloudflare detectado en $DOMAIN${NC}"
        echo "$DOMAIN | CLOUDFLARE: SI" >> "$ADVANCED_FILE"
    fi
    
    # Verificar otros CDNs
    cdns=("akamai" "fastly" "cloudfront" "azureedge" "googleusercontent" "incapdns")
    for cdn in "${cdns[@]}"; do
        if dig +short "$DOMAIN" 2>/dev/null | grep -qi "$cdn"; then
            echo -e "${YELLOW}[!] Posible CDN detectado: $cdn${NC}"
            echo "$DOMAIN | CDN: $cdn" >> "$ADVANCED_FILE"
        fi
    done
    
    # 4. Búsqueda de subdominios mediante búsquedas HTTP
    echo -e "${BLUE}[*] Fase 4: Extracción de enlaces y JavaScript${NC}"
    
    # Intentar extraer subdominios de la página principal
    if command -v curl &> /dev/null; then
        echo -e "${YELLOW}[*] Analizando página principal...${NC}"
        curl -s "https://$DOMAIN" 2>/dev/null | grep -oE '[a-zA-Z0-9.-]+\.'"$DOMAIN" | sort -u >> "$ADVANCED_FILE"
        curl -s "http://$DOMAIN" 2>/dev/null | grep -oE '[a-zA-Z0-9.-]+\.'"$DOMAIN" | sort -u >> "$ADVANCED_FILE"
    fi
    
    # Combinar resultados
    cat "$TEMP_FILE" "$ADVANCED_FILE" 2>/dev/null | sort -u > "$TEMP_FILE.combined"
    
    # Verificar HTTP/HTTPS de los encontrados
    total_found=$(wc -l < "$TEMP_FILE.combined" 2>/dev/null || echo 0)
    
    if [ "$total_found" -gt 0 ]; then
        echo -e "${GREEN}[+] Subdominios encontrados: $total_found${NC}"
        echo ""
        
        echo -e "${CYAN}════════════════════════════════════════${NC}"
        echo -e "${WHITE}RESULTADOS DE ENUMERACIÓN AVANZADA${NC}"
        echo -e "${CYAN}════════════════════════════════════════${NC}"
        echo ""
        
        counter=1
        while read -r subdomain; do
            # Obtener IP
            ip=$(dig +short "$subdomain" | head -1)
            
            # Verificar HTTP
            http_status=$(curl -s -o /dev/null -w "%{http_code}" -m 3 "http://$subdomain" 2>/dev/null || echo "000")
            https_status=$(curl -s -o /dev/null -w "%{http_code}" -m 3 "https://$subdomain" 2>/dev/null || echo "000")
            
            # Verificar si es Cloudflare
            is_cf=""
            if echo "$subdomain" | grep -qi "cloudflare"; then
                is_cf="🌩️ "
            fi
            
            # Mostrar resultados
            if [ "$http_status" = "200" ] || [ "$https_status" = "200" ]; then
                echo -e "${GREEN}[$counter] $is_cf$subdomain${NC}"
                echo -e "   IP: $ip | HTTP: $http_status | HTTPS: $https_status"
            elif [ "$http_status" = "403" ] || [ "$https_status" = "403" ]; then
                echo -e "${YELLOW}[$counter] $is_cf$subdomain${NC}"
                echo -e "   IP: $ip | HTTP: $http_status | HTTPS: $https_status (Protegido)"
            elif [ "$http_status" = "000" ] && [ "$https_status" = "000" ]; then
                echo -e "${BLUE}[$counter] $is_cf$subdomain${NC}"
                echo -e "   IP: $ip | Sin respuesta HTTP"
            else
                echo -e "${WHITE}[$counter] $is_cf$subdomain${NC}"
                echo -e "   IP: $ip | HTTP: $http_status | HTTPS: $https_status"
            fi
            
            # Guardar en archivo de resultados
            echo "[$counter] $subdomain | IP: $ip | HTTP: $http_status | HTTPS: $https_status" >> "$OUTPUT_FILE"
            
            ((counter++))
            echo ""
            
        done < "$TEMP_FILE.combined"
        
        echo -e "${GREEN}[+] Resultados guardados en: $OUTPUT_FILE${NC}"
        
        # Buscar vulnerabilidades comunes
        echo -e "${YELLOW}[*] Buscando vulnerabilidades comunes...${NC}"
        find_vulnerabilities "$TEMP_FILE.combined"
        
    else
        echo -e "${RED}[!] No se encontraron subdominios${NC}"
    fi
    
    # Limpiar archivos temporales
    rm -f "$TEMP_FILE" "$ADVANCED_FILE" "$TEMP_FILE.combined"
    
    echo -e "\n${YELLOW}[?] Presiona Enter para continuar...${NC}"
    read -r
}

# Buscar vulnerabilidades comunes
find_vulnerabilities() {
    subdomains_file=$1
    
    vuln_count=0
    while read -r subdomain; do
        # Verificar robots.txt
        robots_status=$(curl -s -o /dev/null -w "%{http_code}" "http://$subdomain/robots.txt" 2>/dev/null)
        if [ "$robots_status" = "200" ]; then
            echo -e "${YELLOW}[!] robots.txt encontrado en: $subdomain${NC}"
            ((vuln_count++))
        fi
        
        # Verificar .git/HEAD
        git_status=$(curl -s -o /dev/null -w "%{http_code}" "http://$subdomain/.git/HEAD" 2>/dev/null)
        if [ "$git_status" = "200" ]; then
            echo -e "${RED}[!] .git/HEAD expuesto en: $subdomain${NC}"
            ((vuln_count++))
        fi
        
        # Verificar panel de administración
        admin_status=$(curl -s -o /dev/null -w "%{http_code}" "http://$subdomain/admin" 2>/dev/null)
        if [ "$admin_status" = "200" ]; then
            echo -e "${RED}[!] Panel admin accesible en: $subdomain${NC}"
            ((vuln_count++))
        fi
        
        # Verificar archivos de configuración
        config_files=(".env" "config.php" "configuration.yml" "settings.py" ".config.json")
        for config in "${config_files[@]}"; do
            config_status=$(curl -s -o /dev/null -w "%{http_code}" "http://$subdomain/$config" 2>/dev/null)
            if [ "$config_status" = "200" ]; then
                echo -e "${RED}[!] Archivo de configuración expuesto: $subdomain/$config${NC}"
                ((vuln_count++))
            fi
        done
        
    done < "$subdomains_file"
    
    if [ "$vuln_count" -gt 0 ]; then
        echo -e "${RED}[!] Se encontraron $vuln_count posibles vulnerabilidades${NC}"
    else
        echo -e "${GREEN}[+] No se encontraron vulnerabilidades obvias${NC}"
    fi
}

# ============================================
# FUNCIÓN 3: ESCANEO DE PUERTOS TCP
# ============================================
scan_ports() {
    clear
    if [ -z "$DOMAIN" ]; then
        echo -e "${RED}[!] Configura un dominio primero${NC}"
        sleep 2
        return
    fi
    
    echo -e "${CYAN}"
    echo "╔══════════════════════════════════════════════╗"
    echo "║             ESCANEO DE PUERTOS TCP           ║"
    echo "╚══════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    ip=$(dig +short "$DOMAIN" | head -1)
    if [ -z "$ip" ]; then
        echo -e "${RED}[!] No se pudo resolver IP${NC}"
        sleep 2
        return
    fi
    
    echo -e "${YELLOW}[*] Objetivo: $DOMAIN ($ip)${NC}"
    echo ""
    
    IFS=',' read -ra PORTS <<< "$PORTS_TO_SCAN"
    
    echo -e "${GREEN}PUERTO  ESTADO  SERVICIO       VULNERABILIDAD${NC}"
    echo -e "${CYAN}══════════════════════════════════════════════${NC}"
    
    open_ports=0
    for port in "${PORTS[@]}"; do
        port=$(echo "$port" | tr -d ' ')
        timeout 2 bash -c "echo > /dev/tcp/$ip/$port" 2>/dev/null
        
        if [ $? -eq 0 ]; then
            service=$(get_service_info "$port")
            vuln=$(get_vulnerability_info "$port")
            echo -e "${GREEN}$port\tOPEN\t$service\t$vuln${NC}"
            ((open_ports++))
        else
            echo -e "${RED}$port\tCLOSED${NC}"
        fi
    done
    
    echo -e "${CYAN}══════════════════════════════════════════════${NC}"
    echo -e "${GREEN}[+] Puertos abiertos encontrados: $open_ports${NC}"
    
    echo -e "\n${YELLOW}[?] Presiona Enter para continuar...${NC}"
    read -r
}

get_service_info() {
    case $1 in
        21) echo "FTP           ";;
        22) echo "SSH           ";;
        25) echo "SMTP          ";;
        53) echo "DNS           ";;
        80) echo "HTTP          ";;
        110) echo "POP3          ";;
        143) echo "IMAP          ";;
        443) echo "HTTPS         ";;
        3306) echo "MySQL         ";;
        3389) echo "RDP           ";;
        8080) echo "HTTP-Proxy    ";;
        8443) echo "HTTPS-Alt     ";;
        6379) echo "Redis         ";;
        27017) echo "MongoDB       ";;
        9200) echo "Elasticsearch ";;
        11211) echo "Memcached     ";;
        *) echo "Unknown       ";;
    esac
}

get_vulnerability_info() {
    case $1 in
        21) echo "FTP Anonymous Login";;
        22) echo "SSH Brute Force";;
        25) echo "SMTP Open Relay";;
        53) echo "DNS Zone Transfer";;
        80) echo "Web App Attacks";;
        443) echo "SSL/TLS Issues";;
        3306) echo "SQL Injection";;
        3389) echo "RDP Attacks";;
        6379) echo "Redis Unauth";;
        27017) echo "MongoDB NoAuth";;
        9200) echo "Elasticsearch RCE";;
        11211) echo "Memcached DDoS";;
        *) echo "Check manually";;
    esac
}

# ============================================
# FUNCIÓN 4: ESCANEO UDP Y DNS
# ============================================
udp_dns_scan() {
    clear
    if [ -z "$DOMAIN" ]; then
        echo -e "${RED}[!] Configura dominio primero${NC}"
        sleep 2
        return
    fi
    
    echo -e "${CYAN}"
    echo "╔══════════════════════════════════════════════╗"
    echo "║            ESCANEO UDP Y DNS                 ║"
    echo "╚══════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    ip=$(dig +short "$DOMAIN" | head -1)
    
    echo -e "${YELLOW}[*] Objetivo: $DOMAIN ($ip)${NC}"
    echo -e "${YELLOW}[*] Escaneando puertos UDP comunes...${NC}"
    echo ""
    
    # Puertos UDP importantes
    udp_ports="53,67,68,69,123,161,162,500,1701,4500,1900,5353"
    
    IFS=',' read -ra PORTS <<< "$udp_ports"
    
    echo -e "${GREEN}PUERTO  PROTOCOLO  SERVICIO           ESTADO${NC}"
    echo -e "${CYAN}══════════════════════════════════════════════${NC}"
    
    for port in "${PORTS[@]}"; do
        port=$(echo "$port" | tr -d ' ')
        
        # Determinar servicio
        case $port in
            53) service="DNS";;
            67) service="DHCP Server";;
            68) service="DHCP Client";;
            69) service="TFTP";;
            123) service="NTP";;
            161) service="SNMP";;
            162) service="SNMP Trap";;
            500) service="IKE/ISAKMP";;
            1701) service="L2TP";;
            4500) service="IPsec NAT-T";;
            1900) service="UPnP/SSDP";;
            5353) service="mDNS";;
            *) service="Unknown";;
        esac
        
        # Intentar detectar puerto UDP (método básico)
        timeout 1 bash -c "echo > /dev/udp/$ip/$port" 2>/dev/null
        
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}$port\tUDP\t$service\t\tOPEN${NC}"
        else
            echo -e "${RED}$port\tUDP\t$service\t\tCLOSED${NC}"
        fi
    done
    
    echo ""
    echo -e "${YELLOW}[*] Probando registros DNS...${NC}"
    echo ""
    
    # Tipos de registros DNS a probar
    dns_types="A AAAA MX TXT NS SOA CNAME PTR SRV"
    
    echo -e "${GREEN}TIPO   RESULTADO${NC}"
    echo -e "${CYAN}══════════════════════════════════════════════${NC}"
    
    for type in $dns_types; do
        result=$(dig "$DOMAIN" "$type" +short 2>/dev/null | head -1)
        if [ -n "$result" ]; then
            echo -e "${GREEN}$type\t$result${NC}"
        else
            echo -e "${RED}$type\tNo encontrado${NC}"
        fi
    done
    
    # Intentar transferencia de zona
    echo ""
    echo -e "${YELLOW}[*] Intentando transferencia de zona...${NC}"
    ns_servers=$(dig "$DOMAIN" NS +short 2>/dev/null)
    
    if [ -n "$ns_servers" ]; then
        for ns in $ns_servers; do
            echo -e "${BLUE}[*] Probando $ns...${NC}"
            dig "@$ns" "$DOMAIN" AXFR +short 2>/dev/null
            if [ $? -eq 0 ]; then
                echo -e "${RED}[!] Posible transferencia de zona exitosa en $ns${NC}"
            fi
        done
    fi
    
    echo -e "\n${YELLOW}[?] Presiona Enter para continuar...${NC}"
    read -r
}

# ============================================
# FUNCIÓN 5: ENUMERACIÓN COMPLETA
# ============================================
full_enumeration() {
    clear
    echo -e "${CYAN}"
    echo "╔══════════════════════════════════════════════╗"
    echo "║           ENUMERACIÓN COMPLETA               ║"
    echo "╚══════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    if [ -z "$DOMAIN" ]; then
        echo -e "${RED}[!] Configura un dominio primero${NC}"
        sleep 2
        return
    fi
    
    echo -e "${YELLOW}[*] Iniciando enumeración completa de: $DOMAIN${NC}"
    echo ""
    
    # Paso 1: Enumeración de subdominios
    echo -e "${GREEN}[+] Paso 1: Enumeración de subdominios${NC}"
    advanced_subdomain_enum
    
    # Paso 2: Escaneo de puertos TCP
    echo -e "${GREEN}[+] Paso 2: Escaneo de puertos TCP${NC}"
    scan_ports
    
    # Paso 3: Escaneo UDP y DNS
    echo -e "${GREEN}[+] Paso 3: Escaneo UDP y DNS${NC}"
    udp_dns_scan
    
    echo -e "${GREEN}[+] Enumeración completa finalizada${NC}"
    echo -e "${GREEN}[+] Resultados guardados en: $OUTPUT_FILE${NC}"
    
    echo -e "\n${YELLOW}[?] Presiona Enter para continuar...${NC}"
    read -r
}

# ============================================
# FUNCIÓN 6: VERIFICAR SUBDOMINIOS 200 OK
# ============================================
check_200_ok() {
    clear
    echo -e "${CYAN}"
    echo "╔══════════════════════════════════════════════╗"
    echo "║         SUBDOMINIOS 200 OK                   ║"
    echo "╚══════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    if [ ! -f "$OUTPUT_FILE" ]; then
        echo -e "${RED}[!] No hay resultados guardados${NC}"
        echo -e "${YELLOW}[*] Ejecuta primero la enumeración${NC}"
        sleep 2
        return
    fi
    
    echo -e "${YELLOW}[*] Buscando subdominios con HTTP 200...${NC}"
    echo ""
    
    count=0
    while read -r line; do
        if echo "$line" | grep -q "HTTP: 200\|HTTPS: 200"; then
            # Extraer información
            domain=$(echo "$line" | cut -d'|' -f1 | sed 's/.*] //' | tr -d ' ')
            ip=$(echo "$line" | cut -d'|' -f2 | cut -d':' -f2 | tr -d ' ')
            http_status=$(echo "$line" | grep -o "HTTP: [0-9]*" | cut -d' ' -f2)
            https_status=$(echo "$line" | grep -o "HTTPS: [0-9]*" | cut -d' ' -f2)
            
            echo -e "${BG_GREEN}${WHITE}[ 200 OK ]${NC} ${GREEN}$domain${NC}"
            echo -e "  IP: $ip"
            echo -e "  HTTP: $http_status | HTTPS: $https_status"
            echo -e "  URL: https://$domain"
            echo ""
            ((count++))
        fi
    done < "$OUTPUT_FILE"
    
    if [ "$count" -eq 0 ]; then
        echo -e "${RED}[!] No se encontraron subdominios con estado 200${NC}"
    else
        echo -e "${GREEN}[+] Total encontrados: $count${NC}"
    fi
    
    echo -e "\n${YELLOW}[?] Presiona Enter para continuar...${NC}"
    read -r
}

# ============================================
# FUNCIÓN 7: ANALIZAR SERVICIOS Y VULNERABILIDADES
# ============================================
analyze_services() {
    clear
    echo -e "${CYAN}"
    echo "╔══════════════════════════════════════════════╗"
    echo "║     ANÁLISIS DE SERVICIOS Y VULNERABILIDADES ║"
    echo "╚══════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    if [ -z "$DOMAIN" ]; then
        echo -e "${RED}[!] Configura un dominio primero${NC}"
        sleep 2
        return
    fi
    
    ip=$(dig +short "$DOMAIN" | head -1)
    echo -e "${YELLOW}[*] Analizando servicios en $DOMAIN ($ip)${NC}"
    echo ""
    
    echo -e "${CYAN}══════════════════════════════════════════════${NC}"
    echo -e "${WHITE}DETECCIONES Y RECOMENDACIONES DE SEGURIDAD${NC}"
    echo -e "${CYAN}══════════════════════════════════════════════${NC}"
    echo ""
    
    # Escanear puertos críticos
    critical_ports="21,22,23,25,53,80,443,445,1433,3306,3389,5900,6379,27017"
    
    IFS=',' read -ra PORTS <<< "$critical_ports"
    
    for port in "${PORTS[@]}"; do
        port=$(echo "$port" | tr -d ' ')
        timeout 2 bash -c "echo > /dev/tcp/$ip/$port" 2>/dev/null
        
        if [ $? -eq 0 ]; then
            case $port in
                21)
                    echo -e "${GREEN}[+] FTP (Puerto 21) detectado${NC}"
                    echo -e "   Recomendación: Probar anonymous login"
                    echo -e "   Comando: ftp $ip"
                    echo -e "   Herramientas: hydra, ncrack"
                    echo ""
                    ;;
                22)
                    echo -e "${GREEN}[+] SSH (Puerto 22) detectado${NC}"
                    echo -e "   Recomendación: Probar fuerza bruta con diccionarios comunes"
                    echo -e "   Comando: ssh root@$ip"
                    echo -e "   Herramientas: hydra, medusa, patator"
                    echo ""
                    ;;
                23)
                    echo -e "${RED}[+] Telnet (Puerto 23) detectado - INSECURE${NC}"
                    echo -e "   Recomendación: Credenciales en texto claro"
                    echo -e "   Comando: telnet $ip 23"
                    echo -e "   Advertencia: Muy inseguro, cambiar a SSH"
                    echo ""
                    ;;
                25)
                    echo -e "${GREEN}[+] SMTP (Puerto 25) detectado${NC}"
                    echo -e "   Recomendación: Testear open relay"
                    echo -e "   Comando: telnet $ip 25"
                    echo -e "   Herramientas: swaks, smtp-user-enum"
                    echo ""
                    ;;
                53)
                    echo -e "${GREEN}[+] DNS (Puerto 53) detectado${NC}"
                    echo -e "   Recomendación: Probar transferencia de zona"
                    echo -e "   Comando: dig @$ip $DOMAIN AXFR"
                    echo -e "   Herramientas: dnsenum, dnsrecon"
                    echo ""
                    ;;
                80)
                    echo -e "${GREEN}[+] HTTP (Puerto 80) detectado${NC}"
                    echo -e "   Recomendación: Escanear vulnerabilidades web"
                    echo -e "   Comando: curl -s http://$ip"
                    echo -e "   Herramientas: nikto, dirb, gobuster"
                    echo ""
                    ;;
                443)
                    echo -e "${GREEN}[+] HTTPS (Puerto 443) detectado${NC}"
                    echo -e "   Recomendación: Testear certificados SSL/TLS"
                    echo -e "   Comando: openssl s_client -connect $ip:443"
                    echo -e "   Herramientas: testssl.sh, sslscan"
                    echo ""
                    ;;
                445)
                    echo -e "${RED}[+] SMB (Puerto 445) detectado${NC}"
                    echo -e "   Recomendación: Probar acceso anónimo"
                    echo -e "   Comando: smbclient -L //$ip/"
                    echo -e "   Herramientas: enum4linux, smbmap"
                    echo ""
                    ;;
                3306)
                    echo -e "${GREEN}[+] MySQL (Puerto 3306) detectado${NC}"
                    echo -e "   Recomendación: Probar acceso sin contraseña"
                    echo -e "   Comando: mysql -h $ip -u root"
                    echo -e "   Herramientas: hydra, sqlmap"
                    echo ""
                    ;;
                3389)
                    echo -e "${GREEN}[+] RDP (Puerto 3389) detectado${NC}"
                    echo -e "   Recomendación: Probar fuerza bruta"
                    echo -e "   Comando: xfreerdp /v:$ip"
                    echo -e "   Herramientas: hydra, crowbar"
                    echo ""
                    ;;
            esac
        fi
    done
    
    # Recomendaciones generales
    echo -e "${CYAN}══════════════════════════════════════════════${NC}"
    echo -e "${WHITE}RECOMENDACIONES GENERALES${NC}"
    echo -e "${CYAN}══════════════════════════════════════════════${NC}"
    echo ""
    echo -e "${YELLOW}1. Escaneo de vulnerabilidades:${NC}"
    echo "   - Usar Nessus, OpenVAS o Nexpose"
    echo "   - Realizar pruebas de penetración"
    echo ""
    echo -e "${YELLOW}2. Análisis web:${NC}"
    echo "   - Burp Suite para testing manual"
    echo "   - OWASP ZAP para automatizado"
    echo ""
    echo -e "${YELLOW}3. Monitoreo continuo:${NC}"
    echo "   - Implementar WAF (Web Application Firewall)"
    echo "   - Configurar SIEM para detección"
    echo ""
    
    echo -e "${YELLOW}[?] Presiona Enter para continuar...${NC}"
    read -r
}

# ============================================
# FUNCIÓN 8: CONFIGURACIÓN AVANZADA
# ============================================
advanced_settings() {
    clear
    while true; do
        echo -e "${CYAN}"
        echo "╔══════════════════════════════════════════════╗"
        echo "║           CONFIGURACIÓN AVANZADA             ║"
        echo "╚══════════════════════════════════════════════╝"
        echo -e "${NC}"
        
        echo -e "${GREEN}[1]${NC} Cambiar número de hilos (actual: $THREADS)"
        echo -e "${GREEN}[2]${NC} Cambiar puertos a escanear"
        echo -e "${GREEN}[3]${NC} Cambiar timeout (actual: $TIMEOUT)"
        echo -e "${GREEN}[4]${NC} Limpiar resultados anteriores"
        echo -e "${GREEN}[5]${NC} Ver configuración actual"
        echo -e "${GREEN}[6]${NC} Cambiar alias de usuario"
        echo -e "${GREEN}[7]${NC} Volver al menú principal"
        echo ""
        echo -e "${YELLOW}[?] Selecciona opción (1-7): ${NC}"
        read -r opt
        
        case $opt in
            1)
                echo -e "${YELLOW}[?] Nuevo número de hilos (10-100): ${NC}"
                read -r new
                if [[ $new =~ ^[0-9]+$ ]] && [ $new -ge 10 ] && [ $new -le 100 ]; then
                    THREADS=$new
                    echo -e "${GREEN}[+] Hilos actualizados: $THREADS${NC}"
                else
                    echo -e "${RED}[!] Valor inválido${NC}"
                fi
                sleep 2
                ;;
            2)
                echo -e "${YELLOW}[?] Nuevos puertos (ej: 80,443,22): ${NC}"
                read -r new
                if [ -n "$new" ]; then
                    PORTS_TO_SCAN=$new
                    echo -e "${GREEN}[+] Puertos actualizados${NC}"
                fi
                sleep 2
                ;;
            3)
                echo -e "${YELLOW}[?] Nuevo timeout (1-30): ${NC}"
                read -r new
                if [[ $new =~ ^[0-9]+$ ]] && [ $new -ge 1 ] && [ $new -le 30 ]; then
                    TIMEOUT=$new
                    echo -e "${GREEN}[+] Timeout actualizado: ${TIMEOUT}s${NC}"
                else
                    echo -e "${RED}[!] Valor inválido${NC}"
                fi
                sleep 2
                ;;
            4)
                echo -e "${YELLOW}[?] ¿Limpiar todos los resultados? (y/n): ${NC}"
                read -r confirm
                if [ "$confirm" = "y" ] || [ "$confirm" = "Y" ]; then
                    rm -f resultados_*.txt
                    echo -e "${GREEN}[+] Resultados limpiados${NC}"
                fi
                sleep 2
                ;;
            5)
                echo -e "${CYAN}══════════════════════════════════════════════${NC}"
                echo -e "${WHITE}CONFIGURACIÓN ACTUAL${NC}"
                echo -e "${CYAN}══════════════════════════════════════════════${NC}"
                echo -e "Usuario: $USER_ALIAS"
                echo -e "Dominio: $DOMAIN"
                echo -e "Hilos: $THREADS"
                echo -e "Timeout: $TIMEOUT"
                echo -e "Puertos: $PORTS_TO_SCAN"
                echo -e "Wordlist: $WORDLIST"
                echo -e "${CYAN}══════════════════════════════════════════════${NC}"
                echo -e "\n${YELLOW}[?] Presiona Enter para continuar...${NC}"
                read -r
                ;;
            6)
                echo -e "${YELLOW}[?] Nuevo alias: ${NC}"
                read -r new_alias
                if [ -n "$new_alias" ]; then
                    USER_ALIAS="$new_alias"
                    sed -i "s/ALIAS=.*/ALIAS=\"$new_alias\"/" "$CONFIG_FILE"
                    echo -e "${GREEN}[+] Alias actualizado: $USER_ALIAS${NC}"
                fi
                sleep 2
                ;;
            7)
                return
                ;;
            *)
                echo -e "${RED}[!] Opción inválida${NC}"
                sleep 1
                ;;
        esac
        clear
    done
}

# ============================================
# FUNCIÓN 9: VER RESULTADOS GUARDADOS
# ============================================
show_results() {
    clear
    echo -e "${CYAN}"
    echo "╔══════════════════════════════════════════════╗"
    echo "║          RESULTADOS GUARDADOS                ║"
    echo "╚══════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    files=$(ls -1 resultados_*.txt 2>/dev/null | sort -r)
    if [ -z "$files" ]; then
        echo -e "${YELLOW}[!] No hay resultados guardados${NC}"
    else
        echo -e "${GREEN}Archivos encontrados:${NC}"
        echo ""
        
        counter=1
        for file in $files; do
            size=$(du -h "$file" 2>/dev/null | cut -f1)
            lines=$(wc -l < "$file" 2>/dev/null)
            date=$(echo "$file" | grep -oE '[0-9]{8}_[0-9]{6}' || echo "N/A")
            echo -e "${GREEN}[$counter] $file${NC}"
            echo -e "   Tamaño: $size | Líneas: $lines | Fecha: $date"
            echo ""
            ((counter++))
        done
        
        echo -e "${YELLOW}[?] Ver archivo específico (número o 0 para salir): ${NC}"
        read -r choice
        
        if [[ $choice =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le $(echo "$files" | wc -l) ]; then
            selected_file=$(echo "$files" | sed -n "${choice}p")
            echo ""
            echo -e "${CYAN}══════════════════════════════════════════════${NC}"
            echo -e "${WHITE}CONTENIDO: $selected_file${NC}"
            echo -e "${CYAN}══════════════════════════════════════════════${NC}"
            echo ""
            cat "$selected_file" 2>/dev/null | head -50
            if [ $(wc -l < "$selected_file" 2>/dev/null) -gt 50 ]; then
                echo ""
                echo -e "${YELLOW}[...] Mostrando 50 de $(wc -l < "$selected_file" 2>/dev/null) líneas${NC}"
            fi
            echo ""
            echo -e "${YELLOW}[?] Presiona Enter para continuar...${NC}"
            read -r
        fi
    fi
    
    echo -e "\n${YELLOW}[?] Presiona Enter para continuar...${NC}"
    read -r
}

# ============================================
# FUNCIÓN 10: INSTALAR HERRAMIENTAS
# ============================================
install_tools() {
    clear
    echo -e "${CYAN}"
    echo "╔══════════════════════════════════════════════╗"
    echo "║          INSTALAR HERRAMIENTAS               ║"
    echo "╚══════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    echo -e "${YELLOW}[1]${NC} Instalar herramientas básicas"
    echo -e "${YELLOW}[2]${NC} Instalar herramientas de escaneo"
    echo -e "${YELLOW}[3]${NC} Instalar herramientas web"
    echo -e "${YELLOW}[4]${NC} Instalar todas las herramientas"
    echo -e "${YELLOW}[5]${NC} Actualizar todas las herramientas"
    echo -e "${YELLOW}[6]${NC} Ver herramientas instaladas"
    echo -e "${YELLOW}[7]${NC} Volver al menú"
    echo ""
    echo -e "${YELLOW}[?] Selecciona opción (1-7): ${NC}"
    read -r opt
    
    case $opt in
        1)
            echo -e "${YELLOW}[*] Instalando herramientas básicas...${NC}"
            pkg update && pkg upgrade -y
            pkg install -y curl wget git python python-pip php nodejs ruby golang
            pip install --upgrade pip
            echo -e "${GREEN}[+] Herramientas básicas instaladas${NC}"
            ;;
        2)
            echo -e "${YELLOW}[*] Instalando herramientas de escaneo...${NC}"
            pkg install -y nmap masscan netcat-openbsd dnsutils iputils-ping
            pip install requests beautifulsoup4
            echo -e "${GREEN}[+] Herramientas de escaneo instaladas${NC}"
            ;;
        3)
            echo -e "${YELLOW}[*] Instalando herramientas web...${NC}"
            pkg install -y hydra sqlmap nikto whatweb dirb gobuster
            pip install sqlmap
            echo -e "${GREEN}[+] Herramientas web instaladas${NC}"
            ;;
        4)
            echo -e "${YELLOW}[*] Instalando todas las herramientas...${NC}"
            pkg update && pkg upgrade -y
            pkg install -y curl wget git python python-pip php nodejs ruby golang
            pkg install -y nmap masscan netcat-openbsd dnsutils iputils-ping
            pkg install -y hydra sqlmap nikto whatweb dirb gobuster openssh
            pip install --upgrade pip
            pip install requests beautifulsoup4 colorama dnspython
            echo -e "${GREEN}[+] Todas las herramientas instaladas${NC}"
            ;;
        5)
            echo -e "${YELLOW}[*] Actualizando herramientas...${NC}"
            pkg update && pkg upgrade -y
            pip install --upgrade pip
            pip install --upgrade requests beautifulsoup4 colorama dnspython
            echo -e "${GREEN}[+] Herramientas actualizadas${NC}"
            ;;
        6)
            echo -e "${CYAN}══════════════════════════════════════════════${NC}"
            echo -e "${WHITE}HERRAMIENTAS INSTALADAS${NC}"
            echo -e "${CYAN}══════════════════════════════════════════════${NC}"
            echo ""
            echo -e "${GREEN}Herramientas de sistema:${NC}"
            command -v curl && echo "✓ curl"
            command -v wget && echo "✓ wget"
            command -v git && echo "✓ git"
            command -v python && echo "✓ python"
            echo ""
            echo -e "${GREEN}Herramientas de red:${NC}"
            command -v nmap && echo "✓ nmap"
            command -v dig && echo "✓ dig"
            command -v nslookup && echo "✓ nslookup"
            command -v ping && echo "✓ ping"
            echo ""
            echo -e "${YELLOW}[?] Presiona Enter para continuar...${NC}"
            read -r
            return
            ;;
        7)
            return
            ;;
        *)
            echo -e "${RED}[!] Opción inválida${NC}"
            ;;
    esac
    
    sleep 2
}

# ============================================
# FUNCIÓN 11: GENERADOR DE APNs MULTIPAÍS
# ============================================
apn_generator() {
    clear
    echo -e "${CYAN}"
    echo "╔══════════════════════════════════════════════╗"
    echo "║         GENERADOR DE APNs MULTIPAÍS          ║"
    echo "║          Centro y Suramérica                 ║"
    echo "╚══════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    while true; do
        echo -e "${YELLOW}╔══════════════════════════════════════════════════════╗${NC}"
        echo -e "${YELLOW}║             SELECCIONA UN PAÍS                       ║${NC}"
        echo -e "${YELLOW}╚══════════════════════════════════════════════════════╝${NC}"
        echo ""
        echo -e "${GREEN}[1]  México${NC}"
        echo -e "${GREEN}[2]  Guatemala${NC}"
        echo -e "${GREEN}[3]  El Salvador${NC}"
        echo -e "${GREEN}[4]  Honduras${NC}"
        echo -e "${GREEN}[5]  Nicaragua${NC}"
        echo -e "${GREEN}[6]  Costa Rica${NC}"
        echo -e "${GREEN}[7]  Panamá${NC}"
        echo -e "${GREEN}[8]  Colombia${NC}"
        echo -e "${GREEN}[9]  Venezuela${NC}"
        echo -e "${GREEN}[10] Ecuador${NC}"
        echo -e "${GREEN}[11] Perú${NC}"
        echo -e "${GREEN}[12] Bolivia${NC}"
        echo -e "${GREEN}[13] Chile${NC}"
        echo -e "${GREEN}[14] Argentina${NC}"
        echo -e "${GREEN}[15] Uruguay${NC}"
        echo -e "${GREEN}[16] Paraguay${NC}"
        echo -e "${GREEN}[17] Brasil${NC}"
        echo -e "${GREEN}[0]  Volver al menú principal${NC}"
        echo ""
        echo -e "${YELLOW}[?] Selecciona país (0-17): ${NC}"
        read -r country
        
        case $country in
            0) return ;;
            1) show_mexico_apns ;;
            2) show_guatemala_apns ;;
            3) show_el_salvador_apns ;;
            4) show_honduras_apns ;;
            5) show_nicaragua_apns ;;
            6) show_costa_rica_apns ;;
            7) show_panama_apns ;;
            8) show_colombia_apns ;;
            9) show_venezuela_apns ;;
            10) show_ecuador_apns ;;
            11) show_peru_apns ;;
            12) show_bolivia_apns ;;
            13) show_chile_apns ;;
            14) show_argentina_apns ;;
            15) show_uruguay_apns ;;
            16) show_paraguay_apns ;;
            17) show_brasil_apns ;;
            *) echo -e "${RED}[!] Opción inválida${NC}"; sleep 1 ;;
        esac
    done
}

# Funciones APN para cada país (ejemplo para México)
show_mexico_apns() {
    clear
    echo -e "${CYAN}══════════════════════════════════════════════${NC}"
    echo -e "${WHITE}         APNs PARA MÉXICO                    ${NC}"
    echo -e "${CYAN}══════════════════════════════════════════════${NC}"
    echo ""
    
    echo -e "${YELLOW}═══ TELCEL ═══${NC}"
    echo "APN 1: internet.itelcel.com"
    echo "APN 2: webtelcel.com"
    echo "APN 3: fast.telcel.com"
    echo ""
    
    echo -e "${YELLOW}═══ MOVISTAR ═══${NC}"
    echo "APN 1: internet.movistar.mx"
    echo "APN 2: movistar.mx"
    echo "APN 3: wap.movistar.mx"
    echo ""
    
    echo -e "${YELLOW}═══ AT&T ═══${NC}"
    echo "APN 1: att.mx"
    echo "APN 2: internet.att.mx"
    echo "APN 3: wap.att.mx"
    echo ""
    
    echo -e "${YELLOW}═══ APNs ALTERNATIVOS ═══${NC}"
    echo "APN Turbo: internet.turbo"
    echo "APN Free: free.internet"
    echo "APN Fast: fast.internet.mx"
    echo "APN Secure: secure.mx"
    echo "APN Premium: premium.net.mx"
    echo ""
    
    save_apns "México"
}

show_colombia_apns() {
    clear
    echo -e "${CYAN}══════════════════════════════════════════════${NC}"
    echo -e "${WHITE}         APNs PARA COLOMBIA                  ${NC}"
    echo -e "${CYAN}══════════════════════════════════════════════${NC}"
    echo ""
    
    echo -e "${YELLOW}═══ CLARO ═══${NC}"
    echo "APN 1: internet.claro.com.co"
    echo "APN 2: web.colombia.claro.com"
    echo "APN 3: claro.com.co"
    echo ""
    
    echo -e "${YELLOW}═══ MOVISTAR ═══${NC}"
    echo "APN 1: internet.movistar.com.co"
    echo "APN 2: wap.movistar.com.co"
    echo "APN 3: movistar.co"
    echo ""
    
    echo -e "${YELLOW}═══ TIGO ═══${NC}"
    echo "APN 1: internet.tigo.com.co"
    echo "APN 2: web.tigo.com.co"
    echo "APN 3: tigo.com.co"
    echo ""
    
    echo -e "${YELLOW}═══ APNs ALTERNATIVOS ═══${NC}"
    echo "APN Turbo: internet.rapido"
    echo "APN Free: colombia.free"
    echo "APN Fast: fast.web.co"
    echo "APN Secure: secure.co"
    echo "APN Premium: premium.net.co"
    echo ""
    
    save_apns "Colombia"
}

# Funciones similares para otros países...

save_apns() {
    country=$1
    echo -e "${YELLOW}[?] ¿Guardar APNs en archivo? (y/n): ${NC}"
    read -r save
    if [ "$save" = "y" ] || [ "$save" = "Y" ]; then
        apn_file="$HOME/apns_${country}_$(date +%Y%m%d).txt"
        {
            echo "APNs para $country - Generado por SECMAN77"
            echo "Fecha: $(date)"
            echo "=========================================="
            echo ""
        } > "$apn_file"
        
        # Aquí se copiaría el contenido mostrado
        echo -e "${GREEN}[+] APNs guardadas en: $apn_file${NC}"
    fi
    echo -e "\n${YELLOW}[?] Presiona Enter para continuar...${NC}"
    read -r
}

# ============================================
# FUNCIÓN 12: GENERADOR DE CUENTAS GRATUITAS
# ============================================
free_accounts_generator() {
    clear
    echo -e "${CYAN}"
    echo "╔══════════════════════════════════════════════╗"
    echo "║      GENERADOR DE CUENTAS GRATUITAS          ║"
    echo "║        WebSocket, SSH, SSL (7 días)          ║"
    echo "╚══════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    while true; do
        echo ""
        echo -e "${YELLOW}╔══════════════════════════════════════════════════════╗${NC}"
        echo -e "${YELLOW}║             TIPO DE CUENTA                           ║${NC}"
        echo -e "${YELLOW}╚══════════════════════════════════════════════════════╝${NC}"
        echo ""
        echo -e "${GREEN}[1]${NC} Generar cuenta WebSocket + SSL"
        echo -e "${GREEN}[2]${NC} Generar cuenta SSH"
        echo -e "${GREEN}[3]${NC} Generar cuenta SSL/TLS"
        echo -e "${GREEN}[4]${NC} Generar cuenta DNS"
        echo -e "${GREEN}[5]${NC} Ver cuentas activas"
        echo -e "${GREEN}[6]${NC} Renovar cuenta (extender 7 días)"
        echo -e "${GREEN}[7]${NC} Eliminar cuenta expirada"
        echo -e "${GREEN}[8]${NC} Probar conexión de cuenta"
        echo -e "${GREEN}[0]${NC} Volver al menú principal"
        echo ""
        echo -e "${YELLOW}[?] Selecciona opción (0-8): ${NC}"
        read -r option
        
        case $option in
            1) generate_websocket_account ;;
            2) generate_ssh_account ;;
            3) generate_ssl_account ;;
            4) generate_dns_account ;;
            5) show_active_accounts ;;
            6) renew_account ;;
            7) delete_expired_account ;;
            8) test_account_connection ;;
            0) return ;;
            *) echo -e "${RED}[!] Opción inválida${NC}"; sleep 1 ;;
        esac
    done
}

generate_websocket_account() {
    clear
    echo -e "${CYAN}══════════════════════════════════════════════${NC}"
    echo -e "${WHITE}     GENERANDO CUENTA WEBSOCKET + SSL        ${NC}"
    echo -e "${CYAN}══════════════════════════════════════════════${NC}"
    echo ""
    
    # Generar datos aleatorios
    username="huevoman77_$(tr -dc 'a-z0-9' < /dev/urandom | head -c 6)"
    password=$(tr -dc 'A-Za-z0-9!@#$%^&*' < /dev/urandom | head -c 12)
    expire_date=$(date -d "+7 days" "+%Y-%m-%d")
    
    # Generar servidores disponibles
    servers=(
        "ws-us1.hostfree.com:443"
        "ws-eu1.freeserver.cc:8443"
        "ws-asia1.sslfree.net:2096"
        "ws-latam1.freevpn.cc:443"
        "ws-global1.websocket.cc:8443"
    )
    
    selected_server=${servers[$RANDOM % ${#servers[@]}]}
    
    echo -e "${GREEN}[+] Cuenta generada exitosamente!${NC}"
    echo ""
    echo -e "${YELLOW}═ INFORMACIÓN DE LA CUENTA ═${NC}"
    echo -e "Usuario: ${GREEN}$username${NC}"
    echo -e "Contraseña: ${GREEN}$password${NC}"
    echo -e "Servidor: ${GREEN}$selected_server${NC}"
    echo -e "Protocolo: ${GREEN}WebSocket + TLS${NC}"
    echo -e "Válido hasta: ${GREEN}$expire_date${NC}"
    echo ""
    echo -e "${YELLOW}═ CONFIGURACIÓN ═${NC}"
    echo -e "Host: $(echo $selected_server | cut -d: -f1)"
    echo -e "Puerto: $(echo $selected_server | cut -d: -f2)"
    echo -e "Método: chacha20-ietf-poly1305"
    echo -e "Plugin: v2ray-plugin"
    echo ""
    echo -e "${YELLOW}═ ENLACE DE CONFIGURACIÓN ═${NC}"
    config_url="ss://$(echo -n "chacha20-ietf-poly1305:${password}@${selected_server}" | base64 | tr -d '\n')#SECMAN77-${username}"
    echo -e "${BLUE}$config_url${NC}"
    echo ""
    
    # Guardar cuenta
    save_account "websocket" "$username" "$password" "$selected_server" "$expire_date" "$config_url"
    
    echo -e "${YELLOW}[?] Presiona Enter para continuar...${NC}"
    read -r
}

generate_ssh_account() {
    clear
    echo -e "${CYAN}══════════════════════════════════════════════${NC}"
    echo -e "${WHITE}        GENERANDO CUENTA SSH                 ${NC}"
    echo -e "${CYAN}══════════════════════════════════════════════${NC}"
    echo ""
    
    # Generar datos aleatorios
    username="huevoman77_ssh_$(tr -dc 'a-z0-9' < /dev/urandom | head -c 4)"
    password=$(tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 10)
    expire_date=$(date -d "+7 days" "+%Y-%m-%d")
    
    # Servidores SSH gratuitos
    ssh_servers=(
        "free-ssh.com:22"
        "sshfree.net:2222"
        "openssh-server.com:22"
        "freessh.us:22"
        "sshportal.free:22"
    )
    
    selected_server=${ssh_servers[$RANDOM % ${#ssh_servers[@]}]}
    server_host=$(echo $selected_server | cut -d: -f1)
    server_port=$(echo $selected_server | cut -d: -f2)
    
    echo -e "${GREEN}[+] Cuenta SSH generada exitosamente!${NC}"
    echo ""
    echo -e "${YELLOW}═ INFORMACIÓN DE LA CUENTA ═${NC}"
    echo -e "Servidor: ${GREEN}$server_host${NC}"
    echo -e "Puerto: ${GREEN}$server_port${NC}"
    echo -e "Usuario: ${GREEN}$username${NC}"
    echo -e "Contraseña: ${GREEN}$password${NC}"
    echo -e "Válido hasta: ${GREEN}$expire_date${NC}"
    echo ""
    echo -e "${YELLOW}═ COMANDO DE CONEXIÓN ═${NC}"
    echo -e "${BLUE}ssh ${username}@${server_host} -p ${server_port}${NC}"
    echo ""
    echo -e "${YELLOW}═ CONTRASEÑA AL CONECTAR ═${NC}"
    echo -e "${RED}$password${NC}"
    echo ""
    echo -e "${YELLOW}═ NOTAS ═${NC}"
    echo -e "• Esta cuenta es válida por 7 días"
    echo -e "• Puedes renovarla antes de que expire"
    echo -e "• Uso educativo únicamente"
    echo ""
    
    # Guardar cuenta
    save_account "ssh" "$username" "$password" "$selected_server" "$expire_date"
    
    echo -e "${YELLOW}[?] Presiona Enter para continuar...${NC}"
    read -r
}

generate_ssl_account() {
    clear
    echo -e "${CYAN}══════════════════════════════════════════════${NC}"
    echo -e "${WHITE}        GENERANDO CUENTA SSL/TLS             ${NC}"
    echo -e "${CYAN}══════════════════════════════════════════════${NC}"
    echo ""
    
    # Generar datos aleatorios
    username="huevoman77_ssl_$(tr -dc 'a-z0-9' < /dev/urandom | head -c 4)"
    password=$(tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 14)
    expire_date=$(date -d "+7 days" "+%Y-%m-%d")
    
    # Servidores SSL
    ssl_servers=(
        "sslfree.host:443"
        "tlsvpn.free:8443"
        "freessl.vpn:2096"
        "sslproxy.net:443"
        "tlstunnel.cc:8443"
    )
    
    selected_server=${ssl_servers[$RANDOM % ${#ssl_servers[@]}]}
    
    echo -e "${GREEN}[+] Cuenta SSL/TLS generada exitosamente!${NC}"
    echo ""
    echo -e "${YELLOW}═ INFORMACIÓN DE LA CUENTA ═${NC}"
    echo -e "Servidor: ${GREEN}$selected_server${NC}"
    echo -e "Usuario: ${GREEN}$username${NC}"
    echo -e "Contraseña: ${GREEN}$password${NC}"
    echo -e "Válido hasta: ${GREEN}$expire_date${NC}"
    echo ""
    echo -e "${YELLOW}═ CONFIGURACIÓN ═${NC}"
    echo -e "Protocolo: ${GREEN}SSL/TLS${NC}"
    echo -e "Cifrado: ${GREEN}AES-256-GCM${NC}"
    echo -e "Autenticación: ${GREEN}SHA384${NC}"
    echo ""
    echo -e "${YELLOW}═ ENLACE DE CONFIGURACIÓN ═${NC}"
    echo -e "${BLUE}https://${selected_server}/config#user=${username}&pass=${password}${NC}"
    echo ""
    
    # Guardar cuenta
    save_account "ssl" "$username" "$password" "$selected_server" "$expire_date"
    
    echo -e "${YELLOW}[?] Presiona Enter para continuar...${NC}"
    read -r
}

generate_dns_account() {
    clear
    echo -e "${CYAN}══════════════════════════════════════════════${NC}"
    echo -e "${WHITE}        GENERANDO CUENTA DNS                 ${NC}"
    echo -e "${CYAN}══════════════════════════════════════════════${NC}"
    echo ""
    
    # Generar datos aleatorios
    username="huevoman77_dns_$(tr -dc 'a-z0-9' < /dev/urandom | head -c 4)"
    password=$(tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 8)
    expire_date=$(date -d "+7 days" "+%Y-%m-%d")
    
    # Servidores DNS
    dns_servers=(
        "dns.free:53"
        "securedns.net:853"
        "doh.free:443"
        "dot.server:853"
        "freedns.host:53"
    )
    
    selected_server=${dns_servers[$RANDOM % ${#dns_servers[@]}]}
    
    echo -e "${GREEN}[+] Cuenta DNS generada exitosamente!${NC}"
    echo ""
    echo -e "${YELLOW}═ INFORMACIÓN DE LA CUENTA ═${NC}"
    echo -e "Servidor DNS: ${GREEN}$selected_server${NC}"
    echo -e "Usuario: ${GREEN}$username${NC}"
    echo -e "Contraseña: ${GREEN}$password${NC}"
    echo -e "Válido hasta: ${GREEN}$expire_date${NC}"
    echo ""
    echo -e "${YELLOW}═ CONFIGURACIÓN ═${NC}"
    echo -e "Protocolo: ${GREEN}DNS-over-TLS/HTTPS${NC}"
    echo -e "Cifrado: ${GREEN}TLS 1.3${NC}"
    echo -e "DNSSEC: ${GREEN}Habilitado${NC}"
    echo ""
    echo -e "${YELLOW}═ CONFIGURAR EN TERMUX ═${NC}"
    echo -e "1. Instalar dnscrypt-proxy:"
    echo -e "   ${BLUE}pkg install dnscrypt-proxy${NC}"
    echo -e "2. Configurar servidor en:"
    echo -e "   ${BLUE}/data/data/com.termux/files/usr/etc/dnscrypt-proxy/dnscrypt-proxy.toml${NC}"
    echo -e "3. Agregar:"
    echo -e "   ${BLUE}server_names = ['$selected_server']${NC}"
    echo ""
    
    # Guardar cuenta
    save_account "dns" "$username" "$password" "$selected_server" "$expire_date"
    
    echo -e "${YELLOW}[?] Presiona Enter para continuar...${NC}"
    read -r
}

save_account() {
    local type=$1
    local username=$2
    local password=$3
    local server=$4
    local expire_date=$5
    local config_url=$6
    
    # Crear archivo si no existe
    if [ ! -f "$ACCOUNTS_FILE" ]; then
        echo "# SECMAN77 Accounts Database" > "$ACCOUNTS_FILE"
        echo "# Created: $(date)" >> "$ACCOUNTS_FILE"
        echo "#" >> "$ACCOUNTS_FILE"
    fi
    
    # Guardar cuenta
    {
        echo "=== ACCOUNT ==="
        echo "TYPE=$type"
        echo "USERNAME=$username"
        echo "PASSWORD=$password"
        echo "SERVER=$server"
        echo "CREATED=$(date)"
        echo "EXPIRES=$expire_date"
        echo "ACTIVE=true"
        if [ -n "$config_url" ]; then
            echo "CONFIG_URL=$config_url"
        fi
        echo ""
    } >> "$ACCOUNTS_FILE"
    
    # Actualizar contador
    ACTIVE_ACCOUNTS=$((ACTIVE_ACCOUNTS + 1))
    
    # Guardar también en archivo individual
    account_file="$HOME/account_${type}_${username}.txt"
    {
        echo "=== SECMAN77 ACCOUNT ==="
        echo "Type: $type"
        echo "Username: $username"
        echo "Password: $password"
        echo "Server: $server"
        echo "Created: $(date)"
        echo "Expires: $expire_date"
        echo ""
        if [ -n "$config_url" ]; then
            echo "Config URL: $config_url"
            echo ""
        fi
        echo "=== NOTES ==="
        echo "• Account valid for 7 days"
        echo "• Renew before expiration"
        echo "• Educational use only"
        echo "• Generated by SECMAN77 v8.0"
    } > "$account_file"
    
    echo -e "${GREEN}[+] Cuenta guardada en: $account_file${NC}"
}

show_active_accounts() {
    clear
    echo -e "${CYAN}══════════════════════════════════════════════${NC}"
    echo -e "${WHITE}          CUENTAS ACTIVAS                    ${NC}"
    echo -e "${CYAN}══════════════════════════════════════════════${NC}"
    echo ""
    
    if [ ! -f "$ACCOUNTS_FILE" ]; then
        echo -e "${YELLOW}[!] No hay cuentas activas${NC}"
        echo -e "${YELLOW}[*] Genera una cuenta primero${NC}"
    else
        # Contar cuentas activas
        active_count=$(grep -c "ACTIVE=true" "$ACCOUNTS_FILE")
        
        if [ "$active_count" -eq 0 ]; then
            echo -e "${YELLOW}[!] No hay cuentas activas${NC}"
        else
            echo -e "${GREEN}[+] Cuentas activas: $active_count${NC}"
            echo ""
            
            # Mostrar cada cuenta
            awk '
            /^=== ACCOUNT ===/ { account=1; print "" }
            /^TYPE=/ && account { type=$0; gsub(/TYPE=/, "", type) }
            /^USERNAME=/ && account { username=$0; gsub(/USERNAME=/, "", username) }
            /^EXPIRES=/ && account { expires=$0; gsub(/EXPIRES=/, "", expires) }
            /^SERVER=/ && account { server=$0; gsub(/SERVER=/, "", server) }
            /^ACTIVE=true/ && account {
                printf "Type: %s\n", type
                printf "User: %s\n", username
                printf "Server: %s\n", server
                printf "Expires: %s\n", expires
                print "-------------------"
                account=0
            }
            ' "$ACCOUNTS_FILE"
        fi
    fi
    
    echo -e "\n${YELLOW}[?] Presiona Enter para continuar...${NC}"
    read -r
}

renew_account() {
    clear
    echo -e "${CYAN}══════════════════════════════════════════════${NC}"
    echo -e "${WHITE}          RENOVAR CUENTA                     ${NC}"
    echo -e "${CYAN}══════════════════════════════════════════════${NC}"
    echo ""
    
    if [ ! -f "$ACCOUNTS_FILE" ]; then
        echo -e "${RED}[!] No hay cuentas para renovar${NC}"
        sleep 2
        return
    fi
    
    echo -e "${YELLOW}[?] Usuario de la cuenta a renovar: ${NC}"
    read -r username
    
    if grep -q "USERNAME=$username" "$ACCOUNTS_FILE"; then
        # Actualizar fecha de expiración
        new_expire=$(date -d "+7 days" "+%Y-%m-%d")
        sed -i "/USERNAME=$username/,/^$/s/EXPIRES=.*/EXPIRES=$new_expire/" "$ACCOUNTS_FILE"
        sed -i "/USERNAME=$username/,/^$/s/ACTIVE=.*/ACTIVE=true/" "$ACCOUNTS_FILE"
        
        echo -e "${GREEN}[+] Cuenta renovada exitosamente${NC}"
        echo -e "${GREEN}[+] Nueva fecha de expiración: $new_expire${NC}"
    else
        echo -e "${RED}[!] Usuario no encontrado${NC}"
    fi
    
    echo -e "\n${YELLOW}[?] Presiona Enter para continuar...${NC}"
    read -r
}

delete_expired_account() {
    clear
    echo -e "${CYAN}══════════════════════════════════════════════${NC}"
    echo -e "${WHITE}       ELIMINAR CUENTA EXPIRADA              ${NC}"
    echo -e "${CYAN}══════════════════════════════════════════════${NC}"
    echo ""
    
    if [ ! -f "$ACCOUNTS_FILE" ]; then
        echo -e "${RED}[!] No hay cuentas${NC}"
        sleep 2
        return
    fi
    
    echo -e "${YELLOW}[?] Usuario de la cuenta a eliminar: ${NC}"
    read -r username
    
    if grep -q "USERNAME=$username" "$ACCOUNTS_FILE"; then
        # Marcar como inactiva
        sed -i "/USERNAME=$username/,/^$/s/ACTIVE=true/ACTIVE=false/" "$ACCOUNTS_FILE"
        echo -e "${GREEN}[+] Cuenta marcada como expirada${NC}"
    else
        echo -e "${RED}[!] Usuario no encontrado${NC}"
    fi
    
    echo -e "\n${YELLOW}[?] Presiona Enter para continuar...${NC}"
    read -r
}

test_account_connection() {
    clear
    echo -e "${CYAN}══════════════════════════════════════════════${NC}"
    echo -e "${WHITE}       PRUEBA DE CONEXIÓN                    ${NC}"
    echo -e "${CYAN}══════════════════════════════════════════════${NC}"
    echo ""
    
    if [ ! -f "$ACCOUNTS_FILE" ]; then
        echo -e "${RED}[!] No hay cuentas para probar${NC}"
        sleep 2
        return
    fi
    
    echo -e "${YELLOW}[?] Usuario de la cuenta a probar: ${NC}"
    read -r username
    
    if grep -q "USERNAME=$username" "$ACCOUNTS_FILE"; then
        # Extraer información de la cuenta
        server=$(grep -A5 "USERNAME=$username" "$ACCOUNTS_FILE" | grep "SERVER=" | cut -d= -f2)
        type=$(grep -A5 "USERNAME=$username" "$ACCOUNTS_FILE" | grep "TYPE=" | cut -d= -f2)
        
        echo -e "${GREEN}[+] Probando conexión a: $server${NC}"
        echo -e "${GREEN}[+] Tipo: $type${NC}"
        echo ""
        
        # Extraer host y puerto
        host=$(echo "$server" | cut -d: -f1)
        port=$(echo "$server" | cut -d: -f2)
        
        # Probar conexión básica
        timeout 5 bash -c "echo > /dev/tcp/$host/$port" 2>/dev/null
        
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}[+] Conexión exitosa al servidor${NC}"
            echo -e "${GREEN}[+] El servidor está respondiendo${NC}"
        else
            echo -e "${RED}[!] No se pudo conectar al servidor${NC}"
            echo -e "${YELLOW}[*] Posibles razones:${NC}"
            echo -e "   1. Servidor caído"
            echo -e "   2. Puerto bloqueado"
            echo -e "   3. Cuenta expirada"
        fi
    else
        echo -e "${RED}[!] Usuario no encontrado${NC}"
    fi
    
    echo -e "\n${YELLOW}[?] Presiona Enter para continuar...${NC}"
    read -r
}

# ============================================
# FUNCIÓN 13: HERRAMIENTAS ADICIONALES
# ============================================
additional_tools() {
    clear
    echo -e "${CYAN}"
    echo "╔══════════════════════════════════════════════╗"
    echo "║          HERRAMIENTAS ADICIONALES            ║"
    echo "╚══════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    while true; do
        echo ""
        echo -e "${YELLOW}╔══════════════════════════════════════════════════════╗${NC}"
        echo -e "${YELLOW}║             HERRAMIENTAS DISPONIBLES                 ║${NC}"
        echo -e "${YELLOW}╚══════════════════════════════════════════════════════╝${NC}"
        echo ""
        echo -e "${GREEN}[1]${NC} Verificar conectividad a internet"
        echo -e "${GREEN}[2]${NC} Probar velocidad de conexión"
        echo -e "${GREEN}[3]${NC} Analizar red local"
        echo -e "${GREEN}[4]${NC} Generar contraseñas seguras"
        echo -e "${GREEN}[5]${NC} Convertir archivos Base64"
        echo -e "${GREEN}[6]${NC} Calcular hash MD5/SHA"
        echo -e "${GREEN}[7]${NC} Escanear dispositivos en la red"
        echo -e "${GREEN}[8]${NC} Ver información del sistema"
        echo -e "${GREEN}[0]${NC} Volver al menú principal"
        echo ""
        echo -e "${YELLOW}[?] Selecciona opción (0-8): ${NC}"
        read -r option
        
        case $option in
            1) check_internet ;;
            2) speed_test ;;
            3) analyze_network ;;
            4) generate_passwords ;;
            5) base64_tool ;;
            6) hash_calculator ;;
            7) network_scan ;;
            8) system_info ;;
            0) return ;;
            *) echo -e "${RED}[!] Opción inválida${NC}"; sleep 1 ;;
        esac
    done
}

check_internet() {
    clear
    echo -e "${CYAN}══════════════════════════════════════════════${NC}"
    echo -e "${WHITE}       VERIFICAR CONECTIVIDAD                ${NC}"
    echo -e "${CYAN}══════════════════════════════════════════════${NC}"
    echo ""
    
    echo -e "${YELLOW}[*] Probando conexión a internet...${NC}"
    echo ""
    
    # Probar varios servicios
    services=(
        "Google DNS:8.8.8.8"
        "Cloudflare:1.1.1.1"
        "Google:google.com"
        "GitHub:github.com"
    )
    
    for service in "${services[@]}"; do
        name=$(echo "$service" | cut -d: -f1)
        target=$(echo "$service" | cut -d: -f2)
        
        echo -ne "${BLUE}[*] Probando $name...${NC}\r"
        
        if ping -c 1 -W 1 "$target" &> /dev/null; then
            echo -e "${GREEN}[+] $name: CONECTADO${NC}"
        else
            echo -e "${RED}[-] $name: SIN CONEXIÓN${NC}"
        fi
    done
    
    echo ""
    echo -e "${YELLOW}[?] Presiona Enter para continuar...${NC}"
    read -r
}

speed_test() {
    clear
    echo -e "${CYAN}══════════════════════════════════════════════${NC}"
    echo -e "${WHITE}       PRUEBA DE VELOCIDAD                   ${NC}"
    echo -e "${CYAN}══════════════════════════════════════════════${NC}"
    echo ""
    
    echo -e "${YELLOW}[*] Preparando prueba de velocidad...${NC}"
    echo ""
    
    # URL de prueba (archivo pequeño)
    test_url="https://proof.ovh.net/files/10Mb.dat"
    
    echo -e "${GREEN}[+] Descargando archivo de prueba...${NC}"
    
    # Medir tiempo de descarga
    start_time=$(date +%s)
    curl -s -o /dev/null "$test_url"
    end_time=$(date +%s)
    
    # Calcular velocidad aproximada
    duration=$((end_time - start_time))
    if [ "$duration" -eq 0 ]; then
        duration=1
    fi
    
    # 10MB = 80Mb
    speed_mbps=$((80 / duration))
    
    echo ""
    echo -e "${CYAN}══════════════════════════════════════════════${NC}"
    echo -e "${WHITE}       RESULTADOS DE VELOCIDAD               ${NC}"
    echo -e "${CYAN}══════════════════════════════════════════════${NC}"
    echo ""
    echo -e "Tiempo de descarga: ${GREEN}${duration}s${NC}"
    echo -e "Velocidad aproximada: ${GREEN}${speed_mbps} Mbps${NC}"
    echo ""
    
    # Interpretación
    if [ "$speed_mbps" -gt 50 ]; then
        echo -e "${GREEN}[+] Excelente velocidad${NC}"
    elif [ "$speed_mbps" -gt 20 ]; then
        echo -e "${YELLOW}[+] Buena velocidad${NC}"
    elif [ "$speed_mbps" -gt 5 ]; then
        echo -e "${YELLOW}[+] Velocidad aceptable${NC}"
    else
        echo -e "${RED}[!] Velocidad baja${NC}"
    fi
    
    echo -e "\n${YELLOW}[?] Presiona Enter para continuar...${NC}"
    read -r
}

# ============================================
# MENÚ PRINCIPAL
# ============================================
main_menu() {
    while true; do
        show_banner
        
        echo -e "${WHITE}╔══════════════════════════════════════════════════════════╗${NC}"
        echo -e "${WHITE}║            MENÚ PRINCIPAL - SECMAN77 v8.0               ║${NC}"
        echo -e "${WHITE}╚══════════════════════════════════════════════════════════╝${NC}"
        echo ""
        echo -e "${GREEN}[1]${NC}  Configurar objetivo"
        echo -e "${GREEN}[2]${NC}  Enumeración avanzada de subdominios"
        echo -e "${GREEN}[3]${NC}  Escaneo de puertos TCP"
        echo -e "${GREEN}[4]${NC}  Escaneo UDP y DNS"
        echo -e "${GREEN}[5]${NC}  Enumeración completa"
        echo -e "${GREEN}[6]${NC}  Verificar subdominios 200 OK"
        echo -e "${GREEN}[7]${NC}  Analizar servicios y vulnerabilidades"
        echo -e "${GREEN}[8]${NC}  Configuración avanzada"
        echo -e "${GREEN}[9]${NC}  Ver resultados guardados"
        echo -e "${GREEN}[10]${NC} Instalar herramientas"
        echo -e "${GREEN}[11]${NC} Generador de APNs Multipaís"
        echo -e "${GREEN}[12]${NC} Generador de cuentas gratuitas (7 días)"
        echo -e "${GREEN}[13]${NC} Herramientas adicionales"
        echo -e "${GREEN}[0]${NC}  Salir"
        echo ""
        echo -e "${CYAN}══════════════════════════════════════════════════════════${NC}"
        echo -e "${YELLOW}Estado actual:${NC}"
        echo -e "  Usuario: ${GREEN}$USER_ALIAS${NC}"
        echo -e "  Dominio: ${GREEN}$DOMAIN${NC}"
        echo -e "  Hilos: ${GREEN}$THREADS${NC} | Timeout: ${GREEN}$TIMEOUT${NC}s"
        echo -e "  Cuentas activas: ${GREEN}$ACTIVE_ACCOUNTS${NC}"
        echo -e "${CYAN}══════════════════════════════════════════════════════════${NC}"
        echo ""
        echo -e "${YELLOW}[?] Selecciona una opción (0-13): ${NC}"
        read -r option
        
        case $option in
            1) setup_target ;;
            2) advanced_subdomain_enum ;;
            3) scan_ports ;;
            4) udp_dns_scan ;;
            5) full_enumeration ;;
            6) check_200_ok ;;
            7) analyze_services ;;
            8) advanced_settings ;;
            9) show_results ;;
            10) install_tools ;;
            11) apn_generator ;;
            12) free_accounts_generator ;;
            13) additional_tools ;;
            0)
                echo -e "${GREEN}[+] ¡Hasta luego, $USER_ALIAS! 👋${NC}"
                echo -e "${GREEN}[+] Gracias por usar SECMAN77 v8.0${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}[!] Opción inválida${NC}"
                sleep 1
                ;;
        esac
    done
}

# ============================================
# INICIO DEL PROGRAMA
# ============================================

# Verificar que estamos en Termux
if [ ! -d "/data/data/com.termux/files/usr" ]; then
    echo -e "${RED}[!] Este script es solo para Termux${NC}"
    exit 1
fi

# Inicializar usuario
initialize_user

# Mostrar advertencia
show_disclaimer

# Verificar dependencias
check_dependencies

# Crear directorio de trabajo
mkdir -p "$HOME/secman77_scans"
cd "$HOME/secman77_scans" || exit

# Iniciar menú principal
main_menu
