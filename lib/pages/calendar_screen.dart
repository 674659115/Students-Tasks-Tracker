import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/header_bar.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 90),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              const HeaderBar(title: 'CALENDAR'),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'SEPTEMBER',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF94A3B8),
                    letterSpacing: 1.0,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Calendar Grid Container
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
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
                    color: const Color(0xFFCBD5E1),
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
                      {'day': '7', 'dot': AppColors.priorityMedium},
                      {'day': '8', 'dot': AppColors.priorityHigh},
                      {'day': '9', 'dot': AppColors.priorityLow},
                      {'day': '10', 'dot': null},
                      {'day': '11', 'dot': AppColors.priorityHigh},
                      {'day': '12', 'dot': null},
                      {'day': '13', 'dot': null},
                    ]),
                    // Row 2
                    _buildCalendarRow([
                      {'day': '14', 'dot': null},
                      {'day': '15', 'dot': AppColors.priorityLow},
                      {'day': '16', 'dot': AppColors.priorityMedium},
                      {'day': '17', 'dot': AppColors.priorityLow},
                      {'day': '18', 'dot': null},
                      {'day': '19', 'dot': null},
                      {'day': '20', 'dot': null},
                    ]),
                    // Row 3
                    _buildCalendarRow([
                      {'day': '21', 'dot': AppColors.priorityMedium},
                      {'day': '22', 'dot': null},
                      {'day': '23', 'dot': null},
                      {'day': '24', 'dot': AppColors.priorityHigh},
                      {'day': '25', 'dot': null},
                      {'day': '26', 'dot': null},
                      {'day': '27', 'dot': null},
                    ]),
                    // Row 4
                    _buildCalendarRow([
                      {'day': '29', 'dot': AppColors.priorityLow},
                      {'day': '30', 'dot': null},
                      {'day': '1', 'dot': null, 'isNext': true},
                      {'day': '2', 'dot': null, 'isNext': true},
                      {'day': '3', 'dot': null, 'isNext': true},
                      {'day': '4', 'dot': null, 'isNext': true},
                      {'day': '5', 'dot': null, 'isNext': true},
                    ]),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // UPCOMING DEADLINE Header
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'UPCOMING DEADLINE',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Upcoming Deadline Cards List
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _buildDeadlineCard(
                      month: 'Sep',
                      day: '7',
                      title: 'Coding',
                      course: 'IoT & Mobile App',
                      time: '8:30',
                      priority: 'MEDIUM',
                      dotColor: AppColors.priorityMedium,
                    ),
                    const SizedBox(height: 12),
                    _buildDeadlineCard(
                      month: 'Sep',
                      day: '8',
                      title: 'MidTerm Exam',
                      course: 'Eng A+',
                      time: '13:30',
                      priority: 'HIGH',
                      dotColor: AppColors.priorityHigh,
                    ),
                    const SizedBox(height: 12),
                    _buildDeadlineCard(
                      month: 'Sep',
                      day: '9',
                      title: 'Presentation',
                      course: 'Control System',
                      time: '10:00',
                      priority: 'LOW',
                      dotColor: AppColors.priorityLow,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TableRow _buildCalendarRow(List<Map<String, dynamic>> days) {
    return TableRow(
      children: days.map((data) {
        bool isNext = data['isNext'] == true;
        Color? dotColor = data['dot'] as Color?;
        return Container(
          height: 48,
          alignment: Alignment.center,
          color: isNext ? const Color(0xFFF1F5F9) : Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                data['day'] as String,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: isNext
                      ? const Color(0xFF94A3B8)
                      : const Color(0xFF0F172A),
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
    required String month,
    required String day,
    required String title,
    required String course,
    required String time,
    required String priority,
    required Color dotColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
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
                month,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF94A3B8),
                ),
              ),
              Text(
                day,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          const SizedBox(width: 14),

          // Vertical Divider
          Container(
            width: 3,
            height: 40,
            color: const Color(0xFFCBD5E1),
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
                        color: dotColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    text: '$course | $time | ',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF94A3B8),
                    ),
                    children: [
                      TextSpan(
                        text: priority,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                          color: dotColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
