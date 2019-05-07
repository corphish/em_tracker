import 'package:shared_preferences/shared_preferences.dart';

class Item {
  double value;
  String title;
  DateTime addDate;
  int months;

  Item(this.value, this.title, this.addDate, this.months);

  static Item fromString(String str) {
    double value = double.parse(str.split(",")[0]);
    String title = str.split(",")[1];
    DateTime dateTime = DateTime.parse(str.split(",")[2]);
    int months = int.parse(str.split(",")[3]);

    return Item(value, title, dateTime, months);
  }

  String toString() => "$value,$title,${addDate.toString()},$months";

  int monthsRemaining() {
    var now = DateTime.now().month;
    var start = addDate.month;

    if (now < start) now += 12 * (DateTime.now().year - addDate.year);
    return months - (now - start); 
  }

  String formattedMonthsRemaining() {
    var x = monthsRemaining();

    return x >= 120 ? "Payable monthly unless you cancel" : "$x installment(s) remaining";
  }

  bool isComplete() => monthsRemaining() <= 0;
  bool isInfinite() => monthsRemaining() >= 120;
}

class ItemManager {
  final String _spKeyCurrency = "currency";
  final String _spKeyItems = "items";

  String currency;
  List<Item> items;
  double total = 0;
  double totalPayable = 0;

  Future<void> fetchSettings() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    currency = prefs.getString(_spKeyCurrency) ?? "INR";
    List<String> strList = prefs.getStringList(_spKeyItems) ?? null;
    if (strList != null) {
      items = List<Item>();
      strList.forEach((it) {
        Item item = Item.fromString(it);
        if (!item.isComplete()) {
          items.add(item);
          total += item.value;
          if (!item.isInfinite()) totalPayable += item.value * item.monthsRemaining();
        }
      });
    } else {
      items = List<Item>();
    }
  }

  Future<bool> updateCurrency(String newCurrency) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

	  return prefs.setString(_spKeyCurrency, newCurrency);
  }

  Future<bool> addItem(double val, String title, int months) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var item = Item(val, title, DateTime.now(), months);
    if (!item.isComplete()) {
      items.add(item);
      total += val;
      if (!item.isInfinite()) totalPayable += item.value * item.monthsRemaining();
    }

    List<String> strList = List<String>();
    items.forEach((it) => strList.add(it.toString()));

	  return prefs.setStringList(_spKeyItems, strList);
  }

  Future<bool> removeItem(int index) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    total -= items[index].value;
    if (!items[index].isInfinite()) totalPayable -= items[index].value * items[index].monthsRemaining();
    items.removeAt(index);

    List<String> strList = List<String>();
    items.forEach((it) => strList.add(it.toString()));

	  return prefs.setStringList(_spKeyItems, strList);
  }
}