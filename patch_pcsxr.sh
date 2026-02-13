#Script de Automação: patch_pcsxr.sh

#Salve o conteúdo abaixo como patch_pcsxr.sh na pasta principal do seu projeto e dê permissão de execução.

#!/bin/bash

echo "--- Iniciando Patch para Compilação Moderna do PCSXR ---"

# 1. Corrigindo erro de waitpid (falta de include sys/wait.h)
echo "[1/3] Aplicando correções de headers (waitpid)..."
files_to_include=("plugins/dfinput/pad.c" "plugins/dfsound/cfg.c")
for file in "${files_to_include[@]}"; do
    if [ -f "$file" ]; then
        sed -i '1i #include <sys/wait.h>' "$file"
        echo "  - Corrigido: $file"
    fi
done

# 2. Corrigindo protótipo da função OpenCdHandle no cabeçalho
echo "[2/3] Corrigindo protótipo de função em plugins/dfcdrom/cdr.h..."
if [ -f "plugins/dfcdrom/cdr.h" ]; then
    sed -i 's/int OpenCdHandle();/int OpenCdHandle(const char *device);/' plugins/dfcdrom/cdr.h
    echo "  - Corrigido: plugins/dfcdrom/cdr.h"
fi

# 3. Preparando o ambiente para configuração
echo "[3/3] Limpando compilações antigas..."
make clean > /dev/null 2>&1

echo ""
echo "--- PATCH APLICADO COM SUCESSO ---"
echo "Agora execute os comandos abaixo para compilar:"
echo ""
echo "CFLAGS=\"-O2 -fcommon -Wno-incompatible-pointer-types -Wno-implicit-function-declaration\" ./configure --enable-interpreter"
echo "make"
echo "sudo make install"
echo "sudo ldconfig"

##Como usar o Script:
##
##    Crie o arquivo:
##    Bash
##
##    nano patch_pcsxr.sh
##
##    Cole o código acima, salve (Ctrl+O, Enter) e saia (Ctrl+X).
##
##    Dê permissão de execução:
##    Bash
##
##    chmod +x patch_pcsxr.sh
##
##    Rode o script:
##    Bash
##
##    ./patch_pcsxr.sh
##
## O que este script resolve para o próximo usuário:
##
##    Automatiza o SED: Ele insere as linhas de código nos locais exatos sem que o usuário precise abrir um editor de texto.
##
##    Padroniza as Flags: Ele já exibe no final exatamente o que deve ser colado no terminal para o configure.
##
##    Evita o Core Dump: Já inclui a instrução --enable-interpreter para evitar aquele erro de janela preta que fecha sozinha.

