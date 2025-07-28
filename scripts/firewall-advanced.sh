#!/bin/bash

# Script de Configuração Avançada de Firewall com iptables
# Autor: Grupo ASI - IFG Câmpus Formosa
# Data: 2024

echo "=== Configuração Avançada de Firewall ==="
echo "Este script configura regras avançadas de firewall"
echo "ATENÇÃO: Execute apenas em ambiente de teste primeiro!"
echo ""

# Verificar se está rodando como root
if [ "$EUID" -ne 0 ]; then
    echo "ERRO: Este script deve ser executado como root (sudo)"
    exit 1
fi

# Backup das regras atuais
echo "Fazendo backup das regras atuais..."
iptables-save > /backup/iptables_advanced_backup_$(date +%Y%m%d_%H%M%S).bak 2>/dev/null || mkdir -p /backup && iptables-save > /backup/iptables_advanced_backup_$(date +%Y%m%d_%H%M%S).bak

echo "Iniciando configuração avançada do firewall..."

# Limpar todas as regras existentes
echo "1. Limpando regras existentes..."
iptables -F
iptables -X
iptables -t nat -F
iptables -t nat -X
iptables -t mangle -F
iptables -t mangle -X

# Definir políticas padrão
echo "2. Definindo políticas padrão..."
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

# Permitir tráfego local
echo "3. Configurando tráfego local..."
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# Permitir conexões estabelecidas
echo "4. Permitindo conexões estabelecidas..."
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# Configuração de NAT (se necessário)
echo "5. Configurando NAT..."
# Descomente a linha abaixo se este servidor for um gateway
# iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

# Proteção contra ataques avançados
echo "6. Configurando proteções avançadas..."

# Proteção contra ataques de força bruta SSH
iptables -A INPUT -p tcp --dport 22 -m recent --name SSH --set
iptables -A INPUT -p tcp --dport 22 -m recent --name SSH --update --seconds 60 --hitcount 4 -j DROP

# Proteção contra SYN flood
iptables -A INPUT -p tcp --syn -m limit --limit 1/s --limit-burst 3 -j ACCEPT

# Proteção contra port scanning
iptables -A INPUT -p tcp --tcp-flags ALL NONE -j DROP
iptables -A INPUT -p tcp --tcp-flags ALL ALL -j DROP

# Proteção contra ataques de fragmentação
iptables -A INPUT -f -j DROP

# Proteção contra ataques de spoofing
iptables -A INPUT -s 10.0.0.0/8 -j DROP
iptables -A INPUT -s 172.16.0.0/12 -j DROP
iptables -A INPUT -s 192.168.0.0/16 -j DROP
iptables -A INPUT -s 224.0.0.0/4 -j DROP
iptables -A INPUT -s 240.0.0.0/5 -j DROP
iptables -A INPUT -s 127.0.0.0/8 -j DROP

# Permitir acesso SSH com rate limiting
echo "7. Configurando acesso SSH com rate limiting..."
iptables -A INPUT -p tcp --dport 22 -m limit --limit 5/minute --limit-burst 10 -j ACCEPT

# Permitir acesso HTTP/HTTPS
echo "8. Configurando acesso web..."
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -j ACCEPT

# Permitir DNS (se necessário)
echo "9. Configurando DNS..."
iptables -A INPUT -p udp --dport 53 -j ACCEPT
iptables -A INPUT -p tcp --dport 53 -j ACCEPT

# Permitir NTP (sincronização de tempo)
echo "10. Configurando NTP..."
iptables -A INPUT -p udp --dport 123 -j ACCEPT

# Permitir ping com rate limiting
echo "11. Configurando ICMP com rate limiting..."
iptables -A INPUT -p icmp -m limit --limit 1/s --limit-burst 4 -j ACCEPT

# Configuração de logging avançado
echo "12. Configurando logging avançado..."

# Log de tentativas de conexão SSH
iptables -A INPUT -p tcp --dport 22 -j LOG --log-prefix "SSH_ATTEMPT: "

# Log de tentativas de acesso a portas fechadas
iptables -A INPUT -j LOG --log-prefix "DROP: "

# Configuração de port forwarding (exemplo)
echo "13. Configurando port forwarding..."
# Descomente e ajuste conforme necessário
# iptables -t nat -A PREROUTING -p tcp --dport 8080 -j DNAT --to-dest 192.168.1.100:80
# iptables -A FORWARD -p tcp --dport 80 -d 192.168.1.100 -j ACCEPT

# Configuração de balanceamento de carga (exemplo)
echo "14. Configurando balanceamento de carga..."
# Descomente e ajuste conforme necessário
# iptables -t nat -A PREROUTING -p tcp --dport 80 -m statistic --mode nth --every 2 --packet 0 -j DNAT --to-dest 192.168.1.10:80
# iptables -t nat -A PREROUTING -p tcp --dport 80 -j DNAT --to-dest 192.168.1.11:80

# Salvar configurações
echo "15. Salvando configurações..."
if command -v iptables-save >/dev/null 2>&1; then
    iptables-save > /etc/iptables/rules.v4 2>/dev/null || mkdir -p /etc/iptables && iptables-save > /etc/iptables/rules.v4
    echo "Configurações salvas em /etc/iptables/rules.v4"
else
    echo "AVISO: iptables-save não encontrado. Configurações não foram salvas permanentemente."
fi

# Configurar persistência
echo "16. Configurando persistência..."
if command -v netfilter-persistent >/dev/null 2>&1; then
    netfilter-persistent save
    echo "Configurações salvas com netfilter-persistent"
elif command -v iptables-save >/dev/null 2>&1; then
    echo "Para persistência manual, adicione ao /etc/rc.local:"
    echo "iptables-restore < /etc/iptables/rules.v4"
fi

echo ""
echo "=== Configuração Avançada Concluída ==="
echo "Regras atuais:"
iptables -L -v -n

echo ""
echo "=== Estatísticas ==="
echo "Regras por tabela:"
iptables -L -v -n | grep -E "^Chain|^pkts"

echo ""
echo "Para monitoramento contínuo:"
echo "1. tail -f /var/log/syslog | grep iptables"
echo "2. watch -n 1 'iptables -L -v -n'"
echo "3. iptables -L -v -n --line-numbers"

echo ""
echo "Para restaurar backup se necessário:"
echo "iptables-restore < /backup/iptables_advanced_backup_YYYYMMDD_HHMMSS.bak" 