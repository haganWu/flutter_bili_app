import 'package:flutter/material.dart';
import 'package:hi_net/core/hi_net_error.dart';
import 'package:hi_base/LogUtil.dart';
import 'package:hi_base/toast.dart';
import 'package:hi_base/hi_state.dart';
import 'package:hi_base/color.dart';

/// 通用底层分页刷新列表页面框架
/// M：Dao返回数据模型   L：列表数据模型  T：具体Widget
abstract class HiBaseTabState<M, L, T extends StatefulWidget> extends HiState<T> with AutomaticKeepAliveClientMixin {
  final String tag = "HiBaseTabState";
  List<L> dataList = [];
  int pageIndex = 1;
  bool loading = false;
  final ScrollController scrollController = ScrollController();

  get contentChild;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      var dis = scrollController.position.maxScrollExtent - scrollController.position.pixels;
      // 当距离底部不足200时加载更多   列表高度不满屏幕高度时不执行加载更多
      if (dis < 300 && !loading && scrollController.position.maxScrollExtent != 0) {
        LogUtil.L(tag, "------- LoadMore-------");
        loadData(loadMore: true);
      }
    });
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      onRefresh: loadData,
      color: primary,
      child: MediaQuery.removePadding(removeTop: true, context: context, child: contentChild),
    );
  }

  /// 获取对应页面的数据 交由子类处理
  Future<M> getData(int pageIndex);

  /// 从Mo中解析出list数据 交由子类处理
  List<L> parseList(M result);

  Future<void> loadData({bool loadMore = false}) async {
    loading = true;
    if (!loading) {
      pageIndex = 1;
    }
    var currentIndex = pageIndex + (loadMore ? 1 : 0);
    LogUtil.L(tag, "currentIndex:$currentIndex");
    LogUtil.L(tag, "pageIndex:$pageIndex");
    try {
      M result = await getData(currentIndex);
      setState(() {
        if (loadMore) {
          // 合成一个新的数组
          dataList = [...dataList, ...parseList(result)];
          if (parseList(result).isNotEmpty) {
            pageIndex++;
          }
        } else {
          dataList = parseList(result);
        }
      });
      Future.delayed(const Duration(milliseconds: 1000), () {
        loading = false;
      });
    } on NeedAuth catch (e) {
      LogUtil.L(tag, e.toString());
      showErrorToast(e.message);
      setState(() {
        loading = false;
      });
    } on HiNetError catch (e) {
      LogUtil.L(tag, e.toString());
      showErrorToast(e.message);
      setState(() {
        loading = false;
      });
    }
  }

  /// 不重新创建页面
  @override
  bool get wantKeepAlive => true;
}
