import JSZip from 'jszip';

export interface ParsedDocxResult {
  text: string;
  paragraphs: string[];
}

/**
 * Extracts raw legal text and paragraphs from a .docx binary file
 */
export async function parseDocxFile(file: File | Blob): Promise<ParsedDocxResult> {
  const arrayBuffer = await file.arrayBuffer();
  const zip = await JSZip.loadAsync(arrayBuffer);

  const documentXml = zip.file('word/document.xml');
  if (!documentXml) {
    throw new Error('El archivo proporcionado no es un archivo .docx válido (word/document.xml no encontrado)');
  }

  const xmlText = await documentXml.async('text');
  const parser = new DOMParser();
  const xmlDoc = parser.parseFromString(xmlText, 'text/xml');

  const pNodes = xmlDoc.getElementsByTagName('w:p');
  const paragraphs: string[] = [];

  for (let i = 0; i < pNodes.length; i++) {
    const pNode = pNodes[i];
    const tNodes = pNode.getElementsByTagName('w:t');
    let pText = '';
    for (let j = 0; j < tNodes.length; j++) {
      pText += tNodes[j].textContent || '';
    }
    if (pText.trim().length > 0) {
      paragraphs.push(pText.trim());
    }
  }

  const fullText = paragraphs.join('\n\n');

  return {
    text: fullText,
    paragraphs,
  };
}
