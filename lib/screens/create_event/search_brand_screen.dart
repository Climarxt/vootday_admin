// Importing necessary packages and modules
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:vootday_admin/config/configs.dart';
import 'package:vootday_admin/cubit/brands/brands_state.dart';
import 'package:vootday_admin/cubit/cubits.dart';
import 'package:vootday_admin/models/models.dart';
import 'package:vootday_admin/screens/create_event/cubit/create_event/create_event_cubit.dart';
import 'package:vootday_admin/screens/create_event/widgets/widgets.dart';

// Main screen for brand searching
class BrandSearchScreen extends StatefulWidget {
  const BrandSearchScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BrandSearchScreenState createState() => _BrandSearchScreenState();
}

class _BrandSearchScreenState extends State<BrandSearchScreen> {
  // Controller for autocomplete text field
  TextEditingController _tagAutocompleteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Fetch all brands when the screen is initialized
    context.read<BrandCubit>().fetchBrands();
  }

  @override
  Widget build(BuildContext context) {
    // BlocBuilder listens for changes in BrandState
    return BlocBuilder<BrandCubit, BrandState>(
      builder: (context, brandState) {
        return Scaffold(
          appBar: AppBarAddBrand(
              title: AppLocalizations.of(context)!.translate('brand')),
          // FloatingActionButton to validate and proceed
          floatingActionButton: _buildFloatingActionButton(context),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          // The main body of the screen
          body: BlocBuilder<CreateEventCubit, CreateEventState>(
            builder: (context, createPostState) {
              // Build the main content of the screen
              return _buildBody(context, createPostState, brandState.brands);
            },
          ),
        );
      },
    );
  }

  // Builds the main content of the screen
  Widget _buildBody(BuildContext context, CreateEventState createPostState,
      List<Brand> brands) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Autocomplete search bar for brands
          _buildAutoComplete(context, brands),
          const SizedBox(height: 6.0),
          // Displays the list of selected tags
          _buildTagList(context, createPostState),
        ],
      ),
    );
  }

  // Builds the autocomplete search bar for brands
  Widget _buildAutoComplete(BuildContext context, List<Brand> brands) {
    return Autocomplete<String>(
      // Options for the autocomplete
      optionsBuilder: (TextEditingValue textEditingValue) {
        return _buildMatchingTags(textEditingValue, brands);
      },
      // UI for showing options
      optionsViewBuilder: (BuildContext context,
          AutocompleteOnSelected<String> onSelected, Iterable<String> options) {
        return _buildOptionsView(context, onSelected, options, brands);
      },
      // Handling selected option
      onSelected: (tag) => _handleTagSelected(context, tag),
      // Builds the input text field for autocomplete
      fieldViewBuilder: (BuildContext context,
          TextEditingController textEditingController,
          FocusNode focusNode,
          VoidCallback onFieldSubmitted) {
        return _buildTextField(
            context, textEditingController, focusNode, onFieldSubmitted);
      },
    );
  }

  // Finds matching tags for the autocomplete
  Iterable<String> _buildMatchingTags(
      TextEditingValue textEditingValue, List<Brand> brands) {
    if (textEditingValue.text == '') {
      return const Iterable.empty();
    }

    // Convert the list of Brand objects to a list of brand names
    List<String> brandNames = brands.map((brand) => brand.author).toList();

    // Find matching brand names
    var matchingTags =
        brandNames.where((tag) => tag.contains(textEditingValue.text));

    if (!matchingTags.contains(textEditingValue.text)) {
      matchingTags = matchingTags.followedBy([textEditingValue.text]);
    }

    return matchingTags;
  }

  // UI for showing the options for autocomplete
  Widget _buildOptionsView(
      BuildContext context,
      AutocompleteOnSelected<String> onSelected,
      Iterable<String> options,
      List<Brand> brands) {
    return Align(
      alignment: Alignment.topLeft,
      child: Material(
        elevation: 0,
        child: Container(
          color: white,
          child: ListView(
            padding: const EdgeInsets.all(8.0),
            children: options
                .map((String option) =>
                    _buildOption(context, onSelected, option, brands))
                .toList(),
          ),
        ),
      ),
    );
  }

  // Builds individual option for autocomplete
  Widget _buildOption(
      BuildContext context,
      AutocompleteOnSelected<String> onSelected,
      String option,
      List<Brand> brands) {
    // Find the brand object that matches the selected option
    final brand = brands.firstWhere((b) => b.author == option,
        orElse: () => Brand(
            author: option,
            logoUrl:
                'https://firebasestorage.googleapis.com/v0/b/bootdv2.appspot.com/o/images%2Fbrands%2Fquestionmarklogo.svg?alt=media&token=0803c330-d49c-4808-ba80-80f1e6258897&_gl=1*111mjg0*_ga*NzczMDE3MDE2LjE2OTcwMzM5MTE.*_ga_CW55HF8NVT*MTY5ODM0ODMxMS4yMC4xLjE2OTgzNDkxMDUuMzkuMC4w'));

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: ListTile(
        leading: CircleAvatar(
          radius: 24,
          child: ClipOval(
            child: SvgPicture.network(
              brand.logoUrl,
              height: 48,
              width: 48,
            ),
          ),
        ),
        title: Text(option),
        onTap: () => onSelected(option),
      ),
    );
  }

  // Handle the event when a tag is selected
  void _handleTagSelected(BuildContext context, String tag) {
    // Add the selected tag to the CreatePostCubit
    context.read<CreateEventCubit>().addTag(tag);
    // Clear the autocomplete text field
    _tagAutocompleteController.clear();
  }

  // Builds the text field for autocomplete
  Widget _buildTextField(
      BuildContext context,
      TextEditingController textEditingController,
      FocusNode focusNode,
      VoidCallback onFieldSubmitted) {
    _tagAutocompleteController = textEditingController;
    return TextField(
      cursorColor: couleurBleuClair2,
      controller: _tagAutocompleteController,
      focusNode: focusNode,
      style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: black),
      decoration: InputDecoration(
        border: InputBorder.none,
        hintStyle:
            Theme.of(context).textTheme.headlineMedium!.copyWith(color: grey),
        hintText: AppLocalizations.of(context)!.translate('searchbrands'),
      ),
      onSubmitted: (String value) => onFieldSubmitted(),
    );
  }

  // Builds the list of selected tags
  Widget _buildTagList(BuildContext context, CreateEventState state) {
    return SizedBox(
      height: 32.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: state.tags.length,
        itemBuilder: (context, index) =>
            _buildTagChip(context, state.tags[index]),
      ),
    );
  }

  // Builds individual tag chip
  Widget _buildTagChip(BuildContext context, String tag) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: RawChip(
        backgroundColor: grey,
        label: Text(
          tag,
          style: Theme.of(context)
              .textTheme
              .headlineMedium!
              .copyWith(color: black),
        ),
        onPressed: () => context.read<CreateEventCubit>().removeTag(tag),
      ),
    );
  }

  // Builds the floating action button
  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton.extended(
      backgroundColor: couleurBleuClair2,
      onPressed: () => _handlePostButtonPressed(context),
      label: Text(
        AppLocalizations.of(context)!.translate('validate'),
        style: Theme.of(context)
            .textTheme
            .headlineMedium!
            .copyWith(color: Colors.white),
      ),
    );
  }

  // Handling the click of the floating action button
  void _handlePostButtonPressed(BuildContext context) {
    final goRouter = GoRouter.of(context);
    goRouter.go('/newevent');
  }
}
