import React, { useState } from 'react';
import { X, BookOpen, ShieldCheck, Check, Download, FileText } from 'lucide-react';
import { SOPDocument } from '../../types';

interface SopDetailModalProps {
  sop: SOPDocument | null;
  isOpen: boolean;
  onClose: () => void;
  onConfirmRead: (sopId: string) => void;
}

function buildSopPdfBlob(sop: SOPDocument): Blob {
  const esc = (val: string) =>
    val.replace(/[^\x20-\x7E]/g, ' ').replace(/\\/g, '\\\\').replace(/\(/g, '\\(').replace(/\)/g, '\\)');

  const lines: string[] = [
    `DOKUMEN STANDAR OPERASIONAL PROSEDUR (SOP)`,
    `Kode: ${sop.code} | Versi: ${sop.version} | Kategori: ${sop.category}`,
    `Judul: ${sop.title}`,
    `Terakhir Diperbarui: ${sop.lastUpdatedText}`,
    `------------------------------------------------------------`,
    `Ringkasan:`,
    sop.description || 'Pedoman operasional standar.',
    ``,
  ];

  (sop.contentSections || []).forEach((sec, idx) => {
    lines.push(`${idx + 1}. ${sec.heading}`);
    sec.items.forEach((item, itemIdx) => {
      lines.push(`   ${idx + 1}.${itemIdx + 1} ${item}`);
    });
    lines.push('');
  });

  const contentOps: string[] = ['BT', '/F1 10 Tf', '50 790 Td', '14 TL'];
  lines.slice(0, 48).forEach((line) => {
    contentOps.push(`(${esc(line)}) Tj T*`);
  });
  contentOps.push('ET');
  const stream = contentOps.join('\n');

  const objects = [
    '1 0 obj\n<< /Type /Catalog /Pages 2 0 R >>\nendobj\n',
    '2 0 obj\n<< /Type /Pages /Kids [3 0 R] /Count 1 >>\nendobj\n',
    '3 0 obj\n<< /Type /Page /Parent 2 0 R /MediaBox [0 0 595 842] /Contents 4 0 R /Resources << /Font << /F1 5 0 R >> >> >>\nendobj\n',
    `4 0 obj\n<< /Length ${stream.length} >>\nstream\n${stream}\nendstream\nendobj\n`,
    '5 0 obj\n<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica >>\nendobj\n',
  ];

  let pdf = '%PDF-1.4\n';
  const offsets: number[] = [0];
  for (const obj of objects) {
    offsets.push(pdf.length);
    pdf += obj;
  }
  const xrefStart = pdf.length;
  pdf += `xref\n0 ${objects.length + 1}\n0000000000 65535 f \n`;
  for (let i = 1; i < offsets.length; i++) {
    pdf += `${String(offsets[i]).padStart(10, '0')} 00000 n \n`;
  }
  pdf += `trailer\n<< /Size ${objects.length + 1} /Root 1 0 R >>\nstartxref\n${xrefStart}\n%%EOF\n`;
  return new Blob([pdf], { type: 'application/pdf' });
}

export const SopDetailModal: React.FC<SopDetailModalProps> = ({
  sop,
  isOpen,
  onClose,
  onConfirmRead,
}) => {
  const [downloadedNotice, setDownloadedNotice] = useState<string | null>(null);

  if (!isOpen || !sop) return null;

  const handleDownloadSop = () => {
    const safeName =
      sop.attachmentFileName ||
      `${sop.code.replace(/[^A-Za-z0-9_-]/g, '_')}_${sop.version.replace(/[^A-Za-z0-9._-]/g, '')}.pdf`;

    if (sop.attachmentDataUrl) {
      const a = document.createElement('a');
      a.href = sop.attachmentDataUrl;
      a.download = safeName;
      document.body.appendChild(a);
      a.click();
      document.body.removeChild(a);
    } else {
      const blob = buildSopPdfBlob(sop);
      const url = URL.createObjectURL(blob);
      const a = document.createElement('a');
      a.href = url;
      a.download = safeName.endsWith('.pdf') ? safeName : `${safeName}.pdf`;
      document.body.appendChild(a);
      a.click();
      document.body.removeChild(a);
      setTimeout(() => URL.revokeObjectURL(url), 1000);
    }
    setDownloadedNotice(`Berkas ${safeName} berhasil diunduh.`);
  };

  return (
    <div className="fixed inset-0 z-50 flex items-end sm:items-center justify-center bg-slate-900/50 backdrop-blur-xs p-0 sm:p-4">
      <div className="w-full max-w-lg bg-white rounded-t-3xl sm:rounded-2xl shadow-xl overflow-hidden max-h-[92vh] flex flex-col animate-in slide-in-from-bottom duration-200">
        {/* Header */}
        <div className="px-5 py-4 border-b border-slate-100 flex items-center justify-between">
          <div className="flex items-center gap-2">
            <BookOpen className="w-4 h-4 text-[#0051D5]" />
            <h2 className="text-base font-bold text-slate-900">Dokumen Standar Operasional</h2>
          </div>
          <button
            onClick={onClose}
            className="w-8 h-8 rounded-full hover:bg-slate-100 flex items-center justify-center text-slate-400 hover:text-slate-600 transition-colors"
          >
            <X className="w-4 h-4" />
          </button>
        </div>

        {/* Document Content */}
        <div className="p-5 overflow-y-auto space-y-4">
          <div className="space-y-1">
            <div className="flex items-center gap-2 flex-wrap">
              <span className="px-2.5 py-0.5 rounded-md bg-blue-50 text-[#0051D5] text-[11px] font-bold">
                {sop.code}
              </span>
              <span className="px-2.5 py-0.5 rounded-md bg-slate-100 text-slate-700 text-[11px] font-bold">
                {sop.category}
              </span>
              <span className="px-2 py-0.5 rounded-md bg-emerald-50 text-emerald-700 text-[11px] font-bold">
                {sop.version}
              </span>
            </div>

            <h3 className="text-lg font-bold text-slate-900 mt-2 leading-snug">
              {sop.title}
            </h3>
            <p className="text-xs text-slate-500">
              {sop.lastUpdatedText} • Divisi Terkait
            </p>
          </div>

          {/* Attachment Download Card */}
          <div className="rounded-xl bg-blue-50/60 border border-blue-200/80 p-3 flex items-center justify-between gap-3">
            <div className="flex items-center gap-2.5 min-w-0">
              <div className="w-9 h-9 rounded-lg bg-[#0051D5] text-white flex items-center justify-center shrink-0">
                <FileText className="w-4 h-4" />
              </div>
              <div className="min-w-0">
                <p className="text-xs font-bold text-slate-900 truncate">
                  {sop.attachmentFileName || sop.fileInfo || `${sop.code}.pdf`}
                </p>
                <p className="text-[11px] text-slate-500">
                  {sop.fileInfo || 'Dokumen Resmi PDF Siap Unduh'}
                </p>
              </div>
            </div>
            <button
              type="button"
              onClick={handleDownloadSop}
              className="px-3 py-1.5 rounded-lg bg-[#0051D5] hover:bg-blue-700 text-white text-xs font-bold flex items-center gap-1.5 shrink-0 shadow-xs transition-all"
            >
              <Download className="w-3.5 h-3.5" />
              Unduh PDF
            </button>
          </div>

          {downloadedNotice && (
            <div className="rounded-lg bg-emerald-50 border border-emerald-200 px-3 py-2 text-[11px] font-semibold text-emerald-800">
              {downloadedNotice}
            </div>
          )}

          {/* Description */}
          {sop.description && (
            <div className="bg-slate-50 rounded-xl p-3 border border-slate-200/70 text-xs text-slate-700 leading-relaxed">
              {sop.description}
            </div>
          )}

          {/* Sections */}
          {sop.contentSections && sop.contentSections.length > 0 ? (
            <div className="space-y-3.5 pt-1">
              {sop.contentSections.map((sec, idx) => (
                <div key={idx} className="space-y-2">
                  <h4 className="text-xs font-bold text-slate-900 flex items-center gap-1.5">
                    <span className="w-4 h-4 rounded-md bg-blue-100 text-[#0051D5] text-[10px] font-extrabold flex items-center justify-center">
                      {idx + 1}
                    </span>
                    {sec.heading}
                  </h4>
                  <ul className="space-y-1.5 pl-6 list-disc text-xs text-slate-600 leading-relaxed">
                    {sec.items.map((item, itemIdx) => (
                      <li key={itemIdx}>{item}</li>
                    ))}
                  </ul>
                </div>
              ))}
            </div>
          ) : (
            <div className="space-y-2 text-xs text-slate-600">
              <p>Dokumen ini menetapkan standar tata kelola operasional, verifikasi audit ganda, serta protokol pelaporan insiden darurat.</p>
              <p>Setiap staf wajib mengikuti prosedur sesuai instruksi kerja terlampir dan melakukan logging harian.</p>
            </div>
          )}

          {/* Compliance & Verification Banner */}
          <div className="rounded-2xl bg-emerald-50/70 border border-emerald-200 p-3.5 flex items-center justify-between">
            <div className="flex items-center gap-2.5">
              <ShieldCheck className="w-5 h-5 text-emerald-600 shrink-0" />
              <div>
                <p className="text-xs font-bold text-emerald-900">Kepatuhan Operasional</p>
                <p className="text-[11px] text-emerald-700">Verifikasi digital tercatat otomatis pada sistem audit.</p>
              </div>
            </div>
            {sop.isReadByMe ? (
              <span className="inline-flex items-center gap-1 text-[11px] font-bold text-emerald-700 bg-white px-2 py-1 rounded-lg border border-emerald-300">
                <Check className="w-3.5 h-3.5" />
                Terverifikasi
              </span>
            ) : (
              <span className="text-[11px] font-semibold text-rose-600">
                Belum Dibaca
              </span>
            )}
          </div>

          {/* Action Buttons */}
          <div className="pt-2 flex items-center gap-2">
            <button
              onClick={onClose}
              className="flex-1 py-2.5 rounded-xl border border-slate-200 text-slate-700 text-xs font-semibold hover:bg-slate-50 transition-colors"
            >
              Tutup
            </button>
            <button
              onClick={() => {
                onConfirmRead(sop.id);
                onClose();
              }}
              className={`flex-1 py-2.5 rounded-xl text-white text-xs font-bold shadow-md active:scale-95 transition-all flex items-center justify-center gap-1.5 ${sop.isReadByMe
                ? 'bg-emerald-600 hover:bg-emerald-700 shadow-emerald-600/20'
                : 'bg-[#0051D5] hover:bg-blue-700 shadow-blue-600/20'
                }`}
            >
              <Check className="w-4 h-4 stroke-[3]" />
              <span>{sop.isReadByMe ? 'Sudah Disetujui' : 'Saya Sudah Baca & Setuju'}</span>
            </button>
          </div>
        </div>
      </div>
    </div>
  );
};
