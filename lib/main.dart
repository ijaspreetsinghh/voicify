import 'dart:convert';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_storage/get_storage.dart';
import 'package:voicify/controller/controller.dart';
import 'package:voicify/models/session.dart';
import 'package:voicify/services/services/database_service.dart';
import 'package:voicify/view/pages/all_sessions.dart';
import 'package:voicify/view/pages/listening_page.dart';
import 'package:voicify/view/styles/colors/app_colors.dart';
import 'package:voicify/view/styles/theme/dark_theme.dart';
import 'package:voicify/view/styles/theme/light_theme.dart';
import 'package:sqflite/sqflite.dart';

import 'view/styles/typorgraphy/typography.dart';

late Database database;
void main() async {
  await GetStorage.init();
  final AppController appController = Get.put(AppController());
  await initializeDatabase();
  List<Map> sessions = await database.rawQuery('SELECT * FROM Sessions');

  final newSesisons = sessionFromMap(jsonEncode(sessions));
  appController.allSessions = newSesisons.obs;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final AppController appController = Get.put(AppController());
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Voicify',
      initialBinding: MyBinding(),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      // theme: lightTheme,
      // darkTheme: darkTheme,
      // themeMode: ThemeMode.dark,
    );
  }
}

class MyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AppController>(() => AppController());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    this.initialId,
  });
  final int? initialId;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AppController appController = Get.put(AppController());
  @override
  void initState() {
    if (widget.initialId != null &&
        (widget.initialId == 0 || widget.initialId == 1)) {
      appController.currentIndex.value = widget.initialId!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          leadingWidth: 100,
          leading: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 40,
                  width: 40,
                  child: SvgPicture.asset('assets/images/logo_sec.svg'),
                ),
              ]).paddingOnly(left: 24),
          centerTitle: true,
          title: const MyText(
            'Voicify',
            color: AppColors.blackText,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
          actions: [
            // SizedBox(
            //   width: 124,
            //   child: Obx(() => Switch(
            //         value: appController.isDarkMode.value,
            //         onChanged: (value) => appController.toggleTheme(),
            //       )),
            // )
          ],
        ),
        body: Obx(() => appController.currentIndex.value == 0
            ? const ListeningPage()
            : AllSessions()),
        bottomNavigationBar: Obx(() => BottomNavigationBar(
              backgroundColor: AppColors.white,
              // elevation: 0,
              type: BottomNavigationBarType.fixed,
              onTap: (index) {
                // Update the selected index using the provider
                appController.currentIndex.value = index;
              },
              currentIndex: appController.currentIndex.value, iconSize: 24,
              selectedFontSize: 14, unselectedFontSize: 14,
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.mic_none,
                    ),
                    activeIcon: Icon(Icons.mic),
                    label: 'Record'),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.history_rounded,
                    ),
                    activeIcon: Icon(
                      Icons.history_rounded,
                    ),
                    label: 'Sessions'),
              ],
            )));
  }
}
