'use client'

import { useId, useState } from 'react'
import { Eye, EyeOff } from 'lucide-react'

type Props = {
  name?: string
  label?: string
  placeholder?: string
  required?: boolean
  autoComplete?: string
  defaultValue?: string
  hint?: string
}

export default function PasswordInput({
  name = 'password',
  label = 'Contraseña',
  placeholder = '••••••••',
  required = true,
  autoComplete = 'current-password',
  defaultValue,
  hint,
}: Props) {
  const [visible, setVisible] = useState(false)
  const id = useId()

  return (
    <div>
      <label
        htmlFor={id}
        className="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-1"
      >
        {label}
      </label>

      <div className="relative">
        <input
          id={id}
          name={name}
          type={visible ? 'text' : 'password'}
          required={required}
          autoComplete={autoComplete}
          defaultValue={defaultValue}
          placeholder={placeholder}
          className="w-full pl-4 pr-11 py-2 bg-slate-50 dark:bg-slate-800 border border-slate-300 dark:border-slate-700 rounded-lg focus:ring-2 focus:ring-emerald-500 outline-none text-slate-900 dark:text-white"
        />

        <button
          type="button"
          onClick={() => setVisible((v) => !v)}
          aria-label={visible ? 'Ocultar contraseña' : 'Mostrar contraseña'}
          aria-pressed={visible}
          title={visible ? 'Ocultar contraseña' : 'Mostrar contraseña'}
          className="absolute inset-y-0 right-0 flex items-center px-3 text-slate-400 hover:text-emerald-600 focus:text-emerald-600 focus:outline-none focus-visible:ring-2 focus-visible:ring-emerald-500 rounded-r-lg transition-colors"
          tabIndex={-1}
        >
          {visible ? <EyeOff size={18} /> : <Eye size={18} />}
        </button>
      </div>

      {hint && <p className="mt-1 text-xs text-slate-500">{hint}</p>}
    </div>
  )
}
