import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:firebase_lab/data/models/social_model.dart';
import 'package:firebase_lab/data/models/social_model_impl.dart';
import 'package:firebase_lab/data/vos/news_feed_vo.dart';

class AddNewPostBloc extends ChangeNotifier {
  /// State
  String newPostDescription = "";
  bool isAddNewPostError = false;
  bool isDisposed = false;

  /// For Edit Mode
  bool isInEditMode = false;
  String userName = "";
  String profilePicture = "";
  NewsFeedVO? mNewsFeed;

  bool isLoading = false;

  /// Image
  File? chosenImageFile;

  /// Model
  final SocialModel _model = SocialModelImpl();

  AddNewPostBloc({int? newsFeedId}) {
    if (newsFeedId != null) {
      isInEditMode = true;
      _prepopulateDataForEditMode(newsFeedId);
    } else {
      _prepopulateDataForAddNewPost();
    }
  }

  void _prepopulateDataForAddNewPost() {
    userName = "Zaw Moe Htike";
    profilePicture = "https://avatars.githubusercontent.com/u/29286198?v=4";

    _notifySafely();
  }

  void _prepopulateDataForEditMode(int newsFeedId) {
    _model.getNewsFeedById(newsFeedId).listen((newsFeed) {
      userName = newsFeed.userName ?? "";
      profilePicture = newsFeed.profilePicture ?? "";
      newPostDescription = newsFeed.description ?? "";

      mNewsFeed = newsFeed;

      _notifySafely();
    });
  }

  void onImageChosen(File imageFile) {
    chosenImageFile = imageFile;

    _notifySafely();
  }

  void onTapDeleteImage() {
    chosenImageFile = null;

    _notifySafely();
  }

  void onNewPostTextChanged(String newPostDescription) {
    this.newPostDescription = newPostDescription;
  }

  Future onTapAddNewPost() {
    if (newPostDescription.isEmpty) {
      isAddNewPostError = true;
      _notifySafely();
      return Future.error("Error");
    } else {
      isLoading = true;
      _notifySafely();
      isAddNewPostError = false;
      if (isInEditMode) {
        return _updateNewsFeedPost().then((value) {
          isLoading = false;
          _notifySafely();
        });
      } else {
        return _createNewNewsFeedPost().then((value) {
          isLoading = false;
          _notifySafely();
        });
      }
    }
  }

  void _notifySafely() {
    if (!isDisposed) {
      notifyListeners();
    }
  }

  Future<dynamic> _updateNewsFeedPost() {
    mNewsFeed?.description = newPostDescription;

    if (mNewsFeed != null) {
      return _model.updatePost(mNewsFeed!, chosenImageFile);
    } else {
      return Future.error("Error");
    }
  }

  Future<void> _createNewNewsFeedPost() {
    return _model.addNewPost(newPostDescription, chosenImageFile);
  }

  @override
  void dispose() {
    super.dispose();
    isDisposed = true;
  }
}
