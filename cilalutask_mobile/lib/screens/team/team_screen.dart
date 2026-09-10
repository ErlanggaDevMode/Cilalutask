import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/custom_avatar.dart';
import '../../state/app_state_controller.dart';
import '../../state/app_state_scope.dart';
import '../../widgets/modals/create_task_bottom_sheet.dart';
import '../chat/chat_room_screen.dart';

class TeamScreen extends StatelessWidget {
  const TeamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final user = state.currentUser;
    final employees = state.employees;
    final notifications = state.notifications;
    final hasUnreadNotif = notifications.any((n) => n.unread);
    final activeSubTab = state.teamSubTab;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      children: [
        // 1. Header & Subtab Switcher
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'KOLABORASI & NOTIFIKASI',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primary,
                    letterSpacing: 0.8,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Tim & Notif',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),

            // Subtab Switcher
            Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: AppColors.surfaceSecondary,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  _buildSubTabButton(state, 'tim', 'Anggota', Icons.group_rounded),
                  _buildSubTabButton(state, 'notif', 'Notif', Icons.notifications_rounded, hasBadge: hasUnreadNotif),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // SUBTAB 1: TIM (Anggota)
        if (activeSubTab == 'tim') ...[
          // Manager Profile Highlight Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.white, Color(0xFFEFF6FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.primaryBorder),
            ),
            child: Row(
              children: [
                CustomAvatar(
                  imageUrl: user.avatar,
                  fallbackText: user.name,
                  radius: 26,
                  borderColor: AppColors.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              user.name,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                            decoration: BoxDecoration(
                              color: AppColors.primaryLight,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              user.role,
                              style: const TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        user.email,
                        style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.verified_user_rounded, size: 13, color: AppColors.successDark),
                          const SizedBox(width: 4),
                          Text(
                            'Divisi: ${user.division}',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppColors.successDark,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // Member List Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Daftar Karyawan (${employees.length})',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const Text(
                'Semua Aktif',
                style: TextStyle(fontSize: 12, color: AppColors.textMuted),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Member List
          ...employees.map((emp) {
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  CustomAvatar(
                    imageUrl: emp.avatar,
                    fallbackText: emp.name,
                    radius: 18,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          emp.name,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                            children: [
                              TextSpan(text: '${emp.role} • '),
                              TextSpan(
                                text: emp.division,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Action Buttons (RBAC Guarded)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Chat button available to all
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ChatRoomScreen(directUser: emp),
                            ),
                          );
                        },
                        icon: const Icon(Icons.chat_bubble_outline_rounded, size: 18),
                        color: AppColors.primary,
                        tooltip: 'Chat dengan ${emp.name}',
                        visualDensity: VisualDensity.compact,
                      ),
                      // Only Admin can give/assign tasks
                      if (state.isAdmin) ...[
                        const SizedBox(width: 4),
                        ElevatedButton(
                          onPressed: () {
                            CreateTaskBottomSheet.show(
                              context,
                              employees: employees,
                              defaultAssignee: emp,
                              onCreateTask: (newTask) {
                                state.createTask(newTask);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Tugas "${newTask.title}" berhasil diterbitkan untuk ${emp.name}!'),
                                    backgroundColor: AppColors.primaryDark,
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryLight,
                            foregroundColor: AppColors.primary,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: const Text('Beri Tugas', style: TextStyle(fontSize: 11)),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            );
          }),
        ] else ...[
          // SUBTAB 2: NOTIFIKASI
          // Live status & Test Simulation Banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.primaryBorder),
            ),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.success,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Layanan Real-time Aktif',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryDark,
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => state.simulateIncomingRealtimeEvent(),
                  icon: const Icon(Icons.flash_on_rounded, size: 12),
                  label: const Text(
                    'Uji Real-time (+)',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    visualDensity: VisualDensity.compact,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Pemberitahuan (${notifications.length})',
                style: const TextStyle(fontSize: 13, color: AppColors.textMuted, fontWeight: FontWeight.w600),
              ),
              InkWell(
                onTap: () => state.markAllNotificationsAsRead(),
                child: const Text(
                  'Tandai Semua Dibaca',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          ...notifications.map((notif) {
            final isUnread = notif.unread;

            IconData notifIcon;
            Color iconColor;
            Color iconBg;

            switch (notif.type) {
              case 'chat':
                notifIcon = Icons.chat_bubble_rounded;
                iconColor = const Color(0xFF4F46E5);
                iconBg = const Color(0xFFEEF2FF);
                break;
              case 'review':
                notifIcon = Icons.verified_user_rounded;
                iconColor = const Color(0xFF9333EA);
                iconBg = const Color(0xFFFAF5FF);
                break;
              case 'deadline':
                notifIcon = Icons.access_time_rounded;
                iconColor = AppColors.danger;
                iconBg = AppColors.dangerLight;
                break;
              case 'urgent':
                notifIcon = Icons.warning_amber_rounded;
                iconColor = AppColors.danger;
                iconBg = AppColors.dangerLight;
                break;
              case 'sop':
                notifIcon = Icons.menu_book_rounded;
                iconColor = const Color(0xFFD97706);
                iconBg = const Color(0xFFFFFBEB);
                break;
              case 'task':
              default:
                notifIcon = Icons.assignment_rounded;
                iconColor = AppColors.primary;
                iconBg = AppColors.primaryLight;
                break;
            }

            return InkWell(
              onTap: () {
                state.markNotificationAsRead(notif.id);
                if (notif.targetTab != null) {
                  state.setTab(notif.targetTab!);
                }
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isUnread ? iconBg.withValues(alpha: 0.3) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isUnread ? iconColor.withValues(alpha: 0.35) : AppColors.border,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: iconBg,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(notifIcon, color: iconColor, size: 18),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  notif.title,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: isUnread ? FontWeight.bold : FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ),
                              if (isUnread)
                                Container(
                                  width: 7,
                                  height: 7,
                                  decoration: BoxDecoration(
                                    color: iconColor,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            notif.description,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            notif.time,
                            style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildSubTabButton(AppStateController state, String tabId, String label, IconData icon, {bool hasBadge = false}) {
    final isActive = state.teamSubTab == tabId;

    return InkWell(
      onTap: () => state.setTeamSubTab(tabId),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: isActive ? AppColors.primaryDark : AppColors.textMuted),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                color: isActive ? AppColors.primaryDark : AppColors.textSecondary,
              ),
            ),
            if (hasBadge) ...[
              const SizedBox(width: 4),
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: AppColors.danger,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
