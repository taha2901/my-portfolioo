// // استبدل السطر ده:
// // static const String cvLink = '...'
// // بـ StreamBuilder يقرأ من Firestore

// // في الـ build method، غيّر:
// import 'package:flutter/material.dart';
// import 'package:taha_portfolio/core/services/portfolio_service.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'dart:ui';
// import '../../core/theme/app_theme.dart';
// import '../../core/utils/responsive.dart';

// class CVSection extends StatelessWidget {
//   const CVSection({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     final isMobile = Responsive.isMobile(context);
//     final service = PortfolioService();

//     return StreamBuilder<Map<String, dynamic>>(
//       stream: service.getSettings(),
//       builder: (context, snap) {
//         final data = snap.data ?? {};
//         final cvLink = data['cvLink'] ?? '';

//         return Container(
//           width: double.infinity,
//           decoration: BoxDecoration(
//             gradient: isDark ? AppTheme.darkGradient : AppTheme.lightGradient,
//           ),
//           padding: EdgeInsets.symmetric(
//             horizontal: isMobile ? 20 : 60,
//             vertical: isMobile ? 50 : 70,
//           ),
//           child: Center(
//             child: ConstrainedBox(
//               constraints: BoxConstraints(
//                 maxWidth: isMobile ? double.infinity : 700,
//               ),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(25),
//                 child: BackdropFilter(
//                   filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//                   child: Container(
//                     padding: EdgeInsets.all(isMobile ? 30 : 45),
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                         colors: [
//                           Colors.white.withOpacity(0.2),
//                           Colors.white.withOpacity(0.1),
//                         ],
//                       ),
//                       borderRadius: BorderRadius.circular(25),
//                       border: Border.all(
//                           color: Colors.white.withOpacity(0.3), width: 2),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.2),
//                           blurRadius: 30,
//                           offset: const Offset(0, 15),
//                         ),
//                       ],
//                     ),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Container(
//                           padding: EdgeInsets.all(isMobile ? 18 : 22),
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             gradient: LinearGradient(colors: [
//                               Colors.white.withOpacity(0.3),
//                               Colors.white.withOpacity(0.2),
//                             ]),
//                             border: Border.all(
//                                 color: Colors.white.withOpacity(0.5),
//                                 width: 2.5),
//                           ),
//                           child: Icon(Icons.description_rounded,
//                               size: isMobile ? 50 : 60, color: Colors.white),
//                         ),
//                         SizedBox(height: isMobile ? 20 : 25),
//                         Text('Download My CV',
//                             style: TextStyle(
//                               fontSize: isMobile ? 26 : 34,
//                               fontWeight: FontWeight.w900,
//                               color: Colors.white,
//                               letterSpacing: -0.5,
//                             )),
//                         SizedBox(height: isMobile ? 10 : 12),
//                         Text(
//                           'Get a comprehensive overview of my skills,\nexperience, and education',
//                           style: TextStyle(
//                             fontSize: isMobile ? 13 : 15,
//                             color: Colors.white.withOpacity(0.9),
//                             height: 1.5,
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                         SizedBox(height: isMobile ? 25 : 30),
//                         MouseRegion(
//                           cursor: SystemMouseCursors.click,
//                           child: GestureDetector(
//                             onTap: cvLink.isNotEmpty
//                                 ? () => _launchURL(cvLink)
//                                 : null,
//                             child: Container(
//                               padding: EdgeInsets.symmetric(
//                                 horizontal: isMobile ? 32 : 40,
//                                 vertical: isMobile ? 14 : 16,
//                               ),
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.circular(25),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.white.withOpacity(0.3),
//                                     blurRadius: 20,
//                                     spreadRadius: 2,
//                                   ),
//                                 ],
//                               ),
//                               child: Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   Icon(Icons.download_rounded,
//                                       color: isDark
//                                           ? AppTheme.darkPrimary
//                                           : AppTheme.lightPrimary,
//                                       size: isMobile ? 22 : 24),
//                                   const SizedBox(width: 10),
//                                   Text('Download CV',
//                                       style: TextStyle(
//                                         color: isDark
//                                             ? AppTheme.darkPrimary
//                                             : AppTheme.lightPrimary,
//                                         fontSize: isMobile ? 15 : 17,
//                                         fontWeight: FontWeight.w800,
//                                       )),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                         SizedBox(height: isMobile ? 20 : 25),
//                         Wrap(
//                           spacing: 20,
//                           runSpacing: 15,
//                           alignment: WrapAlignment.center,
//                           children: [
//                             _stat('📄', 'PDF Format'),
//                             _stat('📱', 'Mobile Friendly'),
//                             _stat('⚡', 'Quick View'),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _stat(String emoji, String text) => Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Text(emoji, style: const TextStyle(fontSize: 26)),
//           const SizedBox(height: 6),
//           Text(text,
//               style: TextStyle(
//                 color: Colors.white.withOpacity(0.9),
//                 fontSize: 12,
//                 fontWeight: FontWeight.w600,
//               )),
//         ],
//       );

//   Future<void> _launchURL(String url) async {
//     final Uri uri = Uri.parse(url);
//     if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
//       throw Exception('Could not launch $url');
//     }
//   }
// }


import 'package:flutter/material.dart';
import 'package:taha_portfolio/core/services/portfolio_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:ui';
import '../../core/theme/app_theme.dart';
import '../../core/utils/responsive.dart';

// ═══════════════════════════════════════════════════════════
//  CV Section
// ═══════════════════════════════════════════════════════════
class CVSection extends StatefulWidget {
  const CVSection({super.key});

  @override
  State<CVSection> createState() => _CVSectionState();
}

class _CVSectionState extends State<CVSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic);
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = Responsive.isMobile(context);
    final isTablet = Responsive.isTablet(context);

    return StreamBuilder<Map<String, dynamic>>(
      stream: PortfolioService().getSettings(),
      builder: (context, snap) {
        final data = snap.data ?? {};
        final cvLink = data['cvLink'] ?? '';

        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: isDark ? AppTheme.darkGradient : AppTheme.lightGradient,
          ),
          child: Stack(
            children: [
              // Decorative circles
              Positioned(
                top: -60,
                right: -40,
                child: _DecorCircle(
                  size: 220,
                  color: Colors.white.withOpacity(0.06),
                ),
              ),
              Positioned(
                bottom: -40,
                left: -40,
                child: _DecorCircle(
                  size: 180,
                  color: Colors.white.withOpacity(0.05),
                ),
              ),
              Positioned(
                top: 40,
                left: 60,
                child: _DecorCircle(
                  size: 80,
                  color: Colors.white.withOpacity(0.04),
                ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 20 : isTablet ? 40 : 100,
                  vertical: isMobile ? 72 : 120,
                ),
                child: FadeTransition(
                  opacity: _anim,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.12),
                      end: Offset.zero,
                    ).animate(_anim),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,

                      children: [
                        // ── Header pill ──────────────────
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.30),
                              width: 1.5,
                            ),
                            color: Colors.white.withOpacity(0.10),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 7,
                                height: 7,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'MY RESUME',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 2.5,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: isMobile ? 20 : 28),

                        // ── Title ────────────────────────
                        Text(
                          isMobile
                              ? 'Download\nMy CV'
                              : 'Download My CV',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: isMobile ? 38 : isTablet ? 52 : 64,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            height: 1.08,
                            letterSpacing: -2,
                          ),
                        ),

                        SizedBox(height: isMobile ? 14 : 18),

                        // ── Subtitle ─────────────────────
                        ConstrainedBox(
                         constraints: const BoxConstraints(maxWidth: 680),
                          child: Text(
                            'Get a comprehensive overview of my skills, experience, and the projects I\'ve shipped.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: isMobile ? 13.5 : 15.5,
                              color: Colors.white.withOpacity(0.65),
                              height: 1.65,
                            ),
                          ),
                        ),

                        SizedBox(height: isMobile ? 36 : 48),

                        // ── Main Card ────────────────────
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 680),
                          child: _CVCard(
                            cvLink: cvLink,
                            isDark: isDark,
                            isMobile: isMobile,
                          ),
                        ),

                        SizedBox(height: isMobile ? 40 : 56),

                        // ── Stats row ────────────────────
                        Center(
                          child: Wrap(
                            spacing: isMobile ? 24 : 48,
                            runSpacing: 20,
                            alignment: WrapAlignment.center,
                            children: [
                              const _StatItem(emoji: '📄', label: 'PDF Format'),
                              _Divider(),
                              const _StatItem(emoji: '📱', label: 'Mobile Friendly'),
                              _Divider(),
                              const _StatItem(emoji: '⚡', label: 'Quick Download'),
                            ],
                          ),
                        ),
                      ],
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
}

// ═══════════════════════════════════════════════════════════
//  CV Card
// ═══════════════════════════════════════════════════════════
class _CVCard extends StatefulWidget {
  final String cvLink;
  final bool isDark, isMobile;
  const _CVCard({
    required this.cvLink,
    required this.isDark,
    required this.isMobile,
  });

  @override
  State<_CVCard> createState() => _CVCardState();
}

class _CVCardState extends State<_CVCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final hasLink = widget.cvLink.isNotEmpty;

    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(widget.isMobile ? 28 : 40),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.12),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: Colors.white.withOpacity(0.20),
              width: 1.5,
            ),
          ),
          child: Column(
            children: [
              // Icon
              Container(
                width: widget.isMobile ? 72 : 88,
                height: widget.isMobile ? 72 : 88,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.15),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.30),
                    width: 2,
                  ),
                ),
                child: Icon(
                  Icons.description_rounded,
                  size: widget.isMobile ? 36 : 44,
                  color: Colors.white,
                ),
              ),

              SizedBox(height: widget.isMobile ? 20 : 24),

              // Divider line
              Container(
                width: 48,
                height: 2,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              SizedBox(height: widget.isMobile ? 20 : 24),

              // Description
              Text(
                'My CV includes all my technical skills, work experience, education background, and featured projects.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: widget.isMobile ? 13 : 14.5,
                  color: Colors.white.withOpacity(0.70),
                  height: 1.6,
                ),
              ),

              SizedBox(height: widget.isMobile ? 28 : 36),

              // Download button
              MouseRegion(
                cursor: hasLink
                    ? SystemMouseCursors.click
                    : SystemMouseCursors.basic,
                onEnter: (_) => setState(() => _hovered = true),
                onExit: (_) => setState(() => _hovered = false),
                child: GestureDetector(
                  onTap: hasLink ? () => _launch(widget.cvLink) : null,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    transform:
                        Matrix4.translationValues(0, _hovered ? -3 : 0, 0),
                    padding: EdgeInsets.symmetric(
                      horizontal: widget.isMobile ? 32 : 44,
                      vertical: widget.isMobile ? 15 : 18,
                    ),
                    decoration: BoxDecoration(
                      color: _hovered ? Colors.white : Colors.white,
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: _hovered
                          ? [
                              BoxShadow(
                                color: Colors.white.withOpacity(0.35),
                                blurRadius: 28,
                                offset: const Offset(0, 8),
                              ),
                            ]
                          : [
                              BoxShadow(
                                color: Colors.white.withOpacity(0.18),
                                blurRadius: 16,
                                offset: const Offset(0, 4),
                              ),
                            ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.download_rounded,
                          size: widget.isMobile ? 20 : 22,
                          color: widget.isDark
                              ? AppTheme.darkPrimary
                              : AppTheme.lightPrimary,
                        ),
                        SizedBox(width: widget.isMobile ? 8 : 10),
                        Text(
                          hasLink ? 'Download CV' : 'Coming Soon',
                          style: TextStyle(
                            fontSize: widget.isMobile ? 15 : 17,
                            fontWeight: FontWeight.w800,
                            color: widget.isDark
                                ? AppTheme.darkPrimary
                                : AppTheme.lightPrimary,
                            letterSpacing: 0.2,
                          ),
                        ),
                        if (_hovered) ...[
                          SizedBox(width: widget.isMobile ? 8 : 10),
                          Icon(
                            Icons.arrow_downward_rounded,
                            size: 16,
                            color: widget.isDark
                                ? AppTheme.darkPrimary
                                : AppTheme.lightPrimary,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      // ignore
    }
  }
}

// ═══════════════════════════════════════════════════════════
//  Helpers
// ═══════════════════════════════════════════════════════════
class _DecorCircle extends StatelessWidget {
  final double size;
  final Color color;
  const _DecorCircle({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String emoji, label;
  const _StatItem({required this.emoji, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(emoji, style: const TextStyle(fontSize: 28)),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.white.withOpacity(0.70),
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 36,
      color: Colors.white.withOpacity(0.15),
    );
  }
}