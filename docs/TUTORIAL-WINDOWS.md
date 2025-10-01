---
title: "Guía Rápida: Markdown a PDF Profesional"
author: "Pau López Núñez"
date: "30.09.2025"
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

- **Pandoc** - Descarga desde https://pandoc.org/installing.html
- **MiKTeX** - Descarga desde https://miktex.org/download

## Archivos Necesarios

Para trabajar necesitas estos archivos en tu carpeta de trabajo:

1. `convert.ps1` - Convierte Markdown a PDF
2. `new-doc.ps1` - Crea plantillas automáticamente

## Ubicación Recomendada

Guarda los scripts en: `C:\Users\TU_USUARIO\Scripts`

Añade esa carpeta al PATH de Windows para usar los comandos desde cualquier lugar.

\newpage

# Comandos Básicos

## Crear Nuevo Documento

### Documento simple:
```powershell
.\new-doc.ps1 nombre-documento
```

### Documento con estilo Eisvogel (más profesional):
```powershell
.\new-doc.ps1 nombre-documento -Style eisvogel
```

## Convertir a PDF

### Conversión simple:
```powershell
.\convert.ps1 documento.md
```

### Conversión con Eisvogel:
```powershell
.\convert.ps1 documento.md -Template eisvogel
```

\newpage

# Workflow Completo

## Proceso paso a paso:

**PASO 1: Crear documento**
```powershell
.\new-doc.ps1 mi-practica -Style eisvogel
```

**PASO 2: Editar contenido**

El archivo se abre automáticamente, o ábrelo con tu editor preferido.

**PASO 3: Convertir a PDF**
```powershell
.\convert.ps1 mi-practica.md -Template eisvogel
```

**PASO 4: El PDF se genera automáticamente**

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
```powershell
.\new-doc.ps1 documento
.\convert.ps1 documento.md
```

## Estilo Eisvogel

- Portada profesional
- Tabla de contenidos en página separada
- Soporta imágenes de fondo
- Más visual y elegante
- Se descarga automáticamente la primera vez

**Uso:**
```powershell
.\new-doc.ps1 documento -Style eisvogel
.\convert.ps1 documento.md -Template eisvogel
```

\newpage

# Ejemplos Prácticos

## Crear práctica de clase:

```powershell
.\new-doc.ps1 practica-android -Style eisvogel
# Editar contenido en el archivo
.\convert.ps1 practica-android.md -Template eisvogel
```

## Crear documento rápido:

```powershell
.\new-doc.ps1 apuntes
# Editar contenido
.\convert.ps1 apuntes.md
```

## Crear tutorial con imágenes:

```powershell
.\new-doc.ps1 tutorial -Style eisvogel
# Guardar portada.jpg en la carpeta
# Editar tutorial.md y descomentar línea de portada
.\convert.ps1 tutorial.md -Template eisvogel
```

\newpage

# Solución de Problemas

## Error: "Pandoc no encontrado"

**Solución:** Instala Pandoc desde https://pandoc.org/installing.html

## Error: "xelatex no encontrado"

**Solución:** 
- Instala MiKTeX desde https://miktex.org/download
- Añade MiKTeX al PATH de Windows


## El PDF tiene errores de formato

**Soluciones:**
- Verifica que el YAML esté bien escrito (sintaxis correcta)
- Asegúrate de que las imágenes existan si las referencias
- Revisa que no falten comillas en los valores del YAML

## Primera conversión muy lenta

**Explicación:** MiKTeX descarga paquetes adicionales la primera vez. Las siguientes conversiones serán rápidas.

\newpage

# Tips y Trucos

## Consejos útiles:

- Los archivos `.md` son texto plano, usa cualquier editor
- Usa `\newpage` para forzar saltos de página
- Las imágenes de fondo son completamente opcionales
- Eisvogel se instala automáticamente la primera vez que lo uses
- Puedes personalizar autor y fecha editando `new-doc.ps1`
- El encoding es UTF-8, respeta acentos y ñ
- Para bloques de código, especifica el lenguaje para resaltado de sintaxis

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

**Crear documento:**
```powershell
.\new-doc.ps1 nombre [-Style eisvogel]
```

**Convertir a PDF:**
```powershell
.\convert.ps1 nombre.md [-Template eisvogel]
```

## Eso es todo

Simple y rápido. Con estos dos comandos puedes crear documentos profesionales en segundos.

# Referencias

- Documentación de Pandoc: https://pandoc.org/
- Plantilla Eisvogel: https://github.com/Wandmalfarbe/pandoc-latex-template
- Sintaxis Markdown: https://www.markdownguide.org/