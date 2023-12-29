import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:voicify/models/session.dart';
import 'package:voicify/view/styles/theme/dark_theme.dart';
import 'package:voicify/view/styles/theme/light_theme.dart';

class AppController extends GetxController {
  RxBool get isDarkMode => false.obs;
  RxList<Session> allSessions = <Session>[].obs;
  final _icon = '🌙'.obs; // Moon emoji for dark mode
  String get icon => _icon.value;

  @override
  void onInit() {
    super.onInit();
    _loadTheme();
  }

  void toggleTheme() {
    isDarkMode.toggle();
    _icon.value = isDarkMode.value ? '☀️' : '🌙'; // Sun emoji for light mode
    _saveTheme();
    Get.changeTheme(Get.isDarkMode ? darkTheme : lightTheme);
  }

  void _loadTheme() {
    final box = GetStorage();
    isDarkMode.value = box.read('isDarkMode') ?? false;
  }

  void _saveTheme() {
    final box = GetStorage();
    box.write('isDarkMode', isDarkMode.value);
  }
}
