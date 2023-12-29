// ignore_for_file: use_build_context_synchronously, no_leading_underscores_for_local_identifiers
import 'package:vootday_admin/config/configs.dart';
import 'package:vootday_admin/models/models.dart';
import 'package:vootday_admin/repositories/repositories.dart';
import 'package:vootday_admin/screens/post/widgets/custom_widgets.dart';
import 'package:vootday_admin/screens/post/widgets/widgets.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class PostScreen extends StatefulWidget {
  final String postId;
  final String fromPath;

  const PostScreen({
    super.key,
    required this.postId,
    required this.fromPath,
  });

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen>
    with SingleTickerProviderStateMixin {
  Post? _post;
  User? _user;
  bool _isLoading = true;
  ValueNotifier<bool> isPublicNotifier = ValueNotifier(true);

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _loadPost();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 1, end: 1.5)
        .chain(CurveTween(curve: Curves.elasticOut))
        .animate(_controller);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: Opacity(
            opacity: 0.0,
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    if (_post == null || _user == null) {
      return Scaffold(
        appBar: AppBarTitle(title: _user!.username),
        body: const Center(child: Text('Post or user not found')),
      );
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBarTitle(title: _user!.username),
        body: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: size.height),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildPostImage(size, _post!),
                buildPostDetails(
                  context,
                  _user!,
                  _post!,
                  () => _navigateToUserScreen(context, _user!),
                  _navigateToCommentScreen,
                  widget.postId,
                  _animation,
                  _controller,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _loadPost() async {
    try {
      final post =
          await context.read<PostRepository>().getPostById(widget.postId);
      if (post != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection(Paths.users)
            .doc(post.author.id)
            .get();
        if (userDoc.exists) {
          setState(() {
            _post = post;
            _user = User.fromDocument(userDoc);
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _navigateToUserScreen(BuildContext context, User user) {
    context.push('/user/${user.id}');
  }

  void _navigateToCommentScreen(BuildContext context) {
    context.push('/post/${widget.postId}/comment?postId=${widget.postId}');
  }
}
