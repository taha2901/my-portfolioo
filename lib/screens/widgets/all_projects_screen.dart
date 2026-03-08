import 'package:flutter/material.dart';
import 'package:taha_portfolio/core/services/portfolio_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:ui';
import '../../core/utils/responsive.dart';
import '../../models/project_model.dart';

class AllProjectsScreen extends StatelessWidget {
  final String? category;
  const AllProjectsScreen({super.key, this.category});

  Color get _accentColor => const Color(0xFF7C3AED);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = Responsive.isMobile(context);
    final isTablet = Responsive.isTablet(context);
    final hPad = isMobile ? 20.0 : isTablet ? 40.0 : 100.0;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF080B14) : const Color(0xFFF7F8FC),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: PortfolioService().getProjects(category: category),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final raw = snap.data ?? [];
          final projects = raw
              .map(
                (p) => Project(
                  title: p['title'] ?? '',
                  description: p['description'] ?? '',
                  technologies: List<String>.from(p['technologies'] ?? []),
                  imagePath: p['imagePath'] ?? 'assets/img/placeholder.png',
                  category: p['category'] ?? 'Mobile',
                  githubLink: p['githubLink'],
                  apkLink: p['apkLink'],
                  videoLink: p['videoLink'],
                  badge: p['badge'],
                ),
              )
              .toList();

          return CustomScrollView(
            slivers: [
              // ── App Bar ───────────────────────────────
              SliverAppBar(
                pinned: true,
                backgroundColor: isDark
                    ? const Color(0xFF080B14).withOpacity(0.95)
                    : const Color(0xFFF7F8FC).withOpacity(0.95),
                elevation: 0,
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back_rounded,
                    color: isDark ? Colors.white : const Color(0xFF0D1117),
                    size: 24,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                title: Text(
                  category != null ? '$category Projects' : 'All Projects',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : const Color(0xFF0D1117),
                    letterSpacing: -0.5,
                  ),
                ),
                centerTitle: true,
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          color: _accentColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: _accentColor.withOpacity(0.25),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          '${projects.length} projects',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: _accentColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // ── Grid ─────────────────────────────────
              SliverPadding(
                padding: EdgeInsets.symmetric(
                  horizontal: hPad,
                  vertical: 32,
                ),
                sliver: projects.isEmpty
                    ? SliverToBoxAdapter(
                        child: _EmptyState(
                          isDark: isDark,
                          category: category ?? 'Projects',
                        ),
                      )
                    : isMobile
                        ? _MobileList(
                            projects: projects,
                            isDark: isDark,
                            accentColor: _accentColor,
                          )
                        : _DesktopGrid(
                            projects: projects,
                            isDark: isDark,
                            accentColor: _accentColor,
                            isTablet: isTablet,
                          ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 60)),
            ],
          );
        },
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
//  Mobile — vertical list
// ═══════════════════════════════════════════════════════════
class _MobileList extends StatelessWidget {
  final List<Project> projects;
  final bool isDark;
  final Color accentColor;
  const _MobileList({
    required this.projects,
    required this.isDark,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (_, i) => Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: TweenAnimationBuilder<double>(
            duration: Duration(milliseconds: 400 + i * 80),
            tween: Tween(begin: 0, end: 1),
            curve: Curves.easeOutCubic,
            builder: (_, v, child) => Transform.translate(
              offset: Offset(0, 24 * (1 - v)),
              child: Opacity(opacity: v, child: child),
            ),
            child: _ProjectCard(
              project: projects[i],
              isDark: isDark,
              accentColor: accentColor,
              index: i,
            ),
          ),
        ),
        childCount: projects.length,
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
//  Desktop — wrap grid
// ═══════════════════════════════════════════════════════════
class _DesktopGrid extends StatelessWidget {
  final List<Project> projects;
  final bool isDark, isTablet;
  final Color accentColor;
  const _DesktopGrid({
    required this.projects,
    required this.isDark,
    required this.accentColor,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final cols = isTablet ? 2 : 3;
    final hPad = isTablet ? 80.0 : 200.0;
    const spacing = 24.0;
    final cardW = ((width - hPad) - (cols - 1) * spacing) / cols;

    return SliverToBoxAdapter(
      child: Wrap(
        spacing: spacing,
        runSpacing: 24,
        alignment: WrapAlignment.start,
        children: projects.asMap().entries.map((e) {
          return TweenAnimationBuilder<double>(
            duration: Duration(milliseconds: 400 + e.key * 80),
            tween: Tween(begin: 0, end: 1),
            curve: Curves.easeOutCubic,
            builder: (_, v, child) => Transform.translate(
              offset: Offset(0, 28 * (1 - v)),
              child: Opacity(opacity: v, child: child),
            ),
            child: SizedBox(
              width: cardW.clamp(280.0, 500.0),
              child: _ProjectCard(
                project: e.value,
                isDark: isDark,
                accentColor: accentColor,
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
//  Project Card — identical to projects_section.dart
// ═══════════════════════════════════════════════════════════
class _ProjectCard extends StatefulWidget {
  final Project project;
  final bool isDark;
  final Color accentColor;
  final int index;

  const _ProjectCard({
    required this.project,
    required this.isDark,
    required this.accentColor,
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
    _hoverAnim =
        CurvedAnimation(parent: _hoverCtrl, curve: Curves.easeOutCubic);
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

  void _showFullDescription(BuildContext context) {
    final p = widget.project;
    final isDark = widget.isDark;
    final accent = widget.accentColor;

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
            Text(
              p.title,
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
            Flexible(
              child: SingleChildScrollView(
                child: Text(
                  p.description,
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
                _CardImage(
                  project: p,
                  accentColor: accent,
                  hovered: _hovered,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(22, 20, 22, 22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title + index number
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

                      // Description + read more
                      GestureDetector(
                        onTap: () => _showFullDescription(context),
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
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 6),
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

                      // Action buttons
                      _CardActions(
                        project: p,
                        accentColor: accent,
                        isDark: isDark,
                        outerContext: context,
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
    return SizedBox(
      height: 260,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(20)),
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
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.55),
                  ],
                ),
              ),
            ),
          ),
          // Category chip — bottom left
          Positioned(
            bottom: 12,
            left: 14,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
          padding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: _color.withOpacity(0.85),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.white.withOpacity(0.20),
              width: 1,
            ),
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
        if (btns.length > 1) ...[
          const SizedBox(width: 8),
          ...btns.skip(1).map(
                (b) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: _ActionButton(
                    icon: b.icon,
                    label: b.label,
                    url: b.url,
                    isPrimary: false,
                    iconOnly: true,
                    accentColor: accentColor,
                    isDark: isDark,
                    outerContext: outerContext,
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
  final bool isPrimary, isDark, iconOnly;
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
          height: 48,
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
                  size: 16,
                  color: _hovered ? Colors.white : accent,
                ),
                const SizedBox(width: 6),
                Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: 13,
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
      ScaffoldMessenger.of(widget.outerContext).showSnackBar(
        const SnackBar(content: Text('🎬 Coming soon!')),
      );
      return;
    }
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(widget.outerContext).showSnackBar(
        const SnackBar(content: Text('Could not open link')),
      );
    }
  }
}

// ═══════════════════════════════════════════════════════════
//  Empty State
// ═══════════════════════════════════════════════════════════
class _EmptyState extends StatelessWidget {
  final bool isDark;
  final String category;
  const _EmptyState({required this.isDark, required this.category});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 80),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.06),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Colors.white.withOpacity(0.10),
                width: 1.5,
              ),
            ),
            child: const Center(
              child: Text('📂', style: TextStyle(fontSize: 36)),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'No $category projects yet',
            style: TextStyle(
              fontSize: 18,
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