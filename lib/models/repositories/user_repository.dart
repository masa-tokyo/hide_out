import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:voice_put/%20data_models/group.dart';
import 'package:voice_put/%20data_models/user.dart';
import 'package:voice_put/models/database_manager.dart';
import 'package:voice_put/utils/constants.dart';

class UserRepository extends ChangeNotifier{
  final DatabaseManager dbManager;

  UserRepository({this.dbManager});

  static User currentUser;

  bool _isProcessing = false;
  bool get isProcessing => _isProcessing;

  List<User> _groupMembers = [];
  List<User> get groupMembers => _groupMembers;


  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<bool> isSignIn() async {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser != null) {
      currentUser = await dbManager.getUserInfoFromDbById(firebaseUser.uid);
      return true;
    }
    return false;
  }

  Future<LoginScreenStatus> signInOrSignUp() async {

    try {
      GoogleSignInAccount signInAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication signInAuthentication = await signInAccount.authentication;

      final auth.AuthCredential credential = auth.GoogleAuthProvider.credential(
        idToken: signInAuthentication.idToken,
        accessToken: signInAuthentication.accessToken,
      );

      final firebaseUser = (await _auth.signInWithCredential(credential)).user;
      if (firebaseUser == null) {
        return LoginScreenStatus.FAILED;
      }

      final isUserExistedInDb = await dbManager.searchUserInDb(firebaseUser);

      if(!isUserExistedInDb) {
        //Sign up
        await dbManager.insertUser(_convertToUser(firebaseUser));
        currentUser = await dbManager.getUserInfoFromDbById(firebaseUser.uid);
        return LoginScreenStatus.SIGNED_UP;

      } else {
        //Sign in
        currentUser = await dbManager.getUserInfoFromDbById(firebaseUser.uid);
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
    );
  }

  Future<void> registerGroupIdOnUsers(String groupId) async{
    await dbManager.registerGroupIdOnUsers(groupId, currentUser.userId);
  }

  Future<void> updateUserName(String userName) async{
     currentUser = User(
        userId: currentUser.userId,
        displayName: currentUser.displayName,
        inAppUserName: userName,
        photoUrl: currentUser.photoUrl);
    await dbManager.updateUserInfo(currentUser);


  }

  Future<void> getUsersByGroupId(Group group) async{
    _isProcessing = true;

    _groupMembers = await dbManager.getUsersByGroupId(group.groupId);

    _isProcessing = false;
    notifyListeners();

  }
}
