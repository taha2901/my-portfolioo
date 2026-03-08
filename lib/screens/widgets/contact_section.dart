// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'dart:ui';
// import '../../core/theme/app_theme.dart';
// import '../../core/utils/responsive.dart';
// import '../../core/constants/app_constants.dart';

// class ContactSection extends StatelessWidget {
//   const ContactSection({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     return Container(
//       width: double.infinity,
//       decoration: BoxDecoration(
//         color: isDark ? AppTheme.darkBackground : AppTheme.lightBackground,
//       ),
//       padding: EdgeInsets.symmetric(
//         horizontal: Responsive.isMobile(context) ? 20 : Responsive.isTablet(context) ? 40 : 100,
//         vertical: Responsive.isMobile(context) ? 80 : 120,
//       ),
//       child: Column(
//         children: [
//           _buildSectionTitle('Get In Touch', isDark),
//           const SizedBox(height: 20),
//           Text(
//             'Feel free to reach out for collaborations or just a friendly chat',
//             style: TextStyle(
//               fontSize: Responsive.isMobile(context) ? 15 : 17,
//               color: isDark
//                   ? AppTheme.darkTextSecondary
//                   : AppTheme.lightTextSecondary,
//               height: 1.5,
//             ),
//             textAlign: TextAlign.center,
//           ),
//           const SizedBox(height: 60),
//           ConstrainedBox(
//             constraints: const BoxConstraints(maxWidth: 1000),
//             child: Responsive.isMobile(context)
//                 ? Column(
//                     children: [
//                       _buildContactCard(
//                         Icons.phone_rounded,
//                         'Phone',
//                         AppConstants.phone,
//                         'tel:${AppConstants.phone}',
//                         context,
//                         isDark,
//                         const Color(0xFF4CAF50),
//                       ),
//                       const SizedBox(height: 20),
//                       _buildContactCard(
//                         Icons.email_rounded,
//                         'Email',
//                         AppConstants.email,
//                         'mailto:${AppConstants.email}',
//                         context,
//                         isDark,
//                         const Color(0xFFFF5722),
//                       ),
//                       const SizedBox(height: 20),
//                       _buildContactCard(
//                         Icons.location_on_rounded,
//                         'Location',
//                         AppConstants.location,
//                         null,
//                         context,
//                         isDark,
//                         const Color(0xFF2196F3),
//                       ),
//                       const SizedBox(height: 20),
//                       _buildContactCard(
//                         FontAwesomeIcons.linkedin,
//                         'LinkedIn',
//                         'taha-hamada',
//                         AppConstants.linkedIn,
//                         context,
//                         isDark,
//                         const Color(0xFF0077B5),
//                       ),
//                     ],
//                   )
//                 : Wrap(
//                     spacing: 20,
//                     runSpacing: 20,
//                     alignment: WrapAlignment.center,
//                     children: [
//                       _buildContactCard(
//                         Icons.phone_rounded,
//                         'Phone',
//                         AppConstants.phone,
//                         'tel:${AppConstants.phone}',
//                         context,
//                         isDark,
//                         const Color(0xFF4CAF50),
//                       ),
//                       _buildContactCard(
//                         Icons.email_rounded,
//                         'Email',
//                         AppConstants.email,
//                         'mailto:${AppConstants.email}',
//                         context,
//                         isDark,
//                         const Color(0xFFFF5722),
//                       ),
//                       _buildContactCard(
//                         Icons.location_on_rounded,
//                         'Location',
//                         AppConstants.location,
//                         null,
//                         context,
//                         isDark,
//                         const Color(0xFF2196F3),
//                       ),
//                       _buildContactCard(
//                         FontAwesomeIcons.linkedin,
//                         'LinkedIn',
//                         'taha-hamada',
//                         AppConstants.linkedIn,
//                         context,
//                         isDark,
//                         const Color(0xFF0077B5),
//                       ),
//                     ],
//                   ),
//           ),
//           const SizedBox(height: 60),
//           _buildSocialLinks(isDark, context),
//         ],
//       ),
//     );
//   }

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

//   Widget _buildContactCard(
//     IconData icon,
//     String title,
//     String value,
//     String? link,
//     BuildContext context,
//     bool isDark,
//     Color accentColor,
//   ) {
//     final isMobile = Responsive.isMobile(context);

//     return MouseRegion(
//       cursor: link != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
//       child: GestureDetector(
//         onTap: link != null ? () => _launchURL(link) : null,
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(25),
//           child: BackdropFilter(
//             filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//             child: Container(
//               width: isMobile ? double.infinity : 470,
//               padding: const EdgeInsets.all(30),
//               decoration: BoxDecoration(
//                 gradient: isDark
//                     ? LinearGradient(
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                         colors: [
//                           AppTheme.darkCard.withOpacity(0.8),
//                           AppTheme.darkCard.withOpacity(0.6),
//                         ],
//                       )
//                     : LinearGradient(
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                         colors: [
//                           Colors.white,
//                           Colors.white.withOpacity(0.95),
//                         ],
//                       ),
//                 borderRadius: BorderRadius.circular(25),
//                 border: Border.all(
//                   color: isDark
//                       ? accentColor.withOpacity(0.3)
//                       : accentColor.withOpacity(0.2),
//                   width: 2,
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: isDark
//                         ? Colors.black.withOpacity(0.3)
//                         : accentColor.withOpacity(0.1),
//                     blurRadius: 20,
//                     offset: const Offset(0, 10),
//                   ),
//                 ],
//               ),
//               child: Row(
//                 children: [
//                   Container(
//                     width: 70,
//                     height: 70,
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                         colors: [
//                           accentColor.withOpacity(0.9),
//                           accentColor.withOpacity(0.7),
//                         ],
//                       ),
//                       borderRadius: BorderRadius.circular(20),
//                       boxShadow: [
//                         BoxShadow(
//                           color: accentColor.withOpacity(0.4),
//                           blurRadius: 15,
//                           spreadRadius: 2,
//                         ),
//                       ],
//                     ),
//                     child: Icon(
//                       icon,
//                       color: Colors.white,
//                       size: 32,
//                     ),
//                   ),
//                   const SizedBox(width: 20),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           title,
//                           style: TextStyle(
//                             fontSize: 16,
//                             color: isDark
//                                 ? AppTheme.darkTextSecondary
//                                 : AppTheme.lightTextSecondary,
//                             fontWeight: FontWeight.w600,
//                             letterSpacing: 0.5,
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         Text(
//                           value,
//                           style: TextStyle(
//                             fontSize: 17,
//                             color: isDark ? AppTheme.darkText : AppTheme.lightText,
//                             fontWeight: FontWeight.w800,
//                           ),
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ],
//                     ),
//                   ),
//                   if (link != null)
//                     Container(
//                       padding: const EdgeInsets.all(12),
//                       decoration: BoxDecoration(
//                         color: accentColor.withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Icon(
//                         Icons.arrow_forward_rounded,
//                         size: 20,
//                         color: accentColor,
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // Widget _buildSocialLinks(bool isDark) {
//   //   return ClipRRect(
//   //     borderRadius: BorderRadius.circular(25),
//   //     child: BackdropFilter(
//   //       filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//   //       child: Container(
//   //         padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
//   //         decoration: BoxDecoration(
//   //           gradient: LinearGradient(
//   //             colors: [
//   //               (isDark ? AppTheme.darkPrimary : AppTheme.lightPrimary)
//   //                   .withOpacity(0.2),
//   //               (isDark ? AppTheme.darkAccent : AppTheme.lightAccent)
//   //                   .withOpacity(0.1),
//   //             ],
//   //           ),
//   //           borderRadius: BorderRadius.circular(25),
//   //           border: Border.all(
//   //             color: isDark
//   //                 ? AppTheme.darkPrimary.withOpacity(0.3)
//   //                 : AppTheme.lightPrimary.withOpacity(0.2),
//   //             width: 2,
//   //           ),
//   //         ),
//   //         child: Column(
//   //           children: [
//   //             Text(
//   //               'Connect With Me',
//   //               style: TextStyle(
//   //                 fontSize: 20,
//   //                 fontWeight: FontWeight.w800,
//   //                 color: isDark ? AppTheme.darkText : AppTheme.lightText,
//   //                 letterSpacing: 0.5,
//   //               ),
//   //             ),
//   //             const SizedBox(height: 20),
//   //             Row(
//   //               mainAxisAlignment: MainAxisAlignment.center,
//   //               children: [
//   //                 _buildSocialButton(
//   //                   FontAwesomeIcons.github,
//   //                   'GitHub',
//   //                   'https://github.com/taha2901',
//   //                   isDark,
//   //                 ),
//   //                 const SizedBox(width: 15),
//   //                 _buildSocialButton(
//   //                   FontAwesomeIcons.linkedin,
//   //                   'LinkedIn',
//   //                   AppConstants.linkedIn,
//   //                   isDark,
//   //                 ),
//   //                 const SizedBox(width: 15),
//   //                 _buildSocialButton(
//   //                   FontAwesomeIcons.whatsapp,
//   //                   'WhatsApp',
//   //                   'https://wa.me/2${AppConstants.phone}',
//   //                   isDark,
//   //                 ),
//   //               ],
//   //             ),
//   //           ],
//   //         ),
//   //       ),
//   //     ),
//   //   );
//   // }

//   // Widget _buildSocialButton(
//   //   IconData icon,
//   //   String label,
//   //   String url,
//   //   bool isDark,
//   // ) {
//   //   return MouseRegion(
//   //     cursor: SystemMouseCursors.click,
//   //     child: GestureDetector(
//   //       onTap: () => _launchURL(url),
//   //       child: Container(
//   //         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//   //         decoration: BoxDecoration(
//   //           gradient: LinearGradient(
//   //             colors: [
//   //               (isDark ? AppTheme.darkPrimary : AppTheme.lightPrimary)
//   //                   .withOpacity(0.9),
//   //               (isDark ? AppTheme.darkAccent : AppTheme.lightAccent)
//   //                   .withOpacity(0.8),
//   //             ],
//   //           ),
//   //           borderRadius: BorderRadius.circular(15),
//   //           boxShadow: [
//   //             BoxShadow(
//   //               color: (isDark ? AppTheme.darkPrimary : AppTheme.lightPrimary)
//   //                   .withOpacity(0.4),
//   //               blurRadius: 15,
//   //               offset: const Offset(0, 5),
//   //             ),
//   //           ],
//   //         ),
//   //         child: Row(
//   //           mainAxisSize: MainAxisSize.min,
//   //           children: [
//   //             FaIcon(icon, color: Colors.white, size: 18),
//   //             const SizedBox(width: 8),
//   //             Text(
//   //               label,
//   //               style: const TextStyle(
//   //                 color: Colors.white,
//   //                 fontSize: 14,
//   //                 fontWeight: FontWeight.w700,
//   //                 letterSpacing: 0.5,
//   //               ),
//   //             ),
//   //           ],
//   //         ),
//   //       ),
//   //     ),
//   //   );
//   // }

// Widget _buildSocialLinks(bool isDark, BuildContext context) {
//   return ClipRRect(
//     borderRadius: BorderRadius.circular(25),
//     child: BackdropFilter(
//       filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//       child: Container(
//         padding: EdgeInsets.symmetric(
//           horizontal: Responsive.isMobile(context) ? 20 : 30,
//           vertical: 25,
//         ),
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [
//               (isDark ? AppTheme.darkPrimary : AppTheme.lightPrimary)
//                   .withOpacity(0.2),
//               (isDark ? AppTheme.darkAccent : AppTheme.lightAccent)
//                   .withOpacity(0.1),
//             ],
//           ),
//           borderRadius: BorderRadius.circular(25),
//           border: Border.all(
//             color: isDark
//                 ? AppTheme.darkPrimary.withOpacity(0.3)
//                 : AppTheme.lightPrimary.withOpacity(0.2),
//             width: 2,
//           ),
//         ),
//         child: Column(
//           children: [
//             Text(
//               'Connect With Me',
//               style: TextStyle(
//                 fontSize: Responsive.isMobile(context) ? 18 : 20,
//                 fontWeight: FontWeight.w800,
//                 color: isDark ? AppTheme.darkText : AppTheme.lightText,
//                 letterSpacing: 0.5,
//               ),
//             ),
//             const SizedBox(height: 20),
//             // استبدل Row بـ Wrap للموبايل
//             Wrap(
//               spacing: 15,
//               runSpacing: 15,
//               alignment: WrapAlignment.center,
//               children: [
//                 _buildSocialButton(
//                   FontAwesomeIcons.github,
//                   'GitHub',
//                   'https://github.com/taha2901',
//                   isDark,
//                   context
//                 ),
//                 _buildSocialButton(
//                   FontAwesomeIcons.linkedin,
//                   'LinkedIn',
//                   AppConstants.linkedIn,
//                   isDark,
//                   context
//                 ),
//                 _buildSocialButton(
//                   FontAwesomeIcons.whatsapp,
//                   'WhatsApp',
//                   'https://wa.me/2${AppConstants.phone}',
//                   isDark,
//                   context
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     ),
//   );
// }

// Widget _buildSocialButton(
//   IconData icon,
//   String label,
//   String url,
//   bool isDark,
//   BuildContext context
// ) {
//   return MouseRegion(
//     cursor: SystemMouseCursors.click,
//     child: GestureDetector(
//       onTap: () => _launchURL(url),
//       child: Container(
//         // أضف constraints للأزرار على الموبايل
//         constraints: BoxConstraints(
//           minWidth: Responsive.isMobile(context) ? 100 : 120,
//         ),
//         padding: EdgeInsets.symmetric(
//           horizontal: Responsive.isMobile(context) ? 16 : 20,
//           vertical: 12,
//         ),
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [
//               (isDark ? AppTheme.darkPrimary : AppTheme.lightPrimary)
//                   .withOpacity(0.9),
//               (isDark ? AppTheme.darkAccent : AppTheme.lightAccent)
//                   .withOpacity(0.8),
//             ],
//           ),
//           borderRadius: BorderRadius.circular(15),
//           boxShadow: [
//             BoxShadow(
//               color: (isDark ? AppTheme.darkPrimary : AppTheme.lightPrimary)
//                   .withOpacity(0.4),
//               blurRadius: 15,
//               offset: const Offset(0, 5),
//             ),
//           ],
//         ),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             FaIcon(
//               icon,
//               color: Colors.white,
//               size: Responsive.isMobile(context) ? 16 : 18,
//             ),
//             const SizedBox(width: 8),
//             Text(
//               label,
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: Responsive.isMobile(context) ? 13 : 14,
//                 fontWeight: FontWeight.w700,
//                 letterSpacing: 0.5,
//               ),
//             ),
//           ],
//         ),
//       ),
//     ),
//   );
// }

//   Future<void> _launchURL(String url) async {
//     final Uri uri = Uri.parse(url);
//     if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
//       throw Exception('Could not launch $url');
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:ui';
import 'dart:math' as math;
import '../../core/theme/app_theme.dart';
import '../../core/utils/responsive.dart';
import '../../core/constants/app_constants.dart';

// ═══════════════════════════════════════════════════════════
//  Contact Section
// ═══════════════════════════════════════════════════════════
class ContactSection extends StatefulWidget {
  const ContactSection({super.key});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection>
    with TickerProviderStateMixin {
  late AnimationController _headerCtrl;
  late Animation<double> _headerAnim;

  @override
  void initState() {
    super.initState();
    _headerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _headerAnim = CurvedAnimation(
      parent: _headerCtrl,
      curve: Curves.easeOutCubic,
    );
    _headerCtrl.forward();
  }

  @override
  void dispose() {
    _headerCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = Responsive.isMobile(context);
    final isTablet = Responsive.isTablet(context);

    final hPad = isMobile
        ? 20.0
        : isTablet
        ? 40.0
        : 100.0;

    final contactItems = [
      _ContactItem(
        icon: Icons.phone_rounded,
        title: 'Phone',
        value: AppConstants.phone,
        link: 'tel:${AppConstants.phone}',
        color: const Color(0xFF22C55E),
      ),
      _ContactItem(
        icon: Icons.email_rounded,
        title: 'Email',
        value: AppConstants.email,
        link: 'mailto:${AppConstants.email}',
        color: const Color(0xFFF97316),
      ),
      _ContactItem(
        icon: Icons.location_on_rounded,
        title: 'Location',
        value: AppConstants.location,
        link: null,
        color: const Color(0xFF3B82F6),
      ),
      _ContactItem(
        icon: FontAwesomeIcons.linkedin,
        title: 'LinkedIn',
        value: 'taha-hamada',
        link: AppConstants.linkedIn,
        color: const Color(0xFF0A66C2),
      ),
    ];

    final socialItems = [
      _SocialItem(
        icon: FontAwesomeIcons.github,
        label: 'GitHub',
        url: 'https://github.com/taha2901',
        color: isDark ? Colors.white : const Color(0xFF0D1117),
      ),
      _SocialItem(
        icon: FontAwesomeIcons.linkedin,
        label: 'LinkedIn',
        url: AppConstants.linkedIn,
        color: const Color(0xFF0A66C2),
      ),
      _SocialItem(
        icon: FontAwesomeIcons.whatsapp,
        label: 'WhatsApp',
        url: 'https://wa.me/2${AppConstants.phone}',
        color: const Color(0xFF25D366),
      ),
    ];

    return Container(
      width: double.infinity,
      color: isDark ? const Color(0xFF080B14) : const Color(0xFFF7F8FC),
      child: Stack(
        children: [
          // Background orbs
          Positioned(
            top: -60,
            left: -80,
            child: _GlowOrb(
              color: isDark ? AppTheme.darkPrimary : AppTheme.lightPrimary,
              size: 300,
            ),
          ),
          Positioned(
            bottom: 0,
            right: -60,
            child: _GlowOrb(
              color: isDark ? AppTheme.darkAccent : AppTheme.lightAccent,
              size: 260,
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: hPad,
              vertical: isMobile ? 72 : 120,
            ),
            child: Column(
              children: [
                // ── Header ───────────────────────────────
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

                SizedBox(height: isMobile ? 44 : 64),

                // ── Contact Cards Grid ───────────────────
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: _ContactGrid(
                    items: contactItems,
                    isDark: isDark,
                    isMobile: isMobile,
                    isTablet: isTablet,
                  ),
                ),

                SizedBox(height: isMobile ? 48 : 72),

                // ── Social Links ─────────────────────────
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 700),
                  child: _SocialLinksCard(
                    items: socialItems,
                    isDark: isDark,
                    isMobile: isMobile,
                  ),
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
//  Data Models
// ═══════════════════════════════════════════════════════════
class _ContactItem {
  final IconData icon;
  final String title, value;
  final String? link;
  final Color color;
  const _ContactItem({
    required this.icon,
    required this.title,
    required this.value,
    required this.link,
    required this.color,
  });
}

class _SocialItem {
  final IconData icon;
  final String label, url;
  final Color color;
  const _SocialItem({
    required this.icon,
    required this.label,
    required this.url,
    required this.color,
  });
}

// ═══════════════════════════════════════════════════════════
//  Glow Orb
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
    final primary = isDark ? AppTheme.darkPrimary : AppTheme.lightPrimary;

    return Column(
      children: [
        // Pill label
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: primary.withOpacity(0.4), width: 1.5),
            color: primary.withOpacity(0.08),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: primary,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'GET IN TOUCH',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2.5,
                  color: primary,
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: isMobile ? 18 : 24),

        Text(
          "Let's Work\nTogether",
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

        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Text(
            'Feel free to reach out for collaborations, freelance work, or just a friendly chat.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isMobile ? 13.5 : 15.5,
              color: isDark
                  ? Colors.white.withOpacity(0.50)
                  : const Color(0xFF0D1117).withOpacity(0.50),
              height: 1.65,
            ),
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════
//  Contact Grid — 2 cols desktop/tablet, 1 col mobile
// ═══════════════════════════════════════════════════════════
class _ContactGrid extends StatelessWidget {
  final List<_ContactItem> items;
  final bool isDark, isMobile, isTablet;

  const _ContactGrid({
    required this.items,
    required this.isDark,
    required this.isMobile,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    if (isMobile) {
      return Column(
        children: items
            .asMap()
            .entries
            .map(
              (e) => Padding(
                padding: EdgeInsets.only(
                  bottom: e.key < items.length - 1 ? 16 : 0,
                ),
                child: _ContactCard(
                  item: e.value,
                  isDark: isDark,
                  isMobile: true,
                  index: e.key,
                ),
              ),
            )
            .toList(),
      );
    }

    return Center(
      child: Wrap(
        spacing: 20,
        runSpacing: 20,
        alignment: WrapAlignment.center,
        children: items
            .asMap()
            .entries
            .map(
              (e) => SizedBox(
                width: isTablet
                    ? (MediaQuery.of(context).size.width - 80 - 20) / 2
                    : 520,
                child: _ContactCard(
                  item: e.value,
                  isDark: isDark,
                  isMobile: false,
                  index: e.key,
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
//  Contact Card
// ═══════════════════════════════════════════════════════════
class _ContactCard extends StatefulWidget {
  final _ContactItem item;
  final bool isDark, isMobile;
  final int index;
  const _ContactCard({
    required this.item,
    required this.isDark,
    required this.isMobile,
    required this.index,
  });

  @override
  State<_ContactCard> createState() => _ContactCardState();
}

class _ContactCardState extends State<_ContactCard>
    with SingleTickerProviderStateMixin {
  bool _hovered = false;
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _onEnter(_) {
    setState(() => _hovered = true);
    _ctrl.forward();
  }

  void _onExit(_) {
    setState(() => _hovered = false);
    _ctrl.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final isDark = widget.isDark;

    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 500 + widget.index * 100),
      tween: Tween(begin: 0, end: 1),
      curve: Curves.easeOutCubic,
      builder: (_, v, child) => Transform.translate(
        offset: Offset(0, 24 * (1 - v)),
        child: Opacity(opacity: v, child: child),
      ),
      child: MouseRegion(
        cursor: item.link != null
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
        onEnter: _onEnter,
        onExit: _onExit,
        child: GestureDetector(
          onTap: item.link != null ? () => _launch(item.link!) : null,
          child: AnimatedBuilder(
            animation: _anim,
            builder: (_, child) => Transform.translate(
              offset: Offset(0, -5 * _anim.value),
              child: child,
            ),
            child: Container(
              padding: EdgeInsets.all(widget.isMobile ? 20 : 26),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF111827) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _hovered
                      ? item.color.withOpacity(0.45)
                      : (isDark
                            ? Colors.white.withOpacity(0.06)
                            : Colors.black.withOpacity(0.07)),
                  width: 1.5,
                ),
                boxShadow: _hovered
                    ? [
                        BoxShadow(
                          color: item.color.withOpacity(0.18),
                          blurRadius: 40,
                          offset: const Offset(0, 16),
                        ),
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: Colors.black.withOpacity(isDark ? 0.28 : 0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
              ),
              child: Row(
                children: [
                  // Icon box
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    width: widget.isMobile ? 52 : 60,
                    height: widget.isMobile ? 52 : 60,
                    decoration: BoxDecoration(
                      color: _hovered
                          ? item.color
                          : item.color.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: _hovered
                            ? item.color
                            : item.color.withOpacity(0.20),
                        width: 1.5,
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        item.icon,
                        size: widget.isMobile ? 22 : 26,
                        color: _hovered ? Colors.white : item.color,
                      ),
                    ),
                  ),

                  SizedBox(width: widget.isMobile ? 16 : 20),

                  // Text
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title.toUpperCase(),
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.8,
                            color: item.color.withOpacity(0.8),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          item.value,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: widget.isMobile ? 14 : 16,
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF0D1117),
                            letterSpacing: -0.3,
                          ),
                        ),
                      ],
                    ),
                  ),

                  if (item.link != null)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: _hovered
                            ? item.color.withOpacity(0.12)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: _hovered
                              ? item.color.withOpacity(0.30)
                              : (isDark
                                    ? Colors.white.withOpacity(0.08)
                                    : Colors.black.withOpacity(0.08)),
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        Icons.arrow_forward_rounded,
                        size: 16,
                        color: _hovered
                            ? item.color
                            : (isDark
                                  ? Colors.white.withOpacity(0.35)
                                  : Colors.black.withOpacity(0.30)),
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

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      // ignore silently
    }
  }
}

// ═══════════════════════════════════════════════════════════
//  Social Links Card
// ═══════════════════════════════════════════════════════════
class _SocialLinksCard extends StatelessWidget {
  final List<_SocialItem> items;
  final bool isDark, isMobile;

  const _SocialLinksCard({
    required this.items,
    required this.isDark,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    final primary = isDark ? AppTheme.darkPrimary : AppTheme.lightPrimary;

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 700),
      tween: Tween(begin: 0, end: 1),
      curve: Curves.easeOutCubic,
      builder: (_, v, child) => Transform.translate(
        offset: Offset(0, 20 * (1 - v)),
        child: Opacity(opacity: v, child: child),
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(isMobile ? 28 : 36),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF111827) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isDark
                ? Colors.white.withOpacity(0.07)
                : Colors.black.withOpacity(0.07),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.28 : 0.06),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            // Dot + title
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: primary,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'Connect With Me',
                  style: TextStyle(
                    fontSize: isMobile ? 17 : 20,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : const Color(0xFF0D1117),
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),

            SizedBox(height: isMobile ? 6 : 8),

            Text(
              'Find me on these platforms',
              style: TextStyle(
                fontSize: 13,
                color: isDark
                    ? Colors.white.withOpacity(0.40)
                    : Colors.black.withOpacity(0.40),
              ),
            ),

            SizedBox(height: isMobile ? 24 : 28),

            // Divider
            Container(
              height: 1,
              color: isDark
                  ? Colors.white.withOpacity(0.06)
                  : Colors.black.withOpacity(0.06),
            ),

            SizedBox(height: isMobile ? 24 : 28),

            // Social buttons
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: items
                  .map(
                    (s) => _SocialButton(
                      item: s,
                      isDark: isDark,
                      isMobile: isMobile,
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
//  Social Button
// ═══════════════════════════════════════════════════════════
class _SocialButton extends StatefulWidget {
  final _SocialItem item;
  final bool isDark, isMobile;
  const _SocialButton({
    required this.item,
    required this.isDark,
    required this.isMobile,
  });

  @override
  State<_SocialButton> createState() => _SocialButtonState();
}

class _SocialButtonState extends State<_SocialButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => _launch(item.url),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.translationValues(0, _hovered ? -3 : 0, 0),
          padding: EdgeInsets.symmetric(
            horizontal: widget.isMobile ? 18 : 24,
            vertical: widget.isMobile ? 12 : 14,
          ),
          decoration: BoxDecoration(
            color: _hovered ? item.color : item.color.withOpacity(0.09),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: _hovered ? item.color : item.color.withOpacity(0.25),
              width: 1.5,
            ),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: item.color.withOpacity(0.30),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FaIcon(
                item.icon,
                size: widget.isMobile ? 15 : 17,
                color: _hovered ? Colors.white : item.color,
              ),
              SizedBox(width: widget.isMobile ? 8 : 10),
              Text(
                item.label,
                style: TextStyle(
                  fontSize: widget.isMobile ? 13 : 14,
                  fontWeight: FontWeight.w700,
                  color: _hovered ? Colors.white : item.color,
                  letterSpacing: 0.2,
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
