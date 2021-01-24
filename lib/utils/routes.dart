

/*      bottom to Top
  Route<Object> _createRoute(BuildContext context, Widget screen) {

    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionsBuilder: (context, animation, secondaryAnimation, child){
          var begin = Offset(0.0, 1.0);
          var end = Offset.zero;
          var curve = Curves.ease;
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);
          return SlideTransition(
            position: offsetAnimation,
            child: child,);

        });
  }
 */