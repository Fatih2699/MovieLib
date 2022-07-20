import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:movielib/constants/app_constants.dart';
import 'package:movielib/screens/detail_screen.dart';
import 'package:movielib/screens/home_screen.dart';
import 'package:movielib/screens/search_screen.dart';
import 'package:movielib/view_models/user_view_models.dart';
import 'package:provider/provider.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  String search = "";
  @override
  Widget build(BuildContext context) {
    UserModel _user = Provider.of<UserModel>(context, listen: false);
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        color: ApplicationConstants.lacivert,
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.all(10),
                color: ApplicationConstants.lacivert,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios_rounded,
                          color: Colors.grey,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                            color: ApplicationConstants.mavi,
                            borderRadius: BorderRadius.circular(27),
                          ),
                          height: 60.0,
                          width: 330,
                          child: TextFormField(
                            onChanged: (val) {
                              setState(() {
                                search = val;
                              });
                            },
                            keyboardType: TextInputType.emailAddress,
                            style: const TextStyle(
                                color: ApplicationConstants.gri),
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.search,
                                color: Colors.white60,
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  debugPrint('Deneme');
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const SearchScreen(),
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  Icons.filter_alt,
                                  color: Colors.white60,
                                ),
                              ),
                              hintText: 'Ara...',
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.only(top: 14.0),
                              hintStyle: const TextStyle(
                                color: ApplicationConstants.gri,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                    stream: (search != "")
                        ? FirebaseFirestore.instance
                            .collection('users')
                            .where('favorite-movies', arrayContains: search)
                            .snapshots()
                        : FirebaseFirestore.instance
                            .collection('users')
                            .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        debugPrint('girdi1');
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.error != null) {
                        debugPrint('girdi2');
                        return const Center(
                          child: Text('An error has occured'),
                        );
                      }
                      return _user.user.favoriteMovies.isEmpty
                          ? Center(
                              child: RichText(
                                text: TextSpan(
                                    text: 'Henüz favori filmin bulunmuyor.',
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 16),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: ' Eklemeye Başla!',
                                        style: const TextStyle(
                                            color: ApplicationConstants.mor,
                                            fontSize: 16),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const HomeScreen(),
                                              ),
                                            );
                                          },
                                      )
                                    ]),
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                var favorites =
                                    _user.user.favoriteMovies[index];

                                showStar() {
                                  num rating = favorites['voteAverage'];
                                  if (rating >= 0 && rating <= 2) {
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset('assets/icons/star.png'),
                                        Image.asset(
                                            'assets/icons/star_gray.png'),
                                        Image.asset(
                                            'assets/icons/star_gray.png'),
                                        Image.asset(
                                            'assets/icons/star_gray.png'),
                                        Image.asset(
                                            'assets/icons/star_gray.png'),
                                      ],
                                    );
                                  } else if (rating >= 3 && rating <= 4) {
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset('assets/icons/star.png'),
                                        Image.asset('assets/icons/star.png'),
                                        Image.asset(
                                            'assets/icons/star_gray.png'),
                                        Image.asset(
                                            'assets/icons/star_gray.png'),
                                        Image.asset(
                                            'assets/icons/star_gray.png'),
                                      ],
                                    );
                                  } else if (rating >= 5 && rating <= 6) {
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset('assets/icons/star.png'),
                                        Image.asset('assets/icons/star.png'),
                                        Image.asset('assets/icons/star.png'),
                                        Image.asset(
                                            'assets/icons/star_gray.png'),
                                        Image.asset(
                                            'assets/icons/star_gray.png'),
                                      ],
                                    );
                                  } else if (rating >= 7 && rating <= 8) {
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset('assets/icons/star.png'),
                                        Image.asset('assets/icons/star.png'),
                                        Image.asset('assets/icons/star.png'),
                                        Image.asset('assets/icons/star.png'),
                                        Image.asset(
                                            'assets/icons/star_gray.png'),
                                      ],
                                    );
                                  } else {
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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

                                return Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: Slidable(
                                    endActionPane: ActionPane(
                                      motion: const ScrollMotion(),
                                      children: [
                                        SlidableAction(
                                          //BURAYI SOR
                                          onPressed:
                                              (BuildContext context) async {
                                            _user.currentUser();
                                            setState(() {
                                              _user.removeFavorite(
                                                _user.user.userId,
                                                favorites['id'],
                                                favorites['title'],
                                                favorites['posterPath'],
                                                favorites['genres'],
                                                favorites['voteAverage'],
                                              );
                                            });
                                            _user.currentUser();
                                          },
                                          backgroundColor: Colors.red,
                                          foregroundColor: Colors.white,
                                          icon: Icons.delete,
                                          label: 'Sil',
                                        ),
                                      ],
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => DetailScreen(
                                              id: favorites['id'],
                                              title: favorites['title'],
                                              posterPath:
                                                  favorites['posterPath'],
                                              genreIDs: favorites['genres'],
                                              voteAverage:
                                                  favorites['voteAverage'],
                                              date: DateTime.now(),
                                            ),
                                          ),
                                        );
                                      },
                                      child: Card(
                                        elevation: 20,
                                        color: ApplicationConstants.lacivert,
                                        child: SizedBox(
                                          height: 120,
                                          width: double.infinity,
                                          child: Row(
                                            children: <Widget>[
                                              Container(
                                                height: 120,
                                                width: 93,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  image: DecorationImage(
                                                    fit: BoxFit.fill,
                                                    image: NetworkImage(
                                                        ApplicationConstants
                                                                .poster +
                                                            favorites[
                                                                'posterPath']),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 30,
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  SizedBox(
                                                    height: 50,
                                                    width: 240,
                                                    child: AutoSizeText(
                                                      favorites['title'],
                                                      maxLines: 2,
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  Text(
                                                    favorites['genres']
                                                        .toString(),
                                                    style: const TextStyle(
                                                        color:
                                                            Color(0xFFA7A7A7),
                                                        fontSize: 14),
                                                  ),
                                                  showStar(),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              itemCount: _user.user.favoriteMovies.length,
                            );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
