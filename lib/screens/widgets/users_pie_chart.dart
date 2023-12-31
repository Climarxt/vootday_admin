import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:vootday_admin/config/colors.dart';
import 'package:vootday_admin/screens/home/widgets/chart/app_resources.dart';
import 'package:vootday_admin/screens/home/widgets/chart/indicator.dart';

class UserPieChart extends StatefulWidget {
  final int manUsersCount;
  final int womanUsersCount;
  final int allUsersCount;

  const UserPieChart(
      {super.key,
      required this.manUsersCount,
      required this.womanUsersCount,
      required this.allUsersCount});

  @override
  State<StatefulWidget> createState() => UserPieChartState();
}

class UserPieChartState extends State<UserPieChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120.0,
      width: 246,
      child: Card(
        clipBehavior: Clip.antiAlias,
        color: white,
        child: Row(
          children: <Widget>[
            Expanded(
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          touchedIndex = -1;
                          return;
                        }
                        touchedIndex = pieTouchResponse
                            .touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  sectionsSpace: 0,
                  centerSpaceRadius: 10,
                  sections: showingSections(),
                ),
              ),
            ),
            const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Indicator(
                  color: couleurJauneOrange1,
                  text: 'Man',
                  isSquare: true,
                ),
                SizedBox(
                  height: 4,
                ),
                Indicator(
                  color: AppColors.contentColorPurple,
                  text: 'Woman',
                  isSquare: true,
                ),
                SizedBox(
                  height: 4,
                ),
              ],
            ),
            const SizedBox(
              width: 28,
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    double total = widget.manUsersCount.toDouble() +
        widget.womanUsersCount.toDouble() +
        widget.allUsersCount.toDouble();

    int manPercentage = total != 0
        ? ((widget.manUsersCount.toDouble() / total) * 100).round()
        : 0;
    int womanPercentage = total != 0
        ? ((widget.womanUsersCount.toDouble() / total) * 100).round()
        : 0;

    return List.generate(2, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 12.0 : 10.0;
      final radius = isTouched ? 35.0 : 25.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: couleurJauneOrange1,
            value: manPercentage.toDouble(),
            title: '$manPercentage%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: AppColors.mainTextColor1,
              shadows: shadows,
            ),
          );
        case 1:
          return PieChartSectionData(
            color: AppColors.contentColorPurple,
            value: womanPercentage.toDouble(),
            title: '$womanPercentage%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: AppColors.mainTextColor1,
              shadows: shadows,
            ),
          );
        default:
          throw Error();
      }
    });
  }
}
