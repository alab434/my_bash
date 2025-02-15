#!/bin/bash
#
# name: Blender 3D
# icon: blender
# description: Executa uma versão específica, de uma lista, do Blender 3D.
# keywords: blender 3d

clear

## Numeros das versoes LTS
LTS=("4.2" "3.6" "3.3" "2.93" "2.83")

# Diretório onde procurar pelas subpastas do Blender
DIRETORIO="$HOME/Programas/blender"

## Verifique se o diretório existe
if [[ ! -d "$DIRETORIO" ]]; then
    echo -e "\e[31m\u2639 O diretório especificado não existe.\e[0m"
    exit 1
fi

## Procura por arquivos compactados na pasta indicada
~/my_bash/descompac-tarxz.sh "$DIRETORIO"

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

## Verifica se encontrou mais de uma versão
if [[ ${#VERSOES[@]} -gt 1 ]]; then
    echo -e "\nForam encontradas múltiplas versões do \e[33mBlender\e[0m:"
    VERSAOSELECIONADA="Selecione a versão para executar (ou 0 para sair): "
    
    ## Exibe a lista de opções com a numeração correta
    for i in "${!VERSOES[@]}"; do
        NUMVERSAO="${VERSOES[$i]:0:3}"
        if [[ " ${LTS[@]} " =~ " ${NUMVERSAO} " ]]; then ## Testa se é uma versão LTS
            echo -e " \e[33mLTS\e[0m $i) ${VERSOES[i]}"
        else
            echo -e "     $i) ${VERSOES[i]}"
        fi
    done
    
    ## Solicita a escolha do usuário
    while true; do
        echo " "
        read -rp "$VERSAOSELECIONADA" ESCOLHA
        if [[ $ESCOLHA =~ ^[0-9]+$ ]] && [[ $ESCOLHA -ge 0 && $ESCOLHA -lt ${#VERSOES[@]} ]]; then
            if [[ $ESCOLHA -eq 0 ]]; then
                echo -e "\nSaindo sem executar nenhuma versão."
                exit 0
            else
                ESCOLHA=$((ESCOLHA-1))
                break
            fi
        else
            echo -e "\e[31m\u2639 Opção inválida.\e[0m"
        fi
    done
    ULTIMA_PASTA="${PASTAS[$ESCOLHA]}"
else
    echo -e "\n\e[33m\u2716 Nenhuma pasta do Blender foi encontrada no diretório:\e[0m $DIRETORIO"
    exit 1
fi

## Verifica se uma pasta foi encontrada e executa o arquivo Blender
if [[ -n $ULTIMA_PASTA ]]; then
    BLENDER_EXECUTAVEL="${ULTIMA_PASTA%/}/blender"
    if [[ -x $BLENDER_EXECUTAVEL ]]; then
        echo -e "\n\e[36m\u26A1 Executando a versão selecionada:\e[0m $BLENDER_EXECUTAVEL"
        xdotool windowminimize $(xdotool getactivewindow)
        "$BLENDER_EXECUTAVEL" --start-console --window-maximized
    else
        echo -e "\n\e[33m\u2716 Arquivo Blender não foi encontrado ou não é executável:\e[0m $BLENDER_EXECUTAVEL"
    fi
else
    echo -e "\n\e[33m\u2716 Nenhuma pasta do Blender foi encontrada no diretório:\e[0m $DIRETORIO"
fi
