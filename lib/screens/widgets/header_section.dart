import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'dart:ui';
import '../../core/utils/responsive.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: double.infinity,
      height: Responsive.isMobile(context)
          ? screenHeight *
                0.7 // 70% للموبايل
          : Responsive.isTablet(context)
          ? screenHeight *
                0.75 // 75% للتابليت
          : screenHeight * 0.85, // 85% للديسكتوب
      decoration: BoxDecoration(
        gradient: isDark ? AppTheme.darkGradient : AppTheme.lightGradient,
      ),
      child: Stack(
        children: [
          // Animated Background Circles
          ..._buildAnimatedBackground(isDark),

          // Content
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
        top: -100,
        right: -100,
        child: _buildGlowingCircle(300, isDark),
      ),
      Positioned(
        bottom: -150,
        left: -150,
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
            _buildQuickStatsMobile(isDark),
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
              _buildQuickStatsTablet(isDark),
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
                  _buildQuickStats(isDark),
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
    final isDesktop = Responsive.isDesktop(context);
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
              'Get In Touch',
              Icons.email_outlined,
              true,
              isDark,
              isMobile,
            ),
            _buildGlassButton(
              'View Projects',
              Icons.work_outline,
              false,
              isDark,
              isMobile,
            ),
          ],
        ),
      ],
    );
  }

  // Quick Stats for Desktop
  Widget _buildQuickStats(bool isDark) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.15),
                Colors.white.withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1.5,
            ),
          ),
          child: IntrinsicHeight(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildStatItem('1+', 'Years Experience', isDark),
                const SizedBox(width: 30),
                Container(width: 1, color: Colors.white.withOpacity(0.3)),
                const SizedBox(width: 30),
                _buildStatItem('7+', 'Projects Done', isDark),
                const SizedBox(width: 30),
                Container(width: 1, color: Colors.white.withOpacity(0.3)),
                const SizedBox(width: 30),
                _buildStatItem('15+', 'Skills', isDark),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Quick Stats for Mobile
  Widget _buildQuickStatsMobile(bool isDark) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.15),
                Colors.white.withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1.5,
            ),
          ),
          child: IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatItemMobile('3+', 'Years', isDark),
                Container(width: 1, color: Colors.white.withOpacity(0.3)),
                _buildStatItemMobile('7+', 'Projects', isDark),
                Container(width: 1, color: Colors.white.withOpacity(0.3)),
                _buildStatItemMobile('15+', 'Skills', isDark),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Quick Stats for Tablet
  Widget _buildQuickStatsTablet(bool isDark) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.15),
                Colors.white.withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1.5,
            ),
          ),
          child: IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatItemTablet('3+', 'Years Experience', isDark),
                Container(width: 1, color: Colors.white.withOpacity(0.3)),
                _buildStatItemTablet('7+', 'Projects Done', isDark),
                Container(width: 1, color: Colors.white.withOpacity(0.3)),
                _buildStatItemTablet('15+', 'Skills', isDark),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String number, String label, bool isDark) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          number,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildStatItemMobile(String number, String label, bool isDark) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          number,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildStatItemTablet(String number, String label, bool isDark) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          number,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildSkillsList(bool isDark) {
    final topSkills = ['Flutter', 'Dart', 'Firebase','Supabase', 'SQLite', 'REST APIs'];

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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1.5,
                ),
              ),
              child: Text(
                skill,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
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

  Widget _buildSkillsListMobile(bool isDark) {
    final topSkills = ['Flutter', 'Dart', 'Firebase','Supabase', 'SQLite', 'REST APIs'];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: topSkills.map((skill) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1.5,
                ),
              ),
              child: Text(
                skill,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
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

  Widget _buildSkillsListTablet(bool isDark) {
    final topSkills = ['Flutter', 'Dart', 'Firebase','Supabase', 'SQLite', 'REST APIs'];

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
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1.5,
                ),
              ),
              child: Text(
                skill,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
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
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1.5,
            ),
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _buildGlassButton(
    String text,
    IconData icon,
    bool isPrimary,
    bool isDark,
    bool isMobile,
  ) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 20 : 25,
            vertical: isMobile ? 11 : 13,
          ),
          decoration: BoxDecoration(
            gradient: isPrimary
                ? LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.3),
                      Colors.white.withOpacity(0.2),
                    ],
                  )
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
    );
  }
}
