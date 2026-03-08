import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/responsive.dart';
import '../../core/constants/app_constants.dart';

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
    _headerAnim =
        CurvedAnimation(parent: _headerCtrl, curve: Curves.easeOutCubic);
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
    final hPad = isMobile ? 24.0 : isTablet ? 48.0 : 100.0;

    return Container(
      width: double.infinity,
      color: isDark ? const Color(0xFF080B14) : const Color(0xFFF7F8FC),
      child: Stack(
        children: [
          Positioned(
            top: -80,
            left: -60,
            child: _GlowOrb(
              color: isDark ? AppTheme.darkPrimary : AppTheme.lightPrimary,
              size: 340,
            ),
          ),
          Positioned(
            bottom: -40,
            right: -80,
            child: _GlowOrb(
              color: isDark ? AppTheme.darkAccent : AppTheme.lightAccent,
              size: 280,
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: hPad,
              vertical: isMobile ? 72 : 120,
            ),
            child: Column(
              // FIX: crossAxisAlignment stretch يخلي كل الـ children تاخد كامل العرض
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
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

                SizedBox(height: isMobile ? 52 : 80),

                isMobile
                    ? _MobileLayout(isDark: isDark)
                    : _DesktopLayout(isDark: isDark, isTablet: isTablet),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
//  Layouts
// ═══════════════════════════════════════════════════════════

class _DesktopLayout extends StatelessWidget {
  final bool isDark, isTablet;
  const _DesktopLayout({required this.isDark, required this.isTablet});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1100),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: _CTACard(isDark: isDark),
            ),
            const SizedBox(width: 24),
            Expanded(
              flex: 4,
              child: Column(
                children: [
                  _InfoStack(isDark: isDark),
                  const SizedBox(height: 16),
                  _SocialRow(isDark: isDark, isMobile: false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MobileLayout extends StatelessWidget {
  final bool isDark;
  const _MobileLayout({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      // FIX: stretch يخلي كل widget تاخد كامل العرض
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _CTACard(isDark: isDark),
        const SizedBox(height: 16),
        _InfoStack(isDark: isDark),
        const SizedBox(height: 16),
        _SocialRow(isDark: isDark, isMobile: true),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════
//  CTA Card
// ═══════════════════════════════════════════════════════════

class _CTACard extends StatefulWidget {
  final bool isDark;
  const _CTACard({required this.isDark});

  @override
  State<_CTACard> createState() => _CTACardState();
}

class _CTACardState extends State<_CTACard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final primary = isDark ? AppTheme.darkPrimary : AppTheme.lightPrimary;
    final accent = isDark ? AppTheme.darkAccent : AppTheme.lightAccent;
    final isMobile = Responsive.isMobile(context);

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _launch('mailto:${AppConstants.email}'),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          // FIX: double.infinity يضمن أخذ كامل العرض المتاح
          width: double.infinity,
          transform: Matrix4.translationValues(0, _hovered ? -6 : 0, 0),
          padding: EdgeInsets.all(isMobile ? 28 : 40),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [primary, accent],
            ),
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: primary.withOpacity(_hovered ? 0.45 : 0.25),
                blurRadius: _hovered ? 50 : 30,
                offset: const Offset(0, 16),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.20),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.30),
                    width: 1.5,
                  ),
                ),
                child: const Icon(
                  Icons.mail_outline_rounded,
                  color: Colors.white,
                  size: 26,
                ),
              ),

              const SizedBox(height: 32),

              Text(
                'Send me a\nmessage',
                style: TextStyle(
                  fontSize: isMobile ? 26 : 32,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  height: 1.15,
                  letterSpacing: -1,
                ),
              ),

              const SizedBox(height: 14),

              Text(
                AppConstants.email,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.75),
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.2,
                ),
              ),

              const SizedBox(height: 36),

              // FIX: Button بـ IntrinsicWidth بدل min
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Write an email',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: primary,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(width: 10),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      transform: Matrix4.translationValues(_hovered ? 4 : 0, 0, 0),
                      child: Icon(
                        Icons.arrow_forward_rounded,
                        size: 16,
                        color: primary,
                      ),
                    ),
                  ],
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
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

// ═══════════════════════════════════════════════════════════
//  Info Stack
// ═══════════════════════════════════════════════════════════

class _InfoStack extends StatelessWidget {
  final bool isDark;
  const _InfoStack({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final rows = [
      _InfoRow(
        icon: Icons.phone_rounded,
        label: 'Phone',
        value: AppConstants.phone,
        url: 'tel:${AppConstants.phone}',
        color: const Color(0xFF22C55E),
        isDark: isDark,
        index: 0,
      ),
      _InfoRow(
        icon: Icons.location_on_rounded,
        label: 'Location',
        value: AppConstants.location,
        url: null,
        color: const Color(0xFF3B82F6),
        isDark: isDark,
        index: 1,
      ),
      _InfoRow(
        icon: FontAwesomeIcons.linkedin,
        label: 'LinkedIn',
        value: 'taha-hamada',
        url: AppConstants.linkedIn,
        color: const Color(0xFF0A66C2),
        isDark: isDark,
        index: 2,
        isFa: true,
      ),
    ];

    return Container(
      // FIX: width مضمون
      width: double.infinity,
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
            color: Colors.black.withOpacity(isDark ? 0.28 : 0.05),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: rows.asMap().entries.map((e) {
          final isLast = e.key == rows.length - 1;
          return Column(
            children: [
              e.value,
              if (!isLast)
                Container(
                  height: 1,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  color: isDark
                      ? Colors.white.withOpacity(0.05)
                      : Colors.black.withOpacity(0.05),
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _InfoRow extends StatefulWidget {
  final IconData icon;
  final String label, value;
  final String? url;
  final Color color;
  final bool isDark;
  final int index;
  final bool isFa;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.url,
    required this.color,
    required this.isDark,
    required this.index,
    this.isFa = false,
  });

  @override
  State<_InfoRow> createState() => _InfoRowState();
}

class _InfoRowState extends State<_InfoRow> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 500 + widget.index * 100),
      tween: Tween(begin: 0, end: 1),
      curve: Curves.easeOutCubic,
      builder: (_, v, child) =>
          Transform.translate(offset: Offset(12 * (1 - v), 0), child: child),
      child: MouseRegion(
        cursor: widget.url != null
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: widget.url != null ? () => _launch(widget.url!) : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            decoration: BoxDecoration(
              color: _hovered
                  ? widget.color.withOpacity(0.05)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: widget.color.withOpacity(_hovered ? 0.18 : 0.10),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: widget.isFa
                        ? FaIcon(widget.icon, size: 16, color: widget.color)
                        : Icon(widget.icon, size: 18, color: widget.color),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.label,
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.5,
                          color: widget.color.withOpacity(0.8),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        widget.value,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w600,
                          color: widget.isDark
                              ? Colors.white.withOpacity(0.90)
                              : const Color(0xFF0D1117),
                        ),
                      ),
                    ],
                  ),
                ),
                if (widget.url != null)
                  AnimatedOpacity(
                    opacity: _hovered ? 1.0 : 0.35,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.north_east_rounded,
                      size: 16,
                      color: widget.isDark ? Colors.white : Colors.black,
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
    final uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

// ═══════════════════════════════════════════════════════════
//  Social Row
// ═══════════════════════════════════════════════════════════

class _SocialRow extends StatelessWidget {
  final bool isDark, isMobile;
  const _SocialRow({required this.isDark, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    final socials = [
      (FontAwesomeIcons.github, 'GitHub', 'https://github.com/taha2901',
          isDark ? Colors.white : const Color(0xFF0D1117)),
      (FontAwesomeIcons.linkedin, 'LinkedIn', AppConstants.linkedIn,
          const Color(0xFF0A66C2)),
      (FontAwesomeIcons.whatsapp, 'WhatsApp',
          'https://wa.me/2${AppConstants.phone}', const Color(0xFF25D366)),
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111827) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.07)
              : Colors.black.withOpacity(0.07),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.25 : 0.04),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Text(
            'Also on',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: isDark
                  ? Colors.white.withOpacity(0.35)
                  : Colors.black.withOpacity(0.35),
            ),
          ),
          const SizedBox(width: 14),
          const Spacer(),
          ...socials.map((s) => Padding(
                padding: const EdgeInsets.only(left: 10),
                child: _SocialIconBtn(
                  icon: s.$1,
                  label: s.$2,
                  url: s.$3,
                  color: s.$4,
                  isDark: isDark,
                ),
              )),
        ],
      ),
    );
  }
}

class _SocialIconBtn extends StatefulWidget {
  final IconData icon;
  final String label, url;
  final Color color;
  final bool isDark;
  const _SocialIconBtn({
    required this.icon,
    required this.label,
    required this.url,
    required this.color,
    required this.isDark,
  });

  @override
  State<_SocialIconBtn> createState() => _SocialIconBtnState();
}

class _SocialIconBtnState extends State<_SocialIconBtn> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () async {
          final uri = Uri.parse(widget.url);
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        },
        child: Tooltip(
          message: widget.label,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            transform: Matrix4.translationValues(0, _hovered ? -3 : 0, 0),
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: _hovered ? widget.color : widget.color.withOpacity(0.10),
              borderRadius: BorderRadius.circular(13),
              border: Border.all(
                color: _hovered ? widget.color : widget.color.withOpacity(0.22),
                width: 1.5,
              ),
              boxShadow: _hovered
                  ? [
                      BoxShadow(
                        color: widget.color.withOpacity(0.35),
                        blurRadius: 16,
                        offset: const Offset(0, 5),
                      )
                    ]
                  : [],
            ),
            child: Center(
              child: FaIcon(
                widget.icon,
                size: 16,
                color: _hovered ? Colors.white : widget.color,
              ),
            ),
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
                decoration: BoxDecoration(shape: BoxShape.circle, color: primary),
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
            fontSize: isMobile ? 36 : isTablet ? 48 : 60,
            fontWeight: FontWeight.w900,
            color: isDark ? Colors.white : const Color(0xFF0D1117),
            height: 1.08,
            letterSpacing: -2,
          ),
        ),
        SizedBox(height: isMobile ? 14 : 18),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Text(
            'Open for collaborations, freelance work, or just a friendly chat.',
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
            colors: [color.withOpacity(0.12), Colors.transparent],
          ),
        ),
      ),
    );
  }
}