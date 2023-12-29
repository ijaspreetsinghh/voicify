import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voicify/controller/controller.dart';
import 'package:voicify/main.dart';
import 'package:voicify/models/session.dart';
import 'package:voicify/services/services/database_service.dart';
import 'package:voicify/view/styles/colors/app_colors.dart';
import 'package:voicify/view/styles/typorgraphy/typography.dart';

class EditingSession extends StatefulWidget {
  const EditingSession({super.key, required this.session});
  final Session session;

  @override
  State<EditingSession> createState() => _EditingSessionState();
}

class _EditingSessionState extends State<EditingSession> {
  final TextEditingController titleController = TextEditingController();
  RxString title = ''.obs;
  RxString body = ''.obs;
  final TextEditingController bodyController = TextEditingController();
  final AppController appController = Get.put(AppController());
  @override
  void initState() {
    title.value = titleController.text = widget.session.title;
    body.value = bodyController.text = widget.session.body;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        leading: Row(
          children: [
            InkWell(
              onTap: () => Get.back(),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppColors.blackText,
              ),
            ).paddingOnly(left: 24),
          ],
        ),
        centerTitle: true,
        title: const MyText(
          'Session Details',
          color: AppColors.blackText,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        actions: [
          Obx(() => InkWell(
                onTap: widget.session.body.trim() == body.value &&
                        widget.session.title.trim() == title.value
                    ? null
                    : () async {
                        final dateTime = DateTime.now();
                        deleteSessionRecord(id: widget.session.id);
                        appController.allSessions.removeWhere(
                            (element) => element.id == widget.session.id);
                        await database.transaction((txn) async {
                          int id = await txn.rawInsert(
                              'INSERT INTO Sessions(title, body, created_on) VALUES("$title", "$body","${dateTime.millisecondsSinceEpoch}"  )');

                          appController.allSessions.add(Session(
                              id: id,
                              title: titleController.text,
                              body: bodyController.text,
                              createdOn: dateTime));
                        });
                        Get.back();
                      },
                child: Icon(
                  Icons.done_rounded,
                  color: widget.session.body.trim() == body.value &&
                          widget.session.title.trim() == title.value
                      ? AppColors.lightGrey
                      : AppColors.primary,
                ),
              )).paddingOnly(right: 24),
        ],
      ),
      backgroundColor: AppColors.white,
      body: SafeArea(
          child: ListView(
        children: [
          TextFormField(
            controller: titleController,
            textCapitalization: TextCapitalization.sentences,
            style: GoogleFonts.urbanist(
              color: AppColors.blackText,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
            maxLines: 1500,
            minLines: 1,
            onChanged: (value) => title.value = value,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                isDense: true,
                hintText: 'Title',
                hintStyle: GoogleFonts.urbanist(
                  color: AppColors.grey,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
                border: const OutlineInputBorder(borderSide: BorderSide.none)),
          ),
          const SizedBox(
            height: 8,
          ),
          TextFormField(
            textCapitalization: TextCapitalization.sentences,
            style: GoogleFonts.urbanist(
              color: AppColors.bgGreyDark,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            minLines: 2,
            onChanged: (value) => body.value = value,
            maxLines: 1500,
            controller: bodyController,
            decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                isDense: true,
                hintText: 'Note',
                hintStyle: GoogleFonts.urbanist(
                  color: AppColors.grey,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                border: const OutlineInputBorder(borderSide: BorderSide.none)),
          ),
          MyText(
            'Timestamp: ${widget.session.createdOn}',
            fontSize: 12,
            color: AppColors.grey,
          ).marginAll(16),
        ],
      )),
    );
  }
}
