import React, { useState } from 'react';
import {
  TrendingUp,
  Download,
  ChevronDown,
  Clock,
  Zap,
  BarChart3,
  Award,
  Bot,
  ArrowRight,
  ShieldCheck,
  Star,
} from 'lucide-react';
import { EMPLOYEE_PERFORMANCE, DIVISION_PRODUCTIVITY } from '../../data/mockData';

interface ReportsScreenProps {
  onOpenExportModal: () => void;
  onBalanceWorkload: () => void;
}

export const ReportsScreen: React.FC<ReportsScreenProps> = ({
  onOpenExportModal,
  onBalanceWorkload,
}) => {
  const [selectedTimeRange, setSelectedTimeRange] = useState('Bulan Ini (Mei 2025)');

  const timeRanges = [
    'Bulan Ini (Mei 2025)',
    'Minggu Ini',
    'Kuartal 1',
    'Tahun Ini',
  ];

  return (
    <div className="space-y-4 pb-20 px-4 pt-2">
      {/* 1. Header Section: Title & Ekspor */}
      <div className="flex items-start justify-between">
        <div className="flex items-center gap-2.5">
          <div className="w-9 h-9 rounded-xl bg-blue-50 border border-blue-100 flex items-center justify-center text-[#0051D5]">
            <TrendingUp className="w-5 h-5 stroke-[2.5]" />
          </div>
          <div>
            <h1 className="text-xl font-bold tracking-tight text-[#0B1C30]">
              Kinerja & Analisis
            </h1>
            <p className="text-xs text-slate-500 font-normal">
              Evaluasi efisiensi operasional tim
            </p>
          </div>
        </div>

        <button
          onClick={onOpenExportModal}
          className="inline-flex items-center gap-1.5 px-3 py-2 rounded-xl bg-blue-50 hover:bg-blue-100 border border-blue-200 text-[#0051D5] text-xs font-semibold shadow-xs active:scale-95 transition-all"
        >
          <Download className="w-3.5 h-3.5" />
          <span>Ekspor</span>
        </button>
      </div>

      {/* 2. Time Range Selector Pills */}
      <div className="flex items-center gap-1.5 overflow-x-auto no-scrollbar py-1">
        {timeRanges.map((range) => {
          const isActive = selectedTimeRange === range;
          return (
            <button
              key={range}
              onClick={() => setSelectedTimeRange(range)}
              className={`inline-flex items-center gap-1 px-3.5 py-1.5 rounded-full text-xs font-semibold whitespace-nowrap transition-all ${
                isActive
                  ? 'bg-[#0051D5] text-white shadow-xs'
                  : 'bg-white text-slate-600 border border-slate-200 hover:bg-slate-50'
              }`}
            >
              <span>{range}</span>
              {isActive && <ChevronDown className="w-3.5 h-3.5 ml-0.5" />}
            </button>
          );
        })}
      </div>

      {/* 3. Hero Metric Card (Tingkat Penyelesaian) */}
      <div className="relative overflow-hidden rounded-2xl bg-[#00236F] text-white p-4 shadow-lg shadow-blue-950/20 space-y-3">
        {/* Header line */}
        <div className="flex items-center justify-between">
          <span className="text-[11px] font-bold tracking-wider text-blue-200 uppercase">
            TINGKAT PENYELESAIAN (COMPLETION RATE)
          </span>
          <div className="w-8 h-8 rounded-lg bg-white/10 flex items-center justify-center text-blue-200">
            <Award className="w-4 h-4" />
          </div>
        </div>

        {/* Big percentage & trend */}
        <div className="flex items-baseline gap-3">
          <span className="text-3xl sm:text-4xl font-extrabold tracking-tight">
            92.4%
          </span>
          <span className="inline-flex items-center gap-0.5 px-2 py-0.5 rounded-full bg-emerald-500/20 border border-emerald-400/30 text-emerald-300 text-xs font-bold">
            <TrendingUp className="w-3 h-3 stroke-[2.5]" />
            +4.2%
          </span>
        </div>

        <p className="text-xs text-blue-200 font-normal">
          Lebih tinggi dari rerata bulan April (88.2%)
        </p>

        {/* Progress Bar */}
        <div className="w-full h-2 bg-blue-900/60 rounded-full overflow-hidden">
          <div
            className="h-full bg-gradient-to-r from-blue-400 to-emerald-400 rounded-full transition-all duration-500"
            style={{ width: '92.4%' }}
          />
        </div>
      </div>

      {/* 4. Two-Column Sub-Metrics */}
      <div className="grid grid-cols-2 gap-2.5">
        {/* Metric 1: Ketepatan Waktu */}
        <div className="bg-white rounded-2xl p-3.5 border border-slate-200/90 shadow-sm space-y-2">
          <div className="flex items-center justify-between">
            <span className="text-xs font-semibold text-slate-700">Ketepatan Waktu</span>
            <Clock className="w-4 h-4 text-blue-600" />
          </div>

          <div className="flex items-baseline gap-1.5">
            <span className="text-2xl font-bold tracking-tight text-slate-900">88%</span>
            <span className="text-xs text-slate-500 font-medium">On-Time</span>
          </div>

          <p className="text-[11px] font-semibold text-rose-600 flex items-center gap-1">
            <span className="w-1.5 h-1.5 rounded-full bg-rose-500" />
            12% Terlambat
          </p>

          {/* Multi-segment Bar */}
          <div className="w-full h-1.5 bg-slate-100 rounded-full flex overflow-hidden">
            <div className="h-full bg-[#0051D5]" style={{ width: '88%' }} />
            <div className="h-full bg-rose-500" style={{ width: '12%' }} />
          </div>
        </div>

        {/* Metric 2: Rata-rata Durasi */}
        <div className="bg-white rounded-2xl p-3.5 border border-slate-200/90 shadow-sm space-y-2">
          <div className="flex items-center justify-between">
            <span className="text-xs font-semibold text-slate-700">Rata-rata Durasi</span>
            <Zap className="w-4 h-4 text-emerald-600" />
          </div>

          <div className="flex items-baseline gap-1">
            <span className="text-2xl font-bold tracking-tight text-slate-900">1.8</span>
            <span className="text-sm font-bold text-slate-800">Hari</span>
          </div>

          <p className="text-[11px] text-slate-500 font-normal">
            per penyelesaian tugas
          </p>

          {/* SLA Badge */}
          <div className="inline-flex items-center gap-1 px-2 py-0.5 rounded-md bg-emerald-50 text-emerald-700 text-[10px] font-semibold">
            <ShieldCheck className="w-3 h-3 text-emerald-600" />
            <span>Target SLA: &lt; 2.5 Hari</span>
          </div>
        </div>
      </div>

      {/* 5. Produktivitas Divisi */}
      <div className="bg-white rounded-2xl p-4 border border-slate-200/90 shadow-sm space-y-3.5">
        <div className="flex items-center justify-between">
          <div>
            <h2 className="text-sm font-bold text-slate-900 tracking-tight">
              Produktivitas Divisi
            </h2>
            <p className="text-[11px] text-slate-500">
              Rasio penyelesaian target bulanan
            </p>
          </div>
          <BarChart3 className="w-4 h-4 text-slate-600" />
        </div>

        {/* Division Bars */}
        <div className="space-y-3 pt-1">
          {DIVISION_PRODUCTIVITY.map((div) => (
            <div key={div.name} className="space-y-1">
              <div className="flex items-center justify-between text-xs">
                <span className="flex items-center gap-2 font-medium text-slate-700">
                  <span className={`w-2 h-2 rounded-full ${div.colorClass}`} />
                  {div.name}
                </span>
                <span className="font-bold text-slate-800">{div.percent}%</span>
              </div>
              <div className="w-full h-2 bg-slate-100 rounded-full overflow-hidden">
                <div
                  className={`h-full ${div.colorClass} rounded-full transition-all duration-500`}
                  style={{ width: `${div.percent}%` }}
                />
              </div>
            </div>
          ))}
        </div>
      </div>

      {/* 6. Rekap Kinerja Karyawan */}
      <div className="space-y-2.5">
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-2">
            <h2 className="text-[15px] font-bold text-[#0B1C30] tracking-tight">
              Rekap Kinerja Karyawan
            </h2>
            <span className="px-2 py-0.5 rounded-full bg-blue-50 text-[#0051D5] text-[11px] font-bold">
              4 Anggota
            </span>
          </div>
          <button className="text-xs font-semibold text-[#0051D5] hover:text-blue-800">
            Lihat Semua
          </button>
        </div>

        <div className="space-y-2.5">
          {EMPLOYEE_PERFORMANCE.map((emp) => {
            const isRank1 = emp.rank === 1;
            const isRank2 = emp.rank === 2;
            const isRank3 = emp.rank === 3;

            const badgeBg = isRank1 || isRank2 ? 'bg-emerald-500 text-white' : isRank3 ? 'bg-[#0051D5] text-white' : 'bg-slate-700 text-white';

            return (
              <div
                key={emp.id}
                className="bg-white rounded-2xl p-3.5 border border-slate-200/90 shadow-sm flex items-center justify-between gap-3 hover:border-blue-200 transition-all"
              >
                <div className="flex items-center gap-3">
                  {/* Avatar + Rank Badge */}
                  <div className="relative shrink-0">
                    <img
                      src={emp.avatar}
                      alt={emp.name}
                      className="w-11 h-11 rounded-full object-cover ring-1 ring-slate-200"
                    />
                    <span
                      className={`absolute -bottom-1 -right-1 w-5 h-5 rounded-full ${badgeBg} text-[10px] font-extrabold flex items-center justify-center ring-1.5 ring-white`}
                    >
                      #{emp.rank}
                    </span>
                  </div>

                  {/* Info */}
                  <div className="space-y-0.5">
                    <div className="flex items-center gap-1">
                      <span className="text-sm font-bold text-slate-900">
                        {emp.name}
                      </span>
                      {emp.isStar && (
                        <Star className="w-3.5 h-3.5 text-amber-500 fill-amber-500" />
                      )}
                    </div>
                    <p className="text-xs text-slate-500 font-medium">
                      {emp.division}
                    </p>
                    <p className="text-[11px] text-slate-400 font-medium">
                      <span className="text-emerald-700 font-semibold">{emp.completedTasks} Selesai</span> • {emp.delayedTasks} Terlambat
                    </p>
                  </div>
                </div>

                {/* Score & Tag Box */}
                <div className="text-right shrink-0">
                  <div className="px-2.5 py-1 rounded-xl bg-blue-50/80 border border-blue-100 text-right">
                    <span className="text-base font-extrabold text-[#00236F]">
                      {emp.score}
                    </span>
                    <span className="text-[10px] font-bold text-slate-400">/100</span>
                  </div>
                  <span
                    className={`block mt-1 text-[10px] font-extrabold tracking-tight ${
                      emp.statusTag === 'SANGAT BAIK'
                        ? 'text-emerald-600'
                        : emp.statusTag === 'OPTIMAL'
                        ? 'text-[#0051D5]'
                        : 'text-slate-600'
                    }`}
                  >
                    {emp.statusTag}
                  </span>
                </div>
              </div>
            );
          })}
        </div>
      </div>

      {/* 7. Catatan Beban Kerja Tim (AI / Automated Recommendation) */}
      <div className="rounded-2xl bg-blue-50/70 border border-blue-100 p-4 shadow-sm space-y-2.5">
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-2">
            <div className="w-8 h-8 rounded-xl bg-[#0051D5] text-white flex items-center justify-center shadow-xs">
              <Bot className="w-4 h-4" />
            </div>
            <h3 className="text-sm font-bold text-[#0B1C30]">
              Catatan Beban Kerja Tim
            </h3>
          </div>
          <span className="px-2 py-0.5 rounded-full bg-blue-100 text-[#0051D5] text-[10px] font-bold">
            Otomatis
          </span>
        </div>

        <p className="text-xs text-slate-700 leading-relaxed">
          Distribusi beban kerja secara umum berada pada batas seimbang (rata-rata 23 tugas/karyawan). Perhatikan alokasi sprint Kevin Maulana pada modul integrasi API untuk memitigasi risiko 2 keterlambatan berulang.
        </p>

        <button
          onClick={onBalanceWorkload}
          className="inline-flex items-center gap-1.5 text-xs font-bold text-[#0051D5] hover:text-blue-800 transition-colors pt-1"
        >
          <span>Seimbangkan Alokasi Tugas</span>
          <ArrowRight className="w-3.5 h-3.5" />
        </button>
      </div>
    </div>
  );
};
