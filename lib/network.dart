import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bitcoin_ticker/coin_data.dart';

class Network {
  final String apiKey = 'C4094B34-7C06-4DDC-AF79-D142DE496195';

  Future<CoinData> getCoinRate(String cryptoName, String currencyName) async {
    String url =
        'http://rest.coinapi.io/v1/exchangerate/$cryptoName/$currencyName?apikey=$apiKey';
    print('url $url');

    final response = await http.get(Uri.parse(url));
    if (response != null) {
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        print('response body ${response.body}');
        return CoinData.fromJson(jsonDecode(response.body));
      } else {
        return CoinData(rate: 'exception');
      }
    } else {
      return CoinData(rate: 'no response');
    }
  }
}
