import 'package:vootday_admin/config/colors.dart';
import 'package:flutter/material.dart';

class AppTextStyles {
  static TextStyle bodyStyle(BuildContext context) {
    return Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.black);
  }

  static TextStyle bodyStyleGrey(BuildContext context) {
    return Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.grey);
  }

  static TextStyle bodySmallStyleGrey(BuildContext context) {
    return Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.grey);
  }

  static TextStyle bodySmallStyleWhite(BuildContext context) {
    return Theme.of(context)
        .textTheme
        .bodySmall!
        .copyWith(color: white, fontWeight: FontWeight.bold);
  }

  static TextStyle bodyLinkBold(BuildContext context) {
    return Theme.of(context)
        .textTheme
        .bodyLarge!
        .copyWith(color: couleurBleuClair2, fontWeight: FontWeight.bold);
  }

  static TextStyle bodyTag(BuildContext context) {
    return Theme.of(context)
        .textTheme
        .bodyLarge!
        .copyWith(color: greyDark, fontWeight: FontWeight.bold);
  }

  static TextStyle titleLargeBlackBold(BuildContext context) {
    return Theme.of(context)
        .textTheme
        .titleLarge!
        .copyWith(color: Colors.black, fontWeight: FontWeight.bold);
  }

  static TextStyle titleSmallGrey(BuildContext context) {
    return Theme.of(context).textTheme.titleSmall!.copyWith(color: greyDark);
  }

  static TextStyle titleLargeWhiteBold(BuildContext context) {
    return Theme.of(context)
        .textTheme
        .titleLarge!
        .copyWith(color: white, fontWeight: FontWeight.bold);
  }

  static TextStyle titleHeadlineMidBlackBold(BuildContext context) {
    return Theme.of(context)
        .textTheme
        .headlineMedium!
        .copyWith(color: Colors.black, fontWeight: FontWeight.bold);
  }

  static TextStyle subtitleLargeGrey(BuildContext context) {
    return Theme.of(context).textTheme.titleLarge!.copyWith(color: greyDark);
  }

  static TextStyle displaySmallBold(BuildContext context) {
    return Theme.of(context)
        .textTheme
        .displaySmall!
        .copyWith(color: Colors.black, fontWeight: FontWeight.bold);
  }

  static TextStyle titlePost(BuildContext context) {
    return Theme.of(context).textTheme.titleLarge!.copyWith(
      fontWeight: FontWeight.bold,
      color: Colors.white,
      shadows: const [
        Shadow(offset: Offset(-0.2, -0.2), color: Colors.grey),
        Shadow(offset: Offset(0.2, -0.2), color: Colors.grey),
        Shadow(offset: Offset(0.2, 0.2), color: Colors.grey),
        Shadow(offset: Offset(-0.2, 0.2), color: Colors.grey),
      ],
    );
  }
}
