import React from 'react';
import { Home, ClipboardList, BookOpen, BarChart2, Users } from 'lucide-react';
import { TabType } from '../types';

interface BottomNavProps {
  currentTab: TabType;
  onSelectTab: (tab: TabType) => void;
  tasksBadgeCount?: number;
  sopBadgeCount?: number;
}

export const BottomNav: React.FC<BottomNavProps> = ({
  currentTab,
  onSelectTab,
  tasksBadgeCount = 3,
}) => {
  const navItems = [
    {
      id: 'beranda' as TabType,
      label: 'Beranda',
      icon: Home,
    },
    {
      id: 'tugas' as TabType,
      label: 'Tugas',
      icon: ClipboardList,
      badge: tasksBadgeCount,
    },
    {
      id: 'sop' as TabType,
      label: 'SOP',
      icon: BookOpen,
    },
    {
      id: 'laporan' as TabType,
      label: 'Laporan',
      icon: BarChart2,
    },
    {
      id: 'tim' as TabType,
      label: 'Tim & Notif',
      icon: Users,
    },
  ];

  return (
    <nav className="sticky bottom-0 z-30 bg-white/95 backdrop-blur-md border-t border-slate-200/80 px-2 py-1.5 shadow-lg shadow-slate-900/5">
      <div className="flex items-center justify-around max-w-lg mx-auto">
        {navItems.map((item) => {
          const Icon = item.icon;
          const isActive = currentTab === item.id;

          return (
            <button
              key={item.id}
              onClick={() => onSelectTab(item.id)}
              className={`relative flex flex-col items-center justify-center py-1 px-3 rounded-xl transition-all duration-200 group ${
                isActive
                  ? 'text-[#0051D5] font-semibold'
                  : 'text-slate-500 hover:text-slate-700 font-normal'
              }`}
            >
              <div className="relative">
                <Icon
                  className={`w-5 h-5 transition-transform ${
                    isActive ? 'scale-110 stroke-[2.4px]' : 'stroke-[1.8px] group-hover:scale-105'
                  }`}
                />
                {item.badge !== undefined && item.badge > 0 && (
                  <span className="absolute -top-1.5 -right-2.5 bg-[#0051D5] text-white text-[10px] font-bold w-4 h-4 rounded-full flex items-center justify-center ring-2 ring-white">
                    {item.badge}
                  </span>
                )}
              </div>
              <span
                className={`text-[11px] mt-1 tracking-tight whitespace-nowrap leading-none ${
                  isActive ? 'text-[#0051D5]' : 'text-slate-500'
                }`}
              >
                {item.label}
              </span>
            </button>
          );
        })}
      </div>
    </nav>
  );
};
