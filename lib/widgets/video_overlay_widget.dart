import 'package:flutter/material.dart';

class VideoOverlayWidget extends StatefulWidget {
  final bool isMuted;
  final Duration position;
  final Duration duration;

  const VideoOverlayWidget({
    Key? key,
    required this.isMuted,
    required this.position,
    required this.duration,
  }) : super(key: key);

  @override
  State<VideoOverlayWidget> createState() => _VideoOverlayWidgetState();
}

class _VideoOverlayWidgetState extends State<VideoOverlayWidget> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: 10,
          bottom: 10,
          child: Icon(
            widget.isMuted ? Icons.volume_off : Icons.volume_up,
            color: Colors.white,
          ),
        ),
        Positioned(
          right: 10,
          bottom: 10,
          child: Text(
            '${widget.position.inSeconds} / ${widget.duration.inSeconds} s',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
