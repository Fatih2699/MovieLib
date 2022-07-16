import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:movielib/constants/app_constants.dart';
import 'package:movielib/model/movie_actor.dart';
import 'package:movielib/model/movie_model.dart';
import 'package:movielib/model/movie_trailer_model.dart';
import 'package:movielib/screens/favorite_screen.dart';
import 'package:movielib/screens/splash_screen.dart';
import 'package:movielib/screens/watch_later_screen.dart';
import 'package:movielib/view_models/movie_view_models.dart';
import 'package:movielib/view_models/user_view_models.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class DetailScreen extends StatefulWidget {
  int id;
  List genreIDs;
  String title;
  String posterPath;
  num voteAverage;
  DateTime date;
  DetailScreen({
    Key? key,
    required this.id,
    required this.title,
    required this.posterPath,
    required this.genreIDs,
    required this.voteAverage,
    required this.date,
  }) : super(key: key);

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool _isInit = true;
  bool _isLoading = false;
  Movie? movie;
  TrailersModel? trailer;
  ActorsModel? actor;
  String date = "";
  late UserModel _userModel;
  bool isFavorite = false;
  bool isWatchLater = false;
  _showDialog() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: ApplicationConstants.lacivert,
            scrollable: true,
            actions: <Widget>[
              SizedBox(
                height:
                    MediaQuery.of(context).orientation == Orientation.landscape
                        ? MediaQuery.of(context).size.height * 0.7
                        : null,
                child: YoutubePlayer(
                  controller: YoutubePlayerController(
                    initialVideoId: trailer!.results[0].key,
                    flags: const YoutubePlayerFlags(
                      autoPlay: true,
                      mute: false,
                    ),
                  ),
                  showVideoProgressIndicator: true,
                  progressIndicatorColor: Colors.red,
                ),
              ),
            ],
          );
        });
  }

  @override
  Future<void> didChangeDependencies() async {
    if (_isInit) {
      debugPrint('init oldu');
      setState(() {
        _isLoading = true;
      });
      MovieViewModel _movieViewModel = Provider.of<MovieViewModel>(context);
      _userModel = Provider.of<UserModel>(context, listen: false);
      await _userModel.currentUser();
      if (_userModel.user.favoriteMovies.contains(widget.id)) {
        isFavorite = true;
      }
      if (_userModel.user.watchLaterMovies.contains(widget.id)) {
        isWatchLater = true;
      }
      movie = await _movieViewModel.fetchMovie(widget.id);
      trailer = await _movieViewModel.fetchMovieTrailers(widget.id);
      actor = await _movieViewModel.fetchActors(widget.id);
      date = DateFormat.y().format(movie!.releaseDate!);
      setState(() {
        _isLoading = false;
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  changeFavorite() {
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  changeWatchLater() {
    setState(() {
      isWatchLater = !isWatchLater;
    });
  }

  _addFavorite() {
    try {
      _userModel.addMovieFavorite(_userModel.user.userId, widget.id,
          widget.title, widget.posterPath, widget.genreIDs, widget.voteAverage);
      changeFavorite();
      _userModel.currentUser();
      return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 1),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Text('Favoriler Eklendi'),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FavoriteScreen(),
                    ),
                  );
                },
                child: const Text('Favorilere Git'),
              )
            ],
          ),
        ),
      );
    } catch (e) {
      debugPrint('HATA VAR _addFav ${e.toString()}');
    }
  }

  _removeFavorite() {
    try {
      _userModel.removeFavorite(_userModel.user.userId, widget.id, widget.title,
          widget.posterPath, widget.genreIDs, widget.voteAverage);
      changeFavorite();
      _userModel.currentUser();
      return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 1),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Text('Favorilerden kaldırıldı.'),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FavoriteScreen(),
                    ),
                  );
                },
                child: const Text('Favorilere Git'),
              )
            ],
          ),
        ),
      );
    } catch (e) {
      debugPrint('HATA VAR _addFav ${e.toString()}');
    }
  }

  _addWatchLater() {
    try {
      _userModel.addWatchLater(
        _userModel.user.userId,
        widget.id,
        widget.title,
        widget.posterPath,
        widget.genreIDs,
        widget.voteAverage,
        widget.date,
      );
      changeWatchLater();
      _userModel.currentUser();
      return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 1),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Text('Daha Sonra İzleye eklendi'),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WatchLaterScreen(),
                    ),
                  );
                },
                child: const Text('Listeye git'),
              )
            ],
          ),
        ),
      );
    } catch (e) {
      debugPrint('HATA VAR _addWatchLater ${e.toString()}');
    }
  }

  _removeWatchLater() {
    try {
      _userModel.removeWatchLater(
          _userModel.user.userId,
          widget.id,
          widget.title,
          widget.posterPath,
          widget.genreIDs,
          widget.voteAverage,
          widget.date);
      changeWatchLater();
      _userModel.currentUser();
      return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 1),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Text('Daha Sonra İzleden kaldırıldı.'),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WatchLaterScreen(),
                    ),
                  );
                },
                child: const Text('Listeye git'),
              )
            ],
          ),
        ),
      );
    } catch (e) {
      debugPrint('HATA VAR _removeWatchLater ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    showStar() {
      num rating = movie!.voteAverage!;
      if (rating >= 0 && rating <= 2) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/icons/star.png'),
            Image.asset('assets/icons/star_gray.png'),
            Image.asset('assets/icons/star_gray.png'),
            Image.asset('assets/icons/star_gray.png'),
            Image.asset('assets/icons/star_gray.png'),
          ],
        );
      } else if (rating >= 3 && rating <= 4) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/icons/star.png'),
            Image.asset('assets/icons/star.png'),
            Image.asset('assets/icons/star_gray.png'),
            Image.asset('assets/icons/star_gray.png'),
            Image.asset('assets/icons/star_gray.png'),
          ],
        );
      } else if (rating >= 5 && rating <= 6) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/icons/star.png'),
            Image.asset('assets/icons/star.png'),
            Image.asset('assets/icons/star.png'),
            Image.asset('assets/icons/star_gray.png'),
            Image.asset('assets/icons/star_gray.png'),
          ],
        );
      } else if (rating >= 7 && rating <= 8) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/icons/star.png'),
            Image.asset('assets/icons/star.png'),
            Image.asset('assets/icons/star.png'),
            Image.asset('assets/icons/star.png'),
            Image.asset('assets/icons/star_gray.png'),
          ],
        );
      } else {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/icons/star.png'),
            Image.asset('assets/icons/star.png'),
            Image.asset('assets/icons/star.png'),
            Image.asset('assets/icons/star.png'),
            Image.asset('assets/icons/star.png'),
          ],
        );
      }
    }

    return Scaffold(
      body: _isLoading
          ? const SplashScreen()
          : Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              color: ApplicationConstants.lacivert,
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          AutoSizeText(
                            movie!.title!,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                            maxFontSize: 20,
                            minFontSize: 1,
                            overflow: TextOverflow.ellipsis,
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 356,
                        width: 279,
                        child: Stack(
                          children: <Widget>[
                            Stack(
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(22.25),
                                    image: DecorationImage(
                                      // colorFilter: ColorFilter.mode(
                                      //   Colors.black.withOpacity(0.5),
                                      //   BlendMode.softLight,
                                      // ),
                                      fit: BoxFit.fill,
                                      image: NetworkImage(
                                          ApplicationConstants.poster +
                                              movie!.posterPath!),
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(22.25),
                                    color: Colors.white,
                                    gradient: LinearGradient(
                                      begin: FractionalOffset.topCenter,
                                      end: FractionalOffset.bottomCenter,
                                      colors: [
                                        Colors.grey.withOpacity(0.1),
                                        Colors.black,
                                      ],
                                      stops: const [0.0, 10.0],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Align(
                                  alignment: Alignment.topRight,
                                  child: IconButton(
                                    icon: isFavorite
                                        ? const Icon(
                                            Icons.favorite,
                                            color: Colors.red,
                                          )
                                        : const Icon(
                                            Icons.favorite_outline,
                                            color: Colors.red,
                                          ),
                                    onPressed: () {
                                      if (isFavorite == false) {
                                        _addFavorite();
                                      } else {
                                        _removeFavorite();
                                      }
                                    },
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        'daha sonra izle',
                                        style: TextStyle(
                                            color: ApplicationConstants.mor
                                                .withOpacity(0.5),
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      IconButton(
                                        icon: isWatchLater
                                            ? const Icon(
                                                Icons.watch_later,
                                                color: ApplicationConstants.mor,
                                              )
                                            : const Icon(
                                                Icons.watch_later_outlined,
                                                color: ApplicationConstants.mor,
                                              ),
                                        onPressed: () {
                                          if (isWatchLater == false) {
                                            _addWatchLater();
                                          } else {
                                            _removeWatchLater();
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      AutoSizeText(
                        movie!.title!,
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                        maxFontSize: 24,
                        minFontSize: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      showStar(),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        '$date • Aksiyon , Romantik • 2h 46m',
                        style: const TextStyle(
                            color: Color(0XFF9A9A9A), fontSize: 12),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset('assets/icons/director.png'),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            actor!.crew[0]
                                .name, //BURAYI SOR YÖNETMEN INDEXLERİ FARKLI
                            style: const TextStyle(
                                color: Color(0XFF9A9A9A), fontSize: 14),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 20, left: 10),
                              child: Text(
                                'Film Özeti',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: ElevatedButton(
                                onPressed: () async {
                                  _showDialog();
                                  // debugPrint(
                                  //     'https://www.youtube.com/watch?v=' +
                                  //         trailer!.results[0].key);
                                  // try {
                                  //   await launchUrl(Uri.parse(
                                  //       'https://www.youtube.com/watch?v=' +
                                  //           trailer!.results[0].key));
                                  // } catch (e) {
                                  //   debugPrint("HATA: " + e.toString());
                                  // }
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: const <Widget>[
                                    Text(
                                      'Fragmanı İzle',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                    ),
                                    Icon(Icons.play_circle_outline),
                                  ],
                                ),
                                style: ElevatedButton.styleFrom(
                                  primary: ApplicationConstants.mavi,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Card(
                          color: ApplicationConstants.mavi,
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                movie!.overView!,
                                style: const TextStyle(
                                  color: Colors.white60,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(20),
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            '    Oyuncular',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 140,
                        width: double.infinity,
                        child: ListView.builder(
                          shrinkWrap: true,
                          controller: ScrollController(),
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            //debugPrint(actor!.crew[index].name);
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              child: Row(
                                children: <Widget>[
                                  Column(
                                    children: [
                                      SizedBox(
                                        height: 80,
                                        width: 70,
                                        child: CircleAvatar(
                                          backgroundColor: Colors.transparent,
                                          radius: 27,
                                          child: Container(),
                                          backgroundImage: NetworkImage(actor!
                                              .cast[index].getProfilePath),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 70,
                                        child: AutoSizeText(
                                          actor!.cast[index].name,
                                          style: const TextStyle(
                                              color: Colors.white),
                                          maxLines: 2,
                                          textAlign: TextAlign.center,
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                          itemCount: actor!.cast.length,
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
