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
import 'package:sqflite/sqflite.dart';
import 'package:permission_handler/permission_handler.dart';

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
  var microphonePermisison = await Permission.microphone.status;
  if (!microphonePermisison.isGranted) {
    Permission.microphone.request();
  }
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
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AppController appController = Get.put(AppController());

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
          InkWell(
            onTap: () => Get.to(() => AllSessions()),
            child: const Icon(Icons.history_rounded),
          ).marginOnly(right: 24)
        ],
      ),
      body: const ListeningPage(key: ValueKey('Listening Page')),
    );
  }
}
