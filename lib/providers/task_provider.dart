
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../task.dart';

class TaskProvider extends ChangeNotifier {
  List<Task> _tasks = [];
  List<Task> get tasks => _tasks;
  
  // Filter options
  String _currentFilter = 'all'; // all, active, completed
  String get currentFilter => _currentFilter;
  
  // Getter for filtered tasks
  List<Task> get filteredTasks {
    switch (_currentFilter) {
      case 'active':
        return _tasks.where((task) => !task.completed).toList();
      case 'completed':
        return _tasks.where((task) => task.completed).toList();
      default:
        return _tasks;
    }
  }

  TaskProvider() {
    _loadTasks();
  }

  void addTask(String title, {String? description, DateTime? dueDate}) {
    _tasks.add(Task(
      title: title, 
      completed: false,
      description: description,
      dueDate: dueDate,
      createdAt: DateTime.now(),
    ));
    _saveTasks();
    notifyListeners();
  }

  void toggleTask(int index) {
    final taskIndex = _getActualIndex(index);
    _tasks[taskIndex].completed = !_tasks[taskIndex].completed;
    _saveTasks();
    notifyListeners();
  }

  void removeTask(int index) {
    final taskIndex = _getActualIndex(index);
    _tasks.removeAt(taskIndex);
    _saveTasks();
    notifyListeners();
  }
  
  void updateTask(int index, {String? title, String? description, DateTime? dueDate}) {
    final taskIndex = _getActualIndex(index);
    if (title != null) _tasks[taskIndex].title = title;
    if (description != null) _tasks[taskIndex].description = description;
    if (dueDate != null) _tasks[taskIndex].dueDate = dueDate;
    _saveTasks();
    notifyListeners();
  }
  
  // Set filter for tasks
  void setFilter(String filter) {
    _currentFilter = filter;
    notifyListeners();
  }
  
  // Get actual index in the full task list from the filtered list index
  int _getActualIndex(int filteredIndex) {
    if (_currentFilter == 'all') return filteredIndex;
    
    final Task targetTask = filteredTasks[filteredIndex];
    return _tasks.indexWhere((task) => 
      task.title == targetTask.title && 
      task.createdAt == targetTask.createdAt
    );
  }

  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> taskMaps = _tasks.map((task) => task.toMap()).toList();
    prefs.setString('tasks', jsonEncode(taskMaps));
  }

  Future<void> _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? tasksString = prefs.getString('tasks');
    if (tasksString != null) {
      final List<dynamic> decoded = jsonDecode(tasksString);
      _tasks = decoded.map((item) => Task.fromMap(item)).toList();
      notifyListeners();
    }
  }
}