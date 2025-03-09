import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/task_model.dart';

class TaskProvider with ChangeNotifier {
  late Box<Task> _taskBox;

  List<Task> get tasks => _taskBox.values.toList();

  Future<void> initialize() async {
    _taskBox = await Hive.openBox<Task>('tasks');
    notifyListeners();
  }

  Future<void> addTask(String title) async {
    final task = Task(title: title);
    await _taskBox.add(task);
    notifyListeners();
  }

  Future<void> toggleTaskStatus(int index) async {
    final task = _taskBox.getAt(index);
    if (task != null) {
      task.isCompleted = !task.isCompleted;
      await task.save();
      notifyListeners();
    }
  }

  Future<void> removeTask(int index) async {
    await _taskBox.deleteAt(index);
    notifyListeners();
  }

  int get totalTasks => _taskBox.length;
  int get completedTasks =>
      _taskBox.values.where((task) => task.isCompleted).length;
  double get progress =>
      _taskBox.isEmpty ? 0 : (completedTasks / totalTasks) * 100;
}
