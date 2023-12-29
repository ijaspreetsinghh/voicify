import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:voicify/controller/controller.dart';
import 'package:voicify/models/session.dart';
import 'package:voicify/services/services/database_service.dart';
import 'package:voicify/view/pages/edit_session.dart';
import 'package:voicify/view/styles/colors/app_colors.dart';
import 'package:voicify/view/styles/typorgraphy/typography.dart';
import 'package:voicify/view/widgets/my_card.dart';

class AllSessions extends StatefulWidget {
  AllSessions({
    super.key,
  });

  @override
  State<AllSessions> createState() => _AllSessionsState();
}

class _AllSessionsState extends State<AllSessions>
    with AutomaticKeepAliveClientMixin {
  final AppController appController = Get.put(AppController());
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: AppColors.white,
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
          'Previous Sessions',
          color: AppColors.blackText,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: SafeArea(
        child: Obx(
          () {
            appController.allSessions
                .sort((a, b) => b.createdOn.compareTo(a.createdOn));
            return appController.allSessions.isEmpty
                ? Container(
                    margin: const EdgeInsets.symmetric(vertical: 24),
                    height: Get.height * .85,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          height: Get.height * .3,
                        ),
                        const Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              MyText(
                                'No Session',
                                fontSize: 24,
                                color: AppColors.bgGreyDark,
                                fontWeight: FontWeight.w600,
                                textAlign: TextAlign.center,
                              )
                            ]),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(24),
                    itemCount: appController.allSessions.length,
                    itemBuilder: (context, index) => MyCard(
                      bgColor: AppColors.white,
                      outlineColor: AppColors.lightGrey,
                      child: MySession(
                        session: appController.allSessions[index],
                        appController: appController,
                      ),
                    ).marginOnly(bottom: 16),
                  );
          },
        ),
      ),
    );
  }

  void deleteSession() {}
}

class MySession extends StatelessWidget {
  const MySession({
    super.key,
    required this.session,
    required this.appController,
  });
  final Session session;
  final AppController appController;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      // hoverColor: Colors.transparent,
      // splashColor: Colors.transparent,
      // focusColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () => Get.to(() => EditingSession(
            session: session,
          )),
      onLongPress: () {
        Get.bottomSheet(
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const MyText(
                  'Delete this session?',
                  fontSize: 22,
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.w700,
                  color: AppColors.blackText,
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () => Get.back(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppColors.secondaryL),
                        child: const MyText(
                          'Cancel',
                          fontSize: 16,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 56,
                    ),
                    InkWell(
                      onTap: () {
                        deleteSessionRecord(id: session.id);
                        appController.allSessions
                            .removeWhere((element) => element.id == session.id);
                        Get.back();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppColors.primary),
                        child: const MyText(
                          'Delete',
                          fontSize: 16,
                          color: AppColors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              MyText(
                session.title,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                maxLines: 2,
              ),
              MyText(
                session.body,
                maxLines: 8,
                fontSize: 14,
                color: AppColors.grey,
                fontWeight: FontWeight.w600,
              )
            ],
          )),
    );
  }
}
