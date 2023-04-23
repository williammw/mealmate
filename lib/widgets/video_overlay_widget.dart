import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

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
  State<VideoOverlayWidget> createState() => VideoOverlayWidgetState();
}

class VideoOverlayWidgetState extends State<VideoOverlayWidget> {
  bool _showIcon = true;

  @override
  void initState() {
    super.initState();
    showIconWithFadeOut();
  }

  void showIconWithFadeOut() {
    setState(() {
      _showIcon = true;
    });

    Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _showIcon = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (widget.isPlaying)
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Text(
                '${widget.position.inMinutes}:${(widget.position.inSeconds % 60).toString().padLeft(2, '0')} / ${widget.duration.inMinutes}:${(widget.duration.inSeconds % 60).toString().padLeft(2, '0')}',
                style: const TextStyle(color: Colors.white, fontSize: 14.0),
              ),
            ),
          ),
        AnimatedOpacity(
          opacity: _showIcon ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 500),
          child: Align(
            alignment: Alignment.center,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  // Do nothing on tap, since it's handled by VideoPlayerWidget
                },
                child: Icon(
                  widget.isMuted ? Icons.volume_off : Icons.volume_up,
                  color: Colors.white,
                  size: 48.0,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
