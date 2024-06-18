import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vootday_admin/config/configs.dart';
import 'package:vootday_admin/models/models.dart';
import 'package:vootday_admin/screens/create_event/config.dart';
import 'package:vootday_admin/screens/create_event/cubit/create_event/create_event_cubit.dart';
import 'package:vootday_admin/screens/create_event/cubit/search_brand/search_cubit.dart';
import 'package:vootday_admin/screens/create_event/widgets/customize_widgets.dart';
import 'package:vootday_admin/screens/widgets/widgets.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({Key? key}) : super(key: key);

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final CreateEventScreenConfig _config = CreateEventScreenConfig();
  bool _showUserList = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _config.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    context.read<SearchCubit>();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.all(kDefaultPadding),
      child: Scaffold(
        floatingActionButton: _buildFloatingActionButton(context),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: CustomScrollView(
          slivers: [
            const SliverAppBar(
              expandedHeight: 126.0,
              flexibleSpace: FlexibleSpaceBar(
                title: Text('Create Event'),
              ),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: _buildBody(context, size),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, Size size) {
    return SingleChildScrollView(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3.0),
              child: _buildDetailRows(),
            ),
          ),
          const SizedBox(width: 20),
          Container(
            width: 540,
            height: 675,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Image.asset(
              'assets/images/placeholder-image.png',
              fit: BoxFit.cover,
            ),
          ),
          Spacer(), // Added spacer to push the content to the center
        ],
      ),
    );
  }

  Widget _buildDetailRows() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _buildDetailList(),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildDetailList() {
    return [
      buildTextLock(context, 'ID', generateRandomId(), _config.idController),
      buildTextLock(
          context, 'Date', DateTime.now().toString(), _config.dateController),
      buildTextField(context, 'Title', _config.titleController),
      buildDateSelector(context, 'Event Date', _config.dateEventController),
      buildDateSelector(context, 'End Date', _config.dateEndController),
      buildTextField(context, 'Tags (comma separated)', _config.tagsController),
      buildTextField(context, 'Reward', _config.rewardController),
      buildTextFieldCaption(context, 'Caption', _config.captionController),
      buildUserSearchField(context),
    ];
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    final state = context.watch<CreateEventCubit>().state;
    return FloatingActionButton.extended(
      backgroundColor: couleurBleuClair2,
      onPressed: state.status != CreateEventStatus.submitting
          ? () {
              _submitForm(context);
              Future.delayed(const Duration(milliseconds: 1000), () {
                GoRouter.of(context).replace('/upcoming');
              });
            }
          : null,
      label: Text(
        AppLocalizations.of(context)!.translate('add'),
        style: Theme.of(context)
            .textTheme
            .headlineMedium!
            .copyWith(color: Colors.white),
      ),
    );
  }

  Widget buildUserSearchField(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: size.width / 2.2),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _searchController,
              onChanged: (query) {
                setState(() {
                  _showUserList = query.isEmpty;
                });
                if (query.isNotEmpty) {
                  context.read<SearchCubit>().searchUsersBrand(query);
                }
              },
              decoration: const InputDecoration(
                labelText: 'Enter Brand',
                labelStyle: TextStyle(color: Colors.black),
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            if (_showUserList)
              BlocBuilder<SearchCubit, SearchState>(
                builder: (context, state) {
                  if (state.status == SearchStatus.loading) {
                    return const CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.transparent));
                  } else if (state.status == SearchStatus.error) {
                    return Text('Error: ${state.failure.message}');
                  } else if (state.status == SearchStatus.loaded) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: state.users.map((user) {
                        return ListTile(
                          title: Text(user.username),
                          onTap: () {
                            context.read<SearchCubit>().selectUser(user);
                            _searchController.text = user.username;
                            setState(() {
                              _showUserList = false;
                            });
                          },
                        );
                      }).toList(),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
          ],
        ),
      ),
    );
  }

  void _submitForm(BuildContext context) async {
    final newEvent = await _createNewEvent(context);
    if (newEvent != null) {
      context.read<CreateEventCubit>().createEvent(newEvent);
    } else {
      debugPrint('Aucun auteur n a été trouvé pour l utilisateur sélectionné.');
    }
  }

  Future<Event?> _createNewEvent(BuildContext context) async {
    final String id = _config.idController.text;
    final String imageUrl = _config.imageUrlController.text;
    final String caption = _config.captionController.text;
    final int participants =
        int.tryParse(_config.participantsController.text) ?? 0;
    final String title = _config.titleController.text;
    final DateTime? date = DateTime.tryParse(_config.dateController.text);
    final DateTime? dateEvent =
        DateTime.tryParse(_config.dateEventController.text);
    final DateTime? dateEnd = DateTime.tryParse(_config.dateEndController.text);
    final List<String> tags = _config.tagsController.text
        .split(',')
        .map((tag) => tag.trim())
        .toList();
    final String reward = _config.rewardController.text;
    final String logoUrl = _config.logoUrlController.text;
    final User selectedUser = context.read<SearchCubit>().state.selectedUser;

    final Brand? author = await _fetchBrandForUser(selectedUser);

    if (author != null) {
      return Event(
        id: id,
        author: author,
        imageUrl: imageUrl,
        caption: caption,
        participants: participants,
        title: title,
        date: date ?? DateTime.now(),
        dateEvent: dateEvent ?? DateTime.now(),
        dateEnd: dateEnd ?? DateTime.now(),
        tags: tags,
        reward: reward,
        logoUrl: logoUrl,
        user_ref: selectedUser,
      );
    }
    return null;
  }

  Future<Brand?> _fetchBrandForUser(User user) async {
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('brands')
          .where('author', isEqualTo: user.username)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final brandDoc = querySnapshot.docs.first;
        final brand = Brand.fromDocument(brandDoc);
        debugPrint(
            'Auteur trouvé pour l utilisateur ${user.username}: $brand DEBUG : ${brand.id}');
        return brand;
      } else {
        debugPrint('Aucun auteur trouvé pour l utilisateur ${user.username}');
        return null;
      }
    } catch (e) {
      debugPrint('Erreur lors de la recherche de l auteur : $e');
      return null;
    }
  }
}
