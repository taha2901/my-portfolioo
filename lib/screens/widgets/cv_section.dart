import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:ui';
import '../../core/theme/app_theme.dart';
import '../../core/utils/responsive.dart';
import '../../core/constants/app_constants.dart';

class CVSection extends StatelessWidget {
  const CVSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = Responsive.isMobile(context);
    
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: isDark ? AppTheme.darkGradient : AppTheme.lightGradient,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 60,
        vertical: isMobile ? 50 : 70,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: isMobile ? double.infinity : 700,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: EdgeInsets.all(isMobile ? 30 : 45),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(0.2),
                      Colors.white.withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 30,
                      offset: const Offset(0, 15),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Icon
                    Container(
                      padding: EdgeInsets.all(isMobile ? 18 : 22),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0.3),
                            Colors.white.withOpacity(0.2),
                          ],
                        ),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.5),
                          width: 2.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.3),
                            blurRadius: 20,
                            spreadRadius: 3,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.description_rounded,
                        size: isMobile ? 50 : 60,
                        color: Colors.white,
                      ),
                    ),
                    
                    SizedBox(height: isMobile ? 20 : 25),
                    
                    // Title
                    Text(
                      'Download My CV',
                      style: TextStyle(
                        fontSize: isMobile ? 26 : 34,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                    
                    SizedBox(height: isMobile ? 10 : 12),
                    
                    // Description
                    Text(
                      'Get a comprehensive overview of my skills,\nexperience, and education',
                      style: TextStyle(
                        fontSize: isMobile ? 13 : 15,
                        color: Colors.white.withOpacity(0.9),
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    SizedBox(height: isMobile ? 25 : 30),
                    
                    // Download Button
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () => _launchURL(AppConstants.cvLink),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: isMobile ? 32 : 40,
                                vertical: isMobile ? 14 : 16,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(25),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white.withOpacity(0.3),
                                    blurRadius: 20,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.download_rounded,
                                    color: isDark
                                        ? AppTheme.darkPrimary
                                        : AppTheme.lightPrimary,
                                    size: isMobile ? 22 : 24,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    'Download CV',
                                    style: TextStyle(
                                      color: isDark
                                          ? AppTheme.darkPrimary
                                          : AppTheme.lightPrimary,
                                      fontSize: isMobile ? 15 : 17,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    
                    SizedBox(height: isMobile ? 20 : 25),
                    
                    // Stats
                    isMobile
                        ? _buildStatsMobile()
                        : _buildStatsDesktop(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatsDesktop() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildStatItem('📄', 'PDF Format', Colors.white),
        const SizedBox(width: 25),
        Container(
          width: 1,
          height: 35,
          color: Colors.white.withOpacity(0.3),
        ),
        const SizedBox(width: 25),
        _buildStatItem('📱', 'Mobile Friendly', Colors.white),
        const SizedBox(width: 25),
        Container(
          width: 1,
          height: 35,
          color: Colors.white.withOpacity(0.3),
        ),
        const SizedBox(width: 25),
        _buildStatItem('⚡', 'Quick View', Colors.white),
      ],
    );
  }

  Widget _buildStatsMobile() {
    return Wrap(
      spacing: 20,
      runSpacing: 15,
      alignment: WrapAlignment.center,
      children: [
        _buildStatItem('📄', 'PDF Format', Colors.white),
        _buildStatItem('📱', 'Mobile Friendly', Colors.white),
        _buildStatItem('⚡', 'Quick View', Colors.white),
      ],
    );
  }

  Widget _buildStatItem(String emoji, String text, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(emoji, style: const TextStyle(fontSize: 26)),
        const SizedBox(height: 6),
        Text(
          text,
          style: TextStyle(
            color: color.withOpacity(0.9),
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
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
