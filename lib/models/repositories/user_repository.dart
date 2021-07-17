import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:uuid/uuid.dart';
import 'package:voice_put/%20data_models/group.dart';
import 'package:voice_put/%20data_models/user.dart';
import 'package:voice_put/%20data_models/notification.dart' as d;
import 'package:voice_put/models/database_manager.dart';
import 'package:voice_put/utils/constants.dart';

class UserRepository extends ChangeNotifier{
  final DatabaseManager? dbManager;

  UserRepository({this.dbManager});

  static User? currentUser;

  bool _isProcessing = false;
  bool get isProcessing => _isProcessing;

  bool _isUploading = false;
  bool get isUploading => _isUploading;


  List<User> _groupMembers = [];
  List<User> get groupMembers => _groupMembers;

  List<d.Notification> _notifications = [];
  List<d.Notification> get notifications => _notifications;

  bool _isUpdating = false;
  bool get isUpdating => _isUpdating;


  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<bool> isSignIn() async {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser != null) {
      currentUser = await dbManager!.getUserInfoFromDbById(firebaseUser.uid);
      return true;
    }
    return false;
  }

  Future<LoginScreenStatus> signInOrSignUp() async {

    try {
      GoogleSignInAccount? signInAccount = await _googleSignIn.signIn();
      if(signInAccount == null) return LoginScreenStatus.FAILED;

      GoogleSignInAuthentication signInAuthentication = await signInAccount.authentication;

      final auth.AuthCredential credential = auth.GoogleAuthProvider.credential(
        idToken: signInAuthentication.idToken,
        accessToken: signInAuthentication.accessToken,
      );

      final firebaseUser = (await _auth.signInWithCredential(credential)).user;
      if (firebaseUser == null) {
        return LoginScreenStatus.FAILED;
      }

      final isUserExistedInDb = await dbManager!.searchUserInDb(firebaseUser);

      if(!isUserExistedInDb) {
        //Sign up
        await dbManager!.insertUser(_convertToUser(firebaseUser));
        currentUser = await dbManager!.getUserInfoFromDbById(firebaseUser.uid);
        return LoginScreenStatus.SIGNED_UP;

      } else {
        //Sign in
        currentUser = await dbManager!.getUserInfoFromDbById(firebaseUser.uid);
        return LoginScreenStatus.SIGNED_IN;
      }

    } catch (error) {
      print("sign in error caught: $error");
      return LoginScreenStatus.FAILED;
    }
  }

  User _convertToUser(auth.User firebaseUser) {
    return User(
      userId: firebaseUser.uid,
      displayName: firebaseUser.displayName,
      inAppUserName: firebaseUser.displayName,
      photoUrl: firebaseUser.photoURL,
      email: firebaseUser.email,
      audioStoragePath: "",
      audioUrl: "",
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );
  }



  Future<void> updateUserInfo(User updatedCurrentUser) async{

    currentUser = updatedCurrentUser;
    await dbManager!.updateUserInfo(currentUser!);

    //for drawing ProfileScreen again
    notifyListeners();

  }

  Future<void> getUsersByGroupId(Group group) async{
    _isProcessing = true;
    notifyListeners();

    _groupMembers = await dbManager!.getUsersByGroupId(group.groupId);

    _isProcessing = false;
    notifyListeners();

  }

  Future<void> uploadSelfIntro(String path) async{
    _isUploading = true;
    notifyListeners();

    final audioFile = File(path);
    final storageId = Uuid().v1();
    final audioUrl = await dbManager!.uploadAudioToStorage(audioFile, storageId);

    currentUser = currentUser!.copyWith(audioUrl: audioUrl, audioStoragePath: storageId);
    await dbManager!.updateUserInfo(currentUser!);

    _isUploading = false;
    notifyListeners();



  }

  Future<void> signOut() async{
    await _googleSignIn.signOut();
    await _auth.signOut();
    currentUser = null;
  }

  Future<void> getNotifications() async{
    _isProcessing = true;
    notifyListeners();

    _notifications = await dbManager!.getNotifications(currentUser!.userId);

    _isProcessing = false;
    notifyListeners();

  }

  Future<void> deleteNotification(
      {required NotificationDeleteType notificationDeleteType,
        String? postId,
      String? groupId,
      String? notificationId}) async{
    _isUpdating = true; //to update HomeScreen
    notifyListeners();

    switch (notificationDeleteType) {
      case NotificationDeleteType.NOTIFICATION_ID:
        await dbManager!.deleteNotification(notificationId: notificationId);
        _notifications.where((element) => element.notificationId == notificationId);
        break;

      case NotificationDeleteType.OPEN_POST:
        await dbManager!.deleteNotificationByPostIdAndUserId(
            postId: postId, userId: currentUser!.userId);
        _notifications.removeWhere((element) => element.postId == postId);
        break;

      case NotificationDeleteType.LEAVE_GROUP:
        await dbManager!.deleteNotificationByGroupIdAndUserId(
            groupId: groupId, userId: currentUser!.userId);
        _notifications.removeWhere((element) => element.groupId == groupId);
        break;

      case NotificationDeleteType.DELETE_POST:
        await dbManager!.deleteNotificationByPostId(postId: postId);
        break;

      case NotificationDeleteType.DELETE_GROUP:
        await dbManager!.deleteNotificationByGroupId(groupId: groupId);
        _notifications.removeWhere((element) => element.groupId == groupId);
        break;
    }

    _isUpdating = false;
    notifyListeners();

  }


}
