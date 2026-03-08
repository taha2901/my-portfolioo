import 'package:flutter/material.dart';
import 'package:taha_portfolio/core/services/portfolio_service.dart';

class ProjectFormDialog extends StatefulWidget {
  final PortfolioService service;
  final Map<String, dynamic>? existing;

  const ProjectFormDialog({super.key, required this.service, this.existing});

  @override
  State<ProjectFormDialog> createState() => _ProjectFormDialogState();
}

class _ProjectFormDialogState extends State<ProjectFormDialog> {
  late final _title = TextEditingController(text: widget.existing?['title']);
  late final _desc = TextEditingController(text: widget.existing?['description']);
  late final _github = TextEditingController(text: widget.existing?['githubLink']);
  late final _apk = TextEditingController(text: widget.existing?['apkLink']);
  late final _video = TextEditingController(text: widget.existing?['videoLink']);
  late final _image = TextEditingController(text: widget.existing?['imagePath']);
  late final _badge = TextEditingController(text: widget.existing?['badge']);
  late String _category = widget.existing?['category'] ?? 'Mobile';
  late final _techCtrl = TextEditingController(
    text: (widget.existing?['technologies'] as List?)?.join(', ') ?? '',
  );

  bool _loading = false;

  @override
  void dispose() {
    for (final c in [_title, _desc, _github, _apk, _video, _image, _badge, _techCtrl]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (_title.text.trim().isEmpty) return;
    setState(() => _loading = true);

    final data = {
      'title': _title.text.trim(),
      'description': _desc.text.trim(),
      'technologies': _techCtrl.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList(),
      'githubLink': _github.text.trim().isEmpty ? null : _github.text.trim(),
      'apkLink': _apk.text.trim().isEmpty ? null : _apk.text.trim(),
      'videoLink': _video.text.trim().isEmpty ? null : _video.text.trim(),
      'imagePath': _image.text.trim().isEmpty ? 'assets/img/placeholder.png' : _image.text.trim(),
      'badge': _badge.text.trim().isEmpty ? null : _badge.text.trim(),
      'category': _category,
    };

    if (widget.existing != null) {
      await widget.service.updateProject(widget.existing!['id'], data);
    } else {
      await widget.service.addProject(data);
    }

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: isDark ? const Color(0xFF1A1A2E) : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 550, maxHeight: 700),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                ),
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.work_outline_rounded,
                      color: Colors.white, size: 20),
                  const SizedBox(width: 10),
                  Text(
                    widget.existing != null ? 'Edit Project' : 'Add Project',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // Form
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  _field('Title *', _title, isDark),
                  _field('Description', _desc, isDark, maxLines: 3),
                  _field('Technologies (comma separated)', _techCtrl, isDark),

                  // Category
                  const SizedBox(height: 12),
                  Text('Category',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? Colors.white.withOpacity(0.6)
                              : Colors.black.withOpacity(0.5))),
                  const SizedBox(height: 6),
                  Row(
                    children: ['Mobile', 'Web', 'Desktop'].map((cat) {
                      final isSelected = _category == cat;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: () => setState(() => _category = cat),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              gradient: isSelected
                                  ? const LinearGradient(
                                      colors: [
                                        Color(0xFF667EEA),
                                        Color(0xFF764BA2)
                                      ],
                                    )
                                  : null,
                              color: isSelected
                                  ? null
                                  : isDark
                                      ? Colors.white.withOpacity(0.05)
                                      : Colors.black.withOpacity(0.04),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              cat,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: isSelected
                                    ? Colors.white
                                    : isDark
                                        ? Colors.white.withOpacity(0.5)
                                        : Colors.black.withOpacity(0.4),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  _field('GitHub Link', _github, isDark),
                  _field('APK Link', _apk, isDark),
                  _field('Video/Demo Link', _video, isDark),
                  _field('Image Path', _image, isDark,
                      hint: 'assets/img/myimage.png'),
                  _field('Badge (Featured/Offline/Cloud)', _badge, isDark),
                ],
              ),
            ),

            // Footer
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _loading ? null : _save,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Ink(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          alignment: Alignment.center,
                          child: _loading
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                      color: Colors.white, strokeWidth: 2),
                                )
                              : Text(
                                  widget.existing != null ? 'Update' : 'Add',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(
    String label,
    TextEditingController ctrl,
    bool isDark, {
    int maxLines = 1,
    String? hint,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? Colors.white.withOpacity(0.6)
                  : Colors.black.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: ctrl,
            maxLines: maxLines,
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF1A1A2E),
              fontSize: 13,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: isDark
                    ? Colors.white.withOpacity(0.25)
                    : Colors.black.withOpacity(0.25),
                fontSize: 13,
              ),
              filled: true,
              fillColor: isDark
                  ? Colors.white.withOpacity(0.04)
                  : Colors.black.withOpacity(0.03),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: isDark
                      ? Colors.white.withOpacity(0.07)
                      : Colors.black.withOpacity(0.07),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: isDark
                      ? Colors.white.withOpacity(0.07)
                      : Colors.black.withOpacity(0.07),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    const BorderSide(color: Color(0xFF667EEA), width: 1.5),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
          ),
        ],
      ),
    );
  }
}