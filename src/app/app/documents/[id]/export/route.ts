import { NextResponse, type NextRequest } from 'next/server'
import { requireSession } from '@/lib/session'
import { buildDocx, safeFileName } from '@/lib/engine/export'
import { computeBoldRanges } from '@/lib/engine/variables'
import type { Variable } from '@/lib/engine/types'

/**
 * Descarga del documento. ?format=docx entrega un Word real;
 * ?format=txt entrega el texto plano.
 *
 * El PDF se genera en el navegador con jsPDF, porque necesita las fuentes
 * incrustadas y hacerlo aquí obligaría a empaquetarlas en el servidor.
 */
export async function GET(request: NextRequest, context: { params: Promise<{ id: string }> }) {
  const { id } = await context.params
  const format = new URL(request.url).searchParams.get('format') ?? 'docx'

  const { supabase, org, permissions } = await requireSession()

  if (!org) {
    return NextResponse.json({ error: 'Sin espacio de trabajo.' }, { status: 403 })
  }
  if (!permissions.documents) {
    return NextResponse.json({ error: 'Sin permiso para descargar documentos.' }, { status: 403 })
  }

  const { data: doc } = await supabase
    .from('documents')
    .select('title, content, data_payload, template_version_id')
    .eq('id', id)
    .eq('org_id', org.id)
    .maybeSingle()

  if (!doc) {
    return NextResponse.json({ error: 'Documento no encontrado.' }, { status: 404 })
  }

  const content = doc.content ?? ''

  if (format === 'txt') {
    return new NextResponse(`${doc.title}\n\n${content}`, {
      headers: {
        'Content-Type': 'text/plain; charset=utf-8',
        'Content-Disposition': `attachment; filename="${safeFileName(doc.title, 'txt')}"`,
      },
    })
  }

  // Las negritas de los datos del formulario: se recalculan aquí, no se
  // guardaron aparte al generar el documento. Si el documento no quedó
  // anclado a una versión de plantilla (documents.template_version_id
  // nulo) o esa versión no trae variables, sale sin negritas — nunca
  // rompe la descarga por esto.
  let boldRanges: ReturnType<typeof computeBoldRanges> = []
  if (doc.template_version_id && doc.data_payload) {
    const { data: version } = await supabase
      .from('template_versions')
      .select('snapshot')
      .eq('id', doc.template_version_id)
      .maybeSingle()

    const variables = (version?.snapshot as { variables?: Variable[] } | null)?.variables
    if (variables && variables.length > 0) {
      boldRanges = computeBoldRanges(content, variables, doc.data_payload as Record<string, unknown>)
    }
  }

  const bytes = await buildDocx(doc.title, content, boldRanges)

  return new NextResponse(bytes as unknown as BodyInit, {
    headers: {
      'Content-Type': 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
      'Content-Disposition': `attachment; filename="${safeFileName(doc.title, 'docx')}"`,
      'Content-Length': String(bytes.byteLength),
    },
  })
}
