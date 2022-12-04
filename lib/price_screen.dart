import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'coin_data.dart';
import 'network.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  List<String> currList;
  List<dynamic> itemList;
  String currValue = '';

  @override
  void initState() {
    currList = currenciesList;
    itemList = Platform.isIOS ? _getPickerItems() : _getDropdownItems();
    currValue = currList[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('🤑 Coin Ticker'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            FutureBuilder<List<String>>(
                future: _getExchangeRate(currValue),
                builder: (BuildContext context,
                    AsyncSnapshot<List<String>> snapshot) {
                  if (snapshot.hasData &&
                      snapshot.connectionState == ConnectionState.done) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
                          child: Column(
                            children: _getCryptoCards(snapshot.data),
                          ),
                        ),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Padding(
                        padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
                        child: Center(
                          child: Text('Something went wrong.'),
                        ));
                  } else {
                    return Padding(
                        padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
                        child: Center(child: CircularProgressIndicator()));
                  }
                }),
            Container(
              height: 150.0,
              alignment: Alignment.center,
              padding: EdgeInsets.only(bottom: 30.0),
              color: Colors.lightBlue,
              child: Platform.isIOS
                  ? CupertinoPicker(
                      itemExtent: 20.0,
                      children: itemList,
                      onSelectedItemChanged: (value) {
                        setState(() {
                          currValue = currList[value];
                        });
                      },
                    )
                  : DropdownButton(
                      value: currValue,
                      items: itemList,
                      onChanged: (value) {
                        setState(() {
                          currValue = value;
                        });
                      },
                    ),
            ),
          ],
        ));
  }

  List<DropdownMenuItem> _getDropdownItems() {
    List<DropdownMenuItem> currencyList = [];

    for (int i = 0; i < currenciesList.length; i++) {
      currencyList.add(DropdownMenuItem(
          value: currenciesList[i], child: Text(currenciesList[i])));
    }

    return currencyList;
  }

  List<Widget> _getPickerItems() {
    List<Widget> currencyList = [];

    for (int i = 0; i < currenciesList.length; i++) {
      currencyList.add(Center(child: Text(currenciesList[i])));
    }

    return currencyList;
  }

  Future<List<String>> _getExchangeRate(String currency) async {
    List<String> dataSet = [];

    for (int i = 0; i < cryptoList.length; i++) {
      CoinData data = await Network().getCoinRate(cryptoList[i], currency);
      dataSet.add(data.rate);
    }

    return dataSet;
  }

  List<Widget> _getCryptoCards(List<String> dataSet) {
    List<Widget> cards = [];

    for (int i = 0; i < cryptoList.length; i++) {
      cards.add(SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: Card(
          color: Colors.lightBlueAccent,
          elevation: 5.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
            child: Text(
              '1 ${cryptoList[i]} = ${dataSet[i]} $currValue',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ));
    }

    return cards;
  }
}
