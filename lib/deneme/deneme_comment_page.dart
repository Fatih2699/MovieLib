import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:movielib/constants/app_constants.dart';
import 'package:movielib/model/comment_model.dart';
import 'package:movielib/model/movie_model.dart';
import 'package:movielib/screens/home_screen.dart';
import 'package:movielib/screens/splash_screen.dart';
import 'package:movielib/view_models/movie_view_models.dart';
import 'package:movielib/view_models/user_view_models.dart';
import 'package:provider/provider.dart';

class DenemeYorum extends StatefulWidget {
  int id;
  DenemeYorum({Key? key, required this.id}) : super(key: key);

  @override
  State<DenemeYorum> createState() => _DenemeYorumState();
}

class _DenemeYorumState extends State<DenemeYorum> {
  bool _isInit = true;
  bool _isLoading = false;
  Movie? _movie;
  late UserModel _userModel;

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
    DocumentSnapshot _okunanComment =
        await FirebaseFirestore.instance.doc('comments/$added').get();
    Map<String, dynamic> _okunanCommentBilgileriMapi =
        _okunanComment.data() as Map<String, dynamic>;
    Comment _okunanCommentBilgileriNesne =
        Comment.fromMap(_okunanCommentBilgileriMapi);
    print(
      "Okunan Comment:" + _okunanCommentBilgileriNesne.toString(),
    );
    return true;
  }

  // Future<bool> comments() async {
  //   final FirebaseFirestore _firebaseDB = FirebaseFirestore.instance;
  //   var comments = await _firebaseDB
  //       .collection('comments')
  //       .where("movieId", isEqualTo: widget.id)
  //       .get();
  //   debugPrint(comments.docs.first.toString());
  //   return true;
  // }

  TextEditingController controller = TextEditingController();

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
                      Row(
                        children: [
                          Expanded(
                            child: IconButton(
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HomeScreen(),
                                ),
                              ),
                              icon: const Icon(
                                Icons.arrow_back_outlined,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 150,
                            width: 150,
                            child: Image.network(ApplicationConstants.poster +
                                _movie!.posterPath!),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              SizedBox(
                                height: MediaQuery.of(context).size.height / 26,
                                width: MediaQuery.of(context).size.width / 1.7,
                                child: AutoSizeText(
                                  _movie!.title!,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              Text(
                                _movie!.releaseDate.toString(),
                                style: const TextStyle(color: Colors.white),
                              ),
                              Text(
                                _movie!.voteAverage.toString(),
                                style: const TextStyle(color: Colors.white),
                              ),
                              ElevatedButton(
                                  onPressed: () {}, child: Text('test'))
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height / 1.5,
                          child: StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('comments')
                                .snapshots(),
                            builder: (context,
                                AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                              return ListView.builder(
                                itemCount: streamSnapshot.data!.docs.length,
                                scrollDirection: Axis.vertical,
                                controller: ScrollController(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
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
                                            backgroundColor: Colors.transparent,
                                            radius: 20,
                                            backgroundImage: NetworkImage(
                                                _userModel.user.photoURL!),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: AutoSizeText(
                                              //BURAYI SOR
                                              "${_userModel.user.displayName} \n" +
                                                  streamSnapshot.data!
                                                      .docs[index]['content'],
                                              style: const TextStyle(
                                                  color: Colors.white60),
                                              maxLines: 2,
                                              minFontSize: 10,
                                              maxFontSize: 20,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          )),
                      TextFormField(
                        minLines: 1,
                        maxLines: 5,
                        controller: controller,
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(color: ApplicationConstants.gri),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.only(top: 14.0),
                          suffixIcon: IconButton(
                            onPressed: () {
                              addComment();
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
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
