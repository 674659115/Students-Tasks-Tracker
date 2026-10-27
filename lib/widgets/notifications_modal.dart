import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class NotificationItem {
  final String id;
  final String title;
  final String course;
  final String dueTime;
  final String priority;
  final Color priorityColor;
  final bool isUrgent;
  bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.course,
    required this.dueTime,
    required this.priority,
    required this.priorityColor,
    required this.isUrgent,
    this.isRead = false,
  });
}

void showNotificationsModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const NotificationsModalContent(),
  );
}

class NotificationsModalContent extends StatefulWidget {
  const NotificationsModalContent({super.key});

  @override
  State<NotificationsModalContent> createState() =>
      _NotificationsModalContentState();
}

class _NotificationsModalContentState extends State<NotificationsModalContent> {
  final List<NotificationItem> _notifications = [
    NotificationItem(
      id: '1',
      title: 'IoT & Mobile App Project',
      course: 'IoT & Mobile App Dev',
      dueTime: 'Due Today 23:59',
      priority: 'HIGH',
      priorityColor: AppColors.priorityHigh,
      isUrgent: true,
    ),
    NotificationItem(
      id: '2',
      title: 'Control System Homework 3',
      course: 'Control System Engineering',
      dueTime: 'Due Today 23:59',
      priority: 'LOW',
      priorityColor: AppColors.priorityLow,
      isUrgent: true,
    ),
    NotificationItem(
      id: '3',
      title: 'Electronics Lab Prep',
      course: 'Electronic Engineering',
      dueTime: 'Due Tomorrow 23:59',
      priority: 'MEDIUM',
      priorityColor: AppColors.priorityMedium,
      isUrgent: false,
    ),
    NotificationItem(
      id: '4',
      title: 'MidTerm Exam - Eng A+',
      course: 'English Comm. A+',
      dueTime: 'Due in 2 days (13:30)',
      priority: 'HIGH',
      priorityColor: AppColors.priorityHigh,
      isUrgent: false,
    ),
    NotificationItem(
      id: '5',
      title: 'Data Structures Quiz 2',
      course: 'Data Structures & Algorithms',
      dueTime: 'Due Sep 16 (11:00)',
      priority: 'MEDIUM',
      priorityColor: AppColors.priorityMedium,
      isUrgent: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDarkMode(context);
    final cardBg = isDark ? AppColors.cardBgDark : Colors.white;
    final textPrimary = isDark ? AppColors.textLight : const Color(0xFF0F172A);

    final unreadCount = _notifications.where((n) => !n.isRead).length;

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundDark : AppColors.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          // Drag Handle
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      'Notifications',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: textPrimary,
                      ),
                    ),
                    if (unreadCount > 0) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '$unreadCount New',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      for (var n in _notifications) {
                        n.isRead = true;
                      }
                    });
                  },
                  child: const Text('Mark all as read'),
                ),
              ],
            ),
          ),
          const Divider(),

          // Notification Cards List
          Expanded(
            child: _notifications.isEmpty
                ? Center(
                    child: Text(
                      'No upcoming task notifications!',
                      style: TextStyle(
                        fontSize: 15,
                        color: isDark ? AppColors.textMutedDark : AppColors.textMuted,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    itemCount: _notifications.length,
                    itemBuilder: (context, index) {
                      final item = _notifications[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: cardBg,
                          borderRadius: BorderRadius.circular(20),
                          border: item.isUrgent
                              ? Border.all(
                                  color: Colors.redAccent.withValues(alpha: 0.5),
                                  width: 1.5,
                                )
                              : null,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: item.priorityColor.withValues(alpha: 0.15),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                item.isUrgent
                                    ? Icons.warning_amber_rounded
                                    : Icons.alarm_outlined,
                                color: item.priorityColor,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          item.title,
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: textPrimary,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 3,
                                        ),
                                        decoration: BoxDecoration(
                                          color: item.priorityColor,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          item.priority,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item.course,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: isDark
                                          ? AppColors.textMutedDark
                                          : const Color(0xFF64748B),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item.dueTime,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: item.isUrgent
                                          ? Colors.redAccent
                                          : AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.close_rounded,
                                size: 18,
                                color: Color(0xFF94A3B8),
                              ),
                              onPressed: () {
                                setState(() {
                                  _notifications.removeAt(index);
                                });
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
