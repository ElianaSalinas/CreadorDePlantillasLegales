# 02 - Historias de Usuario
**Empresa:** SA&VE Comercial, S.R.L.

## Épica 1: Autenticación, Organizaciones y Perfiles
- **HU-1.1:** Como usuario Profesional, quiero registrarme indicando si soy "Abogado", "Notario" o "Ambos", para habilitar funciones específicas (ej. matrícula CARD).
- **HU-1.2:** Como Profesional, quiero crear una "Organización" e invitar a Paralegales y Asistentes con cuentas y credenciales independientes para mantener trazabilidad.
- **HU-1.3:** Como Paralegal, quiero iniciar sesión en mi propia cuenta y ver los casos asignados a mi Organización.

## Épica 2: Flujo de Aprobación y Trazabilidad (Audit Log)
- **HU-2.1:** Como Paralegal, quiero completar las variables de un contrato y marcarlo como "En Revisión" para que mi Abogado supervisor lo evalúe.
- **HU-2.2:** Como Abogado, quiero recibir una notificación de campana (in-app) cuando un Paralegal envíe un documento a revisión.
- **HU-2.3:** Como Abogado, quiero poder "Aprobar", "Devolver a corrección" o "Finalizar" un documento en revisión.
- **HU-2.4:** Como Administrador de la Organización, quiero ver un Historial de Actividad (Audit Log) detallado que muestre quién y cuándo se creó, editó o aprobó un documento.

## Épica 3: Plantillas y Bóveda (Gestión Documental)
- **HU-3.1:** Como Profesional, quiero modificar una plantilla maestra de SA&VE para que el sistema me genere una copia privada exclusiva para mi organización.
- **HU-3.2:** Como Usuario, quiero importar un archivo propio para que la IA lo convierta en una plantilla inteligente privada.
- **HU-3.3:** Como Administrador SA&VE, quiero crear nuevas versiones de plantillas (Versionado V1.0, V1.1) sin romper los documentos generados previamente con versiones anteriores.
- **HU-3.4:** Como Usuario, quiero una Bóveda (Vault) para guardar hasta 30 documentos (límite base), consultables a futuro.

## Épica 4: Panel de Administración SA&VE (Backoffice)
- **HU-4.1:** Como Super Admin SA&VE, quiero extender el límite de 10 plantillas gratuitas o el límite de bóveda de 30 documentos para un usuario específico.
- **HU-4.2:** Como Administrador Financiero, quiero ver un dashboard con usuarios gratuitos, premium, MRR e ingresos por PayPal.
