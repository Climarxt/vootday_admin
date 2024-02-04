import 'package:vootday_admin/config/configs.dart';
import 'package:vootday_admin/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vootday_admin/screens/event/bloc/blocs.dart';
import 'package:vootday_admin/screens/event/config/constants.dart';
import 'package:vootday_admin/screens/event/widgets/widgets.dart';
import 'package:vootday_admin/screens/widgets/widgets.dart';

class EventScreen extends StatefulWidget {
  final String eventId;
  final String fromPath;

  const EventScreen({
    super.key,
    required this.eventId,
    required this.fromPath,
  });

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen>
    with AutomaticKeepAliveClientMixin {
  final Map<String, bool> _editState = {};
  int totalLikes = 0;

  @override
  void initState() {
    super.initState();
    context.read<EventBloc>().add(EventFetchEvent(eventId: widget.eventId));
    context
        .read<EventStatsBloc>()
        .add(EventStatsCountLikesFetchEvent(eventId: widget.eventId));
    context
        .read<EventStatsBloc>()
        .add(EventStatsRemainingDaysFetchEvent(eventId: widget.eventId));
    for (var detail in [
      'Caption',
      'Title',
      'Date Event',
      'Date End',
      'Tags',
      'ImageUrl'
    ]) {
      _editState[detail] = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    super.build(context);
    return BlocConsumer<EventBloc, EventState>(
      builder: (context, state) {
        if (state.status == EventStatus.loading) {
          return buildLoadingIndicator();
        } else if (state.status == EventStatus.loaded) {
          return _buildEvent(context, state.event ?? Event.empty, size);
        } else {
          return buildLoadingIndicator();
        }
      },
      listener: (BuildContext context, EventState state) {},
    );
  }

  Widget _buildEvent(BuildContext context, Event event, Size size) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderSection(context, event, size),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3.0),
                child: _buildDetailRows(event),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRows(Event event) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _buildDetailListLock(event, true),
          ),
        ),
        const SizedBox(width: kDefaultPadding),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _buildDetailListLock(event, false),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildDetailListLock(Event event, bool isFirstColumn) {
    final details = {
      'ID': event.id,
      'Author': event.author.author,
      'Caption': event.caption,
      'Participants': event.participants.toString(),
      'Title': event.title,
      'Date': event.date.toString(),
      'Date Event': event.dateEvent.toString(),
      'Date End': event.dateEnd.toString(),
      'Tags': event.tags.toString(),
      'Done': event.done.toString(),
      'ImageUrl': event.imageUrl.toString(),
      'LogoUrl': event.logoUrl.toString(),
    };

    final editableDetails = {
      'Caption',
      'Title',
      'Date Event',
      'Date End',
      'Tags',
      'ImageUrl',
      'LogoUrl',
      'Done',
    };

    final int splitIndex = details.length ~/ 2;
    final entries = isFirstColumn
        ? details.entries.take(splitIndex)
        : details.entries.skip(splitIndex);

    return entries
        .map((e) =>
            editableDetails.contains(e.key) && (_editState[e.key] ?? false)
                ? _buildTextField(
                    e.key, TextEditingController(text: e.value), event)
                : _buildTextLock(e.key, e.value, event))
        .expand((widget) => [widget, const SizedBox(height: 10)])
        .toList();
  }

  Widget _buildTextField(
      String label, TextEditingController controller, Event event) {
    Size size = MediaQuery.of(context).size;

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: size.width / 2.2),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: label,
                labelStyle: const TextStyle(color: Colors.black),
                fillColor: white,
                filled: true,
                border: const OutlineInputBorder(),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              setState(() {
                _editState[label] = false;
                _updateFirebase(label, controller.text, event);
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => setState(() {
              _editState[label] = false;
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context, Event event, Size size) {
    return BlocConsumer<EventStatsBloc, EventStatsState>(
      listener: (BuildContext context, EventStatsState state) {},
      builder: (context, state) {
        return Wrap(
          direction: Axis.horizontal,
          spacing: kDefaultPadding,
          runSpacing: kDefaultPadding,
          children: [
            SummaryCard(
              title: event.title,
              value: event.author.author,
              icon: Icons.abc,
              backgroundColor: white,
              textColor: black,
              iconColor: Colors.black12,
              width: 256,
            ),
            SummaryCard(
              title: 'Likes',
              value: state.likesEventCount.toString(),
              icon: Icons.ssid_chart_rounded,
              backgroundColor: white,
              textColor: black,
              iconColor: Colors.black12,
              width: 256,
            ),
            const SummaryCard(
              title: 'Participants',
              value: '70',
              icon: Icons.person,
              backgroundColor: white,
              textColor: black,
              iconColor: Colors.black12,
              width: 256,
            ),
            SummaryCard(
              title: 'Day left',
              value: state.remainingDaysCount.toString(),
              icon: Icons.calendar_month,
              backgroundColor: white,
              textColor: black,
              iconColor: Colors.black12,
              width: 256,
            ),
            buildButtonsCard(context, event),
          ],
        );
      },
    );
  }

  Widget _buildTextLock(String label, String value, Event event) {
    Size size = MediaQuery.of(context).size;

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: size.width / 2.2),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: TextEditingController(text: value),
              decoration: InputDecoration(
                labelText: label,
                labelStyle: const TextStyle(color: Colors.black54),
                fillColor: Colors.grey[300],
                filled: true,
                border: const OutlineInputBorder(),
                disabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
              enabled: false,
              style: const TextStyle(color: Colors.black54),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => setState(() {
              _editState[label] = true;
            }),
          ),
        ],
      ),
    );
  }

  void _updateFirebase(String label, dynamic newValue, Event event) {
    String? firestoreField = fieldMappings[label];
    if (firestoreField != null) {
      context.read<EventBloc>().add(EventUpdateFieldEvent(
            eventId: event.id,
            field: firestoreField,
            newValue: newValue,
          ));
    } else {
      debugPrint('No mapping found for field: $label');
    }
  }

  @override
  bool get wantKeepAlive => true;
}
