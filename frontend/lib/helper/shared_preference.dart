import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {
  factory SharedPreferenceHelper() {
    return _singleton;
  }
  SharedPreferenceHelper._internal();
  static final SharedPreferenceHelper _singleton =
      SharedPreferenceHelper._internal();

  // Future<bool> setFilterPreference(Map<String, bool> data) async {
  //   return (await SharedPreferences.getInstance())
  //       .setString('FilterPreference', jsonEncode(data));
  // }

  // Future<Map<String, bool>?> getFilterPreference() async {
  //   String? data =
  //       (await SharedPreferences.getInstance()).getString('FilterPreference');
  //   if (data == null) {
  //     return null;
  //   }
  //   return Map<String, bool>.from(jsonDecode(data));
  // }

  // Future<bool> setFilterSemantic(String data) async {
  //   return (await SharedPreferences.getInstance())
  //       .setString('FilterSemantic', data);
  // }

  // Future<String?> getFilterSemantic() async {
  //   String? data =
  //       (await SharedPreferences.getInstance()).getString('FilterSemantic');
  //   return data;
  // }

  Future<void> clearFilterPreference() async {
    (await SharedPreferences.getInstance()).remove('filter');
    await clearFilterSemanticPreference();
  }

  Future<void> clearFilterSemanticPreference() async {
    (await SharedPreferences.getInstance())
        .remove('getFilterSemanticPreference');
  }
}
