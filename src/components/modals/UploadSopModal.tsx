import React, { useState } from 'react';
import { X, Upload, FileText, Check } from 'lucide-react';
import { SOPDocument } from '../../types';

interface UploadSopModalProps {
  isOpen: boolean;
  onClose: () => void;
  onAddSop: (newSop: SOPDocument) => void;
}

export const UploadSopModal: React.FC<UploadSopModalProps> = ({
  isOpen,
  onClose,
  onAddSop,
}) => {
  const [title, setTitle] = useState('');
  const [category, setCategory] = useState('Operasional Gudang');
  const [code, setCode] = useState('SOP-2025-OPS-05');
  const [description, setDescription] = useState('');
  const [version, setVersion] = useState('v1.0');
  const [isUrgentMandatory, setIsUrgentMandatory] = useState(false);
  const [fileName, setFileName] = useState<string | null>(null);

  if (!isOpen) return null;

  const handleFileChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    if (e.target.files && e.target.files[0]) {
      setFileName(e.target.files[0].name);
    }
  };

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (!title.trim()) return;

    const newDoc: SOPDocument = {
      id: `sop-${Date.now()}`,
      code: code.trim() || `SOP-${Math.floor(100 + Math.random() * 900)}`,
      title: title.trim(),
      category,
      version: version.trim() || 'v1.0',
      description: description.trim() || 'Pedoman operasional standar.',
      lastUpdatedText: 'Baru saja diunggah',
      fileInfo: fileName ? `${fileName} (PDF)` : 'Dokumen Digital Terbitan Internal',
      isUrgentMandatory,
      isNewUpdate: true,
      readProgressPercent: 0,
      readTeamCount: '0/34 Tim',
      complianceRatioText: '0% Karyawan terverifikasi',
      contentSections: [
        {
          heading: 'Prosedur Pelaksanaan Standar',
          items: [
            description || 'Melakukan instruksi operasional sesuai standar ISO dan K3.',
            'Melaporkan penyelesaian tugas kepada supervisor terkait.',
          ],
        },
      ],
      isReadByMe: true,
    };

    onAddSop(newDoc);
    onClose();
  };

  return (
    <div className="fixed inset-0 z-50 flex items-end sm:items-center justify-center bg-slate-900/50 backdrop-blur-xs p-0 sm:p-4">
      <div className="w-full max-w-lg bg-white rounded-t-3xl sm:rounded-2xl shadow-xl overflow-hidden max-h-[90vh] flex flex-col animate-in slide-in-from-bottom duration-200">
        {/* Header */}
        <div className="px-5 py-4 border-b border-slate-100 flex items-center justify-between">
          <div className="flex items-center gap-2">
            <Upload className="w-4 h-4 text-[#0051D5]" />
            <h2 className="text-base font-bold text-slate-900">Unggah SOP Baru</h2>
          </div>
          <button
            onClick={onClose}
            className="w-8 h-8 rounded-full hover:bg-slate-100 flex items-center justify-center text-slate-400 hover:text-slate-600 transition-colors"
          >
            <X className="w-4 h-4" />
          </button>
        </div>

        {/* Form Body */}
        <form onSubmit={handleSubmit} className="p-5 overflow-y-auto space-y-4">
          <div className="space-y-1.5">
            <label className="text-xs font-bold text-slate-700">
              Judul Dokumen SOP <span className="text-rose-500">*</span>
            </label>
            <input
              type="text"
              required
              value={title}
              onChange={(e) => setTitle(e.target.value)}
              placeholder="Contoh: Prosedur Pengamanan Data Nasabah"
              className="w-full px-3.5 py-2.5 rounded-xl border border-slate-200 text-xs sm:text-sm text-slate-900 placeholder:text-slate-400 focus:outline-none focus:ring-2 focus:ring-[#0051D5]"
            />
          </div>

          <div className="grid grid-cols-2 gap-3">
            <div className="space-y-1.5">
              <label className="text-xs font-bold text-slate-700">Kode SOP</label>
              <input
                type="text"
                value={code}
                onChange={(e) => setCode(e.target.value)}
                placeholder="SOP-2025-OPS-05"
                className="w-full px-3 py-2 rounded-xl border border-slate-200 text-xs text-slate-800 focus:outline-none focus:ring-2 focus:ring-[#0051D5]"
              />
            </div>
            <div className="space-y-1.5">
              <label className="text-xs font-bold text-slate-700">Versi</label>
              <input
                type="text"
                value={version}
                onChange={(e) => setVersion(e.target.value)}
                placeholder="v1.0"
                className="w-full px-3 py-2 rounded-xl border border-slate-200 text-xs text-slate-800 focus:outline-none focus:ring-2 focus:ring-[#0051D5]"
              />
            </div>
          </div>

          <div className="space-y-1.5">
            <label className="text-xs font-bold text-slate-700">Kategori Divisi</label>
            <select
              value={category}
              onChange={(e) => setCategory(e.target.value)}
              className="w-full px-3 py-2.5 rounded-xl border border-slate-200 text-xs text-slate-800 bg-white focus:outline-none focus:ring-2 focus:ring-[#0051D5]"
            >
              <option value="Operasional Gudang">Operasional Gudang</option>
              <option value="Keamanan Kerja (K3)">Keamanan Kerja (K3)</option>
              <option value="Customer Service">Customer Service</option>
              <option value="Finance & HRD">Finance & HRD</option>
              <option value="IT Department">IT Department</option>
            </select>
          </div>

          {/* File Upload Drop Area */}
          <div className="space-y-1.5">
            <label className="text-xs font-bold text-slate-700">Lampiran Berkas (PDF / DOC)</label>
            <label className="border-2 border-dashed border-slate-200 rounded-2xl p-4 flex flex-col items-center justify-center cursor-pointer hover:border-[#0051D5] hover:bg-blue-50/30 transition-all text-center">
              <Upload className="w-6 h-6 text-slate-400 mb-1.5" />
              <span className="text-xs font-semibold text-slate-700">
                {fileName || 'Klik atau seret dokumen ke sini'}
              </span>
              <span className="text-[11px] text-slate-400 mt-0.5">
                Maksimal ukuran file 10MB (PDF, DOCX)
              </span>
              <input
                type="file"
                accept=".pdf,.doc,.docx"
                onChange={handleFileChange}
                className="hidden"
              />
            </label>
          </div>

          <div className="space-y-1.5">
            <label className="text-xs font-bold text-slate-700">Ringkasan Instruksi</label>
            <textarea
              rows={2}
              value={description}
              onChange={(e) => setDescription(e.target.value)}
              placeholder="Rangkuman pedoman operasional..."
              className="w-full px-3.5 py-2 rounded-xl border border-slate-200 text-xs text-slate-900 placeholder:text-slate-400 focus:outline-none focus:ring-2 focus:ring-[#0051D5]"
            />
          </div>

          {/* Urgent Mandatory Toggle */}
          <div className="flex items-center justify-between p-3 rounded-xl bg-slate-50 border border-slate-200/80">
            <div>
              <p className="text-xs font-bold text-slate-800">Wajib Dibaca & Dikonfirmasi</p>
              <p className="text-[11px] text-slate-500">Kirim notifikasi urgent ke seluruh tim divisi</p>
            </div>
            <input
              type="checkbox"
              checked={isUrgentMandatory}
              onChange={(e) => setIsUrgentMandatory(e.target.checked)}
              className="w-4 h-4 text-[#0051D5] rounded-md focus:ring-0"
            />
          </div>

          {/* Submit */}
          <div className="pt-3 flex items-center gap-2.5">
            <button
              type="button"
              onClick={onClose}
              className="flex-1 py-2.5 rounded-xl border border-slate-200 text-slate-700 text-xs font-semibold hover:bg-slate-50 transition-colors"
            >
              Batal
            </button>
            <button
              type="submit"
              className="flex-1 py-2.5 rounded-xl bg-[#0051D5] hover:bg-blue-700 text-white text-xs font-bold shadow-md shadow-blue-600/20 active:scale-95 transition-all"
            >
              Terbitkan Dokumen
            </button>
          </div>
        </form>
      </div>
    </div>
  );
};
