import 'package:cloud_firestore/cloud_firestore.dart';

class FocusSession {
  final String id;
  final int durationSeconds;
  final DateTime completedAt;
  final bool isCompleted;

  FocusSession({
    required this.id,
    required this.durationSeconds,
    required this.completedAt,
    this.isCompleted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'durationSeconds': durationSeconds,
      'completedAt': Timestamp.fromDate(completedAt),
      'isCompleted': isCompleted,
    };
  }

  factory FocusSession.fromMap(String id, Map<String, dynamic> map) {
    return FocusSession(
      id: id,
      durationSeconds: (map['durationSeconds'] as num).toInt(),
      completedAt: (map['completedAt'] as Timestamp).toDate(),
      // Eski kayıtların tamamlanmış Pomodoro olduğunu biliyoruz.
      isCompleted: map['isCompleted'] as bool? ?? true,
    );
  }
}
