class SkillModel {
  final String name;
  final String emoji;

  SkillModel({required this.name, required this.emoji});

 }

 List<SkillModel> getSkills() => [
      SkillModel(name: 'Flutter', emoji: '📱'),
      SkillModel(name: 'Dart', emoji: '🎯'),
      SkillModel(name: 'Firebase', emoji: '🔥'),
      SkillModel(name: 'SQLite', emoji: '🗄️'),
      SkillModel(name: 'REST APIs', emoji: '🌐'),
      SkillModel(name: 'ASP.NET', emoji: '💻'),
      SkillModel(name: 'State Management', emoji: '📊'),
      SkillModel(name: 'Git & GitHub', emoji: '🔧'),
      SkillModel(name: 'Responsive Design', emoji: '📐'),
      SkillModel(name: 'Push Notifications', emoji: '🔔'),
      SkillModel(name: 'Payment Integration', emoji: '💳'),
      SkillModel(name: 'Maps & Location', emoji: '🗺️'),
      SkillModel(name: 'Animations', emoji: '🎬'),
      SkillModel(name: 'App Deployment', emoji: '🚀'),
      SkillModel(name: 'Supabase', emoji: '⚡'),
    ];
