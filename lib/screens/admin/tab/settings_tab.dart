import 'package:flutter/material.dart';
import 'package:taha_portfolio/core/services/portfolio_service.dart';
import 'package:taha_portfolio/models/project_model.dart';
import 'package:taha_portfolio/models/skill_model.dart'; // ← تأكد من المسار الصح

class SettingsTab extends StatefulWidget {
  const SettingsTab({super.key});

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  final service = PortfolioService();
  final _name = TextEditingController();
  final _title = TextEditingController();
  final _about = TextEditingController();
  final _cv = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _location = TextEditingController();
  final _linkedin = TextEditingController();
  final _experience = TextEditingController();
  final _projects = TextEditingController();
  bool _loading = false;
  bool _saved = false;
  bool _seeding = false;
  bool _seedingSkills = false;

  @override
  void dispose() {
    for (final c in [
      _name, _title, _about, _cv, _phone, _email,
      _location, _linkedin, _experience, _projects
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  void _populate(Map<String, dynamic> data) {
    _name.text = data['name'] ?? '';
    _title.text = data['title'] ?? '';
    _about.text = data['aboutMe'] ?? '';
    _cv.text = data['cvLink'] ?? '';
    _phone.text = data['phone'] ?? '';
    _email.text = data['email'] ?? '';
    _location.text = data['location'] ?? '';
    _linkedin.text = data['linkedIn'] ?? '';
    _experience.text = data['experience'] ?? '';
    _projects.text = data['projectsCount'] ?? '';
  }

  Future<void> _save() async {
    setState(() => _loading = true);
    await service.updateSettings({
      'name': _name.text.trim(),
      'title': _title.text.trim(),
      'aboutMe': _about.text.trim(),
      'cvLink': _cv.text.trim(),
      'phone': _phone.text.trim(),
      'email': _email.text.trim(),
      'location': _location.text.trim(),
      'linkedIn': _linkedin.text.trim(),
      'experience': _experience.text.trim(),
      'projectsCount': _projects.text.trim(),
    });
    setState(() {
      _loading = false;
      _saved = true;
    });
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _saved = false);
  }

  // ─── Seed All Skills ──────────────────────────────────────
  Future<void> _seedAllSkills() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Seed All Skills?'),
        content: const Text(
          'هيرفع كل الـ Skills من الكود لـ Firestore.\n\n'
          '⚠️ لو ضغطته أكتر من مرة هيتضافوا مرتين!\n'
          'استخدمه مرة واحدة بس.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            child: const Text('Seed!', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _seedingSkills = true);

    try {
      final allSkills = Skill.getSkills();
      for (int i = 0; i < allSkills.length; i++) {
        await service.addSkill(allSkills[i].name, allSkills[i].emoji);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ تم رفع ${allSkills.length} skill بنجاح!'),
            backgroundColor: Colors.blue,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ حصل خطأ: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _seedingSkills = false);
    }
  }

  // ─── Seed All Projects ────────────────────────────────────
  Future<void> _seedAllProjects() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Seed All Projects?'),
        content: const Text(
          'هيرفع كل المشاريع من الكود لـ Firestore.\n\n'
          '⚠️ لو ضغطته أكتر من مرة هيتضافوا مرتين!\n'
          'استخدمه مرة واحدة بس.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('Seed!', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _seeding = true);

    try {
      final allProjects = Project.getProjects();
      await service.seedProjects(
        allProjects.map((p) => {
          'title': p.title,
          'description': p.description,
          'technologies': p.technologies,
          'imagePath': p.imagePath,
          'category': p.category,
          'githubLink': p.githubLink,
          'apkLink': p.apkLink,
          'videoLink': p.videoLink,
          'badge': p.badge,
        }).toList(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ تم رفع ${allProjects.length} مشروع بنجاح!'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ حصل خطأ: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _seeding = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return StreamBuilder<Map<String, dynamic>>(
      stream: service.getSettings(),
      builder: (context, snap) {
        if (snap.hasData && snap.data!.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_name.text.isEmpty) _populate(snap.data!);
          });
        }
        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // ── Seed Skills ───────────────────────────────
            _SeedCard(
              emoji: '🧠',
              title: 'Seed Skills to Firestore',
              subtitle: 'يرفع كل الـ Skills من skill_model.dart لـ Firestore.\nاستخدمه مرة واحدة بس!',
              buttonLabel: '🧠 Upload All Skills (${Skill.getSkills().length})',
              buttonColor: Colors.blue,
              gradientColors: [Colors.blue, Colors.indigo],
              isLoading: _seedingSkills,
              onPressed: _seedAllSkills,
              isDark: isDark,
            ),

            const SizedBox(height: 12),

            // ── Seed Projects ─────────────────────────────
            _SeedCard(
              emoji: '🚀',
              title: 'Seed Projects to Firestore',
              subtitle: 'يرفع كل المشاريع من project_model.dart لـ Firestore.\nاستخدمه مرة واحدة بس!',
              buttonLabel: '🚀 Upload All Projects (${Project.getProjects().length})',
              buttonColor: Colors.orange[600]!,
              gradientColors: [Colors.orange, Colors.deepOrange],
              isLoading: _seeding,
              onPressed: _seedAllProjects,
              isDark: isDark,
            ),

            const SizedBox(height: 16),

            _section('Personal Info', Icons.person_outline_rounded, isDark, [
              _field('Full Name', _name, isDark),
              _field('Title / Role', _title, isDark),
              _field('Experience', _experience, isDark, hint: '2+ Years'),
              _field('Projects Count', _projects, isDark, hint: '14+ Completed'),
            ]),
            const SizedBox(height: 16),
            _section('About Me', Icons.info_outline_rounded, isDark, [
              _field('About Me Text', _about, isDark, maxLines: 6),
            ]),
            const SizedBox(height: 16),
            _section('Contact Info', Icons.contact_mail_outlined, isDark, [
              _field('Phone', _phone, isDark),
              _field('Email', _email, isDark),
              _field('Location', _location, isDark),
              _field('LinkedIn URL', _linkedin, isDark),
            ]),
            const SizedBox(height: 16),
            _section('CV', Icons.description_outlined, isDark, [
              _field('CV Google Drive Link', _cv, isDark),
            ]),
            const SizedBox(height: 24),
            SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: _loading ? null : _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  padding: EdgeInsets.zero,
                ),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: _saved
                        ? const LinearGradient(
                            colors: [Color(0xFF00C851), Color(0xFF007E33)])
                        : const LinearGradient(
                            colors: [Color(0xFF667EEA), Color(0xFF764BA2)]),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    child: _loading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2.5))
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _saved
                                    ? Icons.check_circle_rounded
                                    : Icons.save_rounded,
                                color: Colors.white,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _saved ? 'Saved!' : 'Save Settings',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        );
      },
    );
  }

  Widget _section(
      String title, IconData icon, bool isDark, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1A2E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.07)
              : Colors.black.withOpacity(0.06),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: const Color(0xFF667EEA)),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : const Color(0xFF1A1A2E),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _field(
    String label,
    TextEditingController ctrl,
    bool isDark, {
    int maxLines = 1,
    String? hint,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? Colors.white.withOpacity(0.5)
                  : Colors.black.withOpacity(0.4),
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: ctrl,
            maxLines: maxLines,
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF1A1A2E),
              fontSize: 13,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: isDark
                    ? Colors.white.withOpacity(0.25)
                    : Colors.black.withOpacity(0.25),
                fontSize: 13,
              ),
              filled: true,
              fillColor: isDark
                  ? Colors.white.withOpacity(0.04)
                  : Colors.black.withOpacity(0.03),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: isDark
                      ? Colors.white.withOpacity(0.07)
                      : Colors.black.withOpacity(0.07),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: isDark
                      ? Colors.white.withOpacity(0.07)
                      : Colors.black.withOpacity(0.07),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    const BorderSide(color: Color(0xFF667EEA), width: 1.5),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Reusable Seed Card Widget ────────────────────────────
class _SeedCard extends StatelessWidget {
  final String emoji, title, subtitle, buttonLabel;
  final Color buttonColor;
  final List<Color> gradientColors;
  final bool isLoading, isDark;
  final VoidCallback onPressed;

  const _SeedCard({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.buttonLabel,
    required this.buttonColor,
    required this.gradientColors,
    required this.isLoading,
    required this.isDark,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            gradientColors[0].withOpacity(0.12),
            gradientColors[1].withOpacity(0.06),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: gradientColors[0].withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: isDark
                      ? gradientColors[0].withOpacity(0.9)
                      : gradientColors[1],
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: isDark
                  ? Colors.white.withOpacity(0.5)
                  : Colors.black.withOpacity(0.4),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton.icon(
              onPressed: isLoading ? null : onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: isLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(Icons.upload_rounded, color: Colors.white),
              label: Text(
                isLoading ? 'جاري الرفع...' : buttonLabel,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}