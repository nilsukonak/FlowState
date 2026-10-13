import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/data/repositories/focus_repository.dart';
import 'package:todoapp/models/focus_session.dart';

class FocusProvider extends ChangeNotifier {
  static const int focusDuration = 25 * 60;

  final FocusRepository _repository = FocusRepository();

  Timer? _timer;

  String? _currentTaskId;
  String? _currentSessionId;

  int _remainingSeconds = focusDuration;
  int _completedSessions = 0;
  int _completedCycles = 0;
  int _totalFocusSeconds = 0;

  // Mevcut oturumda gerçekten çalışılmış saniye.
  int _currentSessionSeconds = 0;

  bool _isRunning = false;
  bool _isCycleCompleted = false;
  bool _isLoading = false;

  // Kayıtları sıraya koyarak eski verinin yeniyi ezmesini önler.
  Future<void> _pendingSave = Future.value();

  int get remainingSeconds => _remainingSeconds;
  int get completedSessions => _completedSessions;
  int get completedCycles => _completedCycles;

  // Kaydedilmiş geçmiş + henüz kaydedilmemiş canlı süre.
  int get totalFocusSeconds => _totalFocusSeconds + _currentSessionSeconds;

  bool get isRunning => _isRunning;
  bool get isCycleCompleted => _isCycleCompleted;
  bool get isLoading => _isLoading;

  Future<void> selectTask(String taskId) async {
    if (_currentTaskId == taskId) return;

    // Önce eski oturumun son durumunu kaydet.
    _timer?.cancel();
    _timer = null;
    _isRunning = false;

    await _saveCurrentSession();

    _currentTaskId = taskId;
    _currentSessionId = null;
    _currentSessionSeconds = 0;
    _remainingSeconds = focusDuration;
    _completedSessions = 0;
    _completedCycles = 0;
    _totalFocusSeconds = 0;
    _isCycleCompleted = false;
    _isLoading = true;

    notifyListeners();

    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      _isLoading = false;
      notifyListeners();
      return;
    }

    try {
      await _pendingSave;

      final sessions = await _repository.fetchSessions(uid, taskId);

      if (_currentTaskId != taskId) return;

      _totalFocusSeconds = sessions.fold<int>(
        0,
        (total, session) => total + session.durationSeconds,
      );

      final completedCount = sessions
          .where(
            (session) =>
                session.isCompleted && session.durationSeconds >= focusDuration,
          )
          .length;

      _completedCycles = completedCount ~/ 4;
      _completedSessions = completedCount % 4;
    } catch (e) {
      debugPrint('FOCUS LOAD ERROR: $e');
    } finally {
      if (_currentTaskId == taskId) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  void startTimer() {
    if (_isRunning ||
        _isCycleCompleted ||
        _currentTaskId == null ||
        _isLoading) {
      return;
    }

    if (_remainingSeconds == 0) {
      _remainingSeconds = focusDuration;
    }

    // Yeni Pomodoro için yeni belge ID'si.
    _currentSessionId ??= FirebaseFirestore.instance
        .collection('sessionIds')
        .doc()
        .id;

    _isRunning = true;
    notifyListeners();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds <= 0) return;

      _remainingSeconds--;
      _currentSessionSeconds++;

      notifyListeners();

      // Her 10 saniyede bir Firebase'e kaydet.
      if (_currentSessionSeconds % 10 == 0) {
        _saveCurrentSession();
      }

      if (_remainingSeconds == 0) {
        _timer?.cancel();
        _timer = null;
        _isRunning = false;

        _completedSessions++;

        if (_completedSessions >= 4) {
          _completedSessions = 4;
          _isCycleCompleted = true;
          _completedCycles++;
        }

        _saveCurrentSession(isCompleted: true);
        notifyListeners();
      }
    });
  }

  Future<void> _saveCurrentSession({bool isCompleted = false}) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final taskId = _currentTaskId;
    final sessionId = _currentSessionId;

    if (uid == null ||
        taskId == null ||
        sessionId == null ||
        _currentSessionSeconds == 0) {
      return;
    }

    // Kayıt anındaki değerleri sabitle.
    final seconds = _currentSessionSeconds;

    final session = FocusSession(
      id: sessionId,
      durationSeconds: seconds,
      completedAt: DateTime.now(),
      isCompleted: isCompleted,
    );

    _pendingSave = _pendingSave
        .then((_) async {
          await _repository.saveSession(uid, taskId, session);
          debugPrint('FOCUS SAVED: $seconds sec, completed=$isCompleted');
        })
        .catchError((Object error) {
          debugPrint('FOCUS SAVE ERROR: $error');
        });

    await _pendingSave;
  }

  void pauseTimer() {
    _timer?.cancel();
    _timer = null;
    _isRunning = false;

    _saveCurrentSession();
    notifyListeners();
  }

  void resetTimer() {
    _timer?.cancel();
    _timer = null;
    _isRunning = false;

    // Reset öncesi çalışılan süreyi kaydet.
    _saveCurrentSession();

    // Geçen süreyi toplamdan düşmüyoruz.
    _totalFocusSeconds += _currentSessionSeconds;

    _currentSessionSeconds = 0;
    _currentSessionId = null;
    _remainingSeconds = focusDuration;

    notifyListeners();
  }

  void startNewCycle() {
    _timer?.cancel();
    _timer = null;
    _isRunning = false;

    _completedSessions = 0;
    _isCycleCompleted = false;
    _remainingSeconds = focusDuration;

    notifyListeners();
  }

  // Focus ekranından çıkarken çağrılacak.
  Future<void> leaveFocus() async {
    _timer?.cancel();
    _timer = null;
    _isRunning = false;

    await _saveCurrentSession();

    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
