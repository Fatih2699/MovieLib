import 'dart:async';

import 'package:flutter/material.dart';
import 'package:movielib/constants/app_constants.dart';
import 'package:movielib/model/movie_response.dart';
import 'package:movielib/screens/detail_screen.dart';
import 'package:movielib/view_models/movie_view_models.dart';
import 'package:provider/provider.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final TextEditingController _controller = TextEditingController();
  MovieResponse? movie;
  int counter = 0;
  bool _isLoading = false;
  changeLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  search(String? query) async {
    changeLoading();
    MovieViewModel _movieViewModel =
        Provider.of<MovieViewModel>(context, listen: false);
    movie = await _movieViewModel.searchMovie(query!);
    counter = movie!.results!.length;
    changeLoading();
    return movie;
  }

  void clearResults() {
    setState(() {
      counter = 0;
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    Timer? timer;
    return Column(
      children: [
        Center(
          child: Container(
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: ApplicationConstants.mavi,
              borderRadius: BorderRadius.circular(27),
            ),
            height: 60.0,
            width: 330,
            child: TextFormField(
              controller: _controller,
              onChanged: (v) {
                timer?.cancel();
                timer = Timer(
                  const Duration(seconds: 1),
                  () {
                    search(_controller.text);
                  },
                );
              },
              keyboardType: TextInputType.text,
              style: const TextStyle(color: ApplicationConstants.gri),
              decoration: InputDecoration(
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.white60,
                ),
                suffixIcon: InkWell(
                  child: const Icon(
                    Icons.clear,
                    color: Colors.white60,
                  ),
                  onTap: () => clearResults(),
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
        ),
        _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.only(top: 5, left: 40, right: 40),
                child: SizedBox(
                  height: counter > 0 ? 150 : 0,
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      var search = movie!.results![index];
                      return Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: ApplicationConstants.mavi,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                leading: Image.network(
                                  ApplicationConstants.poster +
                                      search.posterPath!,
                                ),
                                title: Text(
                                  search.title!,
                                  style: const TextStyle(
                                    color: Colors.white60,
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailScreen(
                                          id: search.id!,
                                          title: search.title!,
                                          posterPath: search.posterPath!,
                                          genreIDs: search.genreId!,
                                          voteAverage: search.voteAverage!,
                                          date: search.releaseDate!),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          )
                        ],
                      );
                    },
                    itemCount: counter,
                  ),
                ),
              )
      ],
    );
  }
}
