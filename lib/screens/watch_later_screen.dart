import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:movielib/constants/app_constants.dart';
import 'package:movielib/screens/detail_screen.dart';
import 'package:movielib/screens/search_screen.dart';
import 'package:movielib/services/notification_service.dart';
import 'package:movielib/view_models/user_view_models.dart';
import 'package:provider/provider.dart';

class WatchLaterScreen extends StatefulWidget {
  const WatchLaterScreen({Key? key}) : super(key: key);

  @override
  State<WatchLaterScreen> createState() => _WatchLaterScreenState();
}

class _WatchLaterScreenState extends State<WatchLaterScreen> {
  late final LocalNotificationService service;
  DateTime? date;
  TimeOfDay? time;
  @override
  void initState() {
    service = LocalNotificationService();
    service.initialize();
    listenToNotification();
    super.initState();
  }

  Future pickDate() async {
    final initialDate = DateTime.now();
    const initialTime = TimeOfDay(hour: 9, minute: 0);
    final newTime = await showTimePicker(
      context: context,
      initialTime: time ?? initialTime,
    );
    final newDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 2),
    );
    if (newDate == null) return;
    setState(() {
      date = newDate;
    });
    if (newTime == null) return;
    setState(() {
      time = newTime;
    });
    var formatterDate = DateFormat('yyyy-MM-dd');
    var formatterTime = DateFormat('HH:mm');
    String dateString = formatterDate.format(date!) +
        ' ' +
        time!.hour.toString().padLeft(2, '0') +
        ':' +
        time!.minute.toString().padLeft(2, '0');
    DateTime selected = DateTime.parse(dateString);
    DateTime now = DateTime.now();
    print(selected);
    print(now);
  }

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
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        debugPrint('girdi 1');
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.error != null) {
                        debugPrint('girdi2');
                        return const Center(
                          child: Text('An error has occured'),
                        );
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          var watchLater = _user.user.watchLaterMovies[index];
                          showStar() {
                            num rating = watchLater['voteAverage'];
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

                          return Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Slidable(
                              endActionPane: ActionPane(
                                motion: const ScrollMotion(),
                                children: [
                                  SlidableAction(
                                    onPressed: (BuildContext context) {},
                                    backgroundColor: Colors.redAccent,
                                    foregroundColor: ApplicationConstants.mor,
                                    icon: Icons.delete,
                                    label: 'Sil',
                                  ),
                                  SlidableAction(
                                    onPressed: (BuildContext context) async {
                                      //pickDate();
                                      await service.showNotification(
                                        id: 0,
                                        title: 'Film Molası 🍿',
                                        body:
                                            "${watchLater['title']} filmini izlemenin zamanı geldi. ",
                                      );
                                    },
                                    backgroundColor: Colors.green,
                                    foregroundColor: ApplicationConstants.mor,
                                    icon: Icons.timer,
                                    label: 'zamanlayıcı ayarla',
                                  )
                                ],
                              ),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailScreen(
                                        id: watchLater['id'],
                                        title: watchLater['title'],
                                        posterPath: watchLater['posterPath'],
                                        genreIDs: watchLater['genres'],
                                        voteAverage: watchLater['voteAverage'],
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
                                                  ApplicationConstants.poster +
                                                      watchLater['posterPath']),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 30,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            SizedBox(
                                              height: 50,
                                              width: 240,
                                              child: AutoSizeText(
                                                watchLater['title'],
                                                maxLines: 2,
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            const Text(
                                              'Korku , Gizem',
                                              style: TextStyle(
                                                  color: Color(0xFFA7A7A7),
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
                        itemCount: _user.user.watchLaterMovies.length,
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void listenToNotification() =>
      service.onNotificationClick.stream.listen(onNotificationListener);
  void onNotificationListener(String? payload) {
    if (payload != null && payload.isNotEmpty) {
      print('payload $payload');
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => DenemeVideo(),
      //   ),
      // );
    }
  }
}
