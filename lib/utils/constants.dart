String userIconUrl() {
  return "https://firebasestorage.googleapis.com/v0/b/voiceput-e9f38.appspot.com/o/icon%2Fuser.png?alt=media&token=f9840490-3249-4292-9f3b-af0859945463";
}

enum RecordingButtonStatus {
  BEFORE_RECORDING,
  DURING_RECORDING,
  AFTER_RECORDING,
}

enum GroupEditMenu {
  EDIT,
  LEAVE,
  NO_EDIT,
  DELETE,
}

enum LoginScreenStatus {
  SIGNED_UP,
  SIGNED_IN,
  FAILED,
}

enum RecordingButtonOpenMode {
  POST_FROM_HOME,
  POST_FROM_GROUP,
  SELF_INTRO_FROM_PROFILE,
  SELF_INTRO_FROM_SIGN_UP,
}
enum ProfileEditScreensOpenMode {
  SIGN_UP,
  PROFILE,
}

enum GroupDetailScreenOpenMode {
  SIGN_UP,
  JOIN,
  GROUP,
}

enum AudioPlayType {
  POST_MINE,
  POST_OTHERS,
  SELF_INTRO,
}

enum NotificationType {
  NEW_POST,
  AUTO_EXIT,
  DELETED_GROUP,
  ALERT_AUTO_EXIT,
  NEW_OWNER,
}

enum NotificationDeleteType {
  NOTIFICATION_ID,
  OPEN_POST,
  // followings are done from cloud functions:
  // DELETE_POST,
  // LEAVE_GROUP,
  // DELETE_GROUP,
}
