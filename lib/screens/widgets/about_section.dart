import 'package:flutter/material.dart';
import 'dart:ui';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';
import '../../core/services/portfolio_service.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final isMobile = width < 650;
        final isTablet = width >= 650 && width < 1100;
        final horizontalPadding = (isMobile ? 20 : isTablet ? 40 : 100).toDouble();
        final verticalPadding = (isMobile ? 70 : 120).toDouble();
        final sectionTitleFontSize = isMobile ? 32.0 : 48.0;

        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: isDark ? AppTheme.darkSurface : Colors.white,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          child: Column(
            children: [
              _buildSectionTitle('About Me', isDark, sectionTitleFontSize),
              const SizedBox(height: 50),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1000),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      padding: EdgeInsets.all(isMobile ? 25 : 50),
                      decoration: BoxDecoration(
                        gradient: isDark
                            ? LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  AppTheme.darkCard.withOpacity(0.8),
                                  AppTheme.darkCard.withOpacity(0.6),
                                ],
                              )
                            : LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  AppTheme.lightBackground,
                                  AppTheme.lightBackground.withOpacity(0.8),
                                ],
                              ),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: isDark
                              ? AppTheme.darkPrimary.withOpacity(0.3)
                              : AppTheme.lightPrimary.withOpacity(0.2),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: isDark
                                ? Colors.black.withOpacity(0.3)
                                : Colors.black.withOpacity(0.08),
                            blurRadius: 30,
                            offset: const Offset(0, 15),
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: StreamBuilder<Map<String, dynamic>>(
                        stream: PortfolioService().getSettings(),
                        builder: (context, settingsSnap) {
                          final settings = settingsSnap.data ?? {};
                          final aboutMe = settings['aboutMe']?.toString().isNotEmpty == true
                              ? settings['aboutMe']
                              : AppConstants.aboutMe;
                          final experience = settings['experience']?.toString() ?? '1+ Years';
                          final projectsCount = settings['projectsCount']?.toString() ?? '14+ Completed';

                          return Column(
                            children: [
                              // ── Info Cards: Projects & Skills من Firestore ──
                              _DynamicInfoCards(
                                isDark: isDark,
                                isMobile: isMobile,
                                experience: experience,
                                projectsCount: projectsCount,
                              ),

                              const SizedBox(height: 35),

                              Text(
                                aboutMe,
                                textAlign: TextAlign.center,
                                textScaleFactor: isMobile ? 0.85 : 1.0,
                                style: TextStyle(
                                  fontSize: isMobile ? 14 : 18,
                                  color: isDark
                                      ? AppTheme.darkTextSecondary
                                      : AppTheme.lightTextSecondary,
                                  height: isMobile ? 1.6 : 1.9,
                                  letterSpacing: 0.2,
                                ),
                              ),

                              const SizedBox(height: 35),

                              Wrap(
                                spacing: 15,
                                runSpacing: 15,
                                alignment: WrapAlignment.center,
                                children: [
                                  _buildHighlight('Clean Code', isDark, isMobile),
                                  _buildHighlight('Fast Development', isDark, isMobile),
                                  _buildHighlight('User-Focused', isDark, isMobile),
                                  _buildHighlight('Responsive Design', isDark, isMobile),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title, bool isDark, double fontSize) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: fontSize,
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
          ),
        ),
      ],
    );
  }

  Widget _buildHighlight(String text, bool isDark, bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 15 : 20,
        vertical: isMobile ? 10 : 12,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            (isDark ? AppTheme.darkPrimary : AppTheme.lightPrimary).withOpacity(0.9),
            (isDark ? AppTheme.darkAccent : AppTheme.lightAccent).withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle, color: Colors.white, size: 18),
          const SizedBox(width: 6),
          Text(
            text,
            textScaleFactor: isMobile ? 0.9 : 1.0,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// Dynamic Info Cards — Projects & Skills من Firestore
// ═══════════════════════════════════════════════════════════
class _DynamicInfoCards extends StatelessWidget {
  final bool isDark;
  final bool isMobile;
  final String experience;
  final String projectsCount;

  const _DynamicInfoCards({
    required this.isDark,
    required this.isMobile,
    required this.experience,
    required this.projectsCount,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final cardWidth = isMobile ? (width - 80) / 3 : null;

    // Projects count من Firestore (عدد الـ docs الفعلي)
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: PortfolioService().getProjects(),
      builder: (context, projectsSnap) {
        final projectsTotal = projectsSnap.data?.length ?? 0;

        // Skills count من Firestore (عدد الـ docs الفعلي)
        return StreamBuilder<List<Map<String, dynamic>>>(
          stream: PortfolioService().getSkills(),
          builder: (context, skillsSnap) {
            final skillsTotal = skillsSnap.data?.length ?? 0;

            final infoCards = [
              _buildInfoCard(
                '🎓',
                'Education',
                'Computer Science & IS',
                isDark,
                isMobile,
                cardWidth,
              ),
              _buildInfoCard(
                '💼',
                'Experience',
                experience, // من Firestore settings
                isDark,
                isMobile,
                cardWidth,
              ),
              _buildInfoCard(
                '🚀',
                'Projects',
                projectsTotal > 0
                    ? '$projectsTotal+ Completed'
                    : projectsCount, // fallback لو Firestore فاضل
                isDark,
                isMobile,
                cardWidth,
              ),
              _buildInfoCard(
                '🧠',
                'Skills',
                skillsTotal > 0
                    ? '$skillsTotal+ Skills'
                    : '15+ Skills', // fallback
                isDark,
                isMobile,
                cardWidth,
              ),
            ];

            if (isMobile) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: infoCards
                      .map((card) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: card,
                          ))
                      .toList(),
                ),
              );
            } else {
              return Row(
                children: infoCards
                    .asMap()
                    .entries
                    .expand((e) => [
                          Expanded(child: e.value),
                          if (e.key < infoCards.length - 1)
                            const SizedBox(width: 16),
                        ])
                    .toList(),
              );
            }
          },
        );
      },
    );
  }

  Widget _buildInfoCard(
    String emoji,
    String title,
    String value,
    bool isDark,
    bool isMobile, [
    double? width,
  ]) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            (isDark ? AppTheme.darkPrimary : AppTheme.lightPrimary).withOpacity(0.2),
            (isDark ? AppTheme.darkAccent : AppTheme.lightAccent).withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 38)),
          const SizedBox(height: 8),
          Text(
            title,
            textScaleFactor: isMobile ? 0.90 : 1.0,
            style: TextStyle(
              fontSize: isMobile ? 12 : 14,
              color: isDark
                  ? AppTheme.darkTextSecondary
                  : AppTheme.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            textScaleFactor: isMobile ? 0.90 : 1.0,
            style: TextStyle(
              fontSize: isMobile ? 13 : 16,
              color: isDark ? AppTheme.darkText : AppTheme.lightText,
              fontWeight: FontWeight.w800,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}