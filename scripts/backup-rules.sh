#!/bin/bash

# Script de Backup e Restauração de Regras do iptables
# Autor: Grupo ASI - IFG Câmpus Formosa
# Data: 2024

BACKUP_DIR="/backup/iptables"
DATE=$(date +%Y%m%d_%H%M%S)

# Função para mostrar uso
show_usage() {
    echo "Uso: $0 [opção]"
    echo ""
    echo "Opções:"
    echo "  backup     - Fazer backup das regras atuais"
    echo "  restore    - Restaurar regras de um backup"
    echo "  list       - Listar backups disponíveis"
    echo "  auto       - Backup automático com rotação (manter últimos 10)"
    echo "  help       - Mostrar esta ajuda"
    echo ""
    echo "Exemplos:"
    echo "  $0 backup"
    echo "  $0 restore /backup/iptables/iptables_20241201_143022.bak"
    echo "  $0 list"
    echo "  $0 auto"
}

# Função para verificar se está rodando como root
check_root() {
    if [ "$EUID" -ne 0 ]; then
        echo "ERRO: Este script deve ser executado como root (sudo)"
        exit 1
    fi
}

# Função para criar diretório de backup
create_backup_dir() {
    if [ ! -d "$BACKUP_DIR" ]; then
        mkdir -p "$BACKUP_DIR"
        echo "Diretório de backup criado: $BACKUP_DIR"
    fi
}

# Função para fazer backup
do_backup() {
    echo "=== Fazendo Backup das Regras do iptables ==="
    
    check_root
    create_backup_dir
    
    BACKUP_FILE="$BACKUP_DIR/iptables_$DATE.bak"
    
    echo "Salvando regras em: $BACKUP_FILE"
    
    # Fazer backup das regras IPv4
    iptables-save > "$BACKUP_FILE"
    
    if [ $? -eq 0 ]; then
        echo "Backup IPv4 salvo com sucesso!"
        
        # Fazer backup das regras IPv6 se disponível
        if command -v ip6tables >/dev/null 2>&1; then
            ip6tables-save > "${BACKUP_FILE%.bak}_ipv6.bak"
            echo "Backup IPv6 salvo com sucesso!"
        fi
        
        # Criar arquivo de informações
        INFO_FILE="${BACKUP_FILE%.bak}.info"
        cat > "$INFO_FILE" << EOF
Data do Backup: $(date)
Sistema: $(uname -a)
Versão do iptables: $(iptables --version)
Usuário: $(whoami)
Hostname: $(hostname)
EOF
        
        echo "Informações do backup salvas em: $INFO_FILE"
        echo "Backup concluído com sucesso!"
        
        # Mostrar estatísticas
        echo ""
        echo "=== Estatísticas do Backup ==="
        echo "Tamanho do arquivo: $(du -h "$BACKUP_FILE" | cut -f1)"
        echo "Número de regras: $(iptables -L | grep -c "^Chain")"
        
    else
        echo "ERRO: Falha ao fazer backup das regras!"
        exit 1
    fi
}

# Função para restaurar backup
do_restore() {
    if [ -z "$1" ]; then
        echo "ERRO: Especifique o arquivo de backup para restaurar"
        echo "Uso: $0 restore /caminho/para/backup.bak"
        exit 1
    fi
    
    BACKUP_FILE="$1"
    
    if [ ! -f "$BACKUP_FILE" ]; then
        echo "ERRO: Arquivo de backup não encontrado: $BACKUP_FILE"
        exit 1
    fi
    
    echo "=== Restaurando Regras do iptables ==="
    
    check_root
    
    echo "Arquivo de backup: $BACKUP_FILE"
    echo "ATENÇÃO: Esta operação irá substituir todas as regras atuais!"
    echo ""
    read -p "Tem certeza que deseja continuar? (s/N): " confirm
    
    if [[ $confirm =~ ^[Ss]$ ]]; then
        echo "Fazendo backup das regras atuais antes da restauração..."
        CURRENT_BACKUP="$BACKUP_DIR/iptables_before_restore_$DATE.bak"
        iptables-save > "$CURRENT_BACKUP"
        
        echo "Restaurando regras..."
        iptables-restore < "$BACKUP_FILE"
        
        if [ $? -eq 0 ]; then
            echo "Restauração concluída com sucesso!"
            echo "Regras atuais:"
            iptables -L -v -n
        else
            echo "ERRO: Falha na restauração!"
            echo "Restaurando regras anteriores..."
            iptables-restore < "$CURRENT_BACKUP"
            exit 1
        fi
    else
        echo "Restauração cancelada."
    fi
}

# Função para listar backups
do_list() {
    echo "=== Backups Disponíveis ==="
    
    if [ ! -d "$BACKUP_DIR" ]; then
        echo "Diretório de backup não encontrado: $BACKUP_DIR"
        exit 1
    fi
    
    if [ -z "$(ls -A "$BACKUP_DIR" 2>/dev/null)" ]; then
        echo "Nenhum backup encontrado."
        exit 0
    fi
    
    echo "Backups IPv4:"
    ls -lh "$BACKUP_DIR"/iptables_*.bak 2>/dev/null | grep -v ipv6 | while read line; do
        echo "  $line"
    done
    
    echo ""
    echo "Backups IPv6:"
    ls -lh "$BACKUP_DIR"/*_ipv6.bak 2>/dev/null | while read line; do
        echo "  $line"
    done
    
    echo ""
    echo "Arquivos de informação:"
    ls -lh "$BACKUP_DIR"/*.info 2>/dev/null | while read line; do
        echo "  $line"
    done
}

# Função para backup automático com rotação
do_auto() {
    echo "=== Backup Automático com Rotação ==="
    
    check_root
    create_backup_dir
    
    # Fazer backup atual
    do_backup
    
    # Manter apenas os últimos 10 backups
    echo ""
    echo "Removendo backups antigos (mantendo os últimos 10)..."
    
    # Contar backups IPv4
    BACKUP_COUNT=$(ls "$BACKUP_DIR"/iptables_*.bak 2>/dev/null | grep -v ipv6 | wc -l)
    
    if [ "$BACKUP_COUNT" -gt 10 ]; then
        TO_REMOVE=$((BACKUP_COUNT - 10))
        echo "Removendo $TO_REMOVE backups antigos..."
        
        ls -t "$BACKUP_DIR"/iptables_*.bak 2>/dev/null | grep -v ipv6 | tail -n +11 | while read file; do
            echo "Removendo: $file"
            rm -f "$file"
            # Remover arquivo de informação correspondente
            rm -f "${file%.bak}.info"
        done
    fi
    
    # Contar backups IPv6
    BACKUP_COUNT_IPV6=$(ls "$BACKUP_DIR"/*_ipv6.bak 2>/dev/null | wc -l)
    
    if [ "$BACKUP_COUNT_IPV6" -gt 10 ]; then
        TO_REMOVE=$((BACKUP_COUNT_IPV6 - 10))
        echo "Removendo $TO_REMOVE backups IPv6 antigos..."
        
        ls -t "$BACKUP_DIR"/*_ipv6.bak 2>/dev/null | tail -n +11 | while read file; do
            echo "Removendo: $file"
            rm -f "$file"
        done
    fi
    
    echo "Rotação de backups concluída!"
}

# Função para verificar integridade do backup
check_backup() {
    if [ -z "$1" ]; then
        echo "ERRO: Especifique o arquivo de backup para verificar"
        exit 1
    fi
    
    BACKUP_FILE="$1"
    
    if [ ! -f "$BACKUP_FILE" ]; then
        echo "ERRO: Arquivo de backup não encontrado: $BACKUP_FILE"
        exit 1
    fi
    
    echo "=== Verificando Integridade do Backup ==="
    echo "Arquivo: $BACKUP_FILE"
    
    # Verificar se o arquivo contém regras válidas
    if grep -q "^#" "$BACKUP_FILE" && grep -q "^-A\|^-I\|^-D" "$BACKUP_FILE"; then
        echo "✓ Arquivo parece ser um backup válido do iptables"
        
        # Contar regras
        RULE_COUNT=$(grep -c "^-A\|^-I\|^-D" "$BACKUP_FILE")
        echo "✓ Número de regras no backup: $RULE_COUNT"
        
        # Verificar tabelas
        TABLES=$(grep "^\\*" "$BACKUP_FILE" | sed 's/^\*//')
        echo "✓ Tabelas encontradas: $TABLES"
        
    else
        echo "✗ Arquivo não parece ser um backup válido do iptables"
        exit 1
    fi
}

# Menu principal
case "$1" in
    backup)
        do_backup
        ;;
    restore)
        do_restore "$2"
        ;;
    list)
        do_list
        ;;
    auto)
        do_auto
        ;;
    check)
        check_backup "$2"
        ;;
    help|--help|-h)
        show_usage
        ;;
    *)
        echo "ERRO: Opção inválida"
        show_usage
        exit 1
        ;;
esac 