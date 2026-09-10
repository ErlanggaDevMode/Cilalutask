import React, { useState, useMemo } from 'react';
import {
  Bookmark,
  History,
  Search,
  SlidersHorizontal,
  FileText,
  Upload,
  ArrowRight,
  Clock,
  ShieldCheck,
  Headphones,
  FileSpreadsheet,
  ShieldAlert,
  Wrench,
  Share2,
  BookOpen,
  CheckCircle2,
  ChevronDown,
} from 'lucide-react';
import { SOPDocument } from '../../types';

interface SopScreenProps {
  sops: SOPDocument[];
  onOpenUploadSop: () => void;
  onOpenSopDetail: (sop: SOPDocument) => void;
  onToggleBookmark: (sopId: string) => void;
}

export const SopScreen: React.FC<SopScreenProps> = ({
  sops,
  onOpenUploadSop,
  onOpenSopDetail,
  onToggleBookmark,
}) => {
  const [searchQuery, setSearchQuery] = useState('');
  const [selectedCategory, setSelectedCategory] = useState('Semua');
  const [sortOrder, setSortOrder] = useState('Versi Terbaru');

  const categories = [
    'Semua',
    'Operasional Gudang',
    'Keamanan Kerja (K3)',
    'Customer Service',
    'Finance & HRD',
    'IT Department',
  ];

  const filteredSops = useMemo(() => {
    return sops.filter((sop) => {
      // Don't duplicate urgent mandatory card in the general directory list if we want clean rendering
      if (selectedCategory !== 'Semua') {
        if (!sop.category.toLowerCase().includes(selectedCategory.toLowerCase().slice(0, 5))) {
          return false;
        }
      }

      if (searchQuery.trim()) {
        const q = searchQuery.toLowerCase();
        return (
          sop.title.toLowerCase().includes(q) ||
          sop.code.toLowerCase().includes(q) ||
          sop.category.toLowerCase().includes(q) ||
          (sop.description && sop.description.toLowerCase().includes(q))
        );
      }

      return true;
    });
  }, [sops, selectedCategory, searchQuery]);

  const urgentSop = sops.find((s) => s.isUrgentMandatory) || sops[0];

  const getSopIcon = (category: string) => {
    if (category.includes('Customer Service')) {
      return <Headphones className="w-5 h-5 text-blue-600" />;
    }
    if (category.includes('Finance') || category.includes('HRD')) {
      return <FileSpreadsheet className="w-5 h-5 text-blue-600" />;
    }
    if (category.includes('IT')) {
      return <ShieldAlert className="w-5 h-5 text-blue-600" />;
    }
    return <Wrench className="w-5 h-5 text-blue-600" />;
  };

  return (
    <div className="space-y-4 pb-20 px-4 pt-2">
      {/* 1. Header Section: Knowledge Base */}
      <div className="flex items-center justify-between">
        <div>
          <span className="text-[11px] font-extrabold uppercase tracking-wider text-[#0051D5]">
            KNOWLEDGE BASE
          </span>
          <h1 className="text-xl font-bold tracking-tight text-[#0B1C30]">
            Pusat Standar Operasional
          </h1>
        </div>

        <div className="flex items-center gap-1.5">
          <button
            className="w-9 h-9 rounded-xl bg-white border border-slate-200 text-slate-600 hover:text-blue-600 flex items-center justify-center active:scale-95 transition-all shadow-xs"
            title="SOP Tersimpan"
          >
            <Bookmark className="w-4 h-4" />
          </button>
          <button
            className="w-9 h-9 rounded-xl bg-white border border-slate-200 text-slate-600 hover:text-blue-600 flex items-center justify-center active:scale-95 transition-all shadow-xs"
            title="Riwayat Revisi"
          >
            <History className="w-4 h-4" />
          </button>
        </div>
      </div>

      {/* 2. Search Bar */}
      <div className="flex items-center gap-2">
        <div className="relative flex-1">
          <Search className="absolute left-3.5 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-400" />
          <input
            type="text"
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            placeholder="Cari SOP, pedoman kerja, kode dokumen"
            className="w-full pl-9 pr-4 py-2.5 bg-white border border-slate-200 rounded-xl text-xs sm:text-sm text-slate-800 placeholder:text-slate-400 focus:outline-none focus:ring-2 focus:ring-[#0051D5] shadow-xs transition-all"
          />
        </div>

        <button
          className="w-10 h-10 rounded-xl bg-blue-50 border border-blue-100 flex items-center justify-center text-[#0051D5] hover:bg-blue-100 transition-colors shrink-0"
          title="Filter Kategori"
        >
          <SlidersHorizontal className="w-4 h-4" />
        </button>
      </div>

      {/* 3. Manager Banner (Kelola Dokumen) */}
      <div className="relative overflow-hidden rounded-2xl bg-gradient-to-r from-[#00236F] via-[#0051D5] to-[#1E3A8A] text-white p-3.5 shadow-md shadow-blue-900/15 flex items-center justify-between">
        <div className="flex items-center gap-3">
          <div className="w-10 h-10 rounded-xl bg-white/15 backdrop-blur-md flex items-center justify-center shrink-0 border border-white/20">
            <FileText className="w-5 h-5 text-white" />
          </div>

          <div className="space-y-0.5">
            <div className="flex items-center gap-2">
              <span className="text-sm font-bold tracking-tight">Kelola Dokumen</span>
              <span className="px-1.5 py-0.2 rounded-sm bg-emerald-400/20 border border-emerald-400/30 text-emerald-300 text-[10px] font-bold tracking-wider">
                MANAGER
              </span>
            </div>
            <p className="text-[11px] text-blue-100 font-normal line-clamp-1">
              Unggah revisi PDF/Doc atau buat instruksi kerja baru
            </p>
          </div>
        </div>

        <button
          onClick={onOpenUploadSop}
          className="w-9 h-9 rounded-xl bg-white text-[#00236F] hover:bg-blue-50 flex items-center justify-center shrink-0 shadow-xs active:scale-95 transition-all ml-2"
          title="Unggah Dokumen Baru"
        >
          <Upload className="w-4 h-4 text-[#00236F] stroke-[2.5]" />
        </button>
      </div>

      {/* 4. Category Filters */}
      <div className="flex items-center gap-1.5 overflow-x-auto no-scrollbar py-1">
        {categories.map((cat) => {
          const isActive = selectedCategory === cat;
          return (
            <button
              key={cat}
              onClick={() => setSelectedCategory(cat)}
              className={`px-3.5 py-1.5 rounded-full text-xs font-semibold whitespace-nowrap transition-all ${
                isActive
                  ? 'bg-[#0051D5] text-white shadow-xs'
                  : 'bg-white text-slate-600 border border-slate-200 hover:bg-slate-50'
              }`}
            >
              {cat}
            </button>
          );
        })}
      </div>

      {/* 5. Urgent SOP Alert Card */}
      {urgentSop && (
        <div className="rounded-2xl bg-rose-50/80 border border-rose-200/90 p-4 shadow-sm space-y-3">
          {/* Top badges */}
          <div className="flex items-center justify-between text-[11px]">
            <span className="inline-flex items-center gap-1 font-bold text-rose-600">
              <span className="w-2 h-2 rounded-full bg-rose-500 animate-pulse" />
              WAJIB DIBACA & DIKONFIRMASI
            </span>
            <span className="px-2 py-0.5 rounded-full bg-rose-100 text-rose-700 font-semibold">
              1 Belum Diverifikasi
            </span>
          </div>

          {/* Code & Due */}
          <div className="flex items-center justify-between text-xs text-slate-500">
            <span className="font-semibold text-slate-700">{urgentSop.code}</span>
            <span className="inline-flex items-center gap-1 text-rose-600 font-medium">
              <Clock className="w-3.5 h-3.5" />
              {urgentSop.deadlineWarning || '2 hari lagi'}
            </span>
          </div>

          {/* Title */}
          <h3 className="text-[15px] font-bold text-slate-900 leading-snug">
            {urgentSop.title}
          </h3>

          {/* Action Row */}
          <div className="flex items-center justify-between pt-1">
            <div className="flex items-center gap-1.5 text-xs text-slate-600 font-medium">
              <ShieldCheck className="w-4 h-4 text-emerald-600" />
              <span>{urgentSop.complianceTag || 'Kepatuhan K3 Divisi Alat'}</span>
            </div>

            <button
              onClick={() => onOpenSopDetail(urgentSop)}
              className="inline-flex items-center gap-1.5 px-3.5 py-1.5 rounded-xl bg-rose-600 hover:bg-rose-700 active:bg-rose-800 text-white text-xs font-bold shadow-xs active:scale-95 transition-all"
            >
              <span>Baca & Setujui</span>
              <ArrowRight className="w-3.5 h-3.5" />
            </button>
          </div>
        </div>
      )}

      {/* 6. Direktori Dokumen */}
      <div className="space-y-2.5">
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-2">
            <h2 className="text-[15px] font-bold text-[#0B1C30] tracking-tight">
              Direktori Dokumen
            </h2>
            <span className="px-2 py-0.5 rounded-full bg-blue-100 text-[#0051D5] text-[11px] font-bold">
              14 Aktif
            </span>
          </div>

          <button
            onClick={() => setSortOrder(sortOrder === 'Versi Terbaru' ? 'Terpopuler' : 'Versi Terbaru')}
            className="inline-flex items-center gap-1 text-xs font-semibold text-[#0051D5] hover:text-blue-800"
          >
            <span>Urutkan: {sortOrder}</span>
            <ChevronDown className="w-3.5 h-3.5" />
          </button>
        </div>

        {/* List of SOPs */}
        <div className="space-y-3">
          {filteredSops.map((sop) => {
            const isBookmarked = !!sop.isBookmarked;

            return (
              <div
                key={sop.id}
                className="bg-white rounded-2xl p-4 border border-slate-200/90 shadow-sm hover:border-blue-200 transition-all space-y-3"
              >
                {/* Header row: Category Icon + Code + Version + Bookmark */}
                <div className="flex items-start justify-between">
                  <div className="flex items-center gap-2.5">
                    <div className="w-9 h-9 rounded-xl bg-blue-50/80 border border-blue-100/80 flex items-center justify-center shrink-0">
                      {getSopIcon(sop.category)}
                    </div>
                    <div>
                      <div className="flex items-center gap-2 flex-wrap">
                        <span className="text-xs font-bold text-slate-800">
                          {sop.code} • {sop.category}
                        </span>
                        {sop.isNewUpdate ? (
                          <span className="px-2 py-0.5 rounded-md bg-emerald-50 text-emerald-700 text-[10px] font-bold">
                            Update Baru
                          </span>
                        ) : (
                          <span className="px-2 py-0.5 rounded-md bg-blue-50 text-[#0051D5] text-[10px] font-bold">
                            {sop.version}
                          </span>
                        )}
                      </div>
                    </div>
                  </div>

                  <button
                    onClick={() => onToggleBookmark(sop.id)}
                    className="text-slate-400 hover:text-blue-600 p-1"
                  >
                    <Bookmark
                      className={`w-4 h-4 ${
                        isBookmarked ? 'text-[#0051D5] fill-[#0051D5]' : ''
                      }`}
                    />
                  </button>
                </div>

                {/* Title & Description */}
                <div>
                  <h3 className="text-[15px] font-bold text-slate-900 leading-snug">
                    {sop.title}
                  </h3>
                  {sop.description && (
                    <p className="text-xs text-slate-500 line-clamp-2 mt-1 leading-relaxed">
                      {sop.description}
                    </p>
                  )}
                </div>

                {/* Conditional metrics/progress */}
                {sop.readProgressPercent !== undefined && (
                  <div className="bg-slate-50 rounded-xl p-2.5 space-y-1.5 border border-slate-100">
                    <div className="flex items-center justify-between text-xs">
                      <span className="text-slate-600 font-medium">
                        {sop.complianceRatioText}
                      </span>
                      <span className="font-bold text-slate-800">
                        {sop.readTeamCount}
                      </span>
                    </div>
                    <div className="w-full h-1.5 bg-slate-200 rounded-full overflow-hidden">
                      <div
                        className="h-full bg-[#0051D5] rounded-full"
                        style={{ width: `${sop.readProgressPercent}%` }}
                      />
                    </div>
                  </div>
                )}

                {/* Badges for maintenance / checkpoints */}
                {(sop.checkPoints || sop.duration) && (
                  <div className="flex items-center gap-2 flex-wrap text-xs">
                    {sop.checkPoints && (
                      <span className="inline-flex items-center gap-1 px-2.5 py-1 rounded-md bg-slate-100 text-slate-700 text-[11px] font-medium">
                        <CheckCircle2 className="w-3 h-3 text-emerald-600" />
                        {sop.checkPoints}
                      </span>
                    )}
                    {sop.duration && (
                      <span className="inline-flex items-center gap-1 px-2.5 py-1 rounded-md bg-slate-100 text-slate-700 text-[11px] font-medium">
                        <Clock className="w-3 h-3 text-slate-500" />
                        {sop.duration}
                      </span>
                    )}
                  </div>
                )}

                {/* Footer: Date / File info + Share + Buka SOP */}
                <div className="flex items-center justify-between pt-2 border-t border-slate-100 text-xs text-slate-500">
                  <span className="text-[11px] font-medium">
                    {sop.fileInfo || sop.lastUpdatedText}
                  </span>

                  <div className="flex items-center gap-2">
                    <button
                      className="w-8 h-8 rounded-xl bg-slate-50 hover:bg-slate-100 border border-slate-200 flex items-center justify-center text-slate-600 transition-colors"
                      title="Bagikan SOP"
                    >
                      <Share2 className="w-3.5 h-3.5" />
                    </button>

                    <button
                      onClick={() => onOpenSopDetail(sop)}
                      className="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-xl bg-[#0051D5] hover:bg-blue-700 active:bg-blue-900 text-white text-xs font-semibold shadow-xs active:scale-95 transition-all"
                    >
                      <BookOpen className="w-3.5 h-3.5" />
                      <span>Buka SOP</span>
                    </button>
                  </div>
                </div>
              </div>
            );
          })}
        </div>
      </div>
    </div>
  );
};
