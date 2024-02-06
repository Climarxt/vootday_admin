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
      'Title',
      'Caption',
      'Date Event',
      'Date End',
      'Done',
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
          return buildBody(context, state.event ?? Event.empty, size);
        } else {
          return buildLoadingIndicator();
        }
      },
      listener: (BuildContext context, EventState state) {},
    );
  }

  Widget buildBody(BuildContext context, Event event, Size size) {
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
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _buildDetailListLock(event),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _buildDetailListDate(event),
              ),
            ],
          ),
        ),
        const SizedBox(width: kDefaultPadding),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _buildDetailList(event),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildDetailListLock(Event event) {
    final details = {
      'ID': event.id,
      'Author': event.author.author,
      'Participants': event.participants.toString(),
      'Date': event.date.toString(),
    };

    final entries = details.entries;

    return entries
        .map((e) => buildTextFullLock(e.key, e.value))
        .expand((widget) => [widget, const SizedBox(height: 10)])
        .toList();
  }

  List<Widget> _buildDetailListDate(Event event) {
    final details = {
      'Date Event': event.dateEvent.toString(),
      'Date End': event.dateEnd.toString(),
    };

    final entries = details.entries;

    return entries
        .map((e) => (_editState[e.key] ?? false)
            ? _buildTextField(
                e.key, TextEditingController(text: e.value), event)
            : _buildTextLock(e.key, e.value, event))
        .expand((widget) => [widget, const SizedBox(height: 10)])
        .toList();
  }

  List<Widget> _buildDetailList(Event event) {
    final details = {
      'Title': event.title,
      'Caption': event.caption,
      'Tags': event.tags.toString(),
      'Done': event.done.toString(),
      'ImageUrl': event.imageUrl.toString(),
    };

    final entries = details.entries;

    return entries
        .map((e) => (_editState[e.key] ?? false)
            ? _buildTextField(
                e.key, TextEditingController(text: e.value), event)
            : _buildTextLock(e.key, e.value, event))
        .expand((widget) => [widget, const SizedBox(height: 10)])
        .toList();
  }

  Widget _buildTextField(
      String label, TextEditingController controller, Event event) {
    Size size = MediaQuery.of(context).size;

    // Si le champ est "Done", utilisez un Checkbox au lieu d'un champ TextField
    if (label == 'Done') {
      return Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: size.width / 2.4),
              child: DropdownButtonFormField<bool>(
                value: event.done,
                onChanged: (value) {
                  setState(() {
                    _editState[label] = false;
                    _updateFirebase(label, value, event);
                  });
                },
                items: const [
                  DropdownMenuItem<bool>(
                    value: true,
                    child: Text('true'),
                  ),
                  DropdownMenuItem<bool>(
                    value: false,
                    child: Text('false'),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => setState(() {
              _editState[label] = false;
            }),
          ),
        ],
      );
    } else {
      // Pour les autres champs, utilisez un champ TextField comme précédemment
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

  Widget buildTextFullLock(String label, String value) {
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

  void _updateFirebase(String label, dynamic newValue, Event event) {
    String? firestoreField = fieldMappings[label];
    if (firestoreField != null) {
      // Si le champ est "Tags", convertissez newValue en List<String>
      if (label == 'Tags') {
        newValue = _parseTags(newValue);
      }

      // Convertissez newValue en DateTime si le champ est lié à la date
      if (label == 'Date Event' || label == 'Date End') {
        newValue = DateTime.parse(newValue);
      }

      context.read<EventBloc>().add(EventUpdateFieldEvent(
            eventId: event.id,
            field: firestoreField,
            newValue: newValue,
          ));
    } else {
      debugPrint('Aucune correspondance trouvée pour le champ : $label');
    }
  }

  List<String> _parseTags(String newValue) {
    // Supprimer les caractères "[" et "]"
    newValue = newValue.replaceAll('[', '').replaceAll(']', '');

    // Diviser la chaîne en utilisant la virgule comme séparateur
    List<String> tagsList = newValue.split(',');

    // Retirer les espaces superflus autour de chaque tag
    tagsList = tagsList.map((tag) => tag.trim()).toList();

    return tagsList;
  }

  @override
  bool get wantKeepAlive => true;
}
