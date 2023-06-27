import 'dart:io';

import 'package:firebase_lab/data/models/authentication_model.dart';
import 'package:firebase_lab/data/vos/user_vo.dart';
import 'package:firebase_lab/network/real_time_database_data_agent_impl.dart';
import 'package:firebase_lab/network/social_data_agent.dart';

class AuthenticationModelImpl extends AuthenticationModel {
  static final AuthenticationModelImpl _singleton =
  AuthenticationModelImpl._internal();

  factory AuthenticationModelImpl() {
    return _singleton;
  }

  AuthenticationModelImpl._internal();

  SocialDataAgent mDataAgent = RealtimeDatabaseDataAgentImpl();

  //SocialDataAgent mDataAgent = CloudFireStoreDataAgentImpl();

  @override
  Future<void> login(String email, String password) {
    return mDataAgent.login(email, password);
  }

  @override
  Future<void> register(String email, String userName, String password, File? userProfile) {
    if(userProfile != null){
      return mDataAgent
          .uploadFileToFirebase(userProfile)
          .then((downloadUrl) => craftUserVO(email, password, userName, downloadUrl))
          .then((user) => mDataAgent.registerNewUser(user));
    } else {
      return craftUserVO(email, password, userName, "")
          .then((user) => mDataAgent.registerNewUser(user));
    }
  }

  Future<UserVO> craftUserVO(String email, String password, String userName,String userProfile) {
    var newUser = UserVO(
      id: "",
      userProfile: userProfile,
      userName: userName,
      email: email,
      password: password,
    );
    return Future.value(newUser);
  }

  @override
  UserVO getLoggedInUser() {
    return mDataAgent.getLoggedInUser();
  }

  @override
  bool isLoggedIn() {
    return mDataAgent.isLoggedIn();
  }

  @override
  Future<void> logOut() {
    return mDataAgent.logOut();
  }

  @override
  Future<UserVO> getUserProfileById(String id) {
    return mDataAgent.getUserProfileById(id);
  }
}
