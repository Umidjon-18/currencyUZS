import 'dart:io';
import 'dart:convert';
import 'currency_model.dart';
import 'package:http/http.dart';

void main(List<String> args) {
  currencyConverter();
}

currencyConverter() async {
  var response =
      await get(Uri.parse("https://cbu.uz/oz/arkhiv-kursov-valyut/json/"));

  List<CurrencyModel> currency_model = [];
  currency_model = [
    for (final item in jsonDecode(response.body)) CurrencyModel.fromJson(item)
  ];

  double? usd, rub, eur;
  Map valyutaTurlari = {};
  currency_model.forEach((element) {
    if (element.ccy == "USD") usd = double.parse(element.rate!);
    if (element.ccy == "RUB") rub = double.parse(element.rate!);
    if (element.ccy == "EUR") eur = double.parse(element.rate!);
    valyutaTurlari.addAll({element.ccy: double.parse(element.rate!)});
  });

//💹🧮♻️💵💴💶💷💰⚖️🏦
  print('''
------------------------------
|       Valyuta kursi        |
|                            |
|     1 USD = $usd so'm   |
|                            |
|     1 RUB = $rub   so'm  |
|                            |
|     1 EUR = $eur so'm  |
|                            |
|                            |
------------------------------
''');

  print('''      
--------------------------------------------------
|       Xizmat turlari                           |
|                                                |
| 1) Istalgan valyutaning so'mdagi qiymati       |
|                                                |
| 2) AQSH Dollarini so'mga hisoblash             |
|                                                |
| 3) Valyutaning valyutaga nisbati               |
|                                                |
|                                                |
--------------------------------------------------''');
  print("Xizmat turini tanlang");
  xizmatlar(valyutaTurlari);
}








void xizmatlar(Map valyutaTurlari) {
  String xizmatTuri = stdin.readLineSync()!;
  if (xizmatTuri == "1") {
    print("Valyuta turini kiriting ♻️");
    String valyutaTuri = stdin.readLineSync()!.toUpperCase();
    if (valyutaTurlari.containsKey(valyutaTuri)) {
      print("1 $valyutaTuri ${valyutaTurlari[valyutaTuri]} so'm");
    } else {
      print('''
Valyuta turi xato kiritildi !
${valyutaTurlari.keys}
''');
    }
  } else if (xizmatTuri == "2") {
    print("AQSH dollari qiymatini kiriting ");
    double amountUSD = double.parse(stdin.readLineSync()!);
    print(
        "$amountUSD USDning so'mdagi qiymati ${(amountUSD * valyutaTurlari["USD"]).toStringAsFixed(3)} so'm");
  } else if (xizmatTuri == "3") {
    print("Valyuta turlarini probel bilan kiriting");
    List<String> valyutalar =
        stdin.readLineSync()!.trim().toUpperCase().split(" ");
    if (valyutaTurlari.containsKey(valyutalar[0])) {
      if (valyutaTurlari.containsKey(valyutalar[1])) {
        print(
            "${valyutalar[0]} ning ${valyutalar[1]} ga nisbati ${valyutaTurlari[valyutalar[0]] / valyutaTurlari[valyutalar[1]]}");
      } else {
        print("Ikkinchi valyuta turi xato kiritildi!");
      }
    } else {
      print("Birinchi valyuta turi xato kiritildi!");
    }
  } else {
    print("Xizmat turi noto'g'ri kiritildi");
  }
}
