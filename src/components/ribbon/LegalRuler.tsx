import React from 'react';

interface LegalRulerProps {
  zoom: number;
}

export const LegalRuler: React.FC<LegalRulerProps> = ({ zoom }) => {
  // 17 cm standard printable width on A4/Letter paper with 2cm margins (total 21cm)
  const cmMarks = Array.from({ length: 22 }, (_, i) => i);

  return (
    <div className="w-full bg-slate-100 border-b border-slate-300 select-none flex justify-center overflow-hidden h-5 shrink-0 z-10 shadow-inner">
      <div
        style={{ width: `${Math.min(100, Math.max(60, zoom * 0.85))}%`, maxWidth: '780px' }}
        className="h-full bg-white border-x border-slate-300 flex items-center relative"
      >
        {/* Left margin marker indicator (3cm) */}
        <div className="absolute left-0 top-0 bottom-0 w-[14%] bg-slate-200/70 border-r border-slate-400/80" />

        {/* Right margin marker indicator (3cm) */}
        <div className="absolute right-0 top-0 bottom-0 w-[14%] bg-slate-200/70 border-l border-slate-400/80" />

        {/* Ruler Ticks */}
        <div className="w-full flex justify-between px-2 text-[9px] text-slate-500 font-mono">
          {cmMarks.map((cm) => (
            <div key={cm} className="flex flex-col items-center relative">
              <div className={`w-[1px] bg-slate-400 ${cm % 5 === 0 ? 'h-3' : 'h-1.5'}`} />
              {cm % 2 === 0 && <span className="text-[8px] -mt-0.5 text-slate-600 font-semibold">{cm}</span>}
            </div>
          ))}
        </div>
      </div>
    </div>
  );
};
