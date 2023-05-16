
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/feed_item_model.dart';
import 'video_player_widget.dart';
import 'package:provider/provider.dart';

import '../providers/drag_state_notifer.dart';

class FeedItem extends StatefulWidget {
  final FeedItemModel feedItem;

  const FeedItem({Key? key, required this.feedItem}) : super(key: key);

  @override
  _FeedItemState createState() => _FeedItemState();
}

class _FeedItemState extends State<FeedItem> {
  int _currentPage = 0;

  Widget _buildMediaContent(BuildContext context) {
    const double desiredHeight = 500;
    const double aspectRatio = (16 / 9);

    List<Widget> mediaWidgets = [];

    if (widget.feedItem.showVideoFirst) {
      for (final videoUrl in widget.feedItem.postVideoUrls) {
        mediaWidgets.add(
          SizedBox(
            height: desiredHeight,
            child: AspectRatio(
              aspectRatio: aspectRatio,
              child: VideoPlayerWidget(url: videoUrl),
            ),
          ),
        );
      }
    }

    for (final imageUrl in widget.feedItem.postImageUrls) {
      mediaWidgets.add(
        Container(
          height: desiredHeight,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(imageUrl),
            ),
          ),
        ),
      );
    }

    if (!widget.feedItem.showVideoFirst) {
      for (final videoUrl in widget.feedItem.postVideoUrls) {
        mediaWidgets.add(
          SizedBox(
            height: desiredHeight,
            child: AspectRatio(
              aspectRatio: aspectRatio,
              child: VideoPlayerWidget(url: videoUrl),
            ),
          ),
        );
      }
    }

    return SizedBox(
      height: desiredHeight,
      child: Stack(
        children: [
          PageView(
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            children: mediaWidgets,
          ),
          Positioned(
            bottom: 8,
            left: 18,
            child: Text(
              '${_currentPage + 1}/${mediaWidgets.length}',
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          Positioned(
            top: 10,
            left: 10,
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.feedItem.userAvatarUrl),
                ),
                const SizedBox(width: 8),
                Text(
                  widget.feedItem.username,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 52,
            left: 10,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Text(
                widget.feedItem.description,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
          Positioned(
            bottom: 30,
            left: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    color: Colors.white,
                    onPressed: () {},
                    icon: const FaIcon(
                      FontAwesomeIcons.thumbsUp,
                      size: 26,
                    ),
                  ),
                  IconButton(
                    color: Colors.white,
                    onPressed: () {},
                    icon: const FaIcon(
                      FontAwesomeIcons.comment,
                      size: 26,
                    ),
                  ),
                  IconButton(
                    color: Colors.white,
                    onPressed: () {},
                    icon: const FaIcon(
                      FontAwesomeIcons.share,
                      size: 26,
                    ),
                  ),
                  IconButton(
                    color: Colors.white,
                    onPressed: () {},
                    icon: const FaIcon(
                      FontAwesomeIcons.bookmark,
                      size: 26,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LongPressDraggable(
      data: 'YourData',
      onDragStarted: () {
        Provider.of<DragState>(context, listen: false).startDragging();
      },
      onDragEnd: (details) {
        Provider.of<DragState>(context, listen: false).endDragging();
      },
      feedback: Transform.scale(
        scale: 0.8,
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          width: MediaQuery.of(context).size.width,
          child: Material(
            color: Colors.transparent,
            child: Opacity(
              opacity: 0.7,
              child: _feedItemWidget(ignorePointer: true),
            ),
          ),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.5,
        child: _feedItemWidget(),
      ),
      child: _feedItemWidget(),
    );
  }

  Widget _feedItemWidget({bool ignorePointer = false}) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(left: 0, top: 8.0, right: 0, bottom: 50.0),
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.7, // Adjust this height as needed
                      child: ignorePointer ? IgnorePointer(child: _buildMediaContent(context)) : _buildMediaContent(context),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        height: 6, // Height of the border
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Colors.blue, Colors.yellow] // Provide your desired colors here
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
