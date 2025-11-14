import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:ui';
import '../../core/theme/app_theme.dart';
import '../../core/utils/responsive.dart';
import '../../core/constants/app_constants.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkBackground : AppTheme.lightBackground,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.isMobile(context) ? 20 : Responsive.isTablet(context) ? 40 : 100,
        vertical: Responsive.isMobile(context) ? 80 : 120,
      ),
      child: Column(
        children: [
          _buildSectionTitle('Get In Touch', isDark),
          const SizedBox(height: 20),
          Text(
            'Feel free to reach out for collaborations or just a friendly chat',
            style: TextStyle(
              fontSize: Responsive.isMobile(context) ? 15 : 17,
              color: isDark
                  ? AppTheme.darkTextSecondary
                  : AppTheme.lightTextSecondary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 60),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: Responsive.isMobile(context)
                ? Column(
                    children: [
                      _buildContactCard(
                        Icons.phone_rounded,
                        'Phone',
                        AppConstants.phone,
                        'tel:${AppConstants.phone}',
                        context,
                        isDark,
                        const Color(0xFF4CAF50),
                      ),
                      const SizedBox(height: 20),
                      _buildContactCard(
                        Icons.email_rounded,
                        'Email',
                        AppConstants.email,
                        'mailto:${AppConstants.email}',
                        context,
                        isDark,
                        const Color(0xFFFF5722),
                      ),
                      const SizedBox(height: 20),
                      _buildContactCard(
                        Icons.location_on_rounded,
                        'Location',
                        AppConstants.location,
                        null,
                        context,
                        isDark,
                        const Color(0xFF2196F3),
                      ),
                      const SizedBox(height: 20),
                      _buildContactCard(
                        FontAwesomeIcons.linkedin,
                        'LinkedIn',
                        'taha-hamada',
                        AppConstants.linkedIn,
                        context,
                        isDark,
                        const Color(0xFF0077B5),
                      ),
                    ],
                  )
                : Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    alignment: WrapAlignment.center,
                    children: [
                      _buildContactCard(
                        Icons.phone_rounded,
                        'Phone',
                        AppConstants.phone,
                        'tel:${AppConstants.phone}',
                        context,
                        isDark,
                        const Color(0xFF4CAF50),
                      ),
                      _buildContactCard(
                        Icons.email_rounded,
                        'Email',
                        AppConstants.email,
                        'mailto:${AppConstants.email}',
                        context,
                        isDark,
                        const Color(0xFFFF5722),
                      ),
                      _buildContactCard(
                        Icons.location_on_rounded,
                        'Location',
                        AppConstants.location,
                        null,
                        context,
                        isDark,
                        const Color(0xFF2196F3),
                      ),
                      _buildContactCard(
                        FontAwesomeIcons.linkedin,
                        'LinkedIn',
                        'taha-hamada',
                        AppConstants.linkedIn,
                        context,
                        isDark,
                        const Color(0xFF0077B5),
                      ),
                    ],
                  ),
          ),
          const SizedBox(height: 60),
          _buildSocialLinks(isDark, context),
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

  Widget _buildContactCard(
    IconData icon,
    String title,
    String value,
    String? link,
    BuildContext context,
    bool isDark,
    Color accentColor,
  ) {
    final isMobile = Responsive.isMobile(context);
    
    return MouseRegion(
      cursor: link != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: link != null ? () => _launchURL(link) : null,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              width: isMobile ? double.infinity : 470,
              padding: const EdgeInsets.all(30),
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
                          Colors.white,
                          Colors.white.withOpacity(0.95),
                        ],
                      ),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: isDark
                      ? accentColor.withOpacity(0.3)
                      : accentColor.withOpacity(0.2),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? Colors.black.withOpacity(0.3)
                        : accentColor.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          accentColor.withOpacity(0.9),
                          accentColor.withOpacity(0.7),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: accentColor.withOpacity(0.4),
                          blurRadius: 15,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Icon(
                      icon,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 16,
                            color: isDark
                                ? AppTheme.darkTextSecondary
                                : AppTheme.lightTextSecondary,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          value,
                          style: TextStyle(
                            fontSize: 17,
                            color: isDark ? AppTheme.darkText : AppTheme.lightText,
                            fontWeight: FontWeight.w800,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  if (link != null)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: accentColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.arrow_forward_rounded,
                        size: 20,
                        color: accentColor,
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

  // Widget _buildSocialLinks(bool isDark) {
  //   return ClipRRect(
  //     borderRadius: BorderRadius.circular(25),
  //     child: BackdropFilter(
  //       filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
  //       child: Container(
  //         padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
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
  //                 fontSize: 20,
  //                 fontWeight: FontWeight.w800,
  //                 color: isDark ? AppTheme.darkText : AppTheme.lightText,
  //                 letterSpacing: 0.5,
  //               ),
  //             ),
  //             const SizedBox(height: 20),
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 _buildSocialButton(
  //                   FontAwesomeIcons.github,
  //                   'GitHub',
  //                   'https://github.com/taha2901',
  //                   isDark,
  //                 ),
  //                 const SizedBox(width: 15),
  //                 _buildSocialButton(
  //                   FontAwesomeIcons.linkedin,
  //                   'LinkedIn',
  //                   AppConstants.linkedIn,
  //                   isDark,
  //                 ),
  //                 const SizedBox(width: 15),
  //                 _buildSocialButton(
  //                   FontAwesomeIcons.whatsapp,
  //                   'WhatsApp',
  //                   'https://wa.me/2${AppConstants.phone}',
  //                   isDark,
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
  // ) {
  //   return MouseRegion(
  //     cursor: SystemMouseCursors.click,
  //     child: GestureDetector(
  //       onTap: () => _launchURL(url),
  //       child: Container(
  //         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
  //           children: [
  //             FaIcon(icon, color: Colors.white, size: 18),
  //             const SizedBox(width: 8),
  //             Text(
  //               label,
  //               style: const TextStyle(
  //                 color: Colors.white,
  //                 fontSize: 14,
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




Widget _buildSocialLinks(bool isDark, BuildContext context) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(25),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Responsive.isMobile(context) ? 20 : 30,
          vertical: 25,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              (isDark ? AppTheme.darkPrimary : AppTheme.lightPrimary)
                  .withOpacity(0.2),
              (isDark ? AppTheme.darkAccent : AppTheme.lightAccent)
                  .withOpacity(0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isDark
                ? AppTheme.darkPrimary.withOpacity(0.3)
                : AppTheme.lightPrimary.withOpacity(0.2),
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Text(
              'Connect With Me',
              style: TextStyle(
                fontSize: Responsive.isMobile(context) ? 18 : 20,
                fontWeight: FontWeight.w800,
                color: isDark ? AppTheme.darkText : AppTheme.lightText,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 20),
            // استبدل Row بـ Wrap للموبايل
            Wrap(
              spacing: 15,
              runSpacing: 15,
              alignment: WrapAlignment.center,
              children: [
                _buildSocialButton(
                  FontAwesomeIcons.github,
                  'GitHub',
                  'https://github.com/taha2901',
                  isDark,
                  context
                ),
                _buildSocialButton(
                  FontAwesomeIcons.linkedin,
                  'LinkedIn',
                  AppConstants.linkedIn,
                  isDark,
                  context
                ),
                _buildSocialButton(
                  FontAwesomeIcons.whatsapp,
                  'WhatsApp',
                  'https://wa.me/2${AppConstants.phone}',
                  isDark, 
                  context
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildSocialButton(
  IconData icon,
  String label,
  String url,
  bool isDark,
  BuildContext context
) {
  return MouseRegion(
    cursor: SystemMouseCursors.click,
    child: GestureDetector(
      onTap: () => _launchURL(url),
      child: Container(
        // أضف constraints للأزرار على الموبايل
        constraints: BoxConstraints(
          minWidth: Responsive.isMobile(context) ? 100 : 120,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: Responsive.isMobile(context) ? 16 : 20,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              (isDark ? AppTheme.darkPrimary : AppTheme.lightPrimary)
                  .withOpacity(0.9),
              (isDark ? AppTheme.darkAccent : AppTheme.lightAccent)
                  .withOpacity(0.8),
            ],
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: (isDark ? AppTheme.darkPrimary : AppTheme.lightPrimary)
                  .withOpacity(0.4),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(
              icon,
              color: Colors.white,
              size: Responsive.isMobile(context) ? 16 : 18,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: Responsive.isMobile(context) ? 13 : 14,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }
}
