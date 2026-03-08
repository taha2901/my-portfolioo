import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:taha_portfolio/core/services/portfolio_service.dart';
import 'dart:ui';
import '../../core/utils/responsive.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';

class HeaderSection extends StatelessWidget {
  final VoidCallback onGetInTouch;
  final VoidCallback onViewProjects;
  const HeaderSection({
    super.key,
    required this.onGetInTouch,
    required this.onViewProjects,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: double.infinity,
      height: Responsive.isMobile(context)
          ? screenHeight * 0.7
          : Responsive.isTablet(context)
              ? screenHeight * 0.75
              : screenHeight * 0.85,
      decoration: BoxDecoration(
        gradient: isDark ? AppTheme.darkGradient : AppTheme.lightGradient,
      ),
      child: Stack(
        children: [
          ..._buildAnimatedBackground(isDark),
          Responsive(
            mobile: _buildMobileHeader(context, isDark),
            tablet: _buildTabletHeader(context, isDark),
            desktop: _buildDesktopHeader(context, isDark),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildAnimatedBackground(bool isDark) {
    return [
      Positioned(
        top: -100, right: -100,
        child: _buildGlowingCircle(300, isDark),
      ),
      Positioned(
        bottom: -150, left: -150,
        child: _buildGlowingCircle(400, isDark),
      ),
      Positioned(top: 150, left: 80, child: _buildGlowingCircle(120, isDark)),
    ];
  }

  Widget _buildGlowingCircle(double size, bool isDark) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            (isDark ? AppTheme.darkPrimary : AppTheme.lightSecondary)
                .withOpacity(0.2),
            Colors.transparent,
          ],
        ),
      ),
    );
  }

  Widget _buildMobileHeader(BuildContext context, bool isDark) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            _buildGlassAvatar(90, isDark),
            const SizedBox(height: 25),
            _buildTextContent(context, TextAlign.center, isDark),
            const SizedBox(height: 30),
            _DynamicQuickStats(isDark: isDark, size: _StatSize.mobile),
            const SizedBox(height: 25),
            _buildSkillsListMobile(isDark),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTabletHeader(BuildContext context, bool isDark) {
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              _buildGlassAvatar(110, isDark),
              const SizedBox(height: 30),
              _buildTextContent(context, TextAlign.center, isDark),
              const SizedBox(height: 35),
              _DynamicQuickStats(isDark: isDark, size: _StatSize.tablet),
              const SizedBox(height: 30),
              _buildSkillsListTablet(isDark),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopHeader(BuildContext context, bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 60),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTextContent(context, TextAlign.left, isDark),
                  const SizedBox(height: 40),
                  _DynamicQuickStats(isDark: isDark, size: _StatSize.desktop),
                ],
              ),
            ),
            const SizedBox(width: 60),
            Expanded(
              flex: 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildGlassAvatar(180, isDark),
                  const SizedBox(height: 30),
                  _buildSkillsList(isDark),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGlassAvatar(double size, bool isDark) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(size / 2),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(isDark ? 0.2 : 0.3),
                Colors.white.withOpacity(isDark ? 0.1 : 0.2),
              ],
            ),
            border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
            boxShadow: [
              BoxShadow(
                color: (isDark ? AppTheme.darkPrimary : AppTheme.lightPrimary)
                    .withOpacity(0.3),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Image.asset('assets/img/IMG_1693.jpg', fit: BoxFit.cover),
        ),
      ),
    );
  }

  Widget _buildTextContent(
    BuildContext context,
    TextAlign alignment,
    bool isDark,
  ) {
    final isMobile = Responsive.isMobile(context);
    final isTablet = Responsive.isTablet(context);

    return Column(
      crossAxisAlignment: alignment == TextAlign.left
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildGlassContainer(
          child: Text(
            'Hi, I\'m',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: isMobile ? 14 : (isTablet ? 16 : 20),
              fontWeight: FontWeight.w400,
              letterSpacing: 2,
            ),
          ),
          isDark: isDark,
        ),
        SizedBox(height: isMobile ? 12 : 15),
        Text(
          AppConstants.name,
          style: TextStyle(
            color: Colors.white,
            fontSize: isMobile ? 32 : (isTablet ? 42 : 56),
            fontWeight: FontWeight.w900,
            height: 1.2,
            letterSpacing: -1,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.3),
                offset: const Offset(0, 4),
                blurRadius: 8,
              ),
            ],
          ),
          textAlign: alignment,
        ),
        SizedBox(height: isMobile ? 15 : 18),
        SizedBox(
          height: isMobile ? 30 : (isTablet ? 35 : 45),
          child: AnimatedTextKit(
            repeatForever: true,
            pause: const Duration(milliseconds: 1000),
            animatedTexts: [
              TyperAnimatedText(
                '💻 Flutter Developer',
                textStyle: TextStyle(
                  color: isDark ? AppTheme.darkAccent : Colors.white,
                  fontSize: isMobile ? 18 : (isTablet ? 24 : 32),
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
                speed: const Duration(milliseconds: 80),
              ),
              TyperAnimatedText(
                '📱 Mobile App Developer',
                textStyle: TextStyle(
                  color: isDark ? AppTheme.darkAccent : Colors.white,
                  fontSize: isMobile ? 18 : (isTablet ? 24 : 32),
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
                speed: const Duration(milliseconds: 80),
              ),
              TyperAnimatedText(
                '🚀 Cross-Platform Expert',
                textStyle: TextStyle(
                  color: isDark ? AppTheme.darkAccent : Colors.white,
                  fontSize: isMobile ? 18 : (isTablet ? 24 : 32),
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
                speed: const Duration(milliseconds: 80),
              ),
            ],
          ),
        ),
        SizedBox(height: isMobile ? 15 : 25),
        Text(
          isMobile
              ? 'CS & IS Bachelor\'s degree\nCross-platform specialist'
              : 'Bachelor\'s degree in Computer Science & Information Systems\nSpecializing in cross-platform development',
          style: TextStyle(
            color: Colors.white.withOpacity(0.85),
            fontSize: isMobile ? 12 : (isTablet ? 13 : 15),
            height: 1.6,
            letterSpacing: 0.3,
          ),
          textAlign: alignment,
        ),
        SizedBox(height: isMobile ? 20 : 30),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: alignment == TextAlign.left
              ? WrapAlignment.start
              : WrapAlignment.center,
          children: [
            _buildGlassButton(
              'Get In Touch', Icons.email_outlined, true, isDark, isMobile,
              onTap: onGetInTouch,
            ),
            _buildGlassButton(
              'View Projects', Icons.work_outline, false, isDark, isMobile,
              onTap: onViewProjects,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSkillsList(bool isDark) => _buildSkillsWrap(isDark, 16, 10, 14);
  Widget _buildSkillsListMobile(bool isDark) => _buildSkillsWrap(isDark, 12, 8, 12);
  Widget _buildSkillsListTablet(bool isDark) => _buildSkillsWrap(isDark, 14, 9, 13);

  Widget _buildSkillsWrap(bool isDark, double hPad, double vPad, double fontSize) {
    const topSkills = ['Flutter', 'Dart', 'Firebase', 'Supabase', 'SQLite', 'REST APIs'];
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      alignment: WrapAlignment.center,
      children: topSkills.map((skill) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
              ),
              child: Text(
                skill,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: fontSize,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildGlassContainer({required Widget child, required bool isDark}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.5),
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _buildGlassButton(
    String text, IconData icon, bool isPrimary, bool isDark, bool isMobile, {
    VoidCallback? onTap,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 20 : 25,
              vertical: isMobile ? 11 : 13,
            ),
            decoration: BoxDecoration(
              gradient: isPrimary
                  ? LinearGradient(colors: [
                      Colors.white.withOpacity(0.3),
                      Colors.white.withOpacity(0.2),
                    ])
                  : null,
              color: isPrimary ? null : Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: Colors.white, size: isMobile ? 18 : 20),
                SizedBox(width: isMobile ? 8 : 10),
                Text(
                  text,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isMobile ? 13 : 15,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// Dynamic Quick Stats — بيجيب الأرقام من Firestore
// ═══════════════════════════════════════════════════════════
enum _StatSize { mobile, tablet, desktop }

class _DynamicQuickStats extends StatelessWidget {
  final bool isDark;
  final _StatSize size;

  const _DynamicQuickStats({required this.isDark, required this.size});

  @override
  Widget build(BuildContext context) {
    final service = PortfolioService();

    return StreamBuilder<Map<String, dynamic>>(
      stream: service.getSettings(),
      builder: (context, settingsSnap) {
        final settings = settingsSnap.data ?? {};
        final experience = settings['experience']?.toString() ?? '1+';

        return StreamBuilder<List<Map<String, dynamic>>>(
          stream: service.getProjects(),
          builder: (context, projectsSnap) {
            final projectsCount = projectsSnap.data?.length ?? 0;
            final projectsLabel = projectsCount > 0 ? '$projectsCount+' : '14+';

            return StreamBuilder<List<Map<String, dynamic>>>(
              stream: service.getSkills(),
              builder: (context, skillsSnap) {
                final skillsCount = skillsSnap.data?.length ?? 0;
                final skillsLabel = skillsCount > 0 ? '$skillsCount+' : '15+';

                return _buildStatsContainer(experience, projectsLabel, skillsLabel);
              },
            );
          },
        );
      },
    );
  }

  Widget _buildStatsContainer(String exp, String projects, String skills) {
    final borderRadius = size == _StatSize.mobile ? 15.0 : size == _StatSize.tablet ? 18.0 : 20.0;
    final hPad = size == _StatSize.mobile ? 15.0 : size == _StatSize.tablet ? 20.0 : 25.0;
    final vPad = size == _StatSize.mobile ? 15.0 : size == _StatSize.tablet ? 18.0 : 20.0;

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.15),
                Colors.white.withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.5),
          ),
          child: IntrinsicHeight(
            child: Row(
              mainAxisSize: size == _StatSize.desktop ? MainAxisSize.min : MainAxisSize.max,
              mainAxisAlignment: size == _StatSize.desktop
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatItem(exp, _expLabel),
                _buildDivider(),
                _buildStatItem(projects, _projectsLabel),
                _buildDivider(),
                _buildStatItem(skills, _skillsLabel),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String get _expLabel => size == _StatSize.desktop ? 'Years Experience' : size == _StatSize.tablet ? 'Years Experience' : 'Years';
  String get _projectsLabel => size == _StatSize.desktop ? 'Projects Done' : size == _StatSize.tablet ? 'Projects Done' : 'Projects';
  String get _skillsLabel => 'Skills';

  Widget _buildDivider() {
    final spacing = size == _StatSize.desktop ? 30.0 : 0.0;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(width: spacing),
        Container(width: 1, color: Colors.white.withOpacity(0.3)),
        SizedBox(width: spacing),
      ],
    );
  }

  Widget _buildStatItem(String number, String label) {
    final numSize = size == _StatSize.mobile ? 18.0 : size == _StatSize.tablet ? 20.0 : 24.0;
    final labelSize = size == _StatSize.mobile ? 10.0 : size == _StatSize.tablet ? 11.0 : 12.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          number,
          style: TextStyle(
            color: Colors.white,
            fontSize: numSize,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: labelSize,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}