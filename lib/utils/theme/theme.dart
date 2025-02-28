// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';

/// APP THEME
final ThemeData appTheme = ThemeData(
  appBarTheme: const AppBarTheme(
    centerTitle: false,
    backgroundColor: Colors.white,
    elevation: 0.0,
    titleTextStyle: TextStyle(
      color: textColor,
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
    ),
    iconTheme: IconThemeData(color: textColor),
  ),
  tabBarTheme: const TabBarTheme(
    labelColor: Colors.black,
    unselectedLabelColor: Colors.grey,
    // indicatorSize: TabBarIndicatorSize.label,
  ),
  hintColor: hintColor,
  fontFamily: 'NunitoSans',
  inputDecorationTheme: const InputDecorationTheme(),
  elevatedButtonTheme: elevatedButtonThemeData,
  outlinedButtonTheme: outlinedButtonThemeData,
  textTheme: const TextTheme(
    bodyLarge: bodyText1,
    bodyMedium: bodyText2,
    titleLarge: headline6,
  ),
  colorScheme: ColorScheme.fromSwatch(primarySwatch: primarySwatch)
      .copyWith(background: backgroundColor),
);
const double radius = 10.0;
const double buttonHeight = 57.0;
const double fieldHeight = 55.0;
const double radiusValue = 10.0;
const Color backgroundColor = Color(0xffF4F4F4);
const Color appBarColor = Color(0xffFAFAFA);
const double buttonRadius = 30.0;
const Color iconColor = Color(0xffA9A9A9);
const Color textColor = Color(0xff383838);
const Color hintColor = Color(0xff8A8A8A);
const Color subtextColor = Color(0xff707070);
const Color backgroundcolorinterface = Color(0xfff4f4f4);
const int hex = 0xffF21C29;

const Color primaryColorLT = Color(hex);
const Color primaryotherColorLT = Color(0xffF7C844);
const Color proprimaryColor = Color(hex);
const Color probackgroundColor = Color(0xfff4f4f4);
const Color prosemibackColor = Color(0xfff4f4f4);

// ignore: always_specify_types
const MaterialColor primarySwatch = MaterialColor(hex, {
  50: Color(hex),
  100: Color(hex),
  200: Color(hex),
  300: Color(hex),
  400: Color(hex),
  500: Color(hex),
  600: Color(hex),
  700: Color(hex),
  800: Color(hex),
  900: Color(hex),
});
const TextStyle headline6 = TextStyle(
  color: textColor,
  fontWeight: FontWeight.w400,
  fontSize: 20.0,
);
const TextStyle bodyText1 = TextStyle(
  color: textColor,
  fontWeight: FontWeight.bold,
  fontSize: 14.0,
);
const TextStyle bodyText2 = TextStyle(
  color: textColor,
  fontWeight: FontWeight.normal,
  fontSize: 12.0,
);
final InputDecoration inputDecoration = InputDecoration(
  hintStyle: bodyText2.copyWith(color: hintColor),
  contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 18.0),
  fillColor: Colors.white,
  filled: true,
  border: const OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(10.0),
    ),
    borderSide: BorderSide(
      width: 0,
      style: BorderStyle.none,
    ),
  ),
);
final InputDecoration messageBoxDecoration = InputDecoration(
  hintStyle: bodyText2.copyWith(
    color: textColor.withOpacity(0.6),
  ),
  contentPadding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
  fillColor: hintColor,
  filled: true,
  border: const OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(40.0),
    ),
    borderSide: BorderSide(
      width: 0,
      style: BorderStyle.none,
    ),
  ),
);

final OutlinedButtonThemeData outlinedButtonThemeData = OutlinedButtonThemeData(
  style: OutlinedButton.styleFrom(
    side: const BorderSide(
      color: primaryColorLT,
    ),
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(10.0),
      ),
    ),
  ),
);

final ElevatedButtonThemeData elevatedButtonThemeData = ElevatedButtonThemeData(
  style: ElevatedButton.styleFrom(
    textStyle: const TextStyle(),
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(10),
      ),
    ),
  ),
);

/*
/// Flutter code sample for SliverAppBar

// This sample shows a [SliverAppBar] and it's behavior when using the
// [pinned], [snap] and [floating] parameters.

import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

/// This is the main application widget.
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: _title,
      home: MyStatefulWidget(),
    );
  }
}
/*

/// This is the stateful widget that the main application instantiates.
class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}
*/


/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  bool _pinned = true;
  bool _snap = false;
  bool _floating = false;

// [SliverAppBar]s are typically used in [CustomScrollView.slivers], which in
// turn can be placed in a [Scaffold.body].
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: _pinned,
            snap: _snap,
            floating: _floating,
            expandedHeight: 160.0,
            flexibleSpace: const FlexibleSpaceBar(
              title: Text('Home'),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 20,
              child: Center(
                child: Text('Scroll to see the SliverAppBar in effect.'),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                return Container(
                  color: index.isOdd ? Colors.white : Colors.black12,
                  height: 100.0,
                  child: Center(
                    child: Text('$index', textScaleFactor: 5),
                  ),
                );
              },
              childCount: 20,
            ),
          ),
        ],
      ),

    );
  }
}
*/
