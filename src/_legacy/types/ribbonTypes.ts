export type RibbonTab =
  | 'FILE' // Archivo (Backstage)
  | 'HOME' // Inicio
  | 'INSERT' // Insertar
  | 'DESIGN' // Diseño
  | 'LAYOUT' // Disposición / Diseño de página
  | 'REFERENCES' // Referencias
  | 'MAILINGS' // Correspondencia
  | 'REVIEW' // Revisar
  | 'VIEW' // Vista
  | 'HELP' // Ayuda
  | 'DEVELOPER' // Desarrollador
  | 'CTX_STAMP' // Contextual: Formato de Sello/Firma
  | 'CTX_TABLE' // Contextual: Diseño de Tabla
  | 'CTX_HEADER'; // Contextual: Encabezado y Pie

export type FontFamily = 'serif' | 'sans' | 'mono';
export type PageColor = 'WHITE' | 'IVORY' | 'PARCHMENT' | 'COLD_GRAY';
export type PageBorder = 'NONE' | 'SINGLE' | 'DOUBLE_NOTARIAL' | 'GOLDEN_BORDER';
export type WatermarkType =
  | 'NONE'
  | 'BORRADOR'
  | 'COPIA NOTARIAL'
  | 'ORIGINAL AUTÉNTICO'
  | 'CONFIDENCIAL'
  | 'USO EXCLUSIVO'
  | 'CUSTOM';

export type PaperSize = 'LETTER' | 'LEGAL' | 'A4';
export type PageOrientation = 'PORTRAIT' | 'LANDSCAPE';
export type PageMargins = 'NORMAL' | 'NARROW' | 'WIDE';
export type TextAlignment = 'left' | 'center' | 'right' | 'justify';

export interface DocumentStyleState {
  fontFamily: FontFamily;
  fontSize: number; // in pt, e.g. 11, 12, 14
  lineHeight: number; // 1.0, 1.15, 1.5, 2.0
  textAlign: TextAlignment;
  isBold: boolean;
  isItalic: boolean;
  isUnderline: boolean;
  isStrikethrough: boolean;
  textColor: string; // hex or tailwind class
  highlightColor: string; // 'none' | 'yellow' | 'green' | 'cyan' | 'pink'
  theme: 'NOTARIAL_CLASSIC' | 'CORPORATE_MODERN' | 'CIVIL_LITIGATION' | 'GOLDEN_SOLEMN';
  pageColor: PageColor;
  pageBorder: PageBorder;
  watermark: WatermarkType;
  customWatermarkText: string;
  paperSize: PaperSize;
  orientation: PageOrientation;
  margins: PageMargins;
  columns: 1 | 2;
  showRuler: boolean;
  showGridlines: boolean;
  showNavigationPane: boolean;
  showNotarialHeader: boolean;
  showNotarialFooter: boolean;
  showNotarialStamp: boolean;
  showQRCode: boolean;
  showSignatures: boolean;
  isProtected: boolean;
  viewLayout: 'PAGINATED' | 'CONTINUOUS' | 'READING_MODE' | 'TWO_PAGES';
  zoom: number;
}

export const DEFAULT_DOCUMENT_STYLE: DocumentStyleState = {
  fontFamily: 'serif',
  fontSize: 12,
  lineHeight: 1.5,
  textAlign: 'justify',
  isBold: false,
  isItalic: false,
  isUnderline: false,
  isStrikethrough: false,
  textColor: '#0f172a',
  highlightColor: 'none',
  theme: 'NOTARIAL_CLASSIC',
  pageColor: 'WHITE',
  pageBorder: 'SINGLE',
  watermark: 'NONE',
  customWatermarkText: 'COPIA OFICIAL',
  paperSize: 'LEGAL',
  orientation: 'PORTRAIT',
  margins: 'NORMAL',
  columns: 1,
  showRuler: true,
  showGridlines: false,
  showNavigationPane: false,
  showNotarialHeader: true,
  showNotarialFooter: true,
  showNotarialStamp: true,
  showQRCode: true,
  showSignatures: true,
  isProtected: false,
  viewLayout: 'PAGINATED',
  zoom: 100,
};
