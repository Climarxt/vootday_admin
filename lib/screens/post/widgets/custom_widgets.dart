// ignore_for_file: use_build_context_synchronously

import 'package:vootday_admin/config/configs.dart';
import 'package:vootday_admin/models/models.dart';
import 'package:vootday_admin/screens/post/widgets/widgets.dart';
import 'package:flutter/material.dart';

Widget buildIconButton(IconData icon, VoidCallback onPressed) {
  return IconButton(
    icon: Icon(icon, color: Colors.black, size: 24),
    onPressed: onPressed,
  );
}

Widget buildActionIcons(
    BuildContext context,
    void Function(BuildContext) navigateToCommentScreen,
    String postId,
    Animation<double> animation,
    AnimationController controller) {
  return Column(
    children: [
      buildIconButton(Icons.comment, () => navigateToCommentScreen(context)),
    ],
  );
}

Widget buildUserProfile(
  User user,
  Post post,
  VoidCallback onTitleTap,
) {
  return ProfileImagePost(
    title: '${user.firstName} ${user.lastName}',
    likes: post.likes,
    profileImageProvider: user.profileImageProvider,
    description: post.caption,
    tags: post.tags,
    onTitleTap: onTitleTap,
  );
}

Widget buildPostDetails(
  BuildContext context,
  User user,
  Post post,
  VoidCallback onUserTitleTap,
  Function(BuildContext) onNavigateToCommentScreen,
  String postId,
  Animation<double> animation,
  AnimationController controller,
) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 18),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            buildUserProfile(user, post, onUserTitleTap),
          ],
        ),
        const Spacer(),
        buildActionIcons(
          context,
          onNavigateToCommentScreen,
          postId,
          animation,
          controller,
        ),
      ],
    ),
  );
}

Widget buildPostImage(
  Size size,
  Post post,
) {
  return ImageLoader(
    imageProvider: post.imageProvider,
    width: size.width,
    height: size.height / 1.5,
  );
}

Container buildImageContainer(
  Size size,
  Post post,
) {
  const double imageContainerFractionWidth = 0.2;
  const double imageContainerFractionHeight = 0.15;

  return Container(
    width: size.width * imageContainerFractionWidth,
    height: size.height * imageContainerFractionHeight,
    decoration: BoxDecoration(
      color: greyDark,
      borderRadius: BorderRadius.circular(10),
      image: DecorationImage(
        image: post.imageProvider,
        fit: BoxFit.cover,
      ),
    ),
  );
}

Column buildTextColumn(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Enregistré dans mes Likes',
        style: AppTextStyles.titleHeadlineMidBlackBold(context),
      ),
      Text(
        'Privé',
        style: AppTextStyles.subtitleLargeGrey(context),
      ),
    ],
  );
}
