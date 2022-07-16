import 'package:flutter/material.dart';
import 'package:movielib/constants/app_constants.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List deneme = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
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
                            decoration: const InputDecoration(
                              prefixIcon: Icon(
                                Icons.search,
                                color: Colors.white60,
                              ),
                              hintText: 'Ara...',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(top: 14.0),
                              hintStyle: TextStyle(
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
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  buildContainer('Vizyonda', const Key('vizyonda')),
                  buildContainer('Popüler', const Key('popular')),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.all(10),
                alignment: Alignment.bottomLeft,
                child: const Text(
                  'Kategoriler',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w400),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      categoryWidget('assets/emogies/comedy.png', 'Komedi',
                          const Key('komedi')),
                      categoryWidget('assets/emogies/horror.png', 'Korku',
                          const Key('korku')),
                      categoryWidget('assets/emogies/thriller.png', 'Gerilim',
                          const Key('gerilim')),
                      categoryWidget('assets/emogies/romance.png', 'Romantik',
                          const Key('romantik')),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      categoryWidget(
                        'assets/emogies/action.png',
                        'Aksiyon',
                        const Key('aksiyon'),
                      ),
                      categoryWidget(
                        'assets/emogies/drama.png',
                        'Drama',
                        const Key('drama'),
                      ),
                      categoryWidget(
                        'assets/emogies/mystery.png',
                        'Gizem',
                        const Key('mystery'),
                      ),
                      categoryWidget(
                        'assets/emogies/fantasy.png',
                        'Fantastik',
                        const Key('fantasy'),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      categoryWidget(
                        'assets/emogies/adventure.png',
                        'Macera',
                        const Key('macera'),
                      ),
                      categoryWidget(
                        'assets/emogies/crime.png',
                        'Suç',
                        const Key('suc'),
                      ),
                      categoryWidget(
                        'assets/emogies/animation.png',
                        'Animasyon',
                        const Key('animasyon'),
                      ),
                    ],
                  )
                ],
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: ApplicationConstants.mavi,
                  elevation: 10,
                ),
                onPressed: () {},
                child: const Text('Filtrele'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InkWell buildContainer(String text, Key key) {
    Color _seciliDegilContainer = const Color(0XFF13244A);
    Color _seciliContainer = const Color(0XFF4AD0EE);
    Color _seciliText = ApplicationConstants.lacivert;
    Color _seciliDegilText = Colors.white60;
    return InkWell(
      onTap: () {
        setState(() {
          if (deneme.contains(key)) {
            deneme.remove(key);
          } else {
            deneme.add(key);
          }
        });
      },
      child: Container(
        height: 36,
        width: 106,
        decoration: BoxDecoration(
          color:
              deneme.contains(key) ? _seciliContainer : _seciliDegilContainer,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: deneme.contains(key) ? _seciliText : _seciliDegilText,
            ),
          ),
        ),
      ),
    );
  }

  Padding categoryWidget(String image, String title, Key key) {
    Color _seciliDegilContainer = const Color(0XFF13244A);
    Color _seciliContainer = const Color(0XFF4AD0EE);
    Color _seciliText = ApplicationConstants.lacivert;
    Color _seciliDegilText = Colors.white60;
    return Padding(
      padding: const EdgeInsets.all(10),
      child: InkWell(
        onTap: () {
          setState(() {
            if (deneme.contains(key)) {
              deneme.remove(key);
            } else {
              deneme.add(key);
            }
          });
        },
        child: Container(
          height: 77,
          width: 70,
          decoration: BoxDecoration(
            color:
                deneme.contains(key) ? _seciliContainer : _seciliDegilContainer,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: <Widget>[
              Image.asset(image),
              Text(
                title,
                style: TextStyle(
                  color: deneme.contains(key) ? _seciliText : _seciliDegilText,
                ),
              ),
            ],
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
        ),
      ),
    );
  }
}
