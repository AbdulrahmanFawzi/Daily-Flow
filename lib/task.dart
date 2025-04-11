class Task {
  String title;
  bool completed;
  String? description;
  DateTime? dueDate;
  DateTime createdAt;
  
  Task({
    required this.title, 
    required this.completed,
    this.description,
    this.dueDate,
    required this.createdAt,
  });
  
  // Convert Task to Map for storage
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'completed': completed,
      'description': description,
      'dueDate': dueDate?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }
  
  // Create Task from Map when loading from storage
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      title: map['title'],
      completed: map['completed'] ?? false,
      description: map['description'],
      dueDate: map['dueDate'] != null ? DateTime.parse(map['dueDate']) : null,
      createdAt: map['createdAt'] != null ? 
                 DateTime.parse(map['createdAt']) : 
                 DateTime.now(),
    );
  }
}