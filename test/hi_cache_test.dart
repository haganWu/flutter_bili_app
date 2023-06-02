import 'package:flutter_bili_app/db/hi_cache.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
/// 单元测试
void main() {
  test('testHiCache', () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    await HiCache.preInit();
    var key = 'testHiCache', value = 'Hello';
    HiCache.getInstance().setString(key, value);
    expect(HiCache.getInstance().get(key), value);
  });
}
