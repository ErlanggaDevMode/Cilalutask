import React from 'react';
import { X, ShieldCheck, Mail, Building, Smartphone, Monitor, Check } from 'lucide-react';
import { CURRENT_USER } from '../../data/mockData';

interface ProfileModalProps {
  isOpen: boolean;
  onClose: () => void;
  isMobileFrame: boolean;
  onToggleFrame: () => void;
}

export const ProfileModal: React.FC<ProfileModalProps> = ({
  isOpen,
  onClose,
  isMobileFrame,
  onToggleFrame,
}) => {
  if (!isOpen) return null;

  return (
    <div className="fixed inset-0 z-50 flex items-end sm:items-center justify-center bg-slate-900/50 backdrop-blur-xs p-0 sm:p-4">
      <div className="w-full max-w-md bg-white rounded-t-3xl sm:rounded-2xl shadow-xl overflow-hidden flex flex-col animate-in slide-in-from-bottom duration-200">
        {/* Header */}
        <div className="px-5 py-4 border-b border-slate-100 flex items-center justify-between">
          <div className="flex items-center gap-2">
            <span className="w-2 h-2 rounded-full bg-emerald-500" />
            <h2 className="text-base font-bold text-slate-900">Profil & Preferensi Pengguna</h2>
          </div>
          <button
            onClick={onClose}
            className="w-8 h-8 rounded-full hover:bg-slate-100 flex items-center justify-center text-slate-400 hover:text-slate-600"
          >
            <X className="w-4 h-4" />
          </button>
        </div>

        {/* Body */}
        <div className="p-5 space-y-4">
          <div className="flex items-center gap-3.5 bg-blue-50/50 p-4 rounded-2xl border border-blue-100">
            <img
              src={CURRENT_USER.avatar}
              alt={CURRENT_USER.name}
              className="w-14 h-14 rounded-2xl object-cover ring-2 ring-blue-600/30"
            />
            <div>
              <div className="flex items-center gap-2">
                <h3 className="text-base font-bold text-slate-900">{CURRENT_USER.name}</h3>
              </div>
              <span className="inline-block mt-0.5 px-2 py-0.5 rounded-full bg-blue-100 text-[#0051D5] text-[10px] font-bold">
                {CURRENT_USER.role}
              </span>
              <p className="text-xs text-slate-500 mt-1 flex items-center gap-1">
                <Mail className="w-3.5 h-3.5" />
                {CURRENT_USER.email}
              </p>
            </div>
          </div>

          {/* Quick Metrics */}
          <div className="grid grid-cols-2 gap-2.5">
            <div className="bg-slate-50 p-3 rounded-xl border border-slate-200/70 text-center">
              <span className="text-[11px] text-slate-500 font-medium">Target Kuartal</span>
              <p className="text-lg font-bold text-[#00236F] mt-0.5">
                {CURRENT_USER.targetQuarterPercent}%
              </p>
            </div>
            <div className="bg-slate-50 p-3 rounded-xl border border-slate-200/70 text-center">
              <span className="text-[11px] text-slate-500 font-medium">Efisiensi Tim</span>
              <p className="text-lg font-bold text-emerald-600 mt-0.5">
                {CURRENT_USER.teamEfficiencyPercent}%
              </p>
            </div>
          </div>

          {/* Device Frame View Toggle */}
          <div className="pt-2 border-t border-slate-100 space-y-2">
            <label className="text-xs font-bold text-slate-700 block">
              Tampilan Pratinjau (Layout Mode)
            </label>
            <div className="grid grid-cols-2 gap-2">
              <button
                type="button"
                onClick={() => !isMobileFrame && onToggleFrame()}
                className={`p-3 rounded-xl border text-center flex flex-col items-center gap-1.5 transition-all ${
                  isMobileFrame
                    ? 'border-[#0051D5] bg-blue-50/70 text-[#0051D5] font-bold shadow-xs'
                    : 'border-slate-200 hover:bg-slate-50 text-slate-600'
                }`}
              >
                <Smartphone className="w-5 h-5" />
                <span className="text-xs">Bingkai Smartphone</span>
              </button>

              <button
                type="button"
                onClick={() => isMobileFrame && onToggleFrame()}
                className={`p-3 rounded-xl border text-center flex flex-col items-center gap-1.5 transition-all ${
                  !isMobileFrame
                    ? 'border-[#0051D5] bg-blue-50/70 text-[#0051D5] font-bold shadow-xs'
                    : 'border-slate-200 hover:bg-slate-50 text-slate-600'
                }`}
              >
                <Monitor className="w-5 h-5" />
                <span className="text-xs">Responsif Penuh</span>
              </button>
            </div>
          </div>

          <div className="pt-2">
            <button
              onClick={onClose}
              className="w-full py-2.5 rounded-xl bg-[#0051D5] hover:bg-blue-700 text-white text-xs font-bold shadow-md shadow-blue-600/20 active:scale-95 transition-all"
            >
              Simpan & Tutup
            </button>
          </div>
        </div>
      </div>
    </div>
  );
};
