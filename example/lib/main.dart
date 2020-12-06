import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cryptowatch_candle_chart/flutter_k_chart.dart';
import 'package:cryptowatch_candle_chart/k_chart_widget.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<KLineEntity> datas;
  bool showLoading = true;
  MainState _mainState = MainState.MA;
  bool _volHidden = false;
  SecondaryState _secondaryState = SecondaryState.MACD;
  bool isLine = false;
  bool isChinese = false;

  @override
  void initState() {
    super.initState();
    fetchOhlcs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff17212F),
//      appBar: AppBar(title: Text(widget.title)),
      body: ListView(
        children: <Widget>[
          Stack(children: <Widget>[
            Container(
              height: 450,
              width: double.infinity,
              child: KChartWidget(
                datas,
                isLine: isLine,
                mainState: _mainState,
                volHidden: _volHidden,
                secondaryState: _secondaryState,
                fixedLength: 2,
                timeFormat: TimeFormat.YEAR_MONTH_DAY,
                isChinese: isChinese,
              ),
            ),
            if (showLoading)
              Container(
                  width: double.infinity,
                  height: 450,
                  alignment: Alignment.center,
                  child: CircularProgressIndicator()),
          ]),
          buildButtons(),
        ],
      ),
    );
  }

  Widget buildButtons() {
    return Wrap(
      alignment: WrapAlignment.spaceEvenly,
      children: <Widget>[
        button("Line", onPressed: () => isLine = true),
        button("Candle", onPressed: () => isLine = false),
        button("MA", onPressed: () => _mainState = MainState.MA),
        button("BOLL", onPressed: () => _mainState = MainState.BOLL),
        button("Hide", onPressed: () => _mainState = MainState.NONE),
        button("MACD", onPressed: () => _secondaryState = SecondaryState.MACD),
        button("KDJ", onPressed: () => _secondaryState = SecondaryState.KDJ),
        button("RSI", onPressed: () => _secondaryState = SecondaryState.RSI),
        button("WR", onPressed: () => _secondaryState = SecondaryState.WR),
        button("Hide sub view",
            onPressed: () => _secondaryState = SecondaryState.NONE),
        button(_volHidden ? "Volume" : "hide volume",
            onPressed: () => _volHidden = !_volHidden),
        button("切换中英文", onPressed: () {
          isChinese = !isChinese;
          setState(() {});
        }),
      ],
    );
  }

  Widget button(String text, {VoidCallback onPressed}) {
    return FlatButton(
        onPressed: () {
          if (onPressed != null) {
            onPressed();
            setState(() {});
          }
        },
        child: Text("$text"),
        color: Colors.blue);
  }

  Future<void> fetchOhlcs() async {
    final response = await http.get(
        'https://api.cryptowat.ch/markets/bitflyer/btcjpy/ohlc?periods=60');
    if (response.statusCode == 200) {
      List<KLineEntity> stores = [];
      print(response.body);
      Map<String, dynamic> decodedJson =
          json.decode(response.body) as Map<String, dynamic>;

      for (int i = 0; i < decodedJson['result']['60'].length; i++) {
        stores.add(KLineEntity.fromJson(decodedJson['result']['60'][i]));
      }
      datas = stores;
      DataUtil.calculate(datas);
      showLoading = false;
      setState(() {});
    } else {
      throw Exception('Failed to load album');
    }
  }
}
