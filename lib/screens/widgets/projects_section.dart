import 'package:flutter/material.dart';
import 'package:taha_portfolio/core/services/portfolio_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:ui';
import 'dart:math' as math;
import '../../core/theme/app_theme.dart';
import '../../core/utils/responsive.dart';
import '../../models/project_model.dart';
import 'all_projects_screen.dart';

class _TabMeta {
  final String emoji, label, category;
  final Color color;
  const _TabMeta(this.emoji, this.label, this.category, this.color);
}

// ═══════════════════════════════════════════════════════════
//  Projects Section — Main Widget
// ═══════════════════════════════════════════════════════════
class ProjectsSection extends StatefulWidget {
  const ProjectsSection({super.key});

  @override
  State<ProjectsSection> createState() => _ProjectsSectionState();
}

class _ProjectsSectionState extends State<ProjectsSection>
    with TickerProviderStateMixin {
  int _selectedTab = 0;
  late AnimationController _fadeCtrl;
  late AnimationController _headerCtrl;
  late Animation<double> _fadeAnim;
  late Animation<double> _headerAnim;

  List<_TabMeta> _tabs(bool isDark) => [
    _TabMeta(
      '📱',
      'Mobile',
      'Mobile',
      isDark ? AppTheme.darkPrimary : AppTheme.lightPrimary,
    ),
    _TabMeta(
      '⚙️',
      'Desktop',
      'Desktop',
      isDark ? AppTheme.darkSecondary : AppTheme.lightSecondary,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _headerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _headerAnim = CurvedAnimation(
      parent: _headerCtrl,
      curve: Curves.easeOutCubic,
    );
    _fadeCtrl.forward();
    _headerCtrl.forward();
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    _headerCtrl.dispose();
    super.dispose();
  }

  Future<void> _switchTab(int index) async {
    if (index == _selectedTab) return;
    await _fadeCtrl.reverse();
    setState(() => _selectedTab = index);
    _fadeCtrl.forward();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = Responsive.isMobile(context);
    final isTablet = Responsive.isTablet(context);
    final tabs = _tabs(isDark);
    final activeTab = tabs[_selectedTab];

    final hPad = isMobile
        ? 20.0
        : isTablet
        ? 40.0
        : 100.0;

    return Container(
      width: double.infinity,
      color: isDark ? const Color(0xFF080B14) : const Color(0xFFF7F8FC),
      child: Stack(
        children: [
          // ── Decorative background orbs ──────────────
          Positioned(
            top: -80,
            right: -60,
            child: _GlowOrb(color: activeTab.color, size: 320),
          ),
          Positioned(
            bottom: 60,
            left: -80,
            child: _GlowOrb(color: activeTab.color, size: 260),
          ),

          // ── Content ─────────────────────────────────
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: hPad,
              vertical: isMobile ? 72 : 120,
            ),
            child: Column(
              children: [
                // Header
                FadeTransition(
                  opacity: _headerAnim,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.15),
                      end: Offset.zero,
                    ).animate(_headerAnim),
                    child: _SectionHeader(
                      isDark: isDark,
                      isMobile: isMobile,
                      isTablet: isTablet,
                    ),
                  ),
                ),

                SizedBox(height: isMobile ? 36 : 52),

                // Tab Bar
                _ModernTabBar(
                  tabs: tabs,
                  selected: _selectedTab,
                  isDark: isDark,
                  isMobile: isMobile,
                  onTap: _switchTab,
                ),

                SizedBox(height: isMobile ? 32 : 52),

                // Grid
                FadeTransition(
                  opacity: _fadeAnim,
                  child: StreamBuilder<List<Map<String, dynamic>>>(
                    stream: PortfolioService().getProjects(
                      category: activeTab.category,
                    ),
                    builder: (context, snap) {
                      if (snap.connectionState == ConnectionState.waiting) {
                        return _LoadingShimmer(
                          isDark: isDark,
                          isMobile: isMobile,
                        );
                      }

                      final raw = snap.data ?? [];
                      final projects = raw
                          .map(
                            (p) => Project(
                              title: p['title'] ?? '',
                              description: p['description'] ?? '',
                              technologies: List<String>.from(
                                p['technologies'] ?? [],
                              ),
                              imagePath:
                                  p['imagePath'] ??
                                  'assets/img/placeholder.png',
                              category: p['category'] ?? 'Mobile',
                              githubLink: p['githubLink'],
                              apkLink: p['apkLink'],
                              videoLink: p['videoLink'],
                              badge: p['badge'],
                            ),
                          )
                          .toList();

                      final displayed = projects.take(4).toList();

                      if (displayed.isEmpty) {
                        return _EmptyState(
                          tab: activeTab,
                          isDark: isDark,
                          isMobile: isMobile,
                        );
                      }

                      return Responsive.isDesktop(context)
                          ? _DesktopMasonryGrid(
                              projects: displayed,
                              isDark: isDark,
                              accentColor: activeTab.color,
                              outerContext: context,
                              isTablet: isTablet,
                            )
                          : _MobileCardStack(
                              projects: displayed,
                              isDark: isDark,
                              accentColor: activeTab.color,
                              outerContext: context,
                            );
                    },
                  ),
                ),

                // View All Button
                StreamBuilder<List<Map<String, dynamic>>>(
                  stream: PortfolioService().getProjects(
                    category: activeTab.category,
                  ),
                  builder: (context, snap) {
                    final total = snap.data?.length ?? 0;
                    if (total <= 4) return const SizedBox(height: 8);
                    return Padding(
                      padding: const EdgeInsets.only(top: 52),
                      child: _ViewAllButton(
                        category: activeTab.category,
                        accentColor: activeTab.color,
                        isDark: isDark,
                        outerContext: context,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
//  Glow Orb Background
// ═══════════════════════════════════════════════════════════
class _GlowOrb extends StatelessWidget {
  final Color color;
  final double size;
  const _GlowOrb({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [color.withOpacity(0.10), Colors.transparent],
            stops: const [0.0, 1.0],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
//  Section Header
// ═══════════════════════════════════════════════════════════
class _SectionHeader extends StatelessWidget {
  final bool isDark, isMobile, isTablet;
  const _SectionHeader({
    required this.isDark,
    required this.isMobile,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Pill label
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            border: Border.all(
              color: (isDark ? AppTheme.darkPrimary : AppTheme.lightPrimary)
                  .withOpacity(0.4),
              width: 1.5,
            ),
            color: (isDark ? AppTheme.darkPrimary : AppTheme.lightPrimary)
                .withOpacity(0.08),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark ? AppTheme.darkPrimary : AppTheme.lightPrimary,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'SELECTED WORK',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2.5,
                  color: isDark ? AppTheme.darkPrimary : AppTheme.lightPrimary,
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: isMobile ? 18 : 22),

        // Title
        Text(
          'Projects That\nMatter',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: isMobile
                ? 36
                : isTablet
                ? 48
                : 60,
            fontWeight: FontWeight.w900,
            color: isDark ? Colors.white : const Color(0xFF0D1117),
            height: 1.08,
            letterSpacing: -2,
          ),
        ),

        SizedBox(height: isMobile ? 14 : 18),

        // Subtitle
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Text(
            'Real products, real users, real impact — built with Flutter and modern backend technologies.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isMobile ? 13.5 : 15.5,
              color: isDark
                  ? Colors.white.withOpacity(0.50)
                  : const Color(0xFF0D1117).withOpacity(0.50),
              height: 1.65,
              letterSpacing: 0.1,
            ),
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════
//  Modern Tab Bar — pill style with animated indicator
// ═══════════════════════════════════════════════════════════
class _ModernTabBar extends StatelessWidget {
  final List<_TabMeta> tabs;
  final int selected;
  final bool isDark, isMobile;
  final Future<void> Function(int) onTap;

  const _ModernTabBar({
    required this.tabs,
    required this.selected,
    required this.isDark,
    required this.isMobile,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withOpacity(0.05)
            : Colors.black.withOpacity(0.05),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.08)
              : Colors.black.withOpacity(0.07),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: tabs.asMap().entries.map((e) {
          final isActive = selected == e.key;
          return GestureDetector(
            onTap: () => onTap(e.key),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOutCubic,
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 16 : 26,
                vertical: isMobile ? 11 : 13,
              ),
              decoration: BoxDecoration(
                color: isActive
                    ? (isDark ? Colors.white.withOpacity(0.10) : Colors.white)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(13),
                boxShadow: isActive
                    ? [
                        BoxShadow(
                          color: e.value.color.withOpacity(0.20),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: TextStyle(fontSize: isMobile ? 15 : 17),
                    child: Text(e.value.emoji),
                  ),
                  SizedBox(width: isMobile ? 6 : 8),
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: TextStyle(
                      fontSize: isMobile ? 20.5 : 25.5,
                      fontWeight: isActive ? FontWeight.w800 : FontWeight.w500,
                      color: isActive
                          ? e.value.color
                          : (isDark
                                ? Colors.white.withOpacity(0.40)
                                : Colors.black.withOpacity(0.40)),
                      letterSpacing: isActive ? 0.3 : 0,
                    ),
                    child: Text(e.value.label),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
//  Loading Shimmer
// ═══════════════════════════════════════════════════════════
class _LoadingShimmer extends StatefulWidget {
  final bool isDark, isMobile;
  const _LoadingShimmer({required this.isDark, required this.isMobile});

  @override
  State<_LoadingShimmer> createState() => _LoadingShimmerState();
}

class _LoadingShimmerState extends State<_LoadingShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) {
        final base = widget.isDark
            ? Colors.white.withOpacity(0.04)
            : Colors.black.withOpacity(0.05);
        final shimmer = widget.isDark
            ? Colors.white.withOpacity(0.08)
            : Colors.black.withOpacity(0.10);

        return Wrap(
          spacing: 24,
          runSpacing: 24,
          alignment: WrapAlignment.center,
          children: List.generate(
            widget.isMobile ? 2 : 4,
            (i) => _ShimmerCard(
              width: widget.isMobile ? double.infinity : 380,
              base: base,
              shimmer: shimmer,
              delay: i * 0.15,
              progress: _anim.value,
            ),
          ),
        );
      },
    );
  }
}

class _ShimmerCard extends StatelessWidget {
  final double width;
  final Color base, shimmer;
  final double delay, progress;
  const _ShimmerCard({
    required this.width,
    required this.base,
    required this.shimmer,
    required this.delay,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final p = ((progress - delay) % 1.0).clamp(0.0, 1.0);
    final color = Color.lerp(base, shimmer, math.sin(p * math.pi))!;

    return Container(
      width: width == double.infinity
          ? MediaQuery.of(context).size.width - 40
          : width,
      height: 360,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
//  Empty State
// ═══════════════════════════════════════════════════════════
class _EmptyState extends StatelessWidget {
  final _TabMeta tab;
  final bool isDark, isMobile;
  const _EmptyState({
    required this.tab,
    required this.isDark,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 64),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: tab.color.withOpacity(0.10),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: tab.color.withOpacity(0.20),
                width: 1.5,
              ),
            ),
            child: Center(
              child: Text(tab.emoji, style: const TextStyle(fontSize: 36)),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'No ${tab.label} projects yet',
            style: TextStyle(
              fontSize: isMobile ? 16 : 18,
              fontWeight: FontWeight.w700,
              color: isDark
                  ? Colors.white.withOpacity(0.7)
                  : const Color(0xFF0D1117).withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Check back soon — always building.',
            style: TextStyle(
              fontSize: 13.5,
              color: isDark
                  ? Colors.white.withOpacity(0.35)
                  : Colors.black.withOpacity(0.35),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
//  Mobile Card Stack — vertical scroll
// ═══════════════════════════════════════════════════════════
class _MobileCardStack extends StatelessWidget {
  final List<Project> projects;
  final bool isDark;
  final Color accentColor;
  final BuildContext outerContext;

  const _MobileCardStack({
    required this.projects,
    required this.isDark,
    required this.accentColor,
    required this.outerContext,
  });

  @override
  Widget build(BuildContext context) {
    // final isMobile = Responsive.isMobile(context);
    const cardW = 320.0;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 460),
      child: ListView.separated(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
        itemCount: projects.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (_, i) => TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 350 + i * 80),
          tween: Tween(begin: 0, end: 1),
          curve: Curves.easeOutCubic,
          builder: (_, v, child) => Transform.translate(
            offset: Offset(20 * (1 - v), 0),
            child: Opacity(opacity: v, child: child),
          ),
          child: SizedBox(
            width: cardW,
            child: _ProjectCard(
              project: projects[i],
              isDark: isDark,
              accentColor: accentColor,
              outerContext: outerContext,
              index: i,
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
//  Desktop Masonry Grid
// ═══════════════════════════════════════════════════════════
class _DesktopMasonryGrid extends StatelessWidget {
  final List<Project> projects;
  final bool isDark, isTablet;
  final Color accentColor;
  final BuildContext outerContext;

  const _DesktopMasonryGrid({
    required this.projects,
    required this.isDark,
    required this.accentColor,
    required this.outerContext,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final cols = isTablet ? 3 : 4;
    final hPad = isTablet ? 80.0 : 200.0;
    const spacing = 16.0;
    final cardW = ((width - hPad) - (cols - 1) * spacing) / cols;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 1600),
      child: Wrap(
        spacing: spacing,
        runSpacing: 20,
        alignment: WrapAlignment.center,
        children: projects.asMap().entries.map((e) {
          return TweenAnimationBuilder<double>(
            duration: Duration(milliseconds: 500 + e.key * 100),
            tween: Tween(begin: 0, end: 1),
            curve: Curves.easeOutCubic,
            builder: (_, v, child) => Transform.translate(
              offset: Offset(0, 32 * (1 - v)),
              child: Opacity(opacity: v, child: child),
            ),
            child: SizedBox(
              width: cardW.clamp(200.0, 420.0),
              child: _ProjectCard(
                project: e.value,
                isDark: isDark,
                accentColor: accentColor,
                outerContext: outerContext,
                index: e.key,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
//  Project Card — premium design
// ═══════════════════════════════════════════════════════════
class _ProjectCard extends StatefulWidget {
  final Project project;
  final bool isDark;
  final Color accentColor;
  final BuildContext outerContext;
  final int index;

  const _ProjectCard({
    required this.project,
    required this.isDark,
    required this.accentColor,
    required this.outerContext,
    required this.index,
  });

  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard>
    with SingleTickerProviderStateMixin {
  bool _hovered = false;
  late AnimationController _hoverCtrl;
  late Animation<double> _hoverAnim;

  @override
  void initState() {
    super.initState();
    _hoverCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    _hoverAnim = CurvedAnimation(
      parent: _hoverCtrl,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _hoverCtrl.dispose();
    super.dispose();
  }

  void _onEnter(_) {
    setState(() => _hovered = true);
    _hoverCtrl.forward();
  }

  void _onExit(_) {
    setState(() => _hovered = false);
    _hoverCtrl.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.project;
    final isDark = widget.isDark;
    final accent = widget.accentColor;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: _onEnter,
      onExit: _onExit,
      child: AnimatedBuilder(
        animation: _hoverAnim,
        builder: (_, child) => Transform.translate(
          offset: Offset(0, -6 * _hoverAnim.value),
          child: child,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF111827) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _hovered
                  ? accent.withOpacity(0.45)
                  : (isDark
                        ? Colors.white.withOpacity(0.06)
                        : Colors.black.withOpacity(0.07)),
              width: 1.5,
            ),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: accent.withOpacity(0.18),
                      blurRadius: 40,
                      offset: const Offset(0, 16),
                      spreadRadius: 0,
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.10),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(isDark ? 0.30 : 0.06),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Image with overlay ──────────────────
                _CardImage(project: p, accentColor: accent, hovered: _hovered),

                // ── Body ───────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(22, 20, 22, 22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title + number
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              p.title,
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                                color: isDark
                                    ? Colors.white
                                    : const Color(0xFF0D1117),
                                letterSpacing: -0.5,
                                height: 1.25,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '#${(widget.index + 1).toString().padLeft(2, '0')}',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: accent.withOpacity(0.55),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // Description
                      GestureDetector(
                        onTap: () => _showFullDescription(
                          context,
                          p.title,
                          p.description,
                          isDark,
                          accent,
                        ),
                        child: RichText(
                          maxLines: 2,
                          overflow: TextOverflow.clip,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: p.description.length > 80
                                    ? '${p.description.substring(0, 80)}... '
                                    : p.description,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: isDark
                                      ? Colors.white.withOpacity(0.45)
                                      : Colors.black.withOpacity(0.45),
                                  height: 1.6,
                                ),
                              ),
                              if (p.description.length > 80)
                                TextSpan(
                                  text: 'read more',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: accent,
                                    height: 1.6,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Tech chips — horizontal scroll
                      SizedBox(
                        height: 28,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: p.technologies.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 6),
                          itemBuilder: (_, i) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: accent.withOpacity(0.09),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: accent.withOpacity(0.22),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              p.technologies[i],
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: accent,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      // Divider
                      Container(
                        height: 1,
                        color: isDark
                            ? Colors.white.withOpacity(0.06)
                            : Colors.black.withOpacity(0.06),
                      ),

                      const SizedBox(height: 16),

                      // Action Buttons
                      _CardActions(
                        project: p,
                        accentColor: accent,
                        isDark: isDark,
                        outerContext: widget.outerContext,
                      ),
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

  void _showFullDescription(
    BuildContext context,
    String title,
    String description,
    bool isDark,
    Color accent,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.6,
        ),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF111827) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          border: Border.all(color: accent.withOpacity(0.20), width: 1.5),
        ),
        padding: const EdgeInsets.fromLTRB(28, 20, 28, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withOpacity(0.15)
                      : Colors.black.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 22),
            // Title
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : const Color(0xFF0D1117),
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              width: 40,
              height: 3,
              decoration: BoxDecoration(
                color: accent,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 18),
            // Description
            Flexible(
              child: SingleChildScrollView(
                child: Text(
                  description,
                  style: TextStyle(
                    fontSize: 14.5,
                    color: isDark
                        ? Colors.white.withOpacity(0.65)
                        : Colors.black.withOpacity(0.65),
                    height: 1.75,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Card Image ──────────────────────────────────────────
class _CardImage extends StatelessWidget {
  final Project project;
  final Color accentColor;
  final bool hovered;
  const _CardImage({
    required this.project,
    required this.accentColor,
    required this.hovered,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      height: 200,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: AnimatedScale(
              scale: hovered ? 1.04 : 1.0,
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeOutCubic,
              child: Image.asset(
                project.imagePath,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        accentColor.withOpacity(0.18),
                        accentColor.withOpacity(0.08),
                      ],
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.code_rounded,
                      size: 52,
                      color: accentColor.withOpacity(0.35),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Bottom gradient overlay
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.55)],
                ),
              ),
            ),
          ),

          // Category chip — bottom left
          Positioned(
            bottom: 12,
            left: 14,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.50),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.white.withOpacity(0.12),
                  width: 1,
                ),
              ),
              child: Text(
                project.category.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 9.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),

          // Badge — top right
          if (project.badge != null)
            Positioned(
              top: 12,
              right: 12,
              child: _BadgeChip(badge: project.badge!),
            ),
        ],
      ),
    );
  }
}

// ─── Badge Chip ──────────────────────────────────────────
class _BadgeChip extends StatelessWidget {
  final String badge;
  const _BadgeChip({required this.badge});

  Color get _color => switch (badge.toLowerCase()) {
    'featured' => const Color(0xFFFF4D6D),
    'offline' => const Color(0xFF3B82F6),
    'cloud' => const Color(0xFF10B981),
    _ => const Color(0xFF8B5CF6),
  };

  IconData get _icon => switch (badge.toLowerCase()) {
    'featured' => Icons.star_rounded,
    'offline' => Icons.storage_rounded,
    'cloud' => Icons.cloud_rounded,
    _ => Icons.label_rounded,
  };

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: _color.withOpacity(0.85),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white.withOpacity(0.20), width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(_icon, size: 12, color: Colors.white),
              const SizedBox(width: 5),
              Text(
                badge,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Card Actions ─────────────────────────────────────────
class _CardActions extends StatelessWidget {
  final Project project;
  final Color accentColor;
  final bool isDark;
  final BuildContext outerContext;

  const _CardActions({
    required this.project,
    required this.accentColor,
    required this.isDark,
    required this.outerContext,
  });

  @override
  Widget build(BuildContext context) {
    final btns = <({IconData icon, String label, String url})>[];
    if (project.githubLink != null)
      btns.add((
        icon: Icons.code_rounded,
        label: 'Code',
        url: project.githubLink!,
      ));
    if (project.apkLink != null)
      btns.add((
        icon: Icons.android_rounded,
        label: 'APK',
        url: project.apkLink!,
      ));
    if (project.videoLink != null && project.videoLink!.trim().isNotEmpty)
      btns.add((
        icon: Icons.play_arrow_rounded,
        label: 'Demo',
        url: project.videoLink!,
      ));

    if (btns.isEmpty) return const SizedBox();

    return Row(
      children: [
        // Primary button (first)
        Expanded(
          flex: 2,
          child: _ActionButton(
            icon: btns[0].icon,
            label: btns[0].label,
            url: btns[0].url,
            isPrimary: true,
            accentColor: accentColor,
            isDark: isDark,
            outerContext: outerContext,
          ),
        ),

        // Secondary buttons
        if (btns.length > 1) ...[
          const SizedBox(width: 8),
          ...btns
              .skip(1)
              .map(
                (b) => Padding(
                  padding: const EdgeInsets.only(left: 0),
                  child: Row(
                    children: [
                      _ActionButton(
                        icon: b.icon,
                        label: b.label,
                        url: b.url,
                        isPrimary: false,
                        accentColor: accentColor,
                        isDark: isDark,
                        outerContext: outerContext,
                        iconOnly: true,
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                ),
              ),
        ],
      ],
    );
  }
}

class _ActionButton extends StatefulWidget {
  final IconData icon;
  final String label, url;
  final bool isPrimary, isDark;
  final bool iconOnly;
  final Color accentColor;
  final BuildContext outerContext;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.url,
    required this.isPrimary,
    required this.isDark,
    required this.accentColor,
    required this.outerContext,
    this.iconOnly = false,
  });

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final accent = widget.accentColor;

    if (!widget.isPrimary && widget.iconOnly) {
      return MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),

        child: GestureDetector(
          onTap: () => _launch(widget.url),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _hovered
                  ? accent.withOpacity(0.12)
                  : (widget.isDark
                        ? Colors.white.withOpacity(0.06)
                        : Colors.black.withOpacity(0.05)),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _hovered
                    ? accent.withOpacity(0.35)
                    : (widget.isDark
                          ? Colors.white.withOpacity(0.08)
                          : Colors.black.withOpacity(0.08)),
                width: 1,
              ),
            ),
            child: Icon(
              widget.icon,
              size: 22,
              color: _hovered
                  ? accent
                  : (widget.isDark
                        ? Colors.white.withOpacity(0.55)
                        : Colors.black.withOpacity(0.45)),
            ),
          ),
        ),
      );
    }

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => _launch(widget.url),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: 42,
          decoration: BoxDecoration(
            color: _hovered ? accent : accent.withOpacity(0.10),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _hovered ? accent : accent.withOpacity(0.28),
              width: 1.5,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  widget.icon,
                  size: 15,
                  color: _hovered ? Colors.white : accent,
                ),
                const SizedBox(width: 6),
                Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: _hovered ? Colors.white : accent,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _launch(String url) async {
    if (url.trim().isEmpty) {
      ScaffoldMessenger.of(
        widget.outerContext,
      ).showSnackBar(const SnackBar(content: Text('🎬 Coming soon!')));
      return;
    }
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(
        widget.outerContext,
      ).showSnackBar(const SnackBar(content: Text('Could not open link')));
    }
  }
}

// ═══════════════════════════════════════════════════════════
//  View All Button
// ═══════════════════════════════════════════════════════════
class _ViewAllButton extends StatefulWidget {
  final String category;
  final Color accentColor;
  final bool isDark;
  final BuildContext outerContext;

  const _ViewAllButton({
    required this.category,
    required this.accentColor,
    required this.isDark,
    required this.outerContext,
  });

  @override
  State<_ViewAllButton> createState() => _ViewAllButtonState();
}

class _ViewAllButtonState extends State<_ViewAllButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => Navigator.push(
          widget.outerContext,
          MaterialPageRoute(
            builder: (_) => AllProjectsScreen(category: widget.category),
          ),
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
          decoration: BoxDecoration(
            color: _hovered
                ? widget.accentColor
                : widget.accentColor.withOpacity(0.10),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: _hovered
                  ? widget.accentColor
                  : widget.accentColor.withOpacity(0.30),
              width: 1.5,
            ),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: widget.accentColor.withOpacity(0.30),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'View All ${widget.category} Projects',
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: _hovered ? Colors.white : widget.accentColor,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(width: 10),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                transform: Matrix4.translationValues(_hovered ? 4 : 0, 0, 0),
                child: Icon(
                  Icons.arrow_forward_rounded,
                  size: 18,
                  color: _hovered ? Colors.white : widget.accentColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
