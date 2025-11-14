import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:ui';
import '../../core/theme/app_theme.dart';
import '../../core/utils/responsive.dart';
import '../../core/constants/app_constants.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = Responsive.isMobile(context);
    
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: isDark
            ? const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF0A0E27),
                  Color(0xFF000000),
                ],
              )
            : const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF0D47A1),
                  Color(0xFF01579B),
                ],
              ),
      ),
      child: Column(
        children: [
          // Main Footer Content
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 20 : 60,
              vertical: isMobile ? 40 : 70,
            ),
            child: isMobile
                ? _buildMobileFooter(isDark)
                : _buildDesktopFooter(isDark),
          ),
          
          // Divider
          Container(
            height: 1,
            margin: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 40),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.white.withOpacity(0.3),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          
          // Bottom Footer
          _buildBottomFooter(isDark, isMobile),
        ],
      ),
    );
  }

  Widget _buildMobileFooter(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildBrandSection(isDark, true),
        const SizedBox(height: 35),
        _buildQuickLinks(isDark, true),
        const SizedBox(height: 35),
        _buildContactInfo(isDark, true),
        const SizedBox(height: 35),
        _buildSocialLinks(isDark, true),
      ],
    );
  }

  Widget _buildDesktopFooter(bool isDark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: _buildBrandSection(isDark, false),
        ),
        const SizedBox(width: 60),
        Expanded(
          child: _buildQuickLinks(isDark, false),
        ),
        const SizedBox(width: 60),
        Expanded(
          child: _buildContactInfo(isDark, false),
        ),
        const SizedBox(width: 60),
        Expanded(
          child: _buildSocialLinks(isDark, false),
        ),
      ],
    );
  }

  Widget _buildBrandSection(bool isDark, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  width: isMobile ? 45 : 50,
                  height: isMobile ? 45 : 50,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.2),
                        Colors.white.withOpacity(0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'TH',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isMobile ? 18 : 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Flexible(
              child: Text(
                AppConstants.name,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isMobile ? 20 : 24,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Text(
          'Flutter Developer specializing in\nbeautiful cross-platform applications',
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: isMobile ? 13 : 14,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 15),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 12 : 16,
                vertical: isMobile ? 8 : 10,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.2),
                    Colors.white.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1.5,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: Color(0xFF4CAF50),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF4CAF50),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Available for work',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isMobile ? 12 : 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickLinks(bool isDark, bool isMobile) {
    final links = [
      {'title': 'Home', 'icon': Icons.home_outlined},
      {'title': 'About', 'icon': Icons.person_outline},
      {'title': 'Projects', 'icon': Icons.work_outline},
      {'title': 'Skills', 'icon': Icons.code_outlined},
      {'title': 'Contact', 'icon': Icons.mail_outline},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Quick Links',
          style: TextStyle(
            color: Colors.white,
            fontSize: isMobile ? 16 : 18,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
        ),
        SizedBox(height: isMobile ? 18 : 25),
        ...links.map((link) {
          return Padding(
            padding: EdgeInsets.only(bottom: isMobile ? 12 : 15),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    link['icon'] as IconData,
                    color: Colors.white.withOpacity(0.7),
                    size: isMobile ? 16 : 18,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    link['title'] as String,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: isMobile ? 14 : 15,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildContactInfo(bool isDark, bool isMobile) {
    final contacts = [
      {
        'icon': Icons.email_outlined,
        'text': AppConstants.email,
        'link': 'mailto:${AppConstants.email}'
      },
      {
        'icon': Icons.phone_outlined,
        'text': AppConstants.phone,
        'link': 'tel:${AppConstants.phone}'
      },
      {
        'icon': Icons.location_on_outlined,
        'text': AppConstants.location,
        'link': null
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Contact Info',
          style: TextStyle(
            color: Colors.white,
            fontSize: isMobile ? 16 : 18,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
        ),
        SizedBox(height: isMobile ? 18 : 25),
        ...contacts.map((contact) {
          return Padding(
            padding: EdgeInsets.only(bottom: isMobile ? 12 : 15),
            child: MouseRegion(
              cursor: contact['link'] != null 
                  ? SystemMouseCursors.click 
                  : SystemMouseCursors.basic,
              child: GestureDetector(
                onTap: contact['link'] != null 
                    ? () => _launchURL(contact['link'] as String) 
                    : null,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      contact['icon'] as IconData,
                      color: Colors.white.withOpacity(0.7),
                      size: isMobile ? 16 : 18,
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Text(
                        contact['text'] as String,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: isMobile ? 13 : 14,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.3,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildSocialLinks(bool isDark, bool isMobile) {
    final socials = [
      {
        'icon': FontAwesomeIcons.github,
        'label': 'GitHub',
        'link': 'https://github.com/taha2901',
        'color': const Color(0xFF333333),
      },
      {
        'icon': FontAwesomeIcons.linkedin,
        'label': 'LinkedIn',
        'link': AppConstants.linkedIn,
        'color': const Color(0xFF0077B5),
      },
      {
        'icon': FontAwesomeIcons.whatsapp,
        'label': 'WhatsApp',
        'link': 'https://wa.me/2${AppConstants.phone}',
        'color': const Color(0xFF25D366),
      },
      {
        'icon': FontAwesomeIcons.telegram,
        'label': 'Telegram',
        'link': 'https://t.me/${AppConstants.phone}',
        'color': const Color(0xFF0088CC),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Follow Me',
          style: TextStyle(
            color: Colors.white,
            fontSize: isMobile ? 16 : 18,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
        ),
        SizedBox(height: isMobile ? 18 : 25),
        Wrap(
          spacing: isMobile ? 10 : 12,
          runSpacing: isMobile ? 10 : 12,
          children: socials.map((social) {
            return MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => _launchURL(social['link'] as String),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(
                      width: isMobile ? 45 : 50,
                      height: isMobile ? 45 : 50,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            (social['color'] as Color).withOpacity(0.8),
                            (social['color'] as Color).withOpacity(0.6),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: (social['color'] as Color).withOpacity(0.3),
                            blurRadius: 12,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Center(
                        child: FaIcon(
                          social['icon'] as IconData,
                          color: Colors.white,
                          size: isMobile ? 20 : 22,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildBottomFooter(bool isDark, bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 60,
        vertical: isMobile ? 20 : 30,
      ),
      child: isMobile
          ? Column(
              children: [
                _buildCopyright(isDark, isMobile),
                const SizedBox(height: 12),
                _buildTechStack(isDark, isMobile),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCopyright(isDark, isMobile),
                _buildTechStack(isDark, isMobile),
              ],
            ),
    );
  }

  Widget _buildCopyright(bool isDark, bool isMobile) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.copyright,
          color: Colors.white.withOpacity(0.6),
          size: isMobile ? 14 : 16,
        ),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            '2025 ${AppConstants.name}. All rights reserved.',
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: isMobile ? 12 : 14,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
            textAlign: isMobile ? TextAlign.center : TextAlign.left,
          ),
        ),
      ],
    );
  }

  Widget _buildTechStack(bool isDark, bool isMobile) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      alignment: isMobile ? WrapAlignment.center : WrapAlignment.start,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          'Built with',
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: isMobile ? 12 : 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Icon(
          Icons.favorite,
          color: Color(0xFFE91E63),
          size: 14,
        ),
        Text(
          'using Flutter',
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: isMobile ? 12 : 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF02569B), Color(0xFF13B9FD)],
            ),
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Text(
            '💙',
            style: TextStyle(fontSize: 11),
          ),
        ),
      ],
    );
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }
}
