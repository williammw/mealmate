import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:mealmate/widgets/video_overlay_widget.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String url;

  VideoPlayerWidget({Key? key, required this.url}) : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _videoPlayerController;
  final _position = ValueNotifier<Duration>(Duration.zero);
  Duration? _duration;
  final _isPlaying = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        _duration = _videoPlayerController.value.duration;
        _videoPlayerController.setLooping(true);
        _videoPlayerController.play();
        setState(() {});
      })
      ..addListener(() {
        if (!_videoPlayerController.value.isPlaying && mounted) {
          setState(() {});
        }
        _position.value = _videoPlayerController.value.position;
        _isPlaying.value = _videoPlayerController.value.isPlaying;
      });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  void _toggleSound() {
    if (_videoPlayerController.value.volume == 0) {
      _videoPlayerController.setVolume(1.0);
    } else {
      _videoPlayerController.setVolume(0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_duration == null) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: () {
        _toggleSound();
      },
      child: Stack(
        children: [
          SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _videoPlayerController.value.size.width,
                height: _videoPlayerController.value.size.height,
                child: VideoPlayer(_videoPlayerController),
              ),
            ),
          ),
          ValueListenableBuilder<Duration>(
            valueListenable: _position,
            builder: (context, position, child) {
              return VideoOverlayWidget(
                position: position,
                duration: _duration!,
                isMuted: _videoPlayerController.value.volume == 0,
                isPlaying: _isPlaying.value,
              );
            },
          ),
        ],
      ),
    );
  }
}
