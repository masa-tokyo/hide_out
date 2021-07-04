
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

enum GroupDetailScreenOpenMode{
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
}

enum NotificationDeleteType {
  NOTIFICATION_ID,
  OPEN_POST,
  DELETE_POST,
  LEAVE_GROUP,
  DELETE_GROUP,
}