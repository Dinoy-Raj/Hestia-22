import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:slide_countdown/slide_countdown.dart';
import '../../main.dart';

class EventDetails extends StatefulWidget {
  Map eventData;
  EventDetails(this.eventData, {Key? key}) : super(key: key);
  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  static const fontfamily = 'Helvetica';
  double letterspace = 0.8;
  double contentspace = 1.2;
  bool modeLandscape = false;
  String imageUrl = "";
  Duration? duration;
  bool isReadmore = false;
  int lines = 4;
  bool start = false;
  DateTime? dateFormat;
  @override
  void initState() {
    // TODO: implement initState
    dateFormat =
        DateFormat("yyyy-mm-ddThh:mm:ss").parse(widget.eventData['reg_end']);
    DateTime endDate = DateTime.parse(dateFormat.toString());
    duration = Duration(
        days: endDate.day - DateTime.now().day,
        hours: endDate.hour - DateTime.now().hour,
        minutes: endDate.minute - DateTime.now().minute,
        seconds: endDate.second - DateTime.now().second);
    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() {
        start = true;
      });
    });
    if (widget.eventData['image'] != null) {
      imageUrl = widget.eventData['image'];
    } else {
      imageUrl =
          "https://www.hestiatkmce.live/static/media/Hestia%2022-date%20reveal.3f5f2c21ac76b6abdd0e.jpg";
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (duration!.inSeconds <= 0) {
      setState(() {});
    }
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Constants.sc,
      body: CustomScrollView(physics: const BouncingScrollPhysics(), slivers: [
        appbar(height, width),
        SliverList(
            delegate: SliverChildListDelegate([
          eventDetails(height, width),
          Divider(
            height: width * 0.03,
            endIndent: width * 0.03,
            indent: width * 0.03,
            thickness: 0.3,
            color: Constants.lightWhite,
          ),
          aboutEvent(height, width),
          widget.eventData['is_file_upload'] &&
                  widget.eventData['guideline_file'] != null
              ? guidelines(height, width)
              : const SizedBox(
                  height: 0,
                ),
          widget.eventData['coordinator_1'] != null ||
                  widget.eventData['coordinator_2'] == null
              ? contactDetails(height, width)
              : const SizedBox(
                  height: 0,
                ),
          duration!.inSeconds <= 0
              ? const Text("")
              : floatButton(height, width),
          //contactDetails(height, width)
        ]))
      ]),
    );
  }

  Widget appbar(double height, double width) {
    return SliverAppBar(
      backgroundColor: Constants.sc,
      leading: AnimatedOpacity(
        duration: const Duration(seconds: 1),
        curve: Curves.decelerate,
        opacity: start ? 1 : 0.5,
        child: AnimatedPadding(
          padding: start
              ? EdgeInsets.all(width * 0.02)
              : EdgeInsets.all(width * 0.012),
          duration: const Duration(milliseconds: 1000),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: LinearGradient(
                    colors: [
                      Constants.bg.withOpacity(.6),
                      Constants.bg.withOpacity(.6),
                    ],
                    begin: AlignmentDirectional.topStart,
                    end: AlignmentDirectional.bottomEnd,
                  ),
                ),
                child: BackButton(
                  color: Constants.color2.withOpacity(.5),
                ),
              ),
            ),
          ),
        ),
      ),
      floating: false,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30))),
      expandedHeight: height * .5,
      flexibleSpace: FlexibleSpaceBar(
        background: AnimatedOpacity(
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOutCubicEmphasized,
          opacity: start ? 1 : 0,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeOutQuad,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30)),
                image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    onError: (Object exception, StackTrace? stackTrace) {
                      setState(() {
                        imageUrl =
                            "https://www.hestiatkmce.live/static/media/Hestia%2022-date%20reveal.3f5f2c21ac76b6abdd0e.jpg";
                      });
                    },
                    fit: BoxFit.cover)),
          ),
        ),
        title: widget.eventData['reg_end'] == null
            ? const SizedBox(
                height: 0,
              )
            : duration!.inSeconds <= 0
                ? const SizedBox(
                    height: 0,
                  )
                : AnimatedOpacity(
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.decelerate,
                    opacity: start ? 1 : 0,
                    child: Container(
                      padding: EdgeInsets.only(
                          left: width * 0.1, right: width * 0.1),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                              child: Container(
                                width: width * 0.5,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  gradient: LinearGradient(
                                    colors: [
                                      Constants.bg.withOpacity(.6),
                                      Constants.bg.withOpacity(.6),
                                    ],
                                    begin: AlignmentDirectional.topStart,
                                    end: AlignmentDirectional.bottomEnd,
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: width * 0.025,
                                      right: width * 0.025,
                                      top: height * 0.015,
                                      bottom: height * 0.006),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        "Day   Hr   Min   Sec",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            letterSpacing: contentspace,
                                            color: Constants.pureWhite
                                                .withOpacity(0.7),
                                            fontSize: 14,
                                            overflow: TextOverflow.clip,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: fontfamily),
                                      ),
                                      SlideCountdownSeparated(
                                        width: width * .05,
                                        separator: " : ",
                                        separatorStyle: const TextStyle(
                                            decoration: TextDecoration.none,
                                            letterSpacing: 2,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            overflow: TextOverflow.clip,
                                            decorationStyle:
                                                TextDecorationStyle.double),
                                        showZeroValue: true,
                                        textStyle: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w200,
                                          decoration: TextDecoration.none,
                                          decorationColor:
                                              Constants.transparent,
                                          overflow: TextOverflow.clip,
                                          color: Constants.pureWhite
                                              .withOpacity(0.9),
                                          fontFamily: fontfamily,
                                        ),
                                        decoration: const BoxDecoration(
                                            color: Constants.transparent),
                                        slideDirection: SlideDirection.down,
                                        duration: duration == null
                                            ? const Duration(
                                                seconds: 0,
                                                minutes: 0,
                                                hours: 0,
                                                days: 0)
                                            : duration!,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
        centerTitle: true,
      ),
    );
  }

  Widget eventDetails(double height, double width) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 500),
      curve: Curves.decelerate,
      opacity: start ? 1 : 0.5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(
                width * 0.03, width * 0.04, width * 0.03, 0),
            child: Stack(
              children: [
                AnimatedOpacity(
                  duration: const Duration(seconds: 1),
                  curve: Curves.slowMiddle,
                  opacity: start ? 1 : 0.3,
                  child: Container(
                    height: width * 0.35,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: width * 0.65,
                              child: Text(
                                widget.eventData['title'],
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: TextStyle(
                                  fontFamily: fontfamily,
                                  letterSpacing: letterspace,
                                  height: 1.2,
                                  fontSize: 28,
                                  color: Constants.pureWhite.withOpacity(1),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        widget.eventData['venue']['title'] != null
                            ? AnimatedOpacity(
                                duration: const Duration(seconds: 1),
                                curve: Curves.slowMiddle,
                                opacity: start ? 1 : 0.3,
                                child: Padding(
                                  padding: EdgeInsets.only(top: width * 0.06),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        FontAwesomeIcons.locationDot,
                                        color: Constants.lightWhite
                                            .withOpacity(0.4),
                                        size: 15,
                                      ),
                                      Text(
                                        "  " +
                                            widget.eventData['venue']['title']
                                                .toString()
                                                .toUpperCase(),
                                        style: TextStyle(
                                          letterSpacing: letterspace,
                                          decoration: TextDecoration.none,
                                          fontSize: 15,
                                          fontFamily: fontfamily,
                                          overflow: TextOverflow.clip,
                                          color: Constants.textColor
                                              .withOpacity(0.8),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            : const SizedBox(
                                height: 0,
                              ),
                      ],
                    ),
                  ),
                ),
                widget.eventData["prize"] == null &&
                        widget.eventData['reg_end'] != null
                    ? const SizedBox(
                        height: 0,
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          AnimatedOpacity(
                            duration: const Duration(seconds: 1),
                            curve: Curves.linear,
                            opacity: start ? 1 : 0.3,
                            child: Container(
                              width: width * 0.28,
                              color: Colors.transparent,
                              child: Stack(
                                children: [
                                  Container(
                                    width: width * 0.28,
                                    height: width * 0.20,
                                    padding: EdgeInsets.only(
                                        top: width * 0.03,
                                        left: width * 0.01,
                                        right: width * 0.01),
                                    decoration: const BoxDecoration(
                                      color: Constants.iconAc,
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(10),
                                          topLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10),
                                          bottomLeft: Radius.circular(10)),
                                    ),
                                    child: Text(
                                      "MAY " + dateFormat!.day.toString(),
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          letterSpacing: contentspace,
                                          overflow: TextOverflow.clip,
                                          color: Constants.textColor.shade100,
                                          fontFamily: fontfamily,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 18),
                                    ),
                                  ),
                                  Container(
                                    width: width * 0.28,
                                    height: width * 0.2,
                                    margin: EdgeInsets.only(top: width * .12),
                                    padding: EdgeInsets.only(
                                        top: width * 0.035,
                                        bottom: width * 0.02,
                                        right: width * 0.04,
                                        left: width * 0.04),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[900],
                                      borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                          topLeft: Radius.circular(10)),
                                    ),
                                    child: Center(
                                        child: widget.eventData['prize'] == null
                                            ? Text(
                                                "0 K",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    letterSpacing: contentspace,
                                                    overflow: TextOverflow.clip,
                                                    color: Constants
                                                        .textColor.shade100,
                                                    fontFamily: fontfamily,
                                                    fontSize: 16),
                                              )
                                            : Text(
                                                (widget.eventData["prize"] /
                                                            1000)
                                                        .toString() +
                                                    " K",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    letterSpacing: contentspace,
                                                    overflow: TextOverflow.clip,
                                                    color: Constants
                                                        .textColor.shade100,
                                                    fontFamily: fontfamily,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20),
                                              )),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          ),
          const Text(""),

          /*Container(
              padding: EdgeInsets.fromLTRB(
                  width * 0.06, width * 0.04, width * 0.06, width * 0.01),

              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
              ),
              child: MaterialButton(
                elevation: 4,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                onPressed: () {},
                color: Constants.iconAc,
                child: Row(
                  children: [
                    Icon(
                      FontAwesomeIcons.ticket,
                      size: 20,
                      color: Constants.pureWhite,
                    ),
                    Text(
                      "  " + eventData["prize"],
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          letterSpacing: contentspace,
                          overflow: TextOverflow.clip,
                          color: Constants.lightWhite,
                          fontFamily: fontfamily,
                          fontSize: 16),
                    ),
                  ],
                ),
              )),
              dateFormat != null
              ? AnimatedPadding(
                  duration: const Duration(seconds: 1),
                  curve: Curves.decelerate,
                  padding: start
                      ? EdgeInsets.fromLTRB(width * 0.06, 0, 0, 0)
                      : const EdgeInsets.only(left: 0),
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.schedule,
                          color: Constants.lightWhite.withOpacity(0.4),
                        ),
                        Text(
                          "   " +
                              dateFormat!.day.toString() +
                              ' / ' +
                              dateFormat!.month.toString() +
                              ' / ' +
                              dateFormat!.year.toString() +
                              "     ",
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                            letterSpacing: letterspace,
                            decoration: TextDecoration.none,
                            fontSize: 16,
                            fontStyle: FontStyle.normal,
                            fontFamily: fontfamily,
                            color: Constants.textColor.shade50,
                            overflow: TextOverflow.clip,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : const SizedBox(
                  height: 0,
                ),
          Container(
            padding: EdgeInsets.fromLTRB(
                width * 0.06, width * 0.02, width * 0.06, width * 0.01),
            child: Row(
              children: [
                Icon(
                  FontAwesomeIcons.ticket,
                  size: 20,
                  color: Constants.lightWhite.withOpacity(0.4),
                ),
                Text(
                  "   " +
                      eventData['registrationfee'] +
                      " Reg. Fee /  " +
                      eventData['prize'] +
                      " Prize",
                  style: TextStyle(
                    letterSpacing: letterspace,
                    decoration: TextDecoration.none,
                    fontSize: 16,
                    fontFamily: fontfamily,
                    overflow: TextOverflow.clip,
                    color: Constants.textColor,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          const Text(""),
          widget.eventData['venue']['title'] != null
              ? AnimatedPadding(
                  duration: const Duration(seconds: 1),
                  curve: Curves.decelerate,
                  padding: start
                      ? EdgeInsets.fromLTRB(width * 0.06, 0, 0, 0)
                      : const EdgeInsets.only(left: 0),
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          color: Constants.lightWhite.withOpacity(0.4),
                          size: 24,
                        ),
                        Text(
                          "   " +
                              widget.eventData['venue']['title']
                                  .toString()
                                  .toUpperCase(),
                          style: TextStyle(
                            letterSpacing: letterspace,
                            decoration: TextDecoration.none,
                            fontSize: 16,
                            fontFamily: fontfamily,
                            overflow: TextOverflow.clip,
                            color: Constants.textColor.shade50,
                            fontWeight: FontWeight.normal,
                          ),
                        )
                      ],
                    ),
                  ),
                )
              : const SizedBox(
                  height: 0,
                ),
          Container(
            padding: EdgeInsets.fromLTRB(
                width * 0.04, width * 0.02, width * 0.04, width * 0.01),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Icon(
                  Icons.currency_rupee_outlined,
                  color: AppColors.pureWhite,
                ),
                Text(
                  '  Prize : ' + eventData['prize'],
                  style: const TextStyle(
                    decoration: TextDecoration.none,
                    fontSize: 18,
                    fontFamily: 'Helvetica',
                    color: AppColors.pureWhite,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),*/
        ],
      ),
    );
  }

  Widget aboutEvent(double height, double width) {
    final lines = isReadmore ? null : 4;
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 500),
      curve: Curves.decelerate,
      opacity: start ? 1 : 0.5,
      child: AnimatedPadding(
        duration: const Duration(seconds: 1),
        curve: Curves.decelerate,
        padding: start
            ? EdgeInsets.fromLTRB(width * 0.03, 0, width * 0.03, 0)
            : const EdgeInsets.only(left: 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(""),
            Text(
              'About Event',
              style: TextStyle(
                decoration: TextDecoration.none,
                fontSize: 18,
                letterSpacing: 0.8,
                fontFamily: fontfamily,
                overflow: TextOverflow.clip,
                color: Constants.pureWhite.withOpacity(0.75),
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(""),
            Text(
              widget.eventData['desc'],
              overflow:
                  isReadmore ? TextOverflow.visible : TextOverflow.ellipsis,
              maxLines: lines,
              style: const TextStyle(
                overflow: TextOverflow.clip,
                fontSize: 16,
                height: 1.5,
                fontFamily: fontfamily,
                color: Constants.textColor,
                inherit: true,
                letterSpacing: 0.9,
                wordSpacing: 1.2,
              ),
            ),
            MaterialButton(
              padding: const EdgeInsets.all(0),
              animationDuration: const Duration(seconds: 0),
              onPressed: () {
                setState(() {
                  // toggle the bool variable true or false
                  isReadmore = !isReadmore;
                });
              },
              child: Row(
                children: [
                  Text(
                    (isReadmore ? 'Read Less\n' : 'Read More\n'),
                    overflow: TextOverflow.clip,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      overflow: TextOverflow.clip,
                      fontSize: 14,
                      fontFamily: fontfamily,
                      color: Constants.lightWhite.withOpacity(0.3),
                      inherit: true,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  const Text(""),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget guidelines(double height, double width) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 100),
      curve: Curves.decelerate,
      opacity: start ? 1 : 0.5,
      child: AnimatedPadding(
        duration: const Duration(milliseconds: 500),
        curve: Curves.decelerate,
        padding: start
            ? EdgeInsets.fromLTRB(width * 0.03, 0, width * 0.03, 0)
            : const EdgeInsets.only(left: 0),
        child: MaterialButton(
            color: Colors.grey[900],
            onPressed: () async {
              String url = widget.eventData['guideline_file'];
              final _url = Uri.parse(url);
              if (url != null && url.isNotEmpty) {
                if (await launchUrl(_url,
                    mode: LaunchMode.externalApplication)) {
                } else {
                  throw 'Could not launch $url';
                }
              }
            },
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                side: BorderSide(color: Colors.white10)),
            child: Center(
              child: Text(
                "View Guidelines",
                style: TextStyle(
                  letterSpacing: letterspace,
                  decoration: TextDecoration.none,
                  fontSize: 16,
                  fontFamily: fontfamily,
                  overflow: TextOverflow.clip,
                  color: Constants.textColor,
                  fontWeight: FontWeight.normal,
                ),
              ),
            )),
      ),
    );
  }

  Widget contactDetails(double height, double width) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 100),
      curve: Curves.decelerate,
      opacity: start ? 1 : 0.5,
      child: AnimatedPadding(
        duration: const Duration(milliseconds: 500),
        curve: Curves.decelerate,
        padding: start
            ? EdgeInsets.fromLTRB(width * 0.03, 0, width * 0.03, 0)
            : const EdgeInsets.only(left: 0),
        child: Column(
          children: [
            widget.eventData['coordinator_1'] != null
                ? Row(
                    children: [
                      /*widget.eventData['coordinator_1']['name'] == null
                    ? const SizedBox(
                        height: 0,
                      )
                    : */
                      Container(
                        width: width * 0.32,
                        child: Text(
                          widget.eventData['coordinator_1'] != null
                              ? widget.eventData['coordinator_1']['name']
                                  .toString()
                              : "No Name",
                          style: TextStyle(
                            letterSpacing: letterspace,
                            fontSize: 16,
                            fontFamily: fontfamily,
                            overflow: TextOverflow.ellipsis,
                            color: Constants.textColor,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                      /*widget.eventData['coordinator_1']['phone_number'] == null
                    ? const SizedBox(
                        height: 0,
                      )
                    : */
                      MaterialButton(
                        onPressed: () async {
                          if (widget.eventData['coordinator_1'] != null) {
                            if (await canLaunchUrl(Uri(
                                scheme: 'tel',
                                path: widget.eventData['coordinator_1']
                                    ['phone_number']))) {
                              await launchUrl(Uri(
                                  scheme: 'tel',
                                  path: widget.eventData['coordinator_1']
                                      ['phone_number']));
                            }
                          }
                        },
                        child: const Icon(
                          FontAwesomeIcons.phoneFlip,
                          size: 17,
                          color: Colors.green,
                        ),
                      )
                    ],
                  )
                : const SizedBox(
                    height: 0,
                  ),
            widget.eventData['coordinator_2'] != null
                ? Row(
                    children: [
                      // widget.eventData['coordinator_2']['name'] == null
                      //     ? const SizedBox(
                      //         height: 0,
                      //       )
                      //     :
                      Container(
                        width: width * 0.32,
                        child: Text(
                          widget.eventData['coordinator_2'] != null
                              ? widget.eventData['coordinator_2']['name']
                                  .toString()
                              : "No Name",
                          style: TextStyle(
                            letterSpacing: letterspace,
                            fontSize: 16,
                            fontFamily: fontfamily,
                            overflow: TextOverflow.ellipsis,
                            color: Constants.textColor,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                      MaterialButton(
                        onPressed: () async {
                          if (widget.eventData['coordinator_1'] != null) {
                            if (await canLaunchUrl(Uri(
                                scheme: 'tel',
                                path: widget.eventData['coordinator_2']
                                    ['phone_number']))) {
                              await launchUrl(Uri(
                                  scheme: 'tel',
                                  path: widget.eventData['coordinator_2']
                                      ['phone_number']));
                            }
                          }
                        },
                        child: const Icon(
                          FontAwesomeIcons.phoneFlip,
                          size: 17,
                          color: Colors.green,
                        ),
                      )
                    ],
                  )
                : const SizedBox(
                    height: 0,
                  ),
          ],
        ),
      ),
    );
  }

  Widget floatButton(double height, double width) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 100),
      curve: Curves.decelerate,
      opacity: start ? 1 : 0.5,
      child: Container(
        height: width * 0.18,
        padding: EdgeInsets.fromLTRB(
            width * .03, width * .03, width * .03, width * .03),
        child: MaterialButton(
          autofocus: true,
          highlightColor: Colors.grey[900],
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          padding: EdgeInsets.fromLTRB(
              width * .0, width * .03, width * .03, width * .03),
          onPressed: () async {
            Uri _url = Uri.parse("https://www.hestiatkmce.live/events/" +
                widget.eventData['event_category'] +
                "/" +
                widget.eventData['slug']);
            print("https://www.hestiatkmce.live/events/" +
                widget.eventData['event_category'] +
                "/" +
                widget.eventData['slug']);
            if (await launchUrl(_url, mode: LaunchMode.externalApplication)) {}
          },
          color: Constants.iconAc,
          child: Text(
            "Book Now",
            style: TextStyle(
              letterSpacing: contentspace,
              overflow: TextOverflow.ellipsis,
              color: Constants.pureWhite,
              fontFamily: fontfamily,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}
