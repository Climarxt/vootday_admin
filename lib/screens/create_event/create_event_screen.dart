import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vootday_admin/config/configs.dart';
import 'package:vootday_admin/models/models.dart';
import 'package:vootday_admin/screens/event/bloc/blocs.dart';
import 'package:vootday_admin/screens/widgets/widgets.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({
    super.key,
  });

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _captionController = TextEditingController();
  final TextEditingController _participantsController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _dateEventController = TextEditingController();
  final TextEditingController _dateEndController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();
  final TextEditingController _rewardController = TextEditingController();
  final TextEditingController _logoUrlController = TextEditingController();

  @override
  void dispose() {
    // Nettoyage des controllers lors de la suppression du State
    _idController.dispose();
    _authorController.dispose();
    _imageUrlController.dispose();
    _captionController.dispose();
    _participantsController.dispose();
    _titleController.dispose();
    _dateController.dispose();
    _dateEventController.dispose();
    _dateEndController.dispose();
    _tagsController.dispose();
    _rewardController.dispose();
    _logoUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocConsumer<EventBloc, EventState>(
      builder: (context, state) {
        if (state.status == EventStatus.loading) {
          return buildLoadingIndicator();
        } else if (state.status == EventStatus.loaded) {
          return _buildEvent(context, state.event ?? Event.empty, size);
        } else {
          return buildLoadingIndicator();
        }
      },
      listener: (BuildContext context, EventState state) {},
    );
  }

  Widget _buildEvent(BuildContext context, Event event, Size size) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // _buildHeaderSection(context, event, size),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3.0),
                child: _buildDetailRows(event),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRows(Event event) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _buildDetailList(event),
          ),
        ),
        const SizedBox(width: kDefaultPadding),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _buildDetailList(event),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildDetailList(Event event) {
    return [
      _buildTextField('ID', _idController, event),
      _buildTextField('Author', _authorController, event),
      _buildTextField('Image URL', _imageUrlController, event),
      _buildTextField('Caption', _captionController, event),
      _buildTextField('Participants', _participantsController, event),
      _buildTextField('Title', _titleController, event),
      _buildTextField('Date', _dateController, event),
      _buildTextField('Event Date', _dateEventController, event),
      _buildTextField('End Date', _dateEndController, event),
      _buildTextField('Tags (comma separated)', _tagsController, event),
      _buildTextField('Reward', _rewardController, event),
      _buildTextField('Logo URL', _logoUrlController, event),
      // Ajouter des widgets pour 'done' et 'user_ref' si nécessaire
    ];
  }

  Widget _buildTextField(
      String label, TextEditingController controller, Event event) {
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
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
