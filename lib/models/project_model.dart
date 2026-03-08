class Project {
  final String title;
  final String description;
  final List<String> technologies;
  final String? githubLink;
  final String? apkLink;
  final String? videoLink;
  final String imagePath;
  final String? badge;
  final String category;

  Project({
    required this.title,
    required this.description,
    required this.technologies,
    this.githubLink,
    this.apkLink,
    this.videoLink,
    required this.imagePath,
    this.badge,
    this.category = 'Mobile',
  });
}
