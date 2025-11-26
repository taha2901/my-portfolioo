import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:ui';
import '../../core/theme/app_theme.dart';
import '../../core/utils/responsive.dart';
import '../../models/project_model.dart';

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final projects = Project.getProjects();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkSurface : Colors.white,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.isMobile(context)
            ? 20
            : Responsive.isTablet(context)
            ? 40
            : 100,
        vertical: Responsive.isMobile(context) ? 80 : 120,
      ),
      child: Column(
        children: [
          _buildSectionTitle('Featured Projects', isDark),
          const SizedBox(height: 60),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1300),
            child: Wrap(
              spacing: 30,
              runSpacing: 40,
              alignment: WrapAlignment.center,
              children: projects.asMap().entries.map((entry) {
                return TweenAnimationBuilder(
                  duration: Duration(milliseconds: 600 + (entry.key * 100)),
                  tween: Tween<double>(begin: 0, end: 1),
                  curve: Curves.easeOutCubic,
                  builder: (context, double value, child) {
                    return Transform.translate(
                      offset: Offset(0, 50 * (1 - value)),
                      child: Opacity(
                        opacity: value,
                        child: _buildProjectCard(entry.value, context, isDark),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.w900,
            color: isDark ? AppTheme.darkText : AppTheme.lightText,
            letterSpacing: -1,
          ),
        ),
        const SizedBox(height: 15),
        Container(
          width: 80,
          height: 5,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                isDark ? AppTheme.darkPrimary : AppTheme.lightPrimary,
                isDark ? AppTheme.darkAccent : AppTheme.lightAccent,
              ],
            ),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: (isDark ? AppTheme.darkPrimary : AppTheme.lightPrimary)
                    .withOpacity(0.4),
                blurRadius: 15,
                spreadRadius: 2,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProjectCard(Project project, BuildContext context, bool isDark) {
    final isMobile = Responsive.isMobile(context);
    final cardWidth = isMobile ? double.infinity : 380.0;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: cardWidth,
            decoration: BoxDecoration(
              gradient: isDark
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppTheme.darkCard.withOpacity(0.9),
                        AppTheme.darkCard.withOpacity(0.7),
                      ],
                    )
                  : LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.white, Colors.white.withOpacity(0.95)],
                    ),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: isDark
                    ? AppTheme.darkPrimary.withOpacity(0.3)
                    : AppTheme.lightPrimary.withOpacity(0.2),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withOpacity(0.4)
                      : Colors.black.withOpacity(0.1),
                  blurRadius: 30,
                  offset: const Offset(0, 15),
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Project Image
                // Project Image
                Container(
                  height: 220,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        (isDark ? AppTheme.darkPrimary : AppTheme.lightPrimary)
                            .withOpacity(0.3),
                        (isDark ? AppTheme.darkAccent : AppTheme.lightAccent)
                            .withOpacity(0.2),
                      ],
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // صورة المشروع
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(25),
                        ),
                        child: Image.asset(
                          project.imagePath,
                          height: 220,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.phone_iphone_rounded,
                              size: 100,
                              color: Colors.white.withOpacity(0.3),
                            );
                          },
                        ),
                      ),

                      // Badge
                      if (project.badge != null)
                        Positioned(
                          top: 15,
                          right: 15,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              gradient: _getBadgeGradient(project.badge!),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: _getBadgeColor(
                                    project.badge!,
                                  ).withOpacity(0.5),
                                  blurRadius: 15,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _getBadgeIcon(project.badge!),
                                  size: 14,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  project.badge!,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                // Project Details
                Padding(
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        project.title,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: isDark
                              ? AppTheme.darkText
                              : AppTheme.lightText,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        project.description,
                        style: TextStyle(
                          fontSize: 15,
                          color: isDark
                              ? AppTheme.darkTextSecondary
                              : AppTheme.lightTextSecondary,
                          height: 1.6,
                        ),
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 20),

                      // Technologies
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: project.technologies.map((tech) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  (isDark
                                          ? AppTheme.darkPrimary
                                          : AppTheme.lightPrimary)
                                      .withOpacity(0.2),
                                  (isDark
                                          ? AppTheme.darkAccent
                                          : AppTheme.lightAccent)
                                      .withOpacity(0.1),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isDark
                                    ? AppTheme.darkPrimary.withOpacity(0.4)
                                    : AppTheme.lightPrimary.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              tech,
                              style: TextStyle(
                                fontSize: 13,
                                color: isDark
                                    ? AppTheme.darkPrimary
                                    : AppTheme.lightPrimary,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.3,
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 25),

                      // Action Buttons
                      Row(
                        children: [
                          if (project.githubLink != null)
                            Expanded(
                              child: _buildActionButton(
                                'GitHub',
                                Icons.code_rounded,
                                project.githubLink!,
                                isDark,
                                project.title,
                                context,
                              ),
                            ),
                          if (project.githubLink != null &&
                              project.apkLink != null)
                            const SizedBox(width: 10),
                          if (project.apkLink != null)
                            Expanded(
                              child: _buildActionButton(
                                'APK',
                                Icons.android_rounded,
                                project.apkLink!,
                                isDark,
                                project.title,
                                context,
                              ),
                            ),
                        ],
                      ),
                      if (project.videoLink != null) ...[
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: _buildActionButton(
                            'Watch Demo',
                            Icons.play_circle_rounded,
                            project.videoLink!,
                            isDark,
                            project.title,
                            context,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  LinearGradient _getBadgeGradient(String badge) {
    switch (badge.toLowerCase()) {
      case 'featured':
        return const LinearGradient(
          colors: [Color(0xFFFF6B6B), Color(0xFFEE5A6F)],
        );
      case 'offline':
        return const LinearGradient(
          colors: [Color(0xFF4A90E2), Color(0xFF357ABD)],
        );
      case 'cloud':
        return const LinearGradient(
          colors: [Color(0xFF00C851), Color(0xFF007E33)],
        );
      default:
        return const LinearGradient(
          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
        );
    }
  }

  Color _getBadgeColor(String badge) {
    switch (badge.toLowerCase()) {
      case 'featured':
        return const Color(0xFFFF6B6B);
      case 'offline':
        return const Color(0xFF4A90E2);
      case 'cloud':
        return const Color(0xFF00C851);
      default:
        return const Color(0xFF667EEA);
    }
  }

  IconData _getBadgeIcon(String badge) {
    switch (badge.toLowerCase()) {
      case 'featured':
        return Icons.star_rounded;
      case 'offline':
        return Icons.storage_rounded;
      case 'cloud':
        return Icons.cloud_rounded;
      default:
        return Icons.label_rounded;
    }
  }

  Widget _buildActionButton(
    String label,
    IconData icon,
    String url,
    bool isDark,
    String projectTitle,
    BuildContext context,
  ) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                (isDark ? AppTheme.darkPrimary : AppTheme.lightPrimary)
                    .withOpacity(0.9),
                (isDark ? AppTheme.darkAccent : AppTheme.lightAccent)
                    .withOpacity(0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: (isDark ? AppTheme.darkPrimary : AppTheme.lightPrimary)
                    .withOpacity(0.4),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _launchURL(url, projectTitle, context),
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _launchURL(
    String url,
    String projectTitle,
    BuildContext context,
  ) async {
    if (projectTitle == 'Management Stocks (Cloud)') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('🎬 سيتم إضافة الفيديو قريبًا!'),
          duration: Duration(seconds: 2),
        ),
      );
      return; // ما تفتحش اللينك
    }

    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }
}
