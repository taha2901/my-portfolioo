import 'package:flutter/material.dart';
import 'package:taha_portfolio/core/services/portfolio_service.dart';
import 'package:taha_portfolio/core/theme/app_theme.dart';
import 'package:taha_portfolio/core/utils/responsive.dart';
import 'dart:ui';

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final service = PortfolioService();
    final isMobile = Responsive.isMobile(context);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkBackground : AppTheme.lightBackground,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile
            ? 20
            : Responsive.isTablet(context)
                ? 40
                : 100,
        vertical: isMobile ? 80 : 120,
      ),
      child: Column(
        children: [
          _buildSectionTitle('Skills & Technologies', isDark),
          const SizedBox(height: 60),
          StreamBuilder<List<Map<String, dynamic>>>(
            stream: service.getSkills(),
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final skills = snap.data ?? [];
              return ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    int crossAxisCount = 3;
                    if (constraints.maxWidth > 900) crossAxisCount = 5;
                    else if (constraints.maxWidth > 600) crossAxisCount = 4;

                    // FIX: childAspectRatio ديناميكي حسب عدد الأعمدة
                    final double cardSize = constraints.maxWidth / crossAxisCount - 20;
                    final double aspectRatio = cardSize / (cardSize + 10); // إضافة مساحة للنص

                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: skills.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 20,
                        // FIX: قيمة ثابتة أقل من 1 تعطي مساحة كافية للنص
                        childAspectRatio: isMobile ? 0.85 : 0.9,
                      ),
                      itemBuilder: (context, index) {
                        final skill = skills[index];
                        return TweenAnimationBuilder(
                          duration: Duration(milliseconds: 500 + (index * 50)),
                          tween: Tween<double>(begin: 0, end: 1),
                          builder: (context, double value, child) {
                            return Transform.scale(
                              scale: value,
                              child: Opacity(
                                opacity: value,
                                child: _buildSkillCard(
                                  skill['name'] ?? '',
                                  skill['emoji'] ?? '📦',
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
              );
            },
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
            gradient: LinearGradient(colors: [
              isDark ? AppTheme.darkPrimary : AppTheme.lightPrimary,
              isDark ? AppTheme.darkAccent : AppTheme.lightAccent,
            ]),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ],
    );
  }

  Widget _buildSkillCard(
      String name, String emoji, BuildContext context, bool isDark) {
    final isMobile = Responsive.isMobile(context);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            // FIX: padding أقل على mobile + overflow مضمون
            padding: EdgeInsets.all(isMobile ? 8 : 10),
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
              mainAxisSize: MainAxisSize.min, // FIX: لا يتمدد أكثر من اللازم
              children: [
                // FIX: حجم أصغر على mobile وأقل overflow
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    emoji,
                    style: TextStyle(fontSize: isMobile ? 32 : 46),
                  ),
                ),
                SizedBox(height: isMobile ? 6 : 12),
                // FIX: النص مع overflow ellipsis ومحاذاة مضمونة
                Text(
                  name,
                  style: TextStyle(
                    fontSize: isMobile ? 11 : 15,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppTheme.darkText : AppTheme.lightText,
                    height: 1.2,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}