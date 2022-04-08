import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hide_out/%20data_models/group.dart';
import 'package:hide_out/%20data_models/notification.dart' as d;
import 'package:hide_out/%20data_models/user.dart';
import 'package:hide_out/models/database_manager.dart';
import 'package:hide_out/utils/constants.dart';
import 'package:hide_out/utils/functions.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:uuid/uuid.dart';

class UserRepository extends ChangeNotifier {
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

  File? _imageFile;

  File? get imageFile => _imageFile;

  User? _member;
  User? get member => _member;

  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<bool> isSignIn() async {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser != null) {
      try {
        currentUser = await dbManager!.getUserInfoFromDbById(firebaseUser.uid);
      } catch (e) {
        print("error: $e");
      }
      return true;
    }
    return false;
  }

  Future<LoginScreenStatus> signInOrSignUpWithGoogle() async {
    try {
      GoogleSignInAccount? signInAccount = await _googleSignIn.signIn();
      if (signInAccount == null) return LoginScreenStatus.FAILED;

      GoogleSignInAuthentication signInAuthentication =
          await signInAccount.authentication;

      final auth.AuthCredential credential = auth.GoogleAuthProvider.credential(
        idToken: signInAuthentication.idToken,
        accessToken: signInAuthentication.accessToken,
      );

      final firebaseUser = (await _auth.signInWithCredential(credential)).user;
      if (firebaseUser == null) {
        return LoginScreenStatus.FAILED;
      }

      final isUserExistedInDb = await dbManager!.searchUserInDb(firebaseUser);

      if (!isUserExistedInDb) {
        //Sign up
        await dbManager!.insertUser(_convertToUser(firebaseUser));
        currentUser = await dbManager!.getUserInfoFromDbById(firebaseUser.uid);

        await createImageFile();

        return LoginScreenStatus.SIGNED_UP;
      } else {
        //Sign in

        //check whether the user signs in again right after deleting account
        final isAccountDeleted =
            await dbManager!.isAccountDeleted(firebaseUser.uid);
        if (isAccountDeleted) {
          return LoginScreenStatus.FAILED;
        }

        currentUser = await dbManager!.getUserInfoFromDbById(firebaseUser.uid);

        await createImageFile();

        return LoginScreenStatus.SIGNED_IN;
      }
    } catch (error) {
      print("sign in error caught: $error");
      return LoginScreenStatus.FAILED;
    }
  }

  Future<LoginScreenStatus> signInOrSignUpWithApple() async {
    try {
      final appleCredential =
          await SignInWithApple.getAppleIDCredential(scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ]);

      final oAuthProvider = auth.OAuthProvider('apple.com');
      final credential = oAuthProvider.credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      final firebaseUser = (await _auth.signInWithCredential(credential)).user;
      if (firebaseUser == null) {
        return LoginScreenStatus.FAILED;
      }

      final isUserExistedInDb = await dbManager!.searchUserInDb(firebaseUser);

      if (!isUserExistedInDb) {
        //Sign up
        await dbManager!.insertUser(_convertToUser(firebaseUser));
        currentUser = await dbManager!.getUserInfoFromDbById(firebaseUser.uid);

        await createImageFile();

        return LoginScreenStatus.SIGNED_UP;
      } else {
        //Sign in

        //check whether the user signs in again right after deleting account
        final isAccountDeleted =
            await dbManager!.isAccountDeleted(firebaseUser.uid);
        if (isAccountDeleted) {
          return LoginScreenStatus.FAILED;
        }

        currentUser = await dbManager!.getUserInfoFromDbById(firebaseUser.uid);

        await createImageFile();

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
      displayName: firebaseUser.displayName ?? '',
      inAppUserName: firebaseUser.displayName ?? '',
      photoUrl: _getRandomPhotoUrl(),
      photoStoragePath: "",
      email: firebaseUser.email ?? "",
      audioStoragePath: "",
      audioUrl: "",
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );
  }

  String _getRandomPhotoUrl() {
    var urls = [
      "https://firebasestorage.googleapis.com/v0/b/voiceput-e9f38.appspot.com/o/icon%2F1.png?alt=media&token=cca53ae8-2903-48f1-83e9-d0eec438a93f",
      "https://firebasestorage.googleapis.com/v0/b/voiceput-e9f38.appspot.com/o/icon%2F2.png?alt=media&token=2c0059b0-605d-49f3-9c0b-b88aa6bbcd60",
      "https://firebasestorage.googleapis.com/v0/b/voiceput-e9f38.appspot.com/o/icon%2F2.png?alt=media&token=2c0059b0-605d-49f3-9c0b-b88aa6bbcd60",
      "https://firebasestorage.googleapis.com/v0/b/voiceput-e9f38.appspot.com/o/icon%2F4.png?alt=media&token=c06a8c7f-e9a8-4b73-ad6e-76d9787ac2b0",
      "https://firebasestorage.googleapis.com/v0/b/voiceput-e9f38.appspot.com/o/icon%2F5.png?alt=media&token=16a1ceef-24c0-4d45-9b89-a3d22cecf56d",
      "https://firebasestorage.googleapis.com/v0/b/voiceput-e9f38.appspot.com/o/icon%2F6.png?alt=media&token=eca13b1f-148a-4781-919c-9da2874713ec",
      "https://firebasestorage.googleapis.com/v0/b/voiceput-e9f38.appspot.com/o/icon%2F7.png?alt=media&token=f15dff8d-900f-4091-8b65-00ad705deca2",
      "https://firebasestorage.googleapis.com/v0/b/voiceput-e9f38.appspot.com/o/icon%2F8.png?alt=media&token=9e4e220c-55ec-4907-b2fb-d1d5f4fecd39",
    ];

    return (urls..shuffle()).first;
  }

  Future<void> updateUserInfo(
      {required User updatedCurrentUser, required bool isNameUpdated}) async {
    currentUser = updatedCurrentUser;
    await dbManager!.updateUserInfo(currentUser!, isNameUpdated: isNameUpdated);

    //for drawing ProfileScreen again
    notifyListeners();
  }

  Future<void> getUsersByGroupId(Group group) async {
    _isProcessing = true;
    notifyListeners();

    _groupMembers = await dbManager!.getUsersByGroupId(group.groupId);

    _isProcessing = false;
    notifyListeners();
  }

  Future<void> uploadSelfIntro(String path) async {
    _isUploading = true;
    notifyListeners();

    final audioFile = File(path);
    final storageId = Uuid().v1();
    final storagePath = "users/$storageId";
    final audioUrl =
        await dbManager!.uploadAudioToStorage(audioFile, storagePath);

    currentUser = currentUser!
        .copyWith(audioUrl: audioUrl, audioStoragePath: storagePath);
    await dbManager!.updateUserInfo(currentUser!);

    _isUploading = false;
    notifyListeners();
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
    currentUser = null;
    _imageFile = null;
    notifyListeners();
  }

  Future<void> getNotifications() async {
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
      String? notificationId}) async {
    _isUpdating = true; //to update HomeScreen
    notifyListeners();

    switch (notificationDeleteType) {
      case NotificationDeleteType.NOTIFICATION_ID:
        await dbManager!.deleteNotification(notificationId: notificationId);
        _notifications
            .where((element) => element.notificationId == notificationId);
        break;

      case NotificationDeleteType.OPEN_POST:
        await dbManager!.deleteNotificationByPostIdAndUserId(
            postId: postId, userId: currentUser!.userId);
        _notifications.removeWhere((element) => element.postId == postId);
        break;
    }

    _isUpdating = false;
    notifyListeners();
  }

  Future<void> updateProfilePicture() async {
    final ImagePicker picker = ImagePicker();

    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      // draw the image right away, then create the file from url again later
      _imageFile = File(pickedImage.path);
      notifyListeners();

      final storageId = Uuid().v1();
      final storagePath = "users/$storageId";
      final photoUrl =
          await dbManager!.uploadPhotoToStorage(_imageFile!, storagePath);

      final previousStoragePath = currentUser!.photoStoragePath;

      currentUser = currentUser!.copyWith(
        photoUrl: photoUrl,
        photoStoragePath: storageId,
      );

      await dbManager!.updateUserInfo(currentUser!, isPhotoUpdated: true);
      if (previousStoragePath != "") {
        await dbManager!.deleteFileOnStorage(previousStoragePath!);
      }

      // set from remote in case that the photo in the local device is deleted
      _imageFile = await createFileFromUrl(currentUser!.photoUrl);
    }
  }

  Future<void> createImageFile() async {
    if (currentUser != null) {
      _imageFile = await createFileFromUrl(currentUser!.photoUrl);
      notifyListeners();
    }
  }

  Future<void> deleteAccount() async {
    // carry out the deletion from cloud functions
    await dbManager!.createDeleteAccountTrigger(currentUser!);
    await signOut();
  }

  Future<void> fetchUser(String memberId) async {
    _isProcessing = true;
    notifyListeners();

    _member = await dbManager!.fetchUser(memberId);
    _isProcessing = false;

    notifyListeners();
  }
}
