import 'dart:io';

void createFolderStructure() {
  const base = 'lib';

  final folders = [
    // core
    'core/theme',
    'core/constants',
    'core/utils',

    // models
    'models',

    // screens
    'screens',
    'screens/widgets',
  ];

  final files = {
    // core/theme
    'core/theme/app_theme.dart': '''
class AppTheme {}
''',

    // core/constants
    'core/constants/app_constants.dart': '''
class AppConstants {}
''',

    // core/utils
    'core/utils/responsive.dart': '''
class Responsive {}
''',

    // models
    'models/project_model.dart': '''
class ProjectModel {}
''',
    'models/skill_model.dart': '''
class SkillModel {}
''',

    // screens
    'screens/home_screen.dart': '''
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("Home Screen")),
    );
  }
}
''',

    // screen widgets
    'screens/widgets/header_section.dart': 'class HeaderSection {}',
    'screens/widgets/about_section.dart': 'class AboutSection {}',
    'screens/widgets/skills_section.dart': 'class SkillsSection {}',
    'screens/widgets/projects_section.dart': 'class ProjectsSection {}',
    'screens/widgets/cv_section.dart': 'class CvSection {}',
    'screens/widgets/contact_section.dart': 'class ContactSection {}',
  };

  // إنشاء المجلدات
  for (final folder in folders) {
    final dir = Directory('$base/$folder');
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
      print('Created folder: ${dir.path}');
    }
  }

  // إنشاء الملفات الفارغة (مع محتوى بسيط)
  files.forEach((path, content) {
    final file = File('$base/$path');
    if (!file.existsSync()) {
      file.createSync(recursive: true);
      file.writeAsStringSync(content);
      print('Created file: $path');
    }
  });

  print('\n✔ Folder structure created successfully!');
}
