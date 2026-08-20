# 03 - Reglas de Negocio
**Empresa:** SA&VE Comercial, S.R.L.

1. **Aislamiento Organizacional:** Un usuario Paralegal o Asistente solo puede ver y editar los documentos de la Organización a la que pertenece. Las credenciales no se comparten.
2. **Independencia de Rol y Función Legal:** Ser "Notario" es un atributo profesional, no un rol de sistema. Otorga campos adicionales (Matrícula, Notaría) pero opera bajo los mismos privilegios de "Profesional" en cuanto a la organización.
3. **Restricción de Aprobación Paralegal:** Por defecto, los perfiles Paralegales y Asistentes NO pueden marcar un documento como "Aprobado" ni "Finalizado" (a menos que el abogado ajuste la configuración de despacho explícitamente).
4. **Límites Freemium (Hard Limits):** 
   - Límite de generación: 10 documentos derivados de plantillas maestras en el nivel gratuito.
   - Límite de bóveda (Vault): 30 documentos almacenados por cuenta/organización.
   - Ambos límites pueden ser ignorados o alterados por el Super Admin.
5. **Inmutabilidad del Historial (Audit Log):** Los registros del Audit Log son de solo lectura y apéndice continuo. Ni siquiera un administrador de la organización puede borrar un registro de auditoría.
6. **Versionado de Plantillas Maestras:** Una plantilla maestra publicada nunca se sobrescribe. Cualquier modificación administrativa generará una nueva versión (v1.x, v2.x). Los documentos ya creados mantendrán un vínculo con la versión original que usaron.
7. **Marca Blanca Absoluta:** No se permiten marcas de agua de SAVE ni logotipos subidos por usuarios en los documentos exportados finales.
