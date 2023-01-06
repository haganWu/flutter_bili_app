
import 'package:flutter_bili_app/utils/LogUtil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HiCache {
  SharedPreferences? prefs;
  HiCache._(){
    init();
  }
  static HiCache? _instance;

  /// 构造方法
  HiCache._pre(SharedPreferences preferences) {
    prefs = preferences;
  }

  // 预处理方法，防止prefs使用之前未初始化
  static Future<HiCache> preInit() async {
    if (_instance == null) {
      var prefs = await SharedPreferences.getInstance();
      _instance = HiCache._pre(prefs);
    }
    return _instance!;
  }
  static HiCache getInstall(){
    return _instance ??= HiCache._();
  }

  void init() async{
    prefs ??= await SharedPreferences.getInstance();
  }

  setString(String key, String value){
    prefs?.setString(key, value);
  }
  setDouble(String key, double value){
    prefs?.setDouble(key, value);
  }
  setInt(String key, int value){
    prefs?.setInt(key, value);
  }
  setBool(String key, bool value){
    prefs?.setBool(key, value);
  }
  setStringList(String key, List<String> value){
    prefs?.setStringList(key, value);
  }

  T? get<T>(String key) {
    var result = prefs?.get(key);
    if (result != null) {
      return result as T;
    }
    return null;
  }

}