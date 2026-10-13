import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todoapp/models/focus_session.dart';

class FocusRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _sessionsRef(
    String uid,
    String taskId,
  ) {
    return _firestore
        .collection('user')
        .doc(uid)
        .collection('tasks')
        .doc(taskId)
        .collection('focusSessions');
  }

  // Yeni oturum oluşturur veya mevcut oturumu günceller.
  Future<void> saveSession(
    String uid,
    String taskId,
    FocusSession session,
  ) async {
    await _sessionsRef(uid, taskId).doc(session.id).set(session.toMap());
  }

  Future<List<FocusSession>> fetchSessions(String uid, String taskId) async {
    final snapshot = await _sessionsRef(
      uid,
      taskId,
    ).orderBy('completedAt', descending: true).get();

    return snapshot.docs.map((doc) {
      return FocusSession.fromMap(doc.id, doc.data());
    }).toList();
  }

  Future<int> getTotalFocusSeconds(String uid, String taskId) async {
    final sessions = await fetchSessions(uid, taskId);

    return sessions.fold<int>(
      0,
      (total, session) => total + session.durationSeconds,
    );
  }

  // Görev kartlarında canlı değişiklikleri dinlemek için.
  Stream<int> watchTotalFocusSeconds(String uid, String taskId) {
    return _sessionsRef(uid, taskId).snapshots().map((snapshot) {
      return snapshot.docs.fold<int>(0, (total, doc) {
        final seconds = (doc.data()['durationSeconds'] as num?)?.toInt() ?? 0;

        return total + seconds;
      });
    });
  }
}
