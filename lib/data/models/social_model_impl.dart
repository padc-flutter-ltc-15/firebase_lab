import 'package:firebase_lab/data/models/social_model.dart';
import 'package:firebase_lab/data/vos/news_feed_vo.dart';
import 'package:firebase_lab/network/cloud_firestore_data_agent_impl.dart';
import 'package:firebase_lab/network/real_time_database_data_agent_impl.dart';
import 'package:firebase_lab/network/social_data_agent.dart';

class SocialModelImpl extends SocialModel {
  static final SocialModelImpl _singleton = SocialModelImpl._internal();

  factory SocialModelImpl() {
    return _singleton;
  }

  SocialModelImpl._internal();

  // SocialDataAgent mDataAgent = RealtimeDatabaseDataAgentImpl();
     SocialDataAgent mDataAgent = CloudFireStoreDataAgentImpl();
  @override
  Stream<List<NewsFeedVO>> getNewsFeed() {
    return mDataAgent.getNewsFeed();
  }

  @override
  Future<void> addNewPost(String description) {
    var currentMilliseconds = DateTime.now().millisecondsSinceEpoch;
    var newPost = NewsFeedVO(
      id: currentMilliseconds,
      userName: "Zaw Moe Htike",
      postImage: "",
      description: description,
      profilePicture:
      "https://avatars.githubusercontent.com/u/29286198?v=4",
    );
    return mDataAgent.addNewPost(newPost);
  }

  @override
  Future<void> deletePost(int postId) {
    return mDataAgent.deletePost(postId);
  }

  @override
  Future<void> editPost(NewsFeedVO newsFeed) {
    return mDataAgent.addNewPost(newsFeed);
  }

  @override
  Stream<NewsFeedVO> getNewsFeedById(int newsFeedId) {
     return mDataAgent.getNewsFeedById(newsFeedId);
  }
}
