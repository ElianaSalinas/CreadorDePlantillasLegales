import React, { useState } from 'react';
import { MessageSquare, Plus, Check, Trash2, X, User } from 'lucide-react';
import { useAppStore } from '../../store/useAppStore';

interface LegalComment {
  id: string;
  author: string;
  timestamp: string;
  clauseReference?: string;
  text: string;
  resolved: boolean;
}

interface CommentsDrawerProps {
  isOpen: boolean;
  onClose: () => void;
}

export const CommentsDrawer: React.FC<CommentsDrawerProps> = ({ isOpen, onClose }) => {
  const { currentUser, activeTemplate } = useAppStore();
  const [comments, setComments] = useState<LegalComment[]>([
    {
      id: 'c1',
      author: 'Licda. Stephanie Montero',
      timestamp: 'Hoy, 10:15 AM',
      clauseReference: 'Cláusula SEGUNDA',
      text: 'Verificar si el monto del depósito incluye el mes de comisión conforme a la Ley 4314 de Inquilinato.',
      resolved: false,
    },
    {
      id: 'c2',
      author: 'Dr. Alejandro Santana (Notario)',
      timestamp: 'Hoy, 11:30 AM',
      clauseReference: 'Comparecencia',
      text: 'Confirmar cédula de identidad del garante solidario.',
      resolved: true,
    },
  ]);

  const [newCommentText, setNewCommentText] = useState('');
  const [newClauseRef, setNewClauseRef] = useState('');

  if (!isOpen) return null;

  const handleAddComment = () => {
    if (!newCommentText.trim()) return;

    const newComment: LegalComment = {
      id: `comm_${Date.now()}`,
      author: currentUser.name,
      timestamp: 'Ahora mismo',
      clauseReference: newClauseRef.trim() || 'General',
      text: newCommentText.trim(),
      resolved: false,
    };

    setComments([newComment, ...comments]);
    setNewCommentText('');
    setNewClauseRef('');
  };

  const handleToggleResolve = (id: string) => {
    setComments(
      comments.map((c) => (c.id === id ? { ...c, resolved: !c.resolved } : c))
    );
  };

  const handleDeleteComment = (id: string) => {
    setComments(comments.filter((c) => c.id !== id));
  };

  return (
    <div className="w-72 sm:w-80 bg-white border-l border-slate-300 flex flex-col h-full shrink-0 shadow-lg z-20">
      {/* Header */}
      <div className="p-3.5 border-b border-slate-200 flex items-center justify-between bg-slate-50">
        <div className="flex items-center space-x-2 text-xs font-bold text-slate-800">
          <MessageSquare className="w-4 h-4 text-emerald-600" />
          <span>Comentarios & Revisión Legal</span>
        </div>
        <button onClick={onClose} className="p-1 hover:bg-slate-200 rounded text-slate-400 hover:text-slate-700">
          <X className="w-4 h-4" />
        </button>
      </div>

      {/* New comment input */}
      <div className="p-3 border-b border-slate-200 bg-slate-50/50 space-y-2">
        <input
          type="text"
          value={newClauseRef}
          onChange={(e) => setNewClauseRef(e.target.value)}
          placeholder="Referencia (ej. Cláusula TERCERA)..."
          className="w-full px-2.5 py-1 text-xs bg-white border border-slate-300 rounded-lg focus:outline-none focus:ring-1 focus:ring-emerald-500"
        />
        <textarea
          value={newCommentText}
          onChange={(e) => setNewCommentText(e.target.value)}
          placeholder="Escribe una observación jurídica..."
          rows={2}
          className="w-full p-2 text-xs bg-white border border-slate-300 rounded-lg focus:outline-none focus:ring-1 focus:ring-emerald-500 resize-none"
        />
        <button
          onClick={handleAddComment}
          disabled={!newCommentText.trim()}
          className="w-full py-1.5 bg-emerald-600 hover:bg-emerald-500 disabled:opacity-40 text-white rounded-lg text-xs font-semibold shadow-xs flex items-center justify-center space-x-1"
        >
          <Plus className="w-3.5 h-3.5" />
          <span>Agregar Observación</span>
        </button>
      </div>

      {/* Comments list */}
      <div className="flex-1 overflow-y-auto p-3 space-y-3">
        {comments.length === 0 ? (
          <p className="text-xs text-slate-400 text-center py-8 italic">No hay comentarios en este documento.</p>
        ) : (
          comments.map((c) => (
            <div
              key={c.id}
              className={`p-3 rounded-xl border transition-all text-xs space-y-2 ${
                c.resolved
                  ? 'bg-slate-50 border-slate-200 opacity-60'
                  : 'bg-amber-50/40 border-amber-200 shadow-xs'
              }`}
            >
              <div className="flex items-center justify-between">
                <div className="flex items-center space-x-1.5">
                  <div className="w-5 h-5 bg-emerald-100 text-emerald-800 rounded-full flex items-center justify-center text-[10px] font-bold">
                    {c.author.charAt(0)}
                  </div>
                  <span className="font-semibold text-slate-900 truncate max-w-[120px]">{c.author}</span>
                </div>
                <span className="text-[10px] text-slate-400">{c.timestamp}</span>
              </div>

              {c.clauseReference && (
                <span className="inline-block px-1.5 py-0.5 bg-white border border-slate-200 rounded text-[10px] font-semibold text-slate-600">
                  {c.clauseReference}
                </span>
              )}

              <p className="text-slate-800 leading-relaxed">{c.text}</p>

              <div className="flex items-center justify-between pt-1 border-t border-slate-100">
                <button
                  onClick={() => handleToggleResolve(c.id)}
                  className={`flex items-center space-x-1 text-[11px] font-medium ${
                    c.resolved ? 'text-slate-500 hover:text-slate-700' : 'text-emerald-700 hover:text-emerald-800 font-semibold'
                  }`}
                >
                  <Check className="w-3.5 h-3.5" />
                  <span>{c.resolved ? 'Reabrir' : 'Marcar Resuelto'}</span>
                </button>

                <button
                  onClick={() => handleDeleteComment(c.id)}
                  className="p-1 text-slate-400 hover:text-rose-600 rounded"
                  title="Eliminar comentario"
                >
                  <Trash2 className="w-3.5 h-3.5" />
                </button>
              </div>
            </div>
          ))
        )}
      </div>
    </div>
  );
};
