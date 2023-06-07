import 'package:flutter/material.dart';
import 'package:hi_base/view_util.dart';
import 'package:flutter_bili_app/widget/hi_blur.dart';

import '../http/model/profile_mo.dart';

/// 增值服务
class BenefitCard extends StatelessWidget {
  final List<Benefit> benefitList;

  const BenefitCard({Key? key, required this.benefitList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 5, top: 12),
      child: Column(
        children: [_buildTitle(), _buildBenefit(context)],
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
          const Text("增值服务", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          hiSpace(width: 10),
          Text(
            "购买后重新登陆查看",
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          )
        ],
      ),
    );
  }

  _buildBenefit(BuildContext context) {
    // 根据卡片数量计算每个卡片宽度
    var width = (MediaQuery.of(context).size.width - 20 - (benefitList.length - 1) * 5) / benefitList.length;
    return Row(
      children: [...benefitList.map((mo) => _buildCard(context, mo, width)).toList()],
    );
  }

  _buildCard(BuildContext context, Benefit mo, double width) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.only(right: 5, bottom: 5),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Container(
            alignment: Alignment.center,
            width: width,
            height: 60,
            decoration: const BoxDecoration(color: Colors.deepOrangeAccent),
            child: Stack(
              children: [
                const Positioned.fill(child: HiBlur(sigma: 6)),
                Positioned.fill(
                    child: Center(
                  child: Text(
                    mo.name!,
                    style: const TextStyle(fontSize: 14, color: Colors.white54),
                    textAlign: TextAlign.center,
                  ),
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
