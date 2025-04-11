import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list/task.dart';
import '../providers/task_provider.dart';
import '../widgets/task_form.dart';

class TaskDetailScreen extends StatelessWidget {
  final Task task;
  final int index;

  const TaskDetailScreen({
    super.key,
    required this.task,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    
    // Format dates
    final String createdDate = '${task.createdAt.day}/${task.createdAt.month}/${task.createdAt.year}';
    final String? dueDate = task.dueDate != null ? 
                           '${task.dueDate!.day}/${task.dueDate!.month}/${task.dueDate!.year}' : 
                           null;
    
    // Check if task is overdue
    final bool isOverdue = task.dueDate != null && 
                          task.dueDate!.isBefore(DateTime.now()) &&
                          !task.completed;

    void _showEditTaskModal() {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: TaskForm(
            editIndex: index,
            initialTitle: task.title,
            initialDescription: task.description,
            initialDueDate: task.dueDate,
            onTaskAdded: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Task updated successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.pop(context);
            },
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Details'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _showEditTaskModal,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status indicator
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: task.completed ? Colors.green : (isOverdue ? Colors.red : Colors.orange),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                task.completed ? 'Completed' : (isOverdue ? 'Overdue' : 'Pending'),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // Title
            Text(
              task.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            
            // Description
            if (task.description != null) ...[
              const Text(
                'Description:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  task.description!,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 20),
            ],
            
            // Dates
            Row(
              children: [
                Expanded(
                  child: _buildInfoCard(
                    title: 'Created on',
                    value: createdDate,
                    icon: Icons.event_available,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildInfoCard(
                    title: 'Due date',
                    value: dueDate ?? 'Not set',
                    icon: Icons.event,
                    isAlert: isOverdue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            
            // Action buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      taskProvider.toggleTask(index);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(task.completed ? 'Task marked as incomplete' : 'Task marked as complete'),
                          backgroundColor: task.completed ? Colors.orange : Colors.green,
                        ),
                      );
                    },
                    icon: Icon(task.completed ? Icons.close : Icons.check),
                    label: Text(task.completed ? 'Mark as Incomplete' : 'Mark as Complete'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: task.completed ? Colors.orange : Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      taskProvider.removeTask(index);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Task deleted!'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    },
                    icon: const Icon(Icons.delete),
                    label: const Text('Delete Task'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String value,
    required IconData icon,
    bool isAlert = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isAlert ? Colors.red.shade50 : Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isAlert ? Colors.red : Colors.blueAccent,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                icon,
                color: isAlert ? Colors.red : Colors.blueAccent,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isAlert ? FontWeight.bold : FontWeight.normal,
                    color: isAlert ? Colors.red : null,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}