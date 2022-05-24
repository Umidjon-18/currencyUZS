import 'dart:io';
import 'dart:convert';
import 'currency_model.dart';
import 'package:http/http.dart';
import 'package:colorize/colorize.dart';

class App {
  Map currencyTypes = {};
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
      currencyTypes.addAll({element.ccy: double.parse(element.rate!)});
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
    services(currencyTypes);
  }

  void services(Map currencyTypes) {
    String serviceType = stdin.readLineSync()!;
    if (serviceType == "1") {
      printModel(greenColor("Valyuta turini kiriting ♻️"));
      String currencyType = stdin.readLineSync()!.toUpperCase();
      if (currencyTypes.containsKey(currencyType)) {
        printModel(greenColor("1 $currencyType ${currencyTypes[currencyType]} so'm   ✅"));
        serviceView();
      } else {
        printModel(redColor("Valyuta turi xato kiritildi ! 🚫 \n${currencyTypes.keys}"));
        serviceView();
      }
    } else if (serviceType == "2") {
      printModel(greenColor("AQSH dollari qiymatini kiriting ♻️"));
      double amountUSD = double.parse(stdin.readLineSync()!);
      printModel(greenColor("$amountUSD AQSH dollarining so'mdagi qiymati ${(amountUSD * currencyTypes["USD"]).toStringAsFixed(3)} so'm  ✅"));
      serviceView();
    } else if (serviceType == "3") {
      printModel(greenColor("Valyuta turlarini probel bilan kiriting ♻️"));
      List<String> valyutalar =
          stdin.readLineSync()!.trim().toUpperCase().split(" ");
      if (currencyTypes.containsKey(valyutalar[0])) {
        if (currencyTypes.containsKey(valyutalar[1])) {
          printModel(greenColor("${valyutalar[0]} ning ${valyutalar[1]} ga nisbati ${(currencyTypes[valyutalar[0]] / currencyTypes[valyutalar[1]]).toStringAsFixed(3)}  ✅"));
          serviceView();
        } else {
          printModel(redColor("Ikkinchi valyuta turi xato kiritildi!  🚫"));
          serviceView();
        }
      } else {
        printModel(redColor("Birinchi valyuta turi xato kiritildi!  🚫"));
        serviceView();
      }
    } else if (serviceType == "4") {
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
