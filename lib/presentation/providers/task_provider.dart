import 'package:flutter/material.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:todoapp/data/repositories/task_repository.dart';
import 'package:todoapp/services/notification_service.dart';

enum FilterOption { All, Active, Completed }

class TaskProvider with ChangeNotifier {
  List<Taskmodel> _task = [];
  List<Taskmodel> get task => _task;
  //DASHBOARD İÇİN KISIMM:
  // Toplam görev sayısı
  int get totalTasks => _task.length;

  // Tamamlanan görev sayısı
  int get completedTasks => _task.where((task) => task.isdone).length;

  // Aktif görev sayısı
  int get activeTasks => _task.where((task) => !task.isdone).length;

  // Tamamlanma yüzdesi (0.0 - 1.0)
  double get completionRate {
    if (_task.isEmpty) return 0.0;

    return completedTasks /
        totalTasks; //sonuc garp cıkıyo ama sonucu 100le carpmıyoz cunku indigator bizden 0. lü bişe bekliyo ekranda yazdırırken carpcaz
  }

  //

  String? get userid => _userid;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  final TaskRepository _repository;
  TaskProvider(this._repository);
  String _searchQuery = ''; //aramacubugu
  void setSearchQuery(String query) {
    _searchQuery = query
        .toLowerCase()
        .trim(); //tolowercase ile buyk kucuk farketmez sekilde arıyo
    notifyListeners(); //her yeni harfte dinlendsn ona gore seyler cıksn aktf olrk
  }
  // Dinamik getter

  String? _userid;

  //FİLTRELEME için
  FilterOption _selectedFilter = FilterOption.All;

  List<Taskmodel> get filteredTasks {
    // 1. Önce mevcut filtreyi uygula
    List<Taskmodel> filtered = [];
    //ilk once sktf olanlar mı tamamlanmıs olanar mı onu getiiryo
    if (_selectedFilter == FilterOption.Active) {
      filtered = _task.where((t) => !t.isdone).toList();
    } else if (_selectedFilter == FilterOption.Completed) {
      filtered = _task.where((t) => t.isdone).toList();
    } else {
      //bunlar secilmediyse all yani tum gorevlerdr
      filtered = List.from(
        _task,
      ); //neded rekt all için filtered = _task;böle hepisini almadk cunku birazdan tamamlananları sona falan tasıcaz orjinal task listeinin duzenini değil olstrdgm yeni listeynin duzenini değiştrms olcamm
    }

    // 2. Ardından arama metnini uygula
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((task) {
        return task.title.toLowerCase().contains(_searchQuery);
      }).toList();
    }

    // 3. Tamamlanan görevleri sona taşı
    filtered.sort((a, b) {
      if (a.isdone == b.isdone) return 0;
      return a.isdone ? 1 : -1;
    });

    return filtered;
  }

  FilterOption get selectedFilter => _selectedFilter;

  void changeFilter(FilterOption filter) {
    _selectedFilter = filter;
    notifyListeners();
  }

  Future<Taskmodel> addTask(Taskmodel newTask) async {
    if (_userid == null) {
      throw Exception('Kullanıcı giriş yapmamış.');
    }

    final savedTask = await _repository.addTask(_userid!, newTask);

    _task.add(savedTask);
    notifyListeners();

    return savedTask;
  }

  void setUserId(String? uid) {
    if (_userid == uid) {
      print("uid değişmedi");
      return;
    }

    _userid = uid; //uid değişmş yeni uidi atadk
    _task.clear(); //gorevler temizlendi

    if (uid != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }

  Future<void> fetchtasks() async {
    if (_userid == null) {
      debugPrint("UID null, görev çekilemez");
      return;
    }

    _isLoading = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });

    try {
      _task = await _repository.fetchtasks(_userid!);
    } catch (e) {
      debugPrint("Görevler çekilemedi: $e");
      rethrow;
    } finally {
      _isLoading = false;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }

  Future<void> dismisibleTask(String taskId) async {
    final uid = _userid;
    if (uid == null) return;

    await _repository.deleteTask(taskId, uid);

    await NotificationService.instance.cancelTaskReminders(taskId: taskId);

    _task.removeWhere((task) => task.id == taskId);
    notifyListeners();
  }

  Future<void> updatedTask(Taskmodel updatedTask) async {
    // Firestore güncelle
    final uid = _userid;
    if (uid != null) {
      print('Güncellenecek ID: ${updatedTask.id}');
      await _repository.updateTask(uid, updatedTask);
      int index = _task.indexWhere((task) => task.id == updatedTask.id);
      if (index != -1) {
        _task[index] = updatedTask;
      }
      notifyListeners();
    }
  }

  //isdone durumunu guncelleme
  Future<void> toggleTaskDone(Taskmodel task) async {
    final uid = _userid;
    final newStatus = !task.isdone;
    await _repository.toogletask(uid!, task);
    task.isdone = newStatus;
    notifyListeners();
  }
}
