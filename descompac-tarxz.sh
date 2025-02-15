#!/bin/bash
#
# name: Descompactar tar.xz
# icon: zip
# description: Descompacta todos os arquivos .tar.xz da pasta indicada.
# keywords: descompactar tar xz


# Verifica se o diretório foi passado como argumento
if [ -z "$1" ]; then
    echo "Uso: $0 <caminho_para_o_diretorio>"
    exit 1
fi

# Diretório onde procurar pelos arquivos .tar.xz
DIRETORIO="$1"

# Verifica se o diretório existe
if [ ! -d "$DIRETORIO" ]; then
    echo "O diretório especificado não existe: $DIRETORIO"
    exit 1
fi

# Encontra todos os arquivos .tar.xz no diretório
ARQUIVOS=$(find "$DIRETORIO" -maxdepth 1 -type f -name "*.tar.xz")

# Verifica se existem arquivos .tar.xz
if [ -z "$ARQUIVOS" ]; then
    echo "Nenhum arquivo .tar.xz encontrado em: $DIRETORIO"
    clear
    exit 0
fi

# Loop para descompactar cada arquivo encontrado
for ARQUIVO in $ARQUIVOS; do
    echo "Descompactando $ARQUIVO ..."
    tar -xJf "$ARQUIVO" -C "$DIRETORIO"
    
    # Verifica se a descompactação foi bem-sucedida
    if [ $? -eq 0 ]; then
        echo "Descompactação concluída: $ARQUIVO"
        echo "Removendo o arquivo .tar.xz ..."
        rm -f "$ARQUIVO"
    else
        echo "Erro ao descompactar: $ARQUIVO"
    fi
done

# echo "Processo concluído."
