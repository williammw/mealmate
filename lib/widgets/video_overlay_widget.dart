import 'package:flutter/material.dart';

class VideoOverlayWidget extends StatelessWidget {
  final Duration position;
  final Duration duration;
  final bool isMuted;
  final bool isPlaying;

  const VideoOverlayWidget({
    Key? key,
    required this.position,
    required this.duration,
    required this.isMuted,
    required this.isPlaying,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (isPlaying)
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                '${position.inMinutes}:${(position.inSeconds % 60).toString().padLeft(2, '0')} / ${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}',
                style: TextStyle(color: Colors.white, fontSize: 14.0),
              ),
            ),
          ),
        if (isMuted)
          Align(
            alignment: Alignment.center,
            child: Icon(Icons.volume_off, color: Colors.white, size: 48.0),
          ),
      ],
    );
  }
}
