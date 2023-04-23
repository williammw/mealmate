import 'package:flutter/material.dart';
import 'package:mealmate/models/feed_item_model.dart';
import 'package:mealmate/widgets/video_player_widget.dart';

class FeedItem extends StatelessWidget {
  final FeedItemModel feedItem;

  const FeedItem({Key? key, required this.feedItem}) : super(key: key);

  Widget _buildMediaContent(BuildContext context) {
    const double desiredHeight = 500;
    const double aspectRatio = (16 / 9);

    List<Widget> mediaWidgets = [];

    if (feedItem.showVideoFirst) {
      for (final videoUrl in feedItem.postVideoUrls) {
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

    for (final imageUrl in feedItem.postImageUrls) {
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

    if (!feedItem.showVideoFirst) {
      for (final videoUrl in feedItem.postVideoUrls) {
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
      child: PageView(
        children: mediaWidgets,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(feedItem.userAvatarUrl),
            ),
            title: Text(feedItem.username),
          ),
          _buildMediaContent(context),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(feedItem.description),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.favorite_border),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.comment),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.share),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.bookmark_border),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
