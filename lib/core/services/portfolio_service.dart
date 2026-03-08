import 'package:cloud_firestore/cloud_firestore.dart';

class PortfolioService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ─── Skills ────────────────────────────────────────────
  Stream<List<Map<String, dynamic>>> getSkills() {
    return _db
        .collection('skills')
        .orderBy('order')
        .snapshots()
        .map((s) => s.docs.map((d) => {'id': d.id, ...d.data()}).toList());
  }

  Future<void> addSkill(String name, String emoji) async {
    final count = await _db.collection('skills').count().get();
    await _db.collection('skills').add({
      'name': name,
      'emoji': emoji,
      'order': count.count,
    });
  }

  Future<void> updateSkill(String id, String name, String emoji) async {
    await _db.collection('skills').doc(id).update({
      'name': name,
      'emoji': emoji,
    });
  }

  Future<void> deleteSkill(String id) async {
    await _db.collection('skills').doc(id).delete();
  }

  // ─── Projects ──────────────────────────────────────────
  // NOTE: بنجيب كل المشاريع ونعمل filter في الكود
  // عشان نتجنب الحاجة لـ Composite Index في Firestore
  Stream<List<Map<String, dynamic>>> getProjects({String? category}) {
    return _db
        .collection('projects')
        .snapshots()
        .map((s) {
          var docs = s.docs
              .map((d) => {'id': d.id, ...d.data() as Map<String, dynamic>})
              .toList();

          // Filter by category in code
          if (category != null && category != 'All') {
            docs = docs
                .where((p) => p['category'] == category)
                .toList();
          }

          // Sort by order field
          docs.sort((a, b) {
            final aOrder = (a['order'] ?? 999) as int;
            final bOrder = (b['order'] ?? 999) as int;
            return aOrder.compareTo(bOrder);
          });

          return docs;
        });
  }

  Future<void> addProject(Map<String, dynamic> data) async {
    final count = await _db.collection('projects').count().get();
    await _db.collection('projects').add({...data, 'order': count.count});
  }

  Future<void> updateProject(String id, Map<String, dynamic> data) async {
    await _db.collection('projects').doc(id).update(data);
  }

  Future<void> deleteProject(String id) async {
    await _db.collection('projects').doc(id).delete();
  }

  // ─── Seed Projects (استخدمه مرة واحدة بس!) ────────────
  Future<void> seedProjects(List<Map<String, dynamic>> projects) async {
    // احذف الموجودين الأول لو حابب تبدأ من صفر
    // final existing = await _db.collection('projects').get();
    // for (final doc in existing.docs) await doc.reference.delete();

    for (int i = 0; i < projects.length; i++) {
      await _db.collection('projects').add({
        ...projects[i],
        'order': i,
      });
    }
  }

  // ─── Settings (CV + About + Constants) ─────────────────
  Stream<Map<String, dynamic>> getSettings() {
    return _db
        .collection('settings')
        .doc('main')
        .snapshots()
        .map((s) => s.data() ?? {});
  }

  Future<void> updateSettings(Map<String, dynamic> data) async {
    await _db
        .collection('settings')
        .doc('main')
        .set(data, SetOptions(merge: true));
  }
}