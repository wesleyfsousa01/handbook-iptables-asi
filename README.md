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
template-escrita-handbook/
├── modelo-handbook.tex          # Arquivo principal do documento
├── bibliografia.bib             # Referências bibliográficas
├── fig/                         # Pasta com figuras
├── README.md                    # Este arquivo
└── scripts/                     # Scripts de exemplo
    ├── firewall-basic.sh        # Configuração básica de firewall
    ├── firewall-advanced.sh     # Configuração avançada
    └── backup-rules.sh          # Script de backup
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

### Compilação

#### No Linux:
```bash
# Instalar TeX Live
sudo apt-get install texlive-full

# Compilar o documento
pdflatex modelo-handbook.tex
```

#### No Windows:
```bash
# Após instalar MiKTeX, abrir o prompt de comando
pdflatex modelo-handbook.tex
```

#### No macOS:
```bash
# Após instalar MacTeX
pdflatex modelo-handbook.tex
```

### Compilação Múltipla

Para referências e índice, pode ser necessário compilar múltiplas vezes:

```bash
pdflatex modelo-handbook.tex
pdflatex modelo-handbook.tex
```

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
- Tabelas e cadeias do iptables
- Configuração de NAT e roteamento
- Proteção contra ataques comuns
- Logging e monitoramento
- Scripts de backup e restauração
- Boas práticas de segurança

## Contribuição

Para contribuir com o projeto:

1. Faça um fork do repositório
2. Crie uma branch para sua feature
3. Faça commit das suas mudanças
4. Abra um Pull Request

## Licença

Este projeto está sob a licença [especificar licença].

## Contato

Para dúvidas ou sugestões, entre em contato com o grupo ASI do IFG Câmpus Formosa.

---

**Nota**: Este documento é parte do handbook "Administração de Serviços para Internet com GNU Linux/Debian" e serve como referência para estudantes do IFG Câmpus Formosa. 