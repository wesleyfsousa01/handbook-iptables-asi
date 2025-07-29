# Handbook - Administração de Serviços para Internet com GNU Linux/Debian

## Sobre o Projeto

Este projeto contém o template LaTeX para criação de um handbook sobre "Administração de Serviços para Internet com GNU Linux/Debian" para o IFG Câmpus Formosa.

### Capítulo Atual: Servidor Firewall (iptables) e Aplicações

O capítulo 7 foi desenvolvido com foco em:
- Configuração e administração do iptables
- Implementação de políticas de segurança
- Configuração de NAT e roteamento
- Boas práticas de segurança
- Monitoramento e manutenção

## Estrutura do Projeto

```
handbook-iptables-asi/
├── modelo-handbook.tex          # Arquivo principal do documento LaTeX
├── bibliografia.bib             # Referências bibliográficas
├── .gitignore                   # Configuração para ignorar arquivos auxiliares
├── fig/                         # Pasta com figuras e imagens
├── docs/                        # Pasta para documentação adicional
├── scripts/                     # Scripts de exemplo e configuração
│   ├── firewall-basic.sh        # Configuração básica de firewall
│   ├── firewall-advanced.sh     # Configuração avançada
│   ├── backup-rules.sh          # Script de backup e restauração
│   └── firewall-config.conf     # Arquivo de configuração
├── README.md                    # Este arquivo
└── INSTRUCOES_GRUPO.md          # Instruções específicas do grupo
```

## Como Compilar o Documento

### Pré-requisitos

Para compilar o documento LaTeX, você precisa ter instalado:

1. **LaTeX Distribution** (escolha uma das opções):
   - **TeX Live** (recomendado para Linux)
   - **MiKTeX** (recomendado para Windows)
   - **MacTeX** (para macOS)

2. **Editor LaTeX** (opcional):
   - TeXstudio
   - TeXmaker
   - Overleaf (online)
   - VS Code com extensão LaTeX Workshop

### Compilação Recomendada

**⚠️ IMPORTANTE**: Este projeto foi configurado para usar **XeLaTeX** devido ao suporte nativo para UTF-8 e caracteres especiais.

#### Comando de Compilação:
```bash
xelatex modelo-handbook.tex
```

#### Alternativa (se necessário):
```bash
pdflatex modelo-handbook.tex
```

### Compilação Múltipla

Para referências e índice, pode ser necessário compilar múltiplas vezes:

```bash
xelatex modelo-handbook.tex
xelatex modelo-handbook.tex
```

### Arquivos Gerados

Após a compilação, serão gerados:
- `modelo-handbook.pdf` - Documento final (7 páginas)
- `modelo-handbook.aux` - Arquivo auxiliar (ignorado pelo .gitignore)
- `modelo-handbook.log` - Log da compilação (ignorado pelo .gitignore)

## Configuração do Projeto

### .gitignore

O projeto inclui um `.gitignore` configurado para:
- Arquivos auxiliares do LaTeX (`.aux`, `.log`, `.out`, etc.)
- Arquivos temporários e de backup
- Arquivos do sistema operacional
- Arquivos de editores/IDEs
- Arquivos de teste

### Encoding e Caracteres Especiais

- **Encoding**: UTF-8 nativo (XeLaTeX)
- **Caracteres especiais**: Suporte completo para acentos e caracteres portugueses
- **Fontes**: Configuradas automaticamente pelo XeLaTeX

## Scripts de Exemplo

### Configuração Básica de Firewall

O arquivo `scripts/firewall-basic.sh` contém uma configuração básica de firewall que pode ser usada como ponto de partida.

### Como usar os scripts:

```bash
# Dar permissão de execução
chmod +x scripts/firewall-basic.sh

# Executar (como root)
sudo ./scripts/firewall-basic.sh
```

### Scripts Disponíveis:

- `firewall-basic.sh` - Configuração básica de firewall
- `firewall-advanced.sh` - Configuração avançada com proteções
- `backup-rules.sh` - Backup e restauração de regras
- `firewall-config.conf` - Arquivo de configuração

## Conteúdo do Capítulo

### Seções Principais:

1. **Ficha Técnica**: Informações básicas sobre o serviço
2. **Descrição do Servidor**: Conceitos fundamentais do iptables
3. **Instalação**: Como instalar e configurar o iptables
4. **Arquivos de Configuração**: Localização e uso dos arquivos de configuração
5. **Exemplos e Boas Práticas**: Configurações práticas e recomendações
6. **Considerações Finais**: Pontos importantes para produção

### Tópicos Abordados:

- Conceitos de firewall e filtragem de pacotes
- Tabelas e cadeias do iptables (filter, nat, mangle)
- Configuração de NAT e roteamento
- Proteção contra ataques comuns (SYN flood, port scanning)
- Logging e monitoramento
- Scripts de backup e restauração
- Boas práticas de segurança
- Configurações para ambientes de produção

## Limpeza e Manutenção

### Arquivos Removidos

Durante a limpeza do projeto, foram removidos:
- Arquivos de teste temporários
- Arquivos auxiliares do LaTeX
- Arquivos duplicados ou desnecessários

### Estrutura Otimizada

O projeto foi reorganizado para:
- Manter apenas arquivos essenciais
- Facilitar a manutenção
- Melhorar a legibilidade do código
- Otimizar a compilação

## Contribuição

Para contribuir com o projeto:

1. Faça um fork do repositório
2. Crie uma branch para sua feature
3. Faça commit das suas mudanças
4. Abra um Pull Request

### Padrões de Contribuição

- Use XeLaTeX para compilação
- Mantenha o encoding UTF-8
- Teste a compilação antes de fazer commit
- Atualize a documentação quando necessário

## Licença

Este projeto está sob a licença [especificar licença].

## Contato

Para dúvidas ou sugestões, entre em contato com o grupo ASI do IFG Câmpus Formosa.

---

**Nota**: Este documento é parte do handbook "Administração de Serviços para Internet com GNU Linux/Debian" e serve como referência para estudantes do IFG Câmpus Formosa.

**Última atualização**: Julho 2025 