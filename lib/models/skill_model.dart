class Skill {
  final String name;
  final String emoji;

  Skill({required this.name, required this.emoji});

  static List<Skill> getSkills() {
    return [
      Skill(name: 'Flutter', emoji: '📱'),
      Skill(name: 'Dart', emoji: '🎯'),
      Skill(name: 'Firebase', emoji: '🔥'),
      Skill(name: 'SQLite', emoji: '🗄️'),
      Skill(name: 'REST APIs', emoji: '🌐'),
      Skill(name: 'ASP.NET', emoji: '💻'),
      Skill(name: 'State Management', emoji: '📊'),
      Skill(name: 'Git & GitHub', emoji: '🔧'),
      Skill(name: 'Responsive Design', emoji: '📐'),
      Skill(name: 'Push Notifications', emoji: '🔔'),
      Skill(name: 'Payment Integration', emoji: '💳'),
      Skill(name: 'Maps & Location', emoji: '🗺️'),
      Skill(name: 'Animations', emoji: '🎬'),
      Skill(name: 'App Deployment', emoji: '🚀'),
      Skill(name: 'Supabase', emoji: '⚡'),
    ];
  }
}
