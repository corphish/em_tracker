class CurrencyManager {
  static var currencyMap = {
    "INR": "₹", 
    "USD": "\$"
  };

  static String encode(double val, String cur) {
    String currency = currencyMap[cur];
    
    return currency == null ? "$val $cur" : "$currency$val"; 
  }
}