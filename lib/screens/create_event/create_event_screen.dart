import 'package:flutter/material.dart';
import 'package:vootday_admin/config/configs.dart';

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
    return _buildEvent(context, size);
  }

  Widget _buildEvent(BuildContext context, Size size) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // _buildHeaderSection(context, size),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3.0),
                child: _buildDetailRows(),
              ),
            ],
          ),
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
        const SizedBox(width: kDefaultPadding),
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
      _buildTextField('ID', _idController),
      _buildTextField('Author', _authorController),
      _buildTextField('Image URL', _imageUrlController),
      _buildTextField('Caption', _captionController),
      _buildTextField('Participants', _participantsController),
      _buildTextField('Title', _titleController),
      _buildTextField('Date', _dateController),
      _buildTextField('Event Date', _dateEventController),
      _buildTextField('End Date', _dateEndController),
      _buildTextField('Tags (comma separated)', _tagsController),
      _buildTextField('Reward', _rewardController),
      _buildTextField('Logo URL', _logoUrlController),
      // Ajouter des widgets pour 'done' et 'user_ref' si nécessaire
    ];
  }

  Widget _buildTextField(String label, TextEditingController controller) {
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
