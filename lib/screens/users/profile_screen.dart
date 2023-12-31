import 'package:vootday_admin/config/configs.dart';
import 'package:vootday_admin/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vootday_admin/screens/users/bloc/profile/profile_bloc.dart';
import 'package:vootday_admin/screens/users/bloc/profile_stats/profile_stats_bloc.dart';
import 'package:vootday_admin/screens/users/config/constants.dart';
import 'package:vootday_admin/screens/users/widgets/widgets.dart';
import 'package:vootday_admin/screens/widgets/widgets.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;

  const ProfileScreen({
    super.key,
    required this.userId,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with AutomaticKeepAliveClientMixin {
  Map<String, bool> _editState = {};
  int totalLikes = 0;

  @override
  void initState() {
    super.initState();
    context
        .read<ProfileStatsBloc>()
        .add(ProfileStatsPostFetchEvent(userId: widget.userId));
    context
        .read<ProfileStatsBloc>()
        .add(ProfileStatsCollectionFetchEvent(userId: widget.userId));
    context
        .read<ProfileStatsBloc>()
        .add(ProfileStatsLikesFetchEvent(userId: widget.userId));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context
            .read<ProfileBloc>()
            .add(ProfileFetchProfile(userId: widget.userId));
      }
    });

    for (var detail in [
      'username',
      'email',
      'firstName',
      'lastName',
      'profileImageUrl',
      'location',
      'bio',
      'selectedGender',
      'username_lowercase',
    ]) {
      _editState[detail] = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    super.build(context);
    return BlocConsumer<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state.status == ProfileStatus.loading) {
          return buildLoadingIndicator();
        } else if (state.status == ProfileStatus.loaded) {
          return _buildBody(context, state.user, size);
        } else {
          return buildLoadingIndicator();
        }
      },
      listener: (BuildContext context, ProfileState state) {},
    );
  }

  Widget _buildBody(BuildContext context, User user, Size size) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderSection(context, user, size),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3.0),
                child: _buildDetailRows(user),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context, User user, Size size) {
    return BlocConsumer<ProfileStatsBloc, ProfileStatsState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Wrap(
          direction: Axis.horizontal,
          spacing: kDefaultPadding,
          runSpacing: kDefaultPadding,
          children: [
            SummaryCard(
              title: '${user.firstName} ${user.lastName}',
              value: user.username,
              icon: Icons.abc,
              backgroundColor: white,
              textColor: black,
              iconColor: Colors.black12,
              width: 256,
            ),
            SummaryCard(
              title: 'OOTD',
              value: state.postCount.toString(),
              icon: Icons.ssid_chart_rounded,
              backgroundColor: white,
              textColor: black,
              iconColor: Colors.black12,
              width: 256,
            ),
            const SummaryCard(
              title: '',
              value: '',
              icon: Icons.ssid_chart_rounded,
              backgroundColor: white,
              textColor: black,
              iconColor: Colors.black12,
              width: 256,
            ),
            SummaryCard(
              title: '',
              value: '',
              icon: Icons.ssid_chart_rounded,
              backgroundColor: white,
              textColor: black,
              iconColor: Colors.black12,
              width: 256,
            ),
            buildButtonsCard(),
          ],
        );
      },
    );
  }

  Widget _buildDetailRows(User user) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _buildDetailListLock(user, true),
          ),
        ),
        const SizedBox(width: kDefaultPadding),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _buildDetailListLock(user, false),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildDetailListLock(User user, bool isFirstColumn) {
    final details = {
      'id': user.id,
      'username': user.username,
      'email': user.email,
      'firstName': user.firstName,
      'lastName': user.lastName,
      'profileImageUrl': user.profileImageUrl,
      'location': user.location,
      'followers': user.followers.toString(),
      'following': user.following.toString(),
      'bio': user.bio,
      'selectedGender': user.selectedGender,
      'username_lowercase': user.username_lowercase,
    };

    final editableDetails = {
      'username',
      'email',
      'firstName',
      'lastName',
      'profileImageUrl',
      'location',
      'bio',
      'selectedGender',
      'username_lowercase',
    };

    final int splitIndex = details.length ~/ 2;
    final entries = isFirstColumn
        ? details.entries.take(splitIndex)
        : details.entries.skip(splitIndex);

    return entries
        .map((e) => editableDetails.contains(e.key) &&
                (_editState[e.key] ?? false)
            ? _buildTextField(e.key, TextEditingController(text: e.value), user)
            : _buildTextLock(e.key, e.value, user))
        .expand((widget) => [widget, const SizedBox(height: 10)])
        .toList();
  }

  Widget _buildTextField(
      String label, TextEditingController controller, User user) {
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
            icon: const Icon(Icons.check),
            onPressed: () {
              setState(() {
                _editState[label] = false;
                _updateFirebase(label, controller.text, user);
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => setState(() {
              _editState[label] = false;
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildTextLock(String label, String value, User user) {
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

  void _updateFirebase(String label, dynamic newValue, User user) {
    String? firestoreField = fieldMappings[label];
    if (firestoreField != null) {
      context.read<ProfileBloc>().add(ProfileUpdateFieldProfile(
            userId: user.id,
            field: firestoreField,
            newValue: newValue,
          ));
    } else {
      debugPrint('No mapping found for field: $label');
    }
  }

  @override
  bool get wantKeepAlive => true;
}
