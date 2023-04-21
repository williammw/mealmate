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
  bool _showMuteIcon = true;

  @override
  void initState() {
    super.initState();

    // Set up a timer to hide the mute icon after 2 seconds
    Timer(const Duration(seconds: 2), () {
      setState(() {
        _showMuteIcon = false;
      });
    });
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
                style: TextStyle(color: Colors.white, fontSize: 14.0),
              ),
            ),
          ),
        if (widget.isMuted)
          const Align(
            alignment: Alignment.center,
            child: Icon(Icons.volume_off, color: Colors.white, size: 48.0),
          ),
        if (!widget.isMuted)
          const Align(
            alignment: Alignment.center,
            child: Icon(Icons.volume_up, color: Colors.white, size: 48.0),
          ),
      ],
    );
  }
}
