#!/bin/bash

# Script de conversión MD → PDF con instalación automática de Eisvogel
# Uso: ./convert.sh archivo.md [--template eisvogel]

# Función de ayuda
show_help() {
    echo "Uso: ./convert.sh archivo.md [--template eisvogel]"
    echo ""
    echo "Opciones:"
    echo "  --template|-t    Template a usar (eisvogel o default). Por defecto: default"
    echo "  --help|-h        Mostrar esta ayuda"
    echo ""
    echo "Ejemplos:"
    echo "  ./convert.sh documento.md"
    echo "  ./convert.sh documento.md --template eisvogel"
    exit 0
}

# Valores por defecto
INPUT_FILE=""
TEMPLATE="default"

# Procesar argumentos
while [[ $# -gt 0 ]]; do
    case $1 in
        --template|-t)
            TEMPLATE="$2"
            shift 2
            ;;
        --help|-h)
            show_help
            ;;
        *.md)
            INPUT_FILE="$1"
            shift
            ;;
        *)
            echo "Error: Argumento desconocido: $1" >&2
            exit 1
            ;;
    esac
done

# Verificar archivo de entrada
if [[ -z "$INPUT_FILE" ]]; then
    echo "Error: Debes proporcionar un archivo .md" >&2
    echo "Uso: ./convert.sh archivo.md [--template eisvogel]"
    exit 1
fi

if [[ ! -f "$INPUT_FILE" ]]; then
    echo "Error: '$INPUT_FILE' no existe" >&2
    exit 1
fi

OUTPUT_FILE="${INPUT_FILE%.md}.pdf"
echo -e "\033[36mConvirtiendo: $INPUT_FILE -> $OUTPUT_FILE\033[0m"

# Buscar Pandoc
pandoc_cmd=""
if command -v pandoc &> /dev/null; then
    pandoc_cmd="pandoc"
elif [[ -f "/usr/local/bin/pandoc" ]]; then
    pandoc_cmd="/usr/local/bin/pandoc"
elif [[ -f "/opt/pandoc/bin/pandoc" ]]; then
    pandoc_cmd="/opt/pandoc/bin/pandoc"
else
    echo -e "\033[31mError: Pandoc no encontrado\033[0m" >&2
    echo "Instala Pandoc con:"
    echo "  Ubuntu/Debian: sudo apt install pandoc"
    echo "  Fedora/RHEL: sudo dnf install pandoc"
    echo "  Arch: sudo pacman -S pandoc"
    echo "  O descarga desde: https://pandoc.org/installing.html"
    exit 1
fi

# Buscar motor PDF (LaTeX)
pdf_engine=""
if command -v xelatex &> /dev/null; then
    pdf_engine="xelatex"
elif command -v pdflatex &> /dev/null; then
    pdf_engine="pdflatex"
elif command -v lualatex &> /dev/null; then
    pdf_engine="lualatex"
else
    echo -e "\033[31mError: No se encontró motor LaTeX (xelatex, pdflatex, lualatex)\033[0m" >&2
    echo "Instala TeX Live:"
    echo "  Ubuntu/Debian: sudo apt install texlive-full"
    echo "  Fedora/RHEL: sudo dnf install texlive-scheme-full"
    echo "  Arch: sudo pacman -S texlive-most"
    exit 1
fi

echo -e "\033[32mUsando motor PDF: $pdf_engine\033[0m"

# Función para instalar Eisvogel automáticamente
install_eisvogel() {
    local templates_dir="$HOME/.pandoc/templates"
    local eisvogel_path="$templates_dir/eisvogel.latex"

    echo -e "\033[33mEisvogel no encontrado. Descargando...\033[0m"

    # Crear directorio si no existe
    mkdir -p "$templates_dir"

    # Verificar si wget o curl están disponibles
    if command -v wget &> /dev/null; then
        download_cmd="wget -O"
    elif command -v curl &> /dev/null; then
        download_cmd="curl -L -o"
    else
        echo -e "\033[31mError: Se necesita wget o curl para descargar Eisvogel\033[0m" >&2
        echo "Descárgalo manualmente desde: https://github.com/Wandmalfarbe/pandoc-latex-template/releases/"
        return 1
    fi

    # URL del último release de Eisvogel
    local url="https://github.com/Wandmalfarbe/pandoc-latex-template/releases/latest/download/Eisvogel.zip"
    local zip_path="/tmp/Eisvogel.zip"
    local extract_path="/tmp/Eisvogel"

    # Descargar
    echo -e "\033[36mDescargando Eisvogel...\033[0m"
    if ! $download_cmd "$zip_path" "$url"; then
        echo -e "\033[31mError al descargar Eisvogel\033[0m" >&2
        return 1
    fi

    # Extraer
    echo -e "\033[36mExtrayendo archivos...\033[0m"
    if command -v unzip &> /dev/null; then
        rm -rf "$extract_path"
        unzip -q "$zip_path" -d "$extract_path"
    else
        echo -e "\033[31mError: Se necesita unzip para extraer el archivo\033[0m" >&2
        echo "Instala unzip: sudo apt install unzip (Ubuntu/Debian)"
        return 1
    fi

    # Buscar eisvogel.latex y copiarlo
    local eisvogel_file
    eisvogel_file=$(find "$extract_path" -name "eisvogel.latex" | head -n 1)

    if [[ -n "$eisvogel_file" ]]; then
        cp "$eisvogel_file" "$eisvogel_path"
        echo -e "\033[32mEisvogel instalado correctamente en: $eisvogel_path\033[0m"

        # Limpiar archivos temporales
        rm -f "$zip_path"
        rm -rf "$extract_path"

        return 0
    else
        echo -e "\033[31mError: No se pudo encontrar eisvogel.latex en el archivo descargado\033[0m" >&2
        return 1
    fi
}

# Decidir template
if [[ "$TEMPLATE" == "eisvogel" ]]; then
    echo -e "\033[33mUsando template Eisvogel\033[0m"

    eisvogel_path="$HOME/.pandoc/templates/eisvogel.latex"

    # Si no existe, instalarlo automáticamente
    if [[ ! -f "$eisvogel_path" ]]; then
        if ! install_eisvogel; then
            exit 1
        fi
    fi

    # Usar ruta completa del template
    "$pandoc_cmd" "$INPUT_FILE" -o "$OUTPUT_FILE" --template "$eisvogel_path" --pdf-engine="$pdf_engine"

else
    echo -e "\033[33mUsando configuración por defecto\033[0m"

    # Buscar pandoc-config.yaml
    config_locations=(
        "./pandoc-config.yaml"
        "$(dirname "$0")/pandoc-config.yaml"
        "$HOME/Documents/Pandoc-Docs/pandoc-config.yaml"
    )

    config_file=""
    for loc in "${config_locations[@]}"; do
        if [[ -f "$loc" ]]; then
            config_file="$loc"
            echo -e "\033[33mUsando config: $config_file\033[0m"
            break
        fi
    done

    if [[ -n "$config_file" ]]; then
        "$pandoc_cmd" "$INPUT_FILE" -o "$OUTPUT_FILE" --pdf-engine="$pdf_engine" --defaults="$config_file"
    else
        "$pandoc_cmd" "$INPUT_FILE" -o "$OUTPUT_FILE" \
            --pdf-engine="$pdf_engine" \
            --toc \
            --toc-depth=3 \
            --number-sections \
            -V geometry:margin=2.5cm \
            -V fontsize=11pt \
            -V lang:spanish \
            -V colorlinks=true \
            -V linkcolor=Blue \
            -V urlcolor=Blue \
            -V documentclass=report
    fi
fi

if [[ $? -eq 0 ]]; then
    echo ""
    echo -e "\033[32mPDF generado: $OUTPUT_FILE\033[0m"

    read -p "¿Abrir PDF? (s/n): " abrir
    if [[ "$abrir" == "s" || "$abrir" == "S" || "$abrir" == "" ]]; then
        # Intentar abrir con diferentes visores PDF
        if command -v xdg-open &> /dev/null; then
            xdg-open "$OUTPUT_FILE"
        elif command -v evince &> /dev/null; then
            evince "$OUTPUT_FILE" &
        elif command -v okular &> /dev/null; then
            okular "$OUTPUT_FILE" &
        elif command -v zathura &> /dev/null; then
            zathura "$OUTPUT_FILE" &
        elif command -v mupdf &> /dev/null; then
            mupdf "$OUTPUT_FILE" &
        else
            echo "No se encontró un visor PDF. Abre manualmente: $OUTPUT_FILE"
        fi
    fi
else
    echo -e "\033[31mError al generar PDF\033[0m" >&2
    exit 1
fi