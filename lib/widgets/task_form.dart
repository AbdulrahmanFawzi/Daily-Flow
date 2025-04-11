import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';

class TaskForm extends StatefulWidget {
  final Function? onTaskAdded;
  final int? editIndex;
  final String? initialTitle;
  final String? initialDescription;
  final DateTime? initialDueDate;

  const TaskForm({
    super.key,
    this.onTaskAdded,
    this.editIndex,
    this.initialTitle,
    this.initialDescription,
    this.initialDueDate,
  });

  @override
  _TaskFormState createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? _selectedDate;
  bool get isEditing => widget.editIndex != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      _titleController.text = widget.initialTitle ?? '';
      _descriptionController.text = widget.initialDescription ?? '';
      _selectedDate = widget.initialDueDate;
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isEditing ? 'Edit Task' : 'Add New Task',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
          const SizedBox(height: 16),
          // Title field
          Container(
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: InputBorder.none,
                prefixIcon: Icon(Icons.edit, color: Colors.blueAccent),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Description field
          Container(
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Description (optional)',
                border: InputBorder.none,
                prefixIcon: Icon(Icons.description, color: Colors.blueAccent),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Due date picker
          ListTile(
            leading: const Icon(Icons.calendar_today, color: Colors.blueAccent),
            title: Text(_selectedDate == null 
                ? 'Set due date (optional)' 
                : 'Due: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'),
            tileColor: Colors.blue.shade50,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            onTap: () => _selectDate(context),
          ),
          const SizedBox(height: 20),
          // Submit button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                if (_titleController.text.isNotEmpty) {
                  if (isEditing) {
                    taskProvider.updateTask(
                      widget.editIndex!,
                      title: _titleController.text,
                      description: _descriptionController.text.isEmpty ? null : _descriptionController.text,
                      dueDate: _selectedDate,
                    );
                  } else {
                    taskProvider.addTask(
                      _titleController.text,
                      description: _descriptionController.text.isEmpty ? null : _descriptionController.text,
                      dueDate: _selectedDate,
                    );
                  }
                  if (widget.onTaskAdded != null) {
                    widget.onTaskAdded!();
                  }
                }
              },
              icon: Icon(isEditing ? Icons.save : Icons.add),
              label: Text(isEditing ? 'Save Changes' : 'Add Task'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}