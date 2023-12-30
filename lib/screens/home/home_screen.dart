import 'package:flutter/material.dart';
import 'package:vootday_admin/config/constants/dimens.dart';
import 'package:vootday_admin/screens/home/widgets/chart/line_chart_sample1.dart';
import 'package:vootday_admin/screens/home/widgets/chart/line_chart_sample2.dart';
import 'package:vootday_admin/screens/home/widgets/chart/pie_chart_sample2.dart';
// ... autres importations nécessaires ...

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Row(
          children: [
            SizedBox(width: kDefaultPadding),
            Expanded(child: Card(child: LineChartSample1())),
            SizedBox(width: kDefaultPadding),
            Expanded(child: Card(child: LineChartSample2())),
            SizedBox(width: kDefaultPadding),
            Expanded(child: Card(child: PieChartSample2()))
          ],
        ),
      ),
    );
  }
}
