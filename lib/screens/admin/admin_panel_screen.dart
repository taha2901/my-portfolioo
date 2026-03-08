import 'package:flutter/material.dart';
import 'package:taha_portfolio/core/services/auth_service.dart';
import 'package:taha_portfolio/core/services/portfolio_service.dart';
import 'package:taha_portfolio/models/project_model.dart';
import 'package:taha_portfolio/screens/admin/tab/projects_tab.dart';
import 'package:taha_portfolio/screens/admin/tab/settings_tab.dart';
import 'package:taha_portfolio/screens/admin/tab/skills_tab.dart';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  int _tab = 0;
  final _auth = AuthService();

  final _tabs = const [
    ('Projects', Icons.work_outline_rounded),
    ('Skills', Icons.psychology_outlined),
    ('Settings', Icons.settings_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF0A0A0F)
          : const Color(0xFFF5F7FF),
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1A1A2E) : Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.admin_panel_settings_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'Admin Panel',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : const Color(0xFF1A1A2E),
              ),
            ),
          ],
        ),
        actions: [
          TextButton.icon(
            onPressed: () async {
              await _auth.logout();
              if (mounted) {
                Navigator.pushReplacementNamed(context, '/');
              }
            },
            icon: const Icon(Icons.logout_rounded, size: 16, color: Colors.red),
            label: const Text(
              'Logout',
              style: TextStyle(color: Colors.red, fontSize: 13),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Tab Bar
          Container(
            color: isDark ? const Color(0xFF1A1A2E) : Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              children: _tabs.asMap().entries.map((e) {
                final isActive = _tab == e.key;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => setState(() => _tab = e.key),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        gradient: isActive
                            ? const LinearGradient(
                                colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                              )
                            : null,
                        color: isActive
                            ? null
                            : isDark
                            ? Colors.white.withOpacity(0.05)
                            : Colors.black.withOpacity(0.04),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            e.value.$2,
                            size: 16,
                            color: isActive
                                ? Colors.white
                                : isDark
                                ? Colors.white.withOpacity(0.5)
                                : Colors.black.withOpacity(0.4),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            e.value.$1,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: isActive
                                  ? Colors.white
                                  : isDark
                                  ? Colors.white.withOpacity(0.5)
                                  : Colors.black.withOpacity(0.4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // Content
          Expanded(
            child: IndexedStack(
              index: _tab,
              children: const [ProjectsTab(), SkillsTab(), SettingsTab()],
            ),
          ),
        ],
      ),
    );
  }
}
