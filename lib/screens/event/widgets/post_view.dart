import 'package:vootday_admin/config/configs.dart';
import 'package:vootday_admin/models/models.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:go_router/go_router.dart';

class PostView extends StatefulWidget {
  final Post post;

  PostView({
    Key? key,
    required this.post,
  }) : super(key: key ?? ValueKey(post.id));

  @override
  // ignore: library_private_types_in_public_api
  _PostViewState createState() => _PostViewState();
}

class _PostViewState extends State<PostView>
    with
        SingleTickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<PostView> {
  bool isImageVisible = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          isImageVisible = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return AnimatedOpacity(
      opacity: isImageVisible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: isImageVisible
          ? Bounceable(
              onTap: () => _navigateToPostScreen(context),
              child: _buildPost(context),
            )
          : Container(color: white),
    );
  }

  Widget _buildPost(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 1.5,
      width: double.infinity,
      child: Stack(
        children: [
          _buildImage(widget.post.imageProvider),
          buildText(context),
        ],
      ),
    );
  }

  Widget _buildImage(CachedNetworkImageProvider imageUrl) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            image: DecorationImage(
              image: imageUrl,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.center,
              colors: [
                Colors.black.withOpacity(0.6),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildText(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 32,
          right: -1,
          child: Container(
            width: 74,
            height: 24,
            decoration: const BoxDecoration(
              color: couleurBleuClair2,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(4),
                bottomLeft: Radius.circular(4),
              ),
            ),
            child: Center(child: buildLikeCount(context)),
          ),
        ),
      ],
    );
  }

  Widget buildLikeCount(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '${widget.post.likes}',
          style: AppTextStyles.titlePost(context),
        ),
        const SizedBox(width: 2),
        const Icon(
          Icons.emoji_events,
          color: white,
          size: 14,
        ),
      ],
    );
  }

  void _navigateToPostScreen(BuildContext context) {
    final username = widget.post.author.username;
    GoRouter.of(context).push('/post/${widget.post.id}?username=$username');
  }

  void _navigateToUserScreen(BuildContext context) {
    GoRouter.of(context).push(
        '/user/${widget.post.author.id}?username=${widget.post.author.username}');
    ;
  }

  @override
  bool get wantKeepAlive => true;
}
