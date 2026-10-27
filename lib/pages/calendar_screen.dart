import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/header_bar.dart';

class CalendarDeadline {
  final String id;
  final String month;
  final int day;
  final String title;
  final String course;
  final String time;
  final String priority;
  final Color dotColor;

  CalendarDeadline({
    required this.id,
    required this.month,
    required this.day,
    required this.title,
    required this.course,
    required this.time,
    required this.priority,
    required this.dotColor,
  });
}

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final List<CalendarDeadline> _deadlines = [
    CalendarDeadline(
      id: '1',
      month: 'Sep',
      day: 7,
      title: 'Coding Project',
      course: 'IoT & Mobile App',
      time: '8:30',
      priority: 'MEDIUM',
      dotColor: AppColors.priorityMedium,
    ),
    CalendarDeadline(
      id: '2',
      month: 'Sep',
      day: 8,
      title: 'MidTerm Exam',
      course: 'Eng A+',
      time: '13:30',
      priority: 'HIGH',
      dotColor: AppColors.priorityHigh,
    ),
    CalendarDeadline(
      id: '3',
      month: 'Sep',
      day: 9,
      title: 'Presentation',
      course: 'Control System',
      time: '10:00',
      priority: 'LOW',
      dotColor: AppColors.priorityLow,
    ),
    CalendarDeadline(
      id: '4',
      month: 'Sep',
      day: 11,
      title: 'Lab Report',
      course: 'Electronic Engineering',
      time: '16:00',
      priority: 'HIGH',
      dotColor: AppColors.priorityHigh,
    ),
    CalendarDeadline(
      id: '5',
      month: 'Sep',
      day: 16,
      title: 'Quiz 2',
      course: 'Data Structures',
      time: '11:00',
      priority: 'MEDIUM',
      dotColor: AppColors.priorityMedium,
    ),
  ];

  Color? _getDotForDay(int dayNumber) {
    final matches = _deadlines.where((d) => d.day == dayNumber).toList();
    if (matches.isEmpty) return null;
    return matches.first.dotColor;
  }

  void _deleteDeadline(String id) {
    setState(() {
      _deadlines.removeWhere((d) => d.id == id);
    });
  }

  void _showAddEventDialog() {
    final titleController = TextEditingController();
    final courseController = TextEditingController(text: 'IoT & Mobile App');
    final timeController = TextEditingController(text: '14:00');
    int selectedDay = DateTime.now().day;
    String selectedPriority = 'HIGH';
    Color selectedColor = AppColors.priorityHigh;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              title: const Text(
                'Add Calendar Deadline',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: 'Title (e.g. Exam, Assignment)',
                        hintText: 'Enter title',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: courseController,
                      decoration: const InputDecoration(
                        labelText: 'Course Name',
                        hintText: 'Enter course name',
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<int>(
                            initialValue: selectedDay,
                            decoration: const InputDecoration(labelText: 'Day (Sep)'),
                            items: List.generate(30, (i) => i + 1).map((d) {
                              return DropdownMenuItem<int>(
                                value: d,
                                child: Text('Sep $d'),
                              );
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) {
                                setDialogState(() {
                                  selectedDay = val;
                                });
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: timeController,
                            decoration: const InputDecoration(
                              labelText: 'Time (e.g. 14:30)',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Priority Level:',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _buildPriorityChip(
                          label: 'LOW',
                          color: AppColors.priorityLow,
                          isSelected: selectedPriority == 'LOW',
                          onTap: () {
                            setDialogState(() {
                              selectedPriority = 'LOW';
                              selectedColor = AppColors.priorityLow;
                            });
                          },
                        ),
                        const SizedBox(width: 8),
                        _buildPriorityChip(
                          label: 'MEDIUM',
                          color: AppColors.priorityMedium,
                          isSelected: selectedPriority == 'MEDIUM',
                          onTap: () {
                            setDialogState(() {
                              selectedPriority = 'MEDIUM';
                              selectedColor = AppColors.priorityMedium;
                            });
                          },
                        ),
                        const SizedBox(width: 8),
                        _buildPriorityChip(
                          label: 'HIGH',
                          color: AppColors.priorityHigh,
                          isSelected: selectedPriority == 'HIGH',
                          onTap: () {
                            setDialogState(() {
                              selectedPriority = 'HIGH';
                              selectedColor = AppColors.priorityHigh;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (titleController.text.isNotEmpty) {
                      setState(() {
                        _deadlines.insert(
                          0,
                          CalendarDeadline(
                            id: DateTime.now().millisecondsSinceEpoch.toString(),
                            month: 'Sep',
                            day: selectedDay,
                            title: titleController.text.trim(),
                            course: courseController.text.trim(),
                            time: timeController.text.trim(),
                            priority: selectedPriority,
                            dotColor: selectedColor,
                          ),
                        );
                      });
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Add Event'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildPriorityChip({
    required String label,
    required Color color,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color : color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : color,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDarkMode(context);
    final cardBg = isDark ? AppColors.cardBgDark : Colors.white;
    final textPrimary = isDark ? AppColors.textLight : const Color(0xFF0F172A);

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 90),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  const HeaderBar(title: 'CALENDAR'),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'SEPTEMBER 2026',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: isDark
                                ? AppColors.textMutedDark
                                : const Color(0xFF94A3B8),
                            letterSpacing: 1.0,
                          ),
                        ),
                        GestureDetector(
                          onTap: _showAddEventDialog,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: const [
                                Icon(Icons.add, color: Colors.white, size: 16),
                                SizedBox(width: 4),
                                Text(
                                  'Add Event',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Calendar Grid Container
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Table(
                      border: TableBorder.all(
                        color: isDark
                            ? const Color(0xFF334155)
                            : const Color(0xFFCBD5E1),
                        width: 1,
                      ),
                      children: [
                        // Day of week header row
                        TableRow(
                          decoration: const BoxDecoration(
                            color: Color(0xFF1E293B),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                            ),
                          ),
                          children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
                              .map((d) => Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 10),
                                    child: Center(
                                      child: Text(
                                        d,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ),
                        // Row 1
                        _buildCalendarRow([
                          {'day': '7', 'dot': _getDotForDay(7)},
                          {'day': '8', 'dot': _getDotForDay(8)},
                          {'day': '9', 'dot': _getDotForDay(9)},
                          {'day': '10', 'dot': _getDotForDay(10)},
                          {'day': '11', 'dot': _getDotForDay(11)},
                          {'day': '12', 'dot': _getDotForDay(12)},
                          {'day': '13', 'dot': _getDotForDay(13)},
                        ], cardBg, textPrimary, isDark),
                        // Row 2
                        _buildCalendarRow([
                          {'day': '14', 'dot': _getDotForDay(14)},
                          {'day': '15', 'dot': _getDotForDay(15)},
                          {'day': '16', 'dot': _getDotForDay(16)},
                          {'day': '17', 'dot': _getDotForDay(17)},
                          {'day': '18', 'dot': _getDotForDay(18)},
                          {'day': '19', 'dot': _getDotForDay(19)},
                          {'day': '20', 'dot': _getDotForDay(20)},
                        ], cardBg, textPrimary, isDark),
                        // Row 3
                        _buildCalendarRow([
                          {'day': '21', 'dot': _getDotForDay(21)},
                          {'day': '22', 'dot': _getDotForDay(22)},
                          {'day': '23', 'dot': _getDotForDay(23)},
                          {'day': '24', 'dot': _getDotForDay(24)},
                          {'day': '25', 'dot': _getDotForDay(25)},
                          {'day': '26', 'dot': _getDotForDay(26)},
                          {'day': '27', 'dot': _getDotForDay(27)},
                        ], cardBg, textPrimary, isDark),
                        // Row 4
                        _buildCalendarRow([
                          {'day': '29', 'dot': _getDotForDay(29)},
                          {'day': '30', 'dot': _getDotForDay(30)},
                          {'day': '1', 'dot': null, 'isNext': true},
                          {'day': '2', 'dot': null, 'isNext': true},
                          {'day': '3', 'dot': null, 'isNext': true},
                          {'day': '4', 'dot': null, 'isNext': true},
                          {'day': '5', 'dot': null, 'isNext': true},
                        ], cardBg, textPrimary, isDark),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // UPCOMING DEADLINE Header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'UPCOMING DEADLINE',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                        color: textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Upcoming Deadline Cards List
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: _deadlines.map((item) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildDeadlineCard(
                            item: item,
                            cardBg: cardBg,
                            textPrimary: textPrimary,
                            isDark: isDark,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  TableRow _buildCalendarRow(
      List<Map<String, dynamic>> days, Color cardBg, Color textPrimary, bool isDark) {
    return TableRow(
      children: days.map((data) {
        bool isNext = data['isNext'] == true;
        Color? dotColor = data['dot'] as Color?;
        final bgColor = isNext
            ? (isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9))
            : cardBg;

        return Container(
          height: 48,
          alignment: Alignment.center,
          color: bgColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                data['day'] as String,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: isNext
                      ? (isDark ? AppColors.textMutedDark : const Color(0xFF94A3B8))
                      : textPrimary,
                ),
              ),
              if (dotColor != null) ...[
                const SizedBox(height: 2),
                Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: dotColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDeadlineCard({
    required CalendarDeadline item,
    required Color cardBg,
    required Color textPrimary,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Date Column
          Column(
            children: [
              Text(
                item.month,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? AppColors.textMutedDark
                      : const Color(0xFF94A3B8),
                ),
              ),
              Text(
                '${item.day}',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(width: 14),

          // Vertical Divider
          Container(
            width: 3,
            height: 40,
            color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
          ),
          const SizedBox(width: 14),

          // Title & Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: item.dotColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        item.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    text: '${item.course} | ${item.time} | ',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? AppColors.textMutedDark
                          : const Color(0xFF94A3B8),
                    ),
                    children: [
                      TextSpan(
                        text: item.priority,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                          color: item.dotColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Delete Deadline Event
          IconButton(
            icon: const Icon(
              Icons.delete_outline_rounded,
              color: Colors.redAccent,
              size: 22,
            ),
            onPressed: () {
              _deleteDeadline(item.id);
            },
          ),
        ],
      ),
    );
  }
}
