import React, { useState } from 'react';
import {
  Users,
  Bell,
  Mail,
  ShieldCheck,
  Check,
  CheckCircle2,
  Clock,
  ChevronRight,
  UserCheck,
} from 'lucide-react';
import { EMPLOYEES, NOTIFICATIONS_DATA, CURRENT_USER } from '../../data/mockData';
import { Assignee } from '../../types';

interface TeamScreenProps {
  onSelectMember?: (member: Assignee) => void;
  onOpenCreateTaskForMember?: (member: Assignee) => void;
}

export const TeamScreen: React.FC<TeamScreenProps> = ({
  onOpenCreateTaskForMember,
}) => {
  const [activeSubTab, setActiveSubTab] = useState<'tim' | 'notif'>('tim');
  const [notifications, setNotifications] = useState(NOTIFICATIONS_DATA);

  const markAllRead = () => {
    setNotifications((prev) => prev.map((n) => ({ ...n, unread: false })));
  };

  const markSingleRead = (id: string) => {
    setNotifications((prev) =>
      prev.map((n) => (n.id === id ? { ...n, unread: false } : n))
    );
  };

  return (
    <div className="space-y-4 pb-20 px-4 pt-2">
      {/* 1. Header & Segmented Subtab */}
      <div className="flex items-center justify-between">
        <div>
          <span className="text-[11px] font-extrabold uppercase tracking-wider text-[#0051D5]">
            KOLABORASI & NOTIFIKASI
          </span>
          <h1 className="text-xl font-bold tracking-tight text-[#0B1C30]">
            Tim & Notif
          </h1>
        </div>

        {/* Subtab Pill Switcher */}
        <div className="bg-slate-100 p-1 rounded-xl flex items-center border border-slate-200/80">
          <button
            onClick={() => setActiveSubTab('tim')}
            className={`flex items-center gap-1.5 px-3 py-1.5 rounded-lg text-xs font-bold transition-all ${
              activeSubTab === 'tim'
                ? 'bg-white text-[#00236F] shadow-xs'
                : 'text-slate-600 hover:text-slate-900'
            }`}
          >
            <Users className="w-3.5 h-3.5" />
            <span>Anggota</span>
          </button>
          <button
            onClick={() => setActiveSubTab('notif')}
            className={`flex items-center gap-1.5 px-3 py-1.5 rounded-lg text-xs font-bold transition-all relative ${
              activeSubTab === 'notif'
                ? 'bg-white text-[#00236F] shadow-xs'
                : 'text-slate-600 hover:text-slate-900'
            }`}
          >
            <Bell className="w-3.5 h-3.5" />
            <span>Notif</span>
            {notifications.some((n) => n.unread) && (
              <span className="w-2 h-2 rounded-full bg-rose-500" />
            )}
          </button>
        </div>
      </div>

      {/* SUBTAB 1: TIM */}
      {activeSubTab === 'tim' && (
        <div className="space-y-3.5">
          {/* Manager Profile Highlight */}
          <div className="bg-gradient-to-br from-white to-blue-50/50 rounded-2xl p-4 border border-blue-100 shadow-sm flex items-center gap-3.5">
            <img
              src={CURRENT_USER.avatar}
              alt={CURRENT_USER.name}
              className="w-14 h-14 rounded-2xl object-cover ring-2 ring-blue-600/20"
            />
            <div className="flex-1 min-w-0">
              <div className="flex items-center gap-1.5">
                <h3 className="text-sm font-bold text-slate-900 truncate">
                  {CURRENT_USER.name}
                </h3>
                <span className="px-2 py-0.5 rounded-full bg-blue-100 text-[#0051D5] text-[10px] font-bold">
                  {CURRENT_USER.role}
                </span>
              </div>
              <p className="text-xs text-slate-500 mt-0.5">{CURRENT_USER.email}</p>
              <div className="flex items-center gap-3 mt-1.5 text-[11px] text-slate-600">
                <span className="flex items-center gap-1 text-emerald-700 font-semibold">
                  <ShieldCheck className="w-3.5 h-3.5" />
                  Divisi: {CURRENT_USER.division}
                </span>
              </div>
            </div>
          </div>

          {/* Members List */}
          <div className="space-y-2.5">
            <div className="flex items-center justify-between">
              <h2 className="text-sm font-bold text-slate-900">
                Daftar Karyawan ({EMPLOYEES.length})
              </h2>
              <span className="text-xs text-slate-500 font-medium">Semua Aktif</span>
            </div>

            <div className="space-y-2.5">
              {EMPLOYEES.map((emp) => (
                <div
                  key={emp.id}
                  className="bg-white rounded-2xl p-3.5 border border-slate-200/90 shadow-sm flex items-center justify-between gap-3 hover:border-blue-200 transition-all"
                >
                  <div className="flex items-center gap-3 min-w-0">
                    <img
                      src={emp.avatar}
                      alt={emp.name}
                      className="w-10 h-10 rounded-full object-cover ring-1 ring-slate-200"
                    />
                    <div className="min-w-0">
                      <h4 className="text-xs sm:text-sm font-bold text-slate-900 truncate">
                        {emp.name}
                      </h4>
                      <p className="text-[11px] text-slate-500 truncate">
                        {emp.role} • <span className="font-semibold text-[#0051D5]">{emp.division}</span>
                      </p>
                    </div>
                  </div>

                  <div className="flex items-center gap-1.5 shrink-0">
                    <button
                      onClick={() => onOpenCreateTaskForMember && onOpenCreateTaskForMember(emp)}
                      className="px-2.5 py-1.5 rounded-xl bg-blue-50 hover:bg-blue-100 text-[#0051D5] text-xs font-semibold active:scale-95 transition-all"
                      title="Beri Tugas"
                    >
                      Beri Tugas
                    </button>
                  </div>
                </div>
              ))}
            </div>
          </div>
        </div>
      )}

      {/* SUBTAB 2: NOTIFIKASI */}
      {activeSubTab === 'notif' && (
        <div className="space-y-3">
          <div className="flex items-center justify-between">
            <span className="text-xs font-semibold text-slate-500">
              Pemberitahuan Terbaru
            </span>
            <button
              onClick={markAllRead}
              className="text-xs font-bold text-[#0051D5] hover:text-blue-800"
            >
              Tandai Semua Dibaca
            </button>
          </div>

          <div className="space-y-2.5">
            {notifications.map((notif) => (
              <div
                key={notif.id}
                onClick={() => markSingleRead(notif.id)}
                className={`cursor-pointer rounded-2xl p-3.5 border transition-all flex items-start gap-3 ${
                  notif.unread
                    ? 'bg-blue-50/50 border-blue-200 shadow-xs'
                    : 'bg-white border-slate-200/80'
                }`}
              >
                <div
                  className={`w-9 h-9 rounded-xl flex items-center justify-center shrink-0 ${
                    notif.type === 'urgent'
                      ? 'bg-rose-100 text-rose-600'
                      : notif.type === 'sop'
                      ? 'bg-blue-100 text-blue-700'
                      : 'bg-slate-100 text-slate-700'
                  }`}
                >
                  {notif.type === 'deadline' ? (
                    <Clock className="w-4 h-4" />
                  ) : notif.type === 'sop' ? (
                    <UserCheck className="w-4 h-4" />
                  ) : (
                    <Bell className="w-4 h-4" />
                  )}
                </div>

                <div className="flex-1 min-w-0">
                  <div className="flex items-center justify-between gap-1">
                    <h4 className="text-xs sm:text-sm font-bold text-slate-900">
                      {notif.title}
                    </h4>
                    {notif.unread && (
                      <span className="w-2 h-2 rounded-full bg-[#0051D5] shrink-0" />
                    )}
                  </div>
                  <p className="text-xs text-slate-600 mt-0.5 leading-snug">
                    {notif.description}
                  </p>
                  <p className="text-[11px] text-slate-400 mt-1">{notif.time}</p>
                </div>
              </div>
            ))}
          </div>
        </div>
      )}
    </div>
  );
};
