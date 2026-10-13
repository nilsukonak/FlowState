import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todoapp/models/task_model.dart';

class TaskRepository {
  Future<List<Taskmodel>> fetchtasks(String uid) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('user')
        .doc(uid) // giriş yapan kullanıcının UID'si
        .collection('tasks') // o kullanıcının görevleri
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return Taskmodel(
        id: doc.id,
        title: data['title'] ?? '',
        description: data['description'] ?? '',
        date: data['date'] ?? '',
        priority: data['priority'] ?? '',
        category: data['category'] ?? '',
        isdone: data['isdone'] ?? false,
      );
    }).toList();
  }

  Future<void> deleteTask(String taskId, String uid) async {
    await FirebaseFirestore.instance
        .collection('user')
        .doc(uid)
        .collection('tasks')
        .doc(taskId)
        .delete();
  }

  Future<void> updateTask(String uid, Taskmodel updatedTask) async {
    await FirebaseFirestore.instance
        .collection('user')
        .doc(uid)
        .collection('tasks')
        .doc(updatedTask.id) // Belgenin ID’si
        .update({
          'title': updatedTask.title,
          'description': updatedTask.description,
          'date': updatedTask.date,
          'priority': updatedTask.priority,
          'category': updatedTask.category,
        });
  }

  Future<void> toogletask(String uid, Taskmodel task) async {
    await FirebaseFirestore.instance
        .collection('user')
        .doc(uid)
        .collection('tasks')
        .doc(task.id)
        .update({'isdone': !task.isdone});
  }

  Future<Taskmodel> addTask(
    String uid, //hangi kullanıcnın altına
    Taskmodel task, //hangi gorevi
  ) async {
    final docRef = await FirebaseFirestore.instance
        .collection('user')
        .doc(uid)
        .collection('tasks')
        .add(task.toJson());

    return task.copyWith(id: docRef.id);
  }
}
