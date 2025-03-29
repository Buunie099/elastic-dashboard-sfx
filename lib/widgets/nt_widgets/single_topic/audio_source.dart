
import 'dart:async';
import 'dart:io';

import 'package:elastic_dashboard/services/text_formatter_builder.dart';
import 'package:flutter/material.dart';

import 'package:path/path.dart' as path;

import 'package:dot_cast/dot_cast.dart';
import 'package:provider/provider.dart';

import 'package:audioplayers/audioplayers.dart';

import 'package:elastic_dashboard/widgets/dialog_widgets/dialog_text_input.dart';
import 'package:elastic_dashboard/widgets/nt_widgets/nt_widget.dart';

import 'package:elastic_dashboard/services/log.dart';

bool isInitialized = false;
double soundVolume = 1;
String filepath = "";

class AudioSourceModel extends SingleTopicNTWidgetModel {
  @override
  String type = AudioSource.widgetType;
  final AudioPlayer player = AudioPlayer();

  bool _shouldplay = false;
  String _soundPath = "";

  bool get shouldPlay => _shouldplay;
  String get soundPath => _soundPath;

  set shouldPlay(bool value) {
    _shouldplay = value;
    refresh();
  }

  set soundPath(String value) {
    _soundPath = value;
    refresh();
  }

  Future<void> playSound() async {
    String filePath = '${path.dirname(Platform.resolvedExecutable)}/data/flutter_assets/assets/soundeffects/$_soundPath';
    logger.info(filePath);
    await player.play(DeviceFileSource(filePath), volume: 1);
    logger.info('We be here Yo! PART #2, COOKING UP DIS CODE');
    await player.resume();
    logger.info('We be here Yo! PART #3, #LEARNTDARTIN6HOURS #FLUTTERIN6HOURS #NEWLANGUAGE');
  }

  AudioSourceModel({
    required super.ntConnection,
    required super.preferences,
    required super.topic,
    super.dataType,
    super.period,
  }) : super();

  AudioSourceModel.fromJson({
    required super.ntConnection,
    required super.preferences,
    required Map<String, dynamic> jsonData,
  }) : super.fromJson(jsonData: jsonData) {
    _soundPath = tryCast(jsonData['sound_path']) ?? "";

    if (!isInitialized) {
      player.setReleaseMode(ReleaseMode.stop);
      isInitialized = true;
    }
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'sound_path': _soundPath
    };
  }

  @override
  List<Widget> getEditProperties(BuildContext context) {
    return [
        DialogTextInput(
          onSubmit: (String path) {
            soundPath = path;
            playSound();
          },
          label: "File Name",
          initialText: soundPath,
        ),
        const SizedBox(width: 10),
        Flexible(
          child: DialogTextInput(
            onSubmit: (value) {
              double? newWidth = double.tryParse(value);

              if (newWidth == null) {
                return;
              }
              soundVolume = newWidth;
            },
            formatter: TextFormatterBuilder.decimalTextFormatter(),
            label: 'Volume (0-1)',
            initialText: soundVolume.toString(),
          ),
        ),
    ];
  }
}

class AudioSource extends NTWidget {
  static const String widgetType = 'Audio Source';

  const AudioSource({super.key});

  @override
  Widget build(BuildContext context) {
    AudioSourceModel model = cast(context.watch<NTWidgetModel>());

    return ValueListenableBuilder(
      valueListenable: model.subscription!,
      builder: (context, data, child) {
        bool value = tryCast(data) ?? false;
        if (value) {
          logger.info('We be here Yo! PART #4, COOKING UP DIS CODE AGAIN');
          model.playSound();
        }
        Widget defaultWidget() => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: (value) ? const Color(0xff505050) : const Color(0xff0000ff)
          ),
        );

      return defaultWidget();
      }
    );
  }
}