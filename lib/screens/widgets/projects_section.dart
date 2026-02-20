// import 'package:flutter/material.dart';
// import 'package:taha_portfolio/screens/widgets/all_projects_screen.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'dart:ui';
// import '../../core/theme/app_theme.dart';
// import '../../core/utils/responsive.dart';
// import '../../models/project_model.dart';

// class ProjectsSection extends StatelessWidget {
//   const ProjectsSection({super.key});

//   @override
//   @override
// Widget build(BuildContext context) {
//   final projects = Project.getProjects();
//   final isDark = Theme.of(context).brightness == Brightness.dark;

//   // أول 4 بس
//   final displayedProjects = projects.take(4).toList();

//   final width = MediaQuery.of(context).size.width;

//   // نحدد كم كارت في الصف على حسب العرض
//   int crossAxisCount;
//   if (width >= 1200) {
//     crossAxisCount = 2; // Desktop كبير: صفين × 2
//   } else if (width >= 800) {
//     crossAxisCount = 2; // Tablet / لابتوب صغير
//   } else {
//     crossAxisCount = 1; // موبايل
//   }

//   final cardWidth = (width -
//           (Responsive.isMobile(context)
//               ? 40
//               : Responsive.isTablet(context)
//                   ? 80
//                   : 200) -
//           (crossAxisCount - 1) * 30) /
//       crossAxisCount;

//   return Container(
//     width: double.infinity,
//     decoration: BoxDecoration(
//       color: isDark ? AppTheme.darkSurface : Colors.white,
//     ),
//     padding: EdgeInsets.symmetric(
//       horizontal: Responsive.isMobile(context)
//           ? 20
//           : Responsive.isTablet(context)
//               ? 40
//               : 100,
//       vertical: Responsive.isMobile(context) ? 80 : 120,
//     ),
//     child: Column(
//       children: [
//         _buildSectionTitle('Featured Projects', isDark),
//         const SizedBox(height: 50),

//         // ======= الكروت المنسقة =======
//         ConstrainedBox(
//           constraints: const BoxConstraints(maxWidth: 1300),
//           child: Wrap(
//             spacing: 30,
//             runSpacing: 40, // مسافة رأسية أكبر
//             alignment: WrapAlignment.center,
//             children: displayedProjects.asMap().entries.map((entry) {
//               final project = entry.value;
//               return TweenAnimationBuilder(
//                 duration: Duration(milliseconds: 600 + (entry.key * 120)),
//                 tween: Tween<double>(begin: 0, end: 1),
//                 curve: Curves.easeOutCubic,
//                 builder: (context, double value, child) {
//                   return Transform.translate(
//                     offset: Offset(0, 40 * (1 - value)),
//                     child: Opacity(
//                       opacity: value,
//                       child: SizedBox(
//                         width: cardWidth.clamp(320, 420), // يخلي كل كارت ثابت
//                         child: _buildProjectCard(project, context, isDark),
//                       ),
//                     ),
//                   );
//                 },
//               );
//             }).toList(),
//           ),
//         ),

//         const SizedBox(height: 45),
//         if (projects.length > 4) _buildViewAllButton(context, isDark),
//       ],
//     ),
//   );
// }

//   Widget _buildSectionTitle(String title, bool isDark) {
//     return Column(
//       children: [
//         Text(
//           title,
//           style: TextStyle(
//             fontSize: 48,
//             fontWeight: FontWeight.w900,
//             color: isDark ? AppTheme.darkText : AppTheme.lightText,
//             letterSpacing: -1,
//           ),
//         ),
//         const SizedBox(height: 15),
//         Container(
//           width: 80,
//           height: 5,
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [
//                 isDark ? AppTheme.darkPrimary : AppTheme.lightPrimary,
//                 isDark ? AppTheme.darkAccent : AppTheme.lightAccent,
//               ],
//             ),
//             borderRadius: BorderRadius.circular(10),
//             boxShadow: [
//               BoxShadow(
//                 color: (isDark ? AppTheme.darkPrimary : AppTheme.lightPrimary)
//                     .withOpacity(0.4),
//                 blurRadius: 15,
//                 spreadRadius: 2,
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildViewAllButton(BuildContext context, bool isDark) {
//     return TweenAnimationBuilder(
//       duration: const Duration(milliseconds: 700),
//       tween: Tween<double>(begin: 0, end: 1),
//       curve: Curves.easeOutCubic,
//       builder: (context, double value, child) {
//         return Transform.scale(
//           scale: value,
//           child: Opacity(
//             opacity: value,
//             child: MouseRegion(
//               cursor: SystemMouseCursors.click,
//               child: GestureDetector(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (_) => const AllProjectsScreen(),
//                     ),
//                   );
//                 },
//                 child: Container(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 36, vertical: 14),
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [
//                         isDark ? AppTheme.darkPrimary : AppTheme.lightPrimary,
//                         isDark ? AppTheme.darkAccent : AppTheme.lightAccent,
//                       ],
//                     ),
//                     borderRadius: BorderRadius.circular(30),
//                     boxShadow: [
//                       BoxShadow(
//                         color:
//                             (isDark ? AppTheme.darkPrimary : AppTheme.lightPrimary)
//                                 .withOpacity(0.4),
//                         blurRadius: 20,
//                         offset: const Offset(0, 10),
//                         spreadRadius: 2,
//                       ),
//                     ],
//                   ),
//                   child: const Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Text(
//                         'عرض جميع المشاريع',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 16,
//                           fontWeight: FontWeight.w700,
//                           letterSpacing: 0.5,
//                         ),
//                       ),
//                       SizedBox(width: 10),
//                       Icon(
//                         Icons.arrow_forward_rounded,
//                         color: Colors.white,
//                         size: 22,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   // باقي الكود بتاعك زي ما هو (من أول _buildProjectCard لحد _launchURL)
//   // انسخه كما هو من الرسالة الأولى بدون تغيير
//   Widget _buildProjectCard(Project project, BuildContext context, bool isDark) {
//     final isMobile = Responsive.isMobile(context);
//     final cardWidth = isMobile ? double.infinity : 380.0;

//     return MouseRegion(
//       cursor: SystemMouseCursors.click,
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(25),
//         child: BackdropFilter(
//           filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//           child: Container(
//             width: cardWidth,
//             decoration: BoxDecoration(
//               gradient: isDark
//                   ? LinearGradient(
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                       colors: [
//                         AppTheme.darkCard.withOpacity(0.9),
//                         AppTheme.darkCard.withOpacity(0.7),
//                       ],
//                     )
//                   : LinearGradient(
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                       colors: [Colors.white, Colors.white.withOpacity(0.95)],
//                     ),
//               borderRadius: BorderRadius.circular(25),
//               border: Border.all(
//                 color: isDark
//                     ? AppTheme.darkPrimary.withOpacity(0.3)
//                     : AppTheme.lightPrimary.withOpacity(0.2),
//                 width: 2,
//               ),
//               boxShadow: [
//                 BoxShadow(
//                   color: isDark
//                       ? Colors.black.withOpacity(0.4)
//                       : Colors.black.withOpacity(0.1),
//                   blurRadius: 30,
//                   offset: const Offset(0, 15),
//                   spreadRadius: 5,
//                 ),
//               ],
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // نفس كود الصورة والبادج من عندك...
//                 Container(
//                   height: 220,
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                       colors: [
//                         (isDark
//                                 ? AppTheme.darkPrimary
//                                 : AppTheme.lightPrimary)
//                             .withOpacity(0.3),
//                         (isDark
//                                 ? AppTheme.darkAccent
//                                 : AppTheme.lightAccent)
//                             .withOpacity(0.2),
//                       ],
//                     ),
//                   ),
//                   child: Stack(
//                     alignment: Alignment.center,
//                     children: [
//                       ClipRRect(
//                         borderRadius: const BorderRadius.vertical(
//                           top: Radius.circular(25),
//                         ),
//                         child: Image.asset(
//                           project.imagePath,
//                           height: 220,
//                           width: double.infinity,
//                           fit: BoxFit.cover,
//                           errorBuilder: (context, error, stackTrace) {
//                             return Icon(
//                               Icons.phone_iphone_rounded,
//                               size: 100,
//                               color: Colors.white.withOpacity(0.3),
//                             );
//                           },
//                         ),
//                       ),
//                       if (project.badge != null)
//                         Positioned(
//                           top: 15,
//                           right: 15,
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 14,
//                               vertical: 8,
//                             ),
//                             decoration: BoxDecoration(
//                               gradient: _getBadgeGradient(project.badge!),
//                               borderRadius: BorderRadius.circular(20),
//                               border: Border.all(
//                                 color: Colors.white.withOpacity(0.3),
//                                 width: 1.5,
//                               ),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: _getBadgeColor(
//                                     project.badge!,
//                                   ).withOpacity(0.5),
//                                   blurRadius: 15,
//                                   spreadRadius: 2,
//                                 ),
//                               ],
//                             ),
//                             child: Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 Icon(
//                                   _getBadgeIcon(project.badge!),
//                                   size: 14,
//                                   color: Colors.white,
//                                 ),
//                                 const SizedBox(width: 6),
//                                 Text(
//                                   project.badge!,
//                                   style: const TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 12,
//                                     fontWeight: FontWeight.bold,
//                                     letterSpacing: 0.5,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(25),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         project.title,
//                         style: TextStyle(
//                           fontSize: 24,
//                           fontWeight: FontWeight.w800,
//                           color: isDark
//                               ? AppTheme.darkText
//                               : AppTheme.lightText,
//                           letterSpacing: -0.5,
//                         ),
//                       ),
//                       const SizedBox(height: 15),
//                       Text(
//                         project.description,
//                         style: TextStyle(
//                           fontSize: 15,
//                           color: isDark
//                               ? AppTheme.darkTextSecondary
//                               : AppTheme.lightTextSecondary,
//                           height: 1.6,
//                         ),
//                         maxLines: 4,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       const SizedBox(height: 20),
//                       Wrap(
//                         spacing: 8,
//                         runSpacing: 8,
//                         children: project.technologies.map((tech) {
//                           return Container(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 14,
//                               vertical: 8,
//                             ),
//                             decoration: BoxDecoration(
//                               gradient: LinearGradient(
//                                 colors: [
//                                   (isDark
//                                           ? AppTheme.darkPrimary
//                                           : AppTheme.lightPrimary)
//                                       .withOpacity(0.2),
//                                   (isDark
//                                           ? AppTheme.darkAccent
//                                           : AppTheme.lightAccent)
//                                       .withOpacity(0.1),
//                                 ],
//                               ),
//                               borderRadius: BorderRadius.circular(20),
//                               border: Border.all(
//                                 color: isDark
//                                     ? AppTheme.darkPrimary.withOpacity(0.4)
//                                     : AppTheme.lightPrimary.withOpacity(0.3),
//                                 width: 1,
//                               ),
//                             ),
//                             child: Text(
//                               tech,
//                               style: TextStyle(
//                                 fontSize: 13,
//                                 color: isDark
//                                     ? AppTheme.darkPrimary
//                                     : AppTheme.lightPrimary,
//                                 fontWeight: FontWeight.w700,
//                                 letterSpacing: 0.3,
//                               ),
//                             ),
//                           );
//                         }).toList(),
//                       ),
//                       const SizedBox(height: 25),
//                       Row(
//                         children: [
//                           if (project.githubLink != null)
//                             Expanded(
//                               child: _buildActionButton(
//                                 'GitHub',
//                                 Icons.code_rounded,
//                                 project.githubLink!,
//                                 isDark,
//                                 project.title,
//                                 context,
//                               ),
//                             ),
//                           if (project.githubLink != null &&
//                               project.apkLink != null)
//                             const SizedBox(width: 10),
//                           if (project.apkLink != null)
//                             Expanded(
//                               child: _buildActionButton(
//                                 'APK',
//                                 Icons.android_rounded,
//                                 project.apkLink!,
//                                 isDark,
//                                 project.title,
//                                 context,
//                               ),
//                             ),
//                         ],
//                       ),
//                       if (project.videoLink != null &&
//                           project.videoLink!.trim().isNotEmpty) ...[
//                         const SizedBox(height: 10),
//                         SizedBox(
//                           width: double.infinity,
//                           child: _buildActionButton(
//                             'Watch Demo',
//                             Icons.play_circle_rounded,
//                             project.videoLink!,
//                             isDark,
//                             project.title,
//                             context,
//                           ),
//                         ),
//                       ],
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   LinearGradient _getBadgeGradient(String badge) { /* نفس الكود */ 
//     switch (badge.toLowerCase()) {
//       case 'featured':
//         return const LinearGradient(
//           colors: [Color(0xFFFF6B6B), Color(0xFFEE5A6F)],
//         );
//       case 'offline':
//         return const LinearGradient(
//           colors: [Color(0xFF4A90E2), Color(0xFF357ABD)],
//         );
//       case 'cloud':
//         return const LinearGradient(
//           colors: [Color(0xFF00C851), Color(0xFF007E33)],
//         );
//       default:
//         return const LinearGradient(
//           colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
//         );
//     }
//   }

//   Color _getBadgeColor(String badge) { /* نفس الكود */ 
//     switch (badge.toLowerCase()) {
//       case 'featured':
//         return const Color(0xFFFF6B6B);
//       case 'offline':
//         return const Color(0xFF4A90E2);
//       case 'cloud':
//         return const Color(0xFF00C851);
//       default:
//         return const Color(0xFF667EEA);
//     }
//   }

//   IconData _getBadgeIcon(String badge) { /* نفس الكود */ 
//     switch (badge.toLowerCase()) {
//       case 'featured':
//         return Icons.star_rounded;
//       case 'offline':
//         return Icons.storage_rounded;
//       case 'cloud':
//         return Icons.cloud_rounded;
//       default:
//         return Icons.label_rounded;
//     }
//   }

//   Widget _buildActionButton(
//     String label,
//     IconData icon,
//     String url,
//     bool isDark,
//     String projectTitle,
//     BuildContext context,
//   ) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(12),
//       child: BackdropFilter(
//         filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
//         child: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [
//                 (isDark ? AppTheme.darkPrimary : AppTheme.lightPrimary)
//                     .withOpacity(0.9),
//                 (isDark ? AppTheme.darkAccent : AppTheme.lightAccent)
//                     .withOpacity(0.8),
//               ],
//             ),
//             borderRadius: BorderRadius.circular(12),
//             boxShadow: [
//               BoxShadow(
//                 color: (isDark ? AppTheme.darkPrimary : AppTheme.lightPrimary)
//                     .withOpacity(0.4),
//                 blurRadius: 15,
//                 offset: const Offset(0, 5),
//               ),
//             ],
//           ),
//           child: Material(
//             color: Colors.transparent,
//             child: InkWell(
//               onTap: () => _launchURL(url, projectTitle, context),
//               borderRadius: BorderRadius.circular(12),
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 14),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(icon, color: Colors.white, size: 20),
//                     const SizedBox(width: 8),
//                     Text(
//                       label,
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 15,
//                         fontWeight: FontWeight.w700,
//                         letterSpacing: 0.5,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> _launchURL(
//     String url,
//     String projectTitle,
//     BuildContext context,
//   ) async {
//     if (projectTitle == 'Management Stocks (Cloud)' &&
//         (url.isEmpty || url.trim().isEmpty)) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('🎬 سيتم إضافة الفيديو قريبًا!'),
//           duration: Duration(seconds: 2),
//         ),
//       );
//       return;
//     }

//     final Uri uri = Uri.parse(url);
//     if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
//       throw Exception('Could not launch $url');
//     }
//   }
// }



import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:ui';
import '../../core/theme/app_theme.dart';
import '../../core/utils/responsive.dart';
import '../../models/project_model.dart';
import 'all_projects_screen.dart';

class ProjectsSection extends StatefulWidget {
  const ProjectsSection({super.key});

  @override
  State<ProjectsSection> createState() => _ProjectsSectionState();
}

class _ProjectsSectionState extends State<ProjectsSection>
    with SingleTickerProviderStateMixin {
  int _selectedTab = 0;
  late AnimationController _fadeCtrl;
  late Animation<double> _fadeAnim;

  List<_TabMeta> _tabs(bool isDark) => [
  _TabMeta('📱', 'Mobile',
      isDark ? AppTheme.darkPrimary : AppTheme.lightPrimary),
  _TabMeta('🌐', 'Web',
      isDark ? AppTheme.darkAccent : AppTheme.lightAccent),
  _TabMeta('⚙️', 'Desktop',
      isDark ? AppTheme.darkSecondary : AppTheme.lightSecondary),
];


  /// ─── Replace these with your actual data sources ────────
  /// Project.getMobileProjects() / getWebProjects() / getBackendProjects()
  /// For now we fall back to the existing getProjects() for Mobile
  List<Project> get _currentProjects {
    switch (_selectedTab) {
      case 0: return Project.getMobileProjects();
      case 1: return Project.getWebProjects();
      case 2: return Project.getBackendProjects();
      default: return [];
    }
  }

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _fadeCtrl.forward();
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
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
    final hPad = isMobile ? 20.0 : Responsive.isTablet(context) ? 40.0 : 100.0;
    final tabs = _tabs(isDark);
    final projects = _currentProjects;
    final displayed = projects.take(4).toList();

    return Container(
      width: double.infinity,
      color: isDark ? AppTheme.darkSurface : Colors.white,
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: isMobile ? 70 : 120),
      child: Column(
        children: [
          // ── Section Title ────────────────────────────
          _SectionTitle(isDark: isDark, isMobile: isMobile),
          SizedBox(height: isMobile ? 32 : 44),

          // ── Tab Switcher ─────────────────────────────
          _ProjectTabBar(
            tabs: tabs,
            selected: _selectedTab,
            isDark: isDark,
            isMobile: isMobile,
            onTap: _switchTab,
          ),
          SizedBox(height: isMobile ? 28 : 44),

          // ── Projects Grid / Scroll ────────────────────
          FadeTransition(
            opacity: _fadeAnim,
            child: displayed.isEmpty
                ? _EmptyState(tab: tabs[_selectedTab], isDark: isDark)
                : isMobile
                    ? _MobileScroll(
                        projects: displayed,
                        isDark: isDark,
                        accentColor:tabs[_selectedTab].color
,
                        context: context,
                      )
                    : _DesktopGrid(
                        projects: displayed,
                        isDark: isDark,
                        accentColor:tabs[_selectedTab].color
,
                        context: context,
                      ),
          ),

          const SizedBox(height: 45),

          // ── View All ─────────────────────────────────
          if (projects.length > 4)
            _ViewAllButton(context: context),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
//  Section Title
// ═══════════════════════════════════════════════════════════
class _SectionTitle extends StatelessWidget {
  final bool isDark, isMobile;
  const _SectionTitle({required this.isDark, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Our Work',
          style: TextStyle(
            fontSize: isMobile ? 32 : 48,
            fontWeight: FontWeight.w900,
            color: isDark ? AppTheme.darkText : AppTheme.lightText,
            letterSpacing: -1,
          ),
        ),
        const SizedBox(height: 14),
        Container(
          width: 72,
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
                blurRadius: 14,
                spreadRadius: 1,
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Text(
          'A selection of projects we\'ve built with dedication and precision.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: isMobile ? 13 : 15,
            color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
            height: 1.6,
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════
//  Tab Bar
// ═══════════════════════════════════════════════════════════
class _ProjectTabBar extends StatelessWidget {
  final List<_TabMeta> tabs;
  final int selected;
  final bool isDark, isMobile;
  final Future<void> Function(int) onTap;

  const _ProjectTabBar({
    required this.tabs,
    required this.selected,
    required this.isDark,
    required this.isMobile,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: isDark
            ? AppTheme.darkCard.withOpacity(0.6)
            : Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.07)
              : Colors.black.withOpacity(0.06),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.06),
            blurRadius: 18,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: tabs.asMap().entries.map((e) {
          final isActive = selected == e.key;
          return GestureDetector(
            onTap: () => onTap(e.key),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeInOut,
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 14 : 22,
                vertical: isMobile ? 10 : 12,
              ),
              decoration: BoxDecoration(
                gradient: isActive
                    ? LinearGradient(
                        colors: [e.value.color, e.value.color.withOpacity(0.75)],
                      )
                    : null,
                borderRadius: BorderRadius.circular(14),
                boxShadow: isActive
                    ? [
                        BoxShadow(
                          color: e.value.color.withOpacity(0.35),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(e.value.emoji, style: TextStyle(fontSize: isMobile ? 15 : 17)),
                  SizedBox(width: isMobile ? 5 : 7),
                  Text(
                    e.value.label,
                    style: TextStyle(
                      fontSize: isMobile ? 12 : 13,
                      fontWeight: FontWeight.w700,
                      color: isActive
                          ? Colors.white
                          : (isDark
                              ? AppTheme.darkTextSecondary
                              : AppTheme.lightTextSecondary),
                    ),
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
//  Empty State
// ═══════════════════════════════════════════════════════════
class _EmptyState extends StatelessWidget {
  final _TabMeta tab;
  final bool isDark;
  const _EmptyState({required this.tab, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: [
          Text(tab.emoji, style: const TextStyle(fontSize: 48)),
          const SizedBox(height: 16),
          Text(
            'No ${tab.label} projects yet',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Check back soon — we\'re always building.',
            style: TextStyle(
              fontSize: 13,
              color: isDark
                  ? AppTheme.darkTextSecondary.withOpacity(0.6)
                  : AppTheme.lightTextSecondary.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
//  Mobile Horizontal Scroll
// ═══════════════════════════════════════════════════════════
class _MobileScroll extends StatelessWidget {
  final List<Project> projects;
  final bool isDark;
  final Color accentColor;
  final BuildContext context;

  const _MobileScroll({
    required this.projects,
    required this.isDark,
    required this.accentColor,
    required this.context,
  });

  @override
  Widget build(BuildContext _) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.swipe_rounded,
              size: 15,
              color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
            ),
            const SizedBox(width: 5),
            Text(
              'Swipe to explore',
              style: TextStyle(
                fontSize: 12,
                color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 520,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
            itemCount: projects.length,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (_, i) => TweenAnimationBuilder<double>(
              duration: Duration(milliseconds: 350 + i * 80),
              tween: Tween(begin: 0, end: 1),
              curve: Curves.easeOutCubic,
              builder: (_, v, child) => Transform.translate(
                offset: Offset(20 * (1 - v), 0),
                child: Opacity(opacity: v, child: child),
              ),
              child: SizedBox(
                width: 300,
                child: _ProjectCard(
                  project: projects[i],
                  isDark: isDark,
                  accentColor: accentColor,
                  outerContext: context,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════
//  Desktop Grid
// ═══════════════════════════════════════════════════════════
class _DesktopGrid extends StatelessWidget {
  final List<Project> projects;
  final bool isDark;
  final Color accentColor;
  final BuildContext context;

  const _DesktopGrid({
    required this.projects,
    required this.isDark,
    required this.accentColor,
    required this.context,
  });

  @override
  Widget build(BuildContext _) {
    final width = MediaQuery.of(context).size.width;
    final cols = width >= 1100 ? 2 : 2;
    final padding = width >= 1100 ? 200.0 : 80.0;
    final cardW = ((width - padding) - (cols - 1) * 30) / cols;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 1300),
      child: Wrap(
        spacing: 30,
        runSpacing: 32,
        alignment: WrapAlignment.center,
        children: projects.asMap().entries.map((e) {
          return TweenAnimationBuilder<double>(
            duration: Duration(milliseconds: 500 + e.key * 100),
            tween: Tween(begin: 0, end: 1),
            curve: Curves.easeOutCubic,
            builder: (_, v, child) => Transform.translate(
              offset: Offset(0, 30 * (1 - v)),
              child: Opacity(opacity: v, child: child),
            ),
            child: SizedBox(
              width: cardW.clamp(300.0, 440.0),
              child: _ProjectCard(
                project: e.value,
                isDark: isDark,
                accentColor: accentColor,
                outerContext: context,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
//  Project Card
// ═══════════════════════════════════════════════════════════
class _ProjectCard extends StatefulWidget {
  final Project project;
  final bool isDark;
  final Color accentColor;
  final BuildContext outerContext;

  const _ProjectCard({
    required this.project,
    required this.isDark,
    required this.accentColor,
    required this.outerContext,
  });

  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final p = widget.project;
    final isDark = widget.isDark;
    final accent = widget.accentColor;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.translationValues(0, _hovered ? -5 : 0, 0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                gradient: isDark
                    ? LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppTheme.darkCard.withOpacity(_hovered ? 1.0 : 0.9),
                          AppTheme.darkCard.withOpacity(0.7),
                        ],
                      )
                    : const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.white, Colors.white],
                      ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: _hovered
                      ? accent.withOpacity(0.5)
                      : (isDark
                          ? Colors.white.withOpacity(0.07)
                          : Colors.black.withOpacity(0.07)),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: _hovered
                        ? accent.withOpacity(0.2)
                        : Colors.black.withOpacity(isDark ? 0.35 : 0.07),
                    blurRadius: _hovered ? 32 : 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Image ────────────────────────────
                  _ProjectImage(project: p, accentColor: accent),

                  // ── Content ──────────────────────────
                  Padding(
                    padding: const EdgeInsets.all(22),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          p.title,
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w800,
                            color: isDark ? AppTheme.darkText : AppTheme.lightText,
                            letterSpacing: -0.4,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          p.description,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark
                                ? AppTheme.darkTextSecondary
                                : AppTheme.lightTextSecondary,
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Tech chips
                        SizedBox(
                          height: 30,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: p.technologies.length,
                            separatorBuilder: (_, __) => const SizedBox(width: 6),
                            itemBuilder: (_, i) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    accent.withOpacity(0.14),
                                    accent.withOpacity(0.06),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: accent.withOpacity(0.28), width: 1,
                                ),
                              ),
                              child: Text(
                                p.technologies[i],
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: isDark
                                      ? AppTheme.darkPrimary
                                      : AppTheme.lightSecondary,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 18),

                        // Action buttons
                        _ActionButtons(
                          project: p,
                          accentColor: accent,
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
      ),
    );
  }
}

// ─── Project Image ───────────────────────────────────────
class _ProjectImage extends StatelessWidget {
  final Project project;
  final Color accentColor;
  const _ProjectImage({required this.project, required this.accentColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            child: Image.asset(
              project.imagePath,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      accentColor.withOpacity(0.25),
                      accentColor.withOpacity(0.15),
                    ],
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.code_rounded,
                    size: 60,
                    color: accentColor.withOpacity(0.4),
                  ),
                ),
              ),
            ),
          ),
          // Category badge
          Positioned(
            top: 12, left: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.55),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                project.category,
                style: const TextStyle(
                  color: Colors.white, fontSize: 11,
                  fontWeight: FontWeight.w700, letterSpacing: 0.4,
                ),
              ),
            ),
          ),
          // Optional badge
          if (project.badge != null)
            Positioned(
              top: 12, right: 12,
              child: _Badge(badge: project.badge!),
            ),
        ],
      ),
    );
  }
}

// ─── Badge ───────────────────────────────────────────────
class _Badge extends StatelessWidget {
  final String badge;
  const _Badge({required this.badge});

  @override
  Widget build(BuildContext context) {
    final color = switch (badge.toLowerCase()) {
      'featured' => const Color(0xFFFF6B6B),
      'offline'  => const Color(0xFF4A90E2),
      'cloud'    => const Color(0xFF00C851),
      _          => const Color(0xFF7B2FFF),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.9),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: color.withOpacity(0.45), blurRadius: 10)],
      ),
      child: Text(
        badge,
        style: const TextStyle(
          color: Colors.white, fontSize: 11,
          fontWeight: FontWeight.w800, letterSpacing: 0.4,
        ),
      ),
    );
  }
}

// ─── Action Buttons ──────────────────────────────────────
class _ActionButtons extends StatelessWidget {
  final Project project;
  final Color accentColor;
  final BuildContext outerContext;
  const _ActionButtons({
    required this.project,
    required this.accentColor,
    required this.outerContext,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        final btns = <({IconData icon, String label, String url})>[];
        if (project.githubLink != null)
          btns.add((icon: Icons.code_rounded, label: 'GitHub', url: project.githubLink!));
        if (project.apkLink != null)
          btns.add((icon: Icons.android_rounded, label: 'APK', url: project.apkLink!));
        if (project.videoLink != null && project.videoLink!.trim().isNotEmpty)
          btns.add((icon: Icons.play_arrow_rounded, label: 'Demo', url: project.videoLink!));

        if (btns.isEmpty) return const SizedBox();

        final btnW = (constraints.maxWidth - (btns.length - 1) * 10) / btns.length;
        return Wrap(
          spacing: 10,
          runSpacing: 10,
          children: btns.map((b) => SizedBox(
            width: btnW,
            height: 40,
            child: _ActionBtn(
              icon: b.icon,
              label: b.label,
              url: b.url,
              accentColor: accentColor,
              outerContext: outerContext,
            ),
          )).toList(),
        );
      },
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final String label, url;
  final Color accentColor;
  final BuildContext outerContext;
  const _ActionBtn({
    required this.icon,
    required this.label,
    required this.url,
    required this.accentColor,
    required this.outerContext,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [accentColor, accentColor.withOpacity(0.75)],
        ),
        borderRadius: BorderRadius.circular(11),
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(0.28),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(11),
          onTap: () => _launch(url),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 15),
              const SizedBox(width: 5),
              Text(label,
                  style: const TextStyle(
                    color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700,
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(outerContext)
          .showSnackBar(const SnackBar(content: Text('Could not open link')));
    }
  }
}

// ─── View All Button ─────────────────────────────────────
class _ViewAllButton extends StatelessWidget {
  final BuildContext context;
  const _ViewAllButton({required this.context});

  @override
  Widget build(BuildContext _) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const AllProjectsScreen()),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 34, vertical: 15),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppTheme.lightPrimary,
              AppTheme.lightAccent,
            ],
          ),
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: AppTheme.lightPrimary.withOpacity(0.4),
              blurRadius: 22,
              offset: const Offset(0, 8),
              spreadRadius: 1,
            ),
          ],
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('View All Projects',
                style: TextStyle(
                  color: Colors.white, fontSize: 15,
                  fontWeight: FontWeight.w700, letterSpacing: 0.2,
                )),
            SizedBox(width: 9),
            Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
          ],
        ),
      ),
    );
  }
}

// ─── Tab Metadata ────────────────────────────────────────
class _TabMeta {
  final String emoji, label;
  final Color color;
  const _TabMeta(this.emoji, this.label, this.color);
}