// import 'package:flutter/material.dart';

// class DeviesScan extends StatelessWidget {
//   late String name;
//   late String ip;
//   bool isConnected = false;
//   DeviesScan({Key? key, required this.name, required this.ip})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.all(15),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(15),
//         color: Color.fromARGB(255, 48, 54, 79),
//       ),
//       child: ListTile(
//         title: Text(
//           name,
//           style: TextStyle(
//               fontWeight: FontWeight.w500, color: Colors.white, fontSize: 20),
//         ),
//         subtitle: Text(
//           ip,
//           style: TextStyle(
//               fontWeight: FontWeight.w500, color: Colors.white, fontSize: 20),
//         ),
//         trailing: MaterialButton(
//           clipBehavior: Clip.antiAlias,
//           color: Color(0xff748EF6),
//           onPressed: () {},
//           shape: StadiumBorder(),
//           child: Text(
//             'Connected',
//             style: TextStyle(color: Colors.white),
//           ),
//         ),
//       ),
//     );
//   }
// }
