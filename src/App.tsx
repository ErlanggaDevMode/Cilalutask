import React, { useState } from 'react';
import { TabType, Task, SOPDocument, Subtask, Assignee, ActivityItem } from './types';
import {
  INITIAL_TASKS,
  INITIAL_SOPS,
  INITIAL_ACTIVITIES,
  CURRENT_USER,
} from './data/mockData';
import { Header } from './components/Header';
import { BottomNav } from './components/BottomNav';
import { HomeScreen } from './components/screens/HomeScreen';
import { TasksScreen } from './components/screens/TasksScreen';
import { SopScreen } from './components/screens/SopScreen';
import { ReportsScreen } from './components/screens/ReportsScreen';
import { TeamScreen } from './components/screens/TeamScreen';
import { CreateTaskModal } from './components/modals/CreateTaskModal';
import { UpdateProgressModal } from './components/modals/UpdateProgressModal';
import { ReviewTaskModal } from './components/modals/ReviewTaskModal';
import { SopDetailModal } from './components/modals/SopDetailModal';
import { UploadSopModal } from './components/modals/UploadSopModal';
import { ExportReportModal } from './components/modals/ExportReportModal';
import { BroadcastModal } from './components/modals/BroadcastModal';
import { ProfileModal } from './components/modals/ProfileModal';
import { Check, Smartphone, Monitor } from 'lucide-react';

export default function App() {
  // Navigation State
  const [currentTab, setCurrentTab] = useState<TabType>('beranda');

  // Core Data State
  const [tasks, setTasks] = useState<Task[]>(INITIAL_TASKS);
  const [sops, setSops] = useState<SOPDocument[]>(INITIAL_SOPS);
  const [activities, setActivities] = useState<ActivityItem[]>(INITIAL_ACTIVITIES);

  // Modal States
  const [isCreateTaskOpen, setIsCreateTaskOpen] = useState(false);
  const [taskForProgress, setTaskForProgress] = useState<Task | null>(null);
  const [taskForReview, setTaskForReview] = useState<Task | null>(null);
  const [sopForDetail, setSopForDetail] = useState<SOPDocument | null>(null);
  const [isUploadSopOpen, setIsUploadSopOpen] = useState(false);
  const [isExportReportOpen, setIsExportReportOpen] = useState(false);
  const [isBroadcastOpen, setIsBroadcastOpen] = useState(false);
  const [isProfileOpen, setIsProfileOpen] = useState(false);
  const [targetMemberForTask, setTargetMemberForTask] = useState<Assignee | null>(null);

  // View Layout Mode (Smartphone Frame vs Fluid Fullscreen)
  const [isMobileFrame, setIsMobileFrame] = useState(true);

  // Toast Notification
  const [toast, setToast] = useState<string | null>(null);

  const showToast = (message: string) => {
    setToast(message);
    setTimeout(() => {
      setToast(null);
    }, 3000);
  };

  // Handlers
  const handleCreateTask = (newTaskData: Partial<Task>) => {
    const newTask = newTaskData as Task;
    setTasks((prev) => [newTask, ...prev]);

    // Add activity
    const newAct: ActivityItem = {
      id: `act-${Date.now()}`,
      userName: CURRENT_USER.name,
      userAvatar: CURRENT_USER.avatar,
      actionPrefix: 'menerbitkan tugas baru',
      targetObject: newTask.title,
      timeAgo: 'Baru saja',
      department: newTask.division,
      type: 'task',
    };
    setActivities((prev) => [newAct, ...prev]);
    showToast(`Tugas "${newTask.title}" berhasil diterbitkan!`);
  };

  const handleSaveProgress = (
    taskId: string,
    updatedSubtasks: Subtask[],
    progressPercent: number
  ) => {
    setTasks((prev) =>
      prev.map((t) => {
        if (t.id === taskId) {
          const isDone = progressPercent === 100;
          return {
            ...t,
            subtasks: updatedSubtasks,
            progressPercent,
            status: isDone ? 'Selesai' : 'Dalam Proses',
          };
        }
        return t;
      })
    );

    const target = tasks.find((t) => t.id === taskId);
    if (target) {
      const newAct: ActivityItem = {
        id: `act-${Date.now()}`,
        userName: target.assignee.name,
        userAvatar: target.assignee.avatar,
        actionPrefix: 'memperbarui progres tugas',
        targetObject: target.title,
        actionSuffix: `ke ${progressPercent}%.`,
        timeAgo: 'Baru saja',
        department: target.division,
        type: 'task',
      };
      setActivities((prev) => [newAct, ...prev]);
    }
    showToast('Progres tugas berhasil diperbarui!');
  };

  const handleApproveTask = (taskId: string) => {
    setTasks((prev) =>
      prev.map((t) => {
        if (t.id === taskId) {
          return {
            ...t,
            status: 'Selesai',
            progressPercent: 100,
            subtasks: t.subtasks.map((st) => ({ ...st, completed: true })),
            needsReview: false,
          };
        }
        return t;
      })
    );

    const target = tasks.find((t) => t.id === taskId);
    if (target) {
      const newAct: ActivityItem = {
        id: `act-${Date.now()}`,
        userName: CURRENT_USER.name,
        userAvatar: CURRENT_USER.avatar,
        actionPrefix: 'menyetujui & menyelesaikan tugas',
        targetObject: target.title,
        timeAgo: 'Baru saja',
        department: target.division,
        type: 'task',
      };
      setActivities((prev) => [newAct, ...prev]);
    }
    showToast('Tugas telah disetujui dan ditandai selesai!');
  };

  const handleAddSop = (newSop: SOPDocument) => {
    setSops((prev) => [newSop, ...prev]);
    const newAct: ActivityItem = {
      id: `act-${Date.now()}`,
      userName: CURRENT_USER.name,
      userAvatar: CURRENT_USER.avatar,
      actionPrefix: 'menerbitkan SOP baru',
      targetObject: newSop.title,
      timeAgo: 'Baru saja',
      department: newSop.category,
      type: 'sop',
    };
    setActivities((prev) => [newAct, ...prev]);
    showToast(`Dokumen "${newSop.title}" berhasil diterbitkan!`);
  };

  const handleConfirmReadSop = (sopId: string) => {
    setSops((prev) =>
      prev.map((s) => {
        if (s.id === sopId) {
          return {
            ...s,
            isReadByMe: true,
            readProgressPercent: Math.min(100, (s.readProgressPercent || 94) + 6),
            isUrgentMandatory: false,
          };
        }
        return s;
      })
    );

    const targetSop = sops.find((s) => s.id === sopId);
    if (targetSop) {
      const newAct: ActivityItem = {
        id: `act-${Date.now()}`,
        userName: CURRENT_USER.name,
        userAvatar: CURRENT_USER.avatar,
        actionPrefix: 'memverifikasi kepatuhan SOP',
        targetObject: targetSop.title,
        timeAgo: 'Baru saja',
        department: targetSop.category,
        type: 'sop',
      };
      setActivities((prev) => [newAct, ...prev]);
    }
    showToast('Konfirmasi verifikasi SOP berhasil dicatat!');
  };

  const handleToggleBookmarkSop = (sopId: string) => {
    setSops((prev) =>
      prev.map((s) =>
        s.id === sopId ? { ...s, isBookmarked: !s.isBookmarked } : s
      )
    );
  };

  const handleSendBroadcast = (message: string, targetDivision: string) => {
    const newAct: ActivityItem = {
      id: `act-${Date.now()}`,
      userName: CURRENT_USER.name,
      userAvatar: CURRENT_USER.avatar,
      actionPrefix: `mengirim broadcast (${targetDivision}):`,
      targetObject: `"${message.slice(0, 35)}..."`,
      timeAgo: 'Baru saja',
      department: targetDivision,
      type: 'task',
    };
    setActivities((prev) => [newAct, ...prev]);
    showToast(`Pengumuman berhasil disiarkan ke ${targetDivision}!`);
  };

  const activeReviewCount = tasks.filter((t) => t.needsReview).length || 3;

  return (
    <div className="min-h-screen bg-[#F0F4FA] text-[#0B1C30] flex flex-col items-center justify-start antialiased py-0 sm:py-6 px-0 sm:px-4">
      {/* Top Floating Control Bar (Device Frame Switcher & Direct Quick Links) */}
      <div className="hidden sm:flex items-center justify-between w-full max-w-[430px] lg:max-w-4xl mb-3 px-2">
        <div className="flex items-center gap-2">
          <span className="w-2.5 h-2.5 rounded-full bg-emerald-500 animate-pulse" />
          <span className="text-xs font-bold text-slate-700 tracking-tight">
            CILULATAKS Live Environment
          </span>
        </div>

        <div className="flex items-center gap-2">
          <button
            onClick={() => setIsMobileFrame(!isMobileFrame)}
            className="inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-white border border-slate-200 text-xs font-bold text-slate-700 hover:text-[#0051D5] hover:border-blue-300 shadow-xs transition-all"
            title="Ganti Mode Tampilan"
          >
            {isMobileFrame ? (
              <>
                <Monitor className="w-3.5 h-3.5 text-blue-600" />
                <span>Mode Layar Penuh</span>
              </>
            ) : (
              <>
                <Smartphone className="w-3.5 h-3.5 text-blue-600" />
                <span>Mode Smartphone</span>
              </>
            )}
          </button>
        </div>
      </div>

      {/* Main Container */}
      <div
        className={`w-full bg-[#F8F9FF] shadow-2xl transition-all duration-300 flex flex-col relative ${
          isMobileFrame
            ? 'max-w-[420px] rounded-none sm:rounded-[36px] sm:border-[8px] sm:border-slate-800 sm:ring-1 sm:ring-slate-300 min-h-screen sm:min-h-[850px] overflow-hidden'
            : 'max-w-4xl rounded-none sm:rounded-2xl border border-slate-200 min-h-screen sm:min-h-[850px] overflow-hidden'
        }`}
      >
        {/* Smartphone Speaker / Notch on frame */}
        {isMobileFrame && (
          <div className="hidden sm:flex items-center justify-center pt-2 pb-1 bg-white">
            <div className="w-20 h-4 bg-slate-900 rounded-full flex items-center justify-center">
              <div className="w-3 h-3 rounded-full bg-slate-950 ring-1 ring-slate-800" />
            </div>
          </div>
        )}

        {/* 1. Sticky Header */}
        <Header
          currentTab={currentTab}
          unreadNotifsCount={3}
          onOpenNotifications={() => setCurrentTab('tim')}
          onOpenProfile={() => setIsProfileOpen(true)}
        />

        {/* 2. Main Scrollable View Area */}
        <main className="flex-1 overflow-y-auto">
          {currentTab === 'beranda' && (
            <HomeScreen
              tasks={tasks}
              activities={activities}
              onNavigateTab={(tab) => setCurrentTab(tab)}
              onOpenCreateTask={() => {
                setTargetMemberForTask(null);
                setIsCreateTaskOpen(true);
              }}
              onOpenUploadSop={() => setIsUploadSopOpen(true)}
              onSelectTask={(task) => {
                setTaskForProgress(task);
              }}
              onQuickBroadcast={() => setIsBroadcastOpen(true)}
            />
          )}

          {currentTab === 'tugas' && (
            <TasksScreen
              tasks={tasks}
              onOpenCreateTask={() => {
                setTargetMemberForTask(null);
                setIsCreateTaskOpen(true);
              }}
              onOpenUpdateProgress={(task) => setTaskForProgress(task)}
              onOpenReview={(task) => setTaskForReview(task)}
            />
          )}

          {currentTab === 'sop' && (
            <SopScreen
              sops={sops}
              onOpenUploadSop={() => setIsUploadSopOpen(true)}
              onOpenSopDetail={(sop) => setSopForDetail(sop)}
              onToggleBookmark={handleToggleBookmarkSop}
            />
          )}

          {currentTab === 'laporan' && (
            <ReportsScreen
              onOpenExportModal={() => setIsExportReportOpen(true)}
              onBalanceWorkload={() => {
                setCurrentTab('tugas');
                showToast('Membuka daftar tugas untuk penyesuaian alokasi beban kerja.');
              }}
            />
          )}

          {currentTab === 'tim' && (
            <TeamScreen
              onOpenCreateTaskForMember={(member) => {
                setTargetMemberForTask(member);
                setIsCreateTaskOpen(true);
              }}
            />
          )}
        </main>

        {/* 3. Sticky Bottom Navigation Bar */}
        <BottomNav
          currentTab={currentTab}
          onSelectTab={(tab) => setCurrentTab(tab)}
          tasksBadgeCount={activeReviewCount}
        />
      </div>

      {/* Floating Toast Message */}
      {toast && (
        <div className="fixed bottom-24 z-50 animate-in fade-in slide-in-from-bottom duration-200 px-4">
          <div className="bg-[#00236F] text-white px-4 py-2.5 rounded-full shadow-lg flex items-center gap-2 text-xs font-semibold">
            <span className="w-4 h-4 rounded-full bg-emerald-500 flex items-center justify-center text-white text-[10px] font-bold">
              ✓
            </span>
            <span>{toast}</span>
          </div>
        </div>
      )}

      {/* Modals & Dialogs */}
      <CreateTaskModal
        isOpen={isCreateTaskOpen}
        onClose={() => setIsCreateTaskOpen(false)}
        onCreateTask={handleCreateTask}
        defaultAssignee={targetMemberForTask}
      />

      <UpdateProgressModal
        isOpen={!!taskForProgress}
        task={taskForProgress}
        onClose={() => setTaskForProgress(null)}
        onSaveProgress={handleSaveProgress}
      />

      <ReviewTaskModal
        isOpen={!!taskForReview}
        task={taskForReview}
        onClose={() => setTaskForReview(null)}
        onApproveTask={handleApproveTask}
      />

      <SopDetailModal
        isOpen={!!sopForDetail}
        sop={sopForDetail}
        onClose={() => setSopForDetail(null)}
        onConfirmRead={handleConfirmReadSop}
      />

      <UploadSopModal
        isOpen={isUploadSopOpen}
        onClose={() => setIsUploadSopOpen(false)}
        onAddSop={handleAddSop}
      />

      <ExportReportModal
        isOpen={isExportReportOpen}
        onClose={() => setIsExportReportOpen(false)}
      />

      <BroadcastModal
        isOpen={isBroadcastOpen}
        onClose={() => setIsBroadcastOpen(false)}
        onSendBroadcast={handleSendBroadcast}
      />

      <ProfileModal
        isOpen={isProfileOpen}
        onClose={() => setIsProfileOpen(false)}
        isMobileFrame={isMobileFrame}
        onToggleFrame={() => setIsMobileFrame(!isMobileFrame)}
      />
    </div>
  );
}
