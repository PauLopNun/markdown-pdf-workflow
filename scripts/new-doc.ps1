# Script para crear plantillas de Markdown con metadatos
# Uso: .\new-doc.ps1 nombre-documento [-Style eisvogel|simple]

param(
    [Parameter(Mandatory=$true)]
    [string]$DocumentName,
    
    [Parameter(Mandatory=$false)]
    [ValidateSet("eisvogel", "simple")]
    [string]$Style = "simple"
)

# Configurar encoding para UTF-8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

# Limpiar el nombre del archivo
$fileName = $DocumentName -replace '\.md$', ''
$fileName = "$fileName.md"

# Verificar si ya existe
if (Test-Path $fileName) {
    $overwrite = Read-Host "El archivo '$fileName' ya existe. Sobrescribir? (s/n)"
    if ($overwrite -ne "s" -and $overwrite -ne "S") {
        Write-Host "Operacion cancelada" -ForegroundColor Yellow
        exit 0
    }
}

$autor = "Pau Lopez Nunez"
$fecha = Get-Date -Format "dd.MM.yyyy"

# Plantilla simple (para uso con pandoc-config.yaml)
$templateSimple = @"
---
title: "$fileName"
author: "$autor"
date: "$fecha"
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
"@

# Plantilla Eisvogel (con opciones fancy y mejor visibilidad)
$templateEisvogel = @"
---
title: "$fileName"
author: "$autor"
date: "$fecha"
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
"@

# Seleccionar plantilla segun estilo
if ($Style -eq "eisvogel") {
    $content = $templateEisvogel
    Write-Host "Creando documento con estilo Eisvogel..." -ForegroundColor Cyan
} else {
    $content = $templateSimple
    Write-Host "Creando documento con estilo simple..." -ForegroundColor Cyan
}

# Crear archivo con encoding UTF-8
[System.IO.File]::WriteAllText((Join-Path $PWD $fileName), $content, [System.Text.Encoding]::UTF8)

Write-Host "Documento creado: $fileName" -ForegroundColor Green

if ($Style -eq "eisvogel") {
    Write-Host ""
    Write-Host "El documento incluye configuracion para titulos visibles (texto blanco):" -ForegroundColor Yellow
    Write-Host "  titlepage-text-color: FFFFFF" -ForegroundColor Gray
    Write-Host "  titlepage-rule-color: FFFFFF" -ForegroundColor Gray
    Write-Host ""
    Write-Host "Para anadir imagenes de fondo (comentadas con #):" -ForegroundColor Yellow
    Write-Host "  1. Guarda imagenes OSCURAS como 'portada.jpg' y 'watermark.jpg'" -ForegroundColor White
    Write-Host "  2. Quita el # de esas lineas en el documento" -ForegroundColor White
    Write-Host ""
    Write-Host "TIP: Usa imagenes de fondo oscuras para que el titulo blanco se vea bien" -ForegroundColor Cyan
    Write-Host ""
}

Write-Host "Para convertir a PDF:" -ForegroundColor Cyan
if ($Style -eq "eisvogel") {
    Write-Host "  .\convert.ps1 $fileName -Template eisvogel" -ForegroundColor White
} else {
    Write-Host "  .\convert.ps1 $fileName" -ForegroundColor White
}

# Preguntar si abrir el archivo
Write-Host ""
$abrir = Read-Host "Abrir el archivo para editar? (s/n)"
if ($abrir -eq "s" -or $abrir -eq "S") {
    if (Get-Command code -ErrorAction SilentlyContinue) {
        code $fileName
    } elseif (Get-Command notepad++ -ErrorAction SilentlyContinue) {
        notepad++ $fileName
    } else {
        notepad $fileName
    }
}