import 'package:flutter/cupertino.dart';
import 'package:flutter_bili_app/http/model/home_mo.dart';
import 'package:flutter_bili_app/widget/hi_banner.dart';

class HomeTabPage extends StatefulWidget {
  final String name;
  final List<BannerMo>? bannerList;

  const HomeTabPage({Key? key, required this.name, this.bannerList}) : super(key: key);

  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [if (widget.bannerList != null) _banner()],
    );
  }

  _banner() {
    return Padding(
        padding: const EdgeInsets.only(left: 2, top: 2, right: 2),
        child: HiBanner(
          bannerList: widget.bannerList ?? [],
        ));
  }
}
