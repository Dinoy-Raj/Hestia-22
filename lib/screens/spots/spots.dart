import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:hestia22/main.dart';
import 'package:hestia22/screens/spots/cards.dart';
import 'package:hestia22/screens/spots/spot_page.dart';

class Spots extends StatefulWidget {
  const Spots({Key? key, required this.data}) : super(key: key);
  final List<dynamic>? data;

  @override
  State<StatefulWidget> createState() {
    return SpotsState();
  }
}

class SpotsState extends State<Spots> {
  final TextEditingController _controller = TextEditingController();
  bool _animate = true;

  List<String> _getSuggestions(String pattern) {
    List<String> list = [];

    if (widget.data != null) {
      for (var element in widget.data!) {
        if (list.length < 4) {
          if (element['title'].toLowerCase().contains(pattern.toLowerCase())) {
            list.add("%l%" + element['title']);

            if (list.length == 4) {
              break;
            }
          }
        }

        if (list.length < 4) {
          for (var event in element['events']) {
            if (event['title'].toLowerCase().contains(pattern.toLowerCase())) {
              list.add("%e%" + event['title']);

              if (list.length == 4) {
                break;
              }
            }
          }
        }
      }

      return list;
    } else {
      return list;
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        _animate = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }

        _controller.clear();
      },
      child: Scaffold(
        backgroundColor: Constants.sc,
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 1000),
            curve: Curves.decelerate,
            opacity: _animate ? 0 : 1,
            child: Column(
              children: [
                const SizedBox(
                  height: 80,
                ),
                AnimatedPadding(
                  padding: _animate
                      ? const EdgeInsets.only(
                          left: 20,
                        )
                      : const EdgeInsets.only(left: 0),
                  duration: const Duration(milliseconds: 1000),
                  curve: Curves.decelerate,
                  child: Center(
                    child: Text(
                      "Explore",
                      style: TextStyle(
                        letterSpacing: 7,
                        color: Constants.color2.withOpacity(.75),
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                  child: AnimatedTextKit(
                    pause: const Duration(milliseconds: 300),
                    repeatForever: true,
                    animatedTexts: [
                      RotateAnimatedText(
                        "TKMCE",
                        textStyle: const TextStyle(
                          color: Constants.iconAc,
                          letterSpacing: 3,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      RotateAnimatedText(
                        "HESTIA'22",
                        textStyle: const TextStyle(
                          color: Constants.iconAc,
                          letterSpacing: 1,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      RotateAnimatedText(
                        "#SPIRIT OF TOMORROW",
                        textStyle: const TextStyle(
                          color: Constants.iconAc,
                          letterSpacing: 1,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 10,
                    bottom: 10,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Constants.color1,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: TypeAheadField(
                      textFieldConfiguration: TextFieldConfiguration(
                        controller: _controller,
                        style: const TextStyle(color: Colors.grey),
                        cursorColor: Colors.grey,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Search for an event or hotspot",
                          hintStyle: const TextStyle(
                            color: Colors.white24,
                            fontSize: 15,
                          ),
                          icon: AnimatedPadding(
                              padding: _animate
                                  ? const EdgeInsets.only(
                                      left: 10,
                                      right: 15,
                                    )
                                  : const EdgeInsets.only(
                                      left: 15,
                                      right: 0,
                                    ),
                              duration: const Duration(milliseconds: 1000),
                              child: const Icon(
                                CupertinoIcons.search,
                                color: Colors.grey,
                              )),
                        ),
                      ),
                      suggestionsCallback: (pattern) async {
                        return _getSuggestions(pattern);
                      },
                      suggestionsBoxDecoration: SuggestionsBoxDecoration(
                          color: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          )),
                      itemBuilder: (context, suggestion) {
                        return ListTile(
                          onTap: () {
                            for (var element in widget.data!) {
                              if (element['title'] ==
                                  suggestion.toString().replaceAll("%l%", "")) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            SpotPage(data: element)));
                              }

                              for (var event in element['events']) {
                                if (event['title'] ==
                                    suggestion
                                        .toString()
                                        .replaceAll("%e%", "")) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SpotPage(data: element)));
                                }
                              }
                            }
                          },
                          leading: Icon(
                            suggestion.toString().contains("%e%")
                                ? CupertinoIcons.star
                                : CupertinoIcons.location,
                            color: Constants.color2.withOpacity(.40),
                            size: 15,
                          ),
                          minLeadingWidth: 0,
                          title: Text(
                            suggestion
                                .toString()
                                .replaceAll("%l%", "")
                                .replaceAll("%e%", ""),
                            style: TextStyle(
                                color: Constants.color2.withOpacity(.40)),
                          ),
                        );
                      },
                      hideOnError: true,
                      hideOnEmpty: true,
                      hideOnLoading: true,
                      hideSuggestionsOnKeyboardHide: true,
                      onSuggestionSelected: (suggestion) {},
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                widget.data == null
                    ? const SizedBox(
                        height: 300,
                        child: Center(child: CupertinoActivityIndicator()))
                    : Cards(
                        data: widget.data!,
                      ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
