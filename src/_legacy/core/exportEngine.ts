import JSZip from 'jszip';
import { jsPDF } from 'jspdf';
import { LegalTemplate, TemplateVariable } from '../types';

/**
 * Extracts plain text and paragraph structures from an uploaded .docx file
 */
export async function parseDocxFile(file: File): Promise<{
  text: string;
  paragraphs: string[];
  xmlRaw?: string;
}> {
  const arrayBuffer = await file.arrayBuffer();
  const zip = await JSZip.loadAsync(arrayBuffer);

  const documentXmlFile = zip.file('word/document.xml');
  if (!documentXmlFile) {
    throw new Error('El archivo no parece ser un documento DOCX válido (falta word/document.xml)');
  }

  const xmlContent = await documentXmlFile.async('text');

  // Simple XML parsing to extract <w:p> paragraphs and <w:t> texts
  const parser = new DOMParser();
  const xmlDoc = parser.parseFromString(xmlContent, 'application/xml');

  const pNodes = xmlDoc.getElementsByTagName('w:p');
  const paragraphs: string[] = [];

  for (let i = 0; i < pNodes.length; i++) {
    const tNodes = pNodes[i].getElementsByTagName('w:t');
    let pText = '';
    for (let j = 0; j < tNodes.length; j++) {
      pText += tNodes[j].textContent || '';
    }
    if (pText.trim()) {
      paragraphs.push(pText);
    }
  }

  const fullText = paragraphs.join('\n\n');
  return {
    text: fullText,
    paragraphs,
    xmlRaw: xmlContent,
  };
}

/**
 * Creates a valid OpenXML .docx file binary from generated text content
 */
export async function generateDocxBlob(title: string, content: string): Promise<Blob> {
  const zip = new JSZip();

  // 1. [Content_Types].xml
  zip.file(
    '[Content_Types].xml',
    `<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">
  <Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>
  <Default Extension="xml" ContentType="application/xml"/>
  <Override PartName="/word/document.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.document.main+xml"/>
</Types>`
  );

  // 2. _rels/.rels
  zip.file(
    '_rels/.rels',
    `<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="word/document.xml"/>
</Relationships>`
  );

  // 3. word/document.xml
  const paragraphs = content.split('\n\n');
  let bodyXml = '';

  for (const p of paragraphs) {
    const lines = p.split('\n');
    for (const line of lines) {
      if (!line.trim()) continue;

      // Escape XML characters
      const escaped = line
        .replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;')
        .replace(/"/g, '&quot;')
        .replace(/'/g, '&apos;');

      // Format legal headings (e.g. PRIMERO:, CLAUSULA, etc.)
      const isHeading =
        /^(PRIMERO|SEGUNDO|TERCERO|CUARTO|QUINTO|SEXTO|SÉPTIMO|OCTAVO|NOVENO|DÉCIMO|UNDÉCIMO|DUODÉCIMO|CONTRATO|ACTO|PODER)/i.test(
          line.trim()
        );

      bodyXml += `<w:p>
        <w:pPr>
          <w:jc w:val="${isHeading ? 'left' : 'both'}"/>
          <w:spacing w:line="276" w:lineRule="auto" w:before="120" w:after="120"/>
        </w:pPr>
        <w:r>
          <w:rPr>
            <w:rFonts w:ascii="Times New Roman" w:hAnsi="Times New Roman"/>
            <w:sz w:val="24"/>
            ${isHeading ? '<w:b/>' : ''}
          </w:rPr>
          <w:t xml:space="preserve">${escaped}</w:t>
        </w:r>
      </w:p>`;
    }
  }

  const documentXml = `<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<w:document xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
  <w:body>
    ${bodyXml}
    <w:sectPr>
      <w:pgSz w:w="12240" w:h="15840"/>
      <w:pgMar w:top="1440" w:right="1440" w:bottom="1440" w:left="1440"/>
    </w:sectPr>
  </w:body>
</w:document>`;

  zip.file('word/document.xml', documentXml);

  return await zip.generateAsync({ type: 'blob', mimeType: 'application/vnd.openxmlformats-officedocument.wordprocessingml.document' });
}

/**
 * Generates a clean PDF representation using jsPDF
 */
export function generatePdfBlob(title: string, content: string): Blob {
  const doc = new jsPDF({
    orientation: 'portrait',
    unit: 'mm',
    format: 'letter',
  });

  const pageWidth = doc.internal.pageSize.getWidth();
  const pageHeight = doc.internal.pageSize.getHeight();
  const margin = 20;
  const maxLineWidth = pageWidth - margin * 2;

  doc.setFont('times', 'normal');
  doc.setFontSize(11);

  const paragraphs = content.split('\n\n');
  let currentY = margin + 10;

  // Header
  doc.setFontSize(9);
  doc.setTextColor(100, 100, 100);
  doc.text('SAVE • Plataforma Documental Legal (República Dominicana)', margin, margin);
  doc.setDrawColor(200, 200, 200);
  doc.line(margin, margin + 2, pageWidth - margin, margin + 2);

  doc.setFontSize(11);
  doc.setTextColor(20, 20, 20);

  for (const para of paragraphs) {
    if (!para.trim()) continue;

    const lines = doc.splitTextToSize(para.trim(), maxLineWidth);

    // Check if new page is needed
    if (currentY + lines.length * 6 > pageHeight - margin - 15) {
      doc.addPage();
      currentY = margin + 10;
      doc.setFontSize(9);
      doc.setTextColor(100, 100, 100);
      doc.text('SAVE • Plataforma Documental Legal (República Dominicana)', margin, margin);
      doc.line(margin, margin + 2, pageWidth - margin, margin + 2);
      doc.setFontSize(11);
      doc.setTextColor(20, 20, 20);
    }

    // Check for bold headings
    const isHeading = /^(PRIMERO|SEGUNDO|TERCERO|CUARTO|QUINTO|SEXTO|SÉPTIMO|OCTAVO|NOVENO|DÉCIMO|CONTRATO|ACTO|PODER)/i.test(
      para.trim()
    );

    if (isHeading) {
      doc.setFont('times', 'bold');
    } else {
      doc.setFont('times', 'normal');
    }

    doc.text(lines, margin, currentY);
    currentY += lines.length * 5.5 + 4;
  }

  // Add page numbers
  const totalPages = doc.getNumberOfPages();
  for (let i = 1; i <= totalPages; i++) {
    doc.setPage(i);
    doc.setFontSize(9);
    doc.setTextColor(120, 120, 120);
    doc.text(`Página ${i} de ${totalPages}`, pageWidth / 2, pageHeight - margin / 2, {
      align: 'center',
    });
  }

  return doc.output('blob');
}

/**
 * Generates official schema.json compliant with Section 5 of Technical Spec
 */
export function generateSchemaJson(template: LegalTemplate): string {
  const properties: Record<string, any> = {};
  const required: string[] = [];

  for (const v of template.variables) {
    if (v.required) {
      required.push(v.tag);
    }

    properties[v.tag] = {
      type: v.dataType === 'number' || v.dataType === 'currency' || v.dataType === 'percentage' ? 'number' : 'string',
      title: v.label,
      description: v.description || v.label,
      'x-metadata': {
        id: v.id,
        category: v.category,
        dataType: v.dataType,
        required: v.required,
        currency: v.currency,
        gender: v.gender,
        role: v.role,
        derivedConfig: v.derivedConfig,
        originalValue: v.originalValue,
      },
    };

    if (v.dataType === 'cedula') {
      properties[v.tag].pattern = '^\\d{3}-\\d{7}-\\d{1}$';
      properties[v.tag].examples = ['001-0894561-2'];
    } else if (v.dataType === 'rnc') {
      properties[v.tag].pattern = '^\\d{9}$';
      properties[v.tag].examples = ['131849201'];
    }
  }

  const schemaObj = {
    $schema: 'http://json-schema.org/draft-07/schema#',
    title: `${template.name} Schema`,
    description: `Contrato de datos generado para plantilla legal dominicana (SAVE v2.0)`,
    templateId: template.id,
    version: template.version,
    jurisdiction: template.jurisdiction,
    type: 'object',
    required,
    properties,
    clauses: template.clauses.map((c) => ({
      id: c.id,
      title: c.title,
      category: c.category,
      conditionVariableId: c.conditionVariableId,
    })),
    rules: template.rules.map((r) => ({
      id: r.id,
      name: r.name,
      targetVariableId: r.targetVariableId,
      operator: r.operator,
      action: r.action,
    })),
  };

  return JSON.stringify(schemaObj, null, 2);
}
