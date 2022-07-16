// import 'package:flutter/material.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';
//
// class DenemeVideo extends StatefulWidget {
//   DenemeVideo({
//     Key? key,
//   }) : super(key: key);
//   @override
//   State<DenemeVideo> createState() => _DenemeVideoState();
// }
//
// class _DenemeVideoState extends State<DenemeVideo> {
//   YoutubePlayerController _controller = YoutubePlayerController(
//     initialVideoId: 'OABAqND52G4',
//     flags: YoutubePlayerFlags(
//       autoPlay: true,
//       mute: false,
//     ),
//   );
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Center(
//           child: Container(
//             alignment: Alignment.centerLeft,
//             decoration: BoxDecoration(
//               color: ApplicationConstants.mavi,
//               borderRadius: BorderRadius.circular(27),
//             ),
//             height: 60.0,
//             width: 330,
//             child: TextField(
//               controller: _controller,
//               onChanged: (v) {
//                 timer?.cancel();
//                 timer = Timer(
//                   const Duration(seconds: 1),
//                   () {
//                     search(_controller.text);
//                   },
//                 );
//               },
//               keyboardType: TextInputType.text,
//               style: const TextStyle(color: ApplicationConstants.gri),
//               decoration: const InputDecoration(
//                 hintText: 'Ara...',
//                 border: InputBorder.none,
//                 contentPadding: EdgeInsets.only(top: 14.0),
//                 hintStyle: TextStyle(
//                   color: ApplicationConstants.gri,
//                   fontSize: 14,
//                 ),
//               ),
//             ),
//           ),
//         ),
//         _isLoading
//             ? const Center(
//                 child: CircularProgressIndicator(),
//               )
//             : Container(
//                 height: MediaQuery.of(context).size.height * 0.4,
//                 color: ApplicationConstants.lacivert,
//                 child: ListView.builder(
//                   itemBuilder: (context, index) {
//                     var search = movie!.results![index];
//                     return ListTile(
//                       leading: Image.network(
//                         ApplicationConstants.poster + search.posterPath!,
//                       ),
//                       title: Text(
//                         search.title!,
//                         style: const TextStyle(color: Colors.white60),
//                       ),
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => DetailScreen(
//                                 id: search.id!,
//                                 title: search.title!,
//                                 posterPath: search.posterPath!,
//                                 genreIDs: search.genreId!,
//                                 voteAverage: search.voteAverage!,
//                                 date: search.releaseDate!),
//                           ),
//                         );
//                       },
//                     );
//                   },
//                   itemCount: 10,
//                 ),
//               )
//       ],
//     );
//     //   Scaffold(
//     //   appBar: AppBar(
//     //     title: const Text('Deneme Favorite'),
//     //   ),
//     //   body: Column(
//     //     mainAxisAlignment: MainAxisAlignment.center,
//     //     children: <Widget>[
//     //       Center(
//     //         child: InkWell(
//     //           onTap: () {
//     //             _showDialog();
//     //           },
//     //           child: Container(
//     //             height: 70,
//     //             width: 250,
//     //             decoration: BoxDecoration(
//     //               color: Colors.red,
//     //             ),
//     //             child: Padding(
//     //               padding: EdgeInsets.all(20),
//     //               child: Center(
//     //                 child: Text('tıkla'),
//     //               ),
//     //             ),
//     //           ),
//     //         ),
//     //       )
//     //     ],
//     //   ),
//     // );
//   }
//
//   _showDialog() {
//     showDialog(
//         context: context,
//         barrierDismissible: true,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(10),
//             ),
//             backgroundColor: Colors.green,
//             title: Text('deneme'),
//             actions: <Widget>[
//               YoutubePlayer(
//                 controller: _controller,
//                 showVideoProgressIndicator: true,
//                 progressIndicatorColor: Colors.red,
//               ),
//             ],
//           );
//         });
//   }
// }
