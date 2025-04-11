import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';

class FilterBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final currentFilter = taskProvider.currentFilter;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildFilterButton(
            context: context,
            label: 'All',
            filter: 'all',
            isActive: currentFilter == 'all',
            onTap: () => taskProvider.setFilter('all'),
          ),
          _buildFilterButton(
            context: context,
            label: 'Active',
            filter: 'active',
            isActive: currentFilter == 'active',
            onTap: () => taskProvider.setFilter('active'),
          ),
          _buildFilterButton(
            context: context,
            label: 'Completed',
            filter: 'completed',
            isActive: currentFilter == 'completed',
            onTap: () => taskProvider.setFilter('completed'),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton({
    required BuildContext context,
    required String label,
    required String filter,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? Colors.blueAccent : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.blueAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}