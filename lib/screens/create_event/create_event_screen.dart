import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vootday_admin/config/configs.dart';
import 'package:vootday_admin/models/models.dart';
import 'package:vootday_admin/screens/create_event/cubit/create_event_cubit.dart';
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
            children: _buildDetailList(), // Première colonne
          ),
        ),
        const SizedBox(width: kDefaultPadding),
        Expanded(
            child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Card(
                child: Image.asset('assets/images/placeholder-image.png'),
              ),
            ),
            _buildTextFieldCaption('Caption', _captionController),
          ],
        )),
      ],
    );
  }

  List<Widget> _buildDetailList() {
    return [
      _buildTextLock('ID', generateRandomId(), _idController),
      _buildBrandInput(context),
      _buildTextField('Title', _titleController),
      _buildTextLock('Date', DateTime.now().toString(), _dateController),
      _buildDateSelector('Event Date', _dateEventController),
      _buildDateSelector('End Date', _dateEndController),
      _buildTextField('Tags (comma separated)', _tagsController),
      _buildTextField('Reward', _rewardController),
      // Ajouter des widgets pour 'done' et 'user_ref' si nécessaire
    ];
  }

  Widget _buildDateSelector(String label, TextEditingController controller) {
    Size size = MediaQuery.of(context).size;

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: size.width / 2.2),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: GestureDetector(
          onTap: () {
            // Afficher un sélecteur de date lorsqu'on appuie sur le champ de texte
            _selectDate(context, controller);
          },
          child: AbsorbPointer(
            child: TextFormField(
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
        ),
      ),
    );
  }

  Future<void> _selectDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        controller.text = picked.toString();
      });
    }
  }

  Widget _buildBrandInput(BuildContext context) {
    final tagCount = context
        .read<CreateEventCubit>()
        .state
        .tags
        .length; // Récupération du nombre de tags

    return ConstrainedBox(
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 2.2),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: GestureDetector(
          onTap: () => GoRouter.of(context).go('/newevent/brand',
              extra: context.read<CreateEventCubit>()),
          child: AbsorbPointer(
            child: TextField(
              controller: TextEditingController(text: 'Brand Name'),
              decoration: InputDecoration(
                labelText: 'Author ($tagCount)', // Affichage du nombre de tags
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

  Widget _buildTextField(String label, TextEditingController controller) {
    Size size = MediaQuery.of(context).size;

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: size.width / 2.2),
      child: Padding(
        padding: const EdgeInsets.all(4),
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
          ],
        ),
      ),
    );
  }

  Widget _buildTextFieldCaption(
      String label, TextEditingController controller) {
    Size size = MediaQuery.of(context).size;

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: size.width / 2.2),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: TextField(
          controller: controller,
          keyboardType:
              TextInputType.multiline, // Permettre le texte multiligne
          maxLines: null, // Permettre un nombre illimité de lignes
          decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(color: Colors.black),
            fillColor: white,
            filled: true,
            border: const OutlineInputBorder(),
          ),
        ),
      ),
    );
  }

  Widget _buildTextLock(
      String label, String value, TextEditingController controller) {
    Size size = MediaQuery.of(context).size;

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: size.width / 2.2),
      child: Padding(
        padding: const EdgeInsets.all(4),
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
          ],
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
              Future.delayed(Duration(milliseconds: 1000), () {
                GoRouter.of(context).replace('/calendar');
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

  void _submitForm(BuildContext context) {
    // Récupération des valeurs des contrôleurs
    final String id = _idController.text;
    // final String author = _authorController.text;
    final String imageUrl = _imageUrlController.text;
    final String caption = _captionController.text;
    final int participants = int.tryParse(_participantsController.text) ?? 0;
    final String title = _titleController.text;
    // Convertir les dates en DateTime
    final DateTime? date = DateTime.tryParse(_dateController.text);
    final DateTime? dateEvent = DateTime.tryParse(_dateEventController.text);
    final DateTime? dateEnd = DateTime.tryParse(_dateEndController.text);
    final List<String> tags =
        _tagsController.text.split(',').map((tag) => tag.trim()).toList();
    final String reward = _rewardController.text;
    final String logoUrl = _logoUrlController.text;

    // Création de l'objet Event
    Event newEvent = Event(
      id: id,
      author: Brand.empty.copyWith(id: '8l6QjuTGFQpgBKscLkxp'),
      imageUrl: imageUrl,
      caption: caption,
      participants: participants,
      title: title,
      date: date ?? DateTime.now(), // Utiliser une valeur par défaut si null
      dateEvent: dateEvent ?? DateTime.now(),
      dateEnd: dateEnd ?? DateTime.now(),
      tags: tags,
      reward: reward,
      logoUrl: logoUrl,
      user_ref: User.empty.copyWith(id: 'CTZ9T78S0N8Df2Bvy2dd'),
    );

    // Appel à createEvent du Cubit
    context.read<CreateEventCubit>().createEvent(newEvent);
  }
}
