import 'package:flutter/material.dart';
import '../services/fetch_reminders_service.dart';
import '../widgets/custom_bottom_bar.dart';

class RemainderScreen extends StatefulWidget {
  const RemainderScreen({super.key});

  @override
  State<RemainderScreen> createState() => _RemainderScreenState();
}

class _RemainderScreenState extends State<RemainderScreen> {
  late Future<List<Map<String, dynamic>>> _remindersFuture;

  @override
  void initState() {
    super.initState();
    _remindersFuture = FetchRemindersService.fetchReminders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF6EE),
      appBar: AppBar(
        backgroundColor: const Color(0xFFEFF6EE),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/home');
          },
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _remindersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error: ${snapshot.error}",
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text("No reminders found."),
            );
          } else {
            final reminders = snapshot.data!;
            return ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                const SizedBox(height: 16),
                _buildTaskSection(
                  "Today's Tasks",
                  reminders.where((reminder) => reminder['type'] == 'today').toList(),
                  Colors.lightBlue.shade100,
                ),
                const SizedBox(height: 16),
                _buildTaskSection(
                  "Overdue Tasks",
                  reminders.where((reminder) => reminder['type'] == 'overdue').toList(),
                  Colors.red.shade100,
                ),
                const SizedBox(height: 16),
                _buildTaskSection(
                  "Upcoming Tasks",
                  reminders.where((reminder) => reminder['type'] == 'upcoming').toList(),
                  Colors.grey.shade200,
                ),
              ],
            );
          }
        },
      ),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }

  Widget _buildTaskSection(
      String title, List<Map<String, dynamic>> tasks, Color backgroundColor) {
    if (tasks.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Column(
          children: tasks
              .map((task) => ExpandableTaskCard(
            taskTitle: task['title'],
            taskBody: task['body'],
            taskId: task['id'],
            imageUrl: task['imageUrl'],
            backgroundColor: backgroundColor,
          ))
              .toList(),
        ),
      ],
    );
  }
}

class ExpandableTaskCard extends StatefulWidget {
  final String taskTitle;
  final String taskBody;
  final String taskId;
  final String imageUrl; // Add imageUrl property
  final Color backgroundColor;

  const ExpandableTaskCard({
    required this.taskTitle,
    required this.taskBody,
    required this.taskId,
    required this.imageUrl, // Initialize imageUrl
    required this.backgroundColor,
    Key? key,
  }) : super(key: key);

  @override
  State<ExpandableTaskCard> createState() => _ExpandableTaskCardState();
}

class _ExpandableTaskCardState extends State<ExpandableTaskCard> {
  bool isExpanded = false;
  bool isChecked = false; // Track the checkbox state for this task

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isExpanded = !isExpanded;
        });
      },
      child: Card(
        color: widget.backgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Display the image from the backend using imageUrl
                  CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 34,
                    backgroundImage: NetworkImage(widget.imageUrl),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.taskTitle,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text(
                          widget.taskBody,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  Checkbox(
                    value: isChecked,
                    onChanged: (value) {
                      setState(() {
                        isChecked = value ?? false;
                      });
                    },
                  ),
                ],
              ),
              if (isExpanded) ...[
                const SizedBox(height: 8),
                const Text(
                  "Additional Tip: Water at the base of the plant and avoid getting water on the leaves to prevent rot or fungal issues.",
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Environmental Impact Notes: Bright sunlight detected today. Ensure the succulent gets ample light but move it to indirect light if the leaves appear scorched or discolored.",
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Handle snooze logic
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlueAccent,
                      ),
                      child: const Text("Snooze"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Handle plant profile logic
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.greenAccent,
                      ),
                      child: const Text("Plant Profile"),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
