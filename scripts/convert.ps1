# Script de conversión MD → PDF con instalación automática de Eisvogel
# Uso: .\convert.ps1 archivo.md [-Template eisvogel]

param(
    [Parameter(Mandatory=$true)]
    [string]$InputFile,
    
    [Parameter(Mandatory=$false)]
    [string]$Template = "default"
)

# Verificar archivo
if (-not (Test-Path $InputFile)) {
    Write-Host "Error: '$InputFile' no existe" -ForegroundColor Red
    exit 1
}

$OutputFile = $InputFile -replace '\.md$', '.pdf'
Write-Host "Convirtiendo: $InputFile -> $OutputFile" -ForegroundColor Cyan

# Buscar Pandoc
$pandocPaths = @(
    "pandoc",
    "C:\Program Files\Pandoc\pandoc.exe",
    "C:\Program Files (x86)\Pandoc\pandoc.exe",
    "$env:LOCALAPPDATA\Pandoc\pandoc.exe"
)

$pandocCmd = $null
foreach ($path in $pandocPaths) {
    try {
        if ($path -eq "pandoc") {
            $null = Get-Command pandoc -ErrorAction Stop
            $pandocCmd = "pandoc"
            break
        } elseif (Test-Path $path) {
            $pandocCmd = $path
            break
        }
    } catch { continue }
}

if (-not $pandocCmd) {
    Write-Host "Error: Pandoc no encontrado" -ForegroundColor Red
    exit 1
}

# Buscar motor PDF
$pdfEngine = $null
$latexPaths = @(
    "C:\Users\paulo\AppData\Local\Programs\MiKTeX\miktex\bin\x64",
    "C:\Program Files\MiKTeX\miktex\bin\x64",
    "$env:LOCALAPPDATA\Programs\MiKTeX\miktex\bin\x64"
)

foreach ($path in $latexPaths) {
    if (Test-Path "$path\xelatex.exe") {
        $pdfEngine = "$path\xelatex.exe"
        break
    } elseif (Test-Path "$path\pdflatex.exe") {
        $pdfEngine = "$path\pdflatex.exe"
        break
    }
}

if (-not $pdfEngine) {
    Write-Host "Error: No se encontro xelatex ni pdflatex" -ForegroundColor Red
    exit 1
}

Write-Host "Usando motor PDF: $pdfEngine" -ForegroundColor Green

# Función para instalar Eisvogel automáticamente
function Install-Eisvogel {
    $templatesDir = "$HOME\.pandoc\templates"
    $eisvogelPath = "$templatesDir\eisvogel.latex"
    
    Write-Host "Eisvogel no encontrado. Descargando..." -ForegroundColor Yellow
    
    # Crear directorio si no existe
    if (-not (Test-Path $templatesDir)) {
        New-Item -ItemType Directory -Path $templatesDir -Force | Out-Null
    }
    
    try {
        # URL del último release de Eisvogel
        $url = "https://github.com/Wandmalfarbe/pandoc-latex-template/releases/latest/download/Eisvogel.zip"
        $zipPath = "$env:TEMP\Eisvogel.zip"
        $extractPath = "$env:TEMP\Eisvogel"
        
        # Descargar
        Write-Host "Descargando Eisvogel..." -ForegroundColor Cyan
        Invoke-WebRequest -Uri $url -OutFile $zipPath -UseBasicParsing
        
        # Extraer
        Write-Host "Extrayendo archivos..." -ForegroundColor Cyan
        Expand-Archive -Path $zipPath -DestinationPath $extractPath -Force
        
        # Buscar eisvogel.latex y copiarlo
        $eisvogelFile = Get-ChildItem -Path $extractPath -Filter "eisvogel.latex" -Recurse | Select-Object -First 1
        
        if ($eisvogelFile) {
            Copy-Item $eisvogelFile.FullName -Destination $eisvogelPath -Force
            Write-Host "Eisvogel instalado correctamente en: $eisvogelPath" -ForegroundColor Green
            
            # Limpiar archivos temporales
            Remove-Item $zipPath -Force -ErrorAction SilentlyContinue
            Remove-Item $extractPath -Recurse -Force -ErrorAction SilentlyContinue
            
            return $true
        } else {
            Write-Host "Error: No se pudo encontrar eisvogel.latex en el archivo descargado" -ForegroundColor Red
            return $false
        }
        
    } catch {
        Write-Host "Error al descargar Eisvogel: $_" -ForegroundColor Red
        Write-Host "Descargalo manualmente desde: https://github.com/Wandmalfarbe/pandoc-latex-template/releases/" -ForegroundColor Yellow
        return $false
    }
}

# Decidir template
if ($Template -eq "eisvogel") {
    Write-Host "Usando template Eisvogel" -ForegroundColor Yellow
    
    $eisvogelPath = "$HOME\.pandoc\templates\eisvogel.latex"
    
    # Si no existe, instalarlo automáticamente
    if (-not (Test-Path $eisvogelPath)) {
        $installed = Install-Eisvogel
        if (-not $installed) {
            exit 1
        }
    }
    
    # Usar ruta completa del template
    & $pandocCmd $InputFile -o $OutputFile --template $eisvogelPath --pdf-engine=$pdfEngine
    
} else {
    Write-Host "Usando configuracion por defecto" -ForegroundColor Yellow
    
    # Buscar pandoc-config.yaml
    $configLocations = @(
        ".\pandoc-config.yaml",
        "$PSScriptRoot\pandoc-config.yaml",
        "$HOME\Documents\Pandoc-Docs\pandoc-config.yaml"
    )
    
    $configFile = $null
    foreach ($loc in $configLocations) {
        if (Test-Path $loc) {
            $configFile = $loc
            Write-Host "Usando config: $configFile" -ForegroundColor Yellow
            break
        }
    }
    
    if ($configFile) {
        & $pandocCmd $InputFile -o $OutputFile --pdf-engine=$pdfEngine --defaults=$configFile
    } else {
        & $pandocCmd $InputFile -o $OutputFile --pdf-engine=$pdfEngine --toc --toc-depth=3 --number-sections -V geometry:margin=2.5cm -V fontsize=11pt -V lang:spanish -V colorlinks=true -V linkcolor=Blue -V urlcolor=Blue -V documentclass=report
    }
}

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "PDF generado: $OutputFile" -ForegroundColor Green
    
    $abrir = Read-Host "Abrir PDF? (s/n)"
    if ($abrir -eq "s" -or $abrir -eq "S" -or $abrir -eq "") {
        Start-Process $OutputFile
    }
} else {
    Write-Host "Error al generar PDF" -ForegroundColor Red
    exit 1
}