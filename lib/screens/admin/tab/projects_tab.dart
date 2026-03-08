import 'package:flutter/material.dart';
import 'package:taha_portfolio/core/services/portfolio_service.dart';
import '../widgets/project_form_dialog.dart';

class ProjectsTab extends StatelessWidget {
  const ProjectsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final service = PortfolioService();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Projects'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: // في الـ floatingActionButton أو أضف IconButton في AppBar
        IconButton(
          icon: const Icon(Icons.upload_rounded),
          tooltip: 'Seed Projects from Code',
          onPressed: () => _seedAllProjects(context, service),
        ),
      ),
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showDialog(
          context: context,
          builder: (_) => ProjectFormDialog(service: service),
        ),
        backgroundColor: const Color(0xFF667EEA),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Add Project',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: service.getProjects(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final projects = snap.data ?? [];
          if (projects.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.work_outline_rounded,
                    size: 60,
                    color: isDark
                        ? Colors.white.withOpacity(0.2)
                        : Colors.black.withOpacity(0.15),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'No projects yet',
                    style: TextStyle(
                      color: isDark
                          ? Colors.white.withOpacity(0.4)
                          : Colors.black.withOpacity(0.3),
                    ),
                  ),
                ],
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: projects.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, i) {
              final p = projects[i];
              return _ProjectTile(project: p, service: service, isDark: isDark);
            },
          );
        },
      ),
    );
  }
  Future<void> _seedAllProjects(BuildContext context, PortfolioService service) async {
  final confirm = await showDialog<bool>(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Seed All Projects?'),
      content: const Text('هيضيف كل المشاريع من الكود لـ Firestore. لو موجودين هيتضافوا مرة تانية!'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
        TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Seed', style: TextStyle(color: Colors.green))),
      ],
    ),
  );
  if (confirm != true) return;

  final projects = [
    {'title': 'E-Learning Platform', 'description': 'Developed a full-featured e-learning mobile application inspired by Udemy. The platform allows users to register, browse courses, watch structured lessons, and track their learning progress. It includes authentication, course enrollment, video-based lessons, progress tracking, and certificate generation after course completion, providing a complete online learning experience.', 'technologies': ['Flutter', 'Mobile', 'Supabase', 'API'], 'imagePath': 'assets/img/e_learning.png', 'apkLink': 'https://drive.google.com/file/d/1iAmiFS9Scwa_IJyPd8SpyygUfFytTbim/view?usp=drivesdk', 'videoLink': 'https://drive.google.com/file/d/1rNMoGTE7pqAsTfGJJO5Q1brqA1RRD9PJ/view?usp=drivesdk', 'category': 'Mobile', 'badge': null, 'githubLink': null, 'apkLink2': null},
    {'title': 'Management Stocks', 'description': 'Designed and delivered a complete shopping flow with authentication, cart management, and order tracking, improving overall user experience and app stability.', 'technologies': ['Flutter', 'Mobile', 'Desktop', 'Api'], 'imagePath': 'assets/img/Clean and Modern App Portfolio Mockup Presentation.png', 'apkLink': 'https://drive.google.com/file/d/1NMJjVptbIkzTFJixuu85F7pooYblovpK/view?usp=drive_link', 'videoLink': 'https://drive.google.com/file/d/1rNMoGTE7pqAsTfGJJO5Q1brqA1RRD9PJ/view?usp=drivesdk', 'category': 'Mobile', 'badge': null, 'githubLink': null},
    // ...
  ];
  
  await service.seedProjects(projects);
  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('✅ تم رفع المشاريع بنجاح!'), backgroundColor: Colors.green),
    );
  }
}
}

class _ProjectTile extends StatelessWidget {
  final Map<String, dynamic> project;
  final PortfolioService service;
  final bool isDark;

  const _ProjectTile({
    required this.project,
    required this.service,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1A2E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.07)
              : Colors.black.withOpacity(0.06),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.phone_iphone_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  project['title'] ?? '',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: isDark ? Colors.white : const Color(0xFF1A1A2E),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    _Chip(project['category'] ?? 'Mobile'),
                    if (project['badge'] != null) ...[
                      const SizedBox(width: 6),
                      _Chip(project['badge'], color: Colors.orange),
                    ],
                  ],
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.edit_outlined,
                  size: 18,
                  color: Color(0xFF667EEA),
                ),
                onPressed: () => showDialog(
                  context: context,
                  builder: (_) =>
                      ProjectFormDialog(service: service, existing: project),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.delete_outline,
                  size: 18,
                  color: Colors.red.withOpacity(0.8),
                ),
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Delete Project?'),
                      content: Text('Delete "${project['title']}"?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text(
                            'Delete',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                  if (confirm == true) {
                    await service.deleteProject(project['id']);
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final Color? color;
  const _Chip(this.label, {this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: (color ?? const Color(0xFF667EEA)).withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: color ?? const Color(0xFF667EEA),
        ),
      ),
    );
  }
}
