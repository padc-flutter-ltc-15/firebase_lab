import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_lab/data/vos/news_feed_vo.dart';
import 'package:firebase_lab/network/social_data_agent.dart';

import '../data/vos/news_feed_vo.dart';

/// Database Paths
const newsFeedPath = "newsfeed";

class RealtimeDatabaseDataAgentImpl extends SocialDataAgent {
  static final RealtimeDatabaseDataAgentImpl _singleton =
      RealtimeDatabaseDataAgentImpl._internal();

  factory RealtimeDatabaseDataAgentImpl() {
    return _singleton;
  }

  RealtimeDatabaseDataAgentImpl._internal();

  /// Database
  var databaseRef = FirebaseDatabase.instance.reference();

  @override
  Stream<List<NewsFeedVO>> getNewsFeed() {
    return databaseRef.child(newsFeedPath).onValue.map((event) {

      debugPrint("getNewFeed() -> snapshot.key -> ${event.snapshot.key}"); // getNewFeed() -> key -> newsfeed
      debugPrint("getNewFeed() -> snapshot.value -> ${event.snapshot.value}"); // getNewFeed() -> value -> {1686970665710: {post_image: https://archanakakar.com/wp-content/uploads/2016/08/madrid-spring_2848493a-large.jpg, user_name: Zaw Moe Htike, description: Hola Rangoon, profile_picture: https://avatars.githubusercontent.com/u/29286198?v=4, id: 1686970665710}, 1686968810867: {post_image: https://archanakakar.com/wp-content/uploads/2016/08/madrid-spring_2848493a-large.jpg, user_name: Zaw Moe Htike, description: Hola Madrid, profile_picture: https://avatars.githubusercontent.com/u/29286198?v=4, id: 1686968810867}}

      final dynamic snapshotValue = event.snapshot.value;

      if (snapshotValue is Map<dynamic, dynamic>) {
        debugPrint("getNewFeed() -> snapshotValue.values -> ${snapshotValue.values}"); // getNewFeed() -> snapshotValue.values -> ({post_image: https://archanakakar.com/wp-content/uploads/2016/08/madrid-spring_2848493a-large.jpg, user_name: Zaw Moe Htike, description: Hola Rangoon, profile_picture: https://avatars.githubusercontent.com/u/29286198?v=4, id: 1686970665710}, {post_image: https://archanakakar.com/wp-content/uploads/2016/08/madrid-spring_2848493a-large.jpg, user_name: Zaw Moe Htike, description: Hola Madrid, profile_picture: https://avatars.githubusercontent.com/u/29286198?v=4, id: 1686968810867})

        List<NewsFeedVO> newsFeedList = snapshotValue.values.map<NewsFeedVO>((newsFeedJson) {
          debugPrint("getNewFeed() -> snapshotValue.values.json -> ${newsFeedJson}");

          return NewsFeedVO.fromJson(Map<String, dynamic>.from(newsFeedJson));
        }).toList();

        return newsFeedList;
      } else {
        return [];
      }
    });
  }

  @override
  Future<void> addNewPost(NewsFeedVO newPost) {
    return databaseRef
        .child(newsFeedPath)
        .child(newPost.id.toString())
        .set(newPost.toJson());
  }

  @override
  Future<void> deletePost(int postId) {
    return databaseRef.child(newsFeedPath)
        .child(postId.toString()).remove();
  }

  @override
  Stream<NewsFeedVO> getNewsFeedById(int newsFeedId) {
    return databaseRef
        .child(newsFeedPath)
        .child(newsFeedId.toString())
        .once()
        .asStream()
        .map((event) {
      final dynamic value = event.snapshot.value;
      if (value != null) {
        return NewsFeedVO.fromJson(Map<String, dynamic>.from(value));
      } else {
        throw Exception('Data not found');
      }
    });
  }

}
