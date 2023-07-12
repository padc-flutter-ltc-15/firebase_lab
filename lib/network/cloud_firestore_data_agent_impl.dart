import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_lab/data/vos/news_feed_vo.dart';
import 'package:firebase_lab/network/social_data_agent.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../data/vos/news_feed_vo.dart';
import '../data/vos/user_vo.dart';

/// News Feed Collection
const newsFeedCollection = "newsfeed";
const fileUploadRef = "uploads";
const usersCollection = "users";

class CloudFireStoreDataAgentImpl extends SocialDataAgent {
  /// FireStore
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  /// Storage
  var firebaseStorage = FirebaseStorage.instance;

  /// Auth
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Future<void> addNewPost(NewsFeedVO newPost) {
    return _fireStore
        .collection(newsFeedCollection)
        .doc(newPost.id.toString())
        .set(newPost.toJson());
  }

  @override
  Future<void> deletePost(int postId) {
    return _fireStore
        .collection(newsFeedCollection)
        .doc(postId.toString())
        .delete();
  }

  @override
  Stream<List<NewsFeedVO>> getNewsFeed() {
    return _fireStore
        .collection(newsFeedCollection)
        .snapshots()
        .map((collection) {
      return collection.docs.map<NewsFeedVO>((document) {
        return NewsFeedVO.fromJson(document.data());
      }).toList();
    });
  }

  @override
  Stream<NewsFeedVO> getNewsFeedById(int newsFeedId) {
    return _fireStore
        .collection(newsFeedCollection)
        .doc(newsFeedId.toString())
        .get()
        .asStream()
        .where((documentSnapShot) => documentSnapShot.data() != null)
        .map((documentSnapShot) =>
        NewsFeedVO.fromJson(documentSnapShot.data()!));
  }

  @override
  Future<String> uploadFileToFirebase(File image) {
    return firebaseStorage
        .ref(fileUploadRef)
        .child("${DateTime.now().millisecondsSinceEpoch}")
        .putFile(image)
        .then((taskSnapshot) => taskSnapshot.ref.getDownloadURL());
  }

  @override
  Future registerNewUser(UserVO newUser) {
    return auth
        .createUserWithEmailAndPassword(
        email: newUser.email ?? "", password: newUser.password ?? "")
        .then((credential) =>
    credential.user?..updateDisplayName(newUser.userName))
        .then((user) {
      newUser.id = user?.uid ?? "";
      _addNewUser(newUser);
    });
  }

  Future<void> _addNewUser(UserVO newUser) {
    return _fireStore
        .collection(usersCollection)
        .doc(newUser.id.toString())
        .set(newUser.toJson());
  }

  @override
  Future login(String email, String password) {
    return auth.signInWithEmailAndPassword(email: email, password: password);
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
    return _fireStore
        .collection(usersCollection)
        .doc(userId.toString())
        .get()
        .then((documentSnapShot) =>  UserVO.fromJson(documentSnapShot.data()!));
  }
}
