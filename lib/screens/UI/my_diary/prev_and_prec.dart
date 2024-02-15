import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:test_1/localization/locales.dart';

class PrevAndPrec extends StatefulWidget {
  const PrevAndPrec({super.key});

  @override
  State<PrevAndPrec> createState() => _PrevAndPrecState();
}

class _PrevAndPrecState extends State<PrevAndPrec> {
  late FlutterLocalization _flutterLocalization;
  late String _currentLocale;
  List<Widget> listViews = <Widget>[];

  @override
  void initState() {
    super.initState();
    _flutterLocalization = FlutterLocalization.instance;
    _currentLocale = _flutterLocalization.currentLocale!.languageCode;
    // print('Current locale - $_currentLocale');
    // addAllListData();
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          LocaleData.prevAndPrecTitle.getString(context),
        ),
        actions: [
          DropdownButton(
            value: _currentLocale,
            items: const [
              DropdownMenuItem(
                value: 'en',
                child: Text('English'),
              ),
              DropdownMenuItem(
                value: 'hi',
                child: Text('हिंदी'),
              ),
            ],
            onChanged: (value) {
              _setLocale(value);
            },
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          //Preventions
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            child: Text(
              context.formatString(LocaleData.prevTitle, ['']),
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            child: Text(
              context.formatString(LocaleData.prevBody, ['']),
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),

          //Precautions
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            child: Text(
              context.formatString(LocaleData.precTitle, ['']),
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            child: Text(
              context.formatString(LocaleData.precBody, ['']),
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),

          // getMainListViewUI(),
        ],
      ),
    );
  }

  void _setLocale(String? value) {
    if (value == null) return;
    if (value == 'en') {
      _flutterLocalization.translate('en');
    } else if (value == 'hi') {
      _flutterLocalization.translate('hi');
    } else {
      return;
    }

    setState(() {
      _currentLocale = value;
    });
  }

  // void addAllListData() {
  //   listViews.add(BodyPara());
  //   listViews.add(BodyPara());
  // }

  // Widget getMainListViewUI() {
  //   return FutureBuilder<bool>(
  //     future: getData(),
  //     builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
  //       if (!snapshot.hasData) {
  //         return const SizedBox();
  //       } else {
  //         return ListView.builder(
  //           // controller: scrollController,
  //           padding: EdgeInsets.only(
  //             top: AppBar().preferredSize.height +
  //                 MediaQuery.of(context).padding.top +
  //                 24,
  //             bottom: 62 + MediaQuery.of(context).padding.bottom,
  //           ),
  //           itemCount: listViews.length,
  //           scrollDirection: Axis.vertical,
  //           itemBuilder: (BuildContext context, int index) {
  //             // widget.animationController?.forward();
  //             return listViews[index];
  //           },
  //         );
  //       }
  //     },
  //   );
  // }
}
