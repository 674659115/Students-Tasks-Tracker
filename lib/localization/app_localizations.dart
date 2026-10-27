import 'package:flutter/material.dart';

final ValueNotifier<String> languageNotifier = ValueNotifier('English (US)');

class AppStrings {
  static String get(String key) {
    final lang = languageNotifier.value;
    if (lang.contains('Thai') || lang.contains('ไทย')) {
      return _thai[key] ?? _english[key] ?? key;
    } else if (lang.contains('Español') || lang.contains('Spanish')) {
      return _spanish[key] ?? _english[key] ?? key;
    } else if (lang.contains('Français') || lang.contains('French')) {
      return _french[key] ?? _english[key] ?? key;
    } else if (lang.contains('Deutsch') || lang.contains('German')) {
      return _german[key] ?? _english[key] ?? key;
    } else if (lang.contains('中文') || lang.contains('Chinese')) {
      return _chinese[key] ?? _english[key] ?? key;
    }
    return _english[key] ?? key;
  }

  static const Map<String, String> _english = {
    'welcome_user': 'Welcome, User!',
    'today_tasks': 'TODAY TASKS',
    'weekly_tasks': 'WEEKLY TASKS',
    'my_tasks': 'MY TASKS',
    'complete': 'Complete',
    'out_of': 'OUT\nOF',
    'home': 'Home',
    'courses': 'Courses',
    'calendar': 'Calendar',
    'profile': 'Profile',
    'settings': 'Settings',
    'app_account_settings': 'App & Account Settings',
    'manage_settings_sub': 'Manage password, notifications & preferences',
    'edit_profile': 'Edit Profile',
    'change_password': 'Change Password',
    'privacy_permissions': 'Privacy & Permissions',
    'push_notifications': 'Push Notifications',
    'dark_theme': 'Dark Theme',
    'language': 'Language',
    'help_faqs': 'Help & FAQs',
    'about_app': 'About App',
    'sign_out': 'Sign Out',
    'add_task': 'ADD TASK',
    'create_task': 'CREATE TASK',
    'cancel': 'CANCEL',
    'task_title': 'TASK TITLE',
    'courses_label': 'COURSES',
    'date_label': 'DATE',
    'priority': 'PRIORITY',
    'low': 'LOW',
    'medium': 'MEDIUM',
    'high': 'HIGH',
    'upcoming_deadline': 'UPCOMING DEADLINE',
    'add_event': 'Add Event',
    'notifications': 'Notifications',
    'manage_profile': 'Manage your Profile',
    'add_course': 'Add Course',
    'active_courses': 'Active Courses',
    'progress': 'Progress',
    'assignment': 'Assignment',
    'test': 'Test',
    'total': 'Total',
    'task_completion_rate': 'TASK COMPLETION RATE',
    'weekly_productivity': 'WEEKLY PRODUCTIVITY',
    'task_by_course': 'TASK BY COURSE',
  };

  static const Map<String, String> _thai = {
    'welcome_user': 'ยินดีต้อนรับ, คุณผู้ใช้!',
    'today_tasks': 'งานประจำวันนี้',
    'weekly_tasks': 'งานประจำสัปดาห์',
    'my_tasks': 'รายการงานของฉัน',
    'complete': 'เสร็จสมบูรณ์',
    'out_of': 'จาก\nทั้งหมด',
    'home': 'หน้าแรก',
    'courses': 'รายวิชา',
    'calendar': 'ปฏิทิน',
    'profile': 'โปรไฟล์',
    'settings': 'การตั้งค่า',
    'app_account_settings': 'การตั้งค่าแอปและบัญชี',
    'manage_settings_sub': 'จัดการรหัสผ่าน การแจ้งเตือน และตัวเลือก',
    'edit_profile': 'แก้ไขโปรไฟล์',
    'change_password': 'เปลี่ยนรหัสผ่าน',
    'privacy_permissions': 'ความเป็นส่วนตัวและการอนุญาต',
    'push_notifications': 'การแจ้งเตือนพุช',
    'dark_theme': 'โหมดมืด (Dark Theme)',
    'language': 'ภาษา (Language)',
    'help_faqs': 'ช่วยเหลือและคำถามที่พบบ่อย',
    'about_app': 'เกี่ยวกับแอปพลิเคชัน',
    'sign_out': 'ออกจากระบบ',
    'add_task': 'เพิ่มงานใหม่',
    'create_task': 'สร้างงาน',
    'cancel': 'ยกเลิก',
    'task_title': 'ชื่อหัวข้องาน',
    'courses_label': 'รายวิชา',
    'date_label': 'วันที่กำหนดส่ง',
    'priority': 'ระดับความสำคัญ',
    'low': 'ต่ำ',
    'medium': 'ปานกลาง',
    'high': 'สูง',
    'upcoming_deadline': 'กำหนดส่งที่กำลังจะมาถึง',
    'add_event': 'เพิ่มกิจกรรม',
    'notifications': 'การแจ้งเตือน',
    'manage_profile': 'จัดการโปรไฟล์ของคุณ',
    'add_course': 'เพิ่มรายวิชา',
    'active_courses': 'รายวิชาที่เรียนอยู่',
    'progress': 'ความคืบหน้า',
    'assignment': 'การบ้าน/การมอบหมาย',
    'test': 'แบบทดสอบ',
    'total': 'รวมทั้งหมด',
    'task_completion_rate': 'อัตราการทำงานเสร็จสมบูรณ์',
    'weekly_productivity': 'ประสิทธิภาพประจำสัปดาห์',
    'task_by_course': 'สัดส่วนงานตามรายวิชา',
  };

  static const Map<String, String> _spanish = {
    'welcome_user': '¡Bienvenido, Usuario!',
    'today_tasks': 'TAREAS DE HOY',
    'weekly_tasks': 'TAREAS SEMANALES',
    'my_tasks': 'MIS TAREAS',
    'complete': 'Completado',
    'out_of': 'DE',
    'home': 'Inicio',
    'courses': 'Cursos',
    'calendar': 'Calendario',
    'profile': 'Perfil',
    'settings': 'Ajustes',
    'change_password': 'Cambiar contraseña',
    'push_notifications': 'Notificaciones',
    'dark_theme': 'Modo oscuro',
    'language': 'Idioma',
    'add_task': 'AÑADIR TAREA',
    'upcoming_deadline': 'PRÓXIMAS ENTREGAS',
  };

  static const Map<String, String> _french = {
    'welcome_user': 'Bienvenue, Utilisateur!',
    'today_tasks': 'TÂCHES DU JOUR',
    'weekly_tasks': 'TÂCHES DE LA SEMAINE',
    'my_tasks': 'MES TÂCHES',
    'complete': 'Terminé',
    'home': 'Accueil',
    'courses': 'Cours',
    'calendar': 'Calendrier',
    'profile': 'Profil',
    'settings': 'Paramètres',
  };

  static const Map<String, String> _german = {
    'welcome_user': 'Willkommen, Benutzer!',
    'today_tasks': 'HEUTIGE AUFGABEN',
    'weekly_tasks': 'WOCHENAUFGABEN',
    'my_tasks': 'MEINE AUFGABEN',
    'complete': 'Erledigt',
    'home': 'Start',
    'courses': 'Kurse',
    'calendar': 'Kalender',
    'profile': 'Profil',
    'settings': 'Einstellungen',
  };

  static const Map<String, String> _chinese = {
    'welcome_user': '欢迎，用户！',
    'today_tasks': '今日任务',
    'weekly_tasks': '本周任务',
    'my_tasks': '我的任务',
    'complete': '已完成',
    'home': '首页',
    'courses': '课程',
    'calendar': '日历',
    'profile': '个人中心',
    'settings': '设置',
  };
}
