import 'dart:io';
import 'dart:convert';
import 'currency_model.dart';
import 'package:http/http.dart';
import 'package:colorize/colorize.dart';

class App {
  Map valyutaTurlari = {};
  currencyConverter() async {
    var response =
        await get(Uri.parse("https://cbu.uz/oz/arkhiv-kursov-valyut/json/"));

    List<CurrencyModel> currency_model = [];
    currency_model = [
      for (final item in jsonDecode(response.body)) CurrencyModel.fromJson(item)
    ];

    double? usd, rub, eur;
    currency_model.forEach((element) {
      if (element.ccy == "USD") usd = double.parse(element.rate!);
      if (element.ccy == "RUB") rub = double.parse(element.rate!);
      if (element.ccy == "EUR") eur = double.parse(element.rate!);
      valyutaTurlari.addAll({element.ccy: double.parse(element.rate!)});
    });

    print(Colorize('''
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
''').green());
    serviceView();
  }

  void serviceView() {
    print(greenColor('''      
--------------------------------------------------
|       Xizmat turlari                           |
|                                                |
| 1) Istalgan valyutaning so'mdagi qiymati       |
|                                                |
| 2) AQSH Dollarini so'mga hisoblash             |
|                                                |
| 3) Valyutaning valyutaga nisbati               |
|                                                |
| 4) Chiqish                                     |
--------------------------------------------------'''));
    printModel(greenColor('Xizmat turini tanlang ♻️'));
    xizmatlar(valyutaTurlari);
  }

  void xizmatlar(Map valyutaTurlari) {
    String xizmatTuri = stdin.readLineSync()!;
    if (xizmatTuri == "1") {
      printModel(greenColor("Valyuta turini kiriting ♻️"));
      String valyutaTuri = stdin.readLineSync()!.toUpperCase();
      if (valyutaTurlari.containsKey(valyutaTuri)) {
        printModel(greenColor("1 $valyutaTuri ${valyutaTurlari[valyutaTuri]} so'm   ✅"));
        serviceView();
      } else {
        printModel(redColor("Valyuta turi xato kiritildi ! 🚫 \n${valyutaTurlari.keys}"));
        serviceView();
      }
    } else if (xizmatTuri == "2") {
      printModel(greenColor("AQSH dollari qiymatini kiriting ♻️"));
      double amountUSD = double.parse(stdin.readLineSync()!);
      printModel(greenColor("$amountUSD AQSH dollarining so'mdagi qiymati ${(amountUSD * valyutaTurlari["USD"]).toStringAsFixed(3)} so'm  ✅"));
      serviceView();
    } else if (xizmatTuri == "3") {
      printModel(greenColor("Valyuta turlarini probel bilan kiriting ♻️"));
      List<String> valyutalar =
          stdin.readLineSync()!.trim().toUpperCase().split(" ");
      if (valyutaTurlari.containsKey(valyutalar[0])) {
        if (valyutaTurlari.containsKey(valyutalar[1])) {
          printModel(greenColor("${valyutalar[0]} ning ${valyutalar[1]} ga nisbati ${(valyutaTurlari[valyutalar[0]] / valyutaTurlari[valyutalar[1]]).toStringAsFixed(3)}  ✅"));
          serviceView();
        } else {
          printModel(redColor("Ikkinchi valyuta turi xato kiritildi!  🚫"));
          serviceView();
        }
      } else {
        printModel(redColor("Birinchi valyuta turi xato kiritildi!  🚫"));
        serviceView();
      }
    } else if (xizmatTuri == "4") {
      exit(0);
    } else {
      printModel(redColor("Xizmat turi noto'g'ri kiritildi  🚫"));
      serviceView();
    }
  }

  void printModel(Colorize text) {
    print(greenColor('''------------------------------------------------------------
|                                                          |'''));
    print("  $text");
    print(greenColor('''|                                                          |
------------------------------------------------------------'''));
  }

  Colorize greenColor(String text) {
    return Colorize(text).green();
  }

  Colorize redColor(String text) {
    return Colorize(text).red();
  }
}
