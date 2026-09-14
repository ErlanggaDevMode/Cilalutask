import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/custom_avatar.dart';
import '../../models/company.dart';
import '../../models/employee.dart';
import '../../models/user_role.dart';
import '../../state/app_state_scope.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // 0: Masuk (Login), 1: Daftar Perusahaan (Admin Baru), 2: Gabung Tim (Karyawan)
  int _activeAuthTab = 0;

  // Login state
  UserRole _selectedRole = UserRole.admin;
  late String _selectedEmployeeId;
  final TextEditingController _loginEmailController = TextEditingController(text: 'sarah.pratama@cilulataks.id');
  final TextEditingController _loginPasswordController = TextEditingController(text: 'password123');
  bool _obscureLoginPassword = true;

  // Register Company state
  final TextEditingController _regCompanyNameController = TextEditingController(text: 'PT Sinergi Abadi');
  final TextEditingController _regCompanyCodeController = TextEditingController(text: 'SINERGI-01');
  final TextEditingController _regAdminNameController = TextEditingController(text: 'Bambang Sudiro');
  final TextEditingController _regAdminEmailController = TextEditingController(text: 'admin@sinergi.id');
  final TextEditingController _regAdminPasswordController = TextEditingController(text: 'admin123');
  String _selectedIndustry = 'Teknologi & Operasional';

  // Join Request state
  final TextEditingController _joinCompanyCodeController = TextEditingController(text: 'CILALU-88');
  final TextEditingController _joinNameController = TextEditingController(text: 'Dimas Pratama');
  final TextEditingController _joinEmailController = TextEditingController(text: 'dimas@gmail.com');
  final TextEditingController _joinPasswordController = TextEditingController(text: 'dimas123');
  final TextEditingController _joinRoleController = TextEditingController(text: 'Mobile Engineer');
  String _selectedJoinDivision = 'IT & Engineering';
  JoinRequest? _submittedJoinRequest;

  @override
  void initState() {
    super.initState();
    _selectedEmployeeId = 'emp-1';
  }

  @override
  void dispose() {
    _loginEmailController.dispose();
    _loginPasswordController.dispose();
    _regCompanyNameController.dispose();
    _regCompanyCodeController.dispose();
    _regAdminNameController.dispose();
    _regAdminEmailController.dispose();
    _regAdminPasswordController.dispose();
    _joinCompanyCodeController.dispose();
    _joinNameController.dispose();
    _joinEmailController.dispose();
    _joinPasswordController.dispose();
    _joinRoleController.dispose();
    super.dispose();
  }

  void _onRoleChanged(UserRole role, List<Assignee> employees, Company currentCompany) {
    setState(() {
      _selectedRole = role;
      if (role == UserRole.admin) {
        _loginEmailController.text = currentCompany.adminEmail.isNotEmpty
            ? currentCompany.adminEmail
            : 'sarah.pratama@cilulataks.id';
      } else {
        if (employees.isNotEmpty) {
          final emp = employees.firstWhere((e) => e.id == _selectedEmployeeId, orElse: () => employees.first);
          _loginEmailController.text = '${emp.shortName.toLowerCase().replaceAll(' ', '').replaceAll('.', '')}@${currentCompany.code.toLowerCase()}.id';
        } else {
          _loginEmailController.text = 'karyawan@${currentCompany.code.toLowerCase()}.id';
        }
      }
    });
  }

  void _onEmployeeChanged(String empId, List<Assignee> employees, Company currentCompany) {
    setState(() {
      _selectedEmployeeId = empId;
      final emp = employees.firstWhere((e) => e.id == empId, orElse: () => employees.first);
      _loginEmailController.text = '${emp.shortName.toLowerCase().replaceAll(' ', '').replaceAll('.', '')}@${currentCompany.code.toLowerCase()}.id';
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final employees = state.employees;
    final currentCompany = state.currentCompany;

    // Check if submitted join request has been approved by admin
    if (_submittedJoinRequest != null) {
      final updated = state.joinRequests.firstWhere(
        (r) => r.id == _submittedJoinRequest!.id,
        orElse: () => _submittedJoinRequest!,
      );
      if (updated.status != _submittedJoinRequest!.status) {
        _submittedJoinRequest = updated;
      }
    }

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Brand Logo & Header
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
                  const SizedBox(height: 12),

                  const Text(
                    'CILALUTASK',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primaryDark,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Platform Manajemen Tugas Multi-Perusahaan',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Segmented Tabs: [Masuk, Buat Perusahaan, Gabung Tim]
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        _buildMainTabButton(0, 'Masuk', Icons.login_rounded),
                        _buildMainTabButton(1, 'Daftar PT', Icons.business_rounded),
                        _buildMainTabButton(2, 'Gabung Tim', Icons.group_add_rounded),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Main Container Card
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
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: _buildCurrentTabContent(context, state, employees, currentCompany),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Quick Demo Switcher Cards
                  _buildDemoShortcuts(state, employees),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainTabButton(int index, String label, IconData icon) {
    final isSelected = _activeAuthTab == index;
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _activeAuthTab = index;
            if (index == 2 && _submittedJoinRequest == null) {
              _joinCompanyCodeController.text = AppStateScope.of(context).currentCompany.code;
            }
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 15,
                color: isSelected ? Colors.white : AppColors.textMuted,
              ),
              const SizedBox(width: 5),
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentTabContent(
    BuildContext context,
    dynamic state,
    List<Assignee> employees,
    Company currentCompany,
  ) {
    switch (_activeAuthTab) {
      case 0:
        return _buildLoginTab(context, state, employees, currentCompany);
      case 1:
        return _buildRegisterCompanyTab(context, state);
      case 2:
        return _buildJoinTeamTab(context, state);
      default:
        return const SizedBox.shrink();
    }
  }

  // TAB 1: LOGIN SCREEN
  Widget _buildLoginTab(
    BuildContext context,
    dynamic state,
    List<Assignee> employees,
    Company currentCompany,
  ) {
    return Column(
      key: const ValueKey('tab-login'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Company Selector Banner
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.surfaceSecondary,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.corporate_fare_rounded, size: 18, color: AppColors.primary),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentCompany.name,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      'ID: ${currentCompany.code} • ${currentCompany.industry}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              if (state.companies.length > 1)
                PopupMenuButton<Company>(
                  icon: const Icon(Icons.swap_horiz_rounded, size: 20, color: AppColors.primary),
                  tooltip: 'Ganti Perusahaan',
                  onSelected: (comp) {
                    state.switchCompany(comp);
                    _onRoleChanged(_selectedRole, state.employees, comp);
                  },
                  itemBuilder: (ctx) {
                    return state.companies.map<PopupMenuItem<Company>>((c) {
                      return PopupMenuItem<Company>(
                        value: c,
                        child: Text('${c.name} (${c.code})'),
                      );
                    }).toList();
                  },
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        const Text(
          'Pilih Peran Masuk',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 8),

        // Role Switcher (Admin vs User)
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
                currentCompany: currentCompany,
              ),
              _buildRoleButton(
                role: UserRole.user,
                label: 'User (Karyawan)',
                icon: Icons.person_rounded,
                employees: employees,
                currentCompany: currentCompany,
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Role Permission Note
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: _selectedRole == UserRole.admin
                ? AppColors.primaryLight.withValues(alpha: 0.5)
                : AppColors.successLight.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: _selectedRole == UserRole.admin
                  ? AppColors.primaryBorder
                  : AppColors.success.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              Icon(
                _selectedRole == UserRole.admin ? Icons.shield_rounded : Icons.verified_user_rounded,
                size: 16,
                color: _selectedRole == UserRole.admin ? AppColors.primary : AppColors.successDark,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _selectedRole == UserRole.admin
                      ? 'Admin: Mengelola tugas, review, terima permohonan join & SOP.'
                      : 'Karyawan: Memperbarui subtask & progres tugas divisi secara mandiri.',
                  style: TextStyle(
                    fontSize: 11,
                    height: 1.3,
                    color: _selectedRole == UserRole.admin ? AppColors.primaryDark : AppColors.successDark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Employee dropdown if user role and employees exist
        if (_selectedRole == UserRole.user) ...[
          if (employees.isNotEmpty) ...[
            const Text(
              'Pilih Identitas Karyawan',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
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
                  value: employees.any((e) => e.id == _selectedEmployeeId)
                      ? _selectedEmployeeId
                      : employees.first.id,
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
                          CustomAvatar(imageUrl: emp.avatar, fallbackText: emp.name, radius: 12),
                          const SizedBox(width: 8),
                          Expanded(child: Text('${emp.name} (${emp.division})')),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) _onEmployeeChanged(val, employees, currentCompany);
                  },
                ),
              ),
            ),
            const SizedBox(height: 14),
          ] else ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, size: 16, color: Colors.amber),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Belum ada karyawan di perusahaan ini. Ajukan akun di tab "Gabung Tim".',
                      style: TextStyle(fontSize: 11, color: Colors.amber, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
          ],
        ],

        // Email Field
        const Text(
          'Alamat Email',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: _loginEmailController,
          style: const TextStyle(fontSize: 13),
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.email_outlined, size: 18, color: AppColors.textMuted),
          ),
        ),
        const SizedBox(height: 14),

        // Password Field
        const Text(
          'Kata Sandi',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: _loginPasswordController,
          obscureText: _obscureLoginPassword,
          style: const TextStyle(fontSize: 13),
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.lock_outline_rounded, size: 18, color: AppColors.textMuted),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureLoginPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                size: 18,
                color: AppColors.textMuted,
              ),
              onPressed: () => setState(() => _obscureLoginPassword = !_obscureLoginPassword),
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
                if (employees.isNotEmpty) {
                  final emp = employees.firstWhere(
                    (e) => e.id == _selectedEmployeeId,
                    orElse: () => employees.first,
                  );
                  state.loginAsEmployee(emp);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Karyawan belum terdaftar. Silakan ajukan lewat tab "Gabung Tim" dan tunggu persetujuan Admin.'),
                      backgroundColor: Colors.amber,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(
              _selectedRole == UserRole.admin ? 'Masuk sebagai Admin' : 'Masuk sebagai Karyawan',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  // TAB 2: REGISTER NEW COMPANY (BLANK SLATE)
  Widget _buildRegisterCompanyTab(BuildContext context, dynamic state) {
    return Column(
      key: const ValueKey('tab-register'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.add_business_rounded, color: AppColors.primary, size: 20),
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Daftar Perusahaan Baru',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                  Text(
                    'Mulai dengan data blank/bersih tanpa data dummy',
                    style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Company Name Field
        const Text('Nama Perusahaan / Organisasi', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        TextField(
          controller: _regCompanyNameController,
          style: const TextStyle(fontSize: 13),
          decoration: const InputDecoration(
            hintText: 'Contoh: PT Nusantara Logistik',
            prefixIcon: Icon(Icons.business_outlined, size: 18, color: AppColors.textMuted),
          ),
          onChanged: (val) {
            // Auto generate code suggestion
            if (val.trim().isNotEmpty) {
              final words = val.trim().split(' ').where((w) => w.length > 2).toList();
              final prefix = words.isNotEmpty ? words.last.toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]'), '') : 'CORP';
              _regCompanyCodeController.text = '$prefix-${DateTime.now().millisecond % 90 + 10}';
            }
          },
        ),
        const SizedBox(height: 12),

        // Company Unique ID / Code
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Kode Unik ID Perusahaan', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
            Text(
              'Digunakan karyawan untuk join',
              style: TextStyle(fontSize: 10, color: AppColors.primary.withValues(alpha: 0.8), fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const SizedBox(height: 6),
        TextField(
          controller: _regCompanyCodeController,
          textCapitalization: TextCapitalization.characters,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 1),
          decoration: const InputDecoration(
            hintText: 'Contoh: SINERGI-01',
            prefixIcon: Icon(Icons.qr_code_2_rounded, size: 18, color: AppColors.textMuted),
          ),
        ),
        const SizedBox(height: 12),

        // Industry Dropdown
        const Text('Bidang / Industri', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
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
              value: _selectedIndustry,
              isExpanded: true,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
              items: const [
                DropdownMenuItem(value: 'Teknologi & Operasional', child: Text('Teknologi & Operasional Cloud')),
                DropdownMenuItem(value: 'Logistik & Pergudangan', child: Text('Logistik, Distribusi & Pergudangan')),
                DropdownMenuItem(value: 'Manufaktur & Pabrik', child: Text('Manufaktur & Pabrik')),
                DropdownMenuItem(value: 'Retail & E-Commerce', child: Text('Retail & E-Commerce')),
                DropdownMenuItem(value: 'Keuangan & Fintech', child: Text('Keuangan & Fintech')),
                DropdownMenuItem(value: 'Kreatif & Media Digital', child: Text('Kreatif, Agensi & Media Digital')),
              ],
              onChanged: (val) {
                if (val != null) setState(() => _selectedIndustry = val);
              },
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Admin Info Section
        const Text('Nama Lengkap Admin Pengelola', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        TextField(
          controller: _regAdminNameController,
          style: const TextStyle(fontSize: 13),
          decoration: const InputDecoration(
            hintText: 'Nama Anda sebagai pemilik/admin',
            prefixIcon: Icon(Icons.person_outline, size: 18, color: AppColors.textMuted),
          ),
        ),
        const SizedBox(height: 12),

        const Text('Email Admin & Kata Sandi', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _regAdminEmailController,
                style: const TextStyle(fontSize: 13),
                decoration: const InputDecoration(
                  hintText: 'admin@email.com',
                  prefixIcon: Icon(Icons.email_outlined, size: 16, color: AppColors.textMuted),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _regAdminPasswordController,
                obscureText: true,
                style: const TextStyle(fontSize: 13),
                decoration: const InputDecoration(
                  hintText: 'Kata Sandi',
                  prefixIcon: Icon(Icons.lock_outline, size: 16, color: AppColors.textMuted),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.surfaceSecondary,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.border),
          ),
          child: const Row(
            children: [
              Icon(Icons.cleaning_services_rounded, size: 16, color: AppColors.primary),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Sistem akan otomatis dimulai dalam kondisi Blank (bersih). Anda dapat menambahkan tugas, SOP, dan divisi secara manual.',
                  style: TextStyle(fontSize: 11, color: AppColors.textSecondary, height: 1.3),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: () {
              if (_regCompanyNameController.text.trim().isEmpty ||
                  _regCompanyCodeController.text.trim().isEmpty ||
                  _regAdminNameController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Mohon isi semua data perusahaan.')),
                );
                return;
              }

              state.registerCompany(
                name: _regCompanyNameController.text.trim(),
                code: _regCompanyCodeController.text.trim().toUpperCase(),
                adminName: _regAdminNameController.text.trim(),
                adminEmail: _regAdminEmailController.text.trim(),
                adminPassword: _regAdminPasswordController.text,
                industry: _selectedIndustry,
              );

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Perusahaan ${_regCompanyNameController.text} berhasil dibuat!'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.rocket_launch_rounded, size: 18, color: Colors.white),
                SizedBox(width: 8),
                Text('Buat Perusahaan (Mulai Blank)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // TAB 3: JOIN COMPANY AS EMPLOYEE
  Widget _buildJoinTeamTab(BuildContext context, dynamic state) {
    if (_submittedJoinRequest != null) {
      final req = _submittedJoinRequest!;
      final isApproved = req.status == JoinRequestStatus.approved;
      final isRejected = req.status == JoinRequestStatus.rejected;

      return Column(
        key: const ValueKey('tab-join-submitted'),
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isApproved
                  ? AppColors.successLight
                  : isRejected
                      ? AppColors.errorLight
                      : Colors.amber.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isApproved
                  ? Icons.check_circle_rounded
                  : isRejected
                      ? Icons.cancel_rounded
                      : Icons.hourglass_top_rounded,
              size: 48,
              color: isApproved
                  ? AppColors.success
                  : isRejected
                      ? AppColors.error
                      : Colors.amber.shade800,
            ),
          ),
          const SizedBox(height: 16),

          Text(
            isApproved
                ? 'Permohonan Diterima!'
                : isRejected
                    ? 'Permohonan Ditolak'
                    : 'Menunggu Persetujuan Admin',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isApproved
                  ? AppColors.successDark
                  : isRejected
                      ? AppColors.errorDark
                      : Colors.amber.shade900,
            ),
          ),
          const SizedBox(height: 8),

          Text(
            isApproved
                ? 'Admin telah menyetujui permohonan Anda untuk bergabung di ${req.companyName} (${req.companyCode}). Anda dapat langsung masuk!'
                : isRejected
                    ? 'Permohonan bergabung Anda di ${req.companyName} belum dapat disetujui oleh admin saat ini.'
                    : 'Permintaan atas nama ${req.userName} untuk bergabung di ${req.companyName} (${req.companyCode}) telah terkirim. Admin sedang meninjau data Anda.',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.4),
          ),
          const SizedBox(height: 16),

          // Details Card
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surfaceSecondary,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                _buildJoinSummaryRow('Kode Perusahaan', req.companyCode),
                const Divider(height: 14),
                _buildJoinSummaryRow('Nama Karyawan', req.userName),
                const Divider(height: 14),
                _buildJoinSummaryRow('Divisi & Role', '${req.role} (${req.division})'),
                const Divider(height: 14),
                _buildJoinSummaryRow(
                  'Status Saat Ini',
                  isApproved ? 'DITERIMA (APPROVED)' : isRejected ? 'DITOLAK' : 'MENUNGGU (PENDING)',
                  highlight: true,
                  color: isApproved ? AppColors.success : (isRejected ? AppColors.error : Colors.amber.shade800),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          if (isApproved) ...[
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () {
                  final targetEmp = state.employees.firstWhere(
                    (e) => e.name == req.userName,
                    orElse: () => Assignee(
                      id: 'emp-new',
                      name: req.userName,
                      shortName: req.userName.split(' ').first,
                      avatar: req.avatar,
                      division: req.division,
                      role: req.role,
                      hasTeamBadge: true,
                      teamCount: 1,
                    ),
                  );
                  state.loginAsEmployee(targetEmp);
                },
                icon: const Icon(Icons.login_rounded, color: Colors.white),
                label: const Text('Masuk ke Dashboard Sekarang', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.success),
              ),
            ),
            const SizedBox(height: 10),
          ],

          OutlinedButton(
            onPressed: () {
              setState(() {
                _submittedJoinRequest = null;
                _activeAuthTab = 0;
              });
            },
            child: const Text('Kembali ke Halaman Masuk'),
          ),
        ],
      );
    }

    return Column(
      key: const ValueKey('tab-join-form'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.person_add_alt_1_rounded, color: AppColors.primary, size: 20),
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Gabung Perusahaan / Tim',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                  Text(
                    'Masukkan ID Perusahaan dan tunggu verifikasi Admin',
                    style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Company ID input
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('ID / Kode Perusahaan', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
            Text('Contoh: ${state.currentCompany.code}', style: const TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.w600)),
          ],
        ),
        const SizedBox(height: 6),
        TextField(
          controller: _joinCompanyCodeController,
          textCapitalization: TextCapitalization.characters,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 1),
          decoration: const InputDecoration(
            hintText: 'Masukkan ID Perusahaan (misal: CILALU-88)',
            prefixIcon: Icon(Icons.domain_verification_rounded, size: 18, color: AppColors.textMuted),
          ),
        ),
        const SizedBox(height: 12),

        // Full Name
        const Text('Nama Lengkap Karyawan', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        TextField(
          controller: _joinNameController,
          style: const TextStyle(fontSize: 13),
          decoration: const InputDecoration(
            hintText: 'Nama lengkap Anda',
            prefixIcon: Icon(Icons.badge_outlined, size: 18, color: AppColors.textMuted),
          ),
        ),
        const SizedBox(height: 12),

        // Division Dropdown
        const Text('Divisi Kerja', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
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
              value: _selectedJoinDivision,
              isExpanded: true,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
              items: const [
                DropdownMenuItem(value: 'IT & Engineering', child: Text('IT & Engineering')),
                DropdownMenuItem(value: 'Operasional & Gudang', child: Text('Operasional & Gudang')),
                DropdownMenuItem(value: 'Pemasaran & Kreatif', child: Text('Pemasaran & Kreatif')),
                DropdownMenuItem(value: 'Finance & Akuntansi', child: Text('Finance & Akuntansi')),
                DropdownMenuItem(value: 'HR & Legal', child: Text('HR & Legal')),
                DropdownMenuItem(value: 'Operasional Lapangan', child: Text('Operasional Lapangan')),
              ],
              onChanged: (val) {
                if (val != null) setState(() => _selectedJoinDivision = val);
              },
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Role / Title
        const Text('Jabatan / Posisi', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        TextField(
          controller: _joinRoleController,
          style: const TextStyle(fontSize: 13),
          decoration: const InputDecoration(
            hintText: 'Contoh: Frontend Engineer, Staff Gudang',
            prefixIcon: Icon(Icons.work_outline_rounded, size: 18, color: AppColors.textMuted),
          ),
        ),
        const SizedBox(height: 12),

        // Email & Password
        const Text('Email Akun & Kata Sandi', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _joinEmailController,
                style: const TextStyle(fontSize: 13),
                decoration: const InputDecoration(
                  hintText: 'email@anda.com',
                  prefixIcon: Icon(Icons.email_outlined, size: 16, color: AppColors.textMuted),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _joinPasswordController,
                obscureText: true,
                style: const TextStyle(fontSize: 13),
                decoration: const InputDecoration(
                  hintText: 'Kata Sandi',
                  prefixIcon: Icon(Icons.lock_outline, size: 16, color: AppColors.textMuted),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Submit Request Button
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: () {
              if (_joinCompanyCodeController.text.trim().isEmpty ||
                  _joinNameController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Mohon isi ID Perusahaan dan Nama Anda.')),
                );
                return;
              }

              final req = state.submitJoinRequest(
                companyCode: _joinCompanyCodeController.text.trim().toUpperCase(),
                name: _joinNameController.text.trim(),
                email: _joinEmailController.text.trim(),
                password: _joinPasswordController.text,
                division: _selectedJoinDivision,
                role: _joinRoleController.text.trim(),
              );

              setState(() {
                _submittedJoinRequest = req;
              });

              HapticFeedback.mediumImpact();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.send_rounded, size: 18, color: Colors.white),
                SizedBox(width: 8),
                Text('Kirim Permohonan Bergabung', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildJoinSummaryRow(String label, String value, {bool highlight = false, Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: highlight ? FontWeight.bold : FontWeight.w600,
            color: color ?? AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildRoleButton({
    required UserRole role,
    required String label,
    required IconData icon,
    required List<Assignee> employees,
    required Company currentCompany,
  }) {
    final isSelected = _selectedRole == role;

    return Expanded(
      child: InkWell(
        onTap: () => _onRoleChanged(role, employees, currentCompany),
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

  Widget _buildDemoShortcuts(dynamic state, List<Assignee> employees) {
    return Column(
      children: [
        const Text(
          'Pintasan Evaluasi & Demo Pengujian:',
          style: TextStyle(fontSize: 11, color: AppColors.textMuted, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            // Admin Demo
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  state.loadSampleDemoData();
                  state.loginAsAdmin();
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: AppColors.border),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.shield_outlined, size: 16, color: AppColors.primary),
                    SizedBox(height: 2),
                    Text('Demo Admin', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                    Text('Data Contoh', style: TextStyle(fontSize: 9, color: AppColors.textMuted)),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 6),

            // Blank Mode Admin (Pure clean slate)
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  state.resetToBlankState();
                  state.loginAsAdmin();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Mode Blank Aktif: Semua data bersih, siap input manual.'),
                      backgroundColor: AppColors.primary,
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                  backgroundColor: Colors.white,
                  side: BorderSide(color: AppColors.primary.withValues(alpha: 0.5)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.cleaning_services_rounded, size: 16, color: AppColors.warning),
                    SizedBox(height: 2),
                    Text('Admin Blank', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.warning)),
                    Text('Data Bersih 100%', style: TextStyle(fontSize: 9, color: AppColors.textMuted)),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 6),

            // Employee Demo
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  state.loadSampleDemoData();
                  if (state.employees.isNotEmpty) {
                    state.loginAsEmployee(state.employees.first);
                  }
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: AppColors.border),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.person_outline_rounded, size: 16, color: AppColors.successDark),
                    SizedBox(height: 2),
                    Text('Demo Karyawan', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                    Text('Kevin M.', style: TextStyle(fontSize: 9, color: AppColors.textMuted)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
