import 'package:flutter/material.dart';
import 'dart:ui';
import '../../core/theme/app_theme.dart';
import '../../core/utils/responsive.dart';
import '../../models/skill_model.dart';

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final skills = Skill.getSkills();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkBackground : AppTheme.lightBackground,
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
          _buildSectionTitle('Skills & Technologies', isDark),
          const SizedBox(height: 60),

          /// -------- GRID (3 per row on mobile) --------
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: LayoutBuilder(
              builder: (context, constraints) {
                int crossAxisCount = 3;

                if (constraints.maxWidth > 900) {
                  crossAxisCount = 5;
                } else if (constraints.maxWidth > 600) {
                  crossAxisCount = 4;
                }

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: skills.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    return TweenAnimationBuilder(
                      duration: Duration(milliseconds: 500 + (index * 50)),
                      tween: Tween<double>(begin: 0, end: 1),
                      builder: (context, double value, child) {
                        return Transform.scale(
                          scale: value,
                          child: Opacity(
                            opacity: value,
                            child: _buildSkillCard(
                              skills[index],
                              context,
                              isDark,
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
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

  Widget _buildSkillCard(Skill skill, BuildContext context, bool isDark) {
    final isMobile = Responsive.isMobile(context);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: isDark
                  ? LinearGradient(
                      colors: [
                        AppTheme.darkCard.withOpacity(0.8),
                        AppTheme.darkCard.withOpacity(0.6),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.9),
                        Colors.white.withOpacity(0.7),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
              borderRadius: BorderRadius.circular(20),
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
                      : Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(skill.emoji,
                    style: TextStyle(fontSize: isMobile ? 40 : 50)),
                const SizedBox(height: 12),
                Text(
                  skill.name,
                  style: TextStyle(
                    fontSize: isMobile ? 14 : 16,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppTheme.darkText : AppTheme.lightText,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
