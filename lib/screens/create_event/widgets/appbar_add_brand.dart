import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vootday_admin/config/configs.dart';

class AppBarAddBrand extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  const AppBarAddBrand({super.key, required this.title});

  @override
  Size get preferredSize => const Size.fromHeight(62);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: const IconThemeData(color: black),
      centerTitle: true,
      title: Text(
        title!,
        style:
            Theme.of(context).textTheme.headlineMedium!.copyWith(color: black),
      ),
      toolbarHeight: 62,
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () {
          final goRouter = GoRouter.of(context);
          goRouter.go('/calendar/createevent/');
        },
      ),
    );
  }
}
