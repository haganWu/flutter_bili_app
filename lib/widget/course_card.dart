import 'package:flutter/material.dart';
import 'package:hi_base/view_util.dart';
import '../http/model/profile_mo.dart';

class CourseCard extends StatelessWidget {
  final List<Course> courseList;

  const CourseCard({Key? key, required this.courseList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 5, top: 12),
      child: Column(
        children: [_buildTitle(), ..._buildCardList(context)],
      ),
    );
  }

  _buildTitle() {
    return Container(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        // 文字垂直（Y轴）居中
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text("职场进阶", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          hiSpace(width: 10),
          Text(
            "带你突破技术瓶颈",
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          )
        ],
      ),
    );
  }

  /// 动态布局
  _buildCardList(BuildContext context) {
    var courseGroup = {};
    // 课程分组
    for (var mo in courseList) {
      if (!courseGroup.containsKey(mo.group)) {
        courseGroup[mo.group] = [];
      }
      List list = courseGroup[mo.group];
      list.add(mo);
    }
    return courseGroup.entries.map((e) {
      List list = e.value;
      // 根据卡片数量计算每个卡片宽度
      var width = (MediaQuery.of(context).size.width - 20 - (list.length - 1) * 5) / list.length;
      var height = width / 16 * 6;
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [...list.map((mo) => _buildCard(mo, width, height)).toList()],
      );
    });
  }

  _buildCard(Course mo, double width, double height) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.only(right: 5, bottom: 5),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: cachedImage(url: mo.cover!, width: width, height: height),
        ),
      ),
    );
  }
}
