// ignore_for_file: avoid_print, unrelated_type_equality_checks
import 'package:vootday_admin/config/configs.dart';
import 'package:vootday_admin/models/models.dart';
import 'package:vootday_admin/screens/event/bloc/blocs.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vootday_admin/screens/event/widgets/widgets.dart';

class FeedEvent extends StatefulWidget {
  final String eventId;
  final String title;
  final String logoUrl;
  const FeedEvent({
    super.key,
    required this.eventId,
    required this.title,
    required this.logoUrl,
  });

  @override
  // ignore: library_private_types_in_public_api
  _FeedEventState createState() => _FeedEventState();
}

class _FeedEventState extends State<FeedEvent>
    with AutomaticKeepAliveClientMixin<FeedEvent> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<FeedEventBloc, FeedEventState>(
      builder: (context, state) {
        final feedEventBloc = context.read<FeedEventBloc>();
        if (!feedEventBloc.state.hasFetchedInitialPosts ||
            feedEventBloc.state.posts.isEmpty) {
          feedEventBloc.add(FeedEventFetchPostsEvents(eventId: widget.eventId));
        }
        return Padding(
          padding: const EdgeInsets.all(kDefaultPadding),
          child: Scaffold(
            body: _buildBody(state),
          ),
        );
      },
    );
  }

  Widget _buildBody(FeedEventState state) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 1 / 1.2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      physics: const BouncingScrollPhysics(),
      cacheExtent: 10000,
      itemCount: state.posts.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if (index == state.posts.length) {
          return state.status == FeedEventStatus.paginating
              ? const Center(child: CircularProgressIndicator())
              : const SizedBox.shrink();
        } else {
          final Post post = state.posts[index] ?? Post.empty;
          return PostView(
            post: post,
          );
        }
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
