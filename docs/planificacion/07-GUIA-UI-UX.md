# 07 - Guía de Interfaz (UI) y Experiencia de Usuario (UX)
**Empresa:** SA&VE Comercial, S.R.L.

## Principios Centrales
1. **Verde como Acento Estratégico:** 
   - **Light Mode:** Dominancia de grises y blancos perlados. Verde (`emerald`) se reserva para botones de acción principal y Badges de éxito.
   - **Dark Mode:** Fondos `slate-900`, acentos en verde `emerald`. Cero uso de color azul/índigo para garantizar identidad legal.
2. **Minimalismo Legal (No-Branding):**
   - El visualizador de documentos y las exportaciones (PDF/DOCX) son lienzos completamente limpios. No se incorporan logotipos del usuario ni de SA&VE.

## Interacciones Específicas del MVP
- **Campana de Notificaciones:** En el navbar principal. Recibirá pings asíncronos cuando: 
  - Paralegal -> Envía documento a revisión.
  - Abogado -> Aprueba documento.
- **Modo Editor (Split-View):** Panel izquierdo colapsable para formularios, panel derecho para visualización de renderizado en tiempo real.
- **Panel de Flujo de Trabajo (Workflow):** Un documento mostrará insignias de estado (Borrador, En Revisión, Aprobado). Los abogados verán botones prominentes de "Aprobar" y "Rechazar" en el Header del editor.
