import 'package:elastic_dashboard/widgets/draggable_containers/models/layout_container_model.dart';
import 'package:elastic_dashboard/widgets/draggable_containers/models/widget_container_model.dart';
import 'package:flutter/material.dart';

import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VideoWidget extends StatefulWidget {
  final SharedPreferences preferences;

  final void Function(Offset globalPosition, WidgetContainerModel widget)
  onNTDragUpdate;
  final void Function(WidgetContainerModel widget) onNTDragEnd;

  final void Function(Offset globalPosition, LayoutContainerModel widget)
  onLayoutDragUpdate;
  final void Function(LayoutContainerModel widget) onLayoutDragEnd;

  final void Function() onClose;

  const VideoWidget({
    super.key,
    required this.preferences,
    required this.onNTDragUpdate,
    required this.onNTDragEnd,
    required this.onLayoutDragUpdate,
    required this.onLayoutDragEnd,
    required this.onClose,
  });

  @override
  State<VideoWidget> createState() => VideoWidgetState();
}

class VideoWidgetState extends State<VideoWidget> {
  late final Player player;
  late final VideoController controller;

  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    player = Player();
    controller = VideoController(player);

    player.open(
      Media(
        '"C:\\Users\\Robotics\\Downloads\\subwaysurfers.mp4"',
      ),
    );

    player.stream.playing.listen((playingStatus) {
      setState(() {
        isPlaying = playingStatus;
      });
    });
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Video'),
    ),
    body: Column(
      children: [
        SizedBox(
          height: 600,
          width: double.infinity,
          child: Video(controller: controller),
        ),
        const SizedBox(height: 20),
        Center(
          child: ElevatedButton(
            onPressed: () {
              if (isPlaying) {
                player.pause();
              } else {
                player.play();
              }
            },
            child: Icon(
              isPlaying ? Icons.pause : Icons.play_arrow,
            ),
          ),
        ),
        Text(isPlaying ? 'Playing' : 'Paused'),
      ],
    ),
  );
}
