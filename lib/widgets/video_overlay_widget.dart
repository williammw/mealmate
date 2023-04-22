import 'dart:async';

import 'package:flutter/material.dart';

class VideoOverlayWidget extends StatefulWidget {
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
  State<VideoOverlayWidget> createState() => _VideoOverlayWidgetState();
}

class _VideoOverlayWidgetState extends State<VideoOverlayWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (widget.isPlaying)
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                '${widget.position.inMinutes}:${(widget.position.inSeconds % 60).toString().padLeft(2, '0')} / ${widget.duration.inMinutes}:${(widget.duration.inSeconds % 60).toString().padLeft(2, '0')}',
                style: const TextStyle(color: Colors.white, fontSize: 14.0),
              ),
            ),
          ),
        if (widget.isMuted)
          Align(
            alignment: Alignment.center,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  // Handle the onTap event here
                  print('Icon tapped');
                },
                child: const Icon(Icons.volume_off, color: Colors.white, size: 48.0),
              ),
            ),
          ),
        if (!widget.isMuted)
          Align(
            alignment: Alignment.center,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  // Handle the onTap event here
                  print('Icon tapped');
                },
                child: const Icon(Icons.volume_up, color: Colors.white, size: 48.0),
              ),
            ),
          )
      ],
    );
  }
}
