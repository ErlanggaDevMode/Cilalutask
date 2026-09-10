import React from 'react';
import {
  ShieldCheck,
  LayoutGrid,
  Plus,
  FileUp,
  Megaphone,
  Calendar,
  CheckCircle2,
  Clock,
  AlertTriangle,
  FileCheck,
  MoreVertical,
  ArrowRight,
  TrendingUp,
  Check,
  RefreshCw,
} from 'lucide-react';
import { Task, TabType, ActivityItem } from '../../types';
import { CURRENT_USER } from '../../data/mockData';

interface HomeScreenProps {
  tasks: Task[];
  activities: ActivityItem[];
  onNavigateTab: (tab: TabType) => void;
  onOpenCreateTask: () => void;
  onOpenUploadSop: () => void;
  onSelectTask: (task: Task) => void;
  onQuickBroadcast: () => void;
}

export const HomeScreen: React.FC<HomeScreenProps> = ({
  tasks,
  activities,
  onNavigateTab,
  onOpenCreateTask,
  onOpenUploadSop,
  onSelectTask,
  onQuickBroadcast,
}) => {
  // Urgent/Approaching deadline tasks
  const approachingTasks = tasks
    .filter((t) => t.isUrgentDeadline || t.deadlineLabel.includes('Hari ini') || t.deadlineLabel.includes('Besok'))
    .slice(0, 3);

  // Summary counts
  const activeCount = tasks.filter((t) => t.status === 'Dalam Proses').length;
  const completedCount = 42; // exactly as shown in screenshot
  const reviewCount = tasks.filter((t) => t.needsReview).length || 7;
  const nearDeadlineCount = tasks.filter((t) => t.isUrgentDeadline).length || 3;

  return (
    <div className="space-y-4 pb-6 px-4 pt-2">
      {/* 1. Hero Welcome Card */}
      <div className="relative overflow-hidden rounded-2xl bg-gradient-to-br from-white via-blue-50/40 to-blue-100/30 border border-blue-100/90 shadow-sm p-4 text-[#0B1C30]">
        <div className="flex items-start justify-between">
          <div className="space-y-1.5">
            {/* Role Chip */}
            <div className="inline-flex items-center gap-1.5 px-2.5 py-0.5 rounded-full bg-blue-100/80 text-blue-800 text-[11px] font-semibold">
              <span className="w-1.5 h-1.5 rounded-full bg-blue-600" />
              {CURRENT_USER.role}
            </div>

            {/* Greeting */}
            <h1 className="text-xl sm:text-2xl font-bold tracking-tight text-[#0B1C30]">
              Halo, {CURRENT_USER.name}
            </h1>

            <p className="text-[13px] text-slate-600 font-normal leading-relaxed">
              Operasional berjalan lancar • <span className="font-semibold text-slate-800">{CURRENT_USER.targetQuarterPercent}%</span> target kuartal tercapai
            </p>
          </div>

          {/* Icon Button Top Right */}
          <button
            onClick={() => onNavigateTab('laporan')}
            className="w-10 h-10 rounded-xl bg-[#00236F] text-white flex items-center justify-center shadow-md shadow-blue-900/20 active:scale-95 transition-transform"
            title="Lihat Dashboard Lengkap"
          >
            <LayoutGrid className="w-5 h-5 text-white" />
          </button>
        </div>

        {/* Divider & Performa footer */}
        <div className="mt-3.5 pt-3 border-t border-blue-100/80 flex items-center justify-between text-xs">
          <div className="flex items-center gap-1.5 text-emerald-700 font-semibold">
            <ShieldCheck className="w-4 h-4 text-emerald-600" />
            <span>Efisiensi Tim: {CURRENT_USER.teamEfficiencyPercent}%</span>
          </div>

          <button
            onClick={() => onNavigateTab('laporan')}
            className="inline-flex items-center gap-1 font-semibold text-[#0051D5] hover:text-blue-800 transition-colors"
          >
            <span>Lihat Performa</span>
            <ArrowRight className="w-3.5 h-3.5" />
          </button>
        </div>
      </div>

      {/* 2. Aksi Cepat (Quick Actions) */}
      <div className="space-y-2">
        <div className="flex items-center justify-between">
          <h2 className="text-[15px] font-bold text-[#0B1C30] tracking-tight">Aksi Cepat</h2>
          <span className="text-xs font-medium text-slate-400">Pintasan</span>
        </div>

        <div className="flex items-center gap-2 overflow-x-auto no-scrollbar py-0.5">
          {/* Buat Tugas Baru */}
          <button
            onClick={onOpenCreateTask}
            className="flex-1 min-w-[150px] inline-flex items-center justify-center gap-2 px-3.5 py-2.5 rounded-xl bg-[#0051D5] hover:bg-blue-700 active:bg-[#00236F] text-white text-xs font-semibold shadow-sm shadow-blue-600/20 active:scale-[0.98] transition-all"
          >
            <Plus className="w-4 h-4 stroke-[2.5]" />
            <span className="whitespace-nowrap">Buat Tugas Baru</span>
          </button>

          {/* Unggah SOP */}
          <button
            onClick={onOpenUploadSop}
            className="flex-1 min-w-[130px] inline-flex items-center justify-center gap-2 px-3.5 py-2.5 rounded-xl bg-white hover:bg-slate-50 border border-slate-200 text-slate-700 text-xs font-semibold shadow-sm active:scale-[0.98] transition-all"
          >
            <FileUp className="w-4 h-4 text-blue-600 stroke-[2]" />
            <span className="whitespace-nowrap">Unggah SOP</span>
          </button>

          {/* Megaphone / Broadcast */}
          <button
            onClick={onQuickBroadcast}
            className="w-10 h-10 rounded-xl bg-white hover:bg-slate-50 border border-slate-200 text-slate-700 flex items-center justify-center shrink-0 shadow-sm active:scale-[0.98] transition-all"
            title="Kirim Pengumuman Tim"
          >
            <Megaphone className="w-4 h-4 text-slate-600" />
          </button>
        </div>
      </div>

      {/* 3. Ringkasan Beban Kerja (Workload 2x2 Grid) */}
      <div className="space-y-2">
        <div className="flex items-center justify-between">
          <h2 className="text-[15px] font-bold text-[#0B1C30] tracking-tight">Ringkasan Beban Kerja</h2>
          <span className="text-xs font-medium text-slate-500">Minggu Ini</span>
        </div>

        <div className="grid grid-cols-2 gap-2.5">
          {/* Card 1: Tugas Aktif */}
          <div
            onClick={() => onNavigateTab('tugas')}
            className="cursor-pointer bg-white rounded-2xl p-3.5 border border-slate-200/80 shadow-sm hover:border-blue-200 transition-all active:scale-[0.99]"
          >
            <div className="flex items-center justify-between">
              <span className="text-xs font-semibold text-slate-700">Tugas Aktif</span>
              <div className="w-7 h-7 rounded-lg bg-blue-50 flex items-center justify-center text-blue-600">
                <Calendar className="w-4 h-4" />
              </div>
            </div>
            <div className="mt-2 flex items-baseline gap-2">
              <span className="text-2xl font-bold tracking-tight text-[#0B1C30]">{activeCount || 24}</span>
            </div>
            <p className="mt-1 text-[11px] font-medium text-blue-600 flex items-center gap-1">
              <TrendingUp className="w-3 h-3 stroke-[2.5]" />
              4 tugas baru
            </p>
          </div>

          {/* Card 2: Selesai */}
          <div
            onClick={() => onNavigateTab('tugas')}
            className="cursor-pointer bg-white rounded-2xl p-3.5 border border-slate-200/80 shadow-sm hover:border-emerald-200 transition-all active:scale-[0.99]"
          >
            <div className="flex items-center justify-between">
              <span className="text-xs font-semibold text-slate-700">Selesai</span>
              <div className="w-7 h-7 rounded-lg bg-blue-50/70 flex items-center justify-center text-blue-500">
                <CheckCircle2 className="w-4 h-4" />
              </div>
            </div>
            <div className="mt-2 flex items-baseline gap-2">
              <span className="text-2xl font-bold tracking-tight text-[#0B1C30]">{completedCount}</span>
            </div>
            <p className="mt-1 text-[11px] font-medium text-emerald-600 flex items-center gap-1">
              <span className="font-bold">↑</span> +18% vs lalu
            </p>
          </div>

          {/* Card 3: Menunggu Review */}
          <div
            onClick={() => onNavigateTab('tugas')}
            className="cursor-pointer bg-white rounded-2xl p-3.5 border border-slate-200/80 shadow-sm hover:border-indigo-200 transition-all active:scale-[0.99]"
          >
            <div className="flex items-center justify-between">
              <span className="text-xs font-semibold text-slate-700">Menunggu Review</span>
              <div className="w-7 h-7 rounded-lg bg-blue-50 flex items-center justify-center text-blue-600">
                <FileCheck className="w-4 h-4" />
              </div>
            </div>
            <div className="mt-2">
              <span className="text-2xl font-bold tracking-tight text-[#0B1C30]">{reviewCount}</span>
            </div>
            <p className="mt-1 text-[11px] font-medium text-slate-500">Butuh persetujuan</p>
          </div>

          {/* Card 4: Mendekati Batas */}
          <div
            onClick={() => onNavigateTab('tugas')}
            className="cursor-pointer bg-white rounded-2xl p-3.5 border border-rose-100 shadow-sm hover:border-rose-300 transition-all active:scale-[0.99]"
          >
            <div className="flex items-center justify-between">
              <span className="text-xs font-semibold text-rose-600">Mendekati Batas</span>
              <div className="w-7 h-7 rounded-lg bg-rose-50 flex items-center justify-center text-rose-500">
                <AlertTriangle className="w-4 h-4" />
              </div>
            </div>
            <div className="mt-2">
              <span className="text-2xl font-bold tracking-tight text-rose-600">{nearDeadlineCount}</span>
            </div>
            <p className="mt-1 text-[11px] font-medium text-rose-600 flex items-center gap-1">
              <Clock className="w-3 h-3 stroke-[2.5]" />
              Tindakan segera
            </p>
          </div>
        </div>
      </div>

      {/* 4. Mendekati Batas Waktu */}
      <div className="space-y-2">
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-1.5 text-[#0B1C30]">
            <Calendar className="w-4 h-4 text-rose-500" />
            <h2 className="text-[15px] font-bold tracking-tight">Mendekati Batas Waktu</h2>
          </div>
          <button
            onClick={() => onNavigateTab('tugas')}
            className="text-xs font-semibold text-[#0051D5] hover:text-blue-800"
          >
            Lihat Semua ({approachingTasks.length || 3})
          </button>
        </div>

        <div className="space-y-2.5">
          {approachingTasks.map((task, idx) => {
            const isFirst = idx === 0;
            return (
              <div
                key={task.id}
                onClick={() => onSelectTask(task)}
                className="cursor-pointer bg-white rounded-2xl p-3.5 border border-slate-200/80 shadow-sm hover:border-blue-200 transition-all active:scale-[0.99]"
              >
                {/* Header Tag & More */}
                <div className="flex items-center justify-between">
                  <span
                    className={`inline-flex items-center gap-1 px-2 py-0.5 rounded-full text-[11px] font-semibold ${
                      isFirst
                        ? 'bg-rose-50 text-rose-600'
                        : 'bg-blue-50 text-blue-700'
                    }`}
                  >
                    <span
                      className={`w-1.5 h-1.5 rounded-full ${
                        isFirst ? 'bg-rose-500' : 'bg-blue-600'
                      }`}
                    />
                    {task.deadlineLabel}
                  </span>

                  <button
                    type="button"
                    onClick={(e) => {
                      e.stopPropagation();
                      onSelectTask(task);
                    }}
                    className="text-slate-400 hover:text-slate-600 p-1"
                  >
                    <MoreVertical className="w-4 h-4" />
                  </button>
                </div>

                {/* Title */}
                <h3 className="mt-2 text-sm font-bold text-slate-900 leading-snug">
                  {task.title}
                </h3>

                {/* Progress */}
                <div className="mt-2.5 space-y-1">
                  <div className="flex items-center justify-between text-[11px] text-slate-500">
                    <span>Penyelesaian</span>
                    <span className="font-semibold text-slate-700">{task.progressPercent}%</span>
                  </div>
                  <div className="w-full h-1.5 bg-slate-100 rounded-full overflow-hidden">
                    <div
                      className="h-full bg-[#0051D5] rounded-full transition-all duration-500"
                      style={{ width: `${task.progressPercent}%` }}
                    />
                  </div>
                </div>

                {/* Assignee & Division Footer */}
                <div className="mt-3 flex items-center justify-between pt-2 border-t border-slate-100">
                  <div className="flex items-center gap-2">
                    <img
                      src={task.assignee.avatar}
                      alt={task.assignee.name}
                      className="w-5 h-5 rounded-full object-cover ring-1 ring-slate-200"
                    />
                    <span className="text-xs font-semibold text-slate-700">
                      {task.assignee.shortName}
                    </span>
                  </div>
                  <span className="text-[11px] px-2 py-0.5 bg-slate-100 text-slate-600 rounded-md font-medium">
                    {task.division.includes('Finance') ? 'Div. Finance' : 'Div. IT Core'}
                  </span>
                </div>
              </div>
            );
          })}
        </div>
      </div>

      {/* 5. Aktivitas Terbaru */}
      <div className="space-y-2">
        <div className="flex items-center justify-between">
          <h2 className="text-[15px] font-bold text-[#0B1C30] tracking-tight">Aktivitas Terbaru</h2>
          <span className="text-xs font-medium text-slate-400">Langsung</span>
        </div>

        <div className="bg-white rounded-2xl p-3.5 border border-slate-200/80 shadow-sm space-y-3.5">
          {activities.map((act, index) => {
            const isSop = act.type === 'sop';
            return (
              <div key={act.id} className={`flex items-start gap-3 ${index > 0 ? 'pt-3 border-t border-slate-100' : ''}`}>
                <div className="relative shrink-0">
                  <img
                    src={act.userAvatar}
                    alt={act.userName}
                    className="w-8 h-8 rounded-full object-cover ring-1 ring-slate-200"
                  />
                  <span className="absolute -bottom-1 -right-1 w-4 h-4 bg-white rounded-full flex items-center justify-center shadow-xs">
                    {isSop ? (
                      <Check className="w-2.5 h-2.5 text-blue-600 stroke-[3]" />
                    ) : (
                      <RefreshCw className="w-2.5 h-2.5 text-blue-500 stroke-[2.5]" />
                    )}
                  </span>
                </div>

                <div className="flex-1 min-w-0">
                  <p className="text-xs text-slate-700 leading-snug">
                    <span className="font-bold text-slate-900">{act.userName}</span>{' '}
                    {act.actionPrefix}{' '}
                    <span className="font-semibold text-[#0051D5]">{act.targetObject}</span>
                    {act.actionSuffix && ` ${act.actionSuffix}`}
                  </p>
                  <p className="text-[11px] text-slate-400 mt-0.5">
                    {act.timeAgo} • {act.department}
                  </p>
                </div>
              </div>
            );
          })}
        </div>
      </div>
    </div>
  );
};
