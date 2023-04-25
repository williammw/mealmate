import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:mealmate/widgets/video_overlay_widget.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String url;

  const VideoPlayerWidget({Key? key, required this.url}) : super(key: key);

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _videoPlayerController;
  final _position = ValueNotifier<Duration>(Duration.zero);
  Duration? _duration;
  final _isPlaying = ValueNotifier<bool>(false);
  final GlobalKey<VideoOverlayWidgetState> videoOverlayKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        _duration = _videoPlayerController.value.duration;
        _videoPlayerController.setLooping(true);
        _videoPlayerController.play();
        _videoPlayerController.setVolume(0.0);

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
    videoOverlayKey.currentState?.showIconWithFadeOut();
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
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: ValueListenableBuilder<Duration>(
              valueListenable: _position,
              builder: (context, position, child) {
                return Slider(
                  activeColor: Colors.white,
                  inactiveColor: Colors.white.withOpacity(0.5),
                  value: position.inMilliseconds.clamp(0, _duration!.inMilliseconds).toDouble(),
                  min: 0.0,
                  max: _duration!.inMilliseconds.toDouble(),
                  onChanged: (double value) {
                    _videoPlayerController.seekTo(Duration(milliseconds: value.toInt()));
                  },
                );
              },
            ),
          ),
          ValueListenableBuilder<Duration>(
            valueListenable: _position,
            builder: (context, position, child) {
              return VideoOverlayWidget(
                key: videoOverlayKey,
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
