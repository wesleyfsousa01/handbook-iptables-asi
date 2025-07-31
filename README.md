# Handbook iptables - ASI

Este repositório contém o handbook sobre iptables desenvolvido pelo Grupo ASI do IFG Câmpus Formosa, incluindo documentação técnica, scripts de configuração e ferramentas de debugging.

## 📋 Sobre o Projeto

O handbook aborda a configuração e administração de firewalls usando iptables no Linux, com foco especial no Debian 12 e suas particularidades relacionadas à transição para nftables.

## 🔧 Correções e Melhorias Implementadas

### 1. Pontos Críticos Corrigidos

#### A) Inconsistência Fundamental: iptables-legacy vs. nftables
- **Problema**: O manual não abordava a transição do iptables-legacy para nftables no Debian 12
- **Solução**: Adicionada seção completa explicando:
  - Contexto histórico da transição
  - Como verificar qual versão está em uso
  - Implicações práticas da mudança
  - Como configurar iptables-legacy se necessário

#### B) Erros de Sintaxe e Formatação
- **Problema**: Comandos com opções agrupadas incorretamente
- **Soluções**:
  - `sudo iptables -L-v-n` → `sudo iptables -L -v -n`
  - `sudo iptables -L-v-n-line-numbers` → `sudo iptables -L -v -n --line-numbers`
  - `lsmod grep iptable` → `lsmod | grep iptable`

#### C) Proteção Contra Força Bruta SSH
- **Problema**: Sintaxe incorreta nas regras de proteção
- **Solução**: Implementada versão corrigida usando `conntrack`:
  ```bash
  # Versão corrigida
  iptables -A INPUT -p tcp --dport 22 -m conntrack --ctstate NEW -m recent --set --name SSH --rsource
  iptables -A INPUT -p tcp --dport 22 -m conntrack --ctstate NEW -m recent --update --seconds 60 --hitcount 4 --name SSH --rsource -j DROP
  ```

### 2. Pontos de Melhoria Implementados

#### A) Modernização e Boas Práticas
- **Nomes de Interfaces**: Adicionadas notas sobre nomes modernos de interfaces (`enp3s0`, `ens18`)
- **netstat vs. ss**: Recomendação explícita para usar `ss` em vez de `netstat` (obsoleto)
- **Documentação Interna**: Melhorada a documentação dos scripts com comentários explicativos

#### B) Clareza e Didática
- **Documentação de Estados**: Explicação detalhada dos estados ESTABLISHED e RELATED
- **Seção de Debugging**: Nova seção com técnicas para diagnosticar problemas
- **Comandos Essenciais**: Tabela de referência rápida com os comandos mais importantes

#### C) Estrutura do Documento
- **Resumo Final**: Adicionada tabela de "Comandos Essenciais" como referência rápida
- **Seções Organizadas**: Melhor organização do conteúdo com seções lógicas

## 📁 Estrutura do Repositório

```
handbook-iptables-asi/
├── modelo-handbook.tex          # Documento principal atualizado
├── scripts/
│   ├── firewall-basic.sh        # Script básico atualizado (v2.0)
│   ├── firewall-advanced.sh     # Script avançado
│   ├── firewall-debug.sh        # NOVO: Script de debugging
│   ├── backup-rules.sh          # Script de backup
│   └── firewall-config.conf     # Arquivo de configuração
├── fig/                         # Figuras e imagens
├── docs/                        # Documentação adicional
└── bibliografia.bib             # Referências bibliográficas
```

## 🚀 Scripts Disponíveis

### 1. firewall-basic.sh (v2.0)
Script de configuração básica atualizado com:
- Verificação de versão do iptables
- Proteção contra força bruta SSH corrigida
- Logging para debugging
- Verificações de segurança adicionais
- Documentação interna melhorada

### 2. firewall-debug.sh (NOVO)
Script interativo para debugging com:
- Menu de opções para diagnóstico
- Verificação de status e regras
- Teste de conectividade
- Monitoramento de logs em tempo real
- Análise de regras por cadeia
- Backup automático

### 3. firewall-advanced.sh
Script para configurações avançadas

### 4. backup-rules.sh
Script para backup e restauração de regras

## 📖 Principais Seções do Handbook

1. **Ficha Técnica** - Informações básicas do serviço
2. **Descrição do Servidor** - Conceitos fundamentais
3. **iptables-legacy vs. nftables** - NOVA: Transição no Debian
4. **Instalação** - Configuração inicial
5. **Arquivos de Configuração** - Estrutura e comandos
6. **Configurações Avançadas** - NAT, logging, proteções
7. **Debugging de Regras** - NOVA: Técnicas de diagnóstico
8. **Comandos Essenciais** - NOVA: Referência rápida
9. **Considerações Finais** - Boas práticas e recomendações

## 🔍 Comandos Essenciais (Referência Rápida)

| Comando | Descrição |
|---------|-----------|
| `iptables -L -v -n` | Listar todas as regras com estatísticas |
| `iptables -A INPUT -p tcp --dport 80 -j ACCEPT` | Adicionar regra para permitir HTTP |
| `iptables -D INPUT 1` | Deletar regra número 1 da cadeia INPUT |
| `iptables -F` | Limpar todas as regras |
| `iptables -P INPUT DROP` | Definir política padrão da cadeia INPUT |
| `iptables-save` | Salvar regras em arquivo |
| `iptables-restore < arquivo` | Restaurar regras de arquivo |
| `iptables -L --line-numbers` | Listar regras com números de linha |
| `iptables -C INPUT -p tcp --dport 22 -j ACCEPT` | Verificar se regra existe |

## 🛠️ Como Usar

### Compilar o Documento
```bash
# Compilar o handbook LaTeX
pdflatex modelo-handbook.tex
```

### Executar Scripts
```bash
# Configuração básica
sudo ./scripts/firewall-basic.sh

# Debugging e verificação
sudo ./scripts/firewall-debug.sh

# Backup das regras
sudo ./scripts/backup-rules.sh
```

## ⚠️ Importante

- **Ambiente de Teste**: Sempre teste as configurações em ambiente controlado antes da produção
- **Backup**: Faça backup das regras atuais antes de aplicar mudanças
- **Compatibilidade**: Esteja ciente da transição para nftables no Debian 12
- **Documentação**: Mantenha documentação atualizada das configurações

## 📚 Referências

- [Debian iptables Documentation](https://wiki.debian.org/iptables)
- [nftables vs iptables](https://wiki.nftables.org/wiki-nftables/index.php/Moving_from_iptables_to_nftables)
- [Netfilter Project](https://netfilter.org/)

## 👥 Autores

**Grupo ASI - IFG Câmpus Formosa**

## 📄 Licença

Este projeto está sob licença educacional para uso acadêmico.

---

**Versão**: 2.0  
**Data**: 2024  
**Status**: Atualizado com correções e melhorias 