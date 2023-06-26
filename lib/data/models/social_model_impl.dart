import 'dart:io';

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

  //SocialDataAgent mDataAgent = RealtimeDatabaseDataAgentImpl();
  SocialDataAgent mDataAgent = CloudFireStoreDataAgentImpl();

  @override
  Stream<List<NewsFeedVO>> getNewsFeed() {
    return mDataAgent.getNewsFeed();
  }

  @override
  Future<void> deletePost(int postId) {
    return mDataAgent.deletePost(postId);
  }

  @override
  Future<void> addNewPost(String description, File? imageFile) {
    if (imageFile != null) {
      return mDataAgent
          .uploadFileToFirebase(imageFile)
          .then((downloadUrl) => craftNewsFeedVO(description, downloadUrl))
          .then((newPost) => mDataAgent.addNewPost(newPost));
    } else {
      return craftNewsFeedVO(description, "")
          .then((newPost) => mDataAgent.addNewPost(newPost));
    }
  }

  Future<NewsFeedVO> craftNewsFeedVO(String description, String imageUrl) {
    var currentMilliseconds = DateTime.now().millisecondsSinceEpoch;
    var newPost = NewsFeedVO(
      id: currentMilliseconds,
      userName: "Zaw Moe Htike",
      postImage: imageUrl,
      description: description,
      profilePicture:
      "https://avatars.githubusercontent.com/u/29286198?v=4",
    );
    return Future.value(newPost);
  }

  @override
  Stream<NewsFeedVO> getNewsFeedById(int newsFeedId) {
    return mDataAgent.getNewsFeedById(newsFeedId);
  }

  @override
  Future<void> updatePost(NewsFeedVO newsFeed, File? imageFile) {
    return mDataAgent.addNewPost(newsFeed);
  }
}
