import 'package:flutter/material.dart';
import '../models/feed_item_model.dart';
import '../widgets/feed_item.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: FeedItemModel.generateFakeData().length,
      itemBuilder: (BuildContext context, int index) {
        return FeedItem(feedItem: FeedItemModel.generateFakeData()[index]);
      },
    );
  }
}
