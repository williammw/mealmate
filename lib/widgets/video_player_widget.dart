import 'package:flutter/material.dart';
import 'dart:math';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String url;

  const VideoPlayerWidget({Key? key, required this.url}) : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  bool _isMuted = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.url);
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);
    _controller.play();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
      _controller.setVolume(_isMuted ? 0.0 : 1.0);
    });
  }

  void _onLongPressMoveUpdate(LongPressMoveUpdateDetails details) {
    // Change this value to adjust the sensitivity of the horizontal drag
    double sensitivity = 100;

    // Calculate the seek position based on the horizontal drag distance
    int seekMilliseconds = _controller.value.position.inMilliseconds + (details.localOffsetFromOrigin.dx * sensitivity).toInt();

    // Clamp the seek position to the video's duration
    seekMilliseconds = max(0, min(seekMilliseconds, _controller.value.duration.inMilliseconds));

    // Seek the video to the new position
    _controller.seekTo(Duration(milliseconds: seekMilliseconds));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return GestureDetector(
            // this  may be a paid feature, as people need pay to watch the video
            onLongPressMoveUpdate: _onLongPressMoveUpdate,
            onTap: _toggleMute,
            onLongPressStart: (_) => _controller.pause(),
            onLongPressEnd: (_) => _controller.play(),
            child: SizedBox(
              height: 500,
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
            ),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
