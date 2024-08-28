#!/bin/bash
#
# name: Blender 3D
# icon: blender
# description: Executa uma versão específica, de uma lista, do Blender 3D.
# keywords: blender 3d

clear

# Diretório onde procurar pelas subpastas do Blender
DIRETORIO="$HOME/Programas/blender"

## Verifique se o diretório existe
if [[ ! -d "$DIRETORIO" ]]; then
    echo -e "\e[31m\u2639 O diretório especificado não existe.\e[0m"
    exit 1
fi

echo -e "\e[33m"
echo "
┌──────────────────────────────────────────────────────────────┐
│                                                              │
│  ██████╗ ██╗     ███████╗███╗   ██╗██████╗ ███████╗██████╗   │
│  ██╔══██╗██║     ██╔════╝████╗  ██║██╔══██╗██╔════╝██╔══██╗  │
│  ██████╔╝██║     █████╗  ██╔██╗ ██║██║  ██║█████╗  ██████╔╝  │
│  ██╔══██╗██║     ██╔══╝  ██║╚██╗██║██║  ██║██╔══╝  ██╔══██╗  │
│  ██████╔╝███████╗███████╗██║ ╚████║██████╔╝███████╗██║  ██║  │
│  ╚═════╝ ╚══════╝╚══════╝╚═╝  ╚═══╝╚═════╝ ╚══════╝╚═╝  ╚═╝  │
│                                                              │
└──────────────────────────────────────────────────────────────┘
"
echo -e "\e[0m"

## Função para comparar versões
compare_versoes() {
    ## Divide os números de versão em arrays
    IFS='.' read -r -a VERSAO1 <<< "$1"
    IFS='.' read -r -a VERSAO2 <<< "$2"
    
    ## Compare cada segmento das versões
    for i in "${!VERSAO1[@]}"; do
        if [[ -z "${VERSAO2[i]}" ]]; then
            return 1
        fi
        if ((10#${VERSAO1[i]} > 10#${VERSAO2[i]})); then
            return 1
        elif ((10#${VERSAO1[i]} < 10#${VERSAO2[i]})); then
            return 2
        fi
    done
    
    if [[ ${#VERSAO1[@]} -gt ${#VERSAO2[@]} ]]; then
        return 1
    elif [[ ${#VERSAO1[@]} -lt ${#VERSAO2[@]} ]]; then
        return 2
    fi
    
    return 0
}

## Inicializa variáveis
VERSOES=()
PASTAS=()

## Loop pelas subpastas no diretório especificado
for PASTA in "$DIRETORIO"/*/; do
    ## exemplo do nome da pasta: blender-4.2.0-linux-x64
    if [[ -d $PASTA && $PASTA == *blender-* ]]; then
        VERSAO=$(echo "$PASTA" | grep -oP 'blender-\K[0-9.]+')
        VERSOES+=("$VERSAO")
        PASTAS+=("$PASTA")
    fi
done

## Adiciona opção de sair
VERSOES=("Sair" "${VERSOES[@]}")
echo ${VERSOES[@]}

## Verifica se encontrou mais de uma versão
if [[ ${#VERSOES[@]} -gt 2 ]]; then
    echo -e "\nForam encontradas múltiplas versões do Blender:"
    PS3="Selecione a versão do Blender para executar (ou 1 para sair): "
    select OPT in "${VERSOES[@]}"; do
        if [[ $REPLY -eq 1 ]]; then
            echo -e "\nSaindo sem executar nenhuma versão."
            exit 0
        elif [[ $REPLY -gt 1 && $REPLY -le ${#VERSOES[@]} ]]; then
            ESCOLHA=$((REPLY-1))
            break
        else
            echo -e "\e[31m\u2639 Opção inválida.\e[0m"
        fi
    done
    ULTIMA_PASTA="${PASTAS[$((ESCOLHA-1))]}"
elif [[ ${#VERSOES[@]} -eq 2 ]]; then
    ULTIMA_PASTA="${PASTAS[0]}"
else
    echo -e "\n\e[33m\u2716 Nenhuma pasta do Blender encontrada no diretório:\e[0m $DIRETORIO"
    exit 1
fi

## Verifica se uma pasta foi encontrada e executa o arquivo Blender
if [[ -n $ULTIMA_PASTA ]]; then
    BLENDER_EXECUTAVEL="${ULTIMA_PASTA%/}/blender"
    if [[ -x $BLENDER_EXECUTAVEL ]]; then
        echo -e "\n\e[36m\u26A1 Executando a versão selecionada:\e[0m $BLENDER_EXECUTAVEL"
        "$BLENDER_EXECUTAVEL" --start-console --window-maximized
    else
        echo -e "\n\e[33m\u2716 Arquivo Blender não encontrado ou não é executável:\e[0m $BLENDER_EXECUTAVEL"
    fi
else
    echo -e "\n\e[33m\u2716 Nenhuma pasta do Blender encontrada no diretório:\e[0m $DIRETORIO"
fi
