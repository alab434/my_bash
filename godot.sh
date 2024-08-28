#!/bin/bash
#
# name: Godot
# icon: godot
# description: Executa uma versão específica, de uma lista, da Engine Godot.
# keywords: godot engine

clear


## Diretório onde procurar pelos arquivos da Godot
##   altere o caminho para refletir a localização dos seus
##   arquivos das versões Godot.
DIRETORIO="$HOME/Programas/godot"


## Verifique se o diretório existe
if [[ ! -d "$DIRETORIO" ]]; then
    echo -e "\e[31m\u2639 O diretório especificado não existe.\e[0m"
    exit 1
fi

echo -e "\e[36m"
echo "
┌────────────────────────────────────────────────┐
│                                                │
│   ██████╗  ██████╗ ██████╗  ██████╗ ████████╗  │
│  ██╔════╝ ██╔═══██╗██╔══██╗██╔═══██╗╚══██╔══╝  │
│  ██║  ███╗██║   ██║██║  ██║██║   ██║   ██║     │
│  ██║   ██║██║   ██║██║  ██║██║   ██║   ██║     │
│  ╚██████╔╝╚██████╔╝██████╔╝╚██████╔╝   ██║     │
│   ╚═════╝  ╚═════╝ ╚═════╝  ╚═════╝    ╚═╝     │
│                                                │
└────────────────────────────────────────────────┘
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
declare -a VERSOES
declare -a ARQUIVOS

## Loop no diretório especificado
for ARQUIVO in "$DIRETORIO"/*; do
    ## exemplo do nome do arquivo: Godot_v4.2.2-stable_linux.x86_64
    if [[ -f $ARQUIVO && $ARQUIVO == *Godot_v* ]]; then
        # Extrai o numero da versao
        VERSAO=$(echo "$ARQUIVO" | grep -oP 'v\K[0-9.]+')
        VERSOES+=("$VERSAO")
        ARQUIVOS+=("$ARQUIVO")
    fi
done

## Verifica se as versões foram encontradas
if [[ ${#VERSOES[@]} -eq 0 ]]; then
    echo -e "\e[33m\u2639 Nenhum arquivo estável foi encontrado no diretório especificado.\e[0m"
    exit 0
fi

## Exibe o menu se mais de uma versão foi encontrada
if ([[ ${#VERSOES[@]} -gt 1 ]]); then
    echo -e "\nSelecione a versão da Godot para executar:"
    for i in "${!VERSOES[@]}"; do
        echo "  $((i+1))) ${VERSOES[$i]}"
    done
    echo "  0) Sair"
    echo
    read -p "Escolha uma opção: " ESCOLHA

    if ! [[ "$ESCOLHA" =~ ^[0-9]+$ ]] || (( ESCOLHA < 0 || ESCOLHA > ${#VERSOES[@]} )); then
        echo -e "\e[31m\u2639 Opção inválida.\e[0m"
        exit 1
    fi

    if [[ "$ESCOLHA" -eq 0 ]]; then
        echo -e "\e[33m\u2639 Saindo sem executar nenhuma versão.\e[0m"
        exit 0
    fi

    SELECIONADO=$((ESCOLHA-1))
    ARQUIVO_ESCOLHIDO="${ARQUIVOS[$SELECIONADO]}"
else
    ARQUIVO_ESCOLHIDO="${ARQUIVOS[0]}"
fi

## Executa a versão escolhida
echo -e "\n\e[32m\u2666 Executando a versão selecionada:\e[0m $ARQUIVO_ESCOLHIDO"
"$ARQUIVO_ESCOLHIDO"
