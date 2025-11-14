class Project {
  final String title;
  final String description;
  final List<String> technologies;
  final String? githubLink;
  final String? apkLink;
  final String? videoLink;
  final String imagePath;
  final String? badge; // جديد - لإضافة Badge مميز

  Project({
    required this.title,
    required this.description,
    required this.technologies,
    this.githubLink,
    this.apkLink,
    this.videoLink,
    required this.imagePath,
    this.badge,
  });

  static List<Project> getProjects() {
    return [
      Project(
        title: 'E-Commerce App',
        description: 'A comprehensive e-commerce mobile application with user authentication, product catalog, shopping cart, and payment integration. Includes admin panel with permissions to add products, track orders, manage users, and delete content.',
        technologies: ['Flutter', 'Firebase', 'Bloc', 'Admin Panel'],
        githubLink: 'https://github.com/taha2901/e-commerce-shop',
        apkLink: 'https://drive.google.com/file/d/1ZNvtGQh0W9UBaU2VGtimp3ERLDnRap2g/view',
        videoLink: 'https://drive.google.com/file/d/1Zv12NvtWlqBPoGotsXo2F5w6C_F2uZZ5/view',
        imagePath: 'assets/img/Cover.png',
        badge: 'Featured',
      ),
      Project(
        title: 'Management Stocks (Local)',
        description: 'Multi-platform inventory management system with SQLite local database. Perfect for single-device retail stores, pharmacies, and shops. Features comprehensive POS functionality, inventory tracking, sales/purchase management, and financial reporting. Works offline with fast performance. Supports Windows, Android, iOS, and Web.',
        technologies: ['Flutter', 'SQLite', 'Offline-First', 'Local Database'],
        imagePath: 'assets/img/mockap stoks sqlite.png',
        videoLink: 'https://drive.google.com/file/d/1oKNF4huSwUoDrVTE41WdRao8dmM_puZ6/view?usp=drivesdk',
        badge: 'Offline',
      ),
      Project(
        title: 'Management Stocks (Cloud)',
        description: 'Advanced cloud-based inventory management system powered by Supabase. Access your data anywhere, anytime from any device. Perfect for multi-branch stores and businesses that need real-time synchronization. Features include cloud storage, multi-user access, automatic backups, and real-time data sync across all devices. All data is securely stored on the cloud and accessible 24/7.',
        technologies: ['Flutter', 'Supabase', 'Cloud Database', 'Real-time Sync'],
        imagePath: 'assets/img/mockup stock db.png',
        videoLink: 'https://drive.google.com/file/d/1oKNF4huSwUoDrVTE41WdRao8dmM_puZ6/view?usp=drivesdk',
        badge: 'Cloud',
      ),
      Project(
        title: 'Doctor App',
        description: 'Medical application displaying doctors with appointment booking system and all medical specialties management. Features include doctor profiles, appointment scheduling, and specialty categorization.',
        technologies: ['Flutter', 'Bloc', 'REST API', 'Healthcare'],
        imagePath: 'assets/img/Product Overview.png',
        apkLink: 'https://drive.google.com/file/d/1t2MgExwf56JwGlTW5JspXvR9S4DzGG9I/view',
        githubLink: 'https://github.com/taha2901/DoctorDocApp',
        videoLink: 'https://drive.google.com/file/d/1hY5CrJFWPnOiz3d0o0_fduygRrHv0X1m/view',
      ),
      Project(
        title: 'Home Services App',
        description: 'A mobile application for home services with user authentication, service catalog, shopping cart, and payment integration. Supports two languages for better accessibility.',
        technologies: ['Flutter', 'Home Services', 'Multi-language'],
        imagePath: 'assets/img/unnamed.png',
        apkLink: 'https://drive.google.com/file/d/13bz61QFwtEXSG79x58dZV0lkPmYNZvqz/view',
        videoLink: 'https://drive.google.com/file/d/1oKNF4huSwUoDrVTE41WdRao8dmM_puZ6/view',
      ),
      Project(
        title: 'Daily Challenges Diabetes',
        description: 'Challenges Diabetes App – A mobile app for diabetic patients to manage medicines with reminders, book doctor appointments, track meals with recommendations, and monitor health measurements like blood sugar, pressure, and weight.',
        technologies: ['Flutter', 'Bloc', 'REST API', 'Healthcare'],
        imagePath: 'assets/img/ChatGPT Image Sep 5, 2025, 04_44_14 PM.png',
        githubLink: 'https://github.com/taha2901/Diaily-Challenge-Diabetis',
        apkLink: 'https://drive.google.com/file/d/10E1Z4pkwvx_5-Pv0gX1P33uAvP5Jt221/view',
        videoLink: 'https://drive.google.com/file/d/1nGkVrfmaj2ZROVg9SGYs5Ej6TaD1-skm/view',
      ),
    ];
  }
}
