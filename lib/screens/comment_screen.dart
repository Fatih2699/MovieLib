import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:movielib/constants/app_constants.dart';
import 'package:movielib/model/comment_model.dart';
import 'package:movielib/model/movie_model.dart';
import 'package:movielib/screens/detail_screen.dart';
import 'package:movielib/screens/splash_screen.dart';
import 'package:movielib/view_models/movie_view_models.dart';
import 'package:movielib/view_models/user_view_models.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommentScreen extends StatefulWidget {
  final int id;
  const CommentScreen({Key? key, required this.id}) : super(key: key);

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  bool _isInit = true;
  bool _isLoading = false;
  Movie? _movie;
  late UserModel _userModel;
  List<Map<String, dynamic>> commentData = [];

  @override
  Future<void> didChangeDependencies() async {
    if (_isInit) {
      debugPrint('init oldu');
      setState(() {
        _isLoading = true;
      });
      MovieViewModel _movieViewModel = Provider.of<MovieViewModel>(context);
      _userModel = Provider.of<UserModel>(context, listen: false);
      _movie = await _movieViewModel.fetchMovie(widget.id);
      setState(() {
        _isLoading = false;
      });
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  Future<bool> addComment() async {
    Comment comment =
        Comment(_userModel.user.userId, _movie!.id.toString(), controller.text);
    final FirebaseFirestore _firebaseDB = FirebaseFirestore.instance;
    var added = await _firebaseDB.collection("comments").add(comment.toMap());
    comments();
    return true;
  }

  Future<bool> comments() async {
    final FirebaseFirestore _firebaseDB = FirebaseFirestore.instance;
    commentData = [];
    var comments = await _firebaseDB
        .collection('comments')
        .where("movieId", isEqualTo: widget.id.toString())
        .get();
    for (var i = 0; i < comments.docs.length; i++) {
      var commentd = comments.docs[i].data();
      var user = await _firebaseDB
          .collection('users')
          .doc(commentd['userId'].toString())
          .get();
      var userData = user.data();
      Timestamp dt = commentd['date'] as Timestamp;
      final DateTime date = dt.toDate();
      setState(() {
        commentData.add({
          "user_name": userData != null ? userData['displayName'] : "",
          "user_image": userData != null ? userData['photoURL'] : "",
          "content": commentd['content'],
          "date": date
        });
      });
    }
    return true;
  }

  TextEditingController controller = TextEditingController();
  @override
  void initState() {
    comments();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const SplashScreen()
        : Scaffold(
            body: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                color: ApplicationConstants.lacivert,
                width: double.infinity,
                child: SafeArea(
                  child: Column(
                    children: <Widget>[
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 3,
                              width: MediaQuery.of(context).size.width / 2,
                              child: InkWell(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailScreen(
                                      id: widget.id,
                                      title: _movie!.title!,
                                      posterPath: _movie!.posterPath!,
                                      genreIDs: _movie!.genreId!,
                                      voteAverage: _movie!.voteAverage!,
                                      date: _movie!.releaseDate!,
                                    ),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 4),
                                  child: Image.network(
                                    ApplicationConstants.poster +
                                        _movie!.posterPath!,
                                    fit: BoxFit.fill,
                                    loadingBuilder: (BuildContext context,
                                        Widget child,
                                        ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value: loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                            Column(
                              children: <Widget>[
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 26,
                                  width:
                                      MediaQuery.of(context).size.width / 1.7,
                                  child: AutoSizeText(
                                    _movie!.title!,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 26,
                                  width:
                                      MediaQuery.of(context).size.width / 1.7,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      const Icon(
                                        Icons.star_outlined,
                                        color: Colors.orangeAccent,
                                      ),
                                      SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              30),
                                      Text(
                                        _movie!.voteAverage.toString(),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 26,
                                  width:
                                      MediaQuery.of(context).size.width / 1.7,
                                  child: Row(
                                    children: <Widget>[
                                      const Icon(
                                        Icons.date_range,
                                        color: Color(0XFF5F2020),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                30,
                                      ),
                                      Text(
                                        DateFormat.yMd()
                                            .format(_movie!.releaseDate!),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 100,
                      ),
                      Expanded(
                        flex: 9,
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height / 1.5,
                          child: commentData.isEmpty
                              ? const Center(
                                  child: Text(
                                    'Henüz bir yorum yok...',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )
                              : ListView.builder(
                                  itemCount: commentData.length,
                                  scrollDirection: Axis.vertical,
                                  controller: ScrollController(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    debugPrint('DENEME' +
                                        commentData.length.toString());
                                    Map<String, dynamic> cData =
                                        commentData[index];
                                    var formattedDate = timeago
                                        .format(cData['date'], locale: 'en');
                                    return Card(
                                      color: ApplicationConstants.mavi,
                                      child: Padding(
                                        padding: const EdgeInsets.all(6),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            CircleAvatar(
                                              backgroundColor:
                                                  Colors.transparent,
                                              radius: 20,
                                              backgroundImage: NetworkImage(
                                                  cData['user_image']!),
                                            ),
                                            Flexible(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 5),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          cData['user_name']!,
                                                          style:
                                                              const TextStyle(
                                                            color:
                                                                Colors.white60,
                                                          ),
                                                        ),
                                                        Text(
                                                          cData['content']!,
                                                          style:
                                                              const TextStyle(
                                                            color:
                                                                Colors.white60,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  // Padding(
                                                  //   padding:
                                                  //       const EdgeInsets.only(
                                                  //           left: 5),
                                                  //   child: AutoSizeText(
                                                  //     '${cData['user_name']!}\n${cData['content']!}',
                                                  //     style: const TextStyle(
                                                  //       color: Colors.white60,
                                                  //     ),
                                                  //     maxLines: 3,
                                                  //     minFontSize: 10,
                                                  //     maxFontSize: 15,
                                                  //     overflow:
                                                  //         TextOverflow.ellipsis,
                                                  //   ),
                                                  // ),
                                                  Padding(
                                                    child: Text(
                                                      formattedDate,
                                                      style: const TextStyle(
                                                          color: Colors.grey),
                                                    ),
                                                    padding: EdgeInsets.only(
                                                        left: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height /
                                                            3.6),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: TextFormField(
                          minLines: 1,
                          maxLines: 5,
                          controller: controller,
                          keyboardType: TextInputType.emailAddress,
                          style:
                              const TextStyle(color: ApplicationConstants.gri),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height / 50),
                            suffixIcon: IconButton(
                              onPressed: () {
                                addComment();
                                clearResults();
                              },
                              icon: const Icon(
                                Icons.send_rounded,
                                color: Colors.white,
                              ),
                            ),
                            hintText: "Yorum ekle...",
                            hintStyle: const TextStyle(
                              color: ApplicationConstants.gri,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }

  void clearResults() {
    controller.clear();
  }
}
