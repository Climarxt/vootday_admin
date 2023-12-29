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
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(
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
                          child: Padding(
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
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  event.author.author,
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: couleurBleuClair2,
                  ),
                  onPressed: () => _navigateToEventFeed(context, event),
                  child: const Text('Show Feed'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildTextLock('ID', event.id),
            const SizedBox(height: 10),
            _buildTextLock('Author', event.author.author),
            const SizedBox(height: 10),
            _buildTextLock('Caption', event.caption),
            const SizedBox(height: 10),
            _buildTextLock('Participants', event.participants.toString()),
            const SizedBox(height: 10),
            _buildTextLock('Title', event.title),
            const SizedBox(height: 10),
            _buildTextLock('Date', event.date.toString()),
            const SizedBox(height: 10),
            _buildTextLock('Date Event', event.dateEvent.toString()),
            const SizedBox(height: 10),
            _buildTextLock('Date End', event.date.toString()),
            const SizedBox(height: 10),
            _buildTextLock('Tags', event.tags.toString()),
            const SizedBox(height: 10),
            _buildTextLock('Done', event.done.toString()),
            const SizedBox(height: 10),
            _buildTextLock('ImageUrl', event.imageUrl.toString()),
            const SizedBox(height: 10),
            _buildTextLock('LogoUrl', event.logoUrl.toString()),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black),
        fillColor: white,
        filled: true,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildTextLock(String label, String value) {
    return TextField(
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
    final encodedTitle = Uri.encodeComponent(event.title);
    final encodedLogoUrl = Uri.encodeComponent(event.logoUrl);

    GoRouter.of(context).push(
      '/feedevent/${widget.eventId}?title=$encodedTitle&logoUrl=$encodedLogoUrl',
    );
  }

  @override
  bool get wantKeepAlive => true;
}
