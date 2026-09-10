import React from 'react';
import { Bell, ShieldCheck } from 'lucide-react';
import { TabType } from '../types';
import { CURRENT_USER } from '../data/mockData';

interface HeaderProps {
  currentTab: TabType;
  unreadNotifsCount: number;
  onOpenNotifications: () => void;
  onOpenProfile: () => void;
}

export const Header: React.FC<HeaderProps> = ({
  currentTab,
  unreadNotifsCount,
  onOpenNotifications,
  onOpenProfile,
}) => {
  const getSubTitle = () => {
    switch (currentTab) {
      case 'beranda':
        return 'Beranda';
      case 'tugas':
        return 'Tugas';
      case 'sop':
        return 'Sop';
      case 'laporan':
        return 'Laporan';
      case 'tim':
        return 'Tim & Notif';
      default:
        return 'Beranda';
    }
  };

  return (
    <header className="sticky top-0 z-30 bg-white/95 backdrop-blur-md border-b border-slate-100 px-4 py-2.5 flex items-center justify-between transition-all">
      {/* Brand & Subtitle */}
      <div className="flex items-center gap-2.5">
        <div className="w-8 h-8 rounded-lg bg-gradient-to-tr from-blue-700 to-indigo-600 flex items-center justify-center text-white shadow-sm shadow-blue-500/20 ring-1 ring-blue-700/10">
          <ShieldCheck className="w-4.5 h-4.5" />
        </div>
        <div className="flex flex-col">
          <span className="text-[15px] font-extrabold tracking-tight text-[#00236F] leading-tight flex items-center gap-1">
            CILULATAKS
          </span>
          <span className="text-[11px] font-medium text-slate-500 capitalize leading-none mt-0.5">
            {getSubTitle()}
          </span>
        </div>
      </div>

      {/* Right Controls: Notification Bell & Profile Avatar */}
      <div className="flex items-center gap-2">
        <button
          type="button"
          onClick={onOpenNotifications}
          className="relative w-9 h-9 rounded-full flex items-center justify-center text-slate-700 hover:text-blue-700 hover:bg-slate-100 active:scale-95 transition-all"
          aria-label="Notifikasi"
        >
          <Bell className="w-5 h-5" />
          {unreadNotifsCount > 0 && (
            <span className="absolute top-1.5 right-1.5 w-2 h-2 bg-rose-500 rounded-full ring-2 ring-white animate-pulse" />
          )}
        </button>

        <button
          type="button"
          onClick={onOpenProfile}
          className="relative w-9 h-9 rounded-full overflow-hidden ring-1.5 ring-slate-200 hover:ring-blue-500 transition-all active:scale-95 flex items-center justify-center bg-slate-100"
          title={CURRENT_USER.name}
        >
          <img
            src={CURRENT_USER.avatar}
            alt={CURRENT_USER.name}
            className="w-full h-full object-cover"
            onError={(e) => {
              // Fallback
              (e.target as HTMLElement).style.display = 'none';
            }}
          />
          <span className="text-xs font-bold text-blue-800">SP</span>
        </button>
      </div>
    </header>
  );
};
