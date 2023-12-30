import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:vootday_admin/config/configs.dart';
import 'package:vootday_admin/models/models.dart';
import 'package:vootday_admin/screens/calendar/bloc/blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vootday_admin/screens/widgets/widgets.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CalendarEndedBloc>().add(CalendarEndedFetchEvent());
    context.read<CalendarComingSoonBloc>().add(CalendarComingSoonFetchEvent());
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(kDefaultPadding),
      child: Scaffold(
        floatingActionButton: _buildFloatingActionButton(context),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        backgroundColor: white,
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderSection(context, size),
              const SizedBox(height: kDefaultPadding),
              // Events Done
              Card(
                  child: Stack(
                children: [
                  buildSectionTitle('Ended events'),
                  BlocBuilder<CalendarEndedBloc, CalendarEndedState>(
                    builder: (context, state) {
                      switch (state.status) {
                        case CalendarEndedStatus.loaded:
                          return SizedBox(
                            width: double.infinity,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 18,
                                    ),
                                    buildEventsTable(state.thisWeekEvents),
                                  ],
                                ),
                              ),
                            ),
                          );
                        case CalendarEndedStatus.loading:
                        default:
                          return Container(color: white);
                      }
                    },
                  ),
                ],
              )),
              const SizedBox(height: kDefaultPadding),
              // Coming Soon Events Section
              Card(
                child: Stack(
                  children: [
                    buildSectionTitle('Coming soon'),
                    BlocBuilder<CalendarComingSoonBloc,
                        CalendarComingSoonState>(
                      builder: (context, state) {
                        switch (state.status) {
                          case CalendarComingSoonStatus.loaded:
                            return SizedBox(
                              width: double.infinity,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Column(
                                    children: [
                                      const SizedBox(
                                        height: 18,
                                      ),
                                      buildEventsTable(
                                          state.thisComingSoonEvents),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          case CalendarComingSoonStatus.loading:
                          default:
                            return Container(color: white);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context, Size size) {
    return Wrap(
      direction: Axis.horizontal,
      spacing: kDefaultPadding,
      runSpacing: kDefaultPadding,
      children: [
        const SummaryCard(
          title: 'Taux de likes ',
          value: '47%',
          icon: Icons.ssid_chart_rounded,
          backgroundColor: white,
          textColor: black,
          iconColor: Colors.black12,
          width: 256,
        ),
        const SummaryCard(
          title: 'Taux de participations',
          value: '70%',
          icon: Icons.person,
          backgroundColor: white,
          textColor: black,
          iconColor: Colors.black12,
          width: 256,
        ),
        const SummaryCard(
          title: 'Ended Events',
          value: '7',
          icon: Icons.calendar_today,
          backgroundColor: white,
          textColor: black,
          iconColor: Colors.black12,
          width: 256,
        ),
        const SummaryCard(
          title: 'Next Events',
          value: '2',
          icon: Icons.calendar_month,
          backgroundColor: white,
          textColor: black,
          iconColor: Colors.black12,
          width: 256,
        ),
        _buildButtonsCard(),
      ],
    );
  }

  Widget _buildButtonsCard() {
    return SizedBox(
      height: 120.0,
      width: 232,
      child: Card(
        color: white,
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(kDefaultPadding),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildShowFeedButton(context),
                    _buildStatsButton(context),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildImportButton(context),
                    _buildExportButton(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShowFeedButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: couleurBleuClair2,
      ),
      onPressed: () {},
      child: const Text('Test1'),
    );
  }

  Widget _buildStatsButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: couleurBleuClair2,
      ),
      onPressed: () {},
      child: const Text('Test2'),
    );
  }

  Widget _buildImportButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: couleurBleuClair2,
      ),
      onPressed: () {},
      child: const Text('Test3'),
    );
  }

  Widget _buildExportButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: couleurBleuClair2,
      ),
      onPressed: () {},
      child: const Text('Test4'),
    );
  }

  Widget buildEventsTable(List<Event?> events) {
    return Padding(
      padding: const EdgeInsets.only(top: kDefaultPadding),
      child: SizedBox(
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Actions')),
            DataColumn(label: Text('ID')),
            DataColumn(label: Text('Brand')),
            DataColumn(label: Text('Title')),
            DataColumn(label: Text('Date Created')),
            DataColumn(label: Text('Date End')),
            DataColumn(label: Text('Date Event')),
            DataColumn(label: Text('Participants')),
            DataColumn(label: Text('Reward')),
            DataColumn(label: Text('User Ref')),
            // DataColumn(label: Text('Done')),
          ],
          rows: events.map((event) {
            if (event == null) return DataRow(cells: [DataCell(Text('N/A'))]);
            return DataRow(
              cells: [
                DataCell(Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.visibility),
                      onPressed: () =>
                          _navigateToEventScreen(context, event.id),
                    ),
                  ],
                )),
                DataCell(Text(event.id)),
                DataCell(Text(event.author.author)),
                DataCell(Text(event.title)),
                DataCell(Text(DateFormat('yyyy-MM-dd').format(event.date))),
                DataCell(Text(DateFormat('yyyy-MM-dd').format(event.dateEnd))),
                DataCell(
                    Text(DateFormat('yyyy-MM-dd').format(event.dateEvent))),
                DataCell(Text(event.participants.toString())),
                DataCell(Text(event.reward.toString())),
                DataCell(Text(event.user_ref.id.toString())),
                // DataCell(Icon(event.done ? Icons.check : Icons.close)),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.all(kDefaultPadding),
      child: Text(title, style: AppTextStyles.titleLargeBlackBold(context)),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton.extended(
      backgroundColor: couleurBleuClair2,
      onPressed: () {},
      label: Text(
        'Add Event',
      ),
    );
  }

  void _navigateToEventScreen(BuildContext context, String eventId) {
    GoRouter.of(context).go('/calendar/event/$eventId', extra: eventId);
  }
}
