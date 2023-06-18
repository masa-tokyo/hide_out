import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:hide_out/utils/constants.dart';
import 'package:recase/recase.dart';

class Tracking {
  factory Tracking() => Tracking._instance ??= Tracking._internal();

  Tracking._internal() : _analytics = FirebaseAnalytics();

  static Tracking? _instance;
  final FirebaseAnalytics _analytics;

  void logEvent(EventType eventType, {Map<String, dynamic>? eventParams}) {
    _analytics.logEvent(
        name: _convertToSnakeCase(eventType.name),
        parameters: eventParams);
  }

  String _convertToSnakeCase(String eventTypeStr) {
    return ReCase(eventTypeStr).snakeCase;
  }

  FirebaseAnalyticsObserver getPageViewObserver() {
    //todo add a comment

    return FirebaseAnalyticsObserver(
      analytics: _analytics,
      nameExtractor: (settings) {
        final paths = settings.name?.split('?');
        if (paths == null) {
          return null;
        }
        final path = paths.first;
        _pageView(path);
        return path;
      },
    );
  }

  Future<void> _pageView(String screenName) async{
    await _analytics.setCurrentScreen(screenName: screenName);
    //todo set a value
    // logEvent(EventType.pageView);
  }

Future<void> setUserId(String id) async {
    await _analytics.setUserId(id);
  }





}
