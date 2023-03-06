import 'package:flutter/material.dart';
import 'package:flutter_bili_app/http/core/hi_net_error.dart';
import 'package:flutter_bili_app/http/dao/profile_dao.dart';
import 'package:flutter_bili_app/http/model/profile_mo.dart';
import 'package:flutter_bili_app/utils/LogUtil.dart';

import '../utils/toast.dart';

/// 我的
class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final String tag = "ProfilePage";

  late ProfileMo _profileMo;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FractionallySizedBox(
          heightFactor: 1,
          widthFactor: 1,
          child: Container(
            alignment: Alignment.center,
            child: const Text(
              "我的",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30, color: Colors.red),
            ),
          ),
        ),
      ),
    );
  }

  void _getData() async {
    try {
      ProfileMo result = await ProfileDao.get();
      LogUtil.L(tag, "个人中心网络接口请求结果：${result.toJson().toString()}");
      setState(() {
        _profileMo = result;
      });
    } on NeedAuth catch (e) {
      LogUtil.L(tag, e.toString());
      showErrorToast(e.message);
    } on HiNetError catch (e) {
      LogUtil.L(tag, e.toString());
      showErrorToast(e.message);
    }
  }
}
