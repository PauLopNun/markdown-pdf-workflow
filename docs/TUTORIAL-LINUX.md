---
title: "Guía Rápida: Markdown a PDF Profesional - Linux"
author: "Pau López Núñez"
date: "01.10.2025"
subject: "Tutorial de Conversión MD a PDF"
titlepage: true
titlepage-rule-height: 0
toc: true
toc-own-page: true
titlepage-background: ./portada.jpg
page-background: ./watermark.jpg
---

# Requisitos Previos

Antes de empezar, necesitas tener instalado:

- **Pandoc** - Conversor de documentos
- **TeX Live** - Distribución LaTeX completa

## Instalación por Distribución

### Ubuntu/Debian:
```bash
sudo apt update
sudo apt install pandoc texlive-full unzip wget
```

### Fedora/RHEL:
```bash
sudo dnf install pandoc texlive-scheme-full unzip wget
```

### Arch Linux:
```bash
sudo pacman -S pandoc texlive-most unzip wget
```

## Archivos Necesarios

Para trabajar necesitas estos archivos en tu carpeta de trabajo:

1. `convert.sh` - Convierte Markdown a PDF
2. `new-doc.sh` - Crea plantillas automáticamente

## Ubicación Recomendada

Guarda los scripts en: `~/bin` o `/usr/local/bin`

Añade `~/bin` al PATH editando `~/.bashrc`:
```bash
export PATH="$HOME/bin:$PATH"
```

\newpage

# Comandos Básicos

## Crear Nuevo Documento

### Documento simple:
```bash
./new-doc.sh nombre-documento
```

### Documento con estilo Eisvogel (más profesional):
```bash
./new-doc.sh nombre-documento --style eisvogel
```

## Convertir a PDF

### Conversión simple:
```bash
./convert.sh documento.md
```

### Conversión con Eisvogel:
```bash
./convert.sh documento.md --template eisvogel
```

\newpage

# Workflow Completo

## Proceso paso a paso:

**PASO 1: Hacer ejecutables (solo primera vez)**
```bash
chmod +x new-doc.sh convert.sh
```

**PASO 2: Crear documento**
```bash
./new-doc.sh mi-practica --style eisvogel
```

**PASO 3: Editar contenido**

El archivo se abre automáticamente, o ábrelo con tu editor preferido.

**PASO 4: Convertir a PDF**
```bash
./convert.sh mi-practica.md --template eisvogel
```

**PASO 5: El PDF se genera automáticamente**

El script pregunta si quieres abrirlo al terminar.

\newpage

# Añadir Imágenes de Fondo

## Configuración (Opcional)

Los documentos Eisvogel incluyen estas líneas comentadas en el YAML:

```yaml
# titlepage-background: ./portada.jpg
# page-background: ./watermark.jpg
```

## Para usarlas:

1. Guarda tus imágenes como `portada.jpg` y `watermark.jpg`
2. Ponlas en la misma carpeta que tu `.md`
3. Edita el `.md` y quita el `#` de esas líneas
4. Convierte de nuevo a PDF

**Nota:** Si no tienes imágenes, deja las líneas comentadas (con `#`). El PDF se generará igual sin ellas.

\newpage

# Diferencias entre Estilos

## Estilo Simple (por defecto)

- Más rápido
- Diseño limpio y minimalista
- Ideal para documentos técnicos
- Configuración básica integrada

**Uso:**
```bash
./new-doc.sh documento
./convert.sh documento.md
```

## Estilo Eisvogel

- Portada profesional
- Tabla de contenidos en página separada
- Soporta imágenes de fondo
- Más visual y elegante
- Se descarga automáticamente la primera vez

**Uso:**
```bash
./new-doc.sh documento --style eisvogel
./convert.sh documento.md --template eisvogel
```

\newpage

# Ejemplos Prácticos

## Crear práctica de clase:

```bash
./new-doc.sh practica-android --style eisvogel
# Editar contenido en el archivo
./convert.sh practica-android.md --template eisvogel
```

## Crear documento rápido:

```bash
./new-doc.sh apuntes
# Editar contenido
./convert.sh apuntes.md
```

## Crear tutorial con imágenes:

```bash
./new-doc.sh tutorial --style eisvogel
# Guardar portada.jpg en la carpeta
# Editar tutorial.md y descomentar línea de portada
./convert.sh tutorial.md --template eisvogel
```

\newpage

# Solución de Problemas

## Error: "Pandoc no encontrado"

**Solución por distribución:**
- **Ubuntu/Debian:** `sudo apt install pandoc`
- **Fedora/RHEL:** `sudo dnf install pandoc`
- **Arch:** `sudo pacman -S pandoc`

## Error: "No se encontró motor LaTeX"

**Solución por distribución:**
- **Ubuntu/Debian:** `sudo apt install texlive-full`
- **Fedora/RHEL:** `sudo dnf install texlive-scheme-full`
- **Arch:** `sudo pacman -S texlive-most`

## Error: "Permission denied"

**Solución:** Hacer el script ejecutable:
```bash
chmod +x new-doc.sh convert.sh
```

## El PDF tiene errores de formato

**Soluciones:**
- Verifica que el YAML esté bien escrito (sintaxis correcta)
- Asegúrate de que las imágenes existan si las referencias
- Revisa que no falten comillas en los valores del YAML

## Primera conversión muy lenta

**Explicación:** TeX Live descarga paquetes adicionales la primera vez. Las siguientes conversiones serán rápidas.

\newpage

# Tips y Trucos

## Consejos útiles:

- Los archivos `.md` son texto plano, usa cualquier editor
- Usa `\newpage` para forzar saltos de página
- Las imágenes de fondo son completamente opcionales
- Eisvogel se instala automáticamente la primera vez que lo uses
- Puedes personalizar autor y fecha editando `new-doc.sh`
- El encoding es UTF-8, respeta acentos y ñ
- Para bloques de código, especifica el lenguaje para resaltado de sintaxis

## Editores recomendados:

- **VS Code:** `code archivo.md`
- **Vim:** `vim archivo.md`
- **Nano:** `nano archivo.md`
- **Gedit:** `gedit archivo.md`

## Formato de código con sintaxis:

````markdown
```python
def hola():
    print("Hola mundo")
```
````

## Tablas en Markdown:

```markdown
| Columna 1 | Columna 2 | Columna 3 |
|-----------|-----------|-----------|
| Dato 1    | Dato 2    | Dato 3    |
| Dato 4    | Dato 5    | Dato 6    |
```

\newpage

# Resumen de Comandos

## Comandos esenciales:

**Hacer ejecutables (solo primera vez):**
```bash
chmod +x new-doc.sh convert.sh
```

**Crear documento:**
```bash
./new-doc.sh nombre [--style eisvogel]
```

**Convertir a PDF:**
```bash
./convert.sh nombre.md [--template eisvogel]
```

## Eso es todo

Simple y rápido. Con estos dos comandos puedes crear documentos profesionales en segundos.

# Referencias

- Documentación de Pandoc: https://pandoc.org/
- Plantilla Eisvogel: https://github.com/Wandmalfarbe/pandoc-latex-template
- Sintaxis Markdown: https://www.markdownguide.org/
- TeX Live: https://www.tug.org/texlive/