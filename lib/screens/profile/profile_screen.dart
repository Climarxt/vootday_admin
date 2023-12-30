import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vootday_admin/screens/users/bloc/profile/profile_bloc.dart';
import 'package:vootday_admin/screens/users/listview_users.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(ProfileLoadAllUsers());
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            Container(width: size.width, height: 200, child: DataPage()),
          ],
        ));
  }
}
