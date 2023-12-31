import 'package:flutter/material.dart';
import 'package:vootday_admin/config/configs.dart';

Widget buildButtonsCard() {
  return SizedBox(
    height: 120.0,
    width: 232,
    child: Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildShowFeedButton(),
                  _buildStatsButton(),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildImportButton(),
                  _buildExportButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildShowFeedButton() {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: couleurBleuClair2,
    ),
    onPressed: () {},
    child: const Text('Test1'),
  );
}

Widget _buildStatsButton() {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: couleurBleuClair2,
    ),
    onPressed: () {},
    child: const Text('Test2'),
  );
}

Widget _buildImportButton() {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: couleurBleuClair2,
    ),
    onPressed: () {},
    child: const Text('Test3'),
  );
}

Widget _buildExportButton() {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: couleurBleuClair2,
    ),
    onPressed: () {},
    child: const Text('Test4'),
  );
}
