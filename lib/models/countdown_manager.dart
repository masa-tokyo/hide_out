//
// import 'dart:async';
//
// class CountdownManager {
//   Timer _timer;
//   int _intTime = 60;
//
//
//   void _startTimer() {
//     final oneSec = Duration(seconds: 1);
//     _timer = Timer.periodic(oneSec,
//             (timer) {
//           if(_intTime == 0){
//             setState(() {
//               timer.cancel();
//               Navigator.push(context, MaterialPageRoute(builder: (_) => widget.screen));
//
//             });
//           } else {
//             setState(() {
//               _intTime--;
//             });
//           }
//         });
//   }
//
//
//
// }