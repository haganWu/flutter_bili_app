import 'package:flutter/material.dart';
import 'package:flutter_bili_app/http/core/hi_net_error.dart';
import 'package:flutter_bili_app/http/dao/profile_dao.dart';
import 'package:flutter_bili_app/http/model/profile_mo.dart';
import 'package:flutter_bili_app/utils/LogUtil.dart';
import 'package:flutter_bili_app/utils/view_util.dart';
import 'package:flutter_bili_app/widget/hi_banner.dart';
import 'package:flutter_bili_app/widget/hi_flexible_header.dart';

import '../utils/toast.dart';
import '../widget/course_card.dart';
import '../widget/hi_blur.dart';

/// 我的
class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with AutomaticKeepAliveClientMixin {
  final String tag = "ProfilePage";
  final ScrollController _controller = ScrollController();

  ProfileMo? _profileMo;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: NestedScrollView(
        controller: _controller,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[buildAppBar()];
        },
        body: ListView(
          padding: const EdgeInsets.only(top: 10),
          children: [..._buildContentList()],
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
    return HiFlexibleHeader(name: _profileMo!.name!, face: _profileMo!.face!, controller: _controller);
  }

  @override
  bool get wantKeepAlive => true;

  buildAppBar() {
    return SliverAppBar(
      // 扩展高度
      expandedHeight: 160,
      // 标题栏是否固定
      pinned: true,
      backgroundColor: Colors.white,
      // 定义滚动空间
      flexibleSpace: FlexibleSpaceBar(
        // 时差滚动效果
        collapseMode: CollapseMode.parallax,
        titlePadding: const EdgeInsets.only(left: 0),
        title: _buildHeader(),
        background: Stack(
          children: [
            Positioned.fill(child: cachedImage(url: 'http://ww1.sinaimg.cn/large/0065oQSqly1frqscr5o00j30k80qzafc.jpg')),
            const Positioned.fill(child: HiBlur(sigma: 6)),
            Positioned(bottom: 0, left: 0, right: 0, child: _buildProfileTab())
          ],
        ),
      ),
    );
  }

  _buildContentList() {
    if (_profileMo == null) {
      return [];
    }
    return [
      _buildBanner(),
      CourseCard(
        courseList: _profileMo!.courseList!,
      )
    ];
  }

  _buildBanner() {
    return HiBanner(bannerList: _profileMo!.bannerList!, padding: const EdgeInsets.only(left: 10, right: 10), bannerHeight: 120, radius: 6);
  }

  _buildProfileTab() {
    if (_profileMo == null) {
      return Container();
    }
    return Container(
      padding: const EdgeInsets.only(top: 5, bottom: 5),
      decoration: const BoxDecoration(color: Colors.white54),
      child: Row(
        // 主轴展开，平分屏幕宽度
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildIconText("收藏", _profileMo!.favorite!),
          _buildIconText("点赞", _profileMo!.like!),
          _buildIconText("浏览", _profileMo!.browsing!),
          _buildIconText("金币", _profileMo!.coin!),
          _buildIconText("粉丝", _profileMo!.fans!),
        ],
      ),
    );
  }

  _buildIconText(String text, int count) {
    return Column(
      children: [
        Text(
          "$count",
          style: const TextStyle(fontSize: 15, color: Colors.black87),
        ),
        Text(
          text,
          style: const TextStyle(fontSize: 12, color: Color(0xFF757575)),
        ),
      ],
    );
  }
}
