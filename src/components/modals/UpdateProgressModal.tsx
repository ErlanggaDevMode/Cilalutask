import React, { useState } from 'react';
import { X, CheckSquare, Square, Check, RefreshCw } from 'lucide-react';
import { Task, Subtask } from '../../types';

interface UpdateProgressModalProps {
  task: Task | null;
  isOpen: boolean;
  onClose: () => void;
  onSaveProgress: (taskId: string, updatedSubtasks: Subtask[], progressPercent: number) => void;
}

export const UpdateProgressModal: React.FC<UpdateProgressModalProps> = ({
  task,
  isOpen,
  onClose,
  onSaveProgress,
}) => {
  if (!isOpen || !task) return null;

  const [subtasks, setSubtasks] = useState<Subtask[]>(task.subtasks);

  const toggleSubtask = (id: string) => {
    const updated = subtasks.map((st) =>
      st.id === id ? { ...st, completed: !st.completed } : st
    );
    setSubtasks(updated);
  };

  const completedCount = subtasks.filter((s) => s.completed).length;
  const totalCount = subtasks.length;
  const computedPercent = totalCount > 0 ? Math.round((completedCount / totalCount) * 100) : 100;

  const handleSave = () => {
    onSaveProgress(task.id, subtasks, computedPercent);
    onClose();
  };

  return (
    <div className="fixed inset-0 z-50 flex items-end sm:items-center justify-center bg-slate-900/50 backdrop-blur-xs p-0 sm:p-4">
      <div className="w-full max-w-lg bg-white rounded-t-3xl sm:rounded-2xl shadow-xl overflow-hidden max-h-[90vh] flex flex-col animate-in slide-in-from-bottom duration-200">
        {/* Header */}
        <div className="px-5 py-4 border-b border-slate-100 flex items-center justify-between">
          <div className="flex items-center gap-2">
            <RefreshCw className="w-4 h-4 text-[#0051D5]" />
            <h2 className="text-base font-bold text-slate-900">Update Progres Tugas</h2>
          </div>
          <button
            onClick={onClose}
            className="w-8 h-8 rounded-full hover:bg-slate-100 flex items-center justify-center text-slate-400 hover:text-slate-600 transition-colors"
          >
            <X className="w-4 h-4" />
          </button>
        </div>

        {/* Content */}
        <div className="p-5 overflow-y-auto space-y-4">
          <div>
            <div className="flex items-center gap-2">
              <span className="px-2 py-0.5 rounded-md bg-blue-50 text-[#0051D5] text-[11px] font-bold">
                {task.division}
              </span>
              <span className="text-xs text-slate-500 font-medium">
                PIC: {task.assignee.name}
              </span>
            </div>
            <h3 className="text-base font-bold text-slate-900 mt-1 leading-snug">
              {task.title}
            </h3>
          </div>

          {/* Progress Indicator Card */}
          <div className="bg-blue-50/70 rounded-2xl p-4 border border-blue-100 space-y-2">
            <div className="flex items-center justify-between text-xs font-bold text-slate-800">
              <span>Tingkat Penyelesaian Subtask</span>
              <span className="text-[#0051D5] text-sm">
                {completedCount} / {totalCount} ({computedPercent}%)
              </span>
            </div>
            <div className="w-full h-2.5 bg-blue-100 rounded-full overflow-hidden">
              <div
                className={`h-full rounded-full transition-all duration-300 ${
                  computedPercent === 100 ? 'bg-emerald-500' : 'bg-[#0051D5]'
                }`}
                style={{ width: `${computedPercent}%` }}
              />
            </div>
          </div>

          {/* Subtask Checklist */}
          <div className="space-y-2">
            <label className="text-xs font-bold text-slate-700 block">
              Centang subtask yang sudah diselesaikan:
            </label>

            <div className="space-y-2">
              {subtasks.map((st) => (
                <div
                  key={st.id}
                  onClick={() => toggleSubtask(st.id)}
                  className={`cursor-pointer p-3 rounded-xl border flex items-start gap-3 transition-all ${
                    st.completed
                      ? 'bg-emerald-50/60 border-emerald-200 text-slate-800'
                      : 'bg-white border-slate-200 hover:border-blue-200 text-slate-700'
                  }`}
                >
                  <div className="mt-0.5 shrink-0">
                    {st.completed ? (
                      <CheckSquare className="w-5 h-5 text-emerald-600" />
                    ) : (
                      <Square className="w-5 h-5 text-slate-400" />
                    )}
                  </div>
                  <span
                    className={`text-xs sm:text-sm font-medium leading-snug ${
                      st.completed ? 'line-through text-slate-400 font-normal' : ''
                    }`}
                  >
                    {st.title}
                  </span>
                </div>
              ))}
            </div>
          </div>

          {/* Actions */}
          <div className="pt-3 flex items-center gap-2.5">
            <button
              onClick={onClose}
              className="flex-1 py-2.5 rounded-xl border border-slate-200 text-slate-700 text-xs font-semibold hover:bg-slate-50 transition-colors"
            >
              Tutup
            </button>
            <button
              onClick={handleSave}
              className="flex-1 py-2.5 rounded-xl bg-[#0051D5] hover:bg-blue-700 text-white text-xs font-bold shadow-md shadow-blue-600/20 active:scale-95 transition-all"
            >
              Simpan Pembaruan
            </button>
          </div>
        </div>
      </div>
    </div>
  );
};
