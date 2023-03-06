import 'package:flutter/material.dart';
import 'package:flutter_bili_app/http/core/hi_net_error.dart';
import 'package:flutter_bili_app/http/dao/profile_dao.dart';
import 'package:flutter_bili_app/http/model/profile_mo.dart';
import 'package:flutter_bili_app/utils/LogUtil.dart';
import 'package:flutter_bili_app/utils/view_util.dart';

import '../utils/toast.dart';

/// 我的
class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final String tag = "ProfilePage";

  ProfileMo? _profileMo;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              // 扩展高度
              expandedHeight: 160,
              // 标题栏是否固定
              pinned: true,
              backgroundColor: Colors.white,
              // 定义滚动空间
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.only(left: 0),
                title: _buildHeader(),
                background: Container(
                  color: Colors.deepOrange,
                ),
              ),
            )
          ];
        },
        body: ListView.builder(
          itemCount: 20,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(title: Text('标题：$index', style: const TextStyle(fontSize: 10, color: Colors.grey)));
          },
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

  _buildHeader() {
    if (_profileMo == null) return Container();
    return Container(
      alignment: Alignment.bottomLeft,
      padding: const EdgeInsets.only(bottom: 30, left: 10),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: cachedImage(url: _profileMo!.face!, width: 44, height: 44),
          ),
          hiSpace(width: 6),
          Text(
            _profileMo!.name!,
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          )
        ],
      ),
    );
  }
}
