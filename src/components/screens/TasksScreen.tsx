import React, { useState, useMemo } from 'react';
import {
  Search,
  X,
  SlidersHorizontal,
  MoreVertical,
  CheckSquare,
  Clock,
  Calendar,
  RefreshCw,
  FileCheck,
  Plus,
} from 'lucide-react';
import { Task, TaskStatus } from '../../types';
import { EMPLOYEES } from '../../data/mockData';

interface TasksScreenProps {
  tasks: Task[];
  onOpenCreateTask: () => void;
  onOpenUpdateProgress: (task: Task) => void;
  onOpenReview: (task: Task) => void;
}

export const TasksScreen: React.FC<TasksScreenProps> = ({
  tasks,
  onOpenCreateTask,
  onOpenUpdateProgress,
  onOpenReview,
}) => {
  const [searchQuery, setSearchQuery] = useState('');
  const [selectedDivision, setSelectedDivision] = useState<string>('Semua Divisi');
  const [selectedEmployeeId, setSelectedEmployeeId] = useState<string>('ALL');
  const [selectedStatus, setSelectedStatus] = useState<TaskStatus>('Dalam Proses');

  const divisions = [
    'Semua Divisi',
    'Operasional',
    'IT & Tech',
    'Pemasaran',
    'Finance & Akuntansi',
  ];

  // Counts for tabs
  const notStartedCount = tasks.filter((t) => t.status === 'Belum Dimulai').length || 5;
  const inProgressCount = tasks.filter((t) => t.status === 'Dalam Proses').length || 14;
  const completedCount = tasks.filter((t) => t.status === 'Selesai').length || 28;

  // Filter tasks
  const filteredTasks = useMemo(() => {
    return tasks.filter((task) => {
      // Status match
      if (task.status !== selectedStatus) {
        return false;
      }

      // Division match
      if (selectedDivision !== 'Semua Divisi' && !task.division.includes(selectedDivision.replace(' & Tech', ''))) {
        return false;
      }

      // Employee match
      if (selectedEmployeeId !== 'ALL' && task.assignee.id !== selectedEmployeeId) {
        return false;
      }

      // Search query
      if (searchQuery.trim()) {
        const q = searchQuery.toLowerCase();
        const matchTitle = task.title.toLowerCase().includes(q);
        const matchDesc = task.description.toLowerCase().includes(q);
        const matchAssignee = task.assignee.name.toLowerCase().includes(q);
        return matchTitle || matchDesc || matchAssignee;
      }

      return true;
    });
  }, [tasks, selectedStatus, selectedDivision, selectedEmployeeId, searchQuery]);

  return (
    <div className="space-y-3 pb-20 px-4 pt-2 relative">
      {/* 1. Search Bar */}
      <div className="flex items-center gap-2">
        <div className="relative flex-1">
          <Search className="absolute left-3.5 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-400" />
          <input
            type="text"
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            placeholder="Cari tugas atau nama karyawan..."
            className="w-full pl-9 pr-9 py-2.5 bg-slate-100/90 border border-slate-200/80 rounded-xl text-xs sm:text-sm text-slate-800 placeholder:text-slate-400 focus:outline-none focus:bg-white focus:ring-2 focus:ring-[#0051D5] transition-all"
          />
          {searchQuery && (
            <button
              onClick={() => setSearchQuery('')}
              className="absolute right-3 top-1/2 -translate-y-1/2 text-slate-400 hover:text-slate-600"
            >
              <X className="w-4 h-4" />
            </button>
          )}
        </div>

        <button
          className="w-10 h-10 rounded-xl bg-blue-50 border border-blue-100 flex items-center justify-center text-[#0051D5] hover:bg-blue-100 transition-colors shrink-0"
          title="Filter Lanjutan"
        >
          <SlidersHorizontal className="w-4 h-4" />
        </button>
      </div>

      {/* 2. Division Filters (Horizontal scroll) */}
      <div className="flex items-center gap-1.5 overflow-x-auto no-scrollbar py-1">
        {divisions.map((div) => {
          const isActive = selectedDivision === div;
          return (
            <button
              key={div}
              onClick={() => setSelectedDivision(div)}
              className={`px-3.5 py-1.5 rounded-full text-xs font-semibold whitespace-nowrap transition-all ${
                isActive
                  ? 'bg-[#00236F] text-white shadow-sm'
                  : 'bg-white text-slate-600 border border-slate-200 hover:bg-slate-50'
              }`}
            >
              {div}
            </button>
          );
        })}
      </div>

      {/* 3. Employee Filters (Horizontal scroll) */}
      <div className="flex items-center gap-2 overflow-x-auto no-scrollbar py-0.5">
        <button
          onClick={() => setSelectedEmployeeId('ALL')}
          className={`inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-xs font-semibold whitespace-nowrap transition-all ${
            selectedEmployeeId === 'ALL'
              ? 'bg-[#0051D5] text-white shadow-xs'
              : 'bg-white text-slate-600 border border-slate-200 hover:bg-slate-50'
          }`}
        >
          <span className="text-[10px] font-extrabold uppercase tracking-wider">ALL</span>
          <span>Semua Karyawan</span>
        </button>

        {EMPLOYEES.map((emp) => {
          const isActive = selectedEmployeeId === emp.id;
          return (
            <button
              key={emp.id}
              onClick={() => setSelectedEmployeeId(emp.id)}
              className={`inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full text-xs font-semibold whitespace-nowrap transition-all ${
                isActive
                  ? 'bg-blue-50 text-blue-700 border-2 border-[#0051D5]'
                  : 'bg-white text-slate-700 border border-slate-200 hover:bg-slate-50'
              }`}
            >
              <img
                src={emp.avatar}
                alt={emp.name}
                className="w-4 h-4 rounded-full object-cover"
              />
              <span>{emp.shortName}</span>
            </button>
          );
        })}
      </div>

      {/* 4. Status Tabs (Belum Dimulai, Dalam Proses, Selesai) */}
      <div className="bg-slate-100/90 p-1 rounded-2xl flex items-center justify-between gap-1 border border-slate-200/70">
        {/* Belum Dimulai */}
        <button
          onClick={() => setSelectedStatus('Belum Dimulai')}
          className={`flex-1 flex items-center justify-center gap-1.5 py-2 px-2 rounded-xl text-xs transition-all ${
            selectedStatus === 'Belum Dimulai'
              ? 'bg-white text-slate-900 font-bold shadow-xs'
              : 'text-slate-600 font-medium hover:text-slate-900'
          }`}
        >
          <span>Belum Dimulai</span>
          <span className="text-[11px] text-slate-400 font-medium">{notStartedCount}</span>
        </button>

        {/* Dalam Proses */}
        <button
          onClick={() => setSelectedStatus('Dalam Proses')}
          className={`flex-1 flex items-center justify-center gap-1.5 py-2 px-2 rounded-xl text-xs transition-all ${
            selectedStatus === 'Dalam Proses'
              ? 'bg-white text-slate-900 font-bold shadow-xs'
              : 'text-slate-600 font-medium hover:text-slate-900'
          }`}
        >
          <span>Dalam Proses</span>
          <span className="px-1.5 py-0.2 rounded-full bg-[#0051D5] text-white text-[10px] font-extrabold">
            {inProgressCount}
          </span>
        </button>

        {/* Selesai */}
        <button
          onClick={() => setSelectedStatus('Selesai')}
          className={`flex-1 flex items-center justify-center gap-1.5 py-2 px-2 rounded-xl text-xs transition-all ${
            selectedStatus === 'Selesai'
              ? 'bg-white text-slate-900 font-bold shadow-xs'
              : 'text-slate-600 font-medium hover:text-slate-900'
          }`}
        >
          <span>Selesai</span>
          <span className="text-[11px] text-slate-400 font-medium">{completedCount}</span>
        </button>
      </div>

      {/* 5. Task Cards */}
      <div className="space-y-3 pt-1">
        {filteredTasks.length === 0 ? (
          <div className="bg-white rounded-2xl p-8 text-center border border-slate-200 space-y-2">
            <p className="text-sm font-semibold text-slate-700">Tidak ada tugas yang cocok</p>
            <p className="text-xs text-slate-500">Coba ubah kata kunci pencarian atau filter divisi.</p>
            <button
              onClick={() => {
                setSearchQuery('');
                setSelectedDivision('Semua Divisi');
                setSelectedEmployeeId('ALL');
              }}
              className="mt-2 text-xs font-bold text-[#0051D5] underline"
            >
              Reset Filter
            </button>
          </div>
        ) : (
          filteredTasks.map((task) => {
            const isHighPriority = task.priority === 'Prioritas Tinggi';
            const completedSubtasks = task.subtasks.filter((s) => s.completed).length;
            const totalSubtasks = task.subtasks.length;
            const isFinished = task.status === 'Selesai' || task.progressPercent >= 80;

            return (
              <div
                key={task.id}
                className="bg-white rounded-2xl p-4 border border-slate-200/90 shadow-sm hover:border-blue-200 transition-all space-y-3"
              >
                {/* Header: Division Tag + Priority Tag + 3-Dots */}
                <div className="flex items-center justify-between">
                  <div className="flex items-center gap-1.5 flex-wrap">
                    <span className="px-2.5 py-0.5 rounded-md bg-blue-50 text-[#0051D5] text-[11px] font-semibold">
                      {task.division}
                    </span>

                    <span
                      className={`inline-flex items-center gap-1 px-2.5 py-0.5 rounded-md text-[11px] font-semibold ${
                        isHighPriority
                          ? 'bg-rose-50 text-rose-600'
                          : 'bg-blue-50 text-blue-700'
                      }`}
                    >
                      <span
                        className={`w-1.5 h-1.5 rounded-full ${
                          isHighPriority ? 'bg-rose-500' : 'bg-blue-600'
                        }`}
                      />
                      {task.priority}
                    </span>
                  </div>

                  <button
                    onClick={() => onOpenReview(task)}
                    className="text-slate-400 hover:text-slate-600 p-1 rounded-md"
                  >
                    <MoreVertical className="w-4 h-4" />
                  </button>
                </div>

                {/* Title & Description */}
                <div>
                  <h3 className="text-[15px] font-bold text-slate-900 leading-snug">
                    {task.title}
                  </h3>
                  <p className="text-xs text-slate-500 line-clamp-2 mt-1 leading-relaxed">
                    {task.description}
                  </p>
                </div>

                {/* Subtasks Progress Box */}
                <div className="space-y-1.5 pt-1">
                  <div className="flex items-center justify-between text-xs">
                    <span className="font-semibold text-slate-700 flex items-center gap-1.5">
                      <CheckSquare className="w-3.5 h-3.5 text-blue-600" />
                      Subtask Checklist
                    </span>
                    <span className="font-semibold text-slate-600 text-[11px]">
                      {completedSubtasks} / {totalSubtasks} {completedSubtasks === totalSubtasks ? 'selesai' : 'subtask'} ({task.progressPercent}%)
                    </span>
                  </div>

                  <div className="w-full h-2 bg-slate-100 rounded-full overflow-hidden">
                    <div
                      className={`h-full rounded-full transition-all duration-300 ${
                        isFinished ? 'bg-emerald-500' : 'bg-[#0051D5]'
                      }`}
                      style={{ width: `${task.progressPercent}%` }}
                    />
                  </div>
                </div>

                {/* Assignee & Deadline Row */}
                <div className="flex items-center justify-between pt-2 border-t border-slate-100 text-xs">
                  {/* Assignee */}
                  <div className="flex items-center gap-2">
                    <div className="relative flex items-center">
                      <img
                        src={task.assignee.avatar}
                        alt={task.assignee.name}
                        className="w-6 h-6 rounded-full object-cover ring-1 ring-white"
                      />
                      {task.assignee.hasTeamBadge && (
                        <span className="w-4 h-4 rounded-full bg-[#00236F] text-white text-[9px] font-bold flex items-center justify-center -ml-1.5 ring-1 ring-white">
                          +{task.assignee.teamCount}
                        </span>
                      )}
                    </div>
                    <span className="font-semibold text-slate-800 text-xs">
                      {task.assignee.name} {task.assignee.hasTeamBadge ? '& Tim' : ''}
                    </span>
                  </div>

                  {/* Deadline Badge */}
                  <span
                    className={`inline-flex items-center gap-1 px-2.5 py-1 rounded-md text-[11px] font-semibold ${
                      task.isUrgentDeadline
                        ? 'bg-rose-50 text-rose-600'
                        : 'bg-slate-100 text-slate-700'
                    }`}
                  >
                    {task.isUrgentDeadline ? (
                      <Clock className="w-3 h-3 text-rose-500" />
                    ) : (
                      <Calendar className="w-3 h-3 text-slate-500" />
                    )}
                    {task.deadlineLabel}
                  </span>
                </div>

                {/* Bottom Action Buttons: Update Progres & Review */}
                <div className="grid grid-cols-2 gap-2 pt-1">
                  <button
                    onClick={() => onOpenUpdateProgress(task)}
                    className="inline-flex items-center justify-center gap-1.5 py-2.5 px-3 rounded-xl bg-[#0051D5] hover:bg-blue-700 active:bg-blue-900 text-white text-xs font-semibold shadow-xs active:scale-[0.98] transition-all"
                  >
                    <RefreshCw className="w-3.5 h-3.5" />
                    <span>Update Progres</span>
                  </button>

                  <button
                    onClick={() => onOpenReview(task)}
                    className="inline-flex items-center justify-center gap-1.5 py-2.5 px-3 rounded-xl bg-blue-50/70 hover:bg-blue-100/80 active:bg-blue-200 border border-blue-200 text-[#0051D5] text-xs font-semibold active:scale-[0.98] transition-all"
                  >
                    <FileCheck className="w-3.5 h-3.5" />
                    <span>Review</span>
                  </button>
                </div>
              </div>
            );
          })
        )}
      </div>

      {/* Floating Action Button (+ + Tugas) */}
      <div className="fixed bottom-20 right-4 sm:right-6 z-20">
        <button
          onClick={onOpenCreateTask}
          className="inline-flex items-center gap-2 px-4 py-3 rounded-full bg-[#0051D5] hover:bg-blue-700 active:bg-[#00236F] text-white text-sm font-bold shadow-lg shadow-blue-600/30 active:scale-95 transition-all"
        >
          <Plus className="w-4 h-4 stroke-[3]" />
          <span>+ Tugas</span>
        </button>
      </div>
    </div>
  );
};
