// Task Tile Widget
// Displays an individual task with its details
import 'package:flutter/material.dart';
import 'package:to_do_list/screens/task_detail_screen.dart';
import 'package:to_do_list/task.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  final int index;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const TaskTile({
    super.key,
    required this.task,
    required this.index,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    // Format due date if available
    String? dueDateText;
    if (task.dueDate != null) {
      dueDateText = '${task.dueDate!.day}/${task.dueDate!.month}/${task.dueDate!.year}';
    }
    
    // Check if task is overdue
    final bool isOverdue = task.dueDate != null && 
                           task.dueDate!.isBefore(DateTime.now()) &&
                           !task.completed;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isOverdue ? 
              BorderSide(color: Colors.red.shade300, width: 1.5) : 
              BorderSide.none,
      ),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => TaskDetailScreen(
                task: task,
                index: index,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          children: [
            ListTile(
              title: Text(
                task.title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  decoration: task.completed ? TextDecoration.lineThrough : null,
                ),
              ),
              subtitle: task.description != null || task.dueDate != null ? 
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (task.description != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        task.description!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    if (task.dueDate != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.event,
                            size: 14,
                            color: isOverdue ? Colors.red : Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            dueDateText!,
                            style: TextStyle(
                              color: isOverdue ? Colors.red : Colors.grey,
                              fontWeight: isOverdue ? FontWeight.bold : null,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ) : null,
              leading: Checkbox(
                value: task.completed,
                activeColor: Colors.blueAccent,
                onChanged: (_) => onToggle(),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.redAccent),
                onPressed: onDelete,
              ),
            ),
          ],
        ),
      ),
    );
  }
}