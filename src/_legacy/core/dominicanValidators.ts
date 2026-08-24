/**
 * Dominican Republic Legal Validators & Notarial Text Formatters
 * SAVE Platform v2.0
 */

/**
 * Validates Dominican JCE Cédula using Luhn Modulo 10 Algorithm
 * Standard format: 000-0000000-0 (11 digits)
 */
export function validateCedulaDominicana(cedula: string): {
  isValid: boolean;
  cleanCedula: string;
  formatted: string;
  error?: string;
} {
  if (!cedula) {
    return { isValid: false, cleanCedula: '', formatted: '', error: 'La cédula es requerida' };
  }

  const clean = cedula.replace(/\D/g, '');

  if (clean.length !== 11) {
    return {
      isValid: false,
      cleanCedula: clean,
      formatted: cedula,
      error: `Debe contener exactamente 11 dígitos numéricos (actualmente tiene ${clean.length})`,
    };
  }

  // All zeros or impossible series
  if (/^0+$/.test(clean)) {
    return { isValid: false, cleanCedula: clean, formatted: cedula, error: 'Cédula no válida' };
  }

  const digits = clean.split('').map(Number);
  const checkDigit = digits[10];
  const weights = [1, 2, 1, 2, 1, 2, 1, 2, 1, 2];

  let sum = 0;
  for (let i = 0; i < 10; i++) {
    let product = digits[i] * weights[i];
    if (product >= 10) {
      product = Math.floor(product / 10) + (product % 10);
    }
    sum += product;
  }

  const calculatedCheckDigit = (10 - (sum % 10)) % 10;
  const isValid = calculatedCheckDigit === checkDigit;

  const formatted = `${clean.slice(0, 3)}-${clean.slice(3, 10)}-${clean.slice(10, 11)}`;

  return {
    isValid,
    cleanCedula: clean,
    formatted,
    error: isValid ? undefined : `Dígito verificador inválido (esperado: ${calculatedCheckDigit}, recibido: ${checkDigit})`,
  };
}

/**
 * Format string as Dominican Cédula 000-0000000-0
 */
export function formatCedulaInput(value: string): string {
  const clean = value.replace(/\D/g, '').slice(0, 11);
  if (clean.length <= 3) return clean;
  if (clean.length <= 10) return `${clean.slice(0, 3)}-${clean.slice(3)}`;
  return `${clean.slice(0, 3)}-${clean.slice(3, 10)}-${clean.slice(10, 11)}`;
}

/**
 * Validates Dominican DGII RNC (Registro Nacional del Contribuyente)
 * Formats: 9 digits for corporations, or 11 digits (Cédula) for natural persons.
 */
export function validateRNC(rnc: string): {
  isValid: boolean;
  cleanRNC: string;
  type: 'PERSONA_JURIDICA' | 'PERSONA_FISICA' | 'INVALID';
  error?: string;
} {
  if (!rnc) {
    return { isValid: false, cleanRNC: '', type: 'INVALID', error: 'El RNC es requerido' };
  }

  const clean = rnc.replace(/\D/g, '');

  if (clean.length === 11) {
    const cedulaCheck = validateCedulaDominicana(clean);
    return {
      isValid: cedulaCheck.isValid,
      cleanRNC: clean,
      type: 'PERSONA_FISICA',
      error: cedulaCheck.error,
    };
  }

  if (clean.length === 9) {
    const digits = clean.split('').map(Number);
    const checkDigit = digits[8];
    const weights = [7, 9, 8, 6, 5, 4, 3, 2];

    let sum = 0;
    for (let i = 0; i < 8; i++) {
      sum += digits[i] * weights[i];
    }

    const remainder = sum % 11;
    let expectedCheck: number;
    if (remainder === 0) {
      expectedCheck = 2;
    } else if (remainder === 1) {
      expectedCheck = 1;
    } else {
      expectedCheck = 11 - remainder;
    }

    const isValid = expectedCheck === checkDigit;

    return {
      isValid,
      cleanRNC: clean,
      type: 'PERSONA_JURIDICA',
      error: isValid ? undefined : `Dígito verificador de RNC inválido (esperado: ${expectedCheck}, recibido: ${checkDigit})`,
    };
  }

  return {
    isValid: false,
    cleanRNC: clean,
    type: 'INVALID',
    error: 'El RNC debe tener 9 dígitos (empresas) o 11 dígitos (personas físicas)',
  };
}

/**
 * Converts integers and decimals to written Spanish words
 */
function unCentenas(num: number): string {
  const unidades = ['', 'UN', 'DOS', 'TRES', 'CUATRO', 'CINCO', 'SEIS', 'SIETE', 'OCHO', 'NUEVE'];
  const especiales = [
    'DIEZ',
    'ONCE',
    'DOCE',
    'TRECE',
    'CATORCE',
    'QUINCE',
    'DIECISÉIS',
    'DIECISIETE',
    'DIECIOCHO',
    'DIECINUEVE',
    'VEINTE',
    'VEINTIUNO',
    'VEINTIDÓS',
    'VEINTITRÉS',
    'VEINTICUATRO',
    'VEINTICINCO',
    'VEINTISÉIS',
    'VEINTISIETE',
    'VEINTIOCHO',
    'VEINTINUEVE',
  ];
  const decenas = ['', 'DIEZ', 'VEINTE', 'TREINTA', 'CUARENTA', 'CINCUENTA', 'SESENTA', 'SETENTA', 'OCHENTA', 'NOVENTA'];
  const centenas = [
    '',
    'CIENTO',
    'DOSCIENTOS',
    'TRESCIENTOS',
    'CUATROCIENTOS',
    'QUINIENTOS',
    'SEISCIENTOS',
    'SETECIENTOS',
    'OCHOCIENTOS',
    'NOVECIENTOS',
  ];

  if (num === 0) return '';
  if (num === 100) return 'CIEN';

  let result = '';
  const c = Math.floor(num / 100);
  const d = Math.floor((num % 100) / 10);
  const u = num % 10;
  const du = num % 100;

  if (c > 0) {
    result += centenas[c] + ' ';
  }

  if (du >= 10 && du <= 29) {
    result += especiales[du - 10];
  } else {
    if (d > 0) {
      result += decenas[d];
      if (u > 0) result += ' Y ';
    }
    if (u > 0 && d !== 2) {
      result += unidades[u];
    }
  }

  return result.trim();
}

/**
 * Converts integer numbers up to billions into Spanish words
 */
export function enteroALetras(n: number): string {
  if (n === 0) return 'CERO';
  if (n < 0) return 'MENOS ' + enteroALetras(Math.abs(n));

  const millones = Math.floor(n / 1000000);
  const miles = Math.floor((n % 1000000) / 1000);
  const resto = n % 1000;

  let texto = '';

  if (millones > 0) {
    if (millones === 1) {
      texto += 'UN MILLÓN ';
    } else {
      texto += enteroALetras(millones) + ' MILLONES ';
    }
  }

  if (miles > 0) {
    if (miles === 1) {
      texto += 'UN MIL ';
    } else {
      texto += unCentenas(miles) + ' MIL ';
    }
  }

  if (resto > 0) {
    texto += unCentenas(resto);
  }

  return texto.trim();
}

/**
 * Converts numeric amount to legal Dominican Spanish representation
 * Example: 30000, "DOP" -> "TREINTA MIL PESOS DOMINICANOS CON 00/100 (RD$30,000.00)"
 */
export function montoALetras(
  monto: number | string,
  moneda: 'DOP' | 'USD' | 'EUR' = 'DOP',
  incluirMontoNumerico = true
): string {
  const num = typeof monto === 'string' ? parseFloat(monto.replace(/[^\d.-]/g, '')) : monto;
  if (isNaN(num)) return '';

  const entero = Math.floor(Math.abs(num));
  const centavos = Math.round((Math.abs(num) - entero) * 100);
  const centavosStr = centavos.toString().padStart(2, '0') + '/100';

  const textoEntero = enteroALetras(entero);

  let nombreMoneda = 'PESOS DOMINICANOS';
  let simbolo = 'RD$';

  if (moneda === 'USD') {
    nombreMoneda = entero === 1 ? 'DÓLAR ESTADOUNIDENSE' : 'DÓLARES ESTADOUNIDENSES';
    simbolo = 'US$';
  } else if (moneda === 'EUR') {
    nombreMoneda = 'EUROS';
    simbolo = '€';
  } else {
    nombreMoneda = entero === 1 ? 'PESO DOMINICANO' : 'PESOS DOMINICANOS';
  }

  const textoFinal = `${textoEntero} ${nombreMoneda} CON ${centavosStr}`;

  if (incluirMontoNumerico) {
    const formattedNum = new Intl.NumberFormat('es-DO', {
      minimumFractionDigits: 2,
      maximumFractionDigits: 2,
    }).format(num);
    return `${textoFinal} (${simbolo}${formattedNum})`;
  }

  return textoFinal;
}

/**
 * Converts date to notarial Dominican Spanish solemn legal clause
 * Example: "2026-08-15" -> "a los quince (15) días del mes de agosto del año dos mil veintiséis (2026)"
 */
export function fechaALetrasNotarial(fechaStr: string): string {
  if (!fechaStr) return '';
  const date = new Date(fechaStr + 'T12:00:00');
  if (isNaN(date.getTime())) return fechaStr;

  const dia = date.getDate();
  const mesIndex = date.getMonth();
  const anio = date.getFullYear();

  const meses = [
    'enero',
    'febrero',
    'marzo',
    'abril',
    'mayo',
    'junio',
    'julio',
    'agosto',
    'septiembre',
    'octubre',
    'noviembre',
    'diciembre',
  ];

  const diaTexto = dia === 1 ? 'primer (1er)' : `${enteroALetras(dia).toLowerCase()} (${dia})`;
  const anioTexto = `${enteroALetras(anio).toLowerCase()} (${anio})`;
  const mesNombre = meses[mesIndex];

  return `a los ${diaTexto} días del mes de ${mesNombre} del año ${anioTexto}`;
}

/**
 * Format currency value with symbol and locale
 */
export function formatCurrencyValue(monto: number | string, moneda: 'DOP' | 'USD' | 'EUR' = 'DOP'): string {
  const num = typeof monto === 'string' ? parseFloat(monto.replace(/[^\d.-]/g, '')) : monto;
  if (isNaN(num)) return '';

  const prefix = moneda === 'DOP' ? 'RD$' : moneda === 'USD' ? 'US$' : '€';
  const formatted = new Intl.NumberFormat('es-DO', {
    minimumFractionDigits: 2,
    maximumFractionDigits: 2,
  }).format(num);

  return `${prefix}${formatted}`;
}

export function validateDominicanCedula(cedula: string): { isValid: boolean; errorMessage?: string } {
  const res = validateCedulaDominicana(cedula);
  return { isValid: res.isValid, errorMessage: res.error };
}

export function validateDominicanRNC(rnc: string): { isValid: boolean; errorMessage?: string } {
  const res = validateRNC(rnc);
  return { isValid: res.isValid, errorMessage: res.error };
}

export const convertNumberToSpanishWords = montoALetras;
