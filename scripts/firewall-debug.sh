#!/bin/bash

# Script de Debugging e Verificação de Firewall
# Autor: Grupo ASI - IFG Câmpus Formosa
# Data: 2024
# Versão: 1.0

echo "=== Ferramentas de Debugging do Firewall ==="
echo "Este script fornece ferramentas para diagnosticar problemas do firewall"
echo ""

# Verificar se está rodando como root
if [ "$EUID" -ne 0 ]; then
    echo "ERRO: Este script deve ser executado como root (sudo)"
    exit 1
fi

# Função para mostrar menu
show_menu() {
    echo ""
    echo "Escolha uma opção:"
    echo "1) Verificar status do iptables"
    echo "2) Listar todas as regras com estatísticas"
    echo "3) Verificar interfaces de rede"
    echo "4) Monitorar logs em tempo real"
    echo "5) Testar conectividade de portas"
    echo "6) Verificar conexões ativas"
    echo "7) Analisar regras por cadeia"
    echo "8) Verificar módulos carregados"
    echo "9) Testar regras específicas"
    echo "10) Backup das regras atuais"
    echo "0) Sair"
    echo ""
    read -p "Opção: " choice
}

# Função para verificar status
check_status() {
    echo "=== Status do iptables ==="
    echo "Versão:"
    iptables --version
    echo ""
    echo "Políticas padrão:"
    iptables -L | grep "Chain" | grep -E "(INPUT|OUTPUT|FORWARD)"
    echo ""
    echo "Número de regras por cadeia:"
    iptables -L INPUT -n | wc -l
    echo "Regras na cadeia INPUT: $(( $(iptables -L INPUT -n | wc -l) - 2 ))"
    iptables -L OUTPUT -n | wc -l
    echo "Regras na cadeia OUTPUT: $(( $(iptables -L OUTPUT -n | wc -l) - 2 ))"
    iptables -L FORWARD -n | wc -l
    echo "Regras na cadeia FORWARD: $(( $(iptables -L FORWARD -n | wc -l) - 2 ))"
}

# Função para listar regras
list_rules() {
    echo "=== Regras do Firewall ==="
    echo "Cadeia INPUT:"
    iptables -L INPUT -v -n --line-numbers
    echo ""
    echo "Cadeia OUTPUT:"
    iptables -L OUTPUT -v -n --line-numbers
    echo ""
    echo "Cadeia FORWARD:"
    iptables -L FORWARD -v -n --line-numbers
}

# Função para verificar interfaces
check_interfaces() {
    echo "=== Interfaces de Rede ==="
    echo "Interfaces disponíveis:"
    ip a | grep -E "^[0-9]+:" | awk '{print $2}' | sed 's/://'
    echo ""
    echo "Detalhes das interfaces:"
    ip a
}

# Função para monitorar logs
monitor_logs() {
    echo "=== Monitoramento de Logs ==="
    echo "Pressione Ctrl+C para parar o monitoramento"
    echo "Logs do iptables em tempo real:"
    tail -f /var/log/syslog | grep iptables
}

# Função para testar conectividade
test_connectivity() {
    echo "=== Teste de Conectividade ==="
    echo "Testando portas comuns..."
    
    # Testar SSH
    if nc -z localhost 22 2>/dev/null; then
        echo "✓ Porta 22 (SSH): ABERTA"
    else
        echo "✗ Porta 22 (SSH): FECHADA"
    fi
    
    # Testar HTTP
    if nc -z localhost 80 2>/dev/null; then
        echo "✓ Porta 80 (HTTP): ABERTA"
    else
        echo "✗ Porta 80 (HTTP): FECHADA"
    fi
    
    # Testar HTTPS
    if nc -z localhost 443 2>/dev/null; then
        echo "✓ Porta 443 (HTTPS): ABERTA"
    else
        echo "✗ Porta 443 (HTTPS): FECHADA"
    fi
    
    echo ""
    echo "Teste de conectividade externa:"
    if ping -c 1 8.8.8.8 >/dev/null 2>&1; then
        echo "✓ Conectividade externa: OK"
    else
        echo "✗ Conectividade externa: FALHOU"
    fi
}

# Função para verificar conexões ativas
check_connections() {
    echo "=== Conexões Ativas ==="
    echo "Conexões TCP:"
    ss -tuln
    echo ""
    echo "Conexões estabelecidas:"
    ss -tuln | grep ESTAB
}

# Função para analisar regras por cadeia
analyze_rules() {
    echo "=== Análise de Regras por Cadeia ==="
    echo "Escolha a cadeia para analisar:"
    echo "1) INPUT"
    echo "2) OUTPUT"
    echo "3) FORWARD"
    read -p "Opção: " chain_choice
    
    case $chain_choice in
        1) chain="INPUT" ;;
        2) chain="OUTPUT" ;;
        3) chain="FORWARD" ;;
        *) echo "Opção inválida"; return ;;
    esac
    
    echo "=== Análise da cadeia $chain ==="
    iptables -L $chain -v -n --line-numbers
    echo ""
    echo "Resumo da cadeia $chain:"
    echo "Total de regras: $(( $(iptables -L $chain -n | wc -l) - 2 ))"
    echo "Política padrão: $(iptables -L $chain | grep "Chain $chain" | awk '{print $4}' | sed 's/(//' | sed 's/)//')"
}

# Função para verificar módulos
check_modules() {
    echo "=== Módulos do Kernel ==="
    echo "Módulos iptables carregados:"
    lsmod | grep iptable
    echo ""
    echo "Módulos netfilter carregados:"
    lsmod | grep nf_
}

# Função para testar regras específicas
test_specific_rules() {
    echo "=== Teste de Regras Específicas ==="
    echo "Testando regras comuns..."
    
    # Testar regra SSH
    if iptables -C INPUT -p tcp --dport 22 -j ACCEPT 2>/dev/null; then
        echo "✓ Regra SSH existe"
    else
        echo "✗ Regra SSH não encontrada"
    fi
    
    # Testar regra HTTP
    if iptables -C INPUT -p tcp --dport 80 -j ACCEPT 2>/dev/null; then
        echo "✓ Regra HTTP existe"
    else
        echo "✗ Regra HTTP não encontrada"
    fi
    
    # Testar regra ESTABLISHED
    if iptables -C INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT 2>/dev/null; then
        echo "✓ Regra ESTABLISHED existe"
    else
        echo "✗ Regra ESTABLISHED não encontrada"
    fi
}

# Função para backup
backup_rules() {
    echo "=== Backup das Regras ==="
    backup_file="/backup/iptables_debug_$(date +%Y%m%d_%H%M%S).bak"
    mkdir -p /backup
    iptables-save > "$backup_file"
    echo "Backup salvo em: $backup_file"
    echo "Para restaurar: iptables-restore < $backup_file"
}

# Loop principal
while true; do
    show_menu
    case $choice in
        1) check_status ;;
        2) list_rules ;;
        3) check_interfaces ;;
        4) monitor_logs ;;
        5) test_connectivity ;;
        6) check_connections ;;
        7) analyze_rules ;;
        8) check_modules ;;
        9) test_specific_rules ;;
        10) backup_rules ;;
        0) echo "Saindo..."; exit 0 ;;
        *) echo "Opção inválida!" ;;
    esac
    
    if [ "$choice" != "0" ]; then
        read -p "Pressione Enter para continuar..."
    fi
done 