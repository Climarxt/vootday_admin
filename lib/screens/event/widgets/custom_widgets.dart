import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vootday_admin/config/configs.dart';
import 'package:vootday_admin/models/models.dart';

Widget buildButtonsCard(BuildContext context, Event event) {
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
                  _buildShowFeedButton(context, event),
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

Widget _buildShowFeedButton(BuildContext context, Event event) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: couleurBleuClair2,
    ),
    onPressed: () => _navigateToEventFeed(context, event.id),
    child: const Text('Feed'),
  );
}

Widget _buildStatsButton() {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: couleurBleuClair2,
    ),
    onPressed: () {},
    child: const Text('Stats'),
  );
}

Widget _buildImportButton() {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: couleurBleuClair2,
    ),
    onPressed: () {},
    child: const Text('Import'),
  );
}

Widget _buildExportButton() {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: couleurBleuClair2,
    ),
    onPressed: () {},
    child: const Text('Export'),
  );
}

void _navigateToEventFeed(BuildContext context, String eventId) {
  GoRouter.of(context).go(
    '/calendar/event/$eventId/feedevent',
  );
}
