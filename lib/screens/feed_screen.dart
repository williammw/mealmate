import 'package:flutter/material.dart';
import 'package:mealmate/models/feed_item_model.dart';
import 'package:mealmate/widgets/feed_item.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: FeedItemModel.generateFakeData().length,
        itemBuilder: (BuildContext context, int index) {
          return FeedItem(feedItem: FeedItemModel.generateFakeData()[index]);
        },
      ),
    );
  }
}
