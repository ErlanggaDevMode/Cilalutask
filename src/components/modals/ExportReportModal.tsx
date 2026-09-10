import React, { useState } from 'react';
import { X, Download, FileSpreadsheet, FileText, Check } from 'lucide-react';

interface ExportReportModalProps {
  isOpen: boolean;
  onClose: () => void;
}

export const ExportReportModal: React.FC<ExportReportModalProps> = ({
  isOpen,
  onClose,
}) => {
  const [format, setFormat] = useState<'pdf' | 'csv' | 'xlsx'>('pdf');
  const [exported, setExported] = useState(false);

  if (!isOpen) return null;

  const handleExport = () => {
    setExported(true);
    setTimeout(() => {
      setExported(false);
      onClose();
    }, 1200);
  };

  return (
    <div className="fixed inset-0 z-50 flex items-end sm:items-center justify-center bg-slate-900/50 backdrop-blur-xs p-0 sm:p-4">
      <div className="w-full max-w-md bg-white rounded-t-3xl sm:rounded-2xl shadow-xl overflow-hidden flex flex-col animate-in slide-in-from-bottom duration-200">
        {/* Header */}
        <div className="px-5 py-4 border-b border-slate-100 flex items-center justify-between">
          <div className="flex items-center gap-2">
            <Download className="w-4 h-4 text-[#0051D5]" />
            <h2 className="text-base font-bold text-slate-900">Ekspor Laporan Kinerja</h2>
          </div>
          <button
            onClick={onClose}
            className="w-8 h-8 rounded-full hover:bg-slate-100 flex items-center justify-center text-slate-400 hover:text-slate-600"
          >
            <X className="w-4 h-4" />
          </button>
        </div>

        <div className="p-5 space-y-4">
          <p className="text-xs text-slate-600 leading-relaxed">
            Unduh rekapitulasi data tingkat penyelesaian tugas, SLA divisi, dan skor karyawan untuk periode <strong>Mei 2025</strong>.
          </p>

          <div className="space-y-2">
            <label className="text-xs font-bold text-slate-700">Pilih Format Berkas</label>
            <div className="grid grid-cols-3 gap-2">
              <button
                type="button"
                onClick={() => setFormat('pdf')}
                className={`p-3 rounded-xl border text-center flex flex-col items-center gap-1.5 transition-all ${
                  format === 'pdf'
                    ? 'border-[#0051D5] bg-blue-50/60 text-[#0051D5] font-bold'
                    : 'border-slate-200 hover:bg-slate-50 text-slate-700'
                }`}
              >
                <FileText className="w-5 h-5" />
                <span className="text-xs">PDF Eksekutif</span>
              </button>

              <button
                type="button"
                onClick={() => setFormat('xlsx')}
                className={`p-3 rounded-xl border text-center flex flex-col items-center gap-1.5 transition-all ${
                  format === 'xlsx'
                    ? 'border-[#0051D5] bg-blue-50/60 text-[#0051D5] font-bold'
                    : 'border-slate-200 hover:bg-slate-50 text-slate-700'
                }`}
              >
                <FileSpreadsheet className="w-5 h-5 text-emerald-600" />
                <span className="text-xs">Excel XLSX</span>
              </button>

              <button
                type="button"
                onClick={() => setFormat('csv')}
                className={`p-3 rounded-xl border text-center flex flex-col items-center gap-1.5 transition-all ${
                  format === 'csv'
                    ? 'border-[#0051D5] bg-blue-50/60 text-[#0051D5] font-bold'
                    : 'border-slate-200 hover:bg-slate-50 text-slate-700'
                }`}
              >
                <FileText className="w-5 h-5 text-slate-500" />
                <span className="text-xs">CSV Data</span>
              </button>
            </div>
          </div>

          <div className="pt-2 flex items-center gap-2">
            <button
              onClick={onClose}
              className="flex-1 py-2.5 rounded-xl border border-slate-200 text-slate-700 text-xs font-semibold hover:bg-slate-50 transition-colors"
            >
              Batal
            </button>
            <button
              onClick={handleExport}
              disabled={exported}
              className="flex-1 py-2.5 rounded-xl bg-[#0051D5] hover:bg-blue-700 text-white text-xs font-bold shadow-md shadow-blue-600/20 active:scale-95 transition-all flex items-center justify-center gap-1.5"
            >
              {exported ? (
                <>
                  <Check className="w-4 h-4 stroke-[3]" />
                  <span>Mengunduh...</span>
                </>
              ) : (
                <>
                  <Download className="w-4 h-4" />
                  <span>Unduh Berkas</span>
                </>
              )}
            </button>
          </div>
        </div>
      </div>
    </div>
  );
};
