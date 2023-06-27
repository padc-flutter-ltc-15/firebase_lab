import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_lab/data/vos/news_feed_vo.dart';
import 'package:firebase_lab/network/social_data_agent.dart';

import '../data/vos/news_feed_vo.dart';
import '../data/vos/user_vo.dart';

/// Database Paths
const newsFeedPath = "newsfeed";
const usersPath = "users";

/// File Upload References
const fileUploadRef = "uploads";

class RealtimeDatabaseDataAgentImpl extends SocialDataAgent {
  static final RealtimeDatabaseDataAgentImpl _singleton =
      RealtimeDatabaseDataAgentImpl._internal();

  factory RealtimeDatabaseDataAgentImpl() {
    return _singleton;
  }

  RealtimeDatabaseDataAgentImpl._internal();

  /// Database
  var databaseRef = FirebaseDatabase.instance.ref();

  /// Storage
  var firebaseStorage = FirebaseStorage.instance;

  /// Auth
  FirebaseAuth auth = FirebaseAuth.instance;

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
    return databaseRef.child(newsFeedPath).child(postId.toString()).remove();
  }

  @override
  Future<String> uploadFileToFirebase(File image) {
    return FirebaseStorage.instance
        .ref(fileUploadRef)
        .child("${DateTime.now().millisecondsSinceEpoch}")
        .putFile(image)
        .then((taskSnapshot) => taskSnapshot.ref.getDownloadURL());
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

  @override
  Future registerNewUser(UserVO newUser) {
    return auth
        .createUserWithEmailAndPassword(
          email: newUser.email ?? "",
          password: newUser.password ?? "",
        )
        /*.then((credential) =>
        credential.user?..updateDisplayName(newUser.userName))*/
        .then((userCredential) {
          userCredential.user?.updateDisplayName(newUser.userName);
          return userCredential.user;
        })
        .then((user) {
          newUser.id = user?.uid ?? "";
          _addNewUser(newUser);
        });
  }

  @override
  Future login(String email, String password) {
    return auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> _addNewUser(UserVO newUser) {
    return databaseRef
        .child(usersPath)
        .child(newUser.id.toString())
        .set(newUser.toJson());
  }

  @override
  bool isLoggedIn() {
    return auth.currentUser != null;
  }

  @override
  UserVO getLoggedInUser() {
    return UserVO(
      id: auth.currentUser?.uid,
      email: auth.currentUser?.email,
      userName: auth.currentUser?.displayName,
    );
  }

  @override
  Future logOut() {
    return auth.signOut();
  }

  @override
  Future<UserVO> getUserProfileById(String userId) {
    return databaseRef
        .child(usersPath)
        .child(userId)
        .once()
        .then((databaseEvent){
      final dynamic value = databaseEvent.snapshot.value;
      if(value != null){
        return UserVO.fromJson(Map<String,dynamic>.from(value));
      } else {
        throw Exception('Data not Found');
      }
    });
  }
}
