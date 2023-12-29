import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vootday_admin/config/configs.dart';
import 'package:vootday_admin/screens/widgets/widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _dataTableHorizontalScrollController = ScrollController();

  @override
  void dispose() {
    _dataTableHorizontalScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final summaryCardCrossAxisCount = (size.width >= kScreenWidthLg ? 4 : 2);

    return Container(
      color: webBackgroundColor,
      child: ListView(
        padding: const EdgeInsets.all(kDefaultPadding),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final summaryCardWidth = ((constraints.maxWidth -
                        (kDefaultPadding * (summaryCardCrossAxisCount - 1))) /
                    summaryCardCrossAxisCount);

                return Wrap(
                  direction: Axis.horizontal,
                  spacing: kDefaultPadding,
                  runSpacing: kDefaultPadding,
                  children: [
                    SummaryCard(
                      title: 'Titre 1',
                      value: '150',
                      icon: Icons.shopping_cart_rounded,
                      backgroundColor: couleurBleuClair,
                      textColor: white,
                      iconColor: Colors.black12,
                      width: summaryCardWidth,
                    ),
                    SummaryCard(
                      title: 'Titre 2',
                      value: '+12%',
                      icon: Icons.ssid_chart_rounded,
                      backgroundColor: couleurBleuClair,
                      textColor: white,
                      iconColor: Colors.black12,
                      width: summaryCardWidth,
                    ),
                    SummaryCard(
                      title: 'Titre 3',
                      value: '+12%',
                      icon: Icons.ssid_chart_rounded,
                      backgroundColor: couleurBleuClair,
                      textColor: white,
                      iconColor: Colors.black12,
                      width: summaryCardWidth,
                    ),
                    SummaryCard(
                      title: 'Titre 4',
                      value: '+12%',
                      icon: Icons.ssid_chart_rounded,
                      backgroundColor: couleurBleuClair,
                      textColor: white,
                      iconColor: Colors.black12,
                      width: summaryCardWidth,
                    ),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: kDefaultPadding),
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CardHeader(
                    title: 'Titre',
                    showDivider: false,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final double dataTableWidth =
                            max(kScreenWidthMd, constraints.maxWidth);

                        return Scrollbar(
                          controller: _dataTableHorizontalScrollController,
                          thumbVisibility: true,
                          trackVisibility: true,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            controller: _dataTableHorizontalScrollController,
                            child: SizedBox(
                              width: dataTableWidth,
                              child: DataTable(
                                showCheckboxColumn: false,
                                showBottomBorder: true,
                                columns: const [
                                  DataColumn(label: Text('No.'), numeric: true),
                                  DataColumn(label: Text('Date')),
                                  DataColumn(label: Text('Item')),
                                  DataColumn(
                                      label: Text('Price'), numeric: true),
                                ],
                                rows: List.generate(5, (index) {
                                  return DataRow.byIndex(
                                    index: index,
                                    cells: [
                                      DataCell(Text('#${index + 1}')),
                                      const DataCell(Text('2022-06-30')),
                                      DataCell(Text('Item ${index + 1}')),
                                      DataCell(
                                          Text('${Random().nextInt(10000)}')),
                                    ],
                                  );
                                }),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.all(kDefaultPadding),
                      child: SizedBox(
                        height: 40.0,
                        width: 120.0,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: couleurBleuClair2,
                          ),
                          onPressed: () {},
                          child: const Text('View All'),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
