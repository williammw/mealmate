class FeedItemModel {
  final String userAvatarUrl;
  final String username;
  final List<String> postImageUrls;
  final List<String> postVideoUrls;
  final String description;
  final int likes;
  final int comments;
  final bool isBookmarked;
  final bool showVideoFirst;

  FeedItemModel({
    required this.userAvatarUrl,
    required this.username,
    required this.postImageUrls,
    required this.postVideoUrls,
    required this.description,
    required this.likes,
    required this.comments,
    required this.isBookmarked,
    required this.showVideoFirst,
  });

  static List<FeedItemModel> generateFakeData() {
    List<FeedItemModel> feedItems = [];
    List<String> videoUrls = [
      'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
      'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
      'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
      'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
      'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4',
      'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4',
      'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4',
      'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4',
      'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/SubaruOutbackOnStreetAndDirt.mp4',
      'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4',
      'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/VolkswagenGTIReview.mp4',
      'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WeAreGoingOnBullrun.mp4',
      'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WhatCarCanYouGetForAGrand.mp4',
    ];

    for (int i = 0; i < 10; i++) {
      feedItems.add(FeedItemModel(
        userAvatarUrl: 'https://i.pravatar.cc/150?img=${i + 1}',
        username: 'Username ${i + 1}',
        postImageUrls: ['https://picsum.photos/id/${i + 10}/400/600'],
        postVideoUrls: i % 3 == 0 ? [videoUrls[i % videoUrls.length]] : [],
        description: 'Post description for post ${i + 1}',
        likes: (i + 1) * 23,
        comments: (i + 1) * 12,
        isBookmarked: i % 2 == 0,
        showVideoFirst: i % 3 == 0,
      ));
    }

    return feedItems;
  }
}
