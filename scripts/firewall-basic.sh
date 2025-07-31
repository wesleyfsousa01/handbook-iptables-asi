#!/bin/bash

# Script de Configuração Básica de Firewall com iptables
# Autor: Grupo ASI - IFG Câmpus Formosa
# Data: 2024
# Versão: 2.0 - Atualizada com correções e melhorias

echo "=== Configuração Básica de Firewall ==="
echo "Este script configura regras básicas de firewall"
echo "ATENÇÃO: Execute apenas em ambiente de teste primeiro!"
echo ""

# Verificar se está rodando como root
if [ "$EUID" -ne 0 ]; then
    echo "ERRO: Este script deve ser executado como root (sudo)"
    exit 1
fi

# Verificar se iptables está disponível
if ! command -v iptables >/dev/null 2>&1; then
    echo "ERRO: iptables não está instalado"
    echo "Execute: sudo apt install iptables iptables-persistent"
    exit 1
fi

# Verificar qual versão do iptables está sendo usada
echo "Verificando versão do iptables..."
iptables_version=$(iptables --version 2>&1)
echo "Versão detectada: $iptables_version"

# Backup das regras atuais
echo "Fazendo backup das regras atuais..."
backup_dir="/backup"
mkdir -p "$backup_dir"
iptables-save > "$backup_dir/iptables_backup_$(date +%Y%m%d_%H%M%S).bak"
echo "Backup salvo em: $backup_dir/iptables_backup_$(date +%Y%m%d_%H%M%S).bak"

echo "Iniciando configuração do firewall..."

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

# Permitir conexões estabelecidas e relacionadas (essencial para o retorno de pacotes)
# ESTABLISHED: pacotes que fazem parte de uma conexão existente
# RELATED: pacotes de novas conexões que estão relacionadas a uma existente (ex: FTP)
echo "4. Permitindo conexões estabelecidas..."
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# Permitir SSH (porta 22)
echo "5. Configurando acesso SSH..."
iptables -A INPUT -p tcp --dport 22 -j ACCEPT

# Permitir HTTP (porta 80)
echo "6. Configurando acesso HTTP..."
iptables -A INPUT -p tcp --dport 80 -j ACCEPT

# Permitir HTTPS (porta 443)
echo "7. Configurando acesso HTTPS..."
iptables -A INPUT -p tcp --dport 443 -j ACCEPT

# Permitir ping (ICMP)
echo "8. Configurando ICMP..."
iptables -A INPUT -p icmp -j ACCEPT

# Proteção básica contra ataques
echo "9. Configurando proteções básicas..."

# Proteção contra SYN flood
iptables -A INPUT -p tcp --syn -m limit --limit 1/s --limit-burst 3 -j ACCEPT

# Proteção contra port scanning
iptables -A INPUT -p tcp --tcp-flags ALL NONE -j DROP
iptables -A INPUT -p tcp --tcp-flags ALL ALL -j DROP

# Proteção contra ataques de força bruta SSH (versão corrigida)
echo "10. Configurando proteção contra força bruta SSH..."
# Criar uma regra para adicionar IPs que tentam novas conexões SSH a uma lista "recent"
iptables -A INPUT -p tcp --dport 22 -m conntrack --ctstate NEW -m recent --set --name SSH --rsource

# Bloquear IPs que aparecem na lista mais de 4 vezes em 60 segundos
iptables -A INPUT -p tcp --dport 22 -m conntrack --ctstate NEW -m recent --update --seconds 60 --hitcount 4 --name SSH --rsource -j DROP

# Log de tentativas de conexão SSH
iptables -A INPUT -p tcp --dport 22 -j LOG --log-prefix "SSH_ATTEMPT: "

# Adicionar logging para debugging (útil para diagnosticar regras)
echo "11. Configurando logging para debugging..."
iptables -A INPUT -j LOG --log-prefix "PACOTE DESCARTADO: "

# Salvar configurações
echo "12. Salvando configurações..."
if command -v iptables-save >/dev/null 2>&1; then
    mkdir -p /etc/iptables
    iptables-save > /etc/iptables/rules.v4
    echo "Configurações salvas em /etc/iptables/rules.v4"
else
    echo "AVISO: iptables-save não encontrado. Configurações não foram salvas permanentemente."
fi

echo ""
echo "=== Configuração Concluída ==="
echo "Regras atuais:"
iptables -L -v -n

echo ""
echo "=== Informações Adicionais ==="
echo "Para verificar interfaces de rede disponíveis:"
echo "  ip a"
echo ""
echo "Para verificar conexões ativas (recomendado):"
echo "  ss -tuln"
echo ""
echo "Para monitorar logs em tempo real:"
echo "  tail -f /var/log/syslog | grep iptables"
echo ""
echo "=== Testes Recomendados ==="
echo "1. Teste o acesso SSH: ssh usuario@servidor"
echo "2. Teste o acesso web: curl http://localhost"
echo "3. Teste ping: ping 8.8.8.8"
echo ""
echo "=== Comandos Úteis ==="
echo "Para restaurar backup se necessário:"
echo "  iptables-restore < $backup_dir/iptables_backup_YYYYMMDD_HHMMSS.bak"
echo ""
echo "Para verificar se regras estão funcionando:"
echo "  iptables -L -v -n --line-numbers"
echo ""
echo "Para testar uma regra específica:"
echo "  iptables -C INPUT -p tcp --dport 80 -j ACCEPT" 