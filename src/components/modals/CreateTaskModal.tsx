import React, { useState } from 'react';
import { X, Plus, Trash2, Calendar, Clock, AlertCircle } from 'lucide-react';
import { Task, PriorityType, Assignee } from '../../types';
import { EMPLOYEES } from '../../data/mockData';

interface CreateTaskModalProps {
  isOpen: boolean;
  onClose: () => void;
  onCreateTask: (newTask: Partial<Task>) => void;
  defaultAssignee?: Assignee | null;
}

export const CreateTaskModal: React.FC<CreateTaskModalProps> = ({
  isOpen,
  onClose,
  onCreateTask,
  defaultAssignee,
}) => {
  const [title, setTitle] = useState('');
  const [description, setDescription] = useState('');
  const [division, setDivision] = useState('IT & Tech');
  const [priority, setPriority] = useState<PriorityType>('Prioritas Tinggi');
  const [assigneeId, setAssigneeId] = useState(defaultAssignee?.id || EMPLOYEES[0].id);
  const [deadlineDate, setDeadlineDate] = useState('Besok, 17:00');
  const [subtasks, setSubtasks] = useState<string[]>([
    'Tahap 1: Analisis kebutuhan & dokumen acuan',
    'Tahap 2: Eksekusi implementasi sistem',
  ]);
  const [newSubtaskInput, setNewSubtaskInput] = useState('');

  if (!isOpen) return null;

  const handleAddSubtask = () => {
    if (newSubtaskInput.trim()) {
      setSubtasks([...subtasks, newSubtaskInput.trim()]);
      setNewSubtaskInput('');
    }
  };

  const handleRemoveSubtask = (index: number) => {
    setSubtasks(subtasks.filter((_, i) => i !== index));
  };

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (!title.trim()) return;

    const selectedAssignee =
      EMPLOYEES.find((emp) => emp.id === assigneeId) || EMPLOYEES[0];

    const newTask: Partial<Task> = {
      id: `tsk-${Date.now()}`,
      title: title.trim(),
      description: description.trim() || 'Instruksi operasional telah ditentukan.',
      division,
      priority,
      status: 'Dalam Proses',
      deadlineLabel: deadlineDate,
      isUrgentDeadline: priority === 'Prioritas Tinggi',
      progressPercent: 0,
      assignee: selectedAssignee,
      subtasks: subtasks.map((st, i) => ({
        id: `st-${Date.now()}-${i}`,
        title: st,
        completed: false,
      })),
      needsReview: true,
    };

    onCreateTask(newTask);
    onClose();
  };

  return (
    <div className="fixed inset-0 z-50 flex items-end sm:items-center justify-center bg-slate-900/50 backdrop-blur-xs p-0 sm:p-4">
      <div className="w-full max-w-lg bg-white rounded-t-3xl sm:rounded-2xl shadow-xl overflow-hidden max-h-[90vh] flex flex-col animate-in slide-in-from-bottom duration-200">
        {/* Header */}
        <div className="px-5 py-4 border-b border-slate-100 flex items-center justify-between">
          <div className="flex items-center gap-2">
            <span className="w-2 h-2 rounded-full bg-[#0051D5]" />
            <h2 className="text-base font-bold text-slate-900">Buat Tugas Baru</h2>
          </div>
          <button
            onClick={onClose}
            className="w-8 h-8 rounded-full hover:bg-slate-100 flex items-center justify-center text-slate-400 hover:text-slate-600 transition-colors"
          >
            <X className="w-4 h-4" />
          </button>
        </div>

        {/* Scrollable Form Body */}
        <form onSubmit={handleSubmit} className="p-5 overflow-y-auto space-y-4">
          {/* Judul Tugas */}
          <div className="space-y-1.5">
            <label className="text-xs font-bold text-slate-700">
              Judul Tugas <span className="text-rose-500">*</span>
            </label>
            <input
              type="text"
              required
              value={title}
              onChange={(e) => setTitle(e.target.value)}
              placeholder="Contoh: Audit Keamanan Jaringan Cabang"
              className="w-full px-3.5 py-2.5 rounded-xl border border-slate-200 text-xs sm:text-sm text-slate-900 placeholder:text-slate-400 focus:outline-none focus:ring-2 focus:ring-[#0051D5]"
            />
          </div>

          {/* Deskripsi */}
          <div className="space-y-1.5">
            <label className="text-xs font-bold text-slate-700">Deskripsi / Ruang Lingkup</label>
            <textarea
              rows={2}
              value={description}
              onChange={(e) => setDescription(e.target.value)}
              placeholder="Rincian prosedur yang harus diselesaikan..."
              className="w-full px-3.5 py-2 rounded-xl border border-slate-200 text-xs text-slate-900 placeholder:text-slate-400 focus:outline-none focus:ring-2 focus:ring-[#0051D5]"
            />
          </div>

          {/* Divisi & Prioritas */}
          <div className="grid grid-cols-2 gap-3">
            <div className="space-y-1.5">
              <label className="text-xs font-bold text-slate-700">Divisi</label>
              <select
                value={division}
                onChange={(e) => setDivision(e.target.value)}
                className="w-full px-3 py-2.5 rounded-xl border border-slate-200 text-xs text-slate-800 bg-white focus:outline-none focus:ring-2 focus:ring-[#0051D5]"
              >
                <option value="IT & Tech">IT & Tech</option>
                <option value="Operasional">Operasional</option>
                <option value="Pemasaran">Pemasaran</option>
                <option value="Finance & Akuntansi">Finance & Akuntansi</option>
              </select>
            </div>

            <div className="space-y-1.5">
              <label className="text-xs font-bold text-slate-700">Prioritas</label>
              <select
                value={priority}
                onChange={(e) => setPriority(e.target.value as PriorityType)}
                className="w-full px-3 py-2.5 rounded-xl border border-slate-200 text-xs text-slate-800 bg-white focus:outline-none focus:ring-2 focus:ring-[#0051D5]"
              >
                <option value="Prioritas Tinggi">Prioritas Tinggi (Urgent)</option>
                <option value="Prioritas Sedang">Prioritas Sedang</option>
                <option value="Prioritas Rendah">Prioritas Rendah</option>
              </select>
            </div>
          </div>

          {/* Penanggung Jawab (Assignee) */}
          <div className="space-y-1.5">
            <label className="text-xs font-bold text-slate-700">Penanggung Jawab</label>
            <select
              value={assigneeId}
              onChange={(e) => setAssigneeId(e.target.value)}
              className="w-full px-3 py-2.5 rounded-xl border border-slate-200 text-xs text-slate-800 bg-white focus:outline-none focus:ring-2 focus:ring-[#0051D5]"
            >
              {EMPLOYEES.map((emp) => (
                <option key={emp.id} value={emp.id}>
                  {emp.name} ({emp.division}) - {emp.role}
                </option>
              ))}
            </select>
          </div>

          {/* Batas Waktu (Deadline) */}
          <div className="space-y-1.5">
            <label className="text-xs font-bold text-slate-700">Batas Waktu (Deadline)</label>
            <input
              type="text"
              value={deadlineDate}
              onChange={(e) => setDeadlineDate(e.target.value)}
              placeholder="Contoh: Hari ini 18:00 atau 2 hari lagi"
              className="w-full px-3.5 py-2 rounded-xl border border-slate-200 text-xs text-slate-900 focus:outline-none focus:ring-2 focus:ring-[#0051D5]"
            />
          </div>

          {/* Subtask Checklist Builder */}
          <div className="space-y-2 pt-1 border-t border-slate-100">
            <label className="text-xs font-bold text-slate-700 flex items-center justify-between">
              <span>Subtask Checklist ({subtasks.length})</span>
              <span className="text-[11px] text-slate-400 font-normal">Wajib diisi</span>
            </label>

            <div className="space-y-1.5">
              {subtasks.map((st, idx) => (
                <div key={idx} className="flex items-center gap-2 bg-slate-50 px-3 py-1.5 rounded-xl text-xs text-slate-700 border border-slate-200/70">
                  <span className="w-4 text-center font-bold text-slate-400 text-[11px]">{idx + 1}</span>
                  <span className="flex-1 truncate">{st}</span>
                  <button
                    type="button"
                    onClick={() => handleRemoveSubtask(idx)}
                    className="text-slate-400 hover:text-rose-500 p-1"
                  >
                    <Trash2 className="w-3.5 h-3.5" />
                  </button>
                </div>
              ))}
            </div>

            <div className="flex items-center gap-2 mt-2">
              <input
                type="text"
                value={newSubtaskInput}
                onChange={(e) => setNewSubtaskInput(e.target.value)}
                onKeyDown={(e) => {
                  if (e.key === 'Enter') {
                    e.preventDefault();
                    handleAddSubtask();
                  }
                }}
                placeholder="Tambah butir subtask baru..."
                className="flex-1 px-3 py-2 text-xs rounded-xl border border-slate-200 focus:outline-none focus:ring-2 focus:ring-[#0051D5]"
              />
              <button
                type="button"
                onClick={handleAddSubtask}
                className="px-3 py-2 rounded-xl bg-slate-100 hover:bg-slate-200 text-slate-700 text-xs font-semibold flex items-center gap-1 transition-colors"
              >
                <Plus className="w-3.5 h-3.5" />
                <span>Tambah</span>
              </button>
            </div>
          </div>

          {/* Submit Buttons */}
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
              Simpan & Terbitkan Tugas
            </button>
          </div>
        </form>
      </div>
    </div>
  );
};
