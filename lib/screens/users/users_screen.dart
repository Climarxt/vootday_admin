import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vootday_admin/config/configs.dart';
import 'package:vootday_admin/screens/widgets/widgets.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final _dataTableHorizontalScrollController = ScrollController();

  @override
  void dispose() {
    _dataTableHorizontalScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                            DataColumn(label: Text('Price'), numeric: true),
                          ],
                          rows: List.generate(5, (index) {
                            return DataRow.byIndex(
                              index: index,
                              cells: [
                                DataCell(Text('#${index + 1}')),
                                const DataCell(Text('2022-06-30')),
                                DataCell(Text('Item ${index + 1}')),
                                DataCell(Text('${Random().nextInt(10000)}')),
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
    );
  }
}
