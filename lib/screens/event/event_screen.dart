import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vootday_admin/config/configs.dart';
import 'package:vootday_admin/models/models.dart';
import 'package:vootday_admin/repositories/repositories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vootday_admin/screens/event/bloc/blocs.dart';

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
  EventRepository eventRepository = EventRepository();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<EventBloc>(context)
        .add(EventFetchEvent(eventId: widget.eventId));
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
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderSection(context, event, size),
              const SizedBox(height: 20),
              _buildDetailRows(event),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context, Event event, Size size) {
    return Row(
      children: [
        _buildEventImageCard(event),
        const SizedBox(width: 24),
        _buildShowFeedButton(context, event),
      ],
    );
  }

  Widget _buildEventImageCard(Event event) {
    return SizedBox(
      height: 120.0,
      width: 256,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Row(
          children: [
            if (event.imageUrl.isNotEmpty)
              Image.network(
                event.imageUrl,
                fit: BoxFit.cover,
                width: 120.0,
                height: 120.0,
              ),
            Expanded(
              child: _buildEventTextInfo(context, event),
            ),
          ],
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
          const SizedBox(height: 4),
          Text(
            event.author.author,
            style: Theme.of(context).textTheme.titleSmall,
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
      child: const Text('Show Feed'),
    );
  }

  Widget _buildDetailRows(Event event) {
    // Utilisez _buildDetailList si event.done est false, sinon utilisez _buildDetailListLock
    final detailListBuilder =
        event.done ? _buildDetailListLock : _buildDetailList;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: detailListBuilder(event, true),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: detailListBuilder(event, false),
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

    final int splitIndex = details.length ~/ 2;
    final entries = isFirstColumn
        ? details.entries.take(splitIndex)
        : details.entries.skip(splitIndex);

    return entries
        .map((e) => _buildTextLock(e.key, e.value))
        .expand((widget) => [widget, const SizedBox(height: 10)])
        .toList();
  }

  List<Widget> _buildDetailList(Event event, bool isFirstColumn) {
    final details = {
      'ID': event.id,
      'Author': event.author.author,
      'LogoUrl': event.logoUrl.toString(),
      'Participants': event.participants.toString(),
      'Done': event.done.toString(),
      'Date': event.date.toString(),
      'Date Event': event.dateEvent.toString(),
      'Date End': event.date.toString(),
      'Title': event.title,
      'Tags': event.tags.toString(),
      'ImageUrl': event.imageUrl.toString(),
      'Caption': event.caption,
    };

    final int splitIndex = details.length ~/ 2;
    final entries = isFirstColumn
        ? details.entries.take(splitIndex)
        : details.entries.skip(splitIndex);

    return entries
        .map((e) {
          final isTextField = [
            'Caption',
            'Title',
            'Date Event',
            'Date End',
            'Tags',
            'ImageUrl'
          ].contains(e.key);
          return isTextField
              ? _buildTextField(e.key, TextEditingController(text: e.value))
              : _buildTextLock(e.key, e.value);
        })
        .expand((widget) => [widget, const SizedBox(height: 10)])
        .toList();
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    Size size = MediaQuery.of(context).size;

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: size.width / 2.2),
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
    );
  }

  Widget _buildTextLock(String label, String value) {
    Size size = MediaQuery.of(context).size;

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: size.width / 2.2),
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
