import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'video_overlay_widget.dart';

class AlmostRectangularSliderTrackShape extends SliderTrackShape {
  final double height;

  AlmostRectangularSliderTrackShape({required this.height});

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    Offset? secondaryOffset,
    bool isDiscrete = false,
    bool isEnabled = false,
  }) {
    final Canvas canvas = context.canvas;
    final Paint activePaint = Paint()..color = sliderTheme.activeTrackColor!;
    final Paint inactivePaint = Paint()..color = sliderTheme.inactiveTrackColor!;
    final double trackWidth = parentBox.size.width;
    final double trackTop = offset.dy + (parentBox.size.height - height) / 2;

    final Rect activeRect = Rect.fromLTWH(
      offset.dx,
      trackTop,
      thumbCenter.dx - offset.dx,
      height,
    );

    final Rect inactiveRect = Rect.fromLTWH(
      thumbCenter.dx,
      trackTop,
      trackWidth - (thumbCenter.dx - offset.dx),
      height,
    );

    canvas.drawRRect(RRect.fromRectAndRadius(activeRect, const Radius.circular(0.5)), activePaint);
    canvas.drawRRect(RRect.fromRectAndRadius(inactiveRect, const Radius.circular(0.5)), inactivePaint);
  }

  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double thumbWidth = sliderTheme.thumbShape!.getPreferredSize(isEnabled, isDiscrete).width;
    final double trackLeft = offset.dx + thumbWidth / 2;
    final double trackTop = offset.dy + (parentBox.size.height - height) / 2;
    final double trackWidth = parentBox.size.width - thumbWidth;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, height);
  }
}

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
                return SliderTheme(
                  data: SliderThemeData(
                    trackHeight: 4.0,
                    trackShape: AlmostRectangularSliderTrackShape(height: 4.0),
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 0.0), // Set radius to 0.0 to hide thumb
                    overlayShape: const RoundSliderOverlayShape(overlayRadius: 0.0),
                  ),
                  child: Slider(
                    activeColor: Colors.white,
                    inactiveColor: Colors.white.withOpacity(0.5),
                    value: position.inMilliseconds.clamp(0, _duration!.inMilliseconds).toDouble(),
                    min: 0.0,
                    max: _duration!.inMilliseconds.toDouble(),
                    onChanged: (double value) {
                      _videoPlayerController.seekTo(Duration(milliseconds: value.toInt()));
                    },
                  ),
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
