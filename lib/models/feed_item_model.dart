class FeedItemModel {
  final String userAvatarUrl;
  final String username;
  final String postImageUrl;
  final String postVideoUrl;
  final String description;
  final int likes;
  final int comments;
  final bool isBookmarked;
  final bool showVideoFirst;

  FeedItemModel({
    required this.userAvatarUrl,
    required this.username,
    required this.postImageUrl,
    required this.postVideoUrl,
    required this.description,
    required this.likes,
    required this.comments,
    required this.isBookmarked,
    required this.showVideoFirst,
  });

  static List<FeedItemModel> generateFakeData() {
    List<FeedItemModel> feedItems = [];
    // String videoUrl = "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4";
    String videoUrl = "https://storage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4";
    for (int i = 0; i < 10; i++) {
      feedItems.add(FeedItemModel(
        userAvatarUrl: "https://i.pravatar.cc/150?img=${i + 1}",
        username: "Username ${i + 1}",
        postImageUrl: "https://picsum.photos/id/${i + 10}/400/600",
        postVideoUrl: i % 3 == 0 ? videoUrl : '',
        description: "Post description for post ${i + 1}",
        likes: (i + 1) * 23,
        comments: (i + 1) * 12,
        isBookmarked: i % 2 == 0,
        showVideoFirst: i % 3 == 0,
      ));
    }

    return feedItems;
  }
}
