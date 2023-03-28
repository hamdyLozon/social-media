import 'package:shared_preferences/shared_preferences.dart';
// لحفظ معلومات من التكبيق نفسه داخليا
class CacheHelper {
  static SharedPreferences ?sharedPreferences;

  static init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  // هيك عملت ميثود عامة اقدر احفظ فيها الداتا يلي عندي شو ما كان نوعها
  static Future<bool>  saveData ({
    required String key,
    required dynamic value,
  })async
  {
    if (value is String) return await sharedPreferences!.setString(key, value);
    if (value is int) return await sharedPreferences!.setInt(key, value);
    if (value is bool) return await sharedPreferences!.setBool(key, value);

    // اذا ما كانت الداتا ولا شي من يلي فوق ف اكيد حتكون من نوع double
    return await sharedPreferences!.setDouble(key, value);
  }

  // ميثود عامة كمان عشان ارجع القيم يلي بدي ياها بعد مااخزن
  static dynamic getData({
    required String key,
  }){
    return sharedPreferences?.get(key);
  }

  static Future<bool> removeData ({
    required String key,
  })async
  {
    return sharedPreferences!.remove(key);
  }


}