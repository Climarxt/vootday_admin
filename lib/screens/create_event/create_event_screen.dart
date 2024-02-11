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
    return BlocConsumer<CreateEventCubit, CreateEventState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          floatingActionButton: _buildFloatingActionButton(context),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          body: _buildBody(context, size),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, Size size) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3.0),
              child: _buildDetailRows(),
            ),
          ],
        ),
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

  Widget buildBrandInput(BuildContext context) {
    final int tagCount = context.read<CreateEventCubit>().state.tags.length;

    return ConstrainedBox(
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 2.2),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: GestureDetector(
          onTap: () => GoRouter.of(context)
              .go('/newevent/brand', extra: context.read<CreateEventCubit>()),
          child: AbsorbPointer(
            child: TextField(
              controller: TextEditingController(text: 'Brand Name'),
              decoration: InputDecoration(
                labelText: 'Author ($tagCount)',
                labelStyle: const TextStyle(color: Colors.black),
                fillColor: white,
                filled: true,
                border: const OutlineInputBorder(),
                suffixIcon: const Icon(Icons.arrow_forward),
              ),
            ),
          ),
        ),
      ),
    );
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(4),
          child: TextField(
            controller: _searchController,
            onChanged: (query) {
              if (query.isEmpty) {
                // Si le champ de recherche est vide, réinitialiser la liste déroulante
                setState(() {
                  _showUserList = true;
                });
              } else {
                // Sinon, effectuer la recherche normalement
                context.read<SearchCubit>().searchUsersBrand(query);
              }
            },
            decoration: const InputDecoration(
              labelText: 'Enter Brand',
              labelStyle: TextStyle(color: Colors.black),
              fillColor: white,
              filled: true,
              border: OutlineInputBorder(),
            ),
          ),
        ),
        const SizedBox(height: 10),
        // Utilisez la variable _showUserList pour contrôler l'affichage de la liste
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
                        // Mettre à jour le champ selectedUser dans SearchCubit
                        context.read<SearchCubit>().selectUser(user);
                        // Mettre à jour la valeur du champ de recherche avec l'username sélectionné
                        _searchController.text = user.username;
                        // Masquer la liste déroulante après la sélection de l'utilisateur
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
    );
  }

  void _submitForm(BuildContext context) {
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

    final newEvent = Event(
      id: id,
      author: Brand.empty.copyWith(id: '8l6QjuTGFQpgBKscLkxp'),
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

    context.read<CreateEventCubit>().createEvent(newEvent);
  }
}
