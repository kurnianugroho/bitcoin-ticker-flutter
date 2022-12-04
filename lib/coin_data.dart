const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

class CoinData {
  String time;
  String cryptoName;
  String currencyName;
  String rate;

  CoinData({time = '', cryptoName = '', currencyName = '', rate = ''}) {
    this.time = time;
    this.cryptoName = cryptoName;
    this.currencyName = currencyName;
    this.rate = rate;
  }

  factory CoinData.fromJson(Map<String, dynamic> json) {
    return CoinData(
        time: json['time'],
        cryptoName: json['asset_id_base'],
        currencyName: json['asset_id_quote'],
        rate: json['rate'].toStringAsFixed(3));
  }
}
