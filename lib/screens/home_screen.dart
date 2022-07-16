import 'dart:math' as math;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:movielib/constants/app_constants.dart';
import 'package:movielib/constants/search_bar.dart';
import 'package:movielib/model/movie_genre.dart';
import 'package:movielib/model/movie_response.dart';
import 'package:movielib/screens/detail_screen.dart';
import 'package:movielib/screens/favorite_screen.dart';
import 'package:movielib/screens/profile_screen.dart';
import 'package:movielib/screens/splash_screen.dart';
import 'package:movielib/screens/watch_later_screen.dart';
import 'package:movielib/view_models/movie_view_models.dart';
import 'package:movielib/view_models/user_view_models.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController? _pageController;
  int initialPage = 10;
  bool _isInit = true;
  bool _isLoading = false;
  MovieResponse? popularMovie;
  MovieResponse? nowPlayMovie;
  GenresModel? genreModel;
  bool showNotification = true;

  changeNotification() {
    setState(() {
      showNotification = !showNotification;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _pageController!.dispose();
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 0.8,
      initialPage: initialPage,
    );
  }

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      MovieViewModel _movieViewModel = Provider.of<MovieViewModel>(context);
      popularMovie = await _movieViewModel.fetchMovieList(true);
      nowPlayMovie = await _movieViewModel.fetchMovieList(false);
      setState(() {
        _isLoading = false;
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    UserModel _userModel = Provider.of<UserModel>(context);
    return _isLoading
        ? const SplashScreen()
        : Scaffold(
            body: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              color: ApplicationConstants.lacivert,
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ProfileScreen(userData: _userModel.user),
                                ),
                              );
                            },
                            child: SizedBox(
                              height: 75,
                              width: 70,
                              child: PopupMenuButton(
                                color: ApplicationConstants.mavi,
                                icon: CircleAvatar(
                                  backgroundColor: const Color(0XFF2C3759),
                                  radius: 30,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    radius: 27,
                                    child: Container(),
                                    backgroundImage:
                                        NetworkImage(_userModel.user.photoURL!),
                                  ),
                                ),
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    value: 1,
                                    child: TextButton.icon(
                                      icon: const Icon(
                                        Icons.person,
                                        color: ApplicationConstants.mor,
                                      ),
                                      label: const Text(
                                        'Profil',
                                        style: TextStyle(color: Colors.white60),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ProfileScreen(
                                              userData: _userModel.user,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 2,
                                    child: TextButton.icon(
                                      icon: const Icon(
                                        Icons.favorite,
                                        color: ApplicationConstants.mor,
                                      ),
                                      label: const Text(
                                        'Favoriler',
                                        style: TextStyle(color: Colors.white60),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                FavoriteScreen(),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 3,
                                    child: TextButton.icon(
                                      icon: const Icon(
                                        Icons.watch_later_sharp,
                                        color: ApplicationConstants.mor,
                                      ),
                                      label: const Text(
                                        'Daha Sonra İzle',
                                        style: TextStyle(color: Colors.white60),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const WatchLaterScreen(),
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Merhaba ${_userModel.user.displayName} 👋',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 16),
                                textAlign: TextAlign.start,
                              ),
                              const Text(
                                'Favori filmlerini eklemeye başla',
                                style: TextStyle(
                                    color: Color(0XFF9A9A9A), fontSize: 12),
                              ),
                            ],
                          ),
                          showNotification
                              ? InkWell(
                                  onTap: () => changeNotification(),
                                  child: Container(
                                    height: 50,
                                    width: 50,
                                    child: const Icon(
                                      Icons.notifications_none_outlined,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: const Color(0XFF2C3759),
                                    ),
                                  ),
                                )
                              : InkWell(
                                  onTap: () => changeNotification(),
                                  child: Container(
                                    height: 50,
                                    width: 50,
                                    child: const Icon(
                                      Icons.notifications_off_outlined,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: const Color(0XFF2C3759),
                                    ),
                                  ),
                                )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const SearchBar(),
                      Container(
                        padding: const EdgeInsets.all(10),
                        alignment: Alignment.bottomLeft,
                        child: const Text(
                          'Popüler Filmler',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 1.2,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: PageView.builder(
                              onPageChanged: (value) {
                                setState(() {
                                  initialPage = value;
                                });
                              },
                              physics: const ClampingScrollPhysics(),
                              controller: _pageController,
                              itemCount: popularMovie!.results!.length,
                              itemBuilder: (context, index) {
                                var popular = popularMovie!.results![index];
                                return AnimatedBuilder(
                                  animation: _pageController!,
                                  builder:
                                      (BuildContext context, Widget? child) {
                                    double value = 0;
                                    if (_pageController!
                                        .position.haveDimensions) {
                                      value = index -
                                          _pageController!.page!.toDouble();
                                      value = (value * 0.038).clamp(-1, 1);
                                    }
                                    return AnimatedOpacity(
                                      duration:
                                          const Duration(milliseconds: 350),
                                      opacity: initialPage == index ? 1 : 0.4,
                                      child: Transform.rotate(
                                        angle: math.pi * value,
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    DetailScreen(
                                                  id: popular.id!,
                                                  title: popular.title!,
                                                  posterPath:
                                                      popular.posterPath!,
                                                  genreIDs:
                                                      popular.genreId!.toList(),
                                                  voteAverage:
                                                      popular.voteAverage!,
                                                  date: DateTime.now(),
                                                ),
                                              ),
                                            );
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15),
                                            child: Column(
                                              children: <Widget>[
                                                Expanded(
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30),
                                                      image: DecorationImage(
                                                        fit: BoxFit.fill,
                                                        image: NetworkImage(
                                                            'https://image.tmdb.org/t/p/original' +
                                                                popular
                                                                    .posterPath!),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  popular.title!,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13,
                                                    color: Colors.white,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        alignment: Alignment.bottomLeft,
                        child: const Text(
                          'Vizyonda',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        controller: ScrollController(),
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          var nowPlay = nowPlayMovie!.results![index];
                          return Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DetailScreen(
                                          id: nowPlay.id!,
                                          title: nowPlay.title!,
                                          posterPath: nowPlay.posterPath!,
                                          genreIDs: nowPlay.genreId!.toList(),
                                          voteAverage: nowPlay.voteAverage!,
                                          date: DateTime.now(),
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: 195,
                                    width: 150,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image: NetworkImage(
                                            'https://image.tmdb.org/t/p/original' +
                                                nowPlay.posterPath!),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 15),
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        SizedBox(
                                          height: 20,
                                          width: 200,
                                          child: AutoSizeText(
                                            nowPlay.title!,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                            maxFontSize: 20,
                                            minFontSize: 2,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 6,
                                        ),
                                        const SizedBox(
                                          height: 6,
                                        ),
                                        // genreModel != null
                                        //     ?
                                        Text(
                                          popularMovie!.results![index].genres
                                              .toString(),
                                          //genreModel!.getGenreTitle(movie!.results![index].genreId!),
                                          style: const TextStyle(
                                              color: Colors.white60,
                                              fontSize: 13),
                                        ),
                                        // : const Text(
                                        //     'Film türü bulunamadı',
                                        //     style: TextStyle(
                                        //         color: Colors.white),
                                        //   ),
                                        const SizedBox(
                                          height: 6,
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Image.asset(
                                              'assets/icons/star.png',
                                              height: 15,
                                            ),
                                            const SizedBox(
                                              width: 4,
                                            ),
                                            Text(
                                              '${nowPlay.voteAverage!}/10',
                                              style: const TextStyle(
                                                  color: Colors.white60,
                                                  fontSize: 11),
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 6,
                                        ),
                                        SizedBox(
                                          height: 120,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2,
                                          child: AutoSizeText(
                                            nowPlay.overView!,
                                            style: const TextStyle(
                                                color: Colors.white60),
                                            maxLines: 6,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 200,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              const SizedBox(),
                                              Text(
                                                DateFormat.yMMMMd().format(
                                                    nowPlay.releaseDate!),
                                                style: const TextStyle(
                                                    color: Colors.white30,
                                                    fontSize: 12),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                        itemCount: 10,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
