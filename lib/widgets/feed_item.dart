import 'package:flutter/material.dart';
import 'package:mealmate/models/feed_item_model.dart';
import 'package:mealmate/widgets/video_player_widget.dart';
import 'package:video_player/video_player.dart';

class FeedItem extends StatelessWidget {
  final FeedItemModel feedItem;

  const FeedItem({Key? key, required this.feedItem}) : super(key: key);

  Widget _buildMediaContent() {
    if (feedItem.postVideoUrl.isNotEmpty && feedItem.showVideoFirst) {
      return VideoPlayerWidget(url: feedItem.postVideoUrl);
    } else if (feedItem.postImageUrl.isNotEmpty) {
      return Container(
        height: 500,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(feedItem.postImageUrl),
          ),
        ),
      );
    } else if (feedItem.postVideoUrl.isNotEmpty) {
      return VideoPlayerWidget(url: feedItem.postVideoUrl);
    } else {
      return const SizedBox.shrink(); // Return an empty widget if no media is available.
    }
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
          _buildMediaContent(),
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
