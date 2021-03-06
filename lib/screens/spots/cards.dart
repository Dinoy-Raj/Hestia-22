import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hestia22/main.dart';
import 'package:hestia22/screens/spots/spot_page.dart';

class Cards extends StatefulWidget {
  final List<dynamic> data;

  const Cards({Key? key, required this.data}) : super(key: key);

  @override
  _CardsState createState() => _CardsState();
}

class _CardsState extends State<Cards> {
  final _pageController = PageController(
    viewportFraction: 0.75,
    initialPage: 0,
  );
  bool _animate = true;
  int _currentPage = 0;
  double _scroll = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _scroll = _pageController.page!;
        _currentPage = _pageController.page!.round();
      });
    });
    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        _animate = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 20,
      ),
      child: SizedBox(
        height: 360,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 300),
              firstChild: Padding(
                padding: const EdgeInsets.only(
                  left: 15,
                  top: 30,
                  bottom: 30,
                ),
                child: RotatedBox(
                  quarterTurns: -1,
                  child: AnimatedPadding(
                    padding: _animate
                        ? const EdgeInsets.only(
                            top: 0,
                          )
                        : const EdgeInsets.only(
                            top: 10,
                          ),
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.decelerate,
                    child: const Text(
                      "The Hotspots",
                      style: TextStyle(
                        letterSpacing: 5,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white24,
                      ),
                    ),
                  ),
                ),
              ),
              secondChild: const SizedBox(
                height: 0,
              ),
              crossFadeState: _scroll <= 0.2
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                physics: const BouncingScrollPhysics(),
                itemCount: widget.data.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Hero(
                    tag: widget.data[index]['title'].toString(),
                    child: Material(
                      color: Colors.transparent,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SpotPage(
                                        data: widget.data[index],
                                      )));
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: _currentPage == index
                              ? EdgeInsets.zero
                              : const EdgeInsets.all(30),
                          decoration: BoxDecoration(
                            color: Constants.iconAc.withOpacity(.01),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: AnimatedOpacity(
                                  duration: const Duration(milliseconds: 800),
                                  opacity: _animate ? 0 : 0.5,
                                  child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    height: double.infinity,
                                    imageUrl: widget.data[index]['picture'] ??
                                        "https://www.hestiatkmce.live/static/media/Hestia%2022-date%20reveal.3f5f2c21ac76b6abdd0e.jpg",
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      index + 1 < 10
                                          ? "0" + (index + 1).toString()
                                          : (index + 1).toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          fontSize: 30,
                                          color:
                                              Constants.color2.withOpacity(.5)),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.data[index]['title']
                                              .toString(),
                                          style: TextStyle(
                                              overflow: TextOverflow.clip,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                              color: Constants.color2
                                                  .withOpacity(.75)),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          widget.data[index]['short_desc']
                                              .toString(),
                                          style: TextStyle(
                                              overflow: TextOverflow.clip,
                                              fontSize: 14,
                                              color: Constants.color2
                                                  .withOpacity(.6)),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          widget.data[index]['desc'].toString(),
                                          style: TextStyle(
                                              overflow: TextOverflow.clip,
                                              fontSize: 12,
                                              color: Constants.color2
                                                  .withOpacity(.4)),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
