import React from 'react';
import { X, CheckCircle, AlertCircle, FileText, Check } from 'lucide-react';
import { Task } from '../../types';

interface ReviewTaskModalProps {
  task: Task | null;
  isOpen: boolean;
  onClose: () => void;
  onApproveTask: (taskId: string) => void;
}

export const ReviewTaskModal: React.FC<ReviewTaskModalProps> = ({
  task,
  isOpen,
  onClose,
  onApproveTask,
}) => {
  if (!isOpen || !task) return null;

  return (
    <div className="fixed inset-0 z-50 flex items-end sm:items-center justify-center bg-slate-900/50 backdrop-blur-xs p-0 sm:p-4">
      <div className="w-full max-w-lg bg-white rounded-t-3xl sm:rounded-2xl shadow-xl overflow-hidden max-h-[90vh] flex flex-col animate-in slide-in-from-bottom duration-200">
        {/* Header */}
        <div className="px-5 py-4 border-b border-slate-100 flex items-center justify-between">
          <div className="flex items-center gap-2">
            <FileText className="w-4 h-4 text-[#0051D5]" />
            <h2 className="text-base font-bold text-slate-900">Review & Persetujuan Tugas</h2>
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
          <div className="space-y-1">
            <div className="flex items-center gap-2">
              <span className="px-2.5 py-0.5 rounded-md bg-blue-50 text-[#0051D5] text-[11px] font-bold">
                {task.division}
              </span>
              <span className="px-2.5 py-0.5 rounded-md bg-rose-50 text-rose-600 text-[11px] font-bold">
                {task.priority}
              </span>
            </div>
            <h3 className="text-lg font-bold text-slate-900 mt-2">
              {task.title}
            </h3>
            <p className="text-xs text-slate-600 leading-relaxed">
              {task.description}
            </p>
          </div>

          {/* Assignee Card */}
          <div className="bg-slate-50 p-3.5 rounded-2xl border border-slate-200/80 flex items-center justify-between">
            <div className="flex items-center gap-3">
              <img
                src={task.assignee.avatar}
                alt={task.assignee.name}
                className="w-10 h-10 rounded-full object-cover ring-1 ring-slate-200"
              />
              <div>
                <h4 className="text-xs font-bold text-slate-900">
                  {task.assignee.name}
                </h4>
                <p className="text-[11px] text-slate-500">
                  {task.assignee.role} • {task.assignee.division}
                </p>
              </div>
            </div>
            <span className="text-xs font-bold text-slate-700 bg-white px-2.5 py-1 rounded-lg border border-slate-200">
              {task.deadlineLabel}
            </span>
          </div>

          {/* Subtasks Summary */}
          <div className="space-y-2">
            <h4 className="text-xs font-bold text-slate-700">
              Daftar Subtask ({task.subtasks.filter((s) => s.completed).length}/{task.subtasks.length} Selesai)
            </h4>
            <div className="space-y-1.5 max-h-48 overflow-y-auto">
              {task.subtasks.map((st) => (
                <div
                  key={st.id}
                  className="flex items-center gap-2.5 p-2 bg-slate-50 rounded-xl text-xs"
                >
                  <span
                    className={`w-4 h-4 rounded-full flex items-center justify-center text-[10px] font-bold ${
                      st.completed ? 'bg-emerald-500 text-white' : 'bg-slate-200 text-slate-500'
                    }`}
                  >
                    {st.completed ? '✓' : '•'}
                  </span>
                  <span className={st.completed ? 'text-slate-500 line-through' : 'text-slate-800'}>
                    {st.title}
                  </span>
                </div>
              ))}
            </div>
          </div>

          {/* Actions */}
          <div className="pt-3 grid grid-cols-2 gap-2.5">
            <button
              onClick={onClose}
              className="py-2.5 rounded-xl border border-slate-200 text-slate-700 text-xs font-semibold hover:bg-slate-50 transition-colors"
            >
              Minta Revisi
            </button>
            <button
              onClick={() => {
                onApproveTask(task.id);
                onClose();
              }}
              className="py-2.5 rounded-xl bg-emerald-600 hover:bg-emerald-700 text-white text-xs font-bold shadow-md shadow-emerald-600/20 active:scale-95 transition-all flex items-center justify-center gap-1.5"
            >
              <Check className="w-4 h-4 stroke-[3]" />
              <span>Setujui & Selesaikan</span>
            </button>
          </div>
        </div>
      </div>
    </div>
  );
};
