import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:voicify/controller/controller.dart';
import 'package:voicify/main.dart';
import 'package:voicify/models/session.dart';
import 'package:voicify/view/styles/colors/app_colors.dart';
import 'package:voicify/view/styles/typorgraphy/typography.dart';
import 'package:permission_handler/permission_handler.dart';

class ListeningPage extends StatefulWidget {
  const ListeningPage({super.key});

  @override
  State<ListeningPage> createState() => _ListeningPageState();
}

class _ListeningPageState extends State<ListeningPage>
    with AutomaticKeepAliveClientMixin {
  final SpeechToText _speechToText = SpeechToText();
  // bool _speechEnabled = false;
  final RxString _lastWords = ''.obs;
  final RxBool _isListening = false.obs;
  final RxDouble _confidence = 1.0.obs;
  final AppController appController = Get.put(AppController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Obx(() => AvatarGlow(
            animate: _isListening.value,
            glowColor: AppColors.primary,
            repeat: true,
            duration: const Duration(milliseconds: 2000),
            child: SizedBox(
              height: 64,
              width: 64,
              child: FloatingActionButton(
                shape: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100),
                  borderSide: BorderSide.none,
                ),
                backgroundColor: AppColors.primary,
                onPressed: _listen,
                tooltip: 'Listen',
                child: Icon(
                  _isListening.value ? Icons.mic : Icons.mic_off,
                  color: AppColors.white,
                  size: 28,
                ),
              ),
            ),
          )),
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Obx(
          () => _lastWords.isEmpty
              ? Container(
                  height: Get.height * .7,
                  padding: const EdgeInsets.all(24),
                  alignment: AlignmentDirectional.center,
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      MyText(
                        'Tap mic🎤 to start record session.',
                        fontSize: 24,
                        color: AppColors.bgGreyDark,
                        fontWeight: FontWeight.w600,
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                )
              : ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(24),
                  children: [
                    _speechToText.isListening
                        ? const MyText(
                            'Listening...',
                            fontSize: 16,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                            textAlign: TextAlign.center,
                          )
                        : const SizedBox(),
                    const SizedBox(
                      height: 8,
                    ),
                    Obx(() => MyText(
                          _lastWords.value,
                          fontSize: 20,
                          color: AppColors.bgGreyDark,
                          fontWeight: FontWeight.w600,
                        )),
                    const SizedBox(
                      height: 16,
                    ),
                    _speechToText.isNotListening && _confidence.value > 0
                        ? Column(
                            children: [
                              MyText(
                                'Confidence: ${(_confidence.value * 100).toStringAsFixed(2)}%',
                                fontSize: 16,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              const MyText(
                                'Speech Saved 👌',
                                fontSize: 20,
                                color: AppColors.grCenterDark,
                                fontWeight: FontWeight.w700,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(
                                height: 100,
                              )
                            ],
                          )
                        : const SizedBox(),
                  ],
                ),
        ),
      ),
    );
  }

  void _listen() async {
    var microphonePermisison = await Permission.microphone.status;

    if (microphonePermisison.isGranted) {
      if (!_isListening.value) {
        bool available = await _speechToText.initialize(
          onStatus: (status) async {
            if (status == 'listening') {
              _isListening.value = true;
            }
            if (status == 'notListening') {
              _isListening.value = false;
            }
            if (status == 'done') {
              _isListening.value = false;

              String randomTitle;
              if (_lastWords.value.trim().length > 5) {
                randomTitle =
                    _lastWords.value.split(' ').take(5).toList().join(' ');
              } else {
                randomTitle = _lastWords.value;
              }
              final ts = DateTime.now().millisecondsSinceEpoch;
              await database.transaction((txn) async {
                int id = await txn.rawInsert(
                    'INSERT INTO Sessions(title, body, created_on) VALUES("$randomTitle", "${_lastWords.value}","${ts}"  )');

                appController.allSessions.add(Session(
                    id: id,
                    title: randomTitle,
                    body: _lastWords.value,
                    createdOn: DateTime.fromMillisecondsSinceEpoch(ts)));
              });
            }
          },
          onError: (error) => Get.snackbar(
            'Error',
            error.errorMsg,
            titleText: const MyText(
              'Error',
              color: Colors.red,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
            duration: const Duration(seconds: 2),
            messageText: MyText(
              error.errorMsg,
              color: AppColors.blackText,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        );

        if (available) {
          _isListening.value = true;

          _speechToText.listen(
            onResult: (result) {
              _lastWords.value = result.recognizedWords;

              _confidence.value = result.confidence;
            },
            listenMode: ListenMode.dictation,
          );
        }
      } else {
        _isListening.value = false;

        _speechToText.stop();
      }
    } else {
      Get.snackbar(
        'Need Microphone Permission',
        'error.errorMsg',
        titleText: const MyText(
          'Error',
          color: Colors.red,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
        duration: const Duration(seconds: 5),
        messageText: const MyText(
          'Microphone permission not allowed.',
          color: AppColors.blackText,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      );
      await Permission.microphone.request();
    }
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
