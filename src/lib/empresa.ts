/**
 * Los datos de la empresa, en un solo sitio.
 *
 * Aparecen en los términos, en la privacidad, en el contacto y en el
 * schema de la portada. Repartidos por cuatro páginas acabarían
 * divergiendo, y en documentos legales una dirección desactualizada no
 * es un detalle de mantenimiento.
 *
 * Lo que no está aquí es porque NO SE INVENTA. Si algún día hay
 * dirección física o teléfono, se añaden; hasta entonces las páginas
 * simplemente no los mencionan. Un dato de contacto falso en una
 * política de privacidad es peor que no tener política.
 */

export const EMPRESA = {
  nombreLegal: 'SA&VE Comercial, S.R.L.',
  nombreComercial: 'SAVE Documentos',
  rnc: '132-28618-9',
  ciudad: 'Punta Cana',
  pais: 'República Dominicana',
  correo: 'info@savedocumentos.com',
  dominio: 'savedocumentos.com',
  url: 'https://savedocumentos.com',
} as const

/** Última vez que se revisaron los términos y la política de privacidad. */
export const VIGENCIA_LEGAL = '5 de septiembre de 2026'

/**
 * Las leyes dominicanas que enmarcan lo que hace SAVE. Se citan en las
 * páginas legales; tenerlas aquí evita que una cambie en un sitio y no
 * en el otro.
 */
export const LEYES = {
  datos: {
    numero: 'Ley 172-13',
    titulo: 'sobre Protección Integral de los Datos Personales',
    fecha: '13 de diciembre de 2013',
  },
  comercioElectronico: {
    numero: 'Ley 126-02',
    titulo: 'sobre Comercio Electrónico, Documentos y Firmas Digitales',
    fecha: '14 de agosto de 2002',
  },
} as const
