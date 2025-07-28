# Instruções para o Grupo ASI - IFG Câmpus Formosa

## Sobre o Projeto

Este template foi desenvolvido especificamente para o capítulo **"Servidor Firewall (iptables) e Aplicações"** do handbook **"Administração de Serviços para Internet com GNU Linux/Debian"**.

## Estrutura do Projeto

```
template-escrita-handbook/
├── modelo-handbook.tex          # Documento LaTeX principal
├── README.md                    # Documentação geral
├── INSTRUCOES_GRUPO.md         # Este arquivo
├── bibliografia.bib             # Referências bibliográficas
├── fig/                         # Pasta para figuras
└── scripts/                     # Scripts práticos
    ├── firewall-basic.sh        # Configuração básica
    ├── firewall-advanced.sh     # Configuração avançada
    ├── backup-rules.sh          # Backup e restauração
    └── firewall-config.conf     # Arquivo de configuração
```

## Como Usar o Template

### 1. Compilação do Documento

Para gerar o PDF do handbook:

**No Windows:**
- Instale o MiKTeX: https://miktex.org/download
- Use um editor como TeXstudio ou TeXmaker
- Ou compile via linha de comando: `pdflatex modelo-handbook.tex`

**No Linux:**
```bash
sudo apt-get install texlive-full
pdflatex modelo-handbook.tex
```

**Online:**
- Use o Overleaf: https://www.overleaf.com
- Faça upload do arquivo `modelo-handbook.tex`

### 2. Personalização do Conteúdo

#### Informações do Grupo
- Altere a linha 47: `\center {\textit{Autor: Grupo ASI - IFG Câmpus Formosa}}`
- Substitua "Grupo ASI" pelos nomes dos integrantes

#### Conteúdo Técnico
- O documento já está estruturado com conteúdo específico sobre iptables
- Adicione suas próprias experiências e configurações
- Inclua screenshots das suas configurações na pasta `fig/`

### 3. Scripts Práticos

#### Script Básico (`firewall-basic.sh`)
```bash
# Dar permissão de execução
chmod +x scripts/firewall-basic.sh

# Executar (como root)
sudo ./scripts/firewall-basic.sh
```

**O que faz:**
- Configura regras básicas de firewall
- Permite SSH, HTTP, HTTPS
- Implementa proteções básicas contra ataques
- Faz backup automático das configurações

#### Script Avançado (`firewall-advanced.sh`)
```bash
# Dar permissão de execução
chmod +x scripts/firewall-advanced.sh

# Executar (como root)
sudo ./scripts/firewall-advanced.sh
```

**O que faz:**
- Configurações mais sofisticadas
- Proteção contra força bruta SSH
- Rate limiting avançado
- Logging detalhado
- Configurações de NAT e port forwarding

#### Script de Backup (`backup-rules.sh`)
```bash
# Dar permissão de execução
chmod +x scripts/backup-rules.sh

# Fazer backup
sudo ./scripts/backup-rules.sh backup

# Listar backups
sudo ./scripts/backup-rules.sh list

# Restaurar backup
sudo ./scripts/backup-rules.sh restore /backup/iptables/iptables_20241201_143022.bak
```

### 4. Configuração Personalizada

Edite o arquivo `scripts/firewall-config.conf` para personalizar:

```bash
# Interface de rede externa
EXTERNAL_INTERFACE="eth0"

# Rede interna
INTERNAL_NETWORK="192.168.1.0/24"

# Portas permitidas
ALLOWED_PORTS="22 80 443 53 123"
```

## Tópicos Abordados no Capítulo

### 1. Ficha Técnica
- Método de comunicação: TCP/UDP, portas configuráveis
- Funções: Controle de tráfego, filtragem, NAT, balanceamento
- Pacote: iptables (incluído no kernel)
- Script de controle: /etc/init.d/netfilter-persistent

### 2. Descrição do Servidor
- Conceitos fundamentais do iptables
- Tabelas (filter, nat, mangle)
- Cadeias (INPUT, OUTPUT, FORWARD, PREROUTING, POSTROUTING)

### 3. Instalação
- Comandos de instalação
- Verificação de módulos do kernel
- Configuração inicial

### 4. Arquivos de Configuração
- Localização dos arquivos de regras
- Comandos principais
- Exemplo de configuração básica

### 5. Exemplos e Boas Práticas
- Configuração de NAT
- Logging e monitoramento
- Proteção contra ataques
- Scripts de backup
- Boas práticas de segurança

### 6. Considerações Finais
- Pontos importantes para produção
- Monitoramento e manutenção
- Alta disponibilidade

## Sugestões para Apresentação

### 1. Demonstração Prática
- Use os scripts para mostrar configuração em tempo real
- Demonstre backup e restauração
- Mostre logs de tentativas de intrusão

### 2. Configurações Específicas
- Configure um servidor web com port forwarding
- Demonstre proteção contra ataques SSH
- Mostre monitoramento em tempo real

### 3. Casos de Uso
- Servidor web com firewall
- Gateway para rede interna
- Servidor de aplicação com balanceamento

## Comandos Úteis para Demonstração

```bash
# Ver regras atuais
sudo iptables -L -v -n

# Monitorar logs em tempo real
sudo tail -f /var/log/syslog | grep iptables

# Testar conectividade
ping 8.8.8.8
curl http://localhost

# Verificar estatísticas
sudo iptables -L -v -n --line-numbers
```

## Dicas para o Trabalho

### 1. Documentação
- Documente todas as configurações feitas
- Mantenha um log de mudanças
- Teste sempre em ambiente controlado

### 2. Segurança
- Nunca teste configurações em produção sem backup
- Mantenha backups das regras
- Monitore logs regularmente

### 3. Apresentação
- Prepare uma demonstração prática
- Tenha planos de contingência
- Documente problemas encontrados e soluções

## Contato e Suporte

Para dúvidas sobre o template ou scripts:
- Consulte a documentação no README.md
- Teste os scripts em ambiente virtualizado
- Mantenha backups antes de qualquer alteração

---

**Boa sorte com o projeto!** 🚀

*Template desenvolvido para o Grupo ASI - IFG Câmpus Formosa* 