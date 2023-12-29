import 'package:flutter/material.dart';
import 'package:vootday_admin/screens/home/widgets/chart/line_chart_sample1.dart';
// ... autres importations nécessaires ...

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              height: 512,
              width: 512,
              child: const LineChartSample1()),
          ],
        ),
      ),
    );
  }
}
