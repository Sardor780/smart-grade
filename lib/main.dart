import 'dart:math';
import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:collection/collection.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'firebase_options.dart';

enum AppLanguage { ru, uz, en }

class L10n {
  static const Map<AppLanguage, Map<String, String>> _values = {
    AppLanguage.ru: {
      'title': 'Система оценивания',
      'role_selection': 'Выберите роль',
      'role_desc': 'Создавайте комнаты, принимайте ответы и получайте автооценки.',
      'teacher': 'Я учитель',
      'student': 'Я ученик',
      'create_room': 'Создать комнату',
      'teacher_name': 'Имя учителя *',
      'group_number': 'Номер группы *',
      'group_hint': 'Например: 01-25',
      'room_title': 'Название теста *',
      'title_hint': 'Например: Математика 1-четверть',
      'duration': 'Время на тест (минуты)',
      'questions_label': 'Вопросы и правильные ответы',
      'add_question': 'Добавить вопрос',
      'creating': 'Создание...',
      'create_btn': 'Создать комнату',
      'room_code': 'Код комнаты',
      'room_active': 'Комната активна — ученики могут отправлять ответы',
      'room_closed': 'Комната закрыта — ученики не смогут отправить ответы',
      'open': 'Открыть',
      'close': 'Закрыть',
      'submissions': 'Ответов',
      'avg_grade': 'Средний балл',
      'accuracy': 'Точность',
      'top_students': 'Топ ученики',
      'hard_questions': 'Сложные вопросы',
      'no_data': 'Пока нет данных',
      'no_submissions': 'Пока нет ответов',
      'loading': 'Загрузка...',
      'error': 'Ошибка загрузки',
      'student_name': 'Ваше имя и фамилия *',
      'student_group': 'Ваша группа *',
      'enter_code': 'Код комнаты',
      'join': 'Войти',
      'send_answers': 'Отправить ответы',
      'sending': 'Отправка...',
      'timer': 'Таймер',
      'short_answer': 'Короткий ответ',
      'true_false': 'Правда / Ложь',
      'mcq': 'Тест (1 вариант)',
      'correct_answer': 'Правильный ответ',
      'question_type': 'Тип вопроса',
      'export': 'Экспорт',
      'true': 'Правда',
      'false': 'Ложь',
      'variant': 'Вариант',
      'bulk_import': 'Массовый импорт',
      'bulk_desc': 'Поддерживаются 3 формата:\n1. Текст: Вопрос -> Ответ\n2. Да/Нет: Вопрос -> Правда (или Ложь)\n3. Тест: Вопрос -> Опции через запятую -> Номер (1-4)',
      'import_btn': 'Импортировать',
      'cancel': 'Отмена',
      'brand_name': 'Urganch raqamli texnologiyalar texnikumi',
      'about': 'О системе',
      'about_desc': 'Данная система разработана для автоматизации процесса тестирования и оценивания.',
      'required_fields': 'Пожалуйста, заполните все обязательные поля',
      'question': 'Вопрос',
      'delete': 'Удалить',
      'login': 'Вход для учителей',
      'email': 'Электронная почта',
      'password': 'Пароль',
      'no_account': 'Нет аккаунта? Регистрация',
      'have_account': 'Уже есть аккаунт? Войти',
      'register_btn': 'Зарегистрироваться',
      'login_btn': 'Войти',
      'logout': 'Выйти',
      'my_results': 'Мои результаты',
      'date': 'Дата',
      'cert_title': 'СЕРТИФИКАТ',
      'cert_desc': 'успешного прохождения тестирования',
      'report_title': 'РЕЗУЛЬТАТЫ ТЕСТА',
      'grade_label': 'ОЦЕНКА',
      'correct_label': 'Правильно',
      'percent_label': 'Процент',
      'page_label': 'Страница',
      'of_label': 'из',
      'back': 'Назад',
      'next': 'Далее',
      'finish_test': 'Завершить тест',
      'finish_and_send': 'Завершить и отправить ответы',
      'confirm_finish': 'Завершить тест?',
      'confirm_finish_desc': 'Вы ответили на все вопросы. Отправить результаты?',
      'confirm_delete': 'Вы уверены, что хотите удалить эту комнату?',
      'room_not_found': 'Комната не найдена',
      'all_certs_sent': 'Все сертификаты отправлены на сохранение',
      'full_report': 'Полный отчёт',
      'all_certificates': 'Все сертификаты',
      'my_rooms': 'Мои комнаты',
      'download_cert': 'Скачать сертификат',
      'edit_test': 'Редактировать тест',
      'edit_confirm_title': 'Редактировать тест?',
      'edit_confirm_desc': 'Изменения затронут будущие попытки. Старые результаты не будут автоматически пересчитаны.',
      'save_success': 'Изменения успешно сохранены',
      'continue': 'Продолжить',
      'profile': 'Профиль',
      'save': 'Сохранить',
      'full_name': 'ФИО',
      'photo_uploaded': 'Фото обновлено',
      'upload_error': 'Ошибка загрузки',
      'issued_by': 'Выдано учителем',
      'teacher_label': 'Учитель',
      'already_submitted': 'Вы уже сдавали этот тест. Попросите учителя открыть доступ.',
      'room_closed_entry': 'Кабинет закрыт. Вход только по разрешению учителя.',
      'room_closed_submit': 'Кабинет закрыт — отправка недоступна. Попросите учителя открыть доступ.',
      'individual_access_active': 'Вам открыт персональный доступ — можно сдать тест.',
      'open_access': 'Открыть доступ',
      'close_access': 'Закрыть доступ',
      'reset_attempt': 'Сбросить попытку',
      'attempt_label': 'Попытка',
    },
    AppLanguage.uz: {
      'title': 'Baholash tizimi',
      'role_selection': 'Rolni tanlang',
      'role_desc': 'Xonalar yarating, javoblarni qabul qiling va avtomatik baholarni oling.',
      'teacher': 'Men o\'qituvchiman',
      'student': 'Men o\'quvchiman',
      'create_room': 'Xona yaratish',
      'teacher_name': 'O\'qituvchi ismi *',
      'group_number': 'Guruh raqami *',
      'group_hint': 'Masalan: 01-25',
      'room_title': 'Test nomi *',
      'title_hint': 'Masalan: Matematika 1-chorak',
      'duration': 'Test vaqti (daqiqa)',
      'questions_label': 'Savollar va to\'g\'ri javoblar',
      'add_question': 'Savol qo\'shish',
      'creating': 'Yaratilmoqda...',
      'create_btn': 'Xona yaratish',
      'room_code': 'Xona kodi',
      'room_active': 'Xona faol — o\'quvchilar javob yuborishlari mumkin',
      'room_closed': 'Xona yopiq — o\'quvchilar javob yubora olmaydilar',
      'open': 'Ochish',
      'close': 'Yopish',
      'submissions': 'Javoblar',
      'avg_grade': 'O\'rtacha ball',
      'accuracy': 'Anıqlik',
      'top_students': 'Top o\'quvchilar',
      'hard_questions': 'Qiyin savollar',
      'no_data': 'Ma\'lumot yo\'q',
      'no_submissions': 'Hozircha javoblar yo\'q',
      'loading': 'Yuklanmoqda...',
      'error': 'Yuklashda xato',
      'student_name': 'Ismingiz va familiyangiz *',
      'student_group': 'Guruhingiz *',
      'enter_code': 'Xona kodi',
      'join': 'Kirish',
      'send_answers': 'Javoblarni yuborish',
      'sending': 'Yuborilmoqda...',
      'timer': 'Taymer',
      'short_answer': 'Qisqa javob',
      'true_false': 'Rost / Yolg\'on',
      'mcq': 'Test (1 variant)',
      'correct_answer': 'To\'g\'ri javob',
      'question_type': 'Savol turi',
      'export': 'Eksport',
      'true': 'Rost',
      'false': 'Yolg\'on',
      'variant': 'Variant',
      'bulk_import': 'Ommaviy import',
      'bulk_desc': '3 ta format qo\'llab-quvvatlanadi:\n1. Matn: Savol -> Javob\n2. Rost/Yolg\'on: Savol -> Rost (yoki Yolg\'on)\n3. Test: Savol -> Variantlar (vergul bilan) -> Raqam (1-4)',
      'import_btn': 'Import qilish',
      'cancel': 'Bekor qilish',
      'brand_name': 'Urganch raqamli texnologiyalar texnikumi',
      'about': 'Tizim haqida',
      'about_desc': 'Ushbu tizim test sinovlari va baholash jarayonini avtomatlashtirish uchun ishlab chiqilgan.',
      'required_fields': 'Iltimos, barcha majburiy mayдонларни to\'ldiring',
      'question': 'Savol',
      'delete': 'O\'chirish',
      'login': 'O\'qituvchilar uchun kirish',
      'email': 'Elektron pochta',
      'password': 'Parol',
      'no_account': 'Akkauntingiz yo\'qmi? Ro\'yxatdan o\'ting',
      'have_account': 'Akkauntingiz bormi? Kirish',
      'register_btn': 'Ro\'yxatdan o\'tish',
      'login_btn': 'Kirish',
      'logout': 'Chiqish',
      'my_results': 'Mening natijalarim',
      'date': 'Sana',
      'cert_title': 'SERTIFIKAT',
      'cert_desc': 'test sinovidan muvaffaqiyatli o\'tganligi to\'g\'risida',
      'report_title': 'TEST NATIJALARI',
      'grade_label': 'BAHO',
      'correct_label': 'To\'g\'ri',
      'percent_label': 'Foiz',
      'page_label': 'Sahifa',
      'of_label': 'dan',
      'back': 'Orqaga',
      'next': 'Keyingisi',
      'finish_test': 'Testni yakunlash',
      'finish_and_send': 'Yakunlash va javoblarni yuborish',
      'confirm_finish': 'Testni yakunlash?',
      'confirm_finish_desc': 'Siz barcha savollarga javob berdingiz. Natijalarni yuborasizmi?',
      'confirm_delete': 'Haqiqatan ham ushbu xonani o\'chirib tashlamoqchimisiz?',
      'room_not_found': 'Xona topilmadi',
      'all_certs_sent': 'Barcha sertifikatlar saqlashga yuborildi',
      'full_report': 'To\'liq hisobot',
      'all_certificates': 'Barcha sertifikatlar',
      'my_rooms': 'Mening xonalarim',
      'download_cert': 'Sertifikatni yuklab olish',
      'edit_test': 'Testni tahrirlash',
      'edit_confirm_title': 'Testni tahrirlashni xohlaysizmi?',
      'edit_confirm_desc': 'O\'zgarishlar kelajakdagi urinishlarga ta\'sir qiladi. Eski natijalar avtomatik ravishda qayta hisoblanmaydi.',
      'save_success': 'O\'zgarishlar muvaffaqiyatli saqlandi',
      'continue': 'Davom etish',
      'profile': 'Profil',
      'save': 'Saqlash',
      'full_name': 'F.I.O.',
      'photo_uploaded': 'Rasm yangilandi',
      'upload_error': 'Yuklashda xato',
      'issued_by': 'O\'qituvchi tomonidan berilgan',
      'teacher_label': 'O\'qituvchi',
      'already_submitted': 'Siz ushbu testni topshirgansiz. O\'qituvchidan ruxsat so\'rang.',
      'room_closed_entry': 'Kabinet yopiq. Kirish faqat o\'qituvchi ruxsati bilan.',
      'room_closed_submit': 'Kabinet yopiq — yuborish mumkin emas. O\'qituvchidan ruxsat so\'rang.',
      'individual_access_active': 'Sizga shaxsiy ruxsat berilgan — testni topshirishingiz mumkin.',
      'open_access': 'Ruxsatni ochish',
      'close_access': 'Ruxsatni yopish',
      'reset_attempt': 'Urinishni o\'chirish',
      'attempt_label': 'Urinish',
    },
    AppLanguage.en: {
      'title': 'Grading System',
      'role_selection': 'Select Role',
      'role_desc': 'Create rooms, accept answers, and get auto-grades.',
      'teacher': 'I am a teacher',
      'student': 'I am a student',
      'create_room': 'Create Room',
      'teacher_name': 'Teacher Name *',
      'group_number': 'Group Number *',
      'group_hint': 'Example: 01-25',
      'room_title': 'Test Title *',
      'title_hint': 'Example: Math Q1',
      'duration': 'Test Duration (minutes)',
      'questions_label': 'Questions and Correct Answers',
      'add_question': 'Add Question',
      'creating': 'Creating...',
      'create_btn': 'Create Room',
      'room_code': 'Room Code',
      'room_active': 'Room is active — students can submit answers',
      'room_closed': 'Room is closed — students cannot submit',
      'open': 'Open',
      'close': 'Close',
      'submissions': 'Submissions',
      'avg_grade': 'Avg Grade',
      'accuracy': 'Accuracy',
      'top_students': 'Top Students',
      'hard_questions': 'Hard Questions',
      'no_data': 'No data yet',
      'no_submissions': 'No submissions yet',
      'loading': 'Loading...',
      'error': 'Loading error',
      'student_name': 'Your First and Last Name *',
      'student_group': 'Your Group *',
      'enter_code': 'Room Code',
      'join': 'Join',
      'send_answers': 'Submit Answers',
      'sending': 'Submitting...',
      'timer': 'Timer',
      'short_answer': 'Short Answer',
      'true_false': 'True / False',
      'mcq': 'Multiple Choice',
      'correct_answer': 'Correct Answer',
      'question_type': 'Question Type',
      'export': 'Export',
      'true': 'True',
      'false': 'False',
      'variant': 'Variant',
      'bulk_import': 'Bulk Import',
      'bulk_desc': '3 formats supported:\n1. Short: Question -> Answer\n2. T/F: Question -> True (or False)\n3. MCQ: Question -> Options (comma separated) -> Index (1-4)',
      'import_btn': 'Import',
      'cancel': 'Cancel',
      'brand_name': 'Urganch Digital Technologies Technical School',
      'about': 'About System',
      'about_desc': 'This system is developed to automate the testing and grading process.',
      'required_fields': 'Please fill in all required fields',
      'question': 'Question',
      'delete': 'Delete',
      'login': 'Teacher Login',
      'email': 'Email',
      'password': 'Password',
      'no_account': 'Don\'t have an account? Register',
      'have_account': 'Already have an account? Login',
      'register_btn': 'Register',
      'login_btn': 'Login',
      'logout': 'Logout',
      'my_results': 'My Results',
      'date': 'Date',
      'cert_title': 'CERTIFICATE',
      'cert_desc': 'of successful testing completion',
      'report_title': 'TEST RESULTS',
      'grade_label': 'GRADE',
      'correct_label': 'Correct',
      'percent_label': 'Percent',
      'page_label': 'Page',
      'of_label': 'of',
      'back': 'Back',
      'next': 'Next',
      'finish_test': 'Finish Test',
      'finish_and_send': 'Finish and Submit Answers',
      'confirm_finish': 'Finish Test?',
      'confirm_finish_desc': 'You have answered all questions. Submit results?',
      'confirm_delete': 'Are you sure you want to delete this room?',
      'room_not_found': 'Room not found',
      'all_certs_sent': 'All certificates sent for saving',
      'full_report': 'Full Report',
      'all_certificates': 'All Certificates',
      'my_rooms': 'My Rooms',
      'download_cert': 'Download Certificate',
      'edit_test': 'Edit Test',
      'edit_confirm_title': 'Edit test?',
      'edit_confirm_desc': 'Changes will affect future attempts. Old results will not be automatically recalculated.',
      'save_success': 'Changes saved successfully',
      'continue': 'Continue',
      'profile': 'Profile',
      'save': 'Save',
      'full_name': 'Full Name',
      'photo_uploaded': 'Photo updated',
      'upload_error': 'Upload error',
      'issued_by': 'Issued by teacher',
      'teacher_label': 'Teacher',
      'already_submitted': 'You have already submitted this test. Ask your teacher for access.',
      'room_closed_entry': 'Room is closed. Entry only with teacher permission.',
      'room_closed_submit': 'Room is closed — submission disabled. Ask your teacher for access.',
      'individual_access_active': 'You have individual access — you may submit the test.',
      'open_access': 'Grant access',
      'close_access': 'Revoke access',
      'reset_attempt': 'Reset attempt',
      'attempt_label': 'Attempt',
    },
  };

  static String s(String key) {
    final lang = _LanguageController.instance.value;
    return _values[lang]?[key] ?? key;
  }
}

class _LanguageController extends ValueNotifier<AppLanguage> {
  _LanguageController._() : super(AppLanguage.uz); // По умолчанию узбекский
  static final _LanguageController instance = _LanguageController._();

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final langIndex = prefs.getInt('app_lang');
    if (langIndex != null && langIndex < AppLanguage.values.length) {
      value = AppLanguage.values[langIndex];
    }
  }

  void setLanguage(AppLanguage lang) {
    value = lang;
    SharedPreferences.getInstance().then((prefs) => prefs.setInt('app_lang', lang.index));
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await _LanguageController.instance.init();
  await _ThemeController.instance.init();
  runApp(const MyApp());
}

class _Persistence {
  static const String _keyStudentName = 'student_name';
  static const String _keyStudentGroup = 'student_group';
  static const String _keyTeacherRooms = 'teacher_rooms';
  static const String _keyStudentHistory = 'student_history';

  static Future<void> saveStudentInfo(String name, String group) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyStudentName, name);
    await prefs.setString(_keyStudentGroup, group);
  }

  static Future<Map<String, String?>> getStudentInfo() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'name': prefs.getString(_keyStudentName),
      'group': prefs.getString(_keyStudentGroup),
    };
  }

  static Future<void> addTeacherRoom(String code) async {
    final prefs = await SharedPreferences.getInstance();
    final rooms = prefs.getStringList(_keyTeacherRooms) ?? [];
    if (!rooms.contains(code)) {
      rooms.insert(0, code);
      if (rooms.length > 5) rooms.removeLast();
      await prefs.setStringList(_keyTeacherRooms, rooms);
    }
  }

  static Future<void> removeTeacherRoom(String code) async {
    final prefs = await SharedPreferences.getInstance();
    final rooms = prefs.getStringList(_keyTeacherRooms) ?? [];
    rooms.remove(code);
    await prefs.setStringList(_keyTeacherRooms, rooms);
  }

  static Future<void> addStudentResult(Map<String, dynamic> result) async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList(_keyStudentHistory) ?? [];
    history.insert(0, jsonEncode({
      ...result,
      'timestamp': DateTime.now().toIso8601String(),
    }));
    if (history.length > 20) history.removeLast();
    await prefs.setStringList(_keyStudentHistory, history);
  }

  static Future<List<Map<String, dynamic>>> getStudentHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList(_keyStudentHistory) ?? [];
    return history.map((s) => jsonDecode(s) as Map<String, dynamic>).toList();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: _ThemeController.instance,
      builder: (context, mode, _) {
        return ValueListenableBuilder<AppLanguage>(
          valueListenable: _LanguageController.instance,
          builder: (context, lang, _) {
            return MaterialApp(
              title: L10n.s('title'),
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(
                  seedColor: const Color(0xFF00C4B4),
                  brightness: Brightness.light,
                  primary: const Color(0xFF00C4B4),
                  secondary: const Color(0xFF3B82F6),
                ),
                useMaterial3: true,
                scaffoldBackgroundColor: const Color(0xFFF8FAFC),
                appBarTheme: const AppBarTheme(
                  centerTitle: false,
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  surfaceTintColor: Colors.transparent,
                  titleTextStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                cardTheme: CardThemeData(
                  elevation: 0,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                    side: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                ),
                inputDecorationTheme: InputDecorationTheme(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFF00C4B4), width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
                filledButtonTheme: FilledButtonThemeData(
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(0, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    backgroundColor: const Color(0xFF00C4B4),
                  ),
                ),
                textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF3B82F6),
                  ),
                ),
              ),
              darkTheme: ThemeData(
                colorScheme: ColorScheme.fromSeed(
                  seedColor: const Color(0xFF00E5D4),
                  brightness: Brightness.dark,
                  primary: const Color(0xFF00E5D4),
                  secondary: const Color(0xFF60A5FA),
                ),
                useMaterial3: true,
                scaffoldBackgroundColor: const Color(0xFF0F172A),
                appBarTheme: const AppBarTheme(
                  centerTitle: false,
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  surfaceTintColor: Colors.transparent,
                ),
                cardTheme: CardThemeData(
                  elevation: 0,
                  color: const Color(0xFF1E2937),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                    side: const BorderSide(color: Color(0xFF334155)),
                  ),
                ),
                inputDecorationTheme: InputDecorationTheme(
                  filled: true,
                  fillColor: const Color(0xFF1E2937),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFF475569)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFF475569)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFF00E5D4), width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
                filledButtonTheme: FilledButtonThemeData(
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(0, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    backgroundColor: const Color(0xFF00E5D4),
                  ),
                ),
              ),
              themeMode: mode,
              home: const SplashScreen(),
            );
          },
        );
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    
    _controller.forward();

    Timer(const Duration(seconds: 3), () async {
      final prefs = await SharedPreferences.getInstance();
      final bool hasSelectedLang = prefs.containsKey('app_lang');

      if (!mounted) return;
      
      final navigator = Navigator.of(context);

      if (hasSelectedLang) {
        // Если язык уже выбирали ранее, идем сразу к выбору роли
        navigator.pushReplacement(
          _modernRoute(const RoleSelectionPage(), replace: true),
        );
      } else {
        // Если запуск первый — спрашиваем язык
        navigator.pushReplacement(
          _modernRoute(const LanguageSelectionPage(), replace: true),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _GradientScaffold(
      appBar: AppBar(toolbarHeight: 0, automaticallyImplyLeading: false),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Hero(
                  tag: 'app_logo',
                  child: Image.asset('assets/logo.png', width: 280),
                ),
                const SizedBox(height: 24),
                Text(
                  L10n.s('brand_name'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  width: 40,
                  height: 3,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class _LanguageSwitch extends StatelessWidget {
  const _LanguageSwitch();

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<AppLanguage>(
      icon: const Icon(Icons.language_rounded),
      onSelected: _LanguageController.instance.setLanguage,
      itemBuilder: (context) => [
        const PopupMenuItem(value: AppLanguage.ru, child: Text('🇷🇺 Русский')),
        const PopupMenuItem(value: AppLanguage.uz, child: Text('🇺🇿 O\'zbekcha')),
        const PopupMenuItem(value: AppLanguage.en, child: Text('🇺🇸 English')),
      ],
    );
  }
}

class LanguageSelectionPage extends StatelessWidget {
  const LanguageSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _GradientScaffold(
      appBar: AppBar(toolbarHeight: 0, automaticallyImplyLeading: false),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Hero(
                tag: 'app_logo',
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Image(image: AssetImage('assets/logo.png')),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Выберите язык\nTilni tanlang\nChoose language',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, height: 1.5),
              ),
              const SizedBox(height: 40),
              _LanguageCard(
                flag: '🇷🇺',
                label: 'Русский',
                onTap: () => _select(context, AppLanguage.ru),
              ),
              const SizedBox(height: 16),
              _LanguageCard(
                flag: '🇺🇿',
                label: 'O\'zbekcha',
                onTap: () => _select(context, AppLanguage.uz),
              ),
              const SizedBox(height: 16),
              _LanguageCard(
                flag: '🇺🇸',
                label: 'English',
                onTap: () => _select(context, AppLanguage.en),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _select(BuildContext context, AppLanguage lang) {
    _LanguageController.instance.setLanguage(lang);
    Navigator.of(context).pushReplacement(_modernRoute(const RoleSelectionPage(), replace: true));
  }
}

class _LanguageCard extends StatelessWidget {
  final String flag;
  final String label;
  final VoidCallback onTap;

  const _LanguageCard({required this.flag, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Theme.of(context).dividerColor.withValues(alpha: 0.1)),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
            child: Row(
              children: [
                Text(flag, style: const TextStyle(fontSize: 28)),
                const SizedBox(width: 20),
                Text(
                  label,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Theme.of(context).primaryColor),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TeacherProfilePage extends StatefulWidget {
  const TeacherProfilePage({super.key});

  @override
  State<TeacherProfilePage> createState() => _TeacherProfilePageState();
}

class _TeacherProfilePageState extends State<TeacherProfilePage> {
  final _nameController = TextEditingController();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    if (doc.exists && mounted) {
      setState(() {
        _nameController.text = doc.data()?['name'] ?? '';
      });
    }
  }

  Future<void> _saveName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() => _loading = true);
    try {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'name': _nameController.text.trim(),
      }, SetOptions(merge: true));
      if (mounted) {
        Navigator.pop(context, true);
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _GradientScaffold(
      appBar: AppBar(title: Text(L10n.s('profile'))),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Color(0xFF00C4B4),
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: L10n.s('full_name')),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _loading ? null : _saveName,
                child: Text(L10n.s('save')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TeacherAuthPage extends StatefulWidget {
  const TeacherAuthPage({super.key});

  @override
  State<TeacherAuthPage> createState() => _TeacherAuthPageState();
}

class _TeacherAuthPageState extends State<TeacherAuthPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLogin = true;
  bool _loading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    if (email.isEmpty || password.isEmpty) return;

    setState(() => _loading = true);
    try {
      if (_isLogin) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        // Initialize profile
        await FirebaseFirestore.instance.collection('users').doc(credential.user!.uid).set({
          'name': email.split('@')[0],
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'Auth Error')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _GradientScaffold(
      appBar: AppBar(title: Text(L10n.s(_isLogin ? 'login_btn' : 'register_btn'))),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: L10n.s('email')),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: L10n.s('password'),
                suffixIcon: IconButton(
                  icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                ),
              ),
              obscureText: _obscurePassword,
            ),
            const SizedBox(height: 24),
            _loading
                ? const CircularProgressIndicator()
                : SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _submit,
                      child: Text(L10n.s(_isLogin ? 'login_btn' : 'register_btn')),
                    ),
                  ),
            TextButton(
              onPressed: () => setState(() => _isLogin = !_isLogin),
              child: Text(L10n.s(_isLogin ? 'no_account' : 'have_account')),
            ),
          ],
        ),
      ),
    );
  }
}

class RoleSelectionPage extends StatefulWidget {
  const RoleSelectionPage({super.key});

  @override
  State<RoleSelectionPage> createState() => _RoleSelectionPageState();
}

class _RoleSelectionPageState extends State<RoleSelectionPage> {
  @override
  void initState() {
    super.initState();
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(L10n.s('about')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/logo.png', height: 120),
            const SizedBox(height: 16),
            Text(
              L10n.s('brand_name'),
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 12),
            Text(
              L10n.s('about_desc'),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppLanguage>(
      valueListenable: _LanguageController.instance,
      builder: (context, lang, _) {
        final user = FirebaseAuth.instance.currentUser;
        return _GradientScaffold(
          appBar: AppBar(
            title: Text(L10n.s('title')),
            actions: const [
              _LanguageSwitch(),
              _ThemeSwitch(),
            ],
          ),
          drawer: Drawer(
            child: Column(
              children: [
                if (user != null)
                  StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance.collection('users').doc(user.uid).snapshots(),
                    builder: (context, snapshot) {
                      final data = snapshot.data?.data() ?? {};
                      final name = data['name'] ?? L10n.s('teacher');

                      return UserAccountsDrawerHeader(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          image: const DecorationImage(
                            image: AssetImage('assets/logo.png'),
                            opacity: 0.1,
                            fit: BoxFit.cover,
                          ),
                        ),
                        accountName: Text(
                          name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                        accountEmail: Text(
                          user.email ?? '',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.8),
                          ),
                        ),
                        currentAccountPicture: GestureDetector(
                          onTap: () => Navigator.of(context).push(_modernRoute(const TeacherProfilePage())),
                          child: const CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(Icons.person, size: 40, color: Color(0xFF00C4B4)),
                          ),
                        ),
                      );
                    },
                  )
                else
                  DrawerHeader(
                    decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary),
                    child: Center(
                      child: Image.asset('assets/logo.png', height: 80),
                    ),
                  ),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      if (user != null) ...[
                        ListTile(
                          leading: const Icon(Icons.person_outline_rounded),
                          title: Text(L10n.s('profile')),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.of(context).push(_modernRoute(const TeacherProfilePage()));
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.collections_bookmark_rounded),
                          title: Text(L10n.s('my_rooms')),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.of(context).push(_modernRoute(const TeacherHistoryPage()));
                          },
                        ),
                      ],
                      ListTile(
                        leading: const Icon(Icons.history_rounded),
                        title: Text(L10n.s('my_results')),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.of(context).push(_modernRoute(const StudentHistoryPage()));
                        },
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.info_outline_rounded),
                        title: Text(L10n.s('about')),
                        onTap: () {
                          Navigator.pop(context);
                          _showAboutDialog(context);
                        },
                      ),
                    ],
                  ),
                ),
                if (user != null)
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.redAccent),
                    title: Text(
                      L10n.s('logout'),
                      style: const TextStyle(color: Colors.redAccent),
                    ),
                    onTap: () async {
                      await FirebaseAuth.instance.signOut();
                      if (!context.mounted) return;
                      Navigator.of(context).pop();
                      setState(() {});
                    },
                  ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Padding(
              key: ValueKey(lang),
              padding: const EdgeInsets.all(16),
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(),
                Text(
                  L10n.s('role_selection'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Text(
                  L10n.s('role_desc'),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: 18),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            onPressed: () {
                              if (user == null) {
                                Navigator.of(context)
                                    .push<bool>(_modernRoute<bool>(const TeacherAuthPage()))
                                    .then((result) {
                                  if (result == true && context.mounted) {
                                    setState(() {});
                                  }
                                });
                              } else {
                                Navigator.of(context)
                                    .push(_modernRoute(const TeacherCreatePage()));
                              }
                            },
                            icon: const Icon(Icons.school),
                            label: Text(L10n.s('teacher')),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size.fromHeight(56),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              side: const BorderSide(color: Color(0xFF3B82F6)),
                            ),
                            onPressed: () {
                              Navigator.of(context)
                                  .push(_modernRoute(const StudentJoinPage()));
                            },
                            icon: const Icon(Icons.person),
                            label: Text(L10n.s('student')),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                // Branding Footer
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    children: [
                      Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        L10n.s('brand_name'),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.7),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        );
      },
    );
  }
}

class TeacherEditPage extends StatefulWidget {
  const TeacherEditPage({super.key, required this.roomCode});

  final String roomCode;

  @override
  State<TeacherEditPage> createState() => _TeacherEditPageState();
}

class _TeacherEditPageState extends State<TeacherEditPage> {
  final TextEditingController _teacherController = TextEditingController();
  final TextEditingController _groupController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _durationMinutesController = TextEditingController();

  List<_QuestionInput> _questions = [];
  bool _saving = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadRoomData();
  }

  Future<void> _loadRoomData() async {
    try {
      final roomDoc = await FirebaseFirestore.instance
          .collection('rooms')
          .doc(widget.roomCode)
          .get();

      final questionsSnap = await FirebaseFirestore.instance
          .collection('rooms')
          .doc(widget.roomCode)
          .collection('questions')
          .orderBy('index')
          .get();

      if (roomDoc.exists) {
        final data = roomDoc.data()!;
        _teacherController.text = data['teacherName'] ?? '';
        _groupController.text = data['groupNumber'] ?? '';
        _titleController.text = data['testTitle'] ?? '';
        _durationMinutesController.text = ((data['durationSeconds'] ?? 600) / 60).toInt().toString();
      }

      _questions = questionsSnap.docs.map((doc) {
        final data = doc.data();
        final q = _QuestionInput();
        q.question.text = data['text'] ?? '';
        
        final typeStr = data['type']?.toString() ?? 'short';
        q.type = _QuestionType.values.firstWhere((e) => e.name == typeStr, orElse: () => _QuestionType.short);

        if (q.type == _QuestionType.short) {
          q.answer.text = data['correctAnswer'] ?? '';
        } else if (q.type == _QuestionType.trueFalse) {
          q.trueFalseValue = data['correctBool'] ?? true;
        } else if (q.type == _QuestionType.mcq) {
          final opts = List<String>.from(data['options'] ?? []);
          for (int i = 0; i < opts.length && i < q.options.length; i++) {
            q.options[i].text = opts[i];
          }
          q.correctIndex = (data['correctIndex'] as num?)?.toInt() ?? 0;
        }
        return q;
      }).toList();

      if (_questions.isEmpty) _questions.add(_QuestionInput());

    } catch (e) {
      debugPrint('Error loading room: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _saveChanges() async {
    final teacher = _teacherController.text.trim();
    final group = _groupController.text.trim();
    final title = _titleController.text.trim();
    
    if (teacher.isEmpty || group.isEmpty || title.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(L10n.s('required_fields'))),
        );
      }
      return;
    }

    setState(() => _saving = true);

    try {
      final firestore = FirebaseFirestore.instance;
      final roomRef = firestore.collection('rooms').doc(widget.roomCode);
      final batch = firestore.batch();

      final durationMinutes = int.tryParse(_durationMinutesController.text.trim()) ?? 10;
      final durationSeconds = max(1, durationMinutes.clamp(1, 180) * 60);

      // Обновляем основную информацию комнаты
      batch.update(roomRef, {
        'teacherName': teacher,
        'groupNumber': group,
        'testTitle': title,
        'durationSeconds': durationSeconds,
      });

      // Удаляем старые вопросы (Firestore batch не поддерживает автоматическое удаление коллекции, поэтому удаляем по ID)
      final oldQuestions = await roomRef.collection('questions').get();
      for (var doc in oldQuestions.docs) {
        batch.delete(doc.reference);
      }

      // Добавляем обновленные вопросы
      for (var i = 0; i < _questions.length; i++) {
        final q = _questions[i];
        final data = q.toFirestore();
        if (data == null) continue;

        data['index'] = i;
        batch.set(roomRef.collection('questions').doc('q$i'), data);
      }

      await batch.commit();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(L10n.s('save_success'))),
      );
      Navigator.of(context).pop();
    }
  } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  void dispose() {
    _teacherController.dispose();
    _groupController.dispose();
    _titleController.dispose();
    _durationMinutesController.dispose();
    for (var q in _questions) {
      q.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppLanguage>(
      valueListenable: _LanguageController.instance,
      builder: (context, lang, _) {
        return _GradientScaffold(
          appBar: AppBar(
            title: Text(L10n.s('edit_test')),
            actions: const [_LanguageSwitch(), _ThemeSwitch()],
          ),
          body: _loading
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    TextField(
                      controller: _teacherController,
                      decoration: InputDecoration(
                        labelText: L10n.s('teacher_name'),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _groupController,
                      decoration: InputDecoration(
                        labelText: L10n.s('group_number'),
                        hintText: L10n.s('group_hint'),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: L10n.s('room_title'),
                        hintText: L10n.s('title_hint'),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _durationMinutesController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: L10n.s('duration'),
                        hintText: 'Например: 10',
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(L10n.s('questions_label'),
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    ...List.generate(_questions.length, (index) {
                      final input = _questions[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${L10n.s('question')} ${index + 1}',
                                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
                                    onPressed: () {
                                      setState(() {
                                        _questions.removeAt(index);
                                      });
                                    },
                                    tooltip: L10n.s('delete'),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              DropdownButtonFormField<_QuestionType>(
                                initialValue: input.type,
                                decoration: InputDecoration(
                                  labelText: L10n.s('question_type'),
                                  border: const OutlineInputBorder(),
                                ),
                                items: [
                                  DropdownMenuItem(
                                    value: _QuestionType.short,
                                    child: Text(L10n.s('short_answer')),
                                  ),
                                  DropdownMenuItem(
                                    value: _QuestionType.trueFalse,
                                    child: Text(L10n.s('true_false')),
                                  ),
                                  DropdownMenuItem(
                                    value: _QuestionType.mcq,
                                    child: Text(L10n.s('mcq')),
                                  ),
                                ],
                                onChanged: (value) {
                                  if (value == null) return;
                                  setState(() => input.type = value);
                                },
                              ),
                              const SizedBox(height: 10),
                              TextField(
                                controller: input.question,
                                decoration: InputDecoration(
                                  labelText: L10n.s('question'),
                                  border: const OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 8),
                              ...input.buildAnswerEditor(setState),
                            ],
                          ),
                        ),
                      );
                    }),
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          _questions.add(_QuestionInput());
                        });
                      },
                      icon: const Icon(Icons.add),
                      label: Text(L10n.s('add_question')),
                    ),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: _saving ? null : _saveChanges,
                      child: Text(_saving ? L10n.s('loading') : L10n.s('save')),
                    ),
                  ],
                ),
        );
      },
    );
  }
}

class TeacherHistoryPage extends StatefulWidget {
  const TeacherHistoryPage({super.key});

  @override
  State<TeacherHistoryPage> createState() => _TeacherHistoryPageState();
}

class _TeacherHistoryPageState extends State<TeacherHistoryPage> {
  bool _loading = true;
  List<DocumentSnapshot> _rooms = [];

  @override
  void initState() {
    super.initState();
    _fetchRooms();
  }

  Future<void> _fetchRooms() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('rooms')
          .where('ownerId', isEqualTo: user.uid)
          .orderBy('createdAt', descending: true)
          .get();
      if (mounted) {
        setState(() {
          _rooms = snapshot.docs;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _GradientScaffold(
      appBar: AppBar(title: Text(L10n.s('my_rooms'))),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _rooms.isEmpty
              ? _StateMessage(icon: Icons.folder_open_rounded, title: L10n.s('no_data'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _rooms.length,
                  itemBuilder: (context, index) {
                    final data = _rooms[index].data() as Map<String, dynamic>;
                    final code = _rooms[index].id;
                    final group = data['groupNumber'] ?? '-';
                    final date = (data['createdAt'] as Timestamp?)?.toDate().toString().split(' ')[0] ?? '-';
                    
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: const CircleAvatar(child: Icon(Icons.meeting_room_rounded)),
                        title: Text(data['testTitle'] ?? '${L10n.s('room_code')}: $code'),
                        subtitle: Text('${L10n.s('room_code')}: $code • $group • $date'),
                        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                        onTap: () {
                          Navigator.of(context).push(
                            _modernRoute(TeacherRoomPage(roomCode: code)),
                          );
                        },
                      ),
                    );
                  },
                ),
    );
  }
}

class StudentHistoryPage extends StatefulWidget {
  const StudentHistoryPage({super.key});

  @override
  State<StudentHistoryPage> createState() => _StudentHistoryPageState();
}

class _StudentHistoryPageState extends State<StudentHistoryPage> {
  bool _loading = true;
  List<Map<String, dynamic>> _history = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final history = await _Persistence.getStudentHistory();
    if (mounted) {
      setState(() {
        _history = history;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _GradientScaffold(
      appBar: AppBar(title: Text(L10n.s('my_results'))),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _history.isEmpty
              ? _StateMessage(icon: Icons.history_rounded, title: L10n.s('no_data'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _history.length,
                  itemBuilder: (context, index) {
                    final res = _history[index];
                    final dateStr = res['timestamp'] != null
                        ? (DateTime.tryParse(res['timestamp'].toString()) ?? DateTime.now())
                            .toString()
                            .split(' ')[0]
                        : '-';
                    
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: const CircleAvatar(child: Icon(Icons.assignment_turned_in_rounded)),
                        title: Text(res['testTitle'] ?? '${L10n.s('room_code')}: ${res['roomCode']}'),
                        subtitle: Text('${L10n.s('room_code')}: ${res['roomCode']} • ${L10n.s('date')}: $dateStr'),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${res['grade']}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}

class TeacherCreatePage extends StatefulWidget {
  const TeacherCreatePage({super.key});

  @override
  State<TeacherCreatePage> createState() => _TeacherCreatePageState();
}

class _TeacherCreatePageState extends State<TeacherCreatePage> {
  final TextEditingController _teacherController = TextEditingController();
  final TextEditingController _groupController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _durationMinutesController =
      TextEditingController(text: '10');
  final List<_QuestionInput> _questions = [
    _QuestionInput(),
    _QuestionInput(),
  ];
  bool _saving = false;

  @override
  void dispose() {
    _teacherController.dispose();
    _groupController.dispose();
    _titleController.dispose();
    _durationMinutesController.dispose();
    for (final input in _questions) {
      input.dispose();
    }
    super.dispose();
  }

  Future<void> _createRoom() async {
    final teacher = _teacherController.text.trim();
    final group = _groupController.text.trim();
    final title = _titleController.text.trim();
    final preparedQuestions = <Map<String, dynamic>>[];

    if (teacher.isEmpty || group.isEmpty || title.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(L10n.s('required_fields'))),
        );
      }
      return;
    }

    for (final input in _questions) {
      final data = input.toFirestore();
      if (data == null) continue;
      preparedQuestions.add(data);
    }

    if (preparedQuestions.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(L10n.s('no_data'))),
        );
      }
      return;
    }

    setState(() => _saving = true);

    try {
      final roomCode = _generateRoomCode();
      final firestore = FirebaseFirestore.instance;
      final roomRef = firestore.collection('rooms').doc(roomCode);
      final batch = firestore.batch();
      final durationMinutes =
          int.tryParse(_durationMinutesController.text.trim()) ?? 10;
      final durationSeconds =
          max(1, durationMinutes.clamp(1, 180) * 60);

      batch.set(roomRef, {
        'teacherName': teacher,
        'groupNumber': group,
        'testTitle': title,
        'ownerId': FirebaseAuth.instance.currentUser?.uid,
        'createdAt': FieldValue.serverTimestamp(),
        'status': 'active', // active | closed
        'questionCount': preparedQuestions.length,
        'durationSeconds': durationSeconds,
      });

      for (var i = 0; i < preparedQuestions.length; i++) {
        final q = preparedQuestions[i];
        q['index'] = i;
        batch.set(roomRef.collection('questions').doc('q$i'), {
          ...q,
        });
      }

      await batch.commit();
      await _Persistence.addTeacherRoom(roomCode);

      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        _modernRoute(TeacherRoomPage(roomCode: roomCode), replace: true),
      );
    } on FirebaseException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка Firebase: ${e.code}'),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  String _generateRoomCode() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final random = Random();
    return List.generate(6, (_) => chars[random.nextInt(chars.length)]).join();
  }

  void _showBulkImportDialog() {
    final controller = TextEditingController();
    final lang = _LanguageController.instance.value;
    final example = lang == AppLanguage.ru
        ? '1. Сколько планет?\n8\n2. Солнце - это звезда?\nПравда\n3. Столица?\nБерлин, Лондон, Париж\n2'
        : lang == AppLanguage.uz
            ? '1. Nechta sayyora?\n8\n2. Quyosh yulduzmi?\nRost\n3. Poytaxt?\nBerlin, London, Parij\n2'
            : '1. How many planets?\n8\n2. Sun is a star?\nTrue\n3. Capital?\nBerlin, London, Paris\n2';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(L10n.s('bulk_import')),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(L10n.s('bulk_desc'), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              TextField(
                controller: controller,
                maxLines: 12,
                decoration: InputDecoration(
                  hintText: example,
                  helperText: 'Разделяйте вопросы пустой строкой для надежности',
                  alignLabelWithHint: true,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(L10n.s('cancel')),
          ),
          FilledButton(
            onPressed: () {
              _parseBulkText(controller.text);
              Navigator.pop(context);
            },
            child: Text(L10n.s('import_btn')),
          ),
        ],
      ),
    );
  }

  void _parseBulkText(String text) {
    final lines = text.split('\n').map((l) => l.trim()).where((l) => l.isNotEmpty).toList();
    final newQuestions = <_QuestionInput>[];

    int i = 0;
    while (i < lines.length) {
      final questionText = lines[i].replaceAll(RegExp(r'^\d+[.)\s]+'), '');
      if (i + 1 >= lines.length) break;

      final secondLine = lines[i + 1];
      final qInput = _QuestionInput();
      qInput.question.text = questionText;

      // 1. Проверка на True/False
      final tfWords = ['правда', 'ложь', 'true', 'false', 'rost', 'yolg\'on', 'yolgon'];
      if (tfWords.contains(secondLine.toLowerCase())) {
        qInput.type = _QuestionType.trueFalse;
        qInput.trueFalseValue = secondLine.toLowerCase() == 'правда' || 
                               secondLine.toLowerCase() == 'true' || 
                               secondLine.toLowerCase() == 'rost';
        newQuestions.add(qInput);
        i += 2;
        continue;
      }

      // 2. Проверка на MCQ (Тест)
      // Если в строке есть запятые и после неё идет еще одна строка с цифрой
      if (secondLine.contains(',') && i + 2 < lines.length && int.tryParse(lines[i + 2]) != null) {
        final options = secondLine.split(',').map((o) => o.trim()).toList();
        final correctIdx = (int.tryParse(lines[i + 2]) ?? 1) - 1;
        
        qInput.type = _QuestionType.mcq;
        for (int j = 0; j < min(4, options.length); j++) {
          qInput.options[j].text = options[j];
        }
        qInput.correctIndex = correctIdx.clamp(0, 3);
        newQuestions.add(qInput);
        i += 3;
        continue;
      }

      // 3. По умолчанию - короткий ответ
      qInput.type = _QuestionType.short;
      qInput.answer.text = secondLine;
      newQuestions.add(qInput);
      i += 2;
    }

    if (newQuestions.isNotEmpty) {
      setState(() {
        _questions.addAll(newQuestions);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppLanguage>(
      valueListenable: _LanguageController.instance,
      builder: (context, lang, _) {
        return _GradientScaffold(
          appBar: AppBar(
            title: Text(L10n.s('create_room')),
            actions: const [
              _LanguageSwitch(),
              _ThemeSwitch(),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextField(
                controller: _teacherController,
                decoration: InputDecoration(
                  labelText: L10n.s('teacher_name'),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _groupController,
                decoration: InputDecoration(
                  labelText: L10n.s('group_number'),
                  hintText: L10n.s('group_hint'),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: L10n.s('room_title'),
                  hintText: L10n.s('title_hint'),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _durationMinutesController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: L10n.s('duration'),
                  hintText: 'Например: 10',
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(L10n.s('questions_label'),
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                  TextButton.icon(
                    onPressed: _showBulkImportDialog,
                    icon: const Icon(Icons.paste_rounded, size: 18),
                    label: Text(L10n.s('bulk_import')),
                    style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ...List.generate(_questions.length, (index) {
                final input = _questions[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${L10n.s('question')} ${index + 1}',
                              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
                              onPressed: () {
                                setState(() {
                                  _questions.removeAt(index);
                                });
                              },
                              tooltip: L10n.s('delete'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<_QuestionType>(
                          initialValue: input.type,
                          decoration: InputDecoration(
                            labelText: L10n.s('question_type'),
                            border: const OutlineInputBorder(),
                          ),
                          items: [
                            DropdownMenuItem(
                              value: _QuestionType.short,
                              child: Text(L10n.s('short_answer')),
                            ),
                            DropdownMenuItem(
                              value: _QuestionType.trueFalse,
                              child: Text(L10n.s('true_false')),
                            ),
                            DropdownMenuItem(
                              value: _QuestionType.mcq,
                              child: Text(L10n.s('mcq')),
                            ),
                          ],
                          onChanged: (value) {
                            if (value == null) return;
                            setState(() => input.type = value);
                          },
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: input.question,
                          decoration: InputDecoration(
                            labelText: L10n.s('question'),
                            border: const OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...input.buildAnswerEditor(setState),
                      ],
                    ),
                  ),
                );
              }),
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    _questions.add(_QuestionInput());
                  });
                },
                icon: const Icon(Icons.add),
                label: Text(L10n.s('add_question')),
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: _saving ? null : _createRoom,
                child: Text(_saving ? L10n.s('creating') : L10n.s('create_btn')),
              ),
            ],
          ),
        );
      },
    );
  }
}

class TeacherRoomPage extends StatelessWidget {
  const TeacherRoomPage({super.key, required this.roomCode});

  final String roomCode;

  Future<void> _exportToCSV(
    BuildContext context,
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
  ) async {
    final buffer = StringBuffer();
    // Add BOM for Excel UTF-8 compatibility
    buffer.write('\u{FEFF}');
    buffer.writeln('Group;Student Name;Grade;Correct Count;Total Questions;Submitted At');

    for (final doc in docs) {
      final data = doc.data();
      final group = data['studentGroup'] ?? '-';
      final name = data['studentName'] ?? 'Unknown';
      final grade = data['grade'] ?? 0;
      final correct = data['correctCount'] ?? 0;
      final total = data['totalQuestions'] ?? 0;
      final submitted = data['submittedAt'] != null
          ? (data['submittedAt'] as Timestamp).toDate().toIso8601String()
          : '';

      buffer.writeln('$group;$name;$grade;$correct;$total;$submitted');
    }

    if (kIsWeb) {
      final bytes = utf8.encode(buffer.toString());
      final base64 = base64Encode(bytes);
      final url = 'data:text/csv;charset=utf-16;base64,$base64';
      // ignore: deprecated_member_use
      await launchUrl(Uri.parse(url));
    } else {
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/results_$roomCode.csv');
      await file.writeAsString(buffer.toString(), encoding: utf8);
      await Share.shareXFiles([XFile(file.path)], text: 'Results for Room $roomCode');
    }
  }

  // ====================== PDF Экспорт ======================
  Future<void> _exportToPDF(
    BuildContext context,
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
    List<QueryDocumentSnapshot<Map<String, dynamic>>> questions,
  ) async {
    final pdf = pw.Document();

    final robotoRegular = await PdfGoogleFonts.robotoRegular();
    final robotoBold = await PdfGoogleFonts.robotoBold();
    final robotoItalic = await PdfGoogleFonts.robotoItalic();

    pw.MemoryImage? logoImage;
    try {
      final logoData = await rootBundle.load('assets/logo.png');
      logoImage = pw.MemoryImage(logoData.buffer.asUint8List());
    } catch (_) {}

    final stats = _buildStats(docs);
    // Remove insights if not used, or use it.

    // Fetch teacher profile
    String teacherName = roomCode; 
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final profile = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        teacherName = profile.data()?['name'] ?? L10n.s('teacher');
      }
    } catch (_) {}

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        theme: pw.ThemeData.withFont(
          base: robotoRegular,
          bold: robotoBold,
          italic: robotoItalic,
        ),
        header: (context) => pw.Column(children: [
          if (logoImage != null)
            pw.Align(alignment: pw.Alignment.centerRight, child: pw.Image(logoImage, height: 60)),
          pw.SizedBox(height: 10),
          pw.Divider(),
        ]),
        footer: (context) => pw.Column(
          children: [
            pw.Divider(),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(L10n.s('brand_name'),
                    style: pw.TextStyle(font: robotoItalic, fontSize: 10)),
                pw.Text('${L10n.s('page_label')} ${context.pageNumber} ${L10n.s('of_label')} ${context.pagesCount}',
                    style: const pw.TextStyle(fontSize: 10)),
              ],
            ),
          ],
        ),
        build: (pw.Context context) => [
          pw.Center(
            child: pw.Text(L10n.s('report_title'),
                style: pw.TextStyle(font: robotoBold, fontSize: 24)),
          ),
          pw.SizedBox(height: 8),
          pw.Center(
            child: pw.Text('${L10n.s('room_code')}: $roomCode',
                style: pw.TextStyle(font: robotoBold, fontSize: 14)),
          ),
          pw.SizedBox(height: 8),
          pw.Center(
            child: pw.Text('${L10n.s('teacher_label')}: $teacherName',
                style: pw.TextStyle(font: robotoBold, fontSize: 14)),
          ),
          pw.SizedBox(height: 25),

          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
            children: [
              _buildPdfStat(L10n.s('submissions'), docs.length.toString(), robotoBold),
              _buildPdfStat(L10n.s('avg_grade'), stats.averageGrade.toStringAsFixed(1), robotoBold),
              _buildPdfStat(L10n.s('accuracy'), '${stats.accuracyPercent.toStringAsFixed(1)}%', robotoBold),
            ],
          ),
          pw.SizedBox(height: 25),

          pw.TableHelper.fromTextArray(
            headerStyle: pw.TextStyle(font: robotoBold, color: PdfColors.white),
            headerDecoration: const pw.BoxDecoration(color: PdfColors.teal700),
            cellStyle: const pw.TextStyle(fontSize: 11),
            headers: ['№', L10n.s('student_name').replaceAll(' *', ''), L10n.s('student_group').replaceAll(' *', ''), L10n.s('avg_grade'), L10n.s('correct_label'), L10n.s('attempt_label'), 'Выходы'],
            data: List.generate(docs.length, (i) {
              final d = docs[i].data();
              final correct = d['correctCount'] ?? 0;
              final total = d['totalQuestions'] ?? 0;
              final leaves = d['appLeaveCount'] ?? 0;
              final attempt = d['attemptNumber'] ?? 1;
              return [
                '${i + 1}',
                d['studentName'] ?? '—',
                d['studentGroup'] ?? '—',
                d['grade'].toString(),
                '$correct / $total',
                '#$attempt',
                leaves > 0 ? '⚠ $leaves' : '—',
              ];
            }),
          ),
          pw.SizedBox(height: 30),
          pw.Center(
            child: pw.Text(
              '${L10n.s('report_title')} ${DateTime.now().toString().split('.')[0]}',
              style: pw.TextStyle(
                font: robotoItalic, 
                fontSize: 11, 
                color: PdfColors.grey700
              ),
            ),
          ),
        ],
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
      name: 'Результаты_$roomCode.pdf',
    );
  }

  pw.Widget _buildPdfStat(String label, String value, pw.Font boldFont) {
    return pw.Column(
      children: [
        pw.Text(value, style: pw.TextStyle(font: boldFont, fontSize: 20)),
        pw.Text(label, style: const pw.TextStyle(fontSize: 11)),
      ],
    );
  }

  // ====================== Сертификат ======================
  Future<void> _exportStudentCertificate(
    BuildContext context,
    QueryDocumentSnapshot<Map<String, dynamic>> submission,
  ) async {
    final data = submission.data();
    final pdf = pw.Document();

    final bold = await PdfGoogleFonts.robotoBold();
    final regular = await PdfGoogleFonts.robotoRegular();

    // Fetch teacher profile & room creation date
    String teacherName = roomCode;
    String dateStr = "-";
    try {
      final roomDoc = await FirebaseFirestore.instance.collection('rooms').doc(roomCode).get();
      final roomData = roomDoc.data();
      final ownerId = roomData?['ownerId'];
      
      // Время создания комнаты
      final createdAt = (roomData?['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now();
      dateStr = "${createdAt.day.toString().padLeft(2, '0')}.${createdAt.month.toString().padLeft(2, '0')}.${createdAt.year} "
                "${createdAt.hour.toString().padLeft(2, '0')}:${createdAt.minute.toString().padLeft(2, '0')}";

      if (ownerId != null) {
        final profile = await FirebaseFirestore.instance.collection('users').doc(ownerId).get();
        teacherName = profile.data()?['name'] ?? L10n.s('teacher');
      }
    } catch (_) {}

    pw.MemoryImage? logo;
    try {
      logo = pw.MemoryImage((await rootBundle.load('assets/logo.png')).buffer.asUint8List());
    } catch (_) {}

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4.landscape,
        theme: pw.ThemeData.withFont(base: regular, bold: bold),
        build: (pw.Context context) => pw.Center(
          child: pw.Container(
            width: 720,
            height: 500,
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.teal800, width: 12),
              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(30)),
            ),
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                if (logo != null) pw.Image(logo, height: 90),
                pw.SizedBox(height: 20),
                pw.Text(L10n.s('cert_title'), style: pw.TextStyle(font: bold, fontSize: 36, color: PdfColors.teal800)),
                pw.Text(L10n.s('cert_desc'), style: pw.TextStyle(font: regular, fontSize: 18)),
                pw.SizedBox(height: 40),
                pw.Text(data['studentName']?.toString() ?? '', style: pw.TextStyle(font: bold, fontSize: 26)),
                pw.SizedBox(height: 8),
                pw.Text('${L10n.s('student_group').replaceAll(' *', '')}: ${data['studentGroup'] ?? '-'}', 
                       style: pw.TextStyle(font: regular, fontSize: 18)),
                pw.SizedBox(height: 50),
                pw.Text(L10n.s('grade_label'), style: pw.TextStyle(font: regular, fontSize: 22)),
                pw.Text('${data['grade']}', style: pw.TextStyle(font: bold, fontSize: 82, color: PdfColors.green800)),
                pw.SizedBox(height: 35),

                // === БЛОК С ИНФОРМАЦИЕЙ ВНИЗУ ===
                pw.Divider(color: PdfColors.grey400, thickness: 1, indent: 100, endIndent: 100),
                pw.SizedBox(height: 12),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: [
                    pw.Text('${L10n.s('issued_by')}: $teacherName', 
                           style: pw.TextStyle(font: regular, fontSize: 13)),
                    pw.SizedBox(width: 40),
                    pw.Text('${L10n.s('date')}: $dateStr', 
                           style: pw.TextStyle(font: regular, fontSize: 13)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
      name: 'Сертификат_${(data['studentName'] ?? 'Ученик').toString().replaceAll(RegExp(r'[^a-zA-Zа-яА-Я0-9]'), '_')}.pdf',
    );
  }

  Future<void> _exportAllCertificates(
    BuildContext context,
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
  ) async {
    if (docs.isEmpty) return;

    for (final doc in docs) {
      if (!context.mounted) return;
      await _exportStudentCertificate(context, doc);
      await Future.delayed(const Duration(milliseconds: 800));
    }

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(L10n.s('all_certs_sent'))),
      );
    }
  }

  Future<void> _duplicateRoom(BuildContext context) async {
    final roomDoc = await FirebaseFirestore.instance.collection('rooms').doc(roomCode).get();
    final questions = await FirebaseFirestore.instance.collection('rooms').doc(roomCode).collection('questions').get();
    
    if (!roomDoc.exists) return;

    final newCode = List.generate(6, (_) => 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789'[Random().nextInt(32)]).join();
    final batch = FirebaseFirestore.instance.batch();
    
    final newRoomRef = FirebaseFirestore.instance.collection('rooms').doc(newCode);
    batch.set(newRoomRef, {
      ...roomDoc.data()!,
      'createdAt': FieldValue.serverTimestamp(),
      'status': 'active',
    });

    for (var q in questions.docs) {
      batch.set(newRoomRef.collection('questions').doc(q.id), q.data());
    }

    await batch.commit();
    await _Persistence.addTeacherRoom(newCode);
    
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Room duplicated: $newCode')));
      Navigator.of(context).pushReplacement(_modernRoute(TeacherRoomPage(roomCode: newCode)));
    }
  }

  Future<void> _editRoom(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(L10n.s('edit_confirm_title')),
        content: Text(L10n.s('edit_confirm_desc')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(L10n.s('cancel'))),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: Text(L10n.s('continue'))),
        ],
      ),
    );

    if (confirmed != true) return;

    if (!context.mounted) return;
    Navigator.of(context).push(
      _modernRoute(TeacherEditPage(roomCode: roomCode)),
    );
  }

  Future<void> _deleteRoom(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(L10n.s('delete')),
        content: Text(L10n.s('confirm_delete')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(L10n.s('cancel'))),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: Text(L10n.s('delete')),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await FirebaseFirestore.instance.collection('rooms').doc(roomCode).delete();
      await _Persistence.removeTeacherRoom(roomCode);
      // Clear draft on success
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('draft_$roomCode');

      if (!context.mounted) return;
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final roomRef = FirebaseFirestore.instance.collection('rooms').doc(roomCode);

    return ValueListenableBuilder<AppLanguage>(
      valueListenable: _LanguageController.instance,
      builder: (context, lang, _) {
        return _GradientScaffold(
          appBar: AppBar(
            title: Text(L10n.s('room_code')),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_rounded),
                tooltip: 'Редактировать тест',
                onPressed: () => _editRoom(context),
              ),
              IconButton(icon: const Icon(Icons.copy_rounded), onPressed: () => _duplicateRoom(context)),
              IconButton(icon: const Icon(Icons.delete_forever_rounded, color: Colors.redAccent), onPressed: () => _deleteRoom(context)),
              const _LanguageSwitch(),
              const _ThemeSwitch(),
            ],
          ),
          body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: roomRef.snapshots(),
            builder: (context, roomSnapshot) {
              return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: roomRef.collection('questions').orderBy('index').snapshots(),
                builder: (context, questionsSnapshot) {
                  final questions = questionsSnapshot.data?.docs ?? [];

                  return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: roomRef.collection('submissions').orderBy('submittedAt', descending: true).snapshots(),
                    builder: (context, submissionSnapshot) {
                      if (submissionSnapshot.hasError) {
                        return _StateMessage(icon: Icons.error_outline, title: L10n.s('error'));
                      }
                      if (!submissionSnapshot.hasData || !roomSnapshot.hasData) {
                        return _StateMessage(icon: Icons.hourglass_top_rounded, title: L10n.s('loading'), isLoading: true);
                      }

                      final docs = submissionSnapshot.data!.docs;
                      final roomData = roomSnapshot.data!.data() ?? {};
                      if (roomData.isEmpty) {
                        return _StateMessage(icon: Icons.delete_outline, title: L10n.s('room_not_found'));
                      }

                      final status = roomData['status']?.toString() ?? 'active';
                      final isClosed = status == 'closed';
                      final stats = _buildStats(docs);
                      final insights = _buildInsights(docs, questions);

                      return RefreshIndicator(
                        onRefresh: () async => Future.delayed(const Duration(seconds: 1)),
                        child: CustomScrollView(
                          slivers: [
                            SliverPadding(
                              padding: const EdgeInsets.all(16),
                              sliver: SliverList(
                                delegate: SliverChildListDelegate([
                                  // Код комнаты + QR
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Theme.of(context).colorScheme.primary,
                                          Theme.of(context).colorScheme.secondary,
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(24),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                                          blurRadius: 12,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    padding: const EdgeInsets.all(24),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              if (roomData['testTitle'] != null) ...[
                                                Text(
                                                  roomData['testTitle'].toString(),
                                                  style: const TextStyle(
                                                      fontSize: 20,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.white,
                                                      letterSpacing: 0.5),
                                                ),
                                                const SizedBox(height: 8),
                                              ],
                                              Text(L10n.s('room_code'),
                                                  style: const TextStyle(fontSize: 14, color: Colors.white70, fontWeight: FontWeight.w600)),
                                              const SizedBox(height: 4),
                                              Text(roomCode,
                                                  style: const TextStyle(
                                                      fontSize: 38,
                                                      fontWeight: FontWeight.w900,
                                                      color: Colors.white,
                                                      letterSpacing: 4)),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(16),
                                          ),
                                          child: QrImageView(
                                              data: roomCode,
                                              version: QrVersions.auto,
                                              size: 80,
                                              gapless: false),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 20),

                                  // Статус комнаты
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: isClosed 
                                          ? Colors.red.withValues(alpha: 0.05) 
                                          : Colors.green.withValues(alpha: 0.05),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: isClosed 
                                            ? Colors.red.withValues(alpha: 0.1) 
                                            : Colors.green.withValues(alpha: 0.1),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          isClosed ? Icons.lock_outline_rounded : Icons.lock_open_rounded,
                                          color: isClosed ? Colors.red : Colors.green,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            isClosed ? L10n.s('room_closed') : L10n.s('room_active'),
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                              color: isClosed ? Colors.red.shade800 : Colors.green.shade800,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        SizedBox(
                                          height: 40, // Фиксированная высота кнопки для аккуратности
                                          child: FilledButton(
                                            onPressed: () => roomRef.update({'status': isClosed ? 'active' : 'closed'}),
                                            style: FilledButton.styleFrom(
                                              backgroundColor: isClosed ? Colors.green : Colors.redAccent,
                                              padding: const EdgeInsets.symmetric(horizontal: 20),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                            ),
                                            child: Text(
                                              isClosed ? L10n.s('open') : L10n.s('close'),
                                              style: const TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  
                                  if (docs.isEmpty)
                                    _StateMessage(
                                      icon: Icons.inbox_rounded,
                                      title: L10n.s('no_submissions'),
                                      subtitle: L10n.s('room_active'),
                                    )
                                  else ...[
                                    // Секция Статистика
                                    _SectionHeader(title: L10n.s('accuracy')),
                                    const SizedBox(height: 12),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 5,
                                          child: Column(
                                            children: [
                                              _ModernStatCard(
                                                  icon: Icons.groups_rounded,
                                                  value: docs.length.toString(),
                                                  label: L10n.s('submissions'),
                                                  color: Colors.blue),
                                              const SizedBox(height: 12),
                                              _ModernStatCard(
                                                  icon: Icons.grade_rounded,
                                                  value: stats.averageGrade.toStringAsFixed(1),
                                                  label: L10n.s('avg_grade'),
                                                  color: Colors.orange),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          flex: 4,
                                          child: Card(
                                            child: Padding(
                                              padding: const EdgeInsets.all(16),
                                              child: Column(
                                                children: [
                                                  SizedBox(
                                                    height: 160,
                                                    child: AnimatedGradeChart(docs: docs),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 24),

                                    // Секция Аналитика
                                    Row(
                                      children: [
                                        Expanded(child: _TopStudentsCard(insights: insights)),
                                        const SizedBox(width: 12),
                                        Expanded(child: _HardQuestionsCard(insights: insights, questions: questions)),
                                      ],
                                    ),
                                    const SizedBox(height: 24),

                                    // Секция Экспорт
                                    _SectionHeader(title: L10n.s('export')),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: _ExportButton(
                                            onPressed: () => _exportToPDF(context, docs, questions),
                                            icon: Icons.picture_as_pdf_rounded,
                                            label: L10n.s('full_report'),
                                            color: Colors.deepOrange,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: _ExportButton(
                                            onPressed: () => _exportAllCertificates(context, docs),
                                            icon: Icons.card_membership_rounded,
                                            label: L10n.s('all_certificates'),
                                            color: Colors.purple,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: _ExportButton(
                                            onPressed: () => _exportToCSV(context, docs),
                                            icon: Icons.table_view_rounded,
                                            label: L10n.s('export'),
                                            color: Colors.blue.shade700,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 32),

                                    // Секция Список ответов
                                    _SectionHeader(title: L10n.s('submissions')),
                                    const SizedBox(height: 12),
                                  ],
                                ]),
                              ),
                            ),
                            if (docs.isNotEmpty)
                              SliverPadding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                sliver: SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                    (context, index) => _SubmissionCard(
                                      roomCode: roomCode,
                                      doc: docs[index],
                                      questionsMap: {for (var q in questions) q.id: q.data()['text']?.toString() ?? ''},
                                      onCertificatePressed: () => _exportStudentCertificate(context, docs[index]),
                                    ),
                                    childCount: docs.length,
                                  ),
                                ),
                              ),
                            const SliverToBoxAdapter(child: SizedBox(height: 40)),
                          ],
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, letterSpacing: 0.5),
    );
  }
}

class _ExportButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String label;
  final Color color;

  const _ExportButton({
    required this.onPressed,
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          decoration: BoxDecoration(
            border: Border.all(color: color.withValues(alpha: 0.3)),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SubmissionCard extends StatelessWidget {
  const _SubmissionCard({
    required this.roomCode,
    required this.doc,
    required this.questionsMap,
    required this.onCertificatePressed,
  });

  final String roomCode;
  final QueryDocumentSnapshot<Map<String, dynamic>> doc;
  final Map<String, String> questionsMap;
  final VoidCallback onCertificatePressed;

  @override
  Widget build(BuildContext context) {
    final data = doc.data();
    final answers = (data['answers'] as Map?)?.cast<String, dynamic>() ?? {};
    final perQuestionCorrect = (data['perQuestionCorrect'] as Map?)?.cast<String, bool>() ?? {};
    final appLeaves = (data['appLeaveCount'] as num?)?.toInt() ?? 0;
    final attempt = data['attemptNumber'] ?? 1;
    final allowRetake = data['allowRetake'] == true;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          title: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${data['studentName'] ?? "Ученик"} (${data['studentGroup'] ?? "-"})',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${L10n.s('attempt_label')} #$attempt • ${data['correctCount']}/${data['totalQuestions']} верно • ${appLeaves > 0 ? "⚠️ $appLeaves выходов" : "Стабильно"}',
                      style: TextStyle(
                        fontSize: 13,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text('${data['grade']}', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 20)),
              ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(
                  allowRetake ? Icons.lock_open_rounded : Icons.lock_outline_rounded,
                  color: allowRetake ? Colors.green : Colors.orange,
                ),
                tooltip: allowRetake ? L10n.s('close_access') : L10n.s('open_access'),
                onPressed: () async {
                  final studentKey = (data['studentKey'] ?? '').toString();
                  final studentGroup = (data['studentGroup'] ?? '').toString();
                  final studentName = (data['studentName'] ?? 'Ученик').toString();
                  await _setIndividualAccess(
                    roomCode: roomCode,
                    studentKey: studentKey.isEmpty ? 'student' : studentKey,
                    studentGroup: studentGroup,
                    studentName: studentName,
                    granted: !allowRetake,
                    submissionRef: doc.reference,
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.download_for_offline_rounded, color: Colors.teal, size: 28),
                onPressed: onCertificatePressed,
              ),
            ],
          ),
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
              child: Column(
                children: answers.entries.map((entry) {
                  final qText = questionsMap[entry.key] ?? entry.key;
                  final isCorrect = perQuestionCorrect[entry.key] ?? false;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          isCorrect ? Icons.check_circle_rounded : Icons.cancel_rounded,
                          size: 20,
                          color: isCorrect ? Colors.green : Colors.redAccent,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            qText,
                            style: const TextStyle(fontSize: 14, height: 1.3),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          entry.value.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isCorrect ? Colors.green : Colors.redAccent,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnimatedGradeChart extends StatefulWidget {
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> docs;
  const AnimatedGradeChart({super.key, required this.docs});

  @override
  State<AnimatedGradeChart> createState() => _AnimatedGradeChartState();
}

class _AnimatedGradeChartState extends State<AnimatedGradeChart> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: PieChart(
        PieChartData(
          sectionsSpace: 4,
          centerSpaceRadius: 45,
          startDegreeOffset: -90,
          sections: _buildSections(),
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildSections() {
    final counts = <int, int>{2: 0, 3: 0, 4: 0, 5: 0};
    for (final doc in widget.docs) {
      final g = (doc.data()['grade'] as num?)?.toInt() ?? 2;
      counts[g] = (counts[g] ?? 0) + 1;
    }

    final colors = {5: Colors.green, 4: Colors.blue, 3: Colors.orange, 2: Colors.red};

    return counts.entries.map((e) {
      return PieChartSectionData(
        color: colors[e.key]!,
        value: e.value.toDouble(),
        title: e.value > 0 ? '${e.key}' : '',
        radius: 40,
        titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
      );
    }).toList();
  }
}

class _ModernStatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _ModernStatCard({required this.icon, required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(16)),
              child: Icon(icon, color: color, size: 34),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(value, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800, height: 1)),
                  Text(label, style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopStudentsCard extends StatelessWidget {
  const _TopStudentsCard({required this.insights});

  final _RoomInsights insights;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.emoji_events_rounded, color: Colors.amber),
                const SizedBox(width: 8),
                Text(
                  L10n.s('top_students'),
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (insights.topStudents.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Text('Пока нет данных', style: TextStyle(color: Colors.grey)),
                ),
              )
            else
              ...insights.topStudents.map((student) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Colors.amber.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              "${insights.topStudents.indexOf(student) + 1}",
                              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.amber),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            student.name,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ),
                        Text(
                          student.avgGrade.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  )),
          ],
        ),
      ),
    );
  }
}

class _HardQuestionsCard extends StatelessWidget {
  const _HardQuestionsCard({required this.insights, required this.questions});

  final _RoomInsights insights;
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> questions;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.warning_amber_rounded, color: Colors.redAccent),
                const SizedBox(width: 8),
                Text(L10n.s('hard_questions'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              ],
            ),
            const SizedBox(height: 16),
            if (insights.hardestQuestions.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Text('Пока нет данных', style: TextStyle(color: Colors.grey)),
                ),
              )
            else
              ...insights.hardestQuestions.map((q) {
                final questionText = q.questionText.isNotEmpty ? q.questionText : 'Вопрос ${q.questionIndex + 1}';

                return Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.redAccent.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            "${q.questionIndex + 1}",
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Tooltip(
                          message: questionText,
                          child: Text(
                            questionText,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 14.5, height: 1.35),
                          ),
                        ),
                      ),
                      Text(
                        "${q.correctPercent.toStringAsFixed(0)}%",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: q.correctPercent < 35 ? Colors.redAccent : Colors.orange,
                        ),
                      ),
                    ],
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}

class QRScannerPage extends StatelessWidget {
  const QRScannerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(L10n.s('enter_code')),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.black,
      body: MobileScanner(
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          for (final barcode in barcodes) {
            if (barcode.rawValue != null) {
              Navigator.pop(context, barcode.rawValue);
              break;
            }
          }
        },
      ),
    );
  }
}

class StudentJoinPage extends StatefulWidget {
  const StudentJoinPage({super.key});

  @override
  State<StudentJoinPage> createState() => _StudentJoinPageState();
}

class _StudentJoinPageState extends State<StudentJoinPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _groupController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _Persistence.getStudentInfo().then((info) {
      if (mounted) {
        setState(() {
          _nameController.text = info['name'] ?? '';
          _groupController.text = info['group'] ?? '';
        });
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _groupController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _join() async {
    final name = _nameController.text.trim();
    final group = _groupController.text.trim();
    final roomCode = _codeController.text.trim().toUpperCase();

    if (name.isEmpty || group.isEmpty || roomCode.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(L10n.s('required_fields'))),
        );
      }
      return;
    }

    await _Persistence.saveStudentInfo(name, group);
    if (!context.mounted) return;

    try {
      final firestore = FirebaseFirestore.instance;
      final roomDoc = await firestore.collection('rooms').doc(roomCode).get();

      if (!roomDoc.exists) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(L10n.s('room_not_found'))),
          );
        }
        return;
      }

      final roomData = roomDoc.data()!;
      final bool isRoomClosed = roomData['status'] == 'closed';

      final studentKey = _studentKeyFromName(name);

      // Ищем предыдущие попытки
      final existing = await firestore
          .collection('rooms')
          .doc(roomCode)
          .collection('submissions')
          .where('studentKey', isEqualTo: studentKey)
          .where('studentGroup', isEqualTo: group)
          .get();

      final individuallyAuthorized = await _hasIndividualAccess(
        firestore: firestore,
        roomCode: roomCode,
        studentKey: studentKey,
        studentGroup: group,
        submissions: existing.docs,
      );

      final hasPreviousAttempt = existing.docs.isNotEmpty;
      String? denyMessageKey;

      if (isRoomClosed && !individuallyAuthorized) {
        denyMessageKey = 'room_closed_entry';
      } else if (hasPreviousAttempt && !individuallyAuthorized) {
        denyMessageKey = 'already_submitted';
      }

      if (denyMessageKey != null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(L10n.s(denyMessageKey)),
              backgroundColor: Colors.orange,
            ),
          );
        }
        return;
      }

      if (!mounted) return;

      Navigator.of(context).push(
        _modernRoute(
          StudentAnswerPage(
            roomCode: roomCode,
            studentName: name,
            studentGroup: group,
            individuallyAuthorized: individuallyAuthorized,
          ),
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppLanguage>(
      valueListenable: _LanguageController.instance,
      builder: (context, lang, _) {
        return _GradientScaffold(
          appBar: AppBar(
            title: Text(L10n.s('student')),
            actions: const [
              _LanguageSwitch(),
              _ThemeSwitch(),
            ],
          ),
          body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Padding(
              key: ValueKey(lang),
              padding: const EdgeInsets.all(16),
              child: Column(
              children: [
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: L10n.s('student_name'),
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _groupController,
                  decoration: InputDecoration(
                    labelText: L10n.s('student_group'),
                    hintText: L10n.s('group_hint'),
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _codeController,
                  textCapitalization: TextCapitalization.characters,
                  decoration: InputDecoration(
                    labelText: L10n.s('enter_code'),
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.qr_code_scanner_rounded, color: Color(0xFF00C4B4)),
                      onPressed: () async {
                        final result = await Navigator.of(context).push<String>(
                          _modernRoute<String>(const QRScannerPage()),
                        );
                        if (result != null && mounted) {
                          setState(() => _codeController.text = result.trim().toUpperCase());
                          _join(); // Автоматический вход после сканирования
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: _join,
                  child: Text(L10n.s('join')),
                ),
              ],
            ),
          ),
        ),
        );
      },
    );
  }
}

class StudentAnswerPage extends StatefulWidget {
  const StudentAnswerPage({
    super.key,
    required this.roomCode,
    required this.studentName,
    required this.studentGroup,
    this.individuallyAuthorized = false,
  });

  final String roomCode;
  final String studentName;
  final String studentGroup;
  final bool individuallyAuthorized;

  @override
  State<StudentAnswerPage> createState() => _StudentAnswerPageState();
}

class _StudentAnswerPageState extends State<StudentAnswerPage> with WidgetsBindingObserver {
  final Map<String, TextEditingController> _shortControllers = {};
  final Map<String, bool> _tfAnswers = {};
  final Map<String, int> _mcqAnswers = {};
  final PageController _pageController = PageController();

  bool _submitting = false;
  Timer? _timer;
  int? _remainingSeconds;
  DateTime? _startedAt;
  bool _autoSubmitted = false;
  List<QueryDocumentSnapshot<Map<String, dynamic>>>? _shuffledDocs;
  int _appLeaveCount = 0;
  int _currentIndex = 0;
  bool _roomClosed = false;

  String get _studentKey => _studentKeyFromName(widget.studentName);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadDraft();
  }

  Future<void> _saveDraft() async {
    final prefs = await SharedPreferences.getInstance();
    final draft = <String, dynamic>{
      'tf': _tfAnswers,
      'mcq': _mcqAnswers,
      'short': _shortControllers.map((k, v) => MapEntry(k, v.text)),
    };
    await prefs.setString('draft_${widget.roomCode}', jsonEncode(draft));
  }

  Future<void> _loadDraft() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('draft_${widget.roomCode}');
    if (data != null) {
      final json = jsonDecode(data) as Map<String, dynamic>;
      setState(() {
        if (json['tf'] != null) (json['tf'] as Map).forEach((k, v) => _tfAnswers[k.toString()] = v as bool);
        if (json['mcq'] != null) (json['mcq'] as Map).forEach((k, v) => _mcqAnswers[k.toString()] = v as int);
        if (json['short'] != null) {
          (json['short'] as Map).forEach((k, v) {
            _shortControllers[k.toString()] = TextEditingController(text: v.toString());
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    for (final controller in _shortControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.hidden) {
      _appLeaveCount++;
      HapticFeedback.vibrate();
      // АВТО-ЗАВЕРШЕНИЕ ПРИ ВЫХОДЕ (нарушение: сворачивание, другая вкладка на Web)
      if (!_submitting && !_autoSubmitted) {
        _autoSubmitted = true;
        _submit(
          _shuffledDocs ?? [],
          roomClosed: _roomClosed,
          isAuto: true,
        );
      }
    }
  }

  void _ensureTimerStarted(int? durationSeconds) {
    if (durationSeconds == null || _timer != null || _remainingSeconds != null) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _startedAt ??= DateTime.now();
      setState(() => _remainingSeconds = durationSeconds);

      _timer = Timer.periodic(const Duration(seconds: 1), (t) {
        if (!mounted) {
          t.cancel();
          return;
        }
        setState(() {
          if (_remainingSeconds != null && _remainingSeconds! > 0) {
            _remainingSeconds = _remainingSeconds! - 1;
          }
          if (_remainingSeconds == 0 && !_submitting && !_autoSubmitted) {
            _autoSubmitted = true;
            _submit(
              _shuffledDocs ?? [],
              roomClosed: _roomClosed,
              isAuto: true,
            );
          }
        });
      });
    });
  }



  Future<void> _submit(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs, {
    required bool roomClosed,
    String? testTitle,
    bool isAuto = false,
    bool hasIndividualPass = false,
  }) async {
    final canSubmitWhenClosed = hasIndividualPass || widget.individuallyAuthorized;

    if (roomClosed && !canSubmitWhenClosed && !isAuto) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(L10n.s('room_closed_submit'))),
        );
      }
      return;
    }

    if (!isAuto) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (c) => AlertDialog(
          title: Text(L10n.s('confirm_finish')),
          content: Text(L10n.s('confirm_finish_desc')),
          actions: [
            TextButton(onPressed: () => Navigator.pop(c, false), child: Text(L10n.s('cancel'))),
            FilledButton(onPressed: () => Navigator.pop(c, true), child: Text(L10n.s('send_answers'))),
          ],
        ),
      );

      if (confirmed != true) return;
    }

    setState(() => _submitting = true);

    final answers = <String, dynamic>{};
    final perQuestion = <String, bool>{};
    var correctCount = 0;

    for (final doc in docs) {
      final data = doc.data();
      final qid = doc.id;
      final type = (data['type'] ?? 'short').toString();
      bool isCorrect = false;

      if (type == 'trueFalse') {
        final ans = _tfAnswers[qid];
        final expected = (data['correctBool'] as bool?) ?? false;
        answers[qid] = ans;
        isCorrect = ans != null && ans == expected;
      } else if (type == 'mcq') {
        final ans = _mcqAnswers[qid];
        final expected = (data['correctIndex'] as num?)?.toInt();
        answers[qid] = ans;
        isCorrect = ans != null && expected != null && ans == expected;
      } else {
        final answer = _shortControllers[qid]?.text.trim() ?? '';
        final expected = (data['correctAnswer'] ?? '').toString();
        answers[qid] = answer;
        final similarity = _similarity(_normalize(answer), _normalize(expected));
        isCorrect = similarity >= 0.73;
      }

      perQuestion[qid] = isCorrect;
      if (isCorrect) correctCount++;
    }

    HapticFeedback.heavyImpact();

    final total = docs.length;
    final grade = _calculateGrade(correctCount: correctCount, total: total);

    final safeName = _studentKey;

    try {
      final submissions = await FirebaseFirestore.instance
          .collection('rooms')
          .doc(widget.roomCode)
          .collection('submissions')
          .where('studentKey', isEqualTo: safeName.isEmpty ? 'student' : safeName)
          .where('studentGroup', isEqualTo: widget.studentGroup)
          .get();

      final attemptNumber = submissions.docs.length + 1;

      await FirebaseFirestore.instance
          .collection('rooms')
          .doc(widget.roomCode)
          .collection('submissions')
          .add({
        'studentName': widget.studentName,
        'studentGroup': widget.studentGroup,
        'studentKey': safeName.isEmpty ? 'student' : safeName,
        'answers': answers,
        'perQuestionCorrect': perQuestion,
        'correctCount': correctCount,
        'totalQuestions': total,
        'grade': grade,
        'attemptNumber': attemptNumber,
        'startedAt': _startedAt?.toIso8601String(),
        'durationSeconds': _remainingSeconds,
        'appLeaveCount': _appLeaveCount,
        'allowRetake': false,
        'submittedAt': FieldValue.serverTimestamp(),
      });

      await _burnIndividualAccess(
        roomCode: widget.roomCode,
        studentKey: safeName,
        studentGroup: widget.studentGroup,
      );

      await _Persistence.addStudentResult({
        'roomCode': widget.roomCode,
        'testTitle': testTitle,
        'grade': grade,
        'correctCount': correctCount,
        'totalQuestions': total,
      });

      // Очистка черновика
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('draft_${widget.roomCode}');

      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        _modernRoute(
          StudentResultPage(
            roomCode: widget.roomCode,
            studentName: widget.studentName,
            studentGroup: widget.studentGroup,
            correctCount: correctCount,
            totalQuestions: total,
            grade: grade,
            perQuestionCorrect: perQuestion,
            answers: answers,
            questions: docs,
          ),
          replace: true,
        ),
      );
    } on FirebaseException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка Firebase: ${e.code}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _submitting = false);
      }
    }
  }

  // ====================== BUILD ======================
  @override
  Widget build(BuildContext context) {
    final questionStream = FirebaseFirestore.instance
        .collection('rooms')
        .doc(widget.roomCode)
        .collection('questions')
        .orderBy('index')
        .snapshots();

    final roomRef = FirebaseFirestore.instance.collection('rooms').doc(widget.roomCode);

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: roomRef.snapshots(),
      builder: (context, roomSnap) {
        final room = roomSnap.data?.data();
        final roomClosed = room?['status'] == 'closed';
        _roomClosed = roomClosed;
        final testTitle = room?['testTitle']?.toString();
        final durationSeconds = (room?['durationSeconds'] as num?)?.toInt();
        if (durationSeconds != null) _ensureTimerStarted(durationSeconds);

        final grantStream = roomRef
            .collection('accessGrants')
            .doc(_accessGrantDocId(_studentKey, widget.studentGroup))
            .snapshots();

        final studentSubsStream = roomRef
            .collection('submissions')
            .where('studentKey', isEqualTo: _studentKey)
            .where('studentGroup', isEqualTo: widget.studentGroup)
            .snapshots();

        return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: grantStream,
          builder: (context, grantSnap) {
            return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: studentSubsStream,
              builder: (context, subsSnap) {
                final hasIndividualPass = widget.individuallyAuthorized ||
                    _individualPassFromSnapshots(
                      grantSnap: grantSnap.data,
                      subsSnap: subsSnap.data,
                    );
                final canSubmit = !roomClosed || hasIndividualPass;

                return _GradientScaffold(
                  appBar: AppBar(
                    title: Text(testTitle ?? '${L10n.s('room_code')} ${widget.roomCode}'),
                    actions: const [_LanguageSwitch(), _ThemeSwitch()],
                  ),
                  body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: questionStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return _StateMessage(icon: Icons.error_outline, title: L10n.s('error'));
                      }
                      if (!snapshot.hasData) {
                        return _StateMessage(
                          icon: Icons.hourglass_top_rounded,
                          title: L10n.s('loading'),
                          isLoading: true,
                        );
                      }

                      final docsFromSnapshot = snapshot.data!.docs;
                      if (docsFromSnapshot.isEmpty) {
                        return _StateMessage(icon: Icons.help_outline_rounded, title: L10n.s('no_data'));
                      }

                      _shuffledDocs ??= List.from(docsFromSnapshot)..shuffle();
                      final docs = _shuffledDocs!;

                      final remaining = _remainingSeconds;
                      if (remaining == 0 && !_submitting && !_autoSubmitted) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (!mounted || _autoSubmitted || _submitting) return;
                          _autoSubmitted = true;
                          _submit(
                            docs,
                            roomClosed: roomClosed,
                            testTitle: testTitle,
                            isAuto: true,
                            hasIndividualPass: hasIndividualPass,
                          );
                        });
                      }

                      final isCritical = remaining != null && remaining <= 300; // 5 минут
              final isDanger = remaining != null && remaining <= 60;

              final timerText = remaining == null
                  ? '--:--'
                  : '${(remaining ~/ 60).toString().padLeft(2, '0')}:${(remaining % 60).toString().padLeft(2, '0')}';

                      return ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          if (roomClosed) ...[
                            Container(
                              width: double.infinity,
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: hasIndividualPass
                                    ? Colors.green.withValues(alpha: 0.12)
                                    : Colors.red.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: hasIndividualPass ? Colors.green : Colors.red,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    hasIndividualPass ? Icons.lock_open_rounded : Icons.lock_outline_rounded,
                                    color: hasIndividualPass ? Colors.green : Colors.red,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      hasIndividualPass
                                          ? L10n.s('individual_access_active')
                                          : L10n.s('room_closed_submit'),
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: hasIndividualPass ? Colors.green.shade800 : Colors.red.shade800,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          // Таймер + Информация
                          Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.studentName,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                              Text('${L10n.s('question')} ${_currentIndex + 1} / ${docs.length}',
                                  style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w600)),
                            ],
                          ),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            decoration: BoxDecoration(
                              color: isDanger
                                  ? Colors.red.withValues(alpha: 0.1)
                                  : isCritical
                                      ? Colors.orange.withValues(alpha: 0.1)
                                      : Colors.green.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isDanger ? Colors.red : isCritical ? Colors.orange : Colors.green,
                                width: 2,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.timer_outlined,
                                    color: isDanger ? Colors.red : isCritical ? Colors.orange : Colors.green),
                                const SizedBox(width: 8),
                                Text(
                                  timerText,
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: isDanger ? Colors.red : isCritical ? Colors.orange : Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      if (remaining != null && durationSeconds != null) ...[
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: remaining / durationSeconds,
                            minHeight: 6,
                            backgroundColor: (isDanger ? Colors.red : isCritical ? Colors.orange : Colors.green).withValues(alpha: 0.1),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              isDanger ? Colors.red : isCritical ? Colors.orange : Colors.green,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Мини-карта вопросов
                  SizedBox(
                    height: 48,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: docs.length,
                      separatorBuilder: (context, index) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final isAnswered = _tfAnswers.containsKey(docs[index].id) ||
                            _mcqAnswers.containsKey(docs[index].id) ||
                            (_shortControllers[docs[index].id]?.text.isNotEmpty ?? false);
                        final isCurrent = _currentIndex == index;

                        return GestureDetector(
                          onTap: () => _pageController.animateToPage(index,
                              duration: const Duration(milliseconds: 300), curve: Curves.easeInOut),
                          child: Container(
                            width: 42,
                            decoration: BoxDecoration(
                              color: isCurrent
                                  ? Theme.of(context).colorScheme.primary
                                  : isAnswered
                                      ? Colors.green.withValues(alpha: 0.25)
                                      : null,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Theme.of(context).dividerColor),
                            ),
                            child: Center(
                              child: Text(
                                '${index + 1}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isCurrent ? Colors.white : null,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Вопросы (PageView)
                  SizedBox(
                    height: 380,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: docs.length,
                      onPageChanged: (i) => setState(() => _currentIndex = i),
                      itemBuilder: (context, index) { 
                        final doc = docs[index];
                        final data = doc.data();
                        final type = (data['type'] ?? 'short').toString();
                        final text = (data['text'] ?? '').toString();

                        return SingleChildScrollView(
                          child: Card(
                            margin: EdgeInsets.zero,
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    text,
                                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                                  ),
                                  const SizedBox(height: 24),
                                  if (type == 'trueFalse')
                                    SizedBox(
                                      width: double.infinity,
                                      child: SegmentedButton<bool>(
                                        segments: [
                                          ButtonSegment(value: true, label: Text(L10n.s('true'))),
                                          ButtonSegment(value: false, label: Text(L10n.s('false'))),
                                        ],
                                        selected: {
                                          if (_tfAnswers.containsKey(doc.id)) _tfAnswers[doc.id]!,
                                        },
                                        emptySelectionAllowed: true,
                                        onSelectionChanged: (v) {
                                          if (v.isEmpty) return;
                                          HapticFeedback.lightImpact();
                                          setState(() => _tfAnswers[doc.id] = v.first);
                                          _saveDraft();
                                        },
                                      ),
                                    )
                                  else if (type == 'mcq')
                                    Builder(
                                      builder: (context) {
                                        final options = (data['options'] as List?)
                                                ?.map((e) => e.toString())
                                                .toList() ??
                                            const <String>[];
                                        if (options.isEmpty) return Text(L10n.s('no_data'));

                                        return Column(
                                          children: List.generate(options.length, (i) {
                                            final isSelected = _mcqAnswers[doc.id] == i;
                                            return Padding(
                                              padding: const EdgeInsets.only(bottom: 8),
                                              child: InkWell(
                                                onTap: () {
                                                  HapticFeedback.lightImpact();
                                                  setState(() => _mcqAnswers[doc.id] = i);
                                                  _saveDraft();
                                                },
                                                borderRadius: BorderRadius.circular(12),
                                                child: Container(
                                                  padding: const EdgeInsets.all(16),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: isSelected
                                                          ? Theme.of(context).colorScheme.primary
                                                          : Theme.of(context).colorScheme.outlineVariant,
                                                      width: isSelected ? 2 : 1,
                                                    ),
                                                    color: isSelected
                                                        ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.05)
                                                        : null,
                                                    borderRadius: BorderRadius.circular(12),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        isSelected ? Icons.check_circle : Icons.circle_outlined,
                                                        color: isSelected ? Theme.of(context).colorScheme.primary : null,
                                                      ),
                                                      const SizedBox(width: 12),
                                                      Expanded(child: Text(options[i])),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          }),
                                        );
                                      },
                                    )
                                  else
                                    TextField(
                                      controller: _shortControllers.putIfAbsent(
                                        doc.id,
                                        () => TextEditingController()..addListener(_saveDraft),
                                      ),
                                      maxLines: 3,
                                      decoration: InputDecoration(
                                        hintText: L10n.s('short_answer'),
                                        border: const OutlineInputBorder(),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Навигация + Завершить
                  Row(
                    children: [
                      if (_currentIndex > 0)
                        OutlinedButton.icon(
                          onPressed: () => _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut),
                          icon: const Icon(Icons.arrow_back),
                          label: Text(L10n.s('back')),
                        )
                      else
                        const SizedBox(width: 80),

                      const Spacer(),

                      if (_currentIndex < docs.length - 1)
                        FilledButton.icon(
                          onPressed: () => _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut),
                          icon: const Icon(Icons.arrow_forward),
                          label: Text(L10n.s('next')),
                        )
                      else
                        FilledButton.icon(
                          onPressed: canSubmit && !_submitting
                              ? () => _submit(
                                    docs,
                                    roomClosed: roomClosed,
                                    testTitle: testTitle,
                                    hasIndividualPass: hasIndividualPass,
                                  )
                              : null,
                          icon: const Icon(Icons.send),
                          label: Text(_submitting ? L10n.s('sending') : L10n.s('finish_test')),
                          style: FilledButton.styleFrom(backgroundColor: Colors.green, minimumSize: const Size(180, 56)),
                        ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Всегда видимая кнопка завершения
                  if (_currentIndex == docs.length - 1)
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: canSubmit && !_submitting
                            ? () => _submit(
                                  docs,
                                  roomClosed: roomClosed,
                                  testTitle: testTitle,
                                  hasIndividualPass: hasIndividualPass,
                                )
                            : null,
                        icon: const Icon(Icons.check_circle_outline, color: Colors.green),
                        label: Text(L10n.s('finish_and_send'), style: const TextStyle(fontSize: 16)),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.green,
                          side: const BorderSide(color: Colors.green, width: 2),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                        ],
                      );
                    },
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

class StudentResultPage extends StatelessWidget {
  const StudentResultPage({
    super.key,
    required this.roomCode,
    required this.studentName,
    required this.studentGroup,
    required this.correctCount,
    required this.totalQuestions,
    required this.grade,
    required this.perQuestionCorrect,
    required this.answers,
    required this.questions,
  });

  final String roomCode;
  final String studentName;
  final String studentGroup;
  final int correctCount;
  final int totalQuestions;
  final int grade;
  final Map<String, bool> perQuestionCorrect;
  final Map<String, dynamic> answers;
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> questions;

  Future<void> _downloadCertificate(BuildContext context) async {
    final pdf = pw.Document();
    final bold = await PdfGoogleFonts.robotoBold();
    final regular = await PdfGoogleFonts.robotoRegular();

    // Fetch teacher profile
    String teacherName = roomCode;
    try {
      final roomDoc = await FirebaseFirestore.instance.collection('rooms').doc(roomCode).get();
      final ownerId = roomDoc.data()?['ownerId'];
      if (ownerId != null) {
        final profile = await FirebaseFirestore.instance.collection('users').doc(ownerId).get();
        teacherName = profile.data()?['name'] ?? L10n.s('teacher');
      }
    } catch (_) {}

    pw.MemoryImage? logo;
    try {
      logo = pw.MemoryImage((await rootBundle.load('assets/logo.png')).buffer.asUint8List());
    } catch (_) {}

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4.landscape,
        theme: pw.ThemeData.withFont(base: regular, bold: bold),
        build: (pw.Context context) => pw.Stack(
          children: [
            // Водяные знаки на фоне
            pw.Positioned.fill(
              child: pw.Opacity(
                opacity: 0.04,
                child: pw.Transform.rotate(
                  angle: 0.3,
                  child: pw.Center(
                    child: pw.Wrap(
                      spacing: 50,
                      runSpacing: 60,
                      children: List.generate(
                        15,
                        (_) => pw.Text('URGANCH RAQAMLI TEXNOLOGIYALAR TEXNIKUMI',
                            style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            pw.Center(
              child: pw.Container(
                width: 720,
                height: 500,
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.teal800, width: 8),
                  borderRadius: const pw.BorderRadius.all(pw.Radius.circular(24)),
                ),
                child: pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: [
                    if (logo != null) pw.Image(logo, height: 80),
                    pw.SizedBox(height: 15),
                    pw.Text(L10n.s('brand_name'),
                        style: pw.TextStyle(font: bold, fontSize: 16, color: PdfColors.teal900, letterSpacing: 1.2)),
                    pw.SizedBox(height: 8),
                    pw.Divider(indent: 120, endIndent: 120, color: PdfColors.teal800),
                    pw.SizedBox(height: 15),
                    pw.Text(L10n.s('cert_title'),
                        style: pw.TextStyle(font: bold, fontSize: 32, color: PdfColors.teal800)),
                    pw.Text(L10n.s('cert_desc'), style: pw.TextStyle(font: regular, fontSize: 16)),
                    pw.SizedBox(height: 30),
                    pw.Text(studentName, style: pw.TextStyle(font: bold, fontSize: 24)),
                    pw.SizedBox(height: 6),
                    pw.Text('${L10n.s('student_group').replaceAll(' *', '')}: $studentGroup',
                        style: pw.TextStyle(font: regular, fontSize: 16)),
                    pw.SizedBox(height: 30),
                    pw.Text(L10n.s('grade_label'), style: pw.TextStyle(font: regular, fontSize: 20)),
                    pw.Text('$grade',
                        style: pw.TextStyle(font: bold, fontSize: 72, color: PdfColors.green800)),
                    pw.SizedBox(height: 25),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      children: [
                        pw.Text('${L10n.s('issued_by')}: $teacherName',
                            style: pw.TextStyle(font: regular, fontSize: 12, color: PdfColors.grey800)),
                      ],
                    ),
                    pw.SizedBox(height: 10),
                    pw.Text(
                        '${L10n.s('room_code')}: $roomCode • ${L10n.s('date')}: ${DateTime.now().toString().split('.')[0]}',
                        style: pw.TextStyle(font: regular, fontSize: 11, color: PdfColors.grey700)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
      name: 'Certificate_${studentName.replaceAll(' ', '_')}.pdf',
    );
  }

  @override
  Widget build(BuildContext context) {
    return _GradientScaffold(
      appBar: AppBar(
        title: Text(L10n.s('my_results')),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.home_rounded),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Icon(Icons.check_circle_outline_rounded, size: 64, color: Colors.green),
                  const SizedBox(height: 16),
                  Text(
                    '${L10n.s('grade_label')}: $grade',
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${L10n.s('correct_label')}: $correctCount / $totalQuestions',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () => _downloadCertificate(context),
                      icon: const Icon(Icons.workspace_premium_rounded),
                      label: Text(L10n.s('cert_title')),
                      style: FilledButton.styleFrom(backgroundColor: Colors.teal),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            L10n.s('questions_label'),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ...questions.map((doc) {
            final isCorrect = perQuestionCorrect[doc.id] ?? false;
            final studentAnswer = answers[doc.id]?.toString() ?? '-';
            final questionText = doc.data()['text'] ?? 'Question';

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: Icon(
                  isCorrect ? Icons.check_circle : Icons.cancel,
                  color: isCorrect ? Colors.green : Colors.redAccent,
                ),
                title: Text(questionText),
                subtitle: Text('${L10n.s('variant')}: $studentAnswer'),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _GradientScaffold extends StatelessWidget {
  const _GradientScaffold({
    required this.appBar,
    required this.body,
    this.drawer,
  });

  final PreferredSizeWidget appBar;
  final Widget body;
  final Widget? drawer;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: appBar,
      drawer: drawer,
      body: Stack(
        children: [
          // 1. Base Gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isDark
                    ? const [Color(0xFF111827), Color(0xFF0B1220)]
                    : const [Color(0xFFF1F5F9), Color(0xFFF8FAFC)],
              ),
            ),
          ),
          // 2. Decorative Blobs
          Positioned(
            top: -100,
            right: -50,
            child: _DecorativeCircle(
              size: 300,
              color: primaryColor.withValues(alpha: isDark ? 0.08 : 0.05),
            ),
          ),
          Positioned(
            bottom: -50,
            left: -80,
            child: _DecorativeCircle(
              size: 250,
              color: Colors.blue.withValues(alpha: isDark ? 0.08 : 0.05),
            ),
          ),
          // 3. Educational Pattern (Grid/Dots)
          Positioned.fill(
            child: CustomPaint(
              painter: _PatternPainter(
                color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.03),
              ),
            ),
          ),
          // 4. Repeating Brand Watermark
          Positioned.fill(
            child: IgnorePointer(
              child: Opacity(
                opacity: isDark ? 0.03 : 0.05,
                child: Transform.rotate(
                  angle: -0.2,
                  child: OverflowBox(
                    maxWidth: 2000,
                    maxHeight: 2000,
                    child: Wrap(
                      spacing: 40,
                      runSpacing: 40,
                      children: List.generate(
                        100,
                        (i) => Text(
                          L10n.s('brand_name').toUpperCase(),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // 5. Content
          SafeArea(child: body),
        ],
      ),
    );
  }
}

class _DecorativeCircle extends StatelessWidget {
  const _DecorativeCircle({required this.size, required this.color});
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}

class _PatternPainter extends CustomPainter {
  _PatternPainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.0;

    const spacing = 30.0;
    
    // Draw dots
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 1.0, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


class _ThemeController extends ValueNotifier<ThemeMode> {
  _ThemeController._() : super(ThemeMode.light);

  static final _ThemeController instance = _ThemeController._();

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt('app_theme');
    if (themeIndex != null && themeIndex < ThemeMode.values.length) {
      value = ThemeMode.values[themeIndex];
    }
  }

  void toggle() {
    value = value == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    SharedPreferences.getInstance().then((prefs) => prefs.setInt('app_theme', value.index));
  }

  bool get isDark => value == ThemeMode.dark;
}

class _ThemeSwitch extends StatelessWidget {
  const _ThemeSwitch();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: _ThemeController.instance,
      builder: (context, mode, _) {
        final isDark = mode == ThemeMode.dark;
        return IntrinsicWidth(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded),
              const SizedBox(width: 6),
              Switch.adaptive(
                value: isDark,
                onChanged: (_) => _ThemeController.instance.toggle(),
              ),
              const SizedBox(width: 6),
            ],
          ),
        );
      },
    );
  }
}

class _StateMessage extends StatelessWidget {
  const _StateMessage({
    required this.icon,
    required this.title,
    this.subtitle,
    this.isLoading = false,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onSurfaceVariant;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isLoading)
              const SizedBox(
                width: 48,
                height: 48,
                child: CircularProgressIndicator(strokeWidth: 3),
              )
            else
              Icon(icon, size: 80, color: color.withValues(alpha: 0.2)),
            const SizedBox(height: 24),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: TextStyle(color: color.withValues(alpha: 0.7)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _QuestionDifficulty {
  const _QuestionDifficulty({
    required this.questionId,
    required this.questionIndex,
    required this.questionText,
    required this.correctPercent,
  });

  final String questionId;
  final int questionIndex;
  final String questionText;
  final double correctPercent;
}

class _QuestionInput {
  _QuestionInput();

  _QuestionType type = _QuestionType.short;
  final TextEditingController question = TextEditingController();
  final TextEditingController answer = TextEditingController(); // short
  bool trueFalseValue = true; // trueFalse
  final List<TextEditingController> options = List.generate(
    4,
    (_) => TextEditingController(),
  );
  int correctIndex = 0; // mcq

  void dispose() {
    question.dispose();
    answer.dispose();
    for (final c in options) {
      c.dispose();
    }
  }

  List<Widget> buildAnswerEditor(void Function(void Function()) setState) {
    switch (type) {
      case _QuestionType.short:
        return [
          TextField(
            controller: answer,
            decoration: InputDecoration(
              labelText: L10n.s('correct_answer'),
              border: const OutlineInputBorder(),
            ),
          ),
        ];
      case _QuestionType.trueFalse:
        return [
          SegmentedButton<bool>(
            segments: [
              ButtonSegment(value: true, label: Text(L10n.s('true'))),
              ButtonSegment(value: false, label: Text(L10n.s('false'))),
            ],
            selected: {trueFalseValue},
            onSelectionChanged: (value) {
              setState(() => trueFalseValue = value.first);
            },
          ),
        ];
      case _QuestionType.mcq:
        return [
          ...List.generate(options.length, (i) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: TextField(
                controller: options[i],
                decoration: InputDecoration(
                  labelText: '${L10n.s('variant')} ${i + 1}',
                  border: const OutlineInputBorder(),
                ),
              ),
            );
          }),
          DropdownButtonFormField<int>(
            initialValue: correctIndex,
            decoration: InputDecoration(
              labelText: L10n.s('correct_answer'),
              border: const OutlineInputBorder(),
            ),
            items: List.generate(
              options.length,
              (i) => DropdownMenuItem(
                value: i,
                child: Text('${L10n.s('variant')} ${i + 1}'),
              ),
            ),
            onChanged: (v) {
              if (v == null) return;
              setState(() => correctIndex = v);
            },
          ),
        ];
    }
  }

  Map<String, dynamic>? toFirestore() {
    final text = question.text.trim();
    if (text.isEmpty) return null;
    switch (type) {
      case _QuestionType.short:
        final correct = answer.text.trim();
        if (correct.isEmpty) return null;
        return {
          'type': 'short',
          'text': text,
          'correctAnswer': correct,
        };
      case _QuestionType.trueFalse:
        return {
          'type': 'trueFalse',
          'text': text,
          'correctBool': trueFalseValue,
        };
      case _QuestionType.mcq:
        final opts = options.map((c) => c.text.trim()).toList();
        if (opts.any((o) => o.isEmpty)) return null;
        if (correctIndex < 0 || correctIndex >= opts.length) return null;
        return {
          'type': 'mcq',
          'text': text,
          'options': opts,
          'correctIndex': correctIndex,
        };
    }
  }
}

enum _QuestionType { short, trueFalse, mcq }

String _studentKeyFromName(String name) {
  final safeName = name.trim().toLowerCase()
      .replaceAll(RegExp(r'\s+'), '_')
      .replaceAll(RegExp(r'[^a-z0-9_а-яё]'), '');
  return safeName.isEmpty ? 'student' : safeName;
}

String _accessGrantDocId(String studentKey, String studentGroup) {
  return '${studentKey}_${studentGroup.replaceAll(RegExp(r'[/\\.]'), '_')}';
}

bool _individualPassFromSnapshots({
  DocumentSnapshot<Map<String, dynamic>>? grantSnap,
  QuerySnapshot<Map<String, dynamic>>? subsSnap,
}) {
  if (grantSnap?.data()?['granted'] == true) return true;
  if (subsSnap == null || subsSnap.docs.isEmpty) return false;

  DateTime latest = DateTime(0);
  bool allowRetake = false;
  for (final doc in subsSnap.docs) {
    final data = doc.data();
    final time = (data['submittedAt'] as Timestamp?)?.toDate() ?? DateTime(0);
    if (time.isAfter(latest)) {
      latest = time;
      allowRetake = data['allowRetake'] == true;
    }
  }
  return allowRetake;
}

Future<bool> _hasIndividualAccess({
  required FirebaseFirestore firestore,
  required String roomCode,
  required String studentKey,
  required String studentGroup,
  List<QueryDocumentSnapshot<Map<String, dynamic>>>? submissions,
}) async {
  final grantId = _accessGrantDocId(studentKey, studentGroup);
  final grant = await firestore
      .collection('rooms')
      .doc(roomCode)
      .collection('accessGrants')
      .doc(grantId)
      .get();
  if (grant.data()?['granted'] == true) return true;

  final docs = submissions ??
      (await firestore
              .collection('rooms')
              .doc(roomCode)
              .collection('submissions')
              .where('studentKey', isEqualTo: studentKey)
              .where('studentGroup', isEqualTo: studentGroup)
              .get())
          .docs;

  if (docs.isEmpty) return false;

  DateTime latest = DateTime(0);
  bool allowRetake = false;
  for (final doc in docs) {
    final data = doc.data();
    final time = (data['submittedAt'] as Timestamp?)?.toDate() ?? DateTime(0);
    if (time.isAfter(latest)) {
      latest = time;
      allowRetake = data['allowRetake'] == true;
    }
  }
  return allowRetake;
}

Future<void> _setIndividualAccess({
  required String roomCode,
  required String studentKey,
  required String studentGroup,
  required String studentName,
  required bool granted,
  DocumentReference<Map<String, dynamic>>? submissionRef,
}) async {
  final firestore = FirebaseFirestore.instance;
  final grantRef = firestore
      .collection('rooms')
      .doc(roomCode)
      .collection('accessGrants')
      .doc(_accessGrantDocId(studentKey, studentGroup));

  if (granted) {
    await grantRef.set({
      'granted': true,
      'studentKey': studentKey,
      'studentGroup': studentGroup,
      'studentName': studentName,
      'grantedAt': FieldValue.serverTimestamp(),
    });
    if (submissionRef != null) {
      await submissionRef.update({'allowRetake': true});
    }
  } else {
    await grantRef.delete();
    if (submissionRef != null) {
      await submissionRef.update({'allowRetake': false});
    }
    final subs = await firestore
        .collection('rooms')
        .doc(roomCode)
        .collection('submissions')
        .where('studentKey', isEqualTo: studentKey)
        .where('studentGroup', isEqualTo: studentGroup)
        .get();
    for (final d in subs.docs) {
      if (d.data()['allowRetake'] == true) {
        await d.reference.update({'allowRetake': false});
      }
    }
  }
}

Future<void> _burnIndividualAccess({
  required String roomCode,
  required String studentKey,
  required String studentGroup,
}) async {
  final firestore = FirebaseFirestore.instance;
  await firestore
      .collection('rooms')
      .doc(roomCode)
      .collection('accessGrants')
      .doc(_accessGrantDocId(studentKey, studentGroup))
      .delete();

  final subs = await firestore
      .collection('rooms')
      .doc(roomCode)
      .collection('submissions')
      .where('studentKey', isEqualTo: studentKey)
      .where('studentGroup', isEqualTo: studentGroup)
      .get();

  for (final d in subs.docs) {
    if (d.data()['allowRetake'] == true) {
      await d.reference.update({'allowRetake': false});
    }
  }
}

int _calculateGrade({required int correctCount, required int total}) {
  if (total <= 0) return 2;
  final ratio = correctCount / total;
  if (ratio >= 0.85) return 5;
  if (ratio >= 0.60) return 4;
  if (ratio >= 0.30) return 3;
  return 2;
}

String _normalize(String value) {
  if (value.isEmpty) return '';

  String text = value.toLowerCase().trim();

  // === 1. КИРИЛЛИЦА → ЛАТИНИЦА (Узбекский) ===
  final cyrToLat = {
    'ё': 'yo',
    'й': 'y',
    'ц': 'ts',
    'у': 'u',
    'к': 'k',
    'е': 'e',
    'н': 'n',
    'г': 'g',
    'ш': 'sh',
    'щ': 'sh',
    'з': 'z',
    'х': 'x',
    'ъ': '',
    'ф': 'f',
    'ы': 'i',
    'в': 'v',
    'а': 'a',
    'п': 'p',
    'р': 'r',
    'о': 'o',
    'л': 'l',
    'д': 'd',
    'ж': 'j',
    'э': 'e',
    'я': 'ya',
    'ч': 'ch',
    'с': 's',
    'м': 'm',
    'и': 'i',
    'т': 't',
    'ь': '',
    'б': 'b',
    'ю': 'yu',
    'ғ': 'g\'',
    'қ': 'q',
    'ў': 'o\'',
    'ҳ': 'h',
    'ң': 'ng',
  };

  for (var entry in cyrToLat.entries) {
    text = text.replaceAll(entry.key, entry.value);
  }

  // === 2. Дополнительная обработка часто используемых комбинаций ===
  text = text
      .replaceAll('o‘', 'o\'')   // разные типы апострофа
      .replaceAll('o`', 'o\'')
      .replaceAll('g‘', 'g\'')
      .replaceAll('g`', 'g\'')
      .replaceAll('sh', 'sh')
      .replaceAll('ch', 'ch')
      .replaceAll('ng', 'ng')
      .replaceAll('yo', 'yo');

  // === 3. Оставляем только буквы, цифры, апостроф и пробелы ===
  text = text.replaceAll(RegExp(r"[^a-z0-9\s']"), '');

  // === 4. Убираем лишние пробелы ===
  text = text.replaceAll(RegExp(r'\s+'), ' ').trim();

  return text;
}

double _similarity(String a, String b) {
  if (a.isEmpty && b.isEmpty) return 1.0;
  if (a.isEmpty || b.isEmpty) return 0.0;

  // Для очень коротких ответов (1-3 символа) — повышаем строгость
  if (a.length <= 3 || b.length <= 3) {
    return a == b ? 1.0 : 0.0;
  }

  final d = _levenshtein(a, b);
  final maxLen = max(a.length, b.length);
  return 1.0 - (d / maxLen);
}

int _levenshtein(String s, String t) {
  final m = s.length;
  final n = t.length;
  if (m == 0) return n;
  if (n == 0) return m;

  final prev = List<int>.generate(n + 1, (j) => j);
  final curr = List<int>.filled(n + 1, 0);

  for (var i = 1; i <= m; i++) {
    curr[0] = i;
    final si = s.codeUnitAt(i - 1);
    for (var j = 1; j <= n; j++) {
      final cost = si == t.codeUnitAt(j - 1) ? 0 : 1;
      curr[j] = min(
        min(curr[j - 1] + 1, prev[j] + 1),
        prev[j - 1] + cost,
      );
    }
    for (var j = 0; j <= n; j++) {
      prev[j] = curr[j];
    }
  }
  return prev[n];
}

_RoomStats _buildStats(List<QueryDocumentSnapshot<Map<String, dynamic>>> docs) {
  var gradeSum = 0.0;
  var correctSum = 0;
  var totalSum = 0;

  for (final doc in docs) {
    final data = doc.data();
    gradeSum += (data['grade'] as num?)?.toDouble() ?? 0;
    correctSum += (data['correctCount'] as num?)?.toInt() ?? 0;
    totalSum += (data['totalQuestions'] as num?)?.toInt() ?? 0;
  }

  return _RoomStats(
    submissionCount: docs.length,
    averageGrade: docs.isEmpty ? 0 : gradeSum / docs.length,
    accuracyPercent: totalSum == 0 ? 0 : (correctSum / totalSum) * 100,
  );
}

class _RoomStats {
  const _RoomStats({
    required this.submissionCount,
    required this.averageGrade,
    required this.accuracyPercent,
  });

  final int submissionCount;
  final double averageGrade;
  final double accuracyPercent;
}

PageRouteBuilder<T> _modernRoute<T>(Widget page, {bool replace = false}) {
  return PageRouteBuilder<T>(
    pageBuilder: (context, animation, secondaryAnimation) => page as dynamic,
    transitionDuration: const Duration(milliseconds: 280),
    reverseTransitionDuration: const Duration(milliseconds: 220),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
      return FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: replace ? Offset.zero : const Offset(0.03, 0),
            end: Offset.zero,
          ).animate(curved),
          child: child,
        ),
      );
    },
  );
}

_RoomInsights _buildInsights(
  List<QueryDocumentSnapshot<Map<String, dynamic>>> submissions,
  List<QueryDocumentSnapshot<Map<String, dynamic>>> questions,
) {
  final byStudent = <String, _StudentAgg>{};
  final byQuestion = <String, _QuestionAgg>{};

  for (final doc in submissions) {
    final data = doc.data();
    final studentName = (data['studentName'] ?? 'Ученик').toString();
    final grade = (data['grade'] as num?)?.toDouble() ?? 0;
    final perQ = (data['perQuestionCorrect'] as Map?)?.cast<String, dynamic>() ?? {};

    final agg = byStudent.putIfAbsent(studentName, () => _StudentAgg(studentName));
    agg.gradeSum += grade;
    agg.count += 1;

    for (final entry in perQ.entries) {
      final qid = entry.key;
      final correct = entry.value == true;
      final qAgg = byQuestion.putIfAbsent(qid, () => _QuestionAgg(qid));
      qAgg.total += 1;
      if (correct) qAgg.correct += 1;
    }
  }

  final topStudents = byStudent.values.toList()
    ..sort((a, b) => b.avgGrade.compareTo(a.avgGrade));

  final hardest = byQuestion.values.toList()
    ..sort((a, b) => a.correctPercent.compareTo(b.correctPercent));

  return _RoomInsights(
    topStudents: topStudents.take(3).map((s) => _StudentScore(s.name, s.avgGrade)).toList(),
    hardestQuestions: hardest
        .where((q) => q.total >= 1)
        .take(4)
        .map((q) {
          final qDoc = questions.where((doc) => doc.id == q.questionId).firstOrNull;
          final index = int.tryParse(q.questionId.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
          return _QuestionDifficulty(
            questionId: q.questionId,
            questionIndex: index,
            questionText: qDoc?['text']?.toString() ?? '',
            correctPercent: q.correctPercent,
          );
        }).toList(),
  );
}

class _RoomInsights {
  const _RoomInsights({
    required this.topStudents,
    required this.hardestQuestions,
  });

  final List<_StudentScore> topStudents;
  final List<_QuestionDifficulty> hardestQuestions;
}

class _StudentScore {
  const _StudentScore(this.name, this.avgGrade);
  final String name;
  final double avgGrade;
}

class _StudentAgg {
  _StudentAgg(this.name);
  final String name;
  double gradeSum = 0;
  int count = 0;
  double get avgGrade => count == 0 ? 0 : gradeSum / count;
}

class _QuestionAgg {
  _QuestionAgg(this.questionId);
  final String questionId;
  int correct = 0;
  int total = 0;
  double get correctPercent => total == 0 ? 0 : (correct / total) * 100;
}
