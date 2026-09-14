import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/custom_avatar.dart';
import '../../core/widgets/custom_badge.dart';
import '../../models/task.dart';
import '../../state/app_state_scope.dart';
import '../../widgets/modals/create_task_bottom_sheet.dart';
import '../../widgets/modals/update_progress_bottom_sheet.dart';
import '../../widgets/modals/review_task_bottom_sheet.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  String _searchQuery = '';
  String _selectedDivision = 'Semua Divisi';
  String _selectedEmployeeId = 'ALL';
  TaskStatus _selectedStatus = TaskStatus.inProgress;

  final TextEditingController _searchController = TextEditingController();

  final List<String> _divisions = [
    'Semua Divisi',
    'Operasional',
    'IT & Tech',
    'Pemasaran',
    'Finance & Akuntansi',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final tasks = state.tasks;
    final employees = state.employees;

    // Counts for status tabs
    final notStartedCount = tasks.where((t) => t.status == TaskStatus.notStarted).length;
    final inProgressCount = tasks.where((t) => t.status == TaskStatus.inProgress).length;
    final completedCount = tasks.where((t) => t.status == TaskStatus.completed).length;

    // Filter tasks
    final filteredTasks = tasks.where((task) {
      // 1. Status match
      if (task.status != _selectedStatus) return false;

      // 2. Division match
      if (_selectedDivision != 'Semua Divisi') {
        final queryDiv = _selectedDivision.replaceAll(' & Tech', '');
        if (!task.division.contains(queryDiv)) return false;
      }

      // 3. Employee match
      if (_selectedEmployeeId != 'ALL' && task.assignee.id != _selectedEmployeeId) {
        return false;
      }

      // 4. Search query
      if (_searchQuery.trim().isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final matchTitle = task.title.toLowerCase().contains(q);
        final matchDesc = task.description.toLowerCase().contains(q);
        final matchAssignee = task.assignee.name.toLowerCase().contains(q);
        return matchTitle || matchDesc || matchAssignee;
      }

      return true;
    }).toList();

    return Stack(
      children: [
        ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
          children: [
            // 1. Search Bar
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.surfaceSecondary,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: TextField(
                      controller: _searchController,
                      style: const TextStyle(fontSize: 13),
                      decoration: InputDecoration(
                        hintText: 'Cari tugas atau nama karyawan...',
                        prefixIcon: const Icon(Icons.search_rounded, size: 18, color: AppColors.textMuted),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear_rounded, size: 18, color: AppColors.textMuted),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() => _searchQuery = '');
                                },
                              )
                            : null,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onChanged: (val) => setState(() => _searchQuery = val),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.primaryBorder),
                  ),
                  child: const Icon(Icons.tune_rounded, color: AppColors.primary, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // 2. Division Filters (Horizontal scroll)
            SizedBox(
              height: 32,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: _divisions.map((div) {
                  final isActive = _selectedDivision == div;
                  return Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: InkWell(
                      onTap: () => setState(() => _selectedDivision = div),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: isActive ? AppColors.primaryDark : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isActive ? AppColors.primaryDark : AppColors.border,
                          ),
                        ),
                        child: Text(
                          div,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isActive ? Colors.white : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 10),

            // 3. Employee Filters (Horizontal scroll)
            SizedBox(
              height: 34,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  // ALL chip
                  Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: InkWell(
                      onTap: () => setState(() => _selectedEmployeeId = 'ALL'),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: _selectedEmployeeId == 'ALL' ? AppColors.primary : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: _selectedEmployeeId == 'ALL' ? AppColors.primary : AppColors.border,
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(
                              'ALL',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                                color: _selectedEmployeeId == 'ALL' ? Colors.white : AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Semua',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: _selectedEmployeeId == 'ALL' ? Colors.white : AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Member chips
                  ...employees.map((emp) {
                    final isSelected = _selectedEmployeeId == emp.id;
                    return Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: InkWell(
                        onTap: () => setState(() => _selectedEmployeeId = emp.id),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.primaryLight : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected ? AppColors.primary : AppColors.border,
                              width: isSelected ? 1.5 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              CustomAvatar(
                                imageUrl: emp.avatar,
                                fallbackText: emp.name,
                                radius: 9,
                                hasBorder: false,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                emp.shortName,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected ? AppColors.primary : AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // 4. Status Tabs (Belum Dimulai, Dalam Proses, Selesai)
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.surfaceSecondary,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  _buildStatusTab('Belum Dimulai', TaskStatus.notStarted, notStartedCount),
                  _buildStatusTab('Dalam Proses', TaskStatus.inProgress, inProgressCount, isBadge: true),
                  _buildStatusTab('Selesai', TaskStatus.completed, completedCount),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // 5. Task Cards List
            if (filteredTasks.isEmpty) ...[
              Container(
                padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        tasks.isEmpty ? Icons.assignment_add : Icons.inbox_rounded,
                        size: 36,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      tasks.isEmpty
                          ? 'Belum Ada Tugas di ${state.currentCompany.name}'
                          : 'Tidak Ada Tugas yang Cocok',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      tasks.isEmpty
                          ? 'Perusahaan siap diinput secara manual. Mulai dengan membuat tugas baru untuk tim Anda.'
                          : 'Coba ubah kata kunci pencarian atau reset filter divisi dan status.',
                      style: const TextStyle(fontSize: 12, color: AppColors.textMuted, height: 1.4),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    if (tasks.isEmpty && state.isAdmin)
                      ElevatedButton.icon(
                        onPressed: () {
                          CreateTaskBottomSheet.show(
                            context,
                            employees: employees,
                            onCreateTask: (newTask) {
                              state.createTask(newTask);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Tugas "${newTask.title}" berhasil dibuat!'),
                                  backgroundColor: AppColors.primaryDark,
                                ),
                              );
                            },
                          );
                        },
                        icon: const Icon(Icons.add_rounded, size: 16, color: Colors.white),
                        label: const Text('Buat Tugas Baru', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      )
                    else if (tasks.isNotEmpty)
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _searchQuery = '';
                            _searchController.clear();
                            _selectedDivision = 'Semua Divisi';
                            _selectedEmployeeId = 'ALL';
                          });
                        },
                        child: const Text('Reset Filter', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                  ],
                ),
              ),
            ] else ...[
              ...filteredTasks.map((task) {
                final completedSubtasks = task.subtasks.where((s) => s.completed).length;
                final totalSubtasks = task.subtasks.length;
                final isDone = task.status == TaskStatus.completed || task.progressPercent >= 100;

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.border),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.02),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Tags
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              DivisionBadge(division: task.division),
                              const SizedBox(width: 6),
                              PriorityBadge(priority: task.priority),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.more_vert_rounded, size: 18, color: AppColors.textMuted),
                            onPressed: () {
                              ReviewTaskBottomSheet.show(
                                context,
                                task: task,
                                onApproveTask: (id) {
                                  state.approveTask(id);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Tugas telah disetujui & ditandai selesai!'),
                                      backgroundColor: AppColors.primaryDark,
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                },
                              );
                            },
                            visualDensity: VisualDensity.compact,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Title & Description
                      Text(
                        task.title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        task.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Subtasks Progress Box
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.check_box_outlined, size: 14, color: AppColors.primary),
                              SizedBox(width: 4),
                              Text(
                                'Subtask Checklist',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '$completedSubtasks / $totalSubtasks (${task.progressPercent}%)',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: isDone ? AppColors.successDark : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: task.progressPercent / 100,
                          minHeight: 6,
                          backgroundColor: AppColors.surfaceSecondary,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            isDone ? AppColors.success : AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Divider(height: 1, color: AppColors.borderSubtle),
                      const SizedBox(height: 10),

                      // Assignee & Deadline Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CustomAvatar(
                                imageUrl: task.assignee.avatar,
                                fallbackText: task.assignee.name,
                                radius: 12,
                                teamCount: task.assignee.hasTeamBadge ? task.assignee.teamCount : null,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${task.assignee.name} ${task.assignee.hasTeamBadge ? '& Tim' : ''}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: task.isUrgentDeadline ? AppColors.dangerLight : AppColors.surfaceSecondary,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  task.isUrgentDeadline ? Icons.access_time_rounded : Icons.calendar_today_rounded,
                                  size: 12,
                                  color: task.isUrgentDeadline ? AppColors.danger : AppColors.textSecondary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  task.deadlineLabel,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: task.isUrgentDeadline ? AppColors.danger : AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Action Buttons (RBAC: Only User can Update Progres, Only Admin can Review)
                      if (state.isUser)
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              UpdateProgressBottomSheet.show(
                                context,
                                task: task,
                                onSaveProgress: (id, subtasks, pct) {
                                  state.saveProgress(id, subtasks, pct);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Progres tugas berhasil diperbarui!'),
                                      backgroundColor: AppColors.primaryDark,
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                },
                              );
                            },
                            icon: const Icon(Icons.refresh_rounded, size: 16),
                            label: const Text('Update Progres Tugas'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                            ),
                          ),
                        )
                      else if (state.isAdmin)
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              ReviewTaskBottomSheet.show(
                                context,
                                task: task,
                                onApproveTask: (id) {
                                  state.approveTask(id);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Tugas telah disetujui & ditandai selesai!'),
                                      backgroundColor: AppColors.primaryDark,
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                },
                              );
                            },
                            icon: const Icon(Icons.assignment_turned_in_outlined, size: 16),
                            label: const Text('Review & Persetujuan'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryDark,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              }),
            ],
          ],
        ),

        // 6. Floating Action Button (+ Tugas) - Only Admin can assign/create tasks
        if (state.isAdmin)
          Positioned(
            right: 16,
            bottom: 16,
            child: FloatingActionButton.extended(
              onPressed: () {
                CreateTaskBottomSheet.show(
                  context,
                  employees: state.employees,
                  onCreateTask: (newTask) {
                    state.createTask(newTask);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Tugas "${newTask.title}" berhasil diterbitkan!'),
                        backgroundColor: AppColors.primaryDark,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                );
              },
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 4,
              icon: const Icon(Icons.add_rounded, size: 20),
              label: const Text(
                'Tugas',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildStatusTab(String label, TaskStatus status, int count, {bool isBadge = false}) {
    final isActive = _selectedStatus == status;

    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedStatus = status),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    )
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                  color: isActive ? AppColors.textPrimary : AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: 4),
              if (isBadge)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '$count',
                    style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                )
              else
                Text(
                  '$count',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textMuted,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
