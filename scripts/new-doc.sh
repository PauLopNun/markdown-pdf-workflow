#!/bin/bash

# Script para crear plantillas de Markdown con metadatos
# Uso: ./new-doc.sh nombre-documento [--style eisvogel|simple]

# Función de ayuda
show_help() {
    echo "Uso: ./new-doc.sh nombre-documento [--style eisvogel|simple]"
    echo ""
    echo "Opciones:"
    echo "  --style|-s    Estilo del documento (eisvogel o simple). Por defecto: simple"
    echo "  --help|-h     Mostrar esta ayuda"
    echo ""
    echo "Ejemplos:"
    echo "  ./new-doc.sh mi-documento"
    echo "  ./new-doc.sh mi-practica --style eisvogel"
    exit 0
}

# Valores por defecto
DOCUMENT_NAME=""
STYLE="simple"

# Procesar argumentos
while [[ $# -gt 0 ]]; do
    case $1 in
        --style|-s)
            STYLE="$2"
            if [[ "$STYLE" != "eisvogel" && "$STYLE" != "simple" ]]; then
                echo "Error: Estilo debe ser 'eisvogel' o 'simple'" >&2
                exit 1
            fi
            shift 2
            ;;
        --help|-h)
            show_help
            ;;
        *)
            if [[ -z "$DOCUMENT_NAME" ]]; then
                DOCUMENT_NAME="$1"
            else
                echo "Error: Argumento desconocido: $1" >&2
                exit 1
            fi
            shift
            ;;
    esac
done

# Verificar que se proporcionó el nombre del documento
if [[ -z "$DOCUMENT_NAME" ]]; then
    echo "Error: Debes proporcionar un nombre de documento" >&2
    echo "Uso: ./new-doc.sh nombre-documento [--style eisvogel|simple]"
    exit 1
fi

# Limpiar el nombre del archivo
filename="${DOCUMENT_NAME%.md}.md"

# Verificar si ya existe
if [[ -f "$filename" ]]; then
    read -p "El archivo '$filename' ya existe. ¿Sobrescribir? (s/n): " overwrite
    if [[ "$overwrite" != "s" && "$overwrite" != "S" ]]; then
        echo "Operación cancelada"
        exit 0
    fi
fi

autor="Pau Lopez Nunez"
fecha=$(date +"%d.%m.%Y")

# Plantilla simple (para uso con pandoc-config.yaml)
read -r -d '' template_simple << 'EOF'
---
title: "FILENAME"
author: "AUTOR"
date: "FECHA"
subject: "Desarrollo de Aplicaciones Multiplataforma"
keywords: ["keyword1", "keyword2"]
---

# Introduccion

Escribe aqui tu contenido...

## Seccion 1

Mas contenido...

\newpage

# Conclusiones

Conclusiones finales...

# Referencias

- Referencia 1
- Referencia 2
EOF

# Plantilla Eisvogel (con opciones fancy y mejor visibilidad)
read -r -d '' template_eisvogel << 'EOF'
---
title: "FILENAME"
author: "AUTOR"
date: "FECHA"
subject: "Desarrollo de Aplicaciones Multiplataforma"
titlepage: true
titlepage-rule-height: 0
titlepage-text-color: "FFFFFF"
titlepage-rule-color: "FFFFFF"
# titlepage-background: ./portada.jpg
# page-background: ./watermark.jpg
toc: true
toc-own-page: true
disable-header-and-footer: false
---

# Introduccion

Escribe aqui tu contenido...

## Objetivos

- Objetivo 1
- Objetivo 2

## Seccion 1

Mas contenido...

\newpage

# Desarrollo

Contenido del desarrollo...

\newpage

# Conclusiones

Conclusiones finales...

# Referencias

- Referencia 1
- Referencia 2
EOF

# Seleccionar plantilla según estilo
if [[ "$STYLE" == "eisvogel" ]]; then
    content="$template_eisvogel"
    echo -e "\033[36mCreando documento con estilo Eisvogel...\033[0m"
else
    content="$template_simple"
    echo -e "\033[36mCreando documento con estilo simple...\033[0m"
fi

# Reemplazar variables en el contenido
content="${content//FILENAME/$filename}"
content="${content//AUTOR/$autor}"
content="${content//FECHA/$fecha}"

# Crear archivo con encoding UTF-8
echo "$content" > "$filename"

echo -e "\033[32mDocumento creado: $filename\033[0m"

if [[ "$STYLE" == "eisvogel" ]]; then
    echo ""
    echo -e "\033[33mEl documento incluye configuración para títulos visibles (texto blanco):\033[0m"
    echo -e "\033[37m  titlepage-text-color: FFFFFF\033[0m"
    echo -e "\033[37m  titlepage-rule-color: FFFFFF\033[0m"
    echo ""
    echo -e "\033[33mPara añadir imágenes de fondo (comentadas con #):\033[0m"
    echo -e "\033[37m  1. Guarda imágenes OSCURAS como 'portada.jpg' y 'watermark.jpg'\033[0m"
    echo -e "\033[37m  2. Quita el # de esas líneas en el documento\033[0m"
    echo ""
    echo -e "\033[36mTIP: Usa imágenes de fondo oscuras para que el título blanco se vea bien\033[0m"
    echo ""
fi

echo -e "\033[36mPara convertir a PDF:\033[0m"
if [[ "$STYLE" == "eisvogel" ]]; then
    echo -e "\033[37m  ./convert.sh $filename --template eisvogel\033[0m"
else
    echo -e "\033[37m  ./convert.sh $filename\033[0m"
fi

# Preguntar si abrir el archivo
echo ""
read -p "¿Abrir el archivo para editar? (s/n): " abrir
if [[ "$abrir" == "s" || "$abrir" == "S" ]]; then
    # Intentar abrir con diferentes editores
    if command -v code &> /dev/null; then
        code "$filename"
    elif command -v nano &> /dev/null; then
        nano "$filename"
    elif command -v vim &> /dev/null; then
        vim "$filename"
    elif command -v gedit &> /dev/null; then
        gedit "$filename" &
    else
        echo "No se encontró un editor compatible. Abre manualmente: $filename"
    fi
fi