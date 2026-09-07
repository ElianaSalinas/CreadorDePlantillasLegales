/**
 * Traduce los errores de Supabase Auth a algo que entienda una persona.
 *
 * Supabase los devuelve en inglés y en su propio vocabulario: "Invalid
 * login credentials", "email rate limit exceeded", "User already
 * registered". Enseñarlos tal cual es pedirle al usuario que depure
 * nuestro backend.
 *
 * Regla del fallback: si no reconocemos el error, NO se enseña el texto
 * original. Se dice qué hacer. El mensaje técnico va al log del
 * servidor, que es donde sirve de algo.
 */

const GENERICO =
  'No pudimos completar la operación. Vuelve a intentarlo en un momento; si sigue igual, escríbenos a info@savedocumentos.com.'

type Regla = { contiene: string; mensaje: string }

const REGLAS: Regla[] = [
  {
    contiene: 'invalid login credentials',
    mensaje: 'El correo o la contraseña no coinciden. Revísalos e inténtalo otra vez.',
  },
  {
    contiene: 'email not confirmed',
    mensaje:
      'Todavía no has confirmado tu correo. Busca el mensaje que te enviamos y abre el enlace; mira también en Spam.',
  },
  {
    contiene: 'user already registered',
    mensaje:
      'Ya existe una cuenta con ese correo. Inicia sesión, o usa "¿Olvidaste tu contraseña?" si no la recuerdas.',
  },
  {
    contiene: 'already been registered',
    mensaje:
      'Ya existe una cuenta con ese correo. Inicia sesión, o usa "¿Olvidaste tu contraseña?" si no la recuerdas.',
  },
  {
    contiene: 'password should be at least',
    mensaje: 'La contraseña es demasiado corta. Necesita al menos 6 caracteres.',
  },
  {
    contiene: 'weak password',
    mensaje: 'Esa contraseña es demasiado fácil de adivinar. Prueba con una más larga.',
  },
  {
    contiene: 'unable to validate email address',
    mensaje: 'Ese correo no parece válido. Revisa que esté bien escrito.',
  },
  {
    contiene: 'invalid email',
    mensaje: 'Ese correo no parece válido. Revisa que esté bien escrito.',
  },
  {
    // El tope lo pone Supabase, por proyecto y por hora. No es culpa
    // de quien se está registrando, así que no se le riñe.
    contiene: 'rate limit',
    mensaje:
      'Estamos enviando muchos correos ahora mismo y nos toca esperar. Prueba de nuevo en unos minutos.',
  },
  {
    contiene: 'for security purposes',
    mensaje: 'Acabas de hacer esto hace un momento. Espera unos segundos y vuelve a intentarlo.',
  },
  {
    contiene: 'signups not allowed',
    mensaje: 'El registro está cerrado temporalmente. Escríbenos a info@savedocumentos.com.',
  },
  {
    contiene: 'error sending confirmation email',
    mensaje:
      'Tu cuenta se creó, pero el correo de confirmación no salió. Escríbenos a info@savedocumentos.com y lo activamos.',
  },
]

export function mensajeDeAuth(bruto?: string | null): string {
  if (!bruto) return GENERICO
  const texto = bruto.toLowerCase()
  const regla = REGLAS.find((r) => texto.includes(r.contiene))
  return regla ? regla.mensaje : GENERICO
}
