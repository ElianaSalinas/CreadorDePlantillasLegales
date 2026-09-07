'use server'

import { revalidatePath } from 'next/cache'
import { redirect } from 'next/navigation'
import { mensajeDeAuth } from '@/lib/mensajes-auth'
import { createClient } from '@/utils/supabase/server'

export async function login(formData: FormData) {
  const supabase = await createClient()

  const data = {
    email: formData.get('email') as string,
    password: formData.get('password') as string,
  }

  const { error } = await supabase.auth.signInWithPassword(data)

  if (error) {
    console.error('[login] signInWithPassword fallo:', error.message)
    redirect('/login?message=' + encodeURIComponent(mensajeDeAuth(error.message)))
  }

  revalidatePath('/', 'layout')
  redirect('/app/dashboard')
}
