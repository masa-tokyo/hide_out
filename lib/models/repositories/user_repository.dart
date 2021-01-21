import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:voice_put/%20data_models/user.dart';
import 'package:voice_put/models/database_manager.dart';

class UserRepository extends ChangeNotifier{
  final DatabaseManager dbManager;

  UserRepository({this.dbManager});

  static User currentUser;

  bool _isProcessing = false;
  bool get isProcessing => _isProcessing;

  bool _isSuccessful = false;
  bool get isSuccessful => _isSuccessful;


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

  Future<void> signUp() async {
    _isProcessing = true;
    notifyListeners();

    try {
      GoogleSignInAccount signInAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication signInAuthentication = await signInAccount.authentication;

      final auth.AuthCredential credential = auth.GoogleAuthProvider.credential(
        idToken: signInAuthentication.idToken,
        accessToken: signInAuthentication.accessToken,
      );

      final firebaseUser = (await _auth.signInWithCredential(credential)).user;
      if (firebaseUser == null) {
        _isSuccessful = false;
      }

      final isUserExistedInDb = await dbManager.searchUserInDb(firebaseUser);

      if(!isUserExistedInDb) {
        await dbManager.insertUser(_convertToUser(firebaseUser));
      }
      currentUser = await dbManager.getUserInfoFromDbById(firebaseUser.uid);
      _isSuccessful = true;

    } catch (error) {
      print("sign in error caught: $error");
      _isSuccessful = false;

    }
    _isProcessing = false;
    notifyListeners();

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
}
