/**
 * Exportación a Word y PDF.
 *
 * El DOCX se construye a mano como OOXML dentro de un ZIP: es el formato
 * que Word abre de forma nativa, y jszip ya estaba en el proyecto. El
 * legado producía texto plano renombrado a .docx, que Word abre con un
 * aviso de archivo dañado.
 */

import JSZip from 'jszip'

/** Escapa lo que XML no admite en un nodo de texto. */
function xmlEscape(text: string): string {
  return text
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
}

/** Un título va centrado y en negrita; el resto justificado. */
function isHeading(line: string): boolean {
  const t = line.trim()
  if (t.length === 0 || t.length > 90) return false
  return t === t.toUpperCase() && /[A-ZÁÉÍÓÚÑ]/.test(t)
}

function paragraph(line: string): string {
  const text = xmlEscape(line)

  if (isHeading(line)) {
    return `<w:p><w:pPr><w:spacing w:before="240" w:after="120"/><w:jc w:val="center"/></w:pPr>` +
      `<w:r><w:rPr><w:b/></w:rPr><w:t xml:space="preserve">${text}</w:t></w:r></w:p>`
  }

  return `<w:p><w:pPr><w:spacing w:after="160" w:line="276" w:lineRule="auto"/><w:jc w:val="both"/></w:pPr>` +
    `<w:r><w:t xml:space="preserve">${text}</w:t></w:r></w:p>`
}

/**
 * Genera un .docx real. Devuelve el archivo como bytes para que una
 * Route Handler lo entregue.
 */
export async function buildDocx(title: string, content: string): Promise<Uint8Array> {
  const zip = new JSZip()

  zip.file(
    '[Content_Types].xml',
    `<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">
<Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>
<Default Extension="xml" ContentType="application/xml"/>
<Override PartName="/word/document.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.document.main+xml"/>
<Override PartName="/word/styles.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.styles+xml"/>
</Types>`
  )

  zip.folder('_rels')!.file(
    '.rels',
    `<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
<Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="word/document.xml"/>
</Relationships>`
  )

  const word = zip.folder('word')!

  word.folder('_rels')!.file(
    'document.xml.rels',
    `<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
<Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/styles" Target="styles.xml"/>
</Relationships>`
  )

  // Times New Roman 12pt: lo que espera un documento legal dominicano.
  word.file(
    'styles.xml',
    `<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<w:styles xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
<w:docDefaults><w:rPrDefault><w:rPr>
<w:rFonts w:ascii="Times New Roman" w:hAnsi="Times New Roman" w:cs="Times New Roman"/>
<w:sz w:val="24"/><w:szCs w:val="24"/><w:lang w:val="es-DO"/>
</w:rPr></w:rPrDefault></w:docDefaults>
</w:styles>`
  )

  const body = [title, '', ...content.split('\n')].map(paragraph).join('')

  word.file(
    'document.xml',
    `<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<w:document xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
<w:body>${body}
<w:sectPr><w:pgSz w:w="12240" w:h="15840"/><w:pgMar w:top="1440" w:right="1440" w:bottom="1440" w:left="1440"/></w:sectPr>
</w:body></w:document>`
  )

  return zip.generateAsync({ type: 'uint8array', compression: 'DEFLATE' })
}

/** Nombre de archivo seguro a partir del título del documento. */
export function safeFileName(title: string, extension: string): string {
  const base = title
    .normalize('NFD')
    .replace(/[\u0300-\u036f]/g, '')
    .replace(/[^a-zA-Z0-9]+/g, '-')
    .replace(/^-+|-+$/g, '')
    .slice(0, 80) || 'documento'
  return `${base}.${extension}`
}
