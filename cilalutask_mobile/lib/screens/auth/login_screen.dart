import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/custom_avatar.dart';
import '../../models/employee.dart';
import '../../models/user_role.dart';
import '../../state/app_state_scope.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  UserRole _selectedRole = UserRole.admin;
  late String _selectedEmployeeId;

  final TextEditingController _emailController = TextEditingController(text: 'sarah.pratama@cilulataks.id');
  final TextEditingController _passwordController = TextEditingController(text: '••••••••');
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _selectedEmployeeId = 'emp-1';
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onRoleChanged(UserRole role, List<Assignee> employees) {
    setState(() {
      _selectedRole = role;
      if (role == UserRole.admin) {
        _emailController.text = 'sarah.pratama@cilulataks.id';
      } else {
        final emp = employees.firstWhere((e) => e.id == _selectedEmployeeId, orElse: () => employees.first);
        _emailController.text = '${emp.shortName.toLowerCase().replaceAll(' ', '').replaceAll('.', '')}@cilulataks.id';
      }
    });
  }

  void _onEmployeeChanged(String empId, List<Assignee> employees) {
    setState(() {
      _selectedEmployeeId = empId;
      final emp = employees.firstWhere((e) => e.id == empId, orElse: () => employees.first);
      _emailController.text = '${emp.shortName.toLowerCase().replaceAll(' ', '').replaceAll('.', '')}@cilulataks.id';
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final employees = state.employees;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Brand Logo
                  Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF1D4ED8), Color(0xFF4F46E5)],
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                      ),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.35),
                          blurRadius: 14,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.shield_rounded,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 14),

                  const Text(
                    'CILULATAKS',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primaryDark,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Sistem Manajemen Tugas & Kepatuhan SOP',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Login Box
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppColors.border),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Pilih Peran Masuk',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Role Selector Switcher (Admin vs User)
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceSecondary,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Row(
                            children: [
                              _buildRoleButton(
                                role: UserRole.admin,
                                label: 'Admin (Manager)',
                                icon: Icons.admin_panel_settings_rounded,
                                employees: employees,
                              ),
                              _buildRoleButton(
                                role: UserRole.user,
                                label: 'User (Karyawan)',
                                icon: Icons.person_rounded,
                                employees: employees,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Role Permissions Info Box
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: _selectedRole == UserRole.admin
                                ? AppColors.primaryLight.withValues(alpha: 0.5)
                                : AppColors.successLight.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _selectedRole == UserRole.admin
                                  ? AppColors.primaryBorder
                                  : AppColors.success.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                _selectedRole == UserRole.admin
                                    ? Icons.security_rounded
                                    : Icons.verified_user_rounded,
                                size: 16,
                                color: _selectedRole == UserRole.admin
                                    ? AppColors.primary
                                    : AppColors.successDark,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _selectedRole == UserRole.admin
                                      ? 'Akses Admin: Berhak memberikan tugas baru, meninjau/review, menyetujui tugas, dan menerbitkan SOP.'
                                      : 'Akses User: Berhak memperbarui checklist subtask & progres tugas secara langsung.',
                                  style: TextStyle(
                                    fontSize: 11,
                                    height: 1.35,
                                    color: _selectedRole == UserRole.admin
                                        ? AppColors.primaryDark
                                        : AppColors.successDark,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // If User Role, choose specific employee
                        if (_selectedRole == UserRole.user) ...[
                          const Text(
                            'Pilih Identitas Karyawan',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceSecondary,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _selectedEmployeeId,
                                isExpanded: true,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                                items: employees.map((emp) {
                                  return DropdownMenuItem(
                                    value: emp.id,
                                    child: Row(
                                      children: [
                                        CustomAvatar(
                                          imageUrl: emp.avatar,
                                          fallbackText: emp.name,
                                          radius: 12,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text('${emp.name} (${emp.division})'),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                                onChanged: (val) {
                                  if (val != null) _onEmployeeChanged(val, employees);
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                        ],

                        // Email Field
                        const Text(
                          'Alamat Email',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        TextField(
                          controller: _emailController,
                          style: const TextStyle(fontSize: 13),
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.email_outlined, size: 18, color: AppColors.textMuted),
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Password Field
                        const Text(
                          'Kata Sandi',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        TextField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          style: const TextStyle(fontSize: 13),
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.lock_outline_rounded, size: 18, color: AppColors.textMuted),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                size: 18,
                                color: AppColors.textMuted,
                              ),
                              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Submit Button
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_selectedRole == UserRole.admin) {
                                state.loginAsAdmin();
                              } else {
                                final emp = employees.firstWhere(
                                  (e) => e.id == _selectedEmployeeId,
                                  orElse: () => employees.first,
                                );
                                state.loginAsEmployee(emp);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              _selectedRole == UserRole.admin
                                  ? 'Masuk sebagai Admin'
                                  : 'Masuk sebagai Karyawan',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Quick Demo Switcher Cards
                  const Text(
                    'Pintasan Uji Coba Cepat (Demo Mode):',
                    style: TextStyle(fontSize: 12, color: AppColors.textMuted, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),

                  Row(
                    children: [
                      // Admin quick button
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => state.loginAsAdmin(),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                            backgroundColor: Colors.white,
                            side: const BorderSide(color: AppColors.border),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Column(
                            children: [
                              Icon(Icons.shield_outlined, size: 18, color: AppColors.primary),
                              SizedBox(height: 4),
                              Text('Demo Admin', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                              Text('Sarah P.', style: TextStyle(fontSize: 9, color: AppColors.textMuted)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Kevin M quick button
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => state.loginAsEmployee(employees[0]),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                            backgroundColor: Colors.white,
                            side: const BorderSide(color: AppColors.border),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Column(
                            children: [
                              Icon(Icons.person_outline_rounded, size: 18, color: AppColors.successDark),
                              SizedBox(height: 4),
                              Text('Demo User IT', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                              Text('Kevin M.', style: TextStyle(fontSize: 9, color: AppColors.textMuted)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Budi S quick button
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => state.loginAsEmployee(employees[2]),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                            backgroundColor: Colors.white,
                            side: const BorderSide(color: AppColors.border),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Column(
                            children: [
                              Icon(Icons.warehouse_outlined, size: 18, color: AppColors.warning),
                              SizedBox(height: 4),
                              Text('Demo User Ops', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                              Text('Budi S.', style: TextStyle(fontSize: 9, color: AppColors.textMuted)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleButton({
    required UserRole role,
    required String label,
    required IconData icon,
    required List<Assignee> employees,
  }) {
    final isSelected = _selectedRole == role;

    return Expanded(
      child: InkWell(
        onTap: () => _onRoleChanged(role, employees),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    )
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected ? AppColors.primary : AppColors.textMuted,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
