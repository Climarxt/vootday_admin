import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vootday_admin/config/configs.dart';
import 'package:vootday_admin/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vootday_admin/screens/event/bloc/blocs.dart';
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
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Map<String, bool> _editState = {};

  @override
  void initState() {
    super.initState();
    BlocProvider.of<EventBloc>(context)
        .add(EventFetchEvent(eventId: widget.eventId));
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
    return BlocBuilder<EventBloc, EventState>(
      builder: (context, state) {
        if (state.status == EventStatus.loading) {
          return _buildLoadingIndicator();
        } else if (state.status == EventStatus.loaded) {
          return _buildEvent(context, state.event ?? Event.empty, size);
        } else {
          return _buildLoadingIndicator();
        }
      },
    );
  }

  Widget _buildEvent(BuildContext context, Event event, Size size) {
    return Container(
      color: webBackgroundColor,
      child: SingleChildScrollView(
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
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context, Event event, Size size) {
    return Wrap(
      direction: Axis.horizontal,
      spacing: kDefaultPadding,
      runSpacing: kDefaultPadding,
      children: [
        _buildEventImageCard(event),
        const SummaryCard(
          title: 'Likes',
          value: '523',
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
        const SummaryCard(
          title: 'Day left',
          value: '7',
          icon: Icons.calendar_month,
          backgroundColor: white,
          textColor: black,
          iconColor: Colors.black12,
          width: 256,
        ),
        _buildButtonsCard(event),
      ],
    );
  }

  Widget _buildButtonsCard(Event event) {
    return SizedBox(
      height: 120.0,
      width: 244,
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
                    _buildStatsButton(context, event),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildImportButton(context, event),
                    _buildExportButton(context, event),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEventImageCard(Event event) {
    return SizedBox(
      height: 120.0,
      width: 256,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(kDefaultPadding),
          child: Row(
            children: [
              Expanded(
                child: _buildEventTextInfo(context, event),
              ),
              if (event.imageUrl.isNotEmpty)
                SvgPicture.network(
                  event.logoUrl,
                  fit: BoxFit.cover,
                  width: 100.0,
                  height: 100.0,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEventTextInfo(BuildContext context, Event event) {
    return Padding(
      padding: const EdgeInsets.all(kDefaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            event.title,
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildShowFeedButton(BuildContext context, Event event) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: couleurBleuClair2,
      ),
      onPressed: () => _navigateToEventFeed(context, event),
      child: const Text('Feed'),
    );
  }

  Widget _buildStatsButton(BuildContext context, Event event) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: couleurBleuClair2,
      ),
      onPressed: () => _navigateToEventFeed(context, event),
      child: const Text('Stats'),
    );
  }

  Widget _buildImportButton(BuildContext context, Event event) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: couleurBleuClair2,
      ),
      onPressed: () => _navigateToEventFeed(context, event),
      child: const Text('Import'),
    );
  }

  Widget _buildExportButton(BuildContext context, Event event) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: couleurBleuClair2,
      ),
      onPressed: () => _navigateToEventFeed(context, event),
      child: const Text('Export'),
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
        SizedBox(
          width: kDefaultPadding,
        ),
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
      'Date End': event.date.toString(),
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
            icon: Icon(Icons.check),
            onPressed: () {
              setState(() {
                _editState[label] = false;
                _updateFirebase(
                    label, controller.text, event); // Mettre à jour Firebase
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () => setState(() {
              _editState[label] = false;
            }),
          ),
        ],
      ),
    );
  }

  void _updateFirebase(String label, String newValue, Event event) {
    // Identifier le champ à mettre à jour et créer une nouvelle instance de l'événement
    Event updatedEvent;
    switch (label) {
      case 'Caption':
        updatedEvent = event.copyWith(caption: newValue);
        break;
      case 'Title':
        updatedEvent = event.copyWith(title: newValue);
        break;
      // Ajoutez des cas pour d'autres champs modifiables
      default:
        debugPrint("Champ non reconnu pour la mise à jour : $label");
        return;
    }

    // Convertir l'événement mis à jour en document Firestore
    Map<String, dynamic> updatedData = updatedEvent.toDocument();

    // Mise à jour de l'événement dans Firestore
    _firebaseFirestore
        .collection('events')
        .doc(event.id)
        .update(updatedData)
        .then((_) => debugPrint(
            "_updateFirebase : Événement mis à jour avec succès dans Firestore."))
        .catchError((error) => debugPrint(
            "_updateFirebase : Erreur lors de la mise à jour de l'événement : $error"));
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
            icon: Icon(Icons.edit),
            onPressed: () => setState(() {
              _editState[label] = true;
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(
        child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.transparent)));
  }

  Future<String> getMostLikedPostImageUrl(String eventId) async {
    try {
      final feedEventRef = FirebaseFirestore.instance
          .collection('events')
          .doc(eventId)
          .collection('feed_event');

      final querySnapshot =
          await feedEventRef.orderBy('likes', descending: true).limit(1).get();

      if (querySnapshot.docs.isNotEmpty) {
        final data = querySnapshot.docs.first.data() as Map<String, dynamic>?;
        final DocumentReference? postRef =
            data?['post_ref'] as DocumentReference?;

        if (postRef != null) {
          final postDoc = await postRef.get();

          if (postDoc.exists) {
            final postData =
                postDoc.data() as Map<String, dynamic>?; // Cast as a map
            return postData?['imageUrl'] as String? ?? ''; // Use the map
          } else {
            debugPrint(
                "HomeEvent - getMostLikedPostImageUrl : Referenced post document does not exist.");
          }
        } else {
          debugPrint(
              "HomeEvent - getMostLikedPostImageUrl : Post reference is null.");
        }
      }
    } catch (e) {
      debugPrint(
          "HomeEvent - getMostLikedPostImageUrl : An error occurred while fetching the most liked post image URL: $e");
    }
    return '';
  }

  void _navigateToEventFeed(BuildContext context, Event event) {
    GoRouter.of(context).go(
      '/calendar/event/${widget.eventId}/feedevent',
    );
  }

  @override
  bool get wantKeepAlive => true;
}
