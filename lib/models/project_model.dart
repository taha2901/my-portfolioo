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
        description:
            'A comprehensive e-commerce mobile application with user authentication, product catalog, shopping cart, and payment integration. Includes admin panel with permissions to add products, track orders, manage users, and delete content.',
        technologies: ['Flutter', 'Firebase', 'Bloc', 'Admin Panel'],
        githubLink: 'https://github.com/taha2901/e-commerce-shop',
        apkLink:
            'https://drive.google.com/file/d/1ZNvtGQh0W9UBaU2VGtimp3ERLDnRap2g/view',
        videoLink:
            'https://drive.google.com/file/d/1Zv12NvtWlqBPoGotsXo2F5w6C_F2uZZ5/view',
        imagePath: 'assets/img/Cover.png',
        badge: 'Featured',
      ),
      Project(
        title: 'Management Stocks',
        description:
            'Designed and delivered a complete shopping flow with authentication, cart management, and order tracking, improving overall user experience and app stability.',
        technologies: ['Flutter', 'Mobile', 'Desktop', 'Api'],
        imagePath: 'assets/img/Screenshot 2026-01-16 030944.png',
        apkLink: '',
        videoLink:
            'https://drive.google.com/file/d/15ZUcYG_v4OAItvlht42T_6IjWZvdpM6o/view',
      ),
      Project(
        title: 'Doctor App',
        description:
            'Medical application displaying doctors with appointment booking system and all medical specialties management. Features include doctor profiles, appointment scheduling, and specialty categorization.',
        technologies: ['Flutter', 'Bloc', 'REST API', 'Healthcare'],
        imagePath: 'assets/img/Product Overview.png',
        apkLink:
            'https://drive.google.com/file/d/1t2MgExwf56JwGlTW5JspXvR9S4DzGG9I/view',
        githubLink: 'https://github.com/taha2901/DoctorDocApp',
        videoLink:
            'https://drive.google.com/file/d/1hY5CrJFWPnOiz3d0o0_fduygRrHv0X1m/view',
      ),
      Project(
        title: 'Home Services App',
        description:
            'A mobile application for home services with user authentication, service catalog, shopping cart, and payment integration. Supports two languages for better accessibility.',
        technologies: ['Flutter', 'Home Services', 'Multi-language'],
        imagePath: 'assets/img/unnamed.png',
        apkLink:
            'https://drive.google.com/file/d/13bz61QFwtEXSG79x58dZV0lkPmYNZvqz/view',
        videoLink:
            'https://drive.google.com/file/d/1oKNF4huSwUoDrVTE41WdRao8dmM_puZ6/view',
      ),
      Project(
        title: 'Daily Challenges Diabetes',
        description:
            'Challenges Diabetes App – A mobile app for diabetic patients to manage medicines with reminders, book doctor appointments, track meals with recommendations, and monitor health measurements like blood sugar, pressure, and weight.',
        technologies: ['Flutter', 'Bloc', 'REST API', 'Healthcare'],
        imagePath: 'assets/img/ChatGPT Image Sep 5, 2025, 04_44_14 PM.png',
        githubLink: 'https://github.com/taha2901/Diaily-Challenge-Diabetis',
        apkLink:
            'https://drive.google.com/file/d/10E1Z4pkwvx_5-Pv0gX1P33uAvP5Jt221/view',
        videoLink:
            'https://drive.google.com/file/d/1nGkVrfmaj2ZROVg9SGYs5Ej6TaD1-skm/view',
      ),
      Project(
        title: 'Gym Manager (Local)',
        description:
            'A multi-platform gym management system built with Flutter and local SQLite. Enables gyms and fitness clubs to manage members, subscriptions, and attendance effortlessly. Features a modern dashboard, barcode-based check-in, revenue tracking, advanced reports, and instant data backup. Responsive, works on Windows and desktop, offline-first, and supports both light and dark mode for an optimal user experience.',
        technologies: ['Flutter', 'SQLite', 'Offline-First', 'Local Database'],
        imagePath: 'assets/img/gym manager.png',
        videoLink:
            'https://drive.google.com/file/d/1Pi4W4iKZGFf1arMaVdthMv0xMQlJLE_I/view?usp=drive_link',
        badge: 'Offline',
      ),
      Project(
        title: 'Management Stocks (Local)',
        description:
            'Multi-platform inventory management system with SQLite local database. Perfect for single-device retail stores, pharmacies, and shops. Features comprehensive POS functionality, inventory tracking, sales/purchase management, and financial reporting. Works offline with fast performance. Supports Windows, Android, iOS, and Web.',
        technologies: ['Flutter', 'SQLite', 'Offline-First', 'Local Database'],
        imagePath: 'assets/img/mockap stoks sqlite.png',
        videoLink:
            'https://drive.google.com/file/d/13R36k2unKcR6YIgrvHGA2D7IJk58XZcp/view?usp=drivesdk',
        badge: 'Offline',
      ),

      Project(
        title: 'EduGate (School Management)',
        description:
            'A cross-platform school management system (Mobile & Desktop) designed for administrators and accountants. Provides real-time insights into student enrollment, payment status, financial reports, staff management (teachers, admin, maintenance), and school inventory such as devices, desks, chairs, and stationery. Includes features for adding new students, managing attendance, publishing announcements, sending notifications, and full control over school operations. Currently completed as a full UI/UX design and will be integrated with a database in the next phase.',
        technologies: ['Flutter', 'Desktop App', 'School System', 'Management'],
        imagePath: 'assets/img/edu_gate.png', // ضع مسار الصورة الصحيح
        videoLink:
            "https://drive.google.com/file/d/1pMMNzpvL_O-fYa5hH_QFJx_GuCIaHkjS/view?usp=drive_link",
        badge: 'Design Only',
      ),
    ];
  }
}
