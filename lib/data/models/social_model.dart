import 'dart:io';
import 'package:firebase_lab/data/vos/news_feed_vo.dart';

import '../vos/user_vo.dart';

abstract class SocialModel {
  Stream<List<NewsFeedVO>> getNewsFeed();
  Stream<NewsFeedVO> getNewsFeedById(int newsFeedId);
  Future<void> addNewPost(String description, File? imageFile, String userProfile);
  Future<void> editPost(NewsFeedVO newsFeed, File? imageFile);
  Future<void> deletePost(int postId);

  Future<UserVO> getUserProfileById(String userId );
}
