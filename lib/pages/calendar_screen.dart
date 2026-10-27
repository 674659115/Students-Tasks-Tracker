import 'package:flutter/material.dart';
import '../localization/app_localizations.dart';
import '../theme/app_theme.dart';
import '../widgets/header_bar.dart';

class CalendarDeadline {
  final String id;
  final String month;
  final int monthNumber;
  final int year;
  final int day;
  final String title;
  final String course;
  final String time;
  final String priority;
  final Color dotColor;

  CalendarDeadline({
    required this.id,
    required this.month,
    required this.monthNumber,
    required this.year,
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
  DateTime _focusedMonth = DateTime(2026, 9, 1);

  final List<CalendarDeadline> _deadlines = [
    CalendarDeadline(
      id: '1',
      month: 'Sep',
      monthNumber: 9,
      year: 2026,
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
      monthNumber: 9,
      year: 2026,
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
      monthNumber: 9,
      year: 2026,
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
      monthNumber: 9,
      year: 2026,
      day: 11,
      title: 'Lab Report',
      course: 'Electronic Engineering',
      time: '16:00',
      priority: 'HIGH',
      dotColor: AppColors.priorityHigh,
    ),
    CalendarDeadline(
      id: '5',
      month: 'Oct',
      monthNumber: 10,
      year: 2026,
      day: 15,
      title: 'Database Quiz',
      course: 'Database Management',
      time: '14:00',
      priority: 'HIGH',
      dotColor: AppColors.priorityHigh,
    ),
    CalendarDeadline(
      id: '6',
      month: 'Oct',
      monthNumber: 10,
      year: 2026,
      day: 22,
      title: 'AI Presentation',
      course: 'Artificial Intelligence',
      time: '11:00',
      priority: 'MEDIUM',
      dotColor: AppColors.priorityMedium,
    ),
  ];

  static const List<String> _monthNames = [
    'JANUARY',
    'FEBRUARY',
    'MARCH',
    'APRIL',
    'MAY',
    'JUNE',
    'JULY',
    'AUGUST',
    'SEPTEMBER',
    'OCTOBER',
    'NOVEMBER',
    'DECEMBER'
  ];

  static const List<String> _monthShortNames = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];

  Color? _getDotForDay(int dayNumber) {
    final matches = _deadlines.where((d) =>
        d.day == dayNumber &&
        d.monthNumber == _focusedMonth.month &&
        d.year == _focusedMonth.year).toList();
    if (matches.isEmpty) return null;
    return matches.first.dotColor;
  }

  void _deleteDeadline(String id) {
    setState(() {
      _deadlines.removeWhere((d) => d.id == id);
    });
  }

  void _changeMonth(int offset) {
    setState(() {
      _focusedMonth = DateTime(
        _focusedMonth.year,
        _focusedMonth.month + offset,
        1,
      );
    });
  }

  void _showAddEventDialog() {
    final titleController = TextEditingController();
    final courseController = TextEditingController(text: 'IoT & Mobile App');
    final timeController = TextEditingController(text: '14:00');
    int selectedDay = 15;
    String selectedPriority = 'HIGH';
    Color selectedColor = AppColors.priorityHigh;

    int maxDays = DateTime(_focusedMonth.year, _focusedMonth.month + 1, 0).day;
    if (selectedDay > maxDays) selectedDay = maxDays;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              title: Text(
                '${AppStrings.get('add_event')} (${_monthShortNames[_focusedMonth.month - 1]} ${_focusedMonth.year})',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
                            decoration: const InputDecoration(labelText: 'Day'),
                            items: List.generate(maxDays, (i) => i + 1).map((d) {
                              return DropdownMenuItem<int>(
                                value: d,
                                child: Text('$d ${_monthShortNames[_focusedMonth.month - 1]}'),
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
                    Text(
                      '${AppStrings.get('priority')}:',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _buildPriorityChip(
                          label: AppStrings.get('low'),
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
                          label: AppStrings.get('medium'),
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
                          label: AppStrings.get('high'),
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
                  child: Text(AppStrings.get('cancel')),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (titleController.text.isNotEmpty) {
                      setState(() {
                        _deadlines.insert(
                          0,
                          CalendarDeadline(
                            id: DateTime.now().millisecondsSinceEpoch.toString(),
                            month: _monthShortNames[_focusedMonth.month - 1],
                            monthNumber: _focusedMonth.month,
                            year: _focusedMonth.year,
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
                  child: Text(AppStrings.get('add_event')),
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

  List<TableRow> _buildCalendarTableRows(Color cardBg, Color textPrimary, bool isDark) {
    int daysInMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1, 0).day;
    int firstWeekday = DateTime(_focusedMonth.year, _focusedMonth.month, 1).weekday; // 1 = Mon, 7 = Sun

    List<TableRow> rows = [];

    // Header Row
    rows.add(
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
                  padding: const EdgeInsets.symmetric(vertical: 10),
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
    );

    int dayCounter = 1;
    int prevMonthDays = DateTime(_focusedMonth.year, _focusedMonth.month, 0).day;
    int startOffset = firstWeekday - 1;

    for (int row = 0; row < 5; row++) {
      List<Map<String, dynamic>> cellData = [];
      for (int col = 0; col < 7; col++) {
        int cellIndex = row * 7 + col;
        if (cellIndex < startOffset) {
          int dayNum = prevMonthDays - (startOffset - cellIndex - 1);
          cellData.add({'day': '$dayNum', 'dot': null, 'isNext': true});
        } else if (dayCounter <= daysInMonth) {
          cellData.add({
            'day': '$dayCounter',
            'dot': _getDotForDay(dayCounter),
            'isNext': false,
          });
          dayCounter++;
        } else {
          int nextDayNum = dayCounter - daysInMonth;
          cellData.add({'day': '$nextDayNum', 'dot': null, 'isNext': true});
          dayCounter++;
        }
      }
      rows.add(_buildCalendarRow(cellData, cardBg, textPrimary, isDark));
    }

    return rows;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDarkMode(context);
    final cardBg = isDark ? AppColors.cardBgDark : Colors.white;
    final textPrimary = isDark ? AppColors.textLight : const Color(0xFF0F172A);

    final currentMonthDeadlines = _deadlines
        .where((d) =>
            d.monthNumber == _focusedMonth.month && d.year == _focusedMonth.year)
        .toList();

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
                  HeaderBar(title: AppStrings.get('calendar')),

                  // Month Navigation Row (< SEPTEMBER 2026 >)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.chevron_left_rounded, size: 28),
                              onPressed: () => _changeMonth(-1),
                            ),
                            Text(
                              '${_monthNames[_focusedMonth.month - 1]} ${_focusedMonth.year}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: isDark
                                    ? AppColors.textMutedDark
                                    : const Color(0xFF94A3B8),
                                letterSpacing: 0.8,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.chevron_right_rounded, size: 28),
                              onPressed: () => _changeMonth(1),
                            ),
                          ],
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
                              children: [
                                const Icon(Icons.add, color: Colors.white, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  AppStrings.get('add_event'),
                                  style: const TextStyle(
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
                      children: _buildCalendarTableRows(cardBg, textPrimary, isDark),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // UPCOMING DEADLINE Header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      AppStrings.get('upcoming_deadline'),
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
                    child: currentMonthDeadlines.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Center(
                              child: Text(
                                'No deadlines scheduled for ${_monthNames[_focusedMonth.month - 1]}!',
                                style: TextStyle(
                                  color: isDark
                                      ? AppColors.textMutedDark
                                      : AppColors.textMuted,
                                ),
                              ),
                            ),
                          )
                        : Column(
                            children: currentMonthDeadlines.map((item) {
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
