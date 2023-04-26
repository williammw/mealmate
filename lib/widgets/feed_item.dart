import 'package:flutter/material.dart';
import 'package:mealmate/models/feed_item_model.dart';
import 'package:mealmate/widgets/video_player_widget.dart';

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
              style: TextStyle(color: Colors.white, fontSize: 16),
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
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    color: Colors.white,
                    onPressed: () {},
                    icon: const Icon(
                      Icons.favorite_border,
                      size: 32,
                    ),
                  ),
                  IconButton(
                    color: Colors.white,
                    onPressed: () {},
                    icon: const Icon(
                      Icons.comment,
                      size: 32,
                    ),
                  ),
                  IconButton(
                    color: Colors.white,
                    onPressed: () {},
                    icon: const Icon(
                      Icons.share,
                      size: 32,
                    ),
                  ),
                  // IconButton(
                  //   color: Colors.white,
                  //   onPressed: () {},
                  //   icon: const Icon(
                  //     Icons.bookmark_border,
                  //     size: 32,
                  //   ),
                  // ),
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
    return Container(
      margin: const EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0, bottom: 14.0),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMediaContent(context),
        ],
      ),
    );
  }
}
